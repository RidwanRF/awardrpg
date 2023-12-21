local testDrivePlayers = {}

addEvent("carshopStartTestDrive", true)
addEventHandler("carshopStartTestDrive", resourceRoot, function (model, r1, g1, b1, r2, g2, b2, carshopId)
    local player = client

    local price = calculateTestDrivePrice(model)
    if not price or player.money < price then
        triggerClientEvent(player, "onClientTestDriveStop", resourceRoot)
        return
    end

    player.money = player.money - price

    -- Выбор места начала тест-драйва
    local position = Config.testdrivePosition
    local rotation = Vector3()
    if carshopId and ShopTable[carshopId] then
        local shop = ShopTable[carshopId]
        position = Vector3(shop.spwnPosX, shop.spwnPosY, shop.spwnPosZ)
        rotation = Vector3(0, 0, shop.spwnRotZ)
    end

    player.dimension = 0
    player.interior = 0
    player.frozen = false

    triggerClientEvent(player, "playerExitCarshop", resourceRoot)

    player.position = position
    local vehicle = createVehicle(model, position, rotation)
    vehicle:setColor(r1, g1, b1, r2, g2, b2)
    vehicle.dimension = player.dimension
    vehicle.interior = player.interior

    player.vehicle = vehicle

    testDrivePlayers[player] = {
        vehicle = vehicle,
        carshopId = carshopId
    }

    vehicle:setData("testDrivePlayer", player, false)
    vehicle:setData("job.nomer", exports.car_system:generateNumberplate("i"))

    triggerClientEvent(player, "onClientTestDriveStart", resourceRoot)

	setTimer(stopPlayerTestDrive, Config.testDriveTime*1000, 1, player, false)

    setTimer(function ()
        fadeCamera(player, true, 3)
    end, 1000, 1)
end)

function isTestDrivePlayer(player)
    if not player then
        return false
    end
    return not not testDrivePlayers[player]
end

function stopPlayerTestDrive(player, omitEnterCarshop)
    if getResourceState(resource) == "stopping" then
        return
    end
    if not player then
        return
    end
    if not testDrivePlayers[player] then
        return
    end
    local testDrive = testDrivePlayers[player]
    testDrivePlayers[player] = nil

    if isElement(testDrive.vehicle) then
        for seat, passenger in pairs(testDrive.vehicle.occupants) do
            passenger.vehicle = nil
        end
    end
    if isElement(player) then
        player.vehicle = nil
        player.interior = 0
        player.dimension = 0
        triggerClientEvent(player, "onClientTestDriveStop", resourceRoot)
        if not omitEnterCarshop then
            local exitPosition = player:getData("carshop_enter_pos")
            if type(exitPosition) == "table" then
                setElementPosition(player, unpack(exitPosition))
            end

            local vehicle = testDrive.vehicle
            local color
            if isElement(vehicle) then
                color = {getVehicleColor(vehicle, true)}
            end
            playerEnterCarshop(player, testDrive.carshopId, {
                color = color
            })
        end
    end
    if isElement(testDrive.vehicle) then
        destroyElement(testDrive.vehicle)
    end
end

addEvent("onPlayerStopTestDrive", true)
addEventHandler("onPlayerStopTestDrive", resourceRoot, function ()
    if not isTestDrivePlayer(player) then
        return
    end
    fadeCamera(client, false, 1)
    setTimer(stopPlayerTestDrive, 1200, 1, client)
end)

addEventHandler("onVehicleStartExit", resourceRoot, function (player, seat, jacked)
    if not isTestDrivePlayer(player) or jacked then
        return
    end
    fadeCamera(player, false, 1)
    setTimer(stopPlayerTestDrive, 1200, 1, player)
    cancelEvent()
end)

-- Вернуть игрока в автомобиль, если он вышел/был выброшен
addEventHandler("onVehicleExit", resourceRoot, function(player)
    if not isTestDrivePlayer(player) then
        return
    end
    if testDrivePlayers[player] and isElement(testDrivePlayers[player].vehicle) then
        setTimer(function ()
            if isElement(player) and testDrivePlayers[player] and isElement(testDrivePlayers[player].vehicle) then
                player.vehicle = testDrivePlayers[player].vehicle
            end
        end, 50, 1)
    end
end)

addEventHandler("onElementDestroy", resourceRoot, function ()
    local player = source:getData("testDrivePlayer")
    if not isTestDrivePlayer(player) then
        return
    end
    if isElement(player) and testDrivePlayers[player] then
        stopPlayerTestDrive(player)
    end
end)

addEventHandler("onPlayerWasted", root, function ()
    stopPlayerTestDrive(source, true)
end)

addEventHandler("onPlayerQuit", root, function ()
    stopPlayerTestDrive(source, true)
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function (player, seat, jacked)
    if not testDrivePlayers[player] then
        cancelEvent()
    end
end)
