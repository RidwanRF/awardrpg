
-- ==========     Работа с пользователем     ==========
function openWindow(playerSource)
	triggerClientEvent(playerSource, "toggleNickLoginWindow", resourceRoot)
end
addCommandHandler("nicklogin", openWindow, true, false)

function isAdmin(player)
	return hasObjectPermissionTo(player, "command.nicklogin", false)
end

function hasBanPanelAccess(player)
	return hasObjectPermissionTo(player, "command.banpanel", false)
end

addEvent("getList", true)
addEventHandler("getList", resourceRoot, function(text, options)
	if (not isAdmin(client)) then return end
	
	local column = convertSearchToColumn(options.searchType, options.Table)
	if (not column) then return end
	local tableName = options.Table
	local timeFrom = getTimeFromTable(options.timeFrom)
	local timeTo = getTimeFromTable(options.timeTo)
	
	local conditions = {}
	local args = {}
	if (options.wildcard) then
		table.insert(conditions, "`??` LIKE '%??%'")
	else
		table.insert(conditions, "`??` = ?")
	end
	table.insert(args, column)
	table.insert(args, text)
	if (timeFrom) then
		table.insert(conditions, "`date` >= ?")
		table.insert(args, timeFrom)
	end
	if (timeTo) then
		table.insert(conditions, "`date` <= ?")
		table.insert(args, timeTo)
	end
	
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("sendListCallback", {player=client}, tableName, "SELECT * FROM ?? WHERE "..table.concat(conditions, " AND ").." ORDER BY `date` DESC LIMIT 300;", unpack(args))
	else
		triggerClientEvent(client, "catchList", resourceRoot, {})
		outputDebugString("[NICKLOGIN][WARNING] Cannot getList - mysql is not active", 2)
	end
end)
function sendListCallback(result, args)
	if not isElement(args.player) then return end
	local accs, serials = {}, {}
	for _, row in ipairs(result) do
		accs[row.login] = true
		serials[row.serial] = true
	end
	local banned = isResourceRunning("login") and exports.login:getBannedLoginsFromTable(accs, serials) or {}
	triggerClientEvent(args.player, "catchList", resourceRoot, result, hasBanPanelAccess(args.player), banned)
end

-- Перобразовать название таблицы, пришедшее с клиента
function convertSearchToColumn(column, Table)
	local allowed
	if (Table == "successful") then
		allowed = {
			nick = "nickShort",
			login = "login",
			lastEvent = "action",
			serial = "serial",
			ip = "ip",
		}
	elseif (Table == "actions") then
		allowed = {
			nick = "nickShort",
			login = "login",
			lastEvent = "reason",
			serial = "serial",
			ip = "ip",
		}
	end
	return (allowed) and (allowed[column])
end

-- Получить строку времени для использования в MySQL
function getTimeFromTable(dateTable)
	if (type(dateTable) ~= "table") then return false end
	dateTable = tonumberAllPairs(dateTable)
	if (dateTable.year) and (dateTable.month) and (dateTable.day) and(dateTable.hour) and (dateTable.min) and (dateTable.sec) then
		return string.format("%04i-%02i-%02i %02i:%02i:%02i", dateTable.year, dateTable.month, dateTable.day, dateTable.hour, dateTable.min, dateTable.sec)
	else
		return false
	end
end

-- Применить tonumber для всех записей в таблице
function tonumberAllPairs(Table)
	local newTable = {}
	for index, value in pairs(Table) do
		newTable[index] = tonumber(value)
	end
	return newTable
end


-- ==========     Работа с БД     ==========
addEventHandler("onResourceStart", resourceRoot, function()
	exports.mysql:dbExec("dbData", "CREATE TABLE IF NOT EXISTS ?? (`key` VARCHAR(255) NOT NULL PRIMARY KEY, `value` VARCHAR(255)) COLLATE=utf8_unicode_ci;")
	exports.mysql:dbExec("successful", [[CREATE TABLE IF NOT EXISTS ?? (
		`nickShort` VARCHAR(22), `login` VARCHAR(255), `hits` MEDIUMINT UNSIGNED, `date` TIMESTAMP, `action` VARCHAR(255),
		`serial` CHAR(32), `nick` VARCHAR(22), `timestamp` INT UNSIGNED, `ip` CHAR(15),
		PRIMARY KEY(nickShort, login, serial, ip)
		) COLLATE=utf8_unicode_ci;
	]])
	exports.mysql:dbExec("actions", [[CREATE TABLE IF NOT EXISTS ?? (
		`nickShort` VARCHAR(22), `login` VARCHAR(255), `hits` MEDIUMINT UNSIGNED, `date` TIMESTAMP, `reason` VARCHAR(255),
		`serial` CHAR(32), `nick` VARCHAR(22), `timestamp` INT UNSIGNED, `ip` CHAR(15),
		PRIMARY KEY(nickShort, login, serial, ip, reason)
		) COLLATE=utf8_unicode_ci;
	]])
	
	--[[
	if not getDBversion() then
		initializeDB()
	end
	]]
end)

addEvent("dbCallback", false)
addEventHandler("dbCallback", resourceRoot, function(queryResult, callbackFunctionName, callbackArguments)
	_G[callbackFunctionName](queryResult, callbackArguments)
end)

function onPlayerLogin(_, theCurrentAccount)
	local name = getPlayerName(source)
	local timestamp = getRealTime().timestamp
	exports.mysql:dbExec("successful", [[INSERT INTO ?? (`nickShort`, `nick`, `login`, `hits`, `date`, `timestamp`, `serial`, `ip`, `action`)
		VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?) ON DUPLICATE KEY UPDATE `nick`=?, `hits`=`hits`+1, `date`=NOW(), `timestamp`=?, `action`=?;]],
		removeColorCodes(name), name, getAccountName(theCurrentAccount), 1, timestamp, getPlayerSerial(source), getPlayerIP(source), "Login",
		name, timestamp, "Login"
	)
end
addEventHandler("onPlayerLogin", root, onPlayerLogin)

function onPlayerQuit()
	local name = getPlayerName(source)
	local timestamp = getRealTime().timestamp
	exports.mysql:dbExec("successful", [[INSERT INTO ?? (`nickShort`, `nick`, `login`, `hits`, `date`, `timestamp`, `serial`, `ip`, `action`)
		VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?) ON DUPLICATE KEY UPDATE `nick`=?, `hits`=`hits`+1, `date`=NOW(), `timestamp`=?, `action`=?;]],
		removeColorCodes(name), name, getAccountName(getPlayerAccount(source)), 1, timestamp, getPlayerSerial(source), getPlayerIP(source), "Quit",
		name, timestamp, "Quit"
	)
end
addEventHandler("onPlayerQuit", root, onPlayerQuit)

function onPlayerChangeNick(_, newNick)
	local timestamp = getRealTime().timestamp
	exports.mysql:dbExec("successful", [[INSERT INTO ?? (`nickShort`, `nick`, `login`, `hits`, `date`, `timestamp`, `serial`, `ip`, `action`)
		VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?) ON DUPLICATE KEY UPDATE `nick`=?, `hits`=`hits`+1, `date`=NOW(), `timestamp`=?, `action`=?;]],
		removeColorCodes(newNick), newNick, getAccountName(getPlayerAccount(source)), 1, timestamp, getPlayerSerial(source), getPlayerIP(source), "Nick change",
		newNick, timestamp, "Nick change"
	)
end
addEventHandler("onPlayerChangeNick", root, onPlayerChangeNick)

function addFailedLogin(player, login, reason)
	local name = getPlayerName(player)
	local timestamp = getRealTime().timestamp
	exports.mysql:dbExec("actions", [[INSERT INTO ?? (`nickShort`, `nick`, `login`, `hits`, `date`, `timestamp`, `reason`, `serial`, `ip`)
		VALUES (?, ?, ?, ?, NOW(), ?, ?, ?, ?) ON DUPLICATE KEY UPDATE `nick`=?, `hits`=`hits`+1, `date`=NOW(), `timestamp`=?;]],
		removeColorCodes(name), name, tostring(login), 1, timestamp, tostring(reason), getPlayerSerial(player), getPlayerIP(player),
		name, timestamp
	)
end


-- ==========     Вспомогательные функции     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end

function removeColorCodes(str)
	return str:gsub("#%x%x%x%x%x%x", "")
end

function getDBversion()
	local result = exports.mysql:dbQuery(-1, "dbData", "SELECT value FROM ?? WHERE `key` = 'version';")
	return (result) and (result[1]) and tonumber(result[1].value)
end


-- ==========     Начальная инициализация БД     ==========
--[[
function initializeDB()
	outputDebugString("[DBUPDATE] Database in nicklogin not initialized!")
	if fileExists("nicklogins.db") then
		outputDebugString("[DBUPDATE] Found old SQLite database, starting import")
		init = {}	-- Должна оставаться глобальной
		init.startTime = getTickCount()
		
		fileCopy("nicklogins.db", "nicklogins.db.old", true)
		init.oldDB = dbConnect("sqlite", "nicklogins.db")
		local result = dbPoll(dbQuery(init.oldDB, "SELECT COUNT(*) AS count FROM nicklogins"), -1)
		init.nickloginRows = (result and result[1] and result[1].count) or 0
		result = dbPoll(dbQuery(init.oldDB, "SELECT COUNT(*) AS count FROM loginfails"), -1)
		init.loginfailsRows = (result and result[1] and result[1].count) or 0
		init.elapsed = getTickCount() - init.startTime
		init.updatedCount = 0
		init.elapsedTime = 0
		
		outputDebugString(string.format("[DBUPDATE] Found %i nicklogin records and %i action records in %i ms.", init.nickloginRows, init.loginfailsRows, init.elapsed))
		setTimer(oldDBimportWorker, 50, 1)
	else
		outputDebugString("[DBUPDATE] Old SQLite databases for nicklogin not found, skipping import")
		endDBinit()
	end
end
function oldDBimportWorker()
	local startTime = getTickCount()
	local result = dbPoll(dbQuery(init.oldDB, "SELECT * FROM nicklogins ORDER BY date ASC LIMIT 200"), -1)
	if (#result > 0) then
		for _, row in ipairs(result) do
			local nickShort = removeColorCodes(row.nick)
			local realTime = getRealTime(row.date)
			local Date = string.format("%04i-%02i-%02i %02i:%02i:%02i", realTime.year+1900, realTime.month+1, realTime.monthday, realTime.hour, realTime.minute, realTime.second)
			exports.mysql:dbExec("successful", "INSERT INTO ?? (`nickShort`, `nick`, `login`, `hits`, `date`, `timestamp`, `serial`, `ip`, `action`) \
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE `nick`=?, `hits`=`hits`+1, `date`=?, `timestamp`=?;",
				nickShort, row.nick, row.login, 1, Date, row.date, row.serial, row.ip, "Quit",
				row.nick, Date, row.date
			)
			if (row.ip) then
				dbExec(init.oldDB, "DELETE FROM nicklogins WHERE nick = ? AND login = ? AND serial = ? AND ip = ?", row.nick, row.login, row.serial, row.ip)
			else
				dbExec(init.oldDB, "DELETE FROM nicklogins WHERE nick = ? AND login = ? AND serial = ? AND ip IS NULL", row.nick, row.login, row.serial)
			end
		end
		init.updatedCount = init.updatedCount + #result
		local portionTime = getTickCount()-startTime
		init.elapsedTime = init.elapsedTime + portionTime
		outputDebugString(string.format("[DBUPDATE] Transferred %i rows (%.0f%%). Speed: %.2f rows/s, this portion %i ms",
			init.updatedCount, init.updatedCount/init.nickloginRows*100, #result / (portionTime/1000), portionTime
		))
		setTimer(oldDBimportWorker, 50, 1)
	else
		init.nickloginTime = init.elapsedTime
		init.elapsedTime = 0
		init.updatedNicklogin = init.updatedCount
		init.updatedCount = 0
		outputDebugString(string.format("[DBUPDATE] Fully transferred %i nicklogin rows in %.2f secs.", init.updatedNicklogin, init.nickloginTime/1000))
		setTimer(oldDBimportWorker2, 50, 1)
	end
end
function oldDBimportWorker2()
	local startTime = getTickCount()
	local result = dbPoll(dbQuery(init.oldDB, "SELECT * FROM loginfails ORDER BY date ASC LIMIT 200"), -1)
	if (#result > 0) then
		for _, row in ipairs(result) do
			local nickShort = removeColorCodes(row.nick)
			local realTime = getRealTime(row.date)
			local Date = string.format("%04i-%02i-%02i %02i:%02i:%02i", realTime.year+1900, realTime.month+1, realTime.monthday, realTime.hour, realTime.minute, realTime.second)
			exports.mysql:dbExec("actions", "INSERT INTO ?? (`nickShort`, `nick`, `login`, `hits`, `date`, `timestamp`, `reason`, `serial`, `ip`) \
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE `nick`=?, `hits`=`hits`+1, `date`=?, `timestamp`=?;",
				nickShort, row.nick, row.login, 1, Date, row.date, row.reason, row.serial, row.ip,
				row.nick, Date, row.date
			)
			if (row.ip) then
				dbExec(init.oldDB, "DELETE FROM loginfails WHERE nick = ? AND login = ? AND serial = ? AND ip = ? AND reason = ?", row.nick, row.login, row.serial, row.ip, row.reason)
			else
				dbExec(init.oldDB, "DELETE FROM loginfails WHERE nick = ? AND login = ? AND serial = ? AND ip IS NULL AND reason = ?", row.nick, row.login, row.serial, row.reason)
			end
		end
		init.updatedCount = init.updatedCount + #result
		local portionTime = getTickCount()-startTime
		init.elapsedTime = init.elapsedTime + portionTime
		outputDebugString(string.format("[DBUPDATE] Transferred %i rows (%.0f%%). Speed: %.2f rows/s, this portion %i ms",
			init.updatedCount, init.updatedCount/init.loginfailsRows*100, #result / (portionTime/1000), portionTime
		))
		setTimer(oldDBimportWorker2, 50, 1)
	else
		outputDebugString(string.format("[DBUPDATE] Fully transferred %i loginfails rows in %.2f secs.", init.updatedCount, init.elapsedTime/1000))
		destroyElement(init.oldDB)
		fileDelete("nicklogins.db")
		outputDebugString(string.format("[DBUPDATE] Fully converted nicklogin DB (%i of %i rows) in %.2f secs (clean time %.2f secs).",
			init.updatedNicklogin+init.updatedCount, init.nickloginRows+init.loginfailsRows, (getTickCount()-init.startTime)/1000, (init.nickloginTime+init.elapsedTime)/1000
		))
		init = nil
		
		exports.mysql:dbExec("dbData", "REPLACE ?? (`key`, `value`) VALUES ('version', '1.0');")
		outputDebugString("[DBUPDATE] Database in nicklogin updated to version 1.0")
	end
end
]]
