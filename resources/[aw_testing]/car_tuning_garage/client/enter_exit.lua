local isTuningActive = false
local currentTuningMarker = nil

-- Зажат ли тормоз при въезде на маркер
local markerBrakeEnabled = false

-- Зажать тормоз, пока не будет нажата любая клавиша
local function brakeUntilKeypress()
    if markerBrakeEnabled then
        return
    end
    markerBrakeEnabled = true
    -- Зажать тормоз
    setPedControlState(localPlayer, "handbrake", true)

    toggleControl("accelerate", false)
    toggleControl("brake_reverse", false)
    setPedControlState(localPlayer, "accelerate", false)
    setPedControlState(localPlayer, "brake_reverse", false)

    -- Отпустить тормоз по нажатию любой клавиши
    local function keypress(key, down)
        if not down then
            markerBrakeEnabled = false
            toggleControl("accelerate", true)
            toggleControl("brake_reverse", true)
            setPedControlState(localPlayer, "handbrake", false)
            removeEventHandler("onClientKey", root, keypress)
        end
    end
    addEventHandler("onClientKey", root, keypress)
end

-- Вернуть управление при выключении ресурса
addEventHandler("onClientResourceStop", resourceRoot, function ()
    if markerBrakeEnabled then
        toggleControl("accelerate", true)
        toggleControl("brake_reverse", true)
        setPedControlState(localPlayer, "handbrake", false)
    end
end)

function enterTuning(marker)
    if isTuningActive then
        return
    end

    currentTuningMarker = marker
    triggerServerEvent("playerEnterTuning", resourceRoot, marker.position.x, marker.position.y, marker.position.z)
end

function exitTuning()
    if not isTuningActive then
        return
    end
    -- Скрыть интерфейс
    showTuningUI(false)
    showChat(true)
    hud = exports.aw_interface_hud:anim_false()
    radar = exports.aw_interface_radar:anim_false()
    speedometer = exports.aw_interface_speedometer:anim_false()
    fadeCamera(false, 0)
    
    -- Очистить корзину и сбросить превью
    clearComponentsOrder()
    disableComponentsPreview()
    triggerServerEvent("playerExitTuning", resourceRoot)
end

-- Обработка входа в тюнинг
addEvent("playerEnterTuning", true)
addEventHandler("playerEnterTuning", resourceRoot, function ()
    if not localPlayer.vehicle then
        handleTuningExit()
        return
    end
    GarageObject.dimension = localPlayer.dimension
    GarageObject.interior  = localPlayer.interior

    addEventHandler("onClientElementDestroy", localPlayer.vehicle, exitTuning)

    toggleAllControls(false, true)
    CameraManager.start()
    setupComponentsPreview()
    showTuningUI(true)
    showChat(false)
    hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()
    isTuningActive = true
	setElementData(localPlayer, "showHud", "off")

    if isResourceRunning("freeroam") then
        exports.freeroam:pressHWDs()
    end
    setTimer(function ()
        if localPlayer.vehicle and isTuningActive then
            localPlayer.vehicle.frozen = true
        end
    end, 3000, 1)
end)

local function handleTuningExit(wasted, buying)
    if not isTuningActive then
        return
    end

    if localPlayer.vehicle then
        removeEventHandler("onClientElementDestroy", localPlayer.vehicle, exitTuning)
    end
    -- Телепортировать игрока к выходу
    if not wasted and currentTuningMarker then
        if localPlayer.vehicle then
            localPlayer.vehicle.frozen = false
            localPlayer.vehicle.position = currentTuningMarker.position + Vector3(0, 0, 1)
            setElementRotation(localPlayer.vehicle, 0, 0, currentTuningMarker.angle)
            localPlayer.vehicle.velocity = Vector3(0, 0.01, 0)

            setTimer(function ()
                localPlayer.vehicle.frozen = false
            end, 50, 1)
        else
            localPlayer.position = currentTuningMarker.position
            localPlayer.rotaion = Vector3(0, 0, currentTuningMarker.angle)
        end
    end
    setElementData(localPlayer, "showHud", "on")
    currentTuningMarker = nil
    showTuningUI(false)
    showChat(true)
    hud = exports.aw_interface_hud:anim_false()
    radar = exports.aw_interface_radar:anim_false()
    speedometer = exports.aw_interface_speedometer:anim_false()
    CameraManager.stop()

    if isResourceRunning("freeroam") then
        exports.freeroam:pressLightsOff()
    end
    isTuningActive = false
    toggleAllControls(true, true)
    fadeCamera(true, 1)
end

-- Обработка выхода из тюнинга
addEvent("playerExitTuning", true)
addEventHandler("playerExitTuning", resourceRoot, handleTuningExit)
addEventHandler("onClientResourceStop", resourceRoot, function ()
    handleTuningExit()
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    GarageObject = createObject(Config.tuningGarageModel, Config.tuningGaragePosition)
    GarageObject.dimension = 1337
    GarageObject.interior = Config.tuningInterior

    for i, markerData in ipairs(Config.tuningMarkers) do
        local marker = createMarker(markerData.position - Vector3(0, 0, 1), "cylinder", Config.tuningMarkerRadius, unpack(Config.tuningMarkerColor))
        local blip = createBlipAttachedTo(marker, 14)
        blip.visibleDistance = 700
        marker:setData("tuningMarkerData", markerData, false)
    end
end)

-- Тестовая команда для входа в тюнинг
if Config.debugEnableTuningCommand then
    addCommandHandler(Config.debugTuningCommand, function ()
        enterTuning(Config.tuningMarkers[1])
    end)
end

addEventHandler("onClientMarkerHit", resourceRoot, function (player)
    if player ~= localPlayer then
        return
    end
    local markerData = source:getData("tuningMarkerData")
    if not markerData then
        return false
    end
    local verticalDistance = localPlayer.position.z - source.position.z
    if verticalDistance > 5 or verticalDistance < -1 then
        return
    end
    if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
        brakeUntilKeypress()
        enterTuning(markerData)
    end
end)
