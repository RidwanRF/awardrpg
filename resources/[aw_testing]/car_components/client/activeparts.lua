-- Название даты для хранения состояния
local COMPONENTS_STATE_DATA = "active_components_state"
-- Длительность анимации
local ANIMATION_DURATION = 1000
-- Интервал, по которому проверяется скорость
local SPEED_CHECK_DELAY = 1000
-- Количество проверок скорости, которые игнорируются после открытия спойлера
local IGNORE_TIMES = 7

local animatedVehicles = {}
local ignoreVehiclesTime = {}

-- Проверяет, есть ли конфликты с другими спойлерами или компонентами
local function isAnimationAllowed(vehicle)
    local conflictUpgradeSlots = AnimationParams[vehicle.model].conflictUpgradeSlots
    if conflictUpgradeSlots then
        for i, slot in ipairs(conflictUpgradeSlots) do
            if vehicle:getUpgradeOnSlot(slot) ~= 0 then
                return false
            end
        end
    end

    local conflictParts = AnimationParams[vehicle.model].conflictParts
    if conflictParts then
        for i, name in ipairs(conflictParts) do
            if vehicle:getComponentVisible(name) then
                return false
            end
        end
    end
    return true
end

-- Обновляет состояние и запускает анимацию
local function updateVehicleComponentsState(vehicle, state)
    if not isElement(vehicle) or not AnimationParams[vehicle.model] then
        return
    end
    -- Проверка конфликтов
    if not isAnimationAllowed(vehicle) then
        return
    end
    if vehicle:getData("brake_spoiler_state") then
        vehicle:setData("active_components_state", false, false)
        ignoreVehiclesTime[vehicle] = nil
        return
    end
    -- Если состояние state уже установлено
    if not not vehicle:getData(COMPONENTS_STATE_DATA) == not not state then
        return
    end
    -- Состояние активных компонентов
    local state = not not state
    vehicle:setData(COMPONENTS_STATE_DATA, state, false)
    -- Прогресс анимации от 0 до 1
    local progress = 1
    if state then
        progress = 0
    end
    if animatedVehicles[vehicle] then
        progress = animatedVehicles[vehicle].progress
    end

    -- Направление движения анимации
    local direction = -1
    if state then
        direction = 1
    end

    -- Список анимируемых компонентов
    local animationParams = AnimationParams[vehicle.model]
    if not animationParams.spoilerFunc then
        return
    end

    -- Таблица анимируемых в данный момент автомобилей
    animatedVehicles[vehicle] = {
        progress  = progress,
        direction = direction,
        callback  = animationParams.spoilerFunc
    }
end

local function getDoorOpenRatio(vehicle, id)
    local ratio = vehicle:getDoorOpenRatio(id)
    if not ratio or vehicle:getDoorState(id) == 4 then
        vehicle:setDoorOpenRatio(id, 0)
        ratio = 0
    end
    return ratio
end

local function animateVehicleComponents(vehicle, animation, deltaTime)
    if not isElement(vehicle) or vehicle:getData("brake_spoiler_state") then
        animatedVehicles[vehicle] = nil
		return
    end
    -- Обновить прогресс
    animation.progress = math.max(0, math.min(1, animation.progress + deltaTime * animation.direction))
    animation.callback(vehicle, getDoorOpenRatio(vehicle, 1), animation.progress)
    -- Проверить, закончилась ли анимация
    if animation.direction == 1 and animation.progress >= 1 then
        animatedVehicles[vehicle] = nil
    elseif animation.direction == -1 and animation.progress <= 0 then
        animatedVehicles[vehicle] = nil
    end
end

addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000

    for vehicle, animation in pairs(animatedVehicles) do
        animateVehicleComponents(vehicle, animation, deltaTime)
    end
end)

function isVehicleActivepartsAnimated(vehicle)
    return not not (vehicle and animatedVehicles[vehicle])
end

function getVehicleSpeed(vehicle)
    local vx, vy, vz = getElementVelocity(vehicle)
    return ((vx^2 + vy^2 + vz^2)^(0.5))*180
end

function resetVehicleAnimationIgnoreTimes(vehicle)
    if ignoreVehiclesTime[vehicle] then
        ignoreVehiclesTime[vehicle] = 1
    end
end

setTimer(function ()
    local streamedVehicles = getElementsByType("vehicle", root, true)

    for i, vehicle in ipairs(streamedVehicles) do
        if AnimationParams[vehicle.model] then
            if not ignoreVehiclesTime[vehicle] then
                -- Открыть спойлер, если набрана достаточная скорость
                if getVehicleSpeed(vehicle) > Config.minSpoilerSpeed then
                    updateVehicleComponentsState(vehicle, true)
                    -- Временно игнорировать проверку скорости, чтобы спойлер не закрылся сразу
                    ignoreVehiclesTime[vehicle] = IGNORE_TIMES
                else
                    updateVehicleComponentsState(vehicle, false)
                end
            else
                -- Счётчик игнорирования проверок скорости для автомобиля
                ignoreVehiclesTime[vehicle] = ignoreVehiclesTime[vehicle] - 1
                if ignoreVehiclesTime[vehicle] <= 0 then
                    ignoreVehiclesTime[vehicle] = nil
                end
            end
        end
    end
end, SPEED_CHECK_DELAY, 0)
