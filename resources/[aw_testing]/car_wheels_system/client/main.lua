local function isVehicleModelLoaded(vehicle)
    for i, name in ipairs(Config.wheelDummies) do
        if not getVehicleComponentPosition(vehicle, name) then
            return false
        end
    end
    return true
end

-- Костыль для проверки, загрузился ли автомобиль
local function waitForVehicleLoading(vehicle, callback)
    if type(callback) ~= "function" then
        return
    end

    if isVehicleModelLoaded(vehicle) then
        callback(vehicle)
        return
    else
        local waitingTimer
        waitingTimer = setTimer(function ()
            if not isElement(vehicle) then
                killTimer(waitingTimer)
                return
            end
            if isVehicleModelLoaded(vehicle) then
                callback(vehicle)
                killTimer(waitingTimer)
            end
        end, 300, 100)
    end
end

-- Возвращает исходное положение колеса с названием wheelName
function getVehicleDefaultWheelPosition(vehicle, wheelName)
    if Config.debugEnabled then
        resetVehicleComponentPosition(vehicle, wheelName)
        return getVehicleComponentPosition(vehicle, wheelName)
    end
    if WheelsPosition[vehicle.model] and WheelsPosition[vehicle.model][wheelName] then
        return unpack(WheelsPosition[vehicle.model][wheelName])
    end
    return getVehicleComponentPosition(vehicle, wheelName)
end

local function resetVehicleWheelsPosition(vehicle)
    for i, name in ipairs(Config.wheelDummies) do
        local x, y, z = getVehicleDefaultWheelPosition(vehicle, name)
        if x then
            setVehicleComponentPosition(vehicle, name, x, y, z)
        end
    end
end

-- Создаёт и настраивает колёса автомобиля
function setupVehicleWheels(vehicle, streamedIn)
    if not isElement(vehicle) then
        return
    end
    waitForVehicleLoading(vehicle, function ()
        if streamedIn then
            -- Сброс положения всех колёс
            resetVehicleWheelsPosition(vehicle)
        end
        createVehicleWheels(vehicle)
    end)
end

-- Удаляет созданные колёса, очищает шейдеры и т.д.
function removeVehicleWheels(vehicle)
    if not isElement(vehicle) then
        return
    end
    destroyVehicleWheels(vehicle)
end

addEventHandler("onClientElementStreamIn", root, function ()
    if getElementType(source) ~= "vehicle" then
        return
    end
    setupVehicleWheels(source, true)
end)

addEventHandler("onClientElementStreamOut", root, function ()
    if getElementType(source) ~= "vehicle" then
        return
    end
    removeVehicleWheels(source)
end)

addEventHandler("onClientElementDestroy", root, function ()
    if getElementType(source) ~= "vehicle" then
        return
    end
    removeVehicleWheels(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
        setupVehicleWheels(vehicle, true)
    end
end)

addEvent("forceUpdateVehicleComponents", true)
addEventHandler("forceUpdateVehicleComponents", root, function ()
    setupVehicleWheels(source)
end)
