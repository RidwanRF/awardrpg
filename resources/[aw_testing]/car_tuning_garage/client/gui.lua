function onResourceStart()
	local sound = playSound3D("sounds/song.mp3", 5616.2001953125, 1165.5999755859, 59, true) 
    local music = playSound3D("http://radiorecord.hostingradio.ru/rap96.aacp", 5614.2001953125, 1165.5999755859, 59, true) 
    setSoundMaxDistance(sound, 25)
    setSoundMaxDistance(music, 35)
    setSoundVolume(sound, 0.15) 
    setSoundVolume(music, 0.05) 
    setElementDimension(sound, 1001)
    setElementDimension(music, 1001)
end
addEventHandler("onClientResourceStart", resourceRoot, onResourceStart)

function onResourceStart()
	local sound = playSound3D("sounds/song.mp3", 5616.2001953125, 1165.5999755859, 59, true) 
    local music = playSound3D("http://radiorecord.hostingradio.ru/rap96.aacp", 5614.2001953125, 1165.5999755859, 59, true) 
    setSoundMaxDistance(sound, 25)
    setSoundMaxDistance(music, 35)
    setSoundVolume(sound, 0.35) 
    setSoundVolume(music, 0.25) 
    setElementDimension(sound, 2001)
    setElementDimension(music, 2001)
end
addEventHandler("onClientResourceStart", resourceRoot, onResourceStart)

local screenSize = Vector2(guiGetScreenSize())
local ui = {}
local ignoreWheelsScrollEvents = false
local totalWheelsPrice = 0

local activeSection = nil

-- Названия разделов тюнинга
local sectionNames = {
    ["bumper_f"]      = "Передний бампер",
    ["bumper_r"]      = "Задний бампер",
    ["skirts"]        = "Боковые юбки",
    ["fenders_f"]     = "Передние фендеры",
    ["fenders_r"]     = "Задние фендеры",
    ["misc"]          = "Прочее",
    ["head_lights"]   = "Передние фары",
    ["tail_lights"]   = "Фонари",
    ["scoop"]         = "Детали крыши",
    ["bonnet"]        = "Капот",
    ["spoiler"]       = "Спойлер",
    ["trunk"]         = "Багажник",
    ["trunk_badge"]   = "Шильдики",
    ["wheels"]        = "Диски",
    ["splitter"]      = "Сплиттер",
    ["diffuser"]      = "Диффузор",
    ["interior"]      = "Салон",
    ["interiorparts"] = "Части салона",
    ["kit"]           = "Комплекты",
    ["licence_frame"] = "Номерная рамка",
    ["door_pside_f"]  = "Правая передняя дверь",
    ["door_dside_f"]  = "Левая передняя дверь",
    ["wheels_config"] = "Настройка колёс",
    ["xenon"]         = "Ксенон",
    ["sgu_config"] 	  = "СГУ",
    ["shtorka"] 	  = "Шторка",
    ["wheels_tire"]   = "Производитель резины",
    ["wheels_brakes"] = "Тормозные диски", 
    ["wheels_prof"]   = "Профиль резины",
    ["door_dside_r"] = "Левая задняя дверь",
	["door_pside_r"] = "Правая задняя дверь",
	["exhaust"] 	  = "Глушитель",
    ["roof_"] 	  = "Крыша",
    ["mirror_rf"] 	  = "Правые зеркла",
    ["mirror_lf"] 	  = "Левые зеркла",
    ["doorfender_rr"] 	  = "Задние правые двери",
    ["doorfender_lr"] 	  = "Задние левые двери",
    ["doorfender_rf"] 	  = "Передние правые двери",
    ["doorfender_lf"] 	  = "Передние левые двери",
    ["grill"]  = "Решетка",
    ["accessories"]  = "Решетка"	
}

-- Является ли локальный игрок владельцем автомобиля
local function isVehicleOwner()
    local accountName = localPlayer:getData("accountName")
    if not accountName or not isElement(localPlayer.vehicle) then
        return false
    end
    return localPlayer:getData("accountName") == localPlayer.vehicle:getData("owner")
end

-- Значение для скроллбара из параметра колёс
local function scrollPositionFromWheelProperty(property, value)
    local minValue = getWheelPropertyLimit(property, "min")
    local maxValue = getWheelPropertyLimit(property, "max")
    local result = (value - minValue) / (maxValue - minValue) * 100
    return result
end

-- Оффсет колёс из прогрессбара
local function wheelPropertyFromScrollPosition(property, position)
    local minValue = getWheelPropertyLimit(property, "min")
    local maxValue = getWheelPropertyLimit(property, "max")
    local result = position / 100 * (maxValue - minValue) + minValue
    return result
end

-- Обновить список в корзине
local function updateOrderList()
    ui.orderList:clear()
    local orderList = getOrderedComponentsList()
    if #orderList == 0 then
        ui.removeFromOrder.enabled = false
        ui.buy.enabled = false

        if isVehicleOwner() then
            ui.buy.text = "Купить"
       -- else
        --    ui.buy.text = "Вы не владелец авто"
        end
        return
    end
    local totalPrice = getOrderTotalPrice()
    if exports.bank:getPlayerBankMoney(client, "RUB") <= totalPrice then
        ui.buy.text = "Недостаточно денег\n($ "..convertNumber(tostring(totalPrice))..")"
        ui.buy.enabled = false
    else
        ui.buy.text = "Купить ($ "..convertNumber(tostring(totalPrice))..")"
        ui.buy.enabled = true
    end

   -- if not isVehicleOwner() then
    --    ui.buy.enabled = false
   --     ui.buy.text = "Вы не владелец авто"
    --end

    for _, data in ipairs(orderList) do
        local rowIndex = ui.orderList:addRow(
            string.format("%s - %s",
                tostring(sectionNames[data.component]),
                tostring(data.name)),
            tostring(data.price))
        ui.orderList:setItemData(rowIndex, 1, data.component)
    end
end

-- Получить название активного раздела
local function getSelectedSectionName()
    local row, column = ui.sectionsList:getSelectedItem()
    if not row then
        return
    end
    return ui.sectionsList:getItemData(row, column)
end

-- Получить информацию о выбранном компоненте
local function getSelectedComponentInfo()
    local rowIndex = ui.componentsList:getSelectedItem()
    if not rowIndex then
        return
    end
    local id = tonumber(ui.componentsList:getItemData(rowIndex, 1))
    local name = ui.componentsList:getItemText(rowIndex, 1)
    local price = tonumber(ui.componentsList:getItemText(rowIndex, 2))
    return id, name, price
end

-- Обновить текст на панели выбора компонентов
local function updateSelectedComponent()
    resetComponentsPreview()
    ui.addToOrder.text = "Добавить в корзину"
    ui.addToOrder.enabled = false
    ui.componentName.text = ""
    local id, name = getSelectedComponentInfo()
    local component = getSelectedSectionName()
    if not id or not component then
        return
    end
    previewComponent(component, id)
    ui.componentName.text = name
    ui.addToOrder.enabled = true

    local vehicle = localPlayer.vehicle
  --  if isElement(vehicle) and getKitComponentId(vehicle.model, tonumber(vehicle:getData("kit")), component) then
    if isElement(vehicle) and getKitComponentId(vehicle:getData("vehicle:model"), tonumber(vehicle:getData("kit")), component) then
        ui.addToOrder.enabled = false
        ui.addToOrder.text = "Деталь конфликтует с комплектом"
    end
    if isComponentOrdered(component, id) then
        ui.addToOrder.enabled = false
        ui.addToOrder.text = "Эта деталь уже установлена"
    end
end

-- Загрузить список разделов для автомобиля игрока
local function loadSections()
  --  local components = getComponentsTable(localPlayer.vehicle.model)
    local components = getComponentsTable(localPlayer.vehicle:getData("vehicle:model"))
    if not components then
        return
    end
    -- Удаление компонентов и разделов, принадлежащих к наборам
    for name, list in pairs(components) do
        for id, component in pairs(list) do
            if component.kit then
                list[id] = nil
            end
        end
        if table.length(list) <= 1 then
            components[name] = nil
        end
    end
    if not exports["car_components"]:isLicenseFrameChangeAllowed(localPlayer.vehicle.model) then
        components["licence_frame"] = nil
    end
    -- Добавить раздел настройки колёс
    components.wheels_config = true

    ui.sectionsList:clear()
    ui.componentsList:clear()
    for section in pairs(components) do
        local name = sectionNames[section] or section
        iprint(sectionNames["doorfender_lf"])
        local rowIndex = ui.sectionsList:addRow(name)
        ui.sectionsList:setItemData(rowIndex, 1, section)
    end
    resetComponentsPreview()
    updateOrderList()
end

local function updateWheelsConfigPrice()
    local price = 0
    for name, p in pairs(Config.wheelPropertiesPrices) do
        if isWheelPropertyModified(name) then
            price = price + p
        end
    end
   -- if not isVehicleOwner() then
   --     ui.wheelsAccept.text = "Вы не владелец авто"
   --     ui.wheelsAccept.enabled = false
   --     return
   -- end
    totalWheelsPrice = 0
    if exports.bank:getPlayerBankMoney(client, "RUB") <= price then
        ui.wheelsAccept.text = "Недостаточно денег\n($ "..convertNumber(price)..")"
        ui.wheelsAccept.enabled = false
    else
        if price > 0 then
            ui.wheelsAccept.text = "Купить ($ "..convertNumber(price)..")"
            ui.wheelsAccept.enabled = true
            totalWheelsPrice = price
        else
            ui.wheelsAccept.text = "Купить"
            ui.wheelsAccept.enabled = false
        end
    end
end

local function loadWheelsSection()
    resetComponentsPreview()

    -- Обновить вылет
    ignoreWheelsScrollEvents = true
    local offsetF = localPlayer.vehicle:getData("wheels_offset_f") or getWheelPropertyLimit("offset", "min")
    local offsetR = localPlayer.vehicle:getData("wheels_offset_r") or getWheelPropertyLimit("offset", "min")
    ui.wheelsOffsetScrollF.scrollPosition = scrollPositionFromWheelProperty("offset", offsetF)
    ui.wheelsOffsetScrollR.scrollPosition = scrollPositionFromWheelProperty("offset", offsetR)
    -- Обновить развал
    local razvalF = localPlayer.vehicle:getData("wheels_razval_f") or getWheelPropertyLimit("razval", "min")
    local razvalR = localPlayer.vehicle:getData("wheels_razval_r") or getWheelPropertyLimit("razval", "min")
    ui.wheelsRazvalScrollF.scrollPosition = scrollPositionFromWheelProperty("razval", razvalF)
    ui.wheelsRazvalScrollR.scrollPosition = scrollPositionFromWheelProperty("razval", razvalR)
    -- Обновить радиус и толщину
    local radius = localPlayer.vehicle:getData("wheels_radius") or getWheelPropertyLimit("radius", "min")
    local widthF = localPlayer.vehicle:getData("wheels_width_f") or getWheelPropertyLimit("width", "min")
    local widthR = localPlayer.vehicle:getData("wheels_width_r") or getWheelPropertyLimit("width", "min")
    ui.wheelsRadiusScroll.scrollPosition = scrollPositionFromWheelProperty("radius", radius)
    ui.wheelsWidthScrollF.scrollPosition = scrollPositionFromWheelProperty("width", widthF)
    ui.wheelsWidthScrollR.scrollPosition = scrollPositionFromWheelProperty("width", widthR)
    ignoreWheelsScrollEvents = false
    updateWheelsConfigPrice()

    local scrollsEnabled = localPlayer.vehicle:getData("wheels") ~= 0
    local alpha = 1
    if not scrollsEnabled then
        alpha = 0.2
        guiBringToFront(ui.disableScrollsLabel)
    end
    ui.wheelsRazvalScrollF.alpha = alpha
    ui.wheelsRazvalScrollR.alpha = alpha
    ui.wheelsRadiusScroll.alpha  = alpha
    ui.wheelsWidthScrollF.alpha  = alpha
    ui.wheelsWidthScrollR.alpha  = alpha

    ui.disableScrollsLabel.visible = not scrollsEnabled
end

local function updateWheelsOffset()
    if ignoreWheelsScrollEvents then
        return
    end
    -- Показать вылет
    previewComponent("wheels_offset_f", wheelPropertyFromScrollPosition("offset", ui.wheelsOffsetScrollF.scrollPosition), true)
    previewComponent("wheels_offset_r", wheelPropertyFromScrollPosition("offset", ui.wheelsOffsetScrollR.scrollPosition))
    updateWheelsConfigPrice()
end

local function updateWheelsRazval()
    if ignoreWheelsScrollEvents then
        return
    end
    -- Показать развал
    previewComponent("wheels_razval_f", wheelPropertyFromScrollPosition("razval", ui.wheelsRazvalScrollF.scrollPosition), true)
    previewComponent("wheels_razval_r", wheelPropertyFromScrollPosition("razval", ui.wheelsRazvalScrollR.scrollPosition), true)
    updateWheelsConfigPrice()
end

local function updateWheelsRadius()
    if ignoreWheelsScrollEvents then
        return
    end
    previewComponent("wheels_radius", wheelPropertyFromScrollPosition("radius", ui.wheelsRadiusScroll.scrollPosition))
    updateWheelsConfigPrice()
end

local function updateWheelsWidth()
    if ignoreWheelsScrollEvents then
        return
    end
    previewComponent("wheels_width_f", wheelPropertyFromScrollPosition("width", ui.wheelsWidthScrollF.scrollPosition))
    previewComponent("wheels_width_r", wheelPropertyFromScrollPosition("width", ui.wheelsWidthScrollR.scrollPosition))
    updateWheelsConfigPrice()
end

-- Отображение содержимого раздела
local function showSection(name)
    ui.componentsList:clear()
    resetComponentsPreview()
    ui.componentName.text = ""
    ui.componentPanel.text = "Выберите раздел"



    activeSection = name

    if not name then
        return
    end
    ui.wheelsWindow.visible = false
    ui.componentsWindow.visible = true
    ui.componentPanel.visible = true
    ui.orderWindow.visible = true
    if name == "wheels_config" then
        ui.wheelsWindow.visible = true
        ui.componentsWindow.visible = false
        ui.componentPanel.visible = false
        ui.orderWindow.visible = false

        loadWheelsSection()
        ui.wheelsAccept.enabled = false
        return
    end
 --   local components = getComponentsTable(localPlayer.vehicle.model)
    local components = getComponentsTable(localPlayer.vehicle:getData("vehicle:model"))
    if not components or not components[name] then
        return
    end
    if name == "spoiler" then
        local function createRow(i)
            local component = components[name][i]
            if component and not component.kit then
                local rowIndex = ui.componentsList:addRow(component.name, component.price)
                ui.componentsList:setItemData(rowIndex, 1, i)
            end
        end
        createRow(0)
        for i = 21, table.maxn(components[name]) do
            createRow(i)
        end
        for i = 1, 20 do
            createRow(i)
        end
    else
        for i = 0, table.maxn(components[name]) do
            local component = components[name][i]
            if component and not component.kit then
                local rowIndex = ui.componentsList:addRow(component.name, component.price)
                ui.componentsList:setItemData(rowIndex, 1, i)
            end
        end
    end
    ui.componentPanel.text = sectionNames[name] or name
    ui.componentsList:setSelectedItem(0, 1)
    updateSelectedComponent()
end

local function changeSelectedComponent(delta)
    local rowIndex = ui.componentsList:getSelectedItem()
    if not rowIndex then
        rowIndex = 0
    end
    rowIndex = rowIndex + delta
    if rowIndex < 0 then
        rowIndex = ui.componentsList:getRowCount() - 1
    elseif rowIndex > ui.componentsList:getRowCount() - 1 then
        rowIndex = 0
    end
    ui.componentsList:setSelectedItem(rowIndex, 1)
    updateSelectedComponent()
end

local function changeSelectedSection(delta)
    local rowIndex = ui.sectionsList:getSelectedItem()
    if not rowIndex then
        rowIndex = 0
    end
    rowIndex = rowIndex + delta
    if rowIndex < 0 then
        rowIndex = ui.sectionsList:getRowCount() - 1
    elseif rowIndex > ui.sectionsList:getRowCount() - 1 then
        rowIndex = 0
    end
    ui.sectionsList:setSelectedItem(rowIndex, 1)
    local name = getSelectedSectionName()
    showSection(name)
end

local function orderSelectedComponent()
    local id, name, price = getSelectedComponentInfo()
    local component = getSelectedSectionName()
    if not id or not component then
        return
    end
    addComponentToOrder(component, id, price, name)
    updateOrderList()
end

local function onKey(key, down)
    if not down then
        return
    end
    if key == "arrow_l" then
        changeSelectedComponent(-1)
    elseif key == "arrow_r" then
        changeSelectedComponent(1)
    elseif key == "arrow_u" then
        changeSelectedComponent(-1)
    elseif key == "arrow_d" then
        changeSelectedComponent(1)
    elseif key == "enter" then
        orderSelectedComponent()
    elseif key == "pgup" then
        changeSelectedSection(-1)
    elseif key == "pgdn" then
        changeSelectedSection(1)
    end
end

function showTuningUI(visible)
    if ui.sectionsWindow.visible == not not visible then
        return
    end
    showChat(not visible)
    -- Отобразить UI
    ui.sectionsWindow.visible = visible
    ui.componentsWindow.visible = visible
    ui.orderWindow.visible = visible
    ui.componentPanel.visible = visible
    ui.exitButton.visible = visible
    ui.wheelsWindow.visible = false

    ui.exitButton.enabled = visible

    if visible then
        loadSections()
        loadWheelsSection()
        addEventHandler("onClientKey", root, onKey)
    else
        removeEventHandler("onClientKey", root, onKey)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local width, height
    local x = 5
    local y = 5

    -- Список видов деталей
    width = 250
    height = screenSize.y * 0.33 - 5
    ui.sectionsWindow = GuiWindow(x, y, width, height, "Компоненты", false)
    ui.sectionsWindow.movable = true
    ui.sectionsWindow.sizable = false
    ui.sectionsList = GuiGridList(5, 25, width - 10, height - 30, false, ui.sectionsWindow)
    ui.sectionsList:setSortingEnabled(false)
    ui.sectionsList:addColumn("Название", 0.9)
    addEventHandler("onClientGUIClick", ui.sectionsList, function ()
        local name = getSelectedSectionName()
        showSection(name)
    end, false)

    -- Список компонентов определенного вида
    y = y + height + 5
    -- width = 250
    height = screenSize.y * 0.33 - 5
    ui.componentsWindow = GuiWindow(x, y, width, height, "Детали", false)
    ui.componentsWindow.movable = true
    ui.componentsWindow.sizable = false

    ui.componentsList = GuiGridList(5, 25, width - 10, height - 30 - 40, false, ui.componentsWindow)
    ui.componentsList:setSortingEnabled(false)
    ui.componentsList:addColumn("Название", 0.6)
    ui.componentsList:addColumn("Цена", 0.25)
    addEventHandler("onClientGUIClick", ui.componentsList, function ()
        updateSelectedComponent()
    end, false)

    ui.addToOrder = GuiButton(5, height - 40, width - 10, 30, "Добавить в корзину", false, ui.componentsWindow)
    ui.addToOrder.enabled = false

    addEventHandler("onClientGUIClick", ui.addToOrder, orderSelectedComponent, false)
    addEventHandler("onClientGUIDoubleClick", ui.componentsList, orderSelectedComponent, false)

    -- Окно настройки колёс
    ui.wheelsWindow = GuiWindow(x, y, width, screenSize.y - y, "Настройка колёс", false)
    ui.wheelsWindow.movable = true
    ui.wheelsWindow.sizable = false

    local wy = 25
    -- Настройка вылета
    GuiLabel(10, wy, width - 10, 25, "Вылет передних и задних колёс", false, ui.wheelsWindow)
    wy = wy + 22
    ui.wheelsOffsetScrollF = GuiScrollBar(10, wy, width - 20, 20, true, false, ui.wheelsWindow)
    wy = wy + 30
    ui.wheelsOffsetScrollR = GuiScrollBar(10, wy, width - 20, 20, true, false, ui.wheelsWindow)
    -- Настройка развала
    wy = wy + 25
    local labelStart = wy
    GuiLabel(10, wy, width - 10, 25, "Развал передних и задних колёс", false, ui.wheelsWindow)
    wy = wy + 22
    ui.wheelsRazvalScrollF = GuiScrollBar(10, wy, width - 20, 20, true, false, ui.wheelsWindow)
    wy = wy + 30
    ui.wheelsRazvalScrollR = GuiScrollBar(10, wy, width - 20, 20, true, false, ui.wheelsWindow)
    -- Настройка толщины
    wy = wy + 25
    GuiLabel(10, wy, width - 10, 25, "Толщина передних и задних колёс", false, ui.wheelsWindow)
    wy = wy + 22
    ui.wheelsWidthScrollF = GuiScrollBar(10, wy, width - 20, 20, true, false, ui.wheelsWindow)
    wy = wy + 30
    ui.wheelsWidthScrollR = GuiScrollBar(10, wy, width - 20, 20, true, false, ui.wheelsWindow)
    -- Настройка радиуса
    wy = wy + 25
    GuiLabel(10, wy, width - 10, 25, "Радиус", false, ui.wheelsWindow)
    wy = wy + 22
    ui.wheelsRadiusScroll = GuiScrollBar(10, wy, width - 20, 20, true, false, ui.wheelsWindow)
    local labelEnd = wy + 25

    local labelHeight = labelEnd - labelStart
    ui.disableScrollsLabel = GuiLabel(0, labelStart, width, labelHeight, "", false, ui.wheelsWindow)
    ui.disableScrollsLabel.visible = false

    local wheelsWindowWidth = ui.wheelsWindow:getSize(false)
    local wheelsWindowHeight = wy + 25 + 40 + 5
    ui.wheelsWindow:setSize(wheelsWindowWidth, wheelsWindowHeight, false)

    ui.wheelsAccept = GuiButton(10, wheelsWindowHeight - 40, 150, 30, "Купить (99999 руб)", false, ui.wheelsWindow)
    ui.wheelsCancel = GuiButton(165, wheelsWindowHeight - 40, 100, 30, "Сброс", false, ui.wheelsWindow)

    addEventHandler("onClientGUIScroll", ui.wheelsOffsetScrollF, updateWheelsOffset)
    addEventHandler("onClientGUIScroll", ui.wheelsOffsetScrollR, updateWheelsOffset)
    addEventHandler("onClientGUIScroll", ui.wheelsRazvalScrollF, updateWheelsRazval)
    addEventHandler("onClientGUIScroll", ui.wheelsRazvalScrollR, updateWheelsRazval)
    addEventHandler("onClientGUIScroll", ui.wheelsWidthScrollF,   updateWheelsWidth)
    addEventHandler("onClientGUIScroll", ui.wheelsWidthScrollR,   updateWheelsWidth)
    addEventHandler("onClientGUIScroll", ui.wheelsRadiusScroll,  updateWheelsRadius)

    addEventHandler("onClientGUIClick", ui.wheelsCancel, loadWheelsSection, false)
    addEventHandler("onClientGUIClick", ui.wheelsAccept, function ()
        if not isVehicleOwner() then
            return
        end
        local data = {}
        for i, name in ipairs(Config.wheelProperties) do
            if isWheelPropertyModified(name) then
                data[name] = localPlayer.vehicle:getData(name) or 0
            end
        end
        triggerServerEvent("garageBuyWheelsConfig", resourceRoot, data, totalWheelsPrice)
        ui.wheelsAccept.enabled = false
    end, false)

    -- Корзина
    y = y + height + 5
    -- width = 250
    height = screenSize.y * 0.33 - 10
    ui.orderWindow = GuiWindow(x, y, width, height, "Корзина", false)
    ui.orderWindow.movable = true
    ui.orderWindow.sizable = false
    ui.orderList = GuiGridList(5, 25, width - 10, height - 30 - 40, false, ui.orderWindow)
    ui.orderList:setSortingEnabled(false)
    ui.orderList:addColumn("Название", 0.6)
    ui.orderList:addColumn("Цена", 0.25)
    addEventHandler("onClientGUIClick", ui.orderList, function ()
        local rowIndex = ui.orderList:getSelectedItem()
        if not rowIndex or rowIndex < 0 then
            ui.removeFromOrder.enabled = false
            return
        end
        ui.removeFromOrder.enabled = true
    end, false)
    ui.removeFromOrder = GuiButton(5, height - 40, (width - 10) / 3, 30, "Удалить", false, ui.orderWindow)
    ui.removeFromOrder.enabled = false
    addEventHandler("onClientGUIClick", ui.removeFromOrder, function ()
        local rowIndex = ui.orderList:getSelectedItem()
        if not rowIndex or rowIndex < 0 then
            return
        end
        local component = ui.orderList:getItemData(rowIndex, 1)
        removeComponentFromOrder(component)
        updateOrderList()
    end, false)

    ui.buy = GuiButton(width / 3 + 12, height - 40, width - 10, 30, "Купить (9999999 руб.)", false, ui.orderWindow)
    addEventHandler("onClientGUIClick", ui.buy, buyComponents, false)
    -- Переключатель компонентов
    x = width
    width = 350
    height = 80
    x = x + (screenSize.x - x) / 2 - width / 2
    y = screenSize.y - height - 20
    ui.componentPanel = GuiWindow(x, y, width, height, "Просмотр деталей", false)
    ui.componentPanel.movable = true
    ui.componentPanel.sizable = false

    ui.componentName = GuiLabel(0, 5, width, height, "", false, ui.componentPanel)
    ui.componentName.verticalAlign = "center"
    ui.componentName.horizontalAlign = "center"

    local buttonWidth = height * 0.6
    ui.prevComponent = GuiButton(5, 25, buttonWidth, height - 20, "<<", false, ui.componentPanel)
    addEventHandler("onClientGUIClick", ui.prevComponent, function ()
        changeSelectedComponent(-1)
    end, false)
    ui.nextComponent = GuiButton(width - 5 - buttonWidth, 25, buttonWidth, height - 20, ">>", false, ui.componentPanel)
    addEventHandler("onClientGUIClick", ui.nextComponent, function ()
        changeSelectedComponent(1)
    end, false)

    local exitButtonWidth = 100
    local exitButtonHeight = 40
    ui.exitButton = GuiButton(screenSize.x - exitButtonWidth - 10, screenSize.y - exitButtonHeight - 20,
        exitButtonWidth, exitButtonHeight, "Выход", false)
    addEventHandler("onClientGUIClick", ui.exitButton, function ()
        exitTuning()
        ui.exitButton.enabled = false
    end, false)

    showTuningUI(false)
end)

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end