function playerEnterCarshop(player, carshopId, params)
    if not isElement(player) then
        return
    end
    player.dimension = Config.carshopDimension
    local garage = getCarshopGarage(carshopId)
    player.interior = garage.interior or 0
    player.frozen = true
    triggerClientEvent(player, "playerEnterCarshop", resourceRoot, carshopId, params)
    fadeCamera(player, true, 1)
end

addEvent("playerEnterCarshop", true)
addEventHandler("playerEnterCarshop", resourceRoot, function (carshopId)
    if client.dimension ~= 0 then
        return
    end
    if client.vehicle then
        return
    end
    if client:getData("isChased") then
        outputChatBox("Сначала оторвитесь от погони!", client, 255, 0, 0)
        return
    end
    client:setData("inCarshop", true, false)
    local x, y, z = getElementPosition(client)
    client:setData("carshop_enter_pos", {x,y,z}, false)
    if isResourceRunning("save_system") then
        exports.save_system:overrideCoordsSaving(client, x, y, z)
    end

    fadeCamera(client, false, 1)
    setTimer(playerEnterCarshop, 1100, 1, client, carshopId)
end)

function playerExitCarshop(player)
    if not isElement(player) then
        return
    end
    if not player:getData("inCarshop") then
        return
    end
    player:setData("inCarshop", false, false)

    player.dimension = 0
    player.interior = 0
    player.frozen = false
    local exitPosition = player:getData("carshop_enter_pos")
    if type(exitPosition) == "table" then
        setElementPosition(player, unpack(exitPosition))
    end
    player:removeData("carshop_enter_pos")

    triggerClientEvent(player, "playerExitCarshop", resourceRoot)
    fadeCamera(player, true, 1)

    if isResourceRunning("save_system") then
        exports.save_system:cancelCoordsSavingOverride(player)
    end
end

addEvent("playerExitCarshop", true)
addEventHandler("playerExitCarshop", resourceRoot, function (...)
    fadeCamera(client, false, 1)
    setTimer(playerExitCarshop, 1100, 1, client, ...)
end)

addEventHandler("onPlayerQuit", root, function ()
    playerExitCarshop(source)
end)

addEventHandler("onPlayerWasted", root, function ()
    playerExitCarshop(source)
end)

addEventHandler("onResourceStop", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        if player:getData("carshop_enter_pos") then
            player.frozen = false
            player.vehicle = nil
            setElementPosition(player, unpack(player:getData("carshop_enter_pos")))
            player.dimension = 0
            player.interior = 0
            player:removeData("carshop_enter_pos")
        end
    end
end)

addEventHandler("onResourceStart", resourceRoot, function ()
    for i, player in ipairs(getElementsByType("player")) do
        if player:getData("carshop_enter_pos") then
            player:removeData("carshop_enter_pos")
        end
    end
end)
