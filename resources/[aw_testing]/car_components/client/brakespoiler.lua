local ANIMATION_SPEED = 5
local SPOILER_STATE_DATA = "brake_spoiler_state"

BrakeSpoilerParams = {
    [526] = {
        name = "spoiler0",
        distY = -0.14,
        distZ = -0.24,
        rotX = -35,
        stockY = -1.775-0.037,
        stockZ = 0.527-0.114,
        stockRotX = -15
    }
}

local animatedVehicles = {}

local function updateVehicleSpoilerState(vehicle, state)
    if not isElement(vehicle) or not BrakeSpoilerParams[vehicle.model] then
        return
    end
    -- Если состояние state уже установлено
    if not vehicle:getData(SPOILER_STATE_DATA) == not not state then
        return
    end
    -- Состояние активных компонентов
    local state = not not state
    vehicle:setData(SPOILER_STATE_DATA, not state, false)
    -- Прогресс анимации от 0 до 1
    local progress = 0
    if state then
        progress = 1
    end
    if animatedVehicles[vehicle] then
        progress = animatedVehicles[vehicle].progress
    end

    -- Направление движения анимации
    local direction = 1
    if state then
        direction = -1
    end

    -- Список анимируемых компонентов
    local animationParams = BrakeSpoilerParams[vehicle.model]
    local component = {}
    component.name = animationParams.name
    -- Выставить значения по умолчанию
    component.stockX = animationParams.stockX or 0
    component.stockY = animationParams.stockY or 0
    component.stockZ = animationParams.stockZ or 0

    component.distX = animationParams.distX or 0
    component.distY = animationParams.distY or 0
    component.distZ = animationParams.distZ or 0

    component.stockRotX = animationParams.stockRotX or 0
    component.stockRotY = animationParams.stockRotY or 0
    component.stockRotZ = animationParams.stockRotZ or 0

    component.rotX = animationParams.rotX or 0
    component.rotY = animationParams.rotY or 0
    component.rotZ = animationParams.rotZ or 0

    -- Таблица анимируемых в данный момент автомобилей
    animatedVehicles[vehicle] = {
        progress  = progress,
        direction = direction,
        component = component,
    }

    vehicle:setData("active_components_state", true, false)
end

local function animateVehicle(vehicle, animation, deltaTime)
    if not isElement(vehicle) then
        animatedVehicles[vehicle] = nil
        return
    end
    -- Обновить прогресс
    animation.progress = math.max(0, math.min(1, animation.progress + deltaTime * animation.direction * ANIMATION_SPEED))

    local component = animation.component
    vehicle:setComponentPosition(component.name,
        component.stockX + component.distX * animation.progress,
        component.stockY + component.distY * animation.progress,
        component.stockZ + component.distZ * animation.progress)

    vehicle:setComponentRotation(component.name,
        component.stockRotX + component.rotX * animation.progress,
        component.stockRotY + component.rotY * animation.progress,
        component.stockRotZ + component.rotZ * animation.progress)

    -- Проверить, закончилась ли анимация
    if animation.direction == 1 and animation.progress >= 1 then
        animatedVehicles[vehicle] = nil
        vehicle:setData("active_components_state", true, false)
        resetVehicleAnimationIgnoreTimes(vehicle)
    elseif animation.direction == -1 and animation.progress <= 0 then
        animatedVehicles[vehicle] = nil
        vehicle:setData("active_components_state", true, false)
        resetVehicleAnimationIgnoreTimes(vehicle)
    end
end

local function checkVehicle(vehicle)
    if not vehicle.controller then
        return
    end
    local params = BrakeSpoilerParams[vehicle.model]
    if not params then
        return
    end
    if not vehicle:getComponentVisible(params.name) then
        return
    end

    -- Нажат ли тормоз
    local state = getPedControlState(vehicle.controller, "brake_reverse")
               or getPedControlState(vehicle.controller, "handbrake")

    if state and (not vehicle:getData("active_components_state") or getVehicleSpeed(vehicle) < Config.minSpoilerSpeed * 0.25) then
        return
    end
    updateVehicleSpoilerState(vehicle, not state)
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for vehicle, animation in pairs(animatedVehicles) do
        animateVehicle(vehicle, animation, deltaTime)
    end
end)

setTimer(function ()
    local streamedVehicles = getElementsByType("vehicle", root, true)

    for i, vehicle in ipairs(streamedVehicles) do
        checkVehicle(vehicle)
    end
end, 250, 0)
