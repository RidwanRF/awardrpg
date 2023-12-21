
-- // Подключение
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    db = dbConnect( "sqlite", "assets/database/database.db")
	dbExec(db, "CREATE TABLE IF NOT EXISTS vehicle(id, state)")
end)

-- // Сохранение в базу данных
function func_save_shtorka(vehicle)
	if isElement(vehicle) then
		local id 		= getElementData(vehicle, "ID") or getElementData(vehicle, "id") or 0
		local state 	= getElementData(vehicle, "vehicle:shtorka") or false
		local result 	= dbPoll(dbQuery(db, "SELECT * FROM vehicle WHERE id = ?", id ), -1)
		if result and #result ~= 0 then
			dbExec(db, "UPDATE vehicle SET state = ? WHERE id = ?", toJSON(state), id)
		else
			dbExec(db, "INSERT INTO vehicle VALUES(?, ?)", id, toJSON(state))
		end
		
		func_set_info(vehicle)
	end
end
addEvent("saveAccountShtorka", true)
addEventHandler("saveAccountShtorka", root, func_save_shtorka)

-- // Загрузка из базы данных
function func_load_shtorka(vehicle)
	if isElement(vehicle) then
		local id 		= getElementData(vehicle, "ID") or getElementData(vehicle, "id") or 0
		local result 	= dbPoll(dbQuery(db, "SELECT * FROM vehicle WHERE id = ?", id ), -1)
		if result and #result ~= 0 then
			setElementData(vehicle, "vehicle:shtorka", fromJSON(result[1]["state"]))
		else
			setElementData(vehicle, "vehicle:shtorka", false)
		end
		func_set_info(vehicle)
	end
end
addEvent("loadAccountShtorka", true )
addEventHandler("loadAccountShtorka", root, func_load_shtorka)

-- // Активация
function func_set_data(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle and getPedOccupiedVehicleSeat(player) == 0 then
		triggerClientEvent("vehicle:shtorka", resourceRoot, vehicle)
	end
end

function func_set_info(vehicle)
	if isElement(vehicle) then
		local id 	= getElementData(vehicle, "ID") or getElementData(vehicle, "id") or 0
		local model = getElementModel(vehicle)
		local state = tostring(getElementData(vehicle, "vehicle:shtorka"))
		print("[Шторка] | ID: "..id.." | MODEL: "..model.." | STATE: "..state)
	end
end

-- // Бинд
addEventHandler("onResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		bindKey(player, game_bind_on_state, "down", func_set_data)
	end
end)

-- // Бинд
addEventHandler("onPlayerJoin", root, function()
	bindKey(source, game_bind_on_state, "down", func_set_data)
end)

-- // Бинд
addEventHandler("onPlayerQuit", root, function()
	unbindKey(source, game_bind_on_state, "down", func_set_data)
end)

-- // Сохранение шторки
addEventHandler("onElementDataChange", root, function(data,_,value)
	 if getElementType(source)== "vehicle" then
        if data == "vehicle:shtorka" then
			func_save_shtorka(source)
		end
	end
end)

-- // Команда включение шторок
addCommandHandler("shtora_on1", function(player, cmd)
	if getPedOccupiedVehicle(player) then
		if getVehicleController(getPedOccupiedVehicle(player)) == player then
			setElementData(getPedOccupiedVehicle(player), "vehicle:shtorka", true)
		end
	end
end)

-- // Команда отключение шторок
addCommandHandler("shtora_off0", function(player, cmd)
	if getPedOccupiedVehicle(player) then
		if getVehicleController(getPedOccupiedVehicle(player)) == player then
			setElementData(getPedOccupiedVehicle(player), "vehicle:shtorka", false)
		end
	end
end)