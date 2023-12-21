local isActive = false
local currentMarker = nil

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

function enterPaintGarage(marker)
    if isActive then
        return
    end

    currentMarker = marker
    triggerServerEvent("playerEnterPaintGarage", resourceRoot, marker.position.x, marker.position.y, marker.position.z)
end

function exitPaintGarage()
    if not isActive then
        return
    end
    triggerServerEvent("playerExitPaintGarage", resourceRoot)
end

-- Обработка входа в тюнинг
addEvent("playerEnterPaintGarage", true)
addEventHandler("playerEnterPaintGarage", resourceRoot, function ()
    if not localPlayer.vehicle then
        handleTuningExit()
        return
    end
    GarageObject.dimension = localPlayer.dimension
    GarageObject.interior  = localPlayer.interior

    addEventHandler("onClientElementDestroy", localPlayer.vehicle, exitPaintGarage)

    toggleAllControls(false, true)
    CameraManager.start()
    setupColorPreview()
    showPaintUI(true)
    isActive = true
    showChat(false)
    hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()

    setTimer(function ()
        if localPlayer.vehicle and isActive then
            localPlayer.vehicle.frozen = true
        end
    end, 3000, 1)
end)

local function handleTuningExit(wasted, buying)
    if not isActive then
        return
    end

    if localPlayer.vehicle then
        removeEventHandler("onClientElementDestroy", localPlayer.vehicle, exitPaintGarage)
    end
    -- Телепортировать игрока к выходу
    if not wasted and currentMarker then
        local targetPosition = currentMarker.position
        local targetRotation = Vector3(0, 0, currentMarker.angle)
        if localPlayer.vehicle then
            if localPlayer.vehicle.vehicleType == "Bike" then
                localPlayer.vehicle.frozen = true
                setTimer(function ()
                    localPlayer.vehicle.position = targetPosition + Vector3(0, 0, 1)
                    setElementRotation(localPlayer.vehicle, targetRotation)
                    setCameraTarget(localPlayer)
                end, 50, 1)

                setTimer(function ()
                    localPlayer.vehicle.velocity = Vector3()
                    localPlayer.vehicle.frozen = false
                end, 500, 1)
            else
                localPlayer.vehicle.position = targetPosition + Vector3(0, 0, 1)
                setElementRotation(localPlayer.vehicle, targetRotation)
                setTimer(function ()
                    setCameraTarget(localPlayer)
                    localPlayer.vehicle.frozen = false
                    localPlayer.vehicle.velocity = Vector3()
                end, 50, 1)
            end
        else
            localPlayer.position = targetPosition
            localPlayer.rotaion = targetRotation
        end
    end
    currentMarker = nil
    -- Скрыть интерфейс
    resetVehiclePreview()
    showPaintUI(false)
    CameraManager.stop()
    hud = exports.aw_interface_hud:anim_false()
    radar = exports.aw_interface_radar:anim_false()
    speedometer = exports.aw_interface_speedometer:anim_false()
    showChat(true)

    isActive = false
    toggleAllControls(true, true)
    fadeCamera(true, 1)
end

-- Обработка выхода из тюнинга
addEvent("playerExitPaintGarage", true)
addEventHandler("playerExitPaintGarage", resourceRoot, handleTuningExit)
addEventHandler("onClientResourceStop", resourceRoot, function ()
    handleTuningExit()
	if (localPlayer.vehicle) then
		localPlayer.vehicle.frozen = false
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    GarageObject = createObject(Config.paintGarageModel, Config.paintGaragePosition)
    GarageObject.dimension = 1337
    GarageObject.interior = Config.garageInterior

    for i, markerData in ipairs(Config.paintGarageMarkers) do
        local marker = createMarker(
            markerData.position - Vector3(0, 0, 1),
            "cylinder",
            Config.garageMarkerRadius,
            unpack(Config.garageMarkerColor)
        )
        local blip = createBlipAttachedTo(marker, Config.blipId)
        blip.visibleDistance = 700
        marker:setData("garageMarkerData", markerData, false)
    end
end)

addEventHandler("onClientMarkerHit", resourceRoot, function (player)
    if player ~= localPlayer then
        return
    end
    local markerData = source:getData("garageMarkerData")
    if not markerData then
        return false
    end
    local verticalDistance = localPlayer.position.z - source.position.z
    if verticalDistance > 5 or verticalDistance < -1 then
        return
    end
    if localPlayer.vehicle and localPlayer.vehicle.controller == localPlayer then
        brakeUntilKeypress()
        enterPaintGarage(markerData)
    end
end)

