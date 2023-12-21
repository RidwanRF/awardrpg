
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

previewVehicle = 0
local freezeTimer

local currentColor = {255, 255, 255, 255, 255, 255}
local currentRegion = 00

local function isVehicleModelLoaded(vehicle)
    return not not getVehicleComponentPosition(vehicle, "wheel_rf_dummy")
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
        end, 50, 50)
    end
end

function setPreviewVehicleColor(isFirst, r, g, b)
    local r1, g1, b1, r2, g2, b2 = getCarColor()
    if isFirst then
        r1, g1, b1 = r, g, b
    else
        r2, g2, b2 = r, g, b
    end
    currentColor = {r1, g1, b1, r2, g2, b2}
    updateVehicleColor()
end

function setDoorState(nameDoor, status, timer)
    if isElement(previewVehicle) then
        local veh = previewVehicle
        setVehicleDoorOpenRatio (veh, nameDoor, status, timer)
    end 
end

addEventHandler( "onClientKey", root, 
    function(button) 
        if getElementData(localPlayer, "mouseWheelRL") == true then
            if isElement(previewVehicle) then
                local veh = previewVehicle
                local _, _, z = getElementRotation(veh)
                if button == "mouse_wheel_down" then
                    setElementRotation(veh, 0, 0, z - 5)
                elseif button == "mouse_wheel_up" then
                    setElementRotation(veh, 0, 0, z + 5)
                end   
            end
        end
    end
)

function _loadPreviewVehicleColor(...)
    currentColor = {...}
    updateVehicleColor()
end

function updateVehicleColor()
    if not isElement(previewVehicle) then
        return
    end
    previewVehicle:setColor(unpack(currentColor))
end

function getCarColor()
    if not isElement(previewVehicle) then
        return
    end
    return previewVehicle:getColor(true)
end

function getCarModel()
    if not isElement(previewVehicle) then
        return
    end
   -- return previewVehicle.model
    return previewVehicle:getData("vehicle:model")
end

function spawnDemoCar(model, position, rotation)
    local fx, fy, fz = position.x, position.y, position.z
    -- Создание автомобиля
    local vehicle = previewVehicle
    local numberplate
    if isElement(vehicle) then
        destroyElement(vehicle)
    end
    vehicle = createVehicle(model, fx, fy, fz + 0.7)
    setElementDimension(vehicle, getElementDimension(localPlayer))
    setElementInterior(vehicle, getElementInterior(localPlayer))
    setVehicleDamageProof(vehicle, true)
    vehicle.dimension = localPlayer.dimension
    vehicle.interior = localPlayer.interior
    vehicle.rotation = rotation

    waitForVehicleLoading(vehicle, function (vehicle)
        if not isElement(vehicle) then
            return
        end
        if isResourceRunning("car_wheels_system") then
            local wx, wy, wz = exports.car_wheels_system:getVehicleDefaultWheelPosition(vehicle, "wheel_lf_dummy")
            local wheelsRadius = exports.car_wheels_system:getVehicleDefaultWheelsRadius(vehicle)
            if wz and wheelsRadius then
                setElementPosition(vehicle, fx, fy, fz + wheelsRadius * 0.5 - wz - 0.05)
            end
        end
        currentColor = {vehicle:getColor(true)}
        updateVehicleColor(vehicle)
        updateVehicleNumberplate()
        updateColorpickerColor()
    end)

    updateVehicleColor()
    vehicle.frozen = false

    if isTimer(freezeTimer) then
        killTimer(freezeTimer)
    end
    freezeTimer = setTimer(function ()
        if isElement(vehicle) then
            vehicle.frozen = true
            updateVehicleNumberplate()
        end
    end, 1000, 1)

    return vehicle
end

function stopCarPreview()
    if isElement(previewVehicle) then
        destroyElement(previewVehicle)
    end
    previewVehicle = nil
end

function showPreviewCar(model)
    local carshopInterior = getCarshopInterior()
    previewVehicle = spawnDemoCar(model, carshopInterior.vehiclePosition, carshopInterior.vehicleRotation or Vector3())
end

function getPreviewVehiclePosition()
    if isElement(previewVehicle) then
        return previewVehicle.position
    else
        return getCarshopInterior().vehiclePosition + 0.8
    end
end

function updateVehicleNumberplate()
    if isElement(previewVehicle) then
        local template = "a-a000aa"
        local region = tostring(currentRegion)
        -- Отдельный шаблон для мотоциклов
        if isModelMotorcycle(previewVehicle.model) then
            template = "c-0000aa"
            -- Обрезать строку с конца, чтобы получался корректный регион
            region = string.sub(region, -2, -1)
        end
        previewVehicle:setData("job.nomer", template .. region)
    end
end

function setPreviewNumberplateRegion(region)
    if not isElement(previewVehicle) then
        return
    end
    currentRegion = region
    updateVehicleNumberplate()
end
