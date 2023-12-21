addEvent("buyCarshopVehicle", true)
addEventHandler("buyCarshopVehicle", resourceRoot, function (model, r1, g1, b1, r2, g2, b2, shopId, region)
    if not isResourceRunning("car_system") then
            triggerClientEvent(client, "buyCarshopVehicle", resourceRoot, false)
        return
    end
    local result = exports.car_system:buyVehicleForPlayer(client, model, r1, g1, b1, r2, g2, b2, shopId, region)
    playerExitCarshop(client)
end)
