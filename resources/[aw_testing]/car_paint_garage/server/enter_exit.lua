local playersInTuning = {}

local function destroyTuningVehicle(vehicle)
    if not isElement(vehicle) then
        return
    end

    if isResourceRunning("car_system") then
        exports.car_system:policeRemoveCar(vehicle)
    end
end

function playerEnterPaintGarage(player)
    if not isElement(player) or not player.vehicle then
        return
    end
    -- Позиция
     player.vehicle.position = Config.garageVehiclePosition
     player.vehicle.rotation = Config.garageVehicleRotation
    -- Интерьер
     player.interior = Config.garageInterior
     player.vehicle.interior = Config.garageInterior

    local dimension = getDimensionForPlayer(player)
    player.dimension = dimension
    player.vehicle.dimension = dimension

    player.vehicle.velocity = Vector3()
    player.vehicle.turnVelocity = Vector3()
    player.vehicle.engineState = false

    triggerClientEvent(player, "playerEnterPaintGarage", resourceRoot, true)
    fadeCamera(player, true, 1)
end

addEvent("playerEnterPaintGarage", true)
addEventHandler("playerEnterPaintGarage", resourceRoot, function (x, y, z)
    if client.dimension ~= 0 then
        return
    end
    if not client.vehicle or client.vehicle.controller ~= client then
        return
    end
    if client:getData("isChased") then
        outputChatBox("Сначала оторвитесь от погони!", client, 255, 0, 0)
        return
    end
   -- local owner = client.vehicle:getData("owner")
   -- if owner ~= client.account.name then
   --  -  -- outputChatBox("Вы не являетесь владельцем автомобиля", client, 255, 0, 0)
     ----   return
   -- end
    if not Config.allowedVehicleTypes[client.vehicle.vehicleType] then
        return
    end
    -- Высадить пассажиров
    for seat, player in pairs(client.vehicle.occupants) do
        if player ~= client then
            player.vehicle = nil
        end
    end
    playersInTuning[client] = true
    fadeCamera(client, false, 1)
    setTimer(playerEnterPaintGarage, 1100, 1, client, marker)

    if isResourceRunning("save_system") then
        exports.save_system:overrideCoordsSaving(client, x, y, z + 1)
    end
end)

function playerExitPaintGarage(player, wasted, buying)
    if not isElement(player) then
        return
    end
    if not playersInTuning[player] then
        return
    end
    if player.vehicle then
        player.vehicle.interior = 0
        player.vehicle.dimension = 0
        player.vehicle.engineState = true
    else
        player.dimension = 0
    end
    player.interior = 0
    playersInTuning[player] = nil
    clearPlayerDimension(player)

    triggerClientEvent(player, "playerExitPaintGarage", resourceRoot, wasted, buying)
    fadeCamera(player, true, 1)

    if wasted then
        destroyTuningVehicle(player.vehicle)
    end
    if isResourceRunning("save_system") then
        exports.save_system:cancelCoordsSavingOverride(player)
    end
end

addEvent("playerExitPaintGarage", true)
addEventHandler("playerExitPaintGarage", resourceRoot, function (...)
    fadeCamera(client, false, 1)
    setTimer(playerExitPaintGarage, 1100, 1, client, ...)
end)

-- Запретить вход в автомобиль, который въезжает в гараж
addEventHandler("onVehicleStartEnter", root, function(player)
    if source.controller and playersInTuning[source.controller] then
        cancelEvent()
    end
end)

-- Запретить выход из автомобиля при въезде в гараж
addEventHandler("onVehicleStartExit", root, function(player)
    if playersInTuning[player] then
        cancelEvent()
    end
end)

-- Вернуть игрока в автомобиль, если он вышел/был выброшен
addEventHandler("onVehicleExit", root, function(player)
    if not player.vehicle and playersInTuning[player] then
        player.vehicle = source
    end
end)

addEventHandler("onPlayerQuit", root, function ()
    playersInTuning[source] = nil
end)

addEventHandler("onPlayerWasted", root, function ()
    playerExitPaintGarage(source, true)
end)
