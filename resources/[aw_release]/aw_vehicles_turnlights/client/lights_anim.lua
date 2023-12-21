-------------------------------------------------------------------
-- Название: lights_anim.lua
-- Описание: Анимация мигания поворотников и прочих фонарей авто
-------------------------------------------------------------------

LightsAnim = {}

local animatedVehicles = {}

----------------------
-- Локальные методы
----------------------

local function updateVehicle(vehicle, deltaTime)
    local anim = animatedVehicles[vehicle]
    -- Передний свет
    LightsAnim.setLightState(vehicle, "front", not not getVehicleLightData(vehicle, "front_lights"))

    -- Поворотники

    -- Получение состояния поворотников
    local turnLeftState
    local turnRightState
    if getVehicleLightData(vehicle, "emergency_light") then
        turnLeftState  = true
        turnRightState = true
    else
        turnLeftState  = getVehicleLightData(vehicle, "turn_left")
        turnRightState = getVehicleLightData(vehicle, "turn_right")
    end
    -- Если поворотники активны
    if turnLeftState or turnRightState then
        anim.turnLightsTime = anim.turnLightsTime + deltaTime
        if anim.turnLightsTime > anim.turnLightsInterval then
            anim.turnLightsState = not anim.turnLightsState
            anim.turnLightsTime = 0

            if turnLeftState then
                LightsAnim.setLightState(vehicle, "turn_left", anim.turnLightsState)
            end
            if turnRightState then
                LightsAnim.setLightState(vehicle, "turn_right", anim.turnLightsState)
            end
        end
    else
        anim.turnLightsTime = anim.turnLightsInterval
        anim.turnLightsState = false
    end

    -- Задний ход и тормоза

    local brakeState = false
    local reverseState = false
    if vehicle.controller and vehicle.onGround then
        local movingBackwards, movingFast = isVehicleMovingBackwards(vehicle)
        local accelerateState = vehicle.controller:getControlState("accelerate")
        if movingBackwards then
            brakeState = movingFast and accelerateState
            reverseState = true
            LightsAnim.setLightState(vehicle, "brake", brakeState)
            LightsAnim.setLightState(vehicle, "rear", reverseState)
        else
            brakeState = (movingFast or accelerateState) and vehicle.controller:getControlState("brake_reverse")
            LightsAnim.setLightState(vehicle, "brake", brakeState)
            LightsAnim.setLightState(vehicle, "rear", false)
        end
    else
        LightsAnim.setLightState(vehicle, "brake", false)
        LightsAnim.setLightState(vehicle, "rear", false)
    end

    -- Время специальной анимации
    if anim.specialAnimActive then
        anim.specialAnimTime = anim.specialAnimTime + deltaTime
    end

    -- Вызов обновления кастомных фар
    local customLights = CustomLights[vehicle:getData("vehicle:model")]
    if customLights and customLights.update then
        customLights.update(anim, deltaTime, vehicle)
    end
	
	if Config.strobesVehicle[vehicle:getData("vehicle:model")] then
		if getVehicleSirensOn(vehicle) then
			local ticks = getTickCount()
			local stateTime1 = 600
			local state1 = (ticks - math.floor(ticks / (stateTime1*2)) * stateTime1*2) > stateTime1

			local stateTime2 = 75
			local state2 = (ticks - math.floor(ticks / (stateTime2*2)) * stateTime2*2) > stateTime2
			if state1 then
				LightsAnim.setLightState(vehicle, "strobe_b", state2)
				LightsAnim.setLightState(vehicle, "strobe_r", false)
			else
				LightsAnim.setLightState(vehicle, "strobe_b", false)
				LightsAnim.setLightState(vehicle, "strobe_r", state2)
			end

			local stateTime3 = 100
			local state3 = (ticks - math.floor(ticks / (stateTime3*2)) * stateTime3*2) > stateTime3
			LightsAnim.setLightState(vehicle, "strobe_w", state3)
		else
			LightsAnim.setLightState(vehicle, "strobe_b", false)
			LightsAnim.setLightState(vehicle, "strobe_r", false)
			LightsAnim.setLightState(vehicle, "strobe_w", false)
		end
	end
end

----------------------
-- Глобальные методы
----------------------

-- Добавляет автомобиль в систему анимации
-- Вызывается из lights_main.lua
function LightsAnim.addVehicle(vehicle)
    if not vehicle then
        return
    end
    animatedVehicles[vehicle] = {
        -- Текущее время поворотников
        turnLightsTime = 0,
        -- Интервал мигания поворотников
        turnLightsInterval = Config.defaultTurnLightsInterval,
        -- Текущее состояние поворотников
        turnLightsState = false,

        -- Специальная анимация, запускающаяся различными действиями
        specialAnimActive = false,
        specialAnimTime = 0,

        -- Более короткие функции для изменения состояния фар
        setLightState        = function (...) return LightsAnim.setLightState(vehicle, ...) end,
        getLightState        = function (...) return LightsAnim.getLightState(vehicle, ...) end,
        setLightColor        = function (...) return LightsAnim.setLightColor(vehicle, ...) end,
        getLightColor        = function (...) return LightsAnim.getLightColor(vehicle, ...) end,
        stopSpecialAnimation = function (...) return LightsAnim.stopSpecialAnimation(vehicle, ...) end,
        startSpecialAnimation = function (...) return LightsAnim.startSpecialAnimation(vehicle, ...) end,
    }
    local customLights = CustomLights[vehicle:getData("vehicle:model")]
    if customLights and customLights.init then
        customLights.init(animatedVehicles[vehicle], vehicle)
    end
end

-- Удаляет автомобиль из системы анимации
-- Вызывается из lights_main.lua
function LightsAnim.removeVehicle(vehicle)
    if vehicle and animatedVehicles[vehicle] then
        animatedVehicles[vehicle] = nil
    end
end

function LightsAnim.getVehicleAnim(vehicle)
    if vehicle then
        return animatedVehicles[vehicle]
    end
end

-- Включение/выключение света
function LightsAnim.setLightState(vehicle, name, state)
    local oldState = getVehicleLightProperty(vehicle, name, "state")
    if state ~= oldState then
        local anim = animatedVehicles[vehicle]
        if anim then
            local customLights = CustomLights[vehicle:getData("vehicle:model")]
            if customLights and customLights.stateHandlers and customLights.stateHandlers[name] then
                customLights.stateHandlers[name](anim, state, vehicle)
            end
        end
        setVehicleLightProperty(vehicle, name, "state", state)
    end
end

function LightsAnim.getLightState(vehicle, name)
    return getVehicleLightProperty(vehicle, name, "state")
end

-- Изменение цвета
function LightsAnim.setLightColor(vehicle, name, r, g, b)
    if not r or not g or not b then
        return
    end
    local oldColor = getVehicleLightProperty(vehicle, name, "color")
    if not oldColor or r ~= oldColor[1] or g ~= oldColor[2] or b ~= oldColor[3] then
        setVehicleLightProperty(vehicle, name, "color", {r, g, b})
    end
end

function LightsAnim.getLightColor(vehicle, name)
    return getVehicleLightProperty(vehicle, name, "color")
end

-- Запуск специальной анимации
-- callback - функция, вызываемая после завершения анимации (опционально)
-- data     - параметры анимации (любой тип)
function LightsAnim.startSpecialAnimation(vehicle, callback, data)
    if not vehicle then
        return false
    end
    local anim = animatedVehicles[vehicle]
    if anim then
        anim.specialAnimTime = 0
        anim.specialAnimActive = true
        if type(callback) == "function" then
            anim.specialAnimCallback = callback
        end
        anim.specialAnimData = data
    end
    return true
end

-- Остановка специальной анимации
function LightsAnim.stopSpecialAnimation(vehicle, omitCallback)
    if not vehicle then
        return false
    end
    local anim = animatedVehicles[vehicle]
    if anim then
        if not omitCallback and anim.specialAnimCallback then
            anim.specialAnimCallback(vehicle)
        end
        anim.specialAnimTime = 0
        anim.specialAnimActive = false
        anim.specialAnimCallback = nil
        anim.specialAnimParams = nil
    end
    return true
end

-- Остановка специальной анимации
function LightsAnim.cancelSpecialAnimation(vehicle)
    return LightsAnim.stopSpecialAnimation(vehicle, true)
end

function LightsAnim.isSpecialAnimationRunning(vehicle)
    if not vehicle then
        return false
    end
    local anim = animatedVehicles[vehicle]
    return not not anim and anim.specialAnimActive
end

--------------------------
-- Обработка событий MTA
--------------------------

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for vehicle in pairs(animatedVehicles) do
		if isElementStreamedIn (vehicle) then
			updateVehicle(vehicle, deltaTime)
		end
    end
end)
