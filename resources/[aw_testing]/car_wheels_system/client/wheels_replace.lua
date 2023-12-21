-------------------------------------------------------
--
-- Замена колёс на объекты, развал, толщина и радиус
--
-------------------------------------------------------

-- id моделей колёс
local wheelModels = {
    -- Стандартные ID колёс
    1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098,
    -- Дополнительные ID
    1004,1005,1006,1051,1011,1012,1013,1017,1024,1026,1027,1030,1031,1032,1033,1035,1036,1038,1039,1040,1041,1042,1043,1044,1047,1048,1062,1052,1053,1054,1055,1056,1057,1061,
	1063,1067,1068,1088,1090,
}

-- Таблица заменённых колёс
local replacedVehicleWheels = {}

local function isFrontWheel(wheelName)
    return wheelName == "wheel_lf_dummy" or wheelName == "wheel_rf_dummy"
end

local function isLeftWheel(wheelName)
    return wheelName == "wheel_lf_dummy" or wheelName == "wheel_lb_dummy"
end

local function replaceWheel(vehicle, wheelName, id, radius, width, color, offset, prof)
    if not id then
        id = 0
    end
    local vehicleWheels = replacedVehicleWheels[vehicle]
    if id == 0 then
        if vehicleWheels[wheelName] then
            local wheel = vehicleWheels[wheelName]
            if isElement(wheel.object) then
                destroyElement(wheel.object)
            end
            wheel.object = nil
        end
        vehicleWheels[wheelName] = nil
        -- Вылет стоковых колёс
        local x, y, z = getVehicleDefaultWheelPosition(vehicle, wheelName)
        setVehicleComponentPosition(vehicle, wheelName, x * (offset + 1), y, z)
    elseif id ~= 0 then
        if not wheelModels[id] then
            destroyVehicleWheels(vehicle)
            return
        end
        if not vehicleWheels[wheelName] then
            vehicleWheels[wheelName] = {}
            local x, y, z = getVehicleDefaultWheelPosition(vehicle, wheelName)
            setVehicleComponentPosition(vehicle, wheelName, x, y, z)
        end
        local wheel = vehicleWheels[wheelName]
        -- Создание объекта колеса при необходимости
        if not wheel.object then
            wheel.object = createObject(wheelModels[id], vehicle.position)
            -- Если dimension не совпадает, аттач ломается
            wheel.object.dimension = vehicle.dimension
            wheel.object:attach(vehicle)
            wheel.object:setCollisionsEnabled(false)
            wheel.shader_shina = dxCreateShader('assets/shaders/replace.fx', 0, 100)
        else -- ...или просто обновить модель
            wheel.object.model = wheelModels[id]
        end
        setObjectScale(wheel.object, width, radius, radius)
        -- Радиус используется для поднятия колеса по Z
        wheel.radius = radius
        if Config.disableWheelsOffset[vehicle.model] then
            wheel.offsetDisabled = true
        end
        local defaultRadius = Config.overrideWheelsRadius[vehicle.model] or Config.defaultRadius
        local radiusMul = wheel.radius / defaultRadius
        -- Поднятие колеса вверх по Z при изменении радиуса
        applyWheelColor(vehicle, wheel.object, {unpack(color)})

        if prof then
            for i, v in pairs(Config.size) do
                if prof == i then
                    prof = v
                end
            end
            wheel.shader_shina:setValue ("size", prof)
        end

        wheel.radiusOffsetZ = -defaultRadius / 2 + wheel.radius / 2 - prof
        
        wheel.shader_shina:setValue("gTexture", exports['r_tires']:getVehicleTire(vehicle))
        for i, v in ipairs (Config.texturesName) do
            wheel.shader_shina:applyToWorldTexture(v, wheel.object)
        end
    end

    setVehicleComponentVisible(vehicle, wheelName, id == 0)
end

-- export-фукнция
function getVehicleDefaultWheelsRadius(vehicle)
    if not isElement(vehicle) then
        return false
    end
    return Config.overrideWheelsRadius[vehicle.model] or Config.defaultRadius
end

-- Создание/обновление колёс автомобиля
function createVehicleWheels(vehicle)
    if not isElement(vehicle) then
        return
    end
    if not replacedVehicleWheels[vehicle] then
        replacedVehicleWheels[vehicle] = {}
    end
    -- Модель колёс
    local wheels = vehicle:getData("wheels")
    -- Радиус по умолчанию
    local radius = vehicle:getData("wheels_radius")
    if not radius then
        radius = getVehicleDefaultWheelsRadius(vehicle)
        vehicle:setData("wheels_radius", radius, false)
    end
    -- толщина
    local widthFront = vehicle:getData("wheels_width_f")
    if not widthFront then
        widthFront = Config.defaultWidth
        vehicle:setData("wheels_width_f", widthFront, false)
    end
    local widthRear = vehicle:getData("wheels_width_r")
    if not widthRear then
        widthRear = Config.defaultWidth
        vehicle:setData("wheels_width_r", widthRear, false)
    end
    -- Вылет по умолчанию
    if not vehicle:getData("wheels_offset_f") then
        vehicle:setData("wheels_offset_f", 0, false)
    end
    if not vehicle:getData("wheels_offset_r") then
        vehicle:setData("wheels_offset_r", 0, false)
    end
    local color = {getVehicleWheelsColor(vehicle)}
    -- Вылет колёс
    local offsetFront = vehicle:getData("wheels_offset_f") or 0
    local offsetRear = vehicle:getData("wheels_offset_r") or 0

    local sProf = vehicle:getData("wheels_prof") or 0

    -- Замена каждого колеса
    replaceWheel(vehicle, "wheel_rf_dummy", wheels, radius, widthFront, color, offsetFront, sProf)
    replaceWheel(vehicle, "wheel_lf_dummy", wheels, radius, widthFront, color, offsetFront, sProf)
    replaceWheel(vehicle, "wheel_lb_dummy", wheels, radius, widthRear,  color, offsetRear, sProf)
    replaceWheel(vehicle, "wheel_rb_dummy", wheels, radius, widthRear,  color, offsetRear, sProf)
    -- Костыль для скрытия задних колёс на Yosemite
end

function destroyVehicleWheels(vehicle)
    if not vehicle or not replacedVehicleWheels[vehicle] then
        return
    end
    -- Удаление объектов колёс
    for name, wheel in pairs(replacedVehicleWheels[vehicle]) do
        if isElement(wheel.object) then
            destroyElement(wheel.object)
        end
        if isElement(wheel.shader_shina) then
            destroyElement(wheel.shader_shina)
        end
        wheel.shader_shina = nil
    end
    replacedVehicleWheels[vehicle] = nil

    -- Удалить наложенный цвет
    removeVehicleShaders(vehicle)
end

addEventHandler("onClientPreRender", root, function ()
    if replacedVehicleWheels then
        for vehicle, wheels in pairs(replacedVehicleWheels) do
            if not isElement(vehicle) then
                destroyVehicleWheels(vehicle)
            else
                if isElementStreamedIn (vehicle) then
                    local wheelsHidden = (vehicle == localPlayer.vehicle and getCameraViewMode() == 0)
                    -- Угол развала
                    local razvalFront = vehicle:getData("wheels_razval_f") or 0
                    local razvalRear = vehicle:getData("wheels_razval_r") or 0
                    -- Вылет колёс
                    local offsetFront = vehicle:getData("wheels_offset_f") or 0
                    local offsetRear = vehicle:getData("wheels_offset_r") or 0
                    -- Вращение автомобиля
                    local vx, vy, vz = getElementRotation(vehicle)
                    local wy = math.cos(math.rad(vx))
                    local wz = math.sin(math.rad(vx))

                    for name, wheel in pairs(wheels) do
                        setVehicleComponentVisible(vehicle, name, false)
                        if wheelsHidden then
                            wheel.object.alpha = 0
                        else
                            local x, y, z = getVehicleComponentPosition(vehicle, name)
                            local rx, ry, rz = getVehicleComponentRotation(vehicle, name)

                            local razval = razvalFront
                            local offset = offsetFront
                            -- Если колёса задние
                            if not isFrontWheel(name) then
                                razval = razvalRear
                                offset = offsetRear
                            end
                            if isLeftWheel(name) then
                                wheel.object:setRotation(rx, ry-vy+(-razval)*wy, rz+vz+(razval)*wz)
                            else
                                wheel.object:setRotation(rx, ry+vy+(-razval)*wy, rz+vz+(-razval)*wz)
                            end

                            x = x * (offset + 1)
                            if wheel.offsetDisabled then
                                offset = 1
                            end
                            -- Опускание колеса по Z при развале
                            local razvalOffsetZ = -math.sin(math.rad(razval)) * wheel.radius * 0.18
                            z = z + wheel.radiusOffsetZ + razvalOffsetZ
                            wheel.object:setAttachedOffsets(x, y, z)

                            wheel.object.dimension = localPlayer.dimension
                            wheel.object.alpha = vehicle.alpha
                            wheel.object.interior = vehicle.interior
                        end
                    end
                end
            end
        end
    end
end)