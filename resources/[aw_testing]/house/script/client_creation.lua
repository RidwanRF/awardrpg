
local interiorsTable = getInteriorsTable()
local screenW, screenH = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
		-- ================= ОКНО СОЗДАНИЯ ДОМОВ =================
		GUI.window.creation = guiCreateWindow((screenW-360), (screenH-500)/2, 330, 500, "Создание дома", false)
		guiWindowSetSizable(GUI.window.creation, false)

		GUI.label[1] = guiCreateLabel(10, 25, 150, 15, "Маркер входа", false, GUI.window.creation)
		guiLabelSetHorizontalAlign(GUI.label[1], "center", false)
		guiLabelSetVerticalAlign(GUI.label[1], "center")
		guiSetFont(GUI.label[1], "default-bold-small")
		GUI.edit.enterMrkX = guiCreateEdit(10, 50, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.enterMrkX, true)
		guiEditSetMaxLength(GUI.edit.enterMrkX, 15)
		GUI.edit.enterMrkY = guiCreateEdit(10, 85, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.enterMrkY, true)
		guiEditSetMaxLength(GUI.edit.enterMrkY, 15)
		GUI.edit.enterMrkZ = guiCreateEdit(10, 120, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.enterMrkZ, true)
		guiEditSetMaxLength(GUI.edit.enterMrkZ, 15)
		GUI.button.setEnterMrkPos = guiCreateButton(10, 155, 150, 35, "Установить координаты", false, GUI.window.creation)

		GUI.label[2] = guiCreateLabel(170, 25, 150, 15, "Маркер выхода", false, GUI.window.creation)
		guiLabelSetHorizontalAlign(GUI.label[2], "center", false)
		guiLabelSetVerticalAlign(GUI.label[2], "center")
		guiSetFont(GUI.label[2], "default-bold-small")
		GUI.edit.exitMrkX = guiCreateEdit(170, 50, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.exitMrkX, true)
		guiEditSetMaxLength(GUI.edit.exitMrkX, 15)
		GUI.edit.exitMrkY = guiCreateEdit(170, 85, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.exitMrkY, true)
		guiEditSetMaxLength(GUI.edit.exitMrkY, 15)
		GUI.edit.exitMrkZ = guiCreateEdit(170, 120, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.exitMrkZ, true)
		guiEditSetMaxLength(GUI.edit.exitMrkZ, 15)
		GUI.button.setExitMrkPos = guiCreateButton(170, 155, 150, 35, "Установить координаты", false, GUI.window.creation)

		GUI.label[3] = guiCreateLabel(10, 210, 150, 15, "Координаты входа", false, GUI.window.creation)
		guiLabelSetHorizontalAlign(GUI.label[3], "center", false)
		guiLabelSetVerticalAlign(GUI.label[3], "center")
		guiSetFont(GUI.label[3], "default-bold-small")
		GUI.edit.enterPointX = guiCreateEdit(10, 235, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.enterPointX, true)
		guiEditSetMaxLength(GUI.edit.enterPointX, 15)
		GUI.edit.enterPointY = guiCreateEdit(10, 270, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.enterPointY, true)
		guiEditSetMaxLength(GUI.edit.enterPointY, 15)
		GUI.edit.enterPointZ = guiCreateEdit(10, 305, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.enterPointZ, true)
		guiEditSetMaxLength(GUI.edit.enterPointZ, 15)
		GUI.button.setEnterPosPos = guiCreateButton(10, 340, 105, 35, "Установить координаты", false, GUI.window.creation)
        GUI.button.tpEnter = guiCreateButton(125, 340, 35, 35, "ТП", false, GUI.window.creation)

		GUI.label[4] = guiCreateLabel(170, 210, 150, 15, "Координаты выхода", false, GUI.window.creation)
		guiLabelSetHorizontalAlign(GUI.label[4], "center", false)
		guiLabelSetVerticalAlign(GUI.label[4], "center")
		guiSetFont(GUI.label[4], "default-bold-small")
		GUI.edit.exitPointX = guiCreateEdit(170, 235, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.exitPointX, true)
		guiEditSetMaxLength(GUI.edit.exitPointX, 15)
		GUI.edit.exitPointY = guiCreateEdit(170, 270, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.exitPointY, true)
		guiEditSetMaxLength(GUI.edit.exitPointY, 15)
		GUI.edit.exitPointZ = guiCreateEdit(170, 305, 150, 25, "", false, GUI.window.creation)
		guiEditSetReadOnly(GUI.edit.exitPointZ, true)
		guiEditSetMaxLength(GUI.edit.exitPointZ, 15)
		GUI.button.setExitPosPos = guiCreateButton(170, 340, 105, 35, "Установить координаты", false, GUI.window.creation)
        GUI.button.tpExit = guiCreateButton(285, 340, 35, 35, "ТП", false, GUI.window.creation)

		GUI.label[5] = guiCreateLabel(10, 395, 58, 25, "Интерьер", false, GUI.window.creation)
		guiLabelSetVerticalAlign(GUI.label[5], "center")
		guiSetFont(GUI.label[5], "default-bold-small")
		GUI.edit.interior = guiCreateEdit(78, 395, 82, 25, "", false, GUI.window.creation)
		guiEditSetMaxLength(GUI.edit.interior, 15)

		GUI.label[6] = guiCreateLabel(170, 395, 30, 25, "Цена", false, GUI.window.creation)
		guiLabelSetVerticalAlign(GUI.label[6], "center")
		guiSetFont(GUI.label[6], "default-bold-small")
		GUI.edit.price = guiCreateEdit(210, 395, 110, 25, "", false, GUI.window.creation)
		guiEditSetMaxLength(GUI.edit.price, 15)
        GUI.label[1] = guiCreateLabel(140, 434, 115, 15, "Слотов транспорта", false, GUI.window.creation)
        guiSetFont(GUI.label[1], "default-bold-small")
        GUI.edit.carLots = guiCreateEdit(265, 430, 55, 25, "", false, GUI.window.creation)
        guiEditSetReadOnly(GUI.edit.carLots, true)   

		GUI.button.interiorPanel = guiCreateButton(10, 455, 80, 35, "<<< Панель интерьеров", false, GUI.window.creation)

		GUI.button.create = guiCreateButton(100, 465, 80, 25, "Создать", false, GUI.window.creation)

		GUI.button.clear = guiCreateButton(205, 465, 80, 25, "Очистить", false, GUI.window.creation)

		GUI.button.closeCreation = guiCreateButton(295, 465, 25, 25, "X", false, GUI.window.creation)

		-- ================= ОКНО ИНТЕРЬЕРОВ =================
		GUI.window.interiors = guiCreateWindow((screenW-900), (screenH-500)/2, 540, 410, "Выбор интерьера", false)
		guiWindowSetSizable(GUI.window.interiors, false)

		GUI.gridlist.interiors = guiCreateGridList(10, 25, 210, 300, false, GUI.window.interiors)
		guiGridListAddColumn(GUI.gridlist.interiors, "Название", 0.87)

		GUI.staticimage.interior = guiCreateStaticImage(230, 25, 300, 300, "images/choose.jpg", false, GUI.window.interiors)

		GUI.button.saveReturnPos = guiCreateButton(10, 335, 80, 65, "Запомнить позицию возврата", false, GUI.window.interiors)
		GUI.button.moveToInterior = guiCreateButton(100, 335, 95, 65, "Переместиться в интерьер", false, GUI.window.interiors)
		GUI.label.returnToWorld = guiCreateLabel(205, 335, 235, 20, "Позиция возврата не сохранена", false, GUI.window.interiors)
		guiLabelSetVerticalAlign(GUI.label.returnToWorld, "center")
		GUI.button.returnToWorld = guiCreateButton(205, 365, 80, 35, "Вернуться", false, GUI.window.interiors)

		GUI.button.moveCoordinates = guiCreateButton(450, 335, 80, 65, "Передать\nданные\n===>>>", false, GUI.window.interiors)

		GUI.button.closeInteriors = guiCreateButton(415, 375, 25, 25, "X", false, GUI.window.interiors)
		
		
		-- ================= СОЗДАНО ВНЕ GUI EDITOR =================
		guiSetVisible(GUI.window.creation, false)
		guiSetVisible(GUI.window.interiors, false)
		guiSetEnabled(GUI.button.moveToInterior, false)
		guiSetEnabled(GUI.button.returnToWorld, false)
		guiSetEnabled(GUI.button.moveCoordinates, false)
		guiSetEnabled(GUI.button.setExitMrkPos, false)
		guiSetEnabled(GUI.button.setEnterPosPos, false)
		guiSetEnabled(GUI.edit.interior, false)
		for i, tableRow in ipairs(interiorsTable) do
			local row = guiGridListAddRow(GUI.gridlist.interiors)
			guiGridListSetItemText(GUI.gridlist.interiors, row, 1, tableRow[1], false, false)
			guiGridListSetItemData(GUI.gridlist.interiors, row, 1, i)
		end
end)

local binded = false
local savedPosX, savedPosY, savedPosZ

function openHPanel()
	if not guiGetVisible(GUI.window.creation) then
		closeAllWindows()
		guiSetVisible(GUI.window.creation, true)
		showCursor(true)
		bindKey("mouse2", "down", showHide)
		addEventHandler("onClientRender", root, drawCrsrInfo)
		if (not binded) then
			bindKey("arrow_u", "down", goInteriorListUp)
			bindKey("arrow_d", "down", goInteriorListDown)
			binded = true
		end
	end
end
addEvent("openHPanel", true)
addEventHandler("openHPanel", resourceRoot, openHPanel)

function goInteriorListUp()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.interiors) - 1
	local rowCount = guiGridListGetRowCount(GUI.gridlist.interiors)
	if selected ~= -1 then 
		guiGridListSetSelectedItem(GUI.gridlist.interiors, selected, 1)
	else
		guiGridListSetSelectedItem(GUI.gridlist.interiors, rowCount-1, 1)
	end
	source = GUI.gridlist.interiors
	onAdminGUIClick()
end

function goInteriorListDown()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.interiors) + 1
	local rowCount = guiGridListGetRowCount(GUI.gridlist.interiors)
	if selected < rowCount then 
		guiGridListSetSelectedItem(GUI.gridlist.interiors, selected, 1)
	else
		guiGridListSetSelectedItem(GUI.gridlist.interiors, 0, 1)
	end
	source = GUI.gridlist.interiors
	onAdminGUIClick()
end

local interiorID
function setCreationInteriorID(id)
	interiorID = id
end

function onAdminGUIClick()
	if (source == GUI.button.closeCreation) then
		closeHPanel()

	elseif (source == GUI.button.setEnterMrkPos) then
		local x, y, z = getElementPosition(localPlayer)
		guiSetText(GUI.edit.enterMrkX, math.round(x, 6))
		guiSetText(GUI.edit.enterMrkY, math.round(y, 6))
		guiSetText(GUI.edit.enterMrkZ, math.round(z, 6))

	elseif (source == GUI.button.tpEnter) then
		local x = tonumber(guiGetText(GUI.edit.enterPointX))
		local y = tonumber(guiGetText(GUI.edit.enterPointY))
		local z = tonumber(guiGetText(GUI.edit.enterPointZ))
		local int = tonumber(guiGetText(GUI.edit.interior))
		if (not x) or (not y) or (not z) or (not int) then
			outputChatBad("Должны быть заполнены 3 поля выше и интерьер!")
			return
		end
		triggerServerEvent("adminTeleport", resourceRoot, x, y, z, int, 31000)

	elseif (source == GUI.button.setExitPosPos) then
		local x, y, z = getElementPosition(localPlayer)
		guiSetText(GUI.edit.exitPointX, math.round(x, 6))
		guiSetText(GUI.edit.exitPointY, math.round(y, 6))
		guiSetText(GUI.edit.exitPointZ, math.round(z, 6))

	elseif (source == GUI.button.tpExit) then
		local x = tonumber(guiGetText(GUI.edit.exitPointX))
		local y = tonumber(guiGetText(GUI.edit.exitPointY))
		local z = tonumber(guiGetText(GUI.edit.exitPointZ))
		if (not x) or (not y) or (not z) then
			outputChatBad("Должны быть заполнены 3 поля координат!")
			return
		end
		triggerServerEvent("adminTeleport", resourceRoot, x, y, z, 0, 0)

	elseif (source == GUI.button.interiorPanel) or (source == GUI.button.closeInteriors) then
		if not guiGetVisible(GUI.window.interiors) then
			guiSetText(GUI.button.interiorPanel, ">>> Панель интерьеров")
			guiSetVisible(GUI.window.interiors, true)
		else
			guiSetText(GUI.button.interiorPanel, "<<< Панель интерьеров")
			guiSetVisible(GUI.window.interiors, false)
		end

	elseif (source == GUI.button.create) then
		local newData = {}
		newData.enterMrkX = guiGetText(GUI.edit.enterMrkX)
		newData.enterMrkY = guiGetText(GUI.edit.enterMrkY)
		newData.enterMrkZ = guiGetText(GUI.edit.enterMrkZ)
		newData.exitPointX = guiGetText(GUI.edit.exitPointX)
		newData.exitPointY = guiGetText(GUI.edit.exitPointY)
		newData.exitPointZ = guiGetText(GUI.edit.exitPointZ)
		newData.price = tonumber(guiGetText(GUI.edit.price))
		newData.carLots = tonumber(guiGetText(GUI.edit.carLots))
		newData.intID = interiorID
		if (newData.enterMrkX == "") or (newData.enterMrkY == "") or (newData.enterMrkZ == "")
			or (newData.exitPointX == "") or (newData.exitPointY == "") or (newData.exitPointZ == "")
			or (not newData.price) or (not newData.intID) then
			outputChatBad("Заполнены не все поля!")
			playSound("sounds/click_question.wav")
			return
		end
		triggerServerEvent("createHouse", resourceRoot, newData)
		closeHPanel()

	elseif (source == GUI.button.clear) then
		guiSetText(GUI.edit.enterMrkX, "")
		guiSetText(GUI.edit.enterMrkY, "")
		guiSetText(GUI.edit.enterMrkZ, "")
		guiSetText(GUI.edit.exitMrkX, "")
		guiSetText(GUI.edit.exitMrkY, "")
		guiSetText(GUI.edit.exitMrkZ, "")
		guiSetText(GUI.edit.enterPointX, "")
		guiSetText(GUI.edit.enterPointY, "")
		guiSetText(GUI.edit.enterPointZ, "")
		guiSetText(GUI.edit.exitPointX, "")
		guiSetText(GUI.edit.exitPointY, "")
		guiSetText(GUI.edit.exitPointZ, "")
		guiSetText(GUI.edit.interior, "")
		guiSetText(GUI.edit.price, "")
		interiorID = false

	elseif (source == GUI.gridlist.interiors) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.interiors)
		if (selected ~= -1) then
			guiSetEnabled(GUI.button.moveCoordinates, true)
			local imagePath = "images/"..interiorsTable[ guiGridListGetItemData(GUI.gridlist.interiors, selected, 1) ][9]
			guiStaticImageLoadImage(GUI.staticimage.interior, imagePath)
			local w, h = guiStaticImageGetNativeSize(GUI.staticimage.interior)
			guiSetSize(GUI.staticimage.interior, w, h, false)
		else
			guiSetEnabled(GUI.button.moveCoordinates, false)
			guiStaticImageLoadImage(GUI.staticimage.interior, "images/choose.jpg")
			guiSetSize(GUI.staticimage.interior, 300, 300, false)
		end

	elseif (source == GUI.button.saveReturnPos) then
		savedPosX, savedPosY, savedPosZ = getElementPosition(localPlayer)
		guiSetEnabled(GUI.button.moveToInterior, true)
		guiSetEnabled(GUI.button.returnToWorld, true)
		guiSetText(GUI.label.returnToWorld, "Возвр. на: "..math.round(savedPosX, 3)..", "..math.round(savedPosY, 3)..", "..math.round(savedPosZ, 3))

	elseif (source == GUI.button.moveToInterior) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.interiors)
		if (selected ~= -1) then
			local interior = interiorsTable[ guiGridListGetItemData(GUI.gridlist.interiors, selected, 1) ]
			triggerServerEvent("adminTeleport", resourceRoot, interior[5], interior[6], interior[7], interior[8], 31000)
		else
			outputChatBad("Не выбран интерьер!")
		end

	elseif (source == GUI.button.returnToWorld) then
		if savedPosX then
			triggerServerEvent("adminTeleport", resourceRoot, savedPosX, savedPosY, savedPosZ, 0, 0)
		else
			outputChatBad("Нет сохраненной позиции!")
		end

	elseif (source == GUI.button.moveCoordinates) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.interiors)
		if (selected ~= -1) then
			local interior = interiorsTable[ guiGridListGetItemData(GUI.gridlist.interiors, selected, 1) ]
			guiSetText(GUI.edit.exitMrkX, interior[2])
			guiSetText(GUI.edit.exitMrkY, interior[3])
			guiSetText(GUI.edit.exitMrkZ, interior[4])
			guiSetText(GUI.edit.enterPointX, interior[5])
			guiSetText(GUI.edit.enterPointY, interior[6])
			guiSetText(GUI.edit.enterPointZ, interior[7])
			guiSetText(GUI.edit.interior, interior[8])
			interiorID = interior.ID
		else
			outputChatBad("Не выбран интерьер!")
		end

	end

end
addEventHandler("onClientGUIClick", resourceRoot, onAdminGUIClick)

function onPriceChanged()
	if (source == GUI.edit.price) then
		local price = tonumber(guiGetText(GUI.edit.price))
		if (price) then
			if (price < 100000000) then
				guiSetText(GUI.edit.carLots, 10)
			elseif (price < 500000000) then
				guiSetText(GUI.edit.carLots, 20)
			elseif (price < 1000000000) then
				guiSetText(GUI.edit.carLots, 30)
			elseif (price < 2000000000) then
				guiSetText(GUI.edit.carLots, 40)
			elseif (price < 4000000000) then
				guiSetText(GUI.edit.carLots, 50)
			elseif (price < 8000000000) then
				guiSetText(GUI.edit.carLots, 60)
			else
				guiSetText(GUI.edit.carLots, 70)
			end
		else
			guiSetText(GUI.edit.carLots, "")
		end
	end
end
addEventHandler("onClientGUIChanged", resourceRoot, onPriceChanged)

function closeHPanel()
	guiSetVisible(GUI.window.creation, false)
	guiSetVisible(GUI.window.interiors, false)
	guiSetText(GUI.button.interiorPanel, "<<< Панель интерьеров")
	showCursor(false)
	unbindKey("mouse2", "down", showHide)
	removeEventHandler("onClientRender", root, drawCrsrInfo)
end

function showHide()
	showCursor(not isCursorShowing())
end

local cursorOverGUI = false
addEventHandler("onClientMouseEnter", resourceRoot, function() cursorOverGUI = true end)
addEventHandler("onClientMouseLeave", resourceRoot, function() cursorOverGUI = false end)
local white = tocolor(255,255,255, 255)

function drawCrsrInfo()
	if isCursorShowing() and not cursorOverGUI then
		local x, y = getCursorPosition()
		if x and y then
			dxDrawText("ПКМ чтобы скрыть/показать курсор.", screenW * x + 10, screenH * y - 10, screenW, screenH, white, 1, 'default', 'left', 'top', false, false, true)
		end
	end
end

function math.round(number, decimals, method)
	decimals = decimals or 0
	local factor = 10 ^ decimals
	if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
	else return tonumber(("%."..decimals.."f"):format(number)) end
end
	
