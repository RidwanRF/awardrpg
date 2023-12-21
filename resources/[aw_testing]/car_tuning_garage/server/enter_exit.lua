local playersInTuning = {}

local function destroyTuningVehicle(vehicle)
    if not isElement(vehicle) then
        return
    end

    if isResourceRunning("car_system") then
        exports.car_system:policeRemoveCar(vehicle)
    end
end

function playerEnterTuning(player)
    if not isElement(player) or not player.vehicle then
        return
    end
    -- Позиция
    player.vehicle.position = Config.tuningVehiclePosition
    player.vehicle.rotation = Config.tuningVehicleRotation
    -- Интерьер
    player.interior = Config.tuningInterior
    player.vehicle.interior = Config.tuningInterior

    local dimension = getDimensionForPlayer(player)
    player.dimension = dimension
    player.vehicle.dimension = dimension

    player.vehicle.velocity = Vector3()
    player.vehicle.turnVelocity = Vector3()
    player.vehicle.engineState = false

    triggerClientEvent(player, "playerEnterTuning", resourceRoot, true)
    fadeCamera(player, true, 1)
end
addEvent("playerEnterTuning", true)
addEventHandler("playerEnterTuning", resourceRoot, function (x, y, z)
    if client.dimension ~= 0 then
        return
    end
    if not client.vehicle or client.vehicle.controller ~= client then
        return
    end
    if client.vehicle.vehicleType ~= "Automobile" then
        return
    end
    if client:getData("isChased") then
        outputChatBox("Сначала оторвитесь от погони!", client, 255, 0, 0)
        return
    end
    if not client.vehicle:getData("vehicle:model") or Config.disabledVehicleModels[client.vehicle:getData("vehicle:model")] then
        outputChatBox("Данный автомобиль нельзя тюнинговать", client, 255, 0, 0)
        return
    end
    if client.vehicle:getData("testDrivePlayer") then
        outputChatBox("Вы не являетесь владельцем автомобиля", client, 255, 0, 0)
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
    setTimer(playerEnterTuning, 1100, 1, client, marker)

    if isResourceRunning("save_system") then
        exports.save_system:overrideCoordsSaving(client, x, y, z + 1)
    end
end)

function playerExitTuning(player, wasted, buying)
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

    triggerClientEvent(player, "playerExitTuning", resourceRoot, wasted, buying)
    fadeCamera(player, true, 1)

    if wasted then
        destroyTuningVehicle(player.vehicle)
    end
    if isResourceRunning("save_system") then
        exports.save_system:cancelCoordsSavingOverride(player)
    end
end

addEvent("playerExitTuning", true)
addEventHandler("playerExitTuning", resourceRoot, function (...)
    setTimer(playerExitTuning, 500, 1, client, ...)
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
    playerExitTuning(source, true)
end)
