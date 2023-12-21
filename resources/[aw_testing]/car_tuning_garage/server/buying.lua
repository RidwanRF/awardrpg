

local _createVehicle = createVehicle
function createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    local veh
    if model >= 400 and model <= 611 then
        veh = _createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    else
        veh = _createVehicle(411, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    end

    setElementData(veh, "vehicle:model", model)

    return veh
end

addEvent("tuningGarageBuy", true)
addEventHandler("tuningGarageBuy", resourceRoot, function (components)
    if not client.vehicle then
        return
    end
    local owner = client.vehicle:getData("owner")
    if owner ~= client.account.name then
        outputChatBox("Вы не являетесь владельцем автомобиля", client, 255, 0, 0)
        return
    end
    local totalPrice = 0
    for i, data in ipairs(components) do
        local componentInfo = getComponentInfo(client.vehicle:getData("vehicle:model"), data.component, data.id)
        if not componentInfo then
            debug.log("No such component: " .. tostring(data.component) .. " (id" .. tostring(data.id) .. ")")
            return
        end
        totalPrice = totalPrice + componentInfo.price
    end
    -- Проверить наличие денег у игрока
    if exports.bank:getPlayerBankMoney(client, "RUB") <= totalPrice then
        return
    end
   -- Установить тюнинг на автомобиль
    local upgradesList = {}
    for i, data in ipairs(components) do
        table.insert(upgradesList, tostring(data.component) .. tostring(data.id))
        if data.component == "xenon" then
            local r, g, b = setVehicleXenon(client.vehicle, data.id)
            client.vehicle:setData("xenon", tostring(r)..","..tostring(g)..","..tostring(b))
		elseif data.component == "shtorka" then
            if data.id == 1 then
			    client.vehicle:setData("vehicle:shtorka", true)
			    client.vehicle:setData("vehicle:shtorka:type", 1)
            elseif data.id == 2 then
                client.vehicle:setData("vehicle:shtorka", true)
                client.vehicle:setData("vehicle:shtorka:type", 2)
            end
		else
			client.vehicle:setData(data.component, data.id)
        end
    end
    triggerClientEvent("forceUpdateVehicleComponents", client.vehicle)
    -- Сохранить тюнинг в бд
    if isResourceRunning("car_system") then
        exports.car_system:saveCarData(client.vehicle)

        -- Лог
        local vehicleName = tostring(exports.car_system:getVehicleModName(client.vehicle))
        local vehicleLicensePlate = tostring(client.vehicle:getData("licensep"))
        local upgradesListString = table.concat(upgradesList, ", ")
        outputDebugString(string.format("[TUNING_GARAGE] %s (acc %s, money %s) installed upgrades [%s] to %s (%s, %s) for %s",
            client.name,
            client.account.name,
            tostring(client.money),
            upgradesListString,
            vehicleName,
            tostring(client.vehicle:getData("vehicle:model")),
            vehicleLicensePlate,
            tostring(totalPrice)))
    end
    -- Снять деньги и выйти
    --debug.log("Total price: " .. tostring(totalPrice))
  --  takePlayerMoney(client, totalPrice)
    exports.bank:takePlayerBankMoney(client, totalPrice, "RUB")
    playerExitTuning(client, false, true)
end)

-- Покупка в гараже настроек колёс
addEvent("garageBuyWheelsConfig", true)
addEventHandler("garageBuyWheelsConfig", resourceRoot, function (data)
    if not client.vehicle or type(data) ~= "table" then
        return
    end
    local owner = client.vehicle:getData("owner")
    if owner ~= client.account.name then
        outputChatBox("Вы не являетесь владельцем автомобиля", client, 255, 0, 0)
        return
    end
    local totalPrice = 0
    for name in pairs(data) do
        totalPrice = totalPrice + Config.wheelPropertiesPrices[name]
    end
    if client.money < totalPrice then
        return
    end
    for name, value in pairs(data) do
        client.vehicle:setData(name, math.floor(value * 1000) / 1000)
    end
   -- takePlayerMoney(client, totalPrice)
    exports.bank:takePlayerBankMoney(client, totalPrice, "RUB")

    if isResourceRunning("car_system") then
        -- Лог
        local vehicleName = tostring(exports.car_system:getVehicleModName(client.vehicle))
        local vehicleLicensePlate = tostring(client.vehicle:getData("licensep"))
        outputDebugString(string.format("[TUNING_GARAGE] %s (acc %s, money %s) updated wheels config to %s (%s, %s) for %s",
            client.name,
            client.account.name,
            tostring(client.money),
            vehicleName,
            tostring(client.vehicle:getData("vehicle:model")),
            vehicleLicensePlate,
            tostring(totalPrice)))
    end
    triggerClientEvent("forceUpdateVehicleComponents", client.vehicle)
    triggerClientEvent(client, "garageBuyWheelsConfig", resourceRoot, data)
end)
