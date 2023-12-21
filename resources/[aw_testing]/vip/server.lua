local db

function dbFunction ()
db = dbConnect ("sqlite", "vips.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS accounts (user, state, time)")
end
dbFunction ()

function givePlayerVIP (acc, time)
if isPlayerVIP (acc) then return addPlayerVipTime(acc, time) end --Если випка уже есть, то вернут в донат панель false
local dbCall = dbPoll(dbQuery(db, "SELECT * FROM accounts WHERE user = ?", acc), -1)

local timeStamp = getRealTime().timestamp
local endTime = timeStamp + time
setAccountData (getAccount (acc), "vip:message", false)

if #dbCall ~= 0 then
	dbExec(db, "UPDATE accounts SET state = ?, time = ? WHERE user = ?", true, endTime, acc)
else
	dbExec(db, "INSERT INTO accounts VALUES (?, ?, ?)", acc, true, endTime)
end
local pl = getAccountPlayer (getAccount (acc))
if isElement (pl) then
	updateClientData (pl)
end
return true
end

function takePlayerVIP (pl)
	local acc = getAccountName (getPlayerAccount(pl))
	dbExec(db, "UPDATE accounts SET state = ?, time = ? WHERE user = ?", false, getRealTime().timestamp, acc)
	updateClientData (pl)
end

function addPlayerVipTime (acc, time)
	if not getAccount (acc) then return false end
	local dbCall = dbPoll(dbQuery(db, "SELECT * FROM accounts WHERE user = ?", acc), -1)

	if #dbCall ~= 0 then
		local timeStamp = 0
		local endTime = 0
		if tonumber(dbCall[1]["state"]) == 1 or dbCall[1]["state"] == "1" then
			timeStamp = dbCall[1]["time"]
			endTime = timeStamp + time
		else
			timeStamp = getRealTime().timestamp
			endTime = timeStamp + time
		end
		setAccountData (getAccount (acc), "vip:message", false)
		dbExec(db, "UPDATE accounts SET state = ?, time = ? WHERE user = ?", true, endTime, acc)
	else
		local timeStamp = getRealTime().timestamp
		local endTime = timeStamp + time
		dbExec(db, "INSERT INTO accounts VALUES (?, ?, ?)", acc, true, endTime)
	end
	local pl = getAccountPlayer (getAccount (acc))
	if isElement (pl) then
		updateClientData (pl)
	end
	return true
end

function giveAccVIP (acc, time)
-- if givePlayerVIP (acc, time) then
	-- return "VIP статус успешно выдан"
-- else
	-- return "Ошибка выдачи #1"
-- end
	return true
end

function consoleJetPack ( thePlayer, commandName )
	local accName = getAccountName ( getPlayerAccount ( thePlayer ) ) 
	if not isPlayerVIP (thePlayer) then return false end
	if isPedInVehicle (thePlayer) then return end
	if not doesPedHaveJetPack ( thePlayer ) then
	  local status = givePedJetPack ( thePlayer )
	  outputChatBox('#50ff50[Джетпак] Вы получили джетпак',thePlayer, 255, 255, 255, true)
	  if not status then
	  end
	else
	  local status = removePedJetPack ( thePlayer )
	  outputChatBox('#50ff50[Джетпак] Вы сняли джетпак',thePlayer, 255, 255, 255, true)
	  if ( not status ) then
	  end
	end
end
addCommandHandler ( "j", consoleJetPack )


function checkVIP ()
local dbCall = dbPoll(dbQuery(db, "SELECT * FROM accounts"), -1)
local timeStamp = getRealTime().timestamp
for i, v in ipairs (dbCall) do
	if v["state"] == 1 then
		if tonumber(timeStamp) >= tonumber(v["time"]) then
			dbExec(db, "UPDATE accounts SET state = ? WHERE user = ?", false, v["user"])
			local pl = getAccountPlayer (getAccount (v["user"]))
			if isElement (pl) then
				updateClientData (pl)
				outputChatBox ("У вас закончился VIP статус!", pl, 255, 200, 0)
				setAccountData (getAccount (v["user"]), "vip:message", false)
			else
				setAccountData (getAccount (v["user"]), "vip:message", "У вас закончился VIP статус!")
			end
		end
	end
end
end
setTimer (checkVIP, 1000*5, 0)

function getTimeVIP (pl)
local acc = getAccountName (getPlayerAccount (pl))
local dbCall = dbPoll(dbQuery(db, "SELECT * FROM accounts WHERE user = ?", acc), -1)
local resTime
for i, v in ipairs (dbCall) do
	if v["state"] == 1 then
		local sec = v["time"] - getRealTime().timestamp
		local res = secondsToTimeDesc (sec)
		resTime = res
		outputChatBox ("До окончания VIP статуса: #AACCAA"..res, pl, 255, 200, 0, true)
		updateClientData (pl)
		break
	else
		outputChatBox ("У вас нету VIP статуса!", pl, 255, 0, 0)
		break
	end
end
return resTime
end
addCommandHandler ("viptime", getTimeVIP)

function onLogin(_, acc)
local data = getAccountData (acc, "vip:message")
if data then
	outputChatBox (data, source, 255, 200, 0)
	setAccountData (acc, "vip:message", false)
end
if isPlayerVIP (source) then
	getTimeVIP (source)
end
end
addEventHandler ("onPlayerLogin", root, onLogin)

function isPlayerVIP (el)
local acc
local result

if type (el) == "string" then
	acc = el
else
	if isElement (el) then
		acc = getAccountName (getPlayerAccount (el))
	else
		result = false
	end
end

if acc then
	local dbCall = dbPoll(dbQuery(db, "SELECT * FROM accounts"), -1)
	for i, v in pairs (dbCall) do
		if v["user"] == acc and v["state"] == 1 then
			result = true
			break
		end
	end
end

return result
end

function updateClientData (pl)
	triggerClientEvent (pl, "updateVIP", pl, isPlayerVIP (pl))
	triggerClientEvent (root, "updateVIPs", root, pl, isPlayerVIP (pl))
end

function onStart()
for i, v in ipairs (getElementsByType ("player")) do
	if isPlayerVIP (v) then
		getTimeVIP (v)
	end
	updateClientData (v)
end
end
setTimer (function() onStart() end, 1000, 1)

function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
		
		if day > 0 then table.insert( results, day .. ( day == 1 and " день" or " дней" ) ) end
		if hou > 0 then table.insert( results, hou .. ( hou == 1 and " час" or " часов" ) ) end
		if min > 0 then table.insert( results, min .. ( min == 1 and " минуты" or " минут" ) ) end
		if sec > 0 then table.insert( results, sec .. ( sec == 1 and " секунда" or " секунд" ) ) end
		
		return table.concat ( results, " " )
	end
	return ""
end
