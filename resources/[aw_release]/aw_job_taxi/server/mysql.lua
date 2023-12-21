local connect = nil

function connectDataBase()
	connect = dbConnect("sqlite", "database.db")
	dbExec(connect, "CREATE TABLE IF NOT EXISTS taxi (ID int(11), name varchar(255), level varchar(255), exp varchar(255), routes varchar(255), salary varchar(255))")
end
connectDataBase()

getFreeProfileID = function ()
	--local result = connect:dbPoll("SELECT ID FROM taxi ORDER BY ID ASC")
	local result = dbPoll(dbQuery(connect, "SELECT ID FROM taxi ORDER BY ID ASC"), -1)
	newID = false
	for i, id in pairs (result) do
		if id["ID"] ~= i then
			newID = i
			break
		end
	end
	if newID then return newID else return #result + 1 end
end

isProfileFromPlayer = function (player)
	local name = getAccountName ( getPlayerAccount ( player ))
	local q = dbPoll(dbQuery(connect, "SELECT * FROM taxi WHERE name=?", name), -1)
	if #q >= 1 then
		return true
	else 
		return false
	end
end

createNewProfile = function (player)
	if not isProfileFromPlayer(player) then
		local ID = getFreeProfileID()
		local name = getAccountName ( getPlayerAccount ( player ))
		local level = 1
		local exp = 0
		local routes = 0
		local salary = 0 
		connect:query("INSERT INTO taxi (ID, name, level, exp, routes, salary) values (?,?,?,?,?,?)", ID, name, level, exp, routes, salary)
		setElementData(player, "taxi:data", {ID = ID, level = level, exp = exp, routes = routes, salary = salary})
		outputDebugTaxiMessage("Created new profile ID: "..ID.." | Name: "..name)
		outputChatBox("Ваш профиль был успешно создан!", player, 255, 255, 0, true)
		return true
	else
		loadProfileData(player)
	end
end
addEvent("onPlayerCreatedTaxiProfile", true)
addEventHandler("onPlayerCreatedTaxiProfile", root, createNewProfile)

loadProfileData = function (player)
	if isProfileFromPlayer(player) then
		local name = getAccountName ( getPlayerAccount ( player ))
		local q = dbPoll(dbQuery(connect, "SELECT * FROM taxi WHERE name=?", name), 1)
		if #q >= 1 then
			setElementData(player, "taxi:data", {ID = q[1]["ID"], level = q[1]["level"], exp = q[1]["exp"], routes = q[1]["routes"], salary = q[1]["salary"]})
		end
	end
end

addEventHandler("finishLogin", root, function ()
	setTimer(function (player)
		loadProfileData(player)
	end, 1000, 1, source)
end)

updateProfileData = function (player)
	if isProfileFromPlayer(player) then
		local data = getElementData(player, "taxi:data") or {}
		if data then
			outputDebugTaxiMessage("Updated profile ID: "..data["ID"].." | Name: "..getPlayerName(player).." | Level: "..data["level"].." | Exp:"..data["exp"].." | Routes: "..data["routes"].." | TotalSalary: "..data["salary"])
			dbExec(connect,"UPDATE taxi SET level=?, exp=?, routes=?, salary=? WHERE ID=?", data.level, data.exp, data.routes, data.salary, data.ID)
		end
		return true
	else
		return false
	end
end

onDataChange = function (data)
	if getElementType(source) == "player" then
		if data == "taxi:data" then
			updateProfileData(source)
		end
	end
end
addEventHandler("onElementDataChange", root, onDataChange)

outputDebugTaxiMessage = function (message)
	outputDebugString("[TAXI] "..message)
end

