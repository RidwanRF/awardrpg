-------------------------------------------------------------------
-- Название: lights_control.lua
-- Описание: Управление поворотниками и т. д., синхронизация фар
-------------------------------------------------------------------

-- Состояние фар локального авто
local localLightsData = {}

local leftPressTime = 0
local rightPressTime = 0

local lightDataNames = {
    ["emergency_light"] = true,
    ["turn_left"]       = true,
    ["turn_right"]      = true,
    ["front_lights"]     = true,
    ["strobe_b"]     = true,
    ["strobe_r"]     = true,
    ["strobe_w"]     = true,
}

local prevFrontState

----------------------
-- Локальные методы
----------------------

-- Синхронизация состояния локальных поворотников и т. д.
local function syncLocalLights()
    if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
        for name, value in pairs(localLightsData) do
            localPlayer.vehicle:setData(name, not not value, true)
        end
    end
end

-- Обработка изменения состояния фар
function handleLightsDataChange(vehicle, name, value)
    -- Выключение фар при отключении поворотников
    if not value then
        if name == "turn_left" or name == "turn_right" then
            LightsAnim.setLightState(vehicle, name, false)
        elseif name == "emergency_light" then
            LightsAnim.setLightState(vehicle, "turn_left", false)
            LightsAnim.setLightState(vehicle, "turn_right", false)
        end
    end

    local customLights = CustomLights[vehicle:getData("vehicle:model")]
    if customLights and customLights.dataHandlers and customLights.dataHandlers[name] then
        customLights.dataHandlers[name](LightsAnim.getVehicleAnim(vehicle), value, vehicle)
    end
end

----------------------
-- Глобальные методы
----------------------

-- Управление фарами своего автомобиля
function setLocalLightsData(name, value)
    if type(name) ~= "string" then
        return
    end
    local vehicle = localPlayer.vehicle
    if not vehicle then
        return
    end
    if vehicle.controller ~= localPlayer then
        return
    end
    localLightsData[name] = value
    antiDOSsend("main_sync", 250, vehicle, name, value)
    handleLightsDataChange(vehicle, name, value)
end


-- Получение состояния фар

function getVehicleLightData(vehicle, name)

    if vehicle.controller == localPlayer then

        return localLightsData[name]

    end

    return vehicle:getData(name)

end


--------------------------
-- Обработка событий MTA
--------------------------

addEventHandler("onClientElementDataChange", root, function (dataName, oldValue)
    if source.type ~= "vehicle" or not isElementStreamedIn(source) then
        return
    end
    if not lightDataNames[dataName] then
        return
    end
    if source.controller == localPlayer then
        return
    end
    handleLightsDataChange(source, dataName, source:getData(dataName))
end)

-- Управление с клавиатуры
addEventHandler("onClientKey", root, function (button, state)
    if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
        return
    end

    -- Автоматическое выключение поворотников после долгого нажатия
    if button == "a" then
        if state then
            leftPressTime = getTickCount()
        else
            if getVehicleLightData(localPlayer.vehicle, "turn_left") and getTickCount() - leftPressTime > Config.turnDisableTime then

                setLocalLightsData("turn_left", false)
            end
        end
    elseif button == "d" then
        if state then
            rightPressTime = getTickCount()
        else
            if getVehicleLightData(localPlayer.vehicle, "turn_right") and getTickCount() - rightPressTime > Config.turnDisableTime then

                setLocalLightsData("turn_right", false)
            end
        end
    end

    -- Управление светом
    if state and getKeyState("lctrl") then
        if button == "a" then
            setLocalLightsData("emergency_light", false)
            setLocalLightsData("turn_right", false)
            setLocalLightsData("turn_left", not localLightsData["turn_left"])
            cancelEvent()
        elseif button == "d" then
            setLocalLightsData("emergency_light", false)
            setLocalLightsData("turn_left", false)
            setLocalLightsData("turn_right", not localLightsData["turn_right"])
            cancelEvent()
        elseif button == "s" then
            setLocalLightsData("turn_left", false)
            setLocalLightsData("turn_right", false)
            setLocalLightsData("emergency_light", not localLightsData["emergency_light"])
            cancelEvent()
        end
        return
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    setTimer(syncLocalLights, 1000, 0)
end)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function (vehicle, seat)
    if seat == 0 then
        localLightsData = {}
    end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function (vehicle, seat)
    localLightsData = {}
end)

addEventHandler("onClientPreRender", root, function ()
    if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
        return
    end

    local state = getVehicleOverrideLights(localPlayer.vehicle)
    local frontState = state == 2

    if prevFrontState == nil then
        prevFrontState = not frontState
    end

    if frontState ~= prevFrontState then
        setLocalLightsData("front_lights", frontState)
    end

    prevFrontState = frontState
end)
