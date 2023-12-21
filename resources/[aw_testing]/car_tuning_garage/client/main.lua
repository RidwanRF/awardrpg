local vehicle
-- Исходное состояние компонентов автомобиля
local initialComponentsTable = {}
-- Корзина
local componentsOrderTable = {}
local previewEnabled = false

-- Колёса
local initialWheelsData = {}

-- Ксенон
local initialXenonColor = {}

function getWheelPropertyLimit(property, limit)
    local index = 1
    if limit == "max" then
        index = 2
    end
    local value = Config.wheelPropertiesLimits[property][index]
    -- Максимальный и минимальный радиус определяется относительно дефолтного радиуса автомобиля
    if property == "radius" and localPlayer.vehicle and isResourceRunning("car_wheels_system") then
        value = value * exports.car_wheels_system:getVehicleDefaultWheelsRadius(localPlayer.vehicle)
    end
    return value
end

function setupComponentsPreview()
    vehicle = localPlayer.vehicle
    previewEnabled = true

    initialComponentsTable = {}
    if not isResourceRunning("car_components") then
        return
    end
    local components = exports.car_components:getComponentNames()
    for i, name in ipairs(components) do
        local value = vehicle:getData(name)
        if not value then
            value = 0
        end
        initialComponentsTable[name] = value
    end

    initialWheelsData = {}
    local props = Config.wheelPropertiesLimits
    initialWheelsData["wheels_offset_f"] = vehicle:getData("wheels_offset_f") or getWheelPropertyLimit("offset", "min")
    initialWheelsData["wheels_offset_r"] = vehicle:getData("wheels_offset_r") or getWheelPropertyLimit("offset", "min")
    initialWheelsData["wheels_razval_f"] = vehicle:getData("wheels_razval_f") or getWheelPropertyLimit("razval", "min")
    initialWheelsData["wheels_razval_r"] = vehicle:getData("wheels_razval_r") or getWheelPropertyLimit("razval", "min")
    initialWheelsData["wheels_width_f"]  = vehicle:getData("wheels_width_f")  or getWheelPropertyLimit("width",  "min")
    initialWheelsData["wheels_width_r"]  = vehicle:getData("wheels_width_r")  or getWheelPropertyLimit("width",  "min")
    initialWheelsData["wheels_radius"]   = vehicle:getData("wheels_radius")   or getWheelPropertyLimit("radius", "min")

    initialXenonColor = {getVehicleHeadLightColor(vehicle)}

    -- Вызывать только после инициализации
    clearComponentsOrder()
end

-- Показать компонент на машине
function previewComponent(name, id, omitEvent)
    if not name or not id then
        return
    end
    if not isElement(vehicle) then
        return
    end
    if not previewEnabled then
        return
    end
    if name == "xenon" then
        setVehicleXenon(vehicle, id)
    else
		if name ~= "sgu_config" then
			vehicle:setData(name, id, false)
		end
    end
    if not omitEvent then
        triggerEvent("forceUpdateVehicleComponents", vehicle)
    end
end

-- Сбросить предпросмотр компонента
function resetComponentsPreview()
    if not isElement(vehicle) then
        return
    end
    if not previewEnabled then
        return
    end
    -- Сброс к начальному состоянию
    for name, value in pairs(initialComponentsTable) do
        vehicle:setData(name, value, false)
    end

    setVehicleHeadLightColor(vehicle, 0, 0, 0)

    -- Отобразить то, что добавлено в корзину
    for name, data in pairs(componentsOrderTable) do
        vehicle:setData(name, data.id, false)
    end
    -- Отобразить колёса
    vehicle:setData("wheels_offset_f", initialWheelsData["wheels_offset_f"], false)
    vehicle:setData("wheels_offset_r", initialWheelsData["wheels_offset_r"], false)
    vehicle:setData("wheels_razval_f", initialWheelsData["wheels_razval_f"], false)
    vehicle:setData("wheels_razval_r", initialWheelsData["wheels_razval_r"], false)
    vehicle:setData("wheels_width_f",  initialWheelsData["wheels_width_f"],  false)
    vehicle:setData("wheels_width_r",  initialWheelsData["wheels_width_r"],  false)
    vehicle:setData("wheels_radius",   initialWheelsData["wheels_radius"],   false)

    triggerEvent("forceUpdateVehicleComponents", vehicle)
end

function isWheelPropertyModified(name)
    return math.floor(vehicle:getData(name) * 50) / 50 ~= math.floor(initialWheelsData[name] * 50) / 50
end

function isComponentOrdered(component, id)
    if not component or not id then
        return false
    end
    if component == "xenon" then
        return false
    end
	if component == "sgu_config" then
        if vehicle:getData (component) and tonumber(vehicle:getData (component)) == id then
			return true
		else
			return false
		end
    end
    local initialValue = initialComponentsTable[component]
    return (id == 0 and not initialValue) or initialValue == id
end

-- Добавить компонент в корзину
function addComponentToOrder(component, id, price, name)
    if not component or not id or not name then
        return
    end
    if not previewEnabled then
        return
    end
    local initialValue = initialComponentsTable[component]
    if isComponentOrdered(component, id) then
        outputChatBox("Этот компонент уже установлен!", 255, 0, 0)
        return
    end
    -- Проверка конфликта с комплектом
    if getKitComponentId(vehicle.model, tonumber(vehicle:getData("kit")), component) then
        return
    end
    if not price then
        price = 0
    end

    componentsOrderTable[component] = { id = id, price = price, name = name}
    resetComponentsPreview()
end

-- Очистить корзину
function clearComponentsOrder()
    componentsOrderTable = {}
    resetComponentsPreview()
end

-- Удалить компонент из корзины
function removeComponentFromOrder(component)
    if not component then
        return
    end
    componentsOrderTable[component] = nil
    resetComponentsPreview()
end

-- Получить общую цену компонентов в корзине
function getOrderTotalPrice()
    local totalPrice = 0
    for component, data in pairs(componentsOrderTable) do
        totalPrice = totalPrice + data.price
    end
    return totalPrice
end

-- Корзина как список
function getOrderedComponentsList()
    local list = {}
    for component, data in pairs(componentsOrderTable) do
        table.insert(list, {component=component, name = data.name, price = data.price, id = data.id})
    end
    return list
end

-- Запретить предпросмотр компонентов. Используетя после нажатия на кнопку "Выход", чтобы во
-- время затемнения экрана нельзя было поставить компоненты и выехать с ними.
function disableComponentsPreview()
    initialWheelsData = {}
    previewEnabled = false
end

function buyComponents()
    fadeCamera(false, 0)

    -- Составить список компонентов для покупки
    local orderList = getOrderedComponentsList()
    local componentsList = {}
    for i, item in ipairs(orderList) do
        table.insert(componentsList, { component = item.component, id = item.id })
    end

    clearComponentsOrder()
    disableComponentsPreview()
    -- Воспроизвести звук ремонта
    playSoundFrontEnd(46)
    triggerServerEvent("tuningGarageBuy", resourceRoot, componentsList)
end

addEvent("garageBuyWheelsConfig", true)
addEventHandler("garageBuyWheelsConfig", resourceRoot, function (properties)
    for name, value in pairs(properties) do
        initialWheelsData[name] = value or 0
    end
    resetComponentsPreview()
end)
