-------------------------------------------------------------------
-- Название: lights_sync.lua
-- Описание: Синхронизация автомобилей с анимированными фарами
-------------------------------------------------------------------

-- Дата: animatedLightsState

----------------------
-- Локальные методы
----------------------

local function setVehicleLightsState(vehicle, state)
    if isResourceRunning("SQW_carsystem") then
        exports.SQW_carsystem:setLightsState(vehicle, state)
    else
        if state == "hwd" or state == "head" then
            state = 2
        else
            state = 1
        end
        vehicle.overrideLights = state
    end
end

-- Устанавливает нужное состояние фар без анимации
local function handleVehicleSteamIn(vehicle)
    if not isElement(vehicle) or not Config.animatedLightsVehicles[vehicle:getData("vehicle:model")] then
        return
    end
    local state = vehicle:getData("animatedLightsState")
    LightsAnim.cancelSpecialAnimation(vehicle)
    if state == "hwd" or state == "head" then
        LightsAnim.startSpecialAnimation(vehicle, nil, "enable")
    else
        LightsAnim.startSpecialAnimation(vehicle, nil, "disable")
    end
    setVehicleLightsState(vehicle, state)
end

----------------------
-- Глобальные методы
----------------------

-- Вызывается скриптом, управляющим светом
-- Запуск света со специальной анимацией
-- state = "head", "hwd", "off"
function setLocalLightsState(state)
    if not localPlayer.vehicle then
        return false
    end
    antiDOSsend("lights", 250, localPlayer.vehicle, "animatedLightsState", state)
    return true
end

--------------------------
-- Обработка событий MTA
--------------------------

addEventHandler("onClientElementDataChange", root, function (dataName, oldValue)
    if source.type ~= "vehicle" or not isElementStreamedIn(source) then
        return
    end
    if dataName ~= "animatedLightsState" then
        return
    end
    local vehicle = source
    if not Config.animatedLightsVehicles[vehicle:getData("vehicle:model")] then
        return
    end
    local state = vehicle:getData(dataName)
	--print (oldValue)
    if oldValue == "off" then
        LightsAnim.startSpecialAnimation(vehicle, function (vehicle)
            setVehicleLightsState(vehicle, vehicle:getData("animatedLightsState"))
        end, "anim_on")
    else
        if state == "head" or state == "hwd" then
            if not LightsAnim.isSpecialAnimationRunning(vehicle) then
                setVehicleLightsState(vehicle, vehicle:getData("animatedLightsState"))
            end
        else
            setVehicleLightsState(vehicle, state)
            if LightsAnim.isSpecialAnimationRunning(vehicle) then
                LightsAnim.cancelSpecialAnimation(vehicle)
                LightsAnim.startSpecialAnimation(vehicle, nil, "disable")
            else
                LightsAnim.startSpecialAnimation(vehicle, nil, "anim_off")
            end
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function ()
    if source.type ~= "vehicle" then
        return
    end
    handleVehicleSteamIn(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElementStreamedIn(vehicle) then
            handleVehicleSteamIn(vehicle)
        end
    end
end)

if Config.debugEnabled then
    addCommandHandler("lightsanim", function (cmd, name)
        if not localPlayer.vehicle then
            outputChatBox("Вы не находитесь в автомобиле")
        end
        LightsAnim.startSpecialAnimation(localPlayer.vehicle, nil, name)
    end)
end
