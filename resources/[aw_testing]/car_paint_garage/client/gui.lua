local screenSize = Vector2(guiGetScreenSize())
local ui = {}
local tonerTimer

addEvent("onColorpickerChange", false)
addEvent("onColorpickerChange2", false)

local sections = {
    body       = { label = "Основной цвет",        price = Config.prices.body },
    additional = { label = "Дополнительный цвет",  price = Config.prices.additional },
    wheels     = { label = "Цвет дисков",          price = Config.prices.wheels },
    paint      = { label = "Тип краски",           customWindow = "paintWindow"  },
    hlbody     = { label = "Цвет блеска",          price = Config.prices.hlbody },
    toner      = { label = "Тонировка",            customWindow = "tonerWindow" },
    vinyls     = { label = "Винилы",               customWindow = "vinylWindow" },
}

local activeSection = "body"
local currentPrice = 0

-- Получить название активного раздела
local function getSelectedSectionName()
    local row, column = ui.sectionsList:getSelectedItem()
    if not row then
        return
    end
    return ui.sectionsList:getItemData(row, column)
end

local function resetBuyButtonText()
    if getPlayerMoney(localPlayer) < currentPrice then
        ui.buttonBuyColor.text = "Недостаточно денег ($ " .. tostring(currentPrice) .. ")"
        ui.buttonBuyColor.enabled = false
    else
        ui.buttonBuyColor.text = "Купить ($ " .. tostring(currentPrice) .. ")"
        ui.buttonBuyColor.enabled = true
    end
end

local function updateColor(r, g, b)
    previewVehicleColor(activeSection, r, g, b)
    resetBuyButtonText()
end

local function updateColor2 (ctype)
	previewVehicleColor2 (ctype)
end

local function resetTonerScrolls()
    ui.tonerScrollFront.scrollPosition = math.floor((getInitialToner("front") - 40) / 60 * 100)
    ui.tonerScrollSide.scrollPosition  = math.floor((getInitialToner("side")  - 40) / 60 * 100)
    ui.tonerScrollRear.scrollPosition  = math.floor((getInitialToner("rear")  - 40) / 60 * 100)
end

local function updateToner()
    localPlayer.vehicle:setData("tint_front",
            math.floor(ui.tonerScrollFront.scrollPosition / 100 * 60 + 40), false)
    localPlayer.vehicle:setData("tint_side",
            math.floor(ui.tonerScrollSide.scrollPosition  / 100 * 60 + 40), false)
    localPlayer.vehicle:setData("tint_rear",
            math.floor(ui.tonerScrollRear.scrollPosition  / 100 * 60 + 40), false)
    triggerEvent("forceUpdateVehicleShaders", localPlayer.vehicle, false, true)

    local price = calculateTonerPrice()
    if price == 0 then
        ui.buttonBuyToner.enabled = false
        ui.buttonBuyToner.text = "Купить"
    else
        ui.buttonBuyToner.enabled = getPlayerMoney(localPlayer) >= price
        ui.buttonBuyToner.text = "Купить (" .. tostring(price) .. ")"
    end
end

local function getSelectedPaintjob()
    local row, column = ui.vinylsList:getSelectedItem()
    if not row then
        return false
    end
    return ui.vinylsList:getItemData(row, column)
end

local function getSelectedColorType()
    local row, column = ui.paintList:getSelectedItem()
    if not row then
        return false
    end
    return ui.paintList:getItemData(row, column)
end

local function updateColorTypeSection()
	--resetVehiclePreview()
	
	local colorType = getSelectedColorType()
	
	localPlayer.vehicle:setData("colorType", colorType, false)
	triggerEvent("forceUpdateVehicleShadersCrutch", localPlayer.vehicle)
	ui.buttonBuyPaint.text = 'Купить ($ ' .. PalitraColor[colorType][3] .. ')'
	
	print( colorType, localPlayer.vehicle:getData("colorType") ) 
	
	local initialColorType = getInitialPaint()
	
	if initialColorType ~= colorType and getPlayerMoney(localPlayer) >= PalitraColor[colorType][3] then
        ui.buttonBuyPaint.enabled = true
    else
        ui.buttonBuyPaint.enabled = false
        if initialColorType == colorType then
            ui.buttonBuyPaint.text = "Данный тип покраски уже установлен"
        end
    end
end
local function updateVinylSection()
    resetVehiclePreview()

    local paintjob = getSelectedPaintjob()
    localPlayer.vehicle:setData("paintjob", paintjob, false)
    triggerEvent("forceUpdateVehicleShadersCrutch", localPlayer.vehicle)

    local initialPaintjob = getInitialPaintjob()
    if not initialPaintjob then
        initialPaintjob = false
    end
    if not paintjob then
        paintjob = false
    end

    local price = Config.paintjobPrice
    if not paintjob then
        price = Config.paintjobRemovePrice
    end
    ui.buttonBuyVinyl.text = "Купить ($ " .. price ..  ")"
    if initialPaintjob ~= paintjob and getPlayerMoney(localPlayer) >= price then
        ui.buttonBuyVinyl.enabled = true
    else
        ui.buttonBuyVinyl.enabled = false
        if initialPaintjob == paintjob then
            ui.buttonBuyVinyl.text = "Данный винил уже установлен"
        end
    end
    if ui.toggleVinylColor.selected and paintjob then
        previewVehicleColor("body", 255, 255, 255)
        previewVehicleColor("additional", 255, 255, 255)
        previewVehicleColor("hlbody", 255, 255, 255)
    end
end

local function showSection(name)
    if not name or not sections[name] then
        return
    end
    local section = sections[name]
    --resetVehiclePreview()
    activeSection = name

    ui.paintWindow.visible = false
    ui.tonerWindow.visible = false
    ui.vinylWindow.visible = false

    if section.customWindow then
        showColorpicker(false)
        ui.buyWindow.visible = false
        ui[section.customWindow].visible = true
    else
        showColorpicker(true)
        setColorpickerColor(getVehicleColorByName(name))
        ui.buyWindow.visible = true
        ui.buyWindow.text = section.label
        currentPrice = section.price
        resetBuyButtonText()

        if activeSection == "body" then
            ui.buttonCopy.text = "Скопировать дополнительный цвет"
        else
            ui.buttonCopy.text = "Скопировать основной цвет"
        end
    end

    if activeSection == "paint" then

        ui.paintList:clear()
        --ui.paintList:addRow("Без винила")
        for k, v in pairs(PalitraColor) do
            local rowIndex = ui.paintList:addRow(v[2])
            ui.paintList:setItemData(rowIndex, 1,v[1])
        end
        ui.paintList:setSelectedItem(0, 1)
        --updatePaintSection()
    elseif activeSection == "toner" then
        resetTonerScrolls()
        updateToner()
    elseif activeSection == "vinyls" then
        local paintjobs = exports["car_components"]:getVehiclePaintjobs(localPlayer.vehicle)
        if type(paintjobs) ~= "table" then
            paintjobs = {}
        end
        ui.vinylsList:clear()
        ui.vinylsList:addRow("Без винила")
        for i, paintjob in ipairs(paintjobs) do
            local rowIndex = ui.vinylsList:addRow(paintjob.name)
            ui.vinylsList:setItemData(rowIndex, 1, paintjob.file)
        end
        ui.vinylsList:setSelectedItem(0, 1)
        updateVinylSection()
    end
end

local function addSection(name)
    local rowIndex = ui.sectionsList:addRow(sections[name].label)
    ui.sectionsList:setItemData(rowIndex, 1, name)
end

function showPaintUI(visible)
    showChat(not visible)
    showColorpicker(visible)
    ui.buyWindow.visible = visible
    ui.sectionsWindow.visible = visible
    ui.buttonExit.enabled = true
    ui.buttonBuyColor.enabled = true
    ui.exitButton.visible = visible

    if visible then

        addEventHandler("onColorpickerChange", resourceRoot, updateColor)
        addEventHandler("onColorpickerChange2", resourceRoot, updateColor2)

        ui.sectionsList:clear()
        addSection("body")
        addSection("additional")
        addSection("wheels")
        addSection("paint")
        addSection("hlbody")
        addSection("toner")
        if isResourceRunning("car_components") then
		print(#exports["car_components"]:getVehiclePaintjobs(localPlayer.vehicle))
			print( tostring( exports["car_components"]:isVehiclePaintjobAllowed(localPlayer.vehicle) ))
            if #exports["car_components"]:getVehiclePaintjobs(localPlayer.vehicle) > 0 then
               addSection("vinyls")
           end
        end
        showSection("body")
        guiGridListSetSelectedItem(ui.sectionsList, 0, 1)
    else
    	ui.paintWindow.visible = false
        ui.tonerWindow.visible = false
        ui.vinylWindow.visible = false
        removeEventHandler("onColorpickerChange", resourceRoot, updateColor)
		removeEventHandler("onColorpickerChange2", resourceRoot, updateColor2)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local width, height
    width = 280
    height = 202
    local x = 10
    local y = 15

    -- Окно разделов
    ui.sectionsWindow = GuiWindow(x, y, width, height, "Покрасочная", false)
    ui.sectionsList = GuiGridList(5, 25, width - 10, height - 30 - 40, false, ui.sectionsWindow)
    ui.sectionsList:setSortingEnabled(false)
    ui.sectionsList:addColumn("Название", 0.9)
	ui.sectionsWindow.visible = false

    addEventHandler("onClientGUIClick", ui.sectionsList, function ()
        local name = getSelectedSectionName()
        showSection(name)
    end, false)

    ui.buttonExit = GuiButton(80, height - 40, width - 160, 30, "Выход", false, ui.sectionsWindow)
    addEventHandler("onClientGUIClick", ui.buttonExit, function ()
        ui.buttonExit.enabled = false
        exitPaintGarage()
    end, false)

    -- Выбор цвета
    y = y + height + 10
    local windowsY = y
    createColorpicker(x, y)
    width, height = getColorpickerSize()
    -- Окно покупки
    y = y + height + 10
    height = 120
    ui.buyWindow = GuiWindow(x, y, width, height, "Покупка", false)
    y = 25
    ui.buttonCopy = GuiButton(10, y, width - 20, 40, "Скопировать цвет", false, ui.buyWindow)
    addEventHandler("onClientGUIClick", ui.buttonCopy, function ()
        local name = "additional"
        if activeSection == "additional" or activeSection == "wheels" then
            name = "body"
        end
        setColorpickerColor(getVehicleColorByName(name))
    end, false)
    y = y + 45
    -- Кнопка покупки цвета
    ui.buttonBuyColor = GuiButton(10, y, width - 20, 40, "Купить (99999 руб.)", false, ui.buyWindow)
    addEventHandler("onClientGUIClick", ui.buttonBuyColor, function ()
        buyVehicleColor(activeSection, getColorpickerColor())
        ui.buttonBuyColor.enabled = false
        ui.buttonBuyColor.text = "Цвет куплен"
    end, false)

    -- Окно тонировки
    height = 240
    y = windowsY
    ui.tonerWindow = GuiWindow(10, y, width, height, "Тонировка", false)
    local ty = 25
    local label = GuiLabel(10, ty, width - 20, 15, "Задняя полусфера: $ 20 000 000", false, ui.tonerWindow)
    guiSetFont(label, "default-bold-small")
    guiLabelSetHorizontalAlign(label, "center", false)
    ty = ty + 25
    ui.tonerScrollRear = GuiScrollBar(10, ty, width - 20, 20, true, false, ui.tonerWindow)
    ty = ty + 30
    local label = GuiLabel(10, ty, width - 20, 15, "Передние боковые стекла: $ 20 000 000", false, ui.tonerWindow)
    guiSetFont(label, "default-bold-small")
    guiLabelSetHorizontalAlign(label, "center", false)
    ty = ty + 25
    ui.tonerScrollSide = GuiScrollBar(10, ty, width - 20, 20, true, false, ui.tonerWindow)
    ty = ty + 30
    local label = GuiLabel(10, ty, width - 20, 15, "Лобовое стекло: $ 20 000 000", false, ui.tonerWindow)
    guiSetFont(label, "default-bold-small")
    guiLabelSetHorizontalAlign(label, "center", false)
    ty = ty + 25
    ui.tonerScrollFront = GuiScrollBar(10, ty, width - 20, 20, true, false, ui.tonerWindow)
    ty = ty + 30
    ui.buttonBuyToner   = GuiButton(10, ty, width - 130, 40, "Купить (99999 руб.)", false, ui.tonerWindow)
    -- Покупка тонировки
    addEventHandler("onClientGUIClick", ui.buttonBuyToner, function ()
        ui.buttonBuyToner.enabled = false
        local price, changedValues = calculateTonerPrice()
        if price <= getPlayerMoney(localPlayer) then
            triggerServerEvent("paintGarageBuyToner", resourceRoot, changedValues)
        end
    end, false)
    ui.buttonResetToner = GuiButton(width - 115, ty, 110, 40, "Сброс", false, ui.tonerWindow)
    -- Сброс тонировки
    addEventHandler("onClientGUIClick", ui.buttonResetToner, function ()
        resetVehiclePreview()
        resetTonerScrolls()
        updateToner()
    end, false)

    addEventHandler("onClientGUIScroll", ui.tonerScrollRear,  updateToner)
    addEventHandler("onClientGUIScroll", ui.tonerScrollSide,  updateToner)
    addEventHandler("onClientGUIScroll", ui.tonerScrollFront, updateToner)

    -- Окно выбора винила
    height = 240
    y = windowsY
    ui.vinylWindow = GuiWindow(10, y, width, height, "Винилы", false)
    ui.vinylsList = GuiGridList(5, 25, width - 10, height - 30 - 45 - 20, false, ui.vinylWindow)
    ui.vinylsList:setSortingEnabled(false)
    ui.vinylsList:addColumn("Название", 0.9)
    ui.buttonBuyVinyl = GuiButton(10, height - 45, width - 20, 40, "Купить ($ " .. Config.paintjobPrice ..  ")", false, ui.vinylWindow)
    ui.toggleVinylColor = GuiCheckBox(10, height - 45 - 26, width - 20, 25, "Оригинальный цвет винила", false, false, ui.vinylWindow)

    addEventHandler("onClientGUIClick", ui.vinylsList, updateVinylSection, false)
    addEventHandler("onClientGUIClick", ui.toggleVinylColor, updateVinylSection, false)

    addEventHandler("onClientGUIClick", ui.buttonBuyVinyl, function ()
        local paintjob = getSelectedPaintjob()
        local price = Config.paintjobPrice
        if not paintjob then
            price = Config.paintjobRemovePrice
        end
        if getPlayerMoney(localPlayer) < price then
            return
        end
        triggerServerEvent("paintGarageBuyPaintjob", resourceRoot, localPlayer.vehicle:getData("paintjob"), ui.toggleVinylColor.selected)
        ui.buttonBuyVinyl.enabled = false
        ui.buttonBuyVinyl.text = "Данный винил уже установлен"
    end, false)


    -- Окно выбора краски кузова
    height = 240
    y = windowsY
    ui.paintWindow = GuiWindow(10, y, width, height, "Тип краски кузова", false)
    ui.paintList = GuiGridList(5, 25, width - 10, height - 30 - 45 - 20, false, ui.paintWindow)
    ui.paintList:setSortingEnabled(false)
    ui.paintList:addColumn("Название", 0.9)
    ui.buttonBuyPaint = GuiButton(10, height - 45, width - 20, 40, "Купить ($ " .. Config.paintjobPrice ..  ")", false, ui.paintWindow)
	
	addEventHandler("onClientGUIClick", ui.buttonBuyPaint, function ()
        local colorType = getSelectedColorType()
        local price = PalitraColor[colorType][3]
        if not colorType then
            price = 0
        end
        if getPlayerMoney(localPlayer) < price then
            return
        end
		if colorType == 1 then colorType = false end
        triggerServerEvent("painGaraColor", resourceRoot, colorType, price)
		localPlayer.vehicle:setData('colorType', colorType)
        ui.buttonBuyPaint.enabled = false
        ui.buttonBuyPaint.text = "Данный винил уже установлен"
    end, false)
	
    addEventHandler("onClientGUIClick", ui.paintList, updateVinylSection, false)
    addEventHandler("onClientGUIClick", ui.paintList, updateColorTypeSection, false)
	
 

    local exitButtonWidth = 100
    local exitButtonHeight = 40
    ui.exitButton = GuiButton(screenSize.x - exitButtonWidth - 10, screenSize.y - exitButtonHeight - 20,
        exitButtonWidth, exitButtonHeight, "Выход", false)
    addEventHandler("onClientGUIClick", ui.exitButton, function ()
        ui.buttonExit.enabled = false
        exitPaintGarage()
    end, false)

    showPaintUI(false)
end)