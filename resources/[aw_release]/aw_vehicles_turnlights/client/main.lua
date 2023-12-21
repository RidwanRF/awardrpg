local lightTypes = {
    {name = "turn_left",  color = {1, 0.5, 0}},
    {name = "turn_right", color = {1, 0.5, 0}},
    {name = "rear",       color = {0.8, 0.8, 0.8}},
    {name = "brake",      color = {1, 0, 0}},

    {name = "strobe_b",   brightness = 1, color = {0, 0, 1}},
    {name = "strobe_r",   brightness = 1, color = {1, 0, 0}},
    {name = "strobe_w",   brightness = 1, color = {1, 1, 1}},
}

local validLightNames = {
    emergency_light = true
}
for i, light in ipairs(lightTypes) do validLightNames[light.name] = true end

local loadedVehicleLights = {}
local localLightsState = {}

local autoDisableTime = 1200
local leftPressTime = 0
local rightPressTime = 0
local hornPressTime = 0

addCommandHandler("lanim", function ()
    triggerServerEvent("syncSpecialAnim", localPlayer.vehicle)
end)

addEvent("syncSpecialAnim", true)
addEventHandler("syncSpecialAnim", root, function ()
    if loadedVehicleLights[source] then
        loadedVehicleLights[source].time = 0
        loadedVehicleLights[source].specialAnimation = true
    end
end)

local function isVehicleMovingBackwards(vehicle)
    if vehicle.velocity.length < 0.05 then
        return false, false
    end

    local direction = vehicle.matrix.forward
    local velocity = vehicle.velocity.normalized

    local dot = direction.x * velocity.x + direction.y * velocity.y
    local det = direction.x * velocity.y - direction.y * velocity.x

    local angle = math.deg(math.atan2(det, dot))
    return math.abs(angle) > 120, true
end

local function getVehicleLightState(vehicle, name)
    if vehicle.controller == localPlayer then
        return localLightsState[name]
    end
    return vehicle:getData(name)
end

-- Обновление поворотников
function updateVehicleLights(vehicle, deltaTime)
    local lights = loadedVehicleLights[vehicle]

    if getVehicleSirensOn(vehicle) then
        local ticks = getTickCount()
        local stateTime1 = 600
        local state1 = (ticks - math.floor(ticks / (stateTime1*2)) * stateTime1*2) > stateTime1

        local stateTime2 = 75
        local state2 = (ticks - math.floor(ticks / (stateTime2*2)) * stateTime2*2) > stateTime2
        if state1 then
            setVehicleCustomLightState(vehicle, "strobe_b", state2)
            setVehicleCustomLightState(vehicle, "strobe_r", false)
        else
            setVehicleCustomLightState(vehicle, "strobe_b", false)
            setVehicleCustomLightState(vehicle, "strobe_r", state2)
        end

        local stateTime3 = 100
        local state3 = (ticks - math.floor(ticks / (stateTime3*2)) * stateTime3*2) > stateTime3
        setVehicleCustomLightState(vehicle, "strobe_w", state3)
    end

    if lights.specialAnimation then
        local lightsTable = LightsTable[vehicle:getData("vehicle:model")]
        if lightsTable and lightsTable.specialAnimation then
            lightsTable.specialAnimation(vehicle, deltaTime, lights)
            return
        else
            lights.specialAnimation = false
        end
    end

    local turnLeftState
    local turnRightState
    if getVehicleLightState(vehicle, "emergency_light") then
        turnLeftState = true
        turnRightState = true
    else
        turnLeftState = not not getVehicleLightState(vehicle, "turn_left")
        turnRightState = not not getVehicleLightState(vehicle, "turn_right")
    end

    -- Reverse & brake
    local brakeState = false
    local reverseState = false
    if vehicle.controller and vehicle.onGround then
        local movingBackwards, movingFast = isVehicleMovingBackwards(vehicle)

        if movingBackwards then
            brakeState = vehicle.controller:getControlState("accelerate") and movingFast
            reverseState = true
            setVehicleCustomLightState(vehicle, "brake", brakeState)
            setVehicleCustomLightState(vehicle, "rear", reverseState)
        else
            brakeState = vehicle.controller:getControlState("brake_reverse") and movingFast
            setVehicleCustomLightState(vehicle, "brake", brakeState)
            setVehicleCustomLightState(vehicle, "rear", false)
        end
    else
        setVehicleCustomLightState(vehicle, "brake", false)
        setVehicleCustomLightState(vehicle, "rear", false)
    end

    if turnLeftState or turnRightState then
        lights.time = lights.time + deltaTime
        if lights.time > lights.turnLightsDelay then
            lights.state = not lights.state
            if turnLeftState then
                setVehicleCustomLightState(vehicle, "turn_left", lights.state)
            end
            if turnRightState then
                setVehicleCustomLightState(vehicle, "turn_right", lights.state)
            end
            lights.time = 0
        end
    end
    if LightsTable[vehicle:getData("vehicle:model")] then
        if LightsTable[vehicle:getData("vehicle:model")].update then
            LightsTable[vehicle:getData("vehicle:model")].update(vehicle, deltaTime, lights, turnLeftState, turnRightState, brakeState, reverseState)
        end
    end
end

function setVehicleCustomLightState(vehicle, name, state, color)
    if not vehicle or not loadedVehicleLights[vehicle] then
        return
    end
    local shader = loadedVehicleLights[vehicle].shaders[name]
    if not shader then
        return
    end
    shader.element:setValue("enabled", state)
    if color then
        shader.element:setValue("turnColor", color)
    end
end

-- Создание шейдеров для поворотников для машины
function createVehicleLights(vehicle)
    if not isElement(vehicle) or vehicle.type ~= "vehicle" then
        outputDebugString("Bad argument @ 'createVehicleLights' [Expected vehicle]", 2)
        return false
    end
    -- Если для машины уже созданы шейдеры
    if loadedVehicleLights[vehicle] then
        return false
    end
    local lightsTable = LightsTable[vehicle:getData("vehicle:model")] or {}

    loadedVehicleLights[vehicle] = {
        shaders = {},
        time = 0,
        turnLightsDelay = lightsTable.turnLightsDelay or 0.6
    }

    local lightsList = {}

    for i, light in ipairs(lightTypes) do
        table.insert(lightsList, light)
    end

    if lightsTable.lights then
        for i, light in ipairs(lightsTable.lights) do
            table.insert(lightsList, light)
        end
    end

    for i, light in ipairs(lightsList) do
        local shader = dxCreateShader("assets/shader.fx")
        local material = light.material or "shader_"..light.name.."_*"

        shader:setValue("turnColor", light.color)
        shader:setValue("brightness", light.brightness or 0.35)
        shader:setValue("enabled", false)
        shader:applyToWorldTexture(material, vehicle)
        loadedVehicleLights[vehicle].shaders[light.name] = {
            element = shader,
            material = material
        }
    end
end

-- Удаление шейдеров
function destroyVehicleLights(vehicle)
    if not loadedVehicleLights[vehicle] then
        return false
    end

    for material, shader in pairs(loadedVehicleLights[vehicle].shaders) do
        if isElement(shader.element) then
            destroyElement(shader.element)
        end
    end

    loadedVehicleLights[vehicle] = nil
end

-- Создание и удаление шейдеров

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local shader = dxCreateShader("assets/replace.fx")
    shader:applyToWorldTexture("coronastar")

    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        createVehicleLights(vehicle)
    end
end)

local function handleVehicleCreate()
    if source and source.type == "vehicle" then
        createVehicleLights(source)
    end
end

local function handleVehicleDestroy()
    if source and source.type == "vehicle" then
        destroyVehicleLights(source)
    end
end

addEventHandler("onClientElementStreamIn",  root, handleVehicleCreate)
addEventHandler("onClientElementDestroy",   root, handleVehicleDestroy)
addEventHandler("onClientElementStreamOut", root, handleVehicleDestroy)
addEventHandler("onClientVehicleExplode",   root, handleVehicleDestroy)

local function handleLightsStateChange(vehicle, name, value)
    if not value then
        if name == "turn_left" or name == "turn_right" then
            setVehicleCustomLightState(vehicle, name, false)
        elseif name == "emergency_light" then
            setVehicleCustomLightState(vehicle, "turn_left", false)
            setVehicleCustomLightState(vehicle, "turn_right", false)
        end
        if name == "strobes" and not value then
            setVehicleCustomLightState(vehicle, "strobe_r", false)
            setVehicleCustomLightState(vehicle, "strobe_w", false)
            setVehicleCustomLightState(vehicle, "strobe_b", false)
        end
        if loadedVehicleLights[vehicle] then
            loadedVehicleLights[vehicle].time = 0
            loadedVehicleLights[vehicle].state = false
        end
    end
    if LightsTable[vehicle:getData("vehicle:model")] and LightsTable[vehicle:getData("vehicle:model")].handleLightsState then
        LightsTable[vehicle:getData("vehicle:model")].handleLightsState(vehicle, name, value)
    end
end

local function setLocalLightsState(name, value)
    localLightsState[name] = value
    handleLightsStateChange(localPlayer.vehicle, name, value)
end

function setLocalLightsStateVeh(veh, name, value)
    localLightsState[name] = value
    handleLightsStateChange(veh, name, value)
end

-- Обновление состояния фонарей
--[[addEventHandler("onClientPreRender", root, function (deltaTime)
    deltaTime = deltaTime / 1000
    for vehicle in pairs(loadedVehicleLights) do
        updateVehicleLights(vehicle, deltaTime)
    end
end)]]

addEventHandler("onClientElementDataChange", root, function (dataName, oldValue)
    if source.type ~= "vehicle" or not isElementStreamedIn(source) or not validLightNames[dataName] then
        return
    end
    if source.controller == localPlayer then
        return
    end
    handleLightsStateChange(source, dataName, source:getData(dataName))
end)

local hornTimer

-- Управление светом
addEventHandler("onClientKey", root, function (button, state)
    if not localPlayer.vehicle or localPlayer.vehicle.controller ~= localPlayer then
        return
    end

    if button == "a" then
        if state then
            leftPressTime = getTickCount()
        else
            if getTickCount() - leftPressTime > autoDisableTime then
                setLocalLightsState("turn_left", false)
            end
        end
    elseif button == "d" then
        if state then
            rightPressTime = getTickCount()
        else
            if getTickCount() - rightPressTime > autoDisableTime then
                setLocalLightsState("turn_right", false)
            end
        end
    end

    if state and getKeyState("lctrl") then
        if button == "a" then

            setLocalLightsState("turn_right", false)
            setLocalLightsState("turn_left", not localLightsState["turn_left"])
            cancelEvent()
        elseif button == "d" then
            setLocalLightsState("turn_left", false)
            setLocalLightsState("turn_right", not localLightsState["turn_right"])
            cancelEvent()
        elseif button == "s" then
            setLocalLightsState("turn_left", false)
            setLocalLightsState("turn_right", false)
            setLocalLightsState("emergency_light", not localLightsState["emergency_light"])
            cancelEvent()
        end
        return
    end
end)

setTimer(function ()
    if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
        for name, value in pairs(localLightsState) do
            localPlayer.vehicle:setData(name, not not value, true)
        end
    end
end, 800, 0)

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function (vehicle, seat)
    if seat == 0 then
        localLightsState = {}
    end
end)

addEventHandler("onClientPlayerVehicleExit", localPlayer, function (vehicle, seat)
    localLightsState = {}
end)
