function setVehicleColorByName(vehicle, name, r, g, b)
    if name == "body" then
        local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
        setVehicleColor(vehicle, r, g, b, r2, g2, b2)
    elseif name == "additional" then
        local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
        setVehicleColor(vehicle, r1, g1, b1, r, g, b)
    elseif name == "wheels" then
        vehicle:setData("wheels_color", string.format("#%.2X%.2X%.2X", r, g, b))
        triggerClientEvent(root, "forceUpdateVehicleComponents", vehicle)
    end
end

addEvent("paintGarageBuyVehicleColor", true)
addEventHandler("paintGarageBuyVehicleColor", resourceRoot, function (name, r, g, b)
    if not client.vehicle then
        return
    end
    local price = Config.prices[name]
    if not price then
        return
    end
    if client.money < price then
        return
    end
    takePlayerMoney(client, price)
    setVehicleColorByName(client.vehicle, name, r, g, b)
    triggerClientEvent(client, "paintGarageBuyVehicleColor", resourceRoot, name, r, g, b)

    if isResourceRunning("car_system") then
        -- Лог
        local vehicleName = tostring(exports.car_system:getVehicleModName(client.vehicle))
        local vehicleLicensePlate = tostring(client.vehicle:getData("licensep"))
    end
end)

addEvent("paintGarageBuyToner", true)
addEventHandler("paintGarageBuyToner", resourceRoot, function (sides)
    if not sides or type(sides) ~= "table" then
        return
    end
    local price = 0
    local sideNames = {}
    for name in pairs(sides) do
        price = price + Config.tintPrices[name]
        table.insert(sideNames, name)
    end
    if client.money < price then
        return
    end
    takePlayerMoney(client, price)

    for name, value in pairs(sides) do
        value = tonumber(value)
        if value then
            client.vehicle:setData("tint_" .. tostring(name), math.floor(value))
        end
    end

    triggerClientEvent(client, "paintGarageBuyToner", resourceRoot, sides)

    -- Сохранить тюнинг в бд
    if isResourceRunning("car_system") then
        exports.car_system:saveCarData(client.vehicle)

        -- Лог
        local vehicleName = tostring(exports.car_system:getVehicleModName(client.vehicle))
        local vehicleLicensePlate = tostring(client.vehicle:getData("licensep"))
    end
end)

addEvent("paintGarageBuyPaintjob", true)
addEventHandler("paintGarageBuyPaintjob", resourceRoot, function (paintjob, resetColors)
    if not paintjob then
        paintjob = nil
    end
    local price = Config.paintjobPrice
    if not paintjob then
        price = Config.paintjobRemovePrice
    end
    if client.money < price then
        return
    end
    takePlayerMoney(client, price)
    client.vehicle:setData("paintjob", paintjob)
    if resetColors then
        setVehicleColorByName("body", 255, 255, 255)
        setVehicleColorByName("additional", 255, 255, 255)
    end
    triggerClientEvent(client, "paintGarageBuyPaintjob", resourceRoot, paintjob, resetColors)

    -- Сохранить тюнинг в бд
    if isResourceRunning("car_system") then
        exports.car_system:saveCarData(client.vehicle)

        -- Лог
        local vehicleName = tostring(exports.car_system:getVehicleModName(client.vehicle))
        local vehicleLicensePlate = tostring(client.vehicle:getData("licensep"))
    end
end)





addEvent("painGaraColor", true)
addEventHandler("painGaraColor", resourceRoot, function (stype, cost)
    if getPlayerMoney(client) >= cost then
        if stype == 1 then stype = false end
        takePlayerMoney(client, cost)
        setElementData (client.vehicle, "colorType", stype)
		triggerClientEvent(client, "paintGarageBuyVehicleColorType", resourceRoot,'ColorType', stype)
    else
         outputChatBox ("#009933Недостаточно средст для покупки типа краски",client,  255, 127, 0, true)
    end
end)