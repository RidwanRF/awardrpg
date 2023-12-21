-------------------------------------------------------------------
-- Название: lights_main.lua
-- Описание: Инициализация шейдеров, функции для управления фарами
-------------------------------------------------------------------

-- Инициализированные автомобили
local vehicleLightsTable = {}

---------------------
-- Локальные методы
---------------------

-- Создание шейдеров для всех фар
local function loadVehicleLights(vehicle)
    if not isElement(vehicle) then
        return
    end

    -- Конфиг для автомобиля
    local customLights = CustomLights[vehicle:getData("vehicle:model")] or {}

    -- Список всех фар для автомобиля

    local lightsList = table.copy(Config.defaultLights)
    -- Добавление дополнительных фар из конфига
    if type(customLights.lights) == "table" then
        for i, v in ipairs(customLights.lights) do
            table.insert(lightsList, v)
        end
    end
	if type(Config.defaultStrobes) == "table" then
		for i, v in ipairs(Config.defaultStrobes) do
            table.insert(lightsList, v)
        end
	end

    vehicleLightsTable[vehicle] = {}

    -- Создание шейдеров для всех фар
    for i, light in ipairs(lightsList) do
        -- Параметры по умолчанию
        local properties = {}
        properties.state      = false
        properties.color      = light.color      or Config.defaultLightColor
        properties.brightness = light.brightness or Config.defaultLightBrightness

        local shader
        if not light.noShader then
            -- Создание и настройка шейдера
            shader = dxCreateShader("assets/shader.fx")
            for name, value in pairs(properties) do
                shader:setValue(name, value)
            end
            -- Название материала
            local material = light.material or "shader_"..light.name.."_*"
            shader:applyToWorldTexture(material, vehicle)

            if light.colorMul then
                shader:setValue("colorMul", light.colorMul)
            end
        end

        -- Сохранение в таблицу инициализированных авто
        vehicleLightsTable[vehicle][light.name] = {
            shader     = shader,
            material   = material,
            properties = properties,
        }
    end

    LightsAnim.addVehicle(vehicle)
end

-- Удаление шейдеров фар автомобиля
local function unloadVehicleLights(vehicle)
    if not vehicle or not vehicleLightsTable[vehicle] then
        return
    end

    for name, light in pairs(vehicleLightsTable[vehicle]) do
        if isElement(light.shader) then
            destroyElement(light.shader)
        end
    end

    vehicleLightsTable[vehicle] = nil

    LightsAnim.removeVehicle(vehicle)
end

----------------------
-- Глобальные методы
----------------------

-- Изменение состояния фары lightName автомобиля vehicle
-- Возможные значения property: state, color, brightness
function setVehicleLightProperty(vehicle, lightName, property, value)
    if not isElement(vehicle) or not lightName or not vehicleLightsTable[vehicle] then
        return false
    end
    local light = vehicleLightsTable[vehicle][lightName]
    if not light then
        return false
    end
    -- Дублирование значения в таблице, чтобы его можно
    -- было получить через getVehicleLightProperty
    light.properties[property] = value

    -- Установка параметра в шейдере
    if isElement(light.shader) then
        return light.shader:setValue(property, value)
    end
    return true
end

-- Получение ранее заданного состояния фар

function getVehicleLightProperty(vehicle, lightName, property)

    if not isElement(vehicle) or not lightName or not vehicleLightsTable[vehicle] then

        return false

    end

    local light = vehicleLightsTable[vehicle][lightName]

    if not light then

        return false

    end

    return light.properties[property]

end
-- Проверяет наличие фонаря с названием lightName у автомобиля
function hasVehicleLight(vehicle, lightName)
    if not isElement(vehicle) or not lightName or not vehicleLightsTable[vehicle] then
        return false
    end
    return not not vehicleLightsTable[vehicle][lightName]
end

--------------------------
-- Обработка событий MTA
--------------------------

addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Инициализация фар всех стоящих рядом авто
    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        if isElementStreamedIn(vehicle) then
            loadVehicleLights(vehicle)
        end
    end
end)

local function handleVehicleCreate()
    if source and source.type == "vehicle" then
        loadVehicleLights(source)
    end
end

local function handleVehicleDestroy()
    if source and source.type == "vehicle" then
        unloadVehicleLights(source)
    end
end

addEventHandler("onClientElementStreamIn",  root, handleVehicleCreate)
addEventHandler("onClientElementDestroy",   root, handleVehicleDestroy)
addEventHandler("onClientElementStreamOut", root, handleVehicleDestroy)
addEventHandler("onClientVehicleExplode",   root, handleVehicleDestroy)

if Config.debugEnabled then
    addCommandHandler("testlight", function (cmd, name)
        local v = localPlayer.vehicle
        if not v then
            return
        end
        setVehicleLightProperty(v, name, "color", {1, 0, 1})
        setVehicleLightProperty(v, name, "state", not setVehicleLightProperty(v, name, "state"))
    end)
end
