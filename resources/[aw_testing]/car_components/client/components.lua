-----------------------------------------------------------------------------------
-- Скрипт, обеспечивающий отображение компонентов на автомобилях на стороне клиента --
--------------------------------------------------------------------------------------

-- Список названий компонентов
local componentNames = {
    "bumper_f",      -- передний бампер
    "bumper_r",      -- задний бампер
    "skirts",        -- боковые юбки
    "fenders_f",     -- передние фендеры
    "fenders_r",     -- задние фендеры
    "misc",          -- прочее
    "head_lights",   -- передние фары
    "tail_lights",   -- задние фары
    "scoop",         -- воздухозаборник на крыше
    "bonnet",        -- капот
    "spoiler",       -- спойлер
    "trunk",         -- багажник
    "trunk_badge",   -- шильдик на багажнике
    "splitter",      -- рассекатель
    "diffuser",      -- диффузор
    "interior",      -- интерьер
    "interiorparts", -- части интерьера
    "kit",           -- комплекты
    "door_pside_f",  -- правая передняя дверь
    "door_dside_f",  -- левая передняя дверь
	"door_dside_r", -- левая задняя дверь
	"door_pside_r", -- правая задняя дверь
	"exhaust", -- глушитель
	"sgu_config", -- СГУ
	"shtorka", -- Шторка
	"wheels_tire", -- tire
	"wheels_brakes", -- brakes
    "wheels_prof",      -- профиль
    "wheels_tire",      -- резина
    "wheels_brake",      -- резина
    "number_plate",      -- номер 
    "doorfender_lr",      -- правая задняя дверь 
    "doorfender_rr",      -- левая задняя дверь 
    "glass_lr",      -- стекло задней левой двери 
    "glass_rr",      -- стекло задней правой двери 
    "steklo_zad",      -- стекло задней фары  
    "ecstasyy",      -- крышка для Дух Экстаза
}

-- Компоненты, которые полностью копируются с основных
-- Может быть указан один компонент как строка или список компонентов как массив
local additionalComponents = {
    ["fenders_r"] = {"doorfender_lr", "doorfender_rr", "glass_lr", "glass_rr"},
    ["tail_lights"] = {"trunk_lights"}
}

local defaultSpoilers = {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164}

-- Отображение дополнительного компонента при наличии
local function updateAdditionComponent(vehicle, name, id, show)
    if not additionalComponents[name] then
        return
    end

    if type(additionalComponents[name]) == "table" then
        -- Список дополнительных компонентов
        for i, additionalName in ipairs(additionalComponents[name]) do
            vehicle:setComponentVisible(additionalName .. id, show)
        end
    elseif type(additionalComponents[name] == "string") then
        -- Один дополнительный компонент
        vehicle:setComponentVisible(additionalComponents[name] .. id, show)
    end
end

function getVehicleComponentId(vehicle, name)
    local kit = vehicle:getData("kit") or 0
    if kit > 0 then
        local kitComponent = exports["car_tuning_garage"]:getKitComponentId(vehicle.model, kit, name)
        if kitComponent then
            return kitComponent
        end
    end
    return vehicle:getData(name)
end

-- Возвращает id компонента спойлера с учётом стандартных спойлеров
function getVehicleSpoilerId(vehicle)
    local id = getVehicleComponentId(vehicle, "spoiler")
    if type(id) ~= "number" then
        return 0
    elseif id > 20 then
        return id - 20
    else
        return id
    end
end

local function updateComponent(vehicle, name, activeKit)
    if type(name) ~= "string" or name == "kit" then
        return
    end

    -- Пройтись по всем вариантам компонента, имеющимся на автомобиле, и скрыть их
    local currentComponentId = 0
    while currentComponentId <= Config.maxComponentsCount do
        local currentComponentName = name .. currentComponentId
        -- Скрыть основной компонент
        vehicle:setComponentVisible(currentComponentName, false)
        -- Скрыть дополнительный компонент
        updateAdditionComponent(vehicle, name, currentComponentId, false)

        if currentComponentId > 0 and not getVehicleComponentPosition(vehicle, currentComponentName) then
            break
        end
        currentComponentId = currentComponentId + 1
    end

    -- Отобразить вариант, указанный в дате
    local showComponent = tonumber(vehicle:getData(name)) or 0
    -- ...или из кита, если он установлен
    if activeKit then
        local kitComponent = exports["car_tuning_garage"]:getKitComponentId(vehicle.model, activeKit, name)
        if kitComponent then
            showComponent = kitComponent
        end
    end

    -- Для спойлеров - первые N компонентов - стандартные спойлеры GTA
    if name == "spoiler" then
        -- Скрыть установленный стандартный спойлер
        for i, upgrade in ipairs(defaultSpoilers) do
            vehicle:removeUpgrade(upgrade)
        end
        -- Показать первые N стандартных спойлеров
        if showComponent > 0 and showComponent <= #defaultSpoilers then
            if defaultSpoilers[showComponent] then
                vehicle:addUpgrade(defaultSpoilers[showComponent])
            end
            return
        elseif showComponent > #defaultSpoilers then
            -- Показать дополнительный сопйлер
            showComponent = showComponent - #defaultSpoilers
        end
    end
    vehicle:setComponentVisible(name .. showComponent, true)
    -- Показать дополнительный компонент
    updateAdditionComponent(vehicle, name, showComponent, true)
end

function updateVehicleComponents(vehicle)
    if not isElement(vehicle) or not vehicle.streamedIn then
        return
    end
    -- Текущий кит
    -- Для получения информации о комплектах требуется ресурс car_tuning_garage
    local activeKit = tonumber(vehicle:getData("kit"))
    if not isResourceRunning("car_tuning_garage") then
        activeKit = nil
    end
    -- Обновить все компоненты
    for i, name in ipairs(componentNames) do
        updateComponent(vehicle, name, activeKit)
    end
    -- Обновить активный капот
    setupVehicleComponentsOpening(vehicle)
    -- Обновить номера
    setupVehicleLicenseFrames(vehicle)
end

-- Получить список всех существующих компонентов
function getComponentNames()
    local result = {}
    for i, name in ipairs(componentNames) do
        table.insert(result, name)
    end
    table.insert(result, "wheels")
    table.insert(result, "licence_frame")
    table.insert(result, "wheels_tire")
    table.insert(result, "wheels_brake")
    table.insert(result, "wheels_prof")
    return result
end

addEventHandler("onClientElementStreamIn", root, function ()
    if source.type == "vehicle" then
        updateVehicleComponents(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
        updateVehicleComponents(vehicle)
    end
end, true, "low")

addEvent("forceUpdateVehicleComponents", true)
addEventHandler("forceUpdateVehicleComponents", root, function ()
    updateVehicleComponents(source)
end)
