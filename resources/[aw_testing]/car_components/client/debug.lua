----------------------------------------------
-- Тестирование системы тюнинга компонентов --
----------------------------------------------

-- Скрипт запустится только, если включен Config.debugEnabled
if not Config.debugEnabled then
    return
end

debugActive = false

local screenSize = Vector2(guiGetScreenSize())
local isVisible = false

local panelWidth = 180
local isScrollEnabled = false

local ui = {}

addEventHandler("onClientRender", root, function ()
    if not isVisible or not localPlayer.vehicle then
        return
    end
    -- Отрисовка списка всех компонентов
    local list = {}
    for name, visible in pairs(localPlayer.vehicle:getComponents()) do
        table.insert(list, {name, visible})
    end
    -- Упорядочить по алфавиту
    table.sort(list, function (a, b)
        return a[1] < b[1]
    end)

    local x = screenSize.x - panelWidth
    local y = 10

    local bgX = x - 10
    local bgWidth = panelWidth + 20
    if #list * 11 + 10 > screenSize.y then
        bgX = bgX - 200
        bgWidth = bgWidth + 200
    end
    dxDrawRectangle(bgX, 0, bgWidth, screenSize.x, tocolor(0, 0, 0, 150))
    for i, item in ipairs(list) do
        local color = tocolor(0, 255, 0)
        if not item[2] then
            color = tocolor(255, 0, 0)
        end
        dxDrawText(item[1], x, y, x,y, color)
        dxDrawText(tostring(item[2]), x + 150, y, x + 150, y, color)
        y = y + 11
        if y > screenSize.y - 20 then
            x = x - 200
            y = 10
        end
    end
end)

local function updateSelectedComponent()
    if not localPlayer.vehicle then
        return
    end
    local name = guiComboBoxGetItemText(ui.componentName, ui.componentName.selected)
    local value = ui.componentId.selected
    if not value then
        value = 0
    end
    localPlayer.vehicle:setData(name, value)

    triggerEvent("forceUpdateVehicleComponents", localPlayer.vehicle)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Создание окна редактора
    local width = 300
    local height = 300
    ui.window = GuiWindow(10, screenSize.y - 10 - height, width, height, "Редактор тюнинга", false)
    ui.window.visible = false

    ui.componentName = GuiComboBox(0.05, 0.1, 0.45, 0.8, "Компонент", true, ui.window)
    local names = getComponentNames()
    for i, name in ipairs(names) do
        ui.componentName:addItem(name)
    end

    ui.componentId = GuiComboBox(0.5, 0.1, 0.45, 0.8, "ID", true, ui.window)
    for id = 0, 64 do
        ui.componentId:addItem(tostring(id))
    end
    local y = 0.25
    GuiLabel(0.05, y, 0.9, 0.07, "Открывание дверей", true, ui.window)
    y = y + 0.07
    ui.doorsScroll = GuiScrollBar(0.05, y, 0.9, 0.07, true, true, ui.window)

    -- Выбрано название компонента
    addEventHandler("onClientGUIComboBoxAccepted", ui.componentName, function ()
        if not localPlayer.vehicle then
            return
        end
        local name = guiComboBoxGetItemText(ui.componentName, ui.componentName.selected)
        local value = localPlayer.vehicle:getData(name)
        if not value then
            value = -1
        end
        ui.componentId.selected = value
    end)

    -- Выбран вариант компонента
    addEventHandler("onClientGUIComboBoxAccepted", ui.componentId, updateSelectedComponent)

    addEventHandler("onClientGUIScroll", ui.doorsScroll, function ()
        if not localPlayer.vehicle then
            return
        end
        local position = guiScrollBarGetScrollPosition(source)
        if not position then
            position = 0
        end
        position = position / 100

        for i = 0, 5 do
            localPlayer.vehicle:setDoorOpenRatio(i, position)
        end
    end)

    outputDebugString("Debug mode enabled. Press '"..Config.debugHotkey.."' to show editor.", 0, 50, 150, 255)
end)

addCommandHandler("cartest", function ()
    isVisible = not isVisible

    ui.window.visible = isVisible
    showCursor(isVisible)

    debugActive = isVisible
end)

bindKey(Config.debugHotkey, "down", "cartest")

addEventHandler("onClientMouseEnter", resourceRoot, function ()
    if source == ui.componentId then
        isScrollEnabled = true
    end
end)

addEventHandler("onClientMouseLeave", resourceRoot, function ()
    if source == ui.componentId then
        isScrollEnabled = false
    end
end)

addEventHandler("onClientMouseWheel", resourceRoot, function (delta)
    if isScrollEnabled then
        ui.componentId.selected = ui.componentId.selected - delta
        if ui.componentId.selected < 0 then
            ui.componentId.selected = 0
        end
        updateSelectedComponent()
    end
end)
