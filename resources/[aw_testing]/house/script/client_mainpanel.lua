
local screenW, screenH = guiGetScreenSize()
currentMarkerData = {}
enabledButtons = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		-- ================= ОКНО ИГРОКОВ =================
		GUI.window.main = guiCreateWindow((screenW - 454), (screenH - 436), 424, 406, "Панель дома", false)
		guiWindowSetSizable(GUI.window.main, false)

		GUI.label.buy = guiCreateLabel(10, 25, 128, 15, "Приобрести", false, GUI.window.main)
		guiLabelSetHorizontalAlign(GUI.label.buy, "center", false)
		guiLabelSetVerticalAlign(GUI.label.buy, "center")
		guiSetFont(GUI.label.buy, "default-bold-small")
		guiLabelSetColor(GUI.label.buy, 0, 153, 255)
		GUI.button.buy = guiCreateButton(10, 50, 128, 128, "", false, GUI.window.main)
		GUI.staticimage.buy = guiCreateStaticImage(0, 0, 128, 128, "images/icon_buy.png", false, GUI.button.buy)

		GUI.label.sell = guiCreateLabel(148, 25, 128, 15, "Продать", false, GUI.window.main)
		guiLabelSetHorizontalAlign(GUI.label.sell, "center", false)
		guiLabelSetVerticalAlign(GUI.label.sell, "center")
		guiSetFont(GUI.label.sell, "default-bold-small")
		guiLabelSetColor(GUI.label.sell, 0, 153, 255)
		GUI.button.sell = guiCreateButton(148, 50, 128, 128, "", false, GUI.window.main)
		GUI.staticimage.sell = guiCreateStaticImage(0, 0, 128, 128, "images/icon_sale.png", false, GUI.button.sell)

		GUI.label.changeKey = guiCreateLabel(286, 25, 128, 15, "Сменить ключ", false, GUI.window.main)
		guiLabelSetHorizontalAlign(GUI.label.changeKey, "center", false)
		guiLabelSetVerticalAlign(GUI.label.changeKey, "center")
		guiSetFont(GUI.label.changeKey, "default-bold-small")
		guiLabelSetColor(GUI.label.changeKey, 0, 153, 255)
		GUI.button.changeKey = guiCreateButton(286, 50, 128, 128, "", false, GUI.window.main)
		GUI.staticimage.changeKey = guiCreateStaticImage(0, 0, 128, 128, "images/icon_key.png", false, GUI.button.changeKey)

		GUI.label.enter = guiCreateLabel(10, 193, 128, 15, "Зайти в дом", false, GUI.window.main)
		guiLabelSetHorizontalAlign(GUI.label.enter, "center", false)
		guiLabelSetVerticalAlign(GUI.label.enter, "center")
		guiSetFont(GUI.label.enter, "default-bold-small")
		guiLabelSetColor(GUI.label.enter, 0, 153, 255)
		GUI.button.enter = guiCreateButton(10, 218, 128, 128, "", false, GUI.window.main)
		GUI.staticimage.enter = guiCreateStaticImage(0, 0, 128, 128, "images/icon_enter.png", false, GUI.button.enter)

		GUI.label.newOwner = guiCreateLabel(148, 193, 128, 15, "Продать игроку", false, GUI.window.main)
		guiLabelSetHorizontalAlign(GUI.label.newOwner, "center", false)
		guiLabelSetVerticalAlign(GUI.label.newOwner, "center")
		guiSetFont(GUI.label.newOwner, "default-bold-small")
		guiLabelSetColor(GUI.label.newOwner, 0, 153, 255)
		GUI.button.newOwner = guiCreateButton(148, 218, 128, 128, "", false, GUI.window.main)
		GUI.staticimage.newOwner = guiCreateStaticImage(0, 0, 128, 128, "images/icon_newowner.png", false, GUI.button.newOwner)

		GUI.label.edit = guiCreateLabel(286, 193, 128, 15, "Редактирование", false, GUI.window.main)
		guiLabelSetHorizontalAlign(GUI.label.edit, "center", false)
		guiLabelSetVerticalAlign(GUI.label.edit, "center")
		guiSetFont(GUI.label.edit, "default-bold-small")
		guiLabelSetColor(GUI.label.edit, 0, 153, 255)
		GUI.button.edit = guiCreateButton(286, 218, 128, 128, "", false, GUI.window.main)
		GUI.staticimage.edit = guiCreateStaticImage(0, 0, 128, 128, "images/icon_edit.png", false, GUI.button.edit)

		GUI.label.nomer = guiCreateLabel(10, 356, 128, 15, "Номер: 0", false, GUI.window.main)
		guiLabelSetVerticalAlign(GUI.label.nomer, "center")
		guiSetFont(GUI.label.nomer, "default-bold-small")
		guiLabelSetColor(GUI.label.nomer, 254, 254, 255)

		GUI.label.price = guiCreateLabel(148, 356, 266, 15, "Цена: 0", false, GUI.window.main)
		guiLabelSetVerticalAlign(GUI.label.price, "center")
		guiSetFont(GUI.label.price, "default-bold-small")
		guiLabelSetColor(GUI.label.price, 254, 254, 255)

		GUI.label.owner = guiCreateLabel(10, 381, 266, 15, "Владелец: Nobody", false, GUI.window.main)
		guiLabelSetVerticalAlign(GUI.label.owner, "center")
		guiSetFont(GUI.label.owner, "default-bold-small")
		guiLabelSetColor(GUI.label.owner, 254, 254, 255)

		GUI.button.close = guiCreateButton(384, 366, 30, 30, "X", false, GUI.window.main)
		
		-- ================= СОЗДАНО ВНЕ GUI EDITOR =================
		guiSetVisible(GUI.window.main, false)		
		addEventHandler("onClientMouseEnter", GUI.staticimage.buy,		onMouseEnter)
		addEventHandler("onClientMouseEnter", GUI.staticimage.sell,		onMouseEnter)
		addEventHandler("onClientMouseEnter", GUI.staticimage.changeKey,onMouseEnter)
		addEventHandler("onClientMouseEnter", GUI.staticimage.enter,	onMouseEnter)
		addEventHandler("onClientMouseEnter", GUI.staticimage.newOwner, onMouseEnter)
		addEventHandler("onClientMouseEnter", GUI.staticimage.edit,		onMouseEnter)
		addEventHandler("onClientMouseLeave", GUI.staticimage.buy,		onMouseLeave)
		addEventHandler("onClientMouseLeave", GUI.staticimage.sell,		onMouseLeave)
		addEventHandler("onClientMouseLeave", GUI.staticimage.changeKey,onMouseLeave)
		addEventHandler("onClientMouseLeave", GUI.staticimage.enter,	onMouseLeave)
		addEventHandler("onClientMouseLeave", GUI.staticimage.newOwner,	onMouseLeave)
		addEventHandler("onClientMouseLeave", GUI.staticimage.edit,		onMouseLeave)
	end
)

function onMouseEnter()
	if enabledButtons[source] then
		guiSetAlpha(source, 0.5)
	end
end

function onMouseLeave()
	if enabledButtons[source] then
		guiSetAlpha(source, 1.0)
	end
end

function openPlayerPanel(markerData, buttons)
	if guiGetVisible(GUI.window.creation) then return end
	guiSetVisible(GUI.window.main, true)
	currentMarkerData = markerData
	guiSetText(GUI.label.nomer, "Номер: "..markerData.ID)
	guiSetText(GUI.label.price, string.format("Цена: %s $.          Парк. мест: %i", explodeNumber(markerData.cost), markerData.carLots))
	if markerData.owner ~= "" then
		guiSetText(GUI.label.owner, "Владелец: "..markerData.owner..". Интерьер: "..markerData.intID)
	else
		guiSetText(GUI.label.owner, "Владелец: отсутствует. Интерьер: "..markerData.intID)
	end
	for id, value in pairs(buttons) do
		if value then
			guiSetEnabled(GUI.button[id], true)
			guiSetAlpha(GUI.staticimage[id], 1.0)
			enabledButtons[GUI.staticimage[id]] = true
		else
			guiSetEnabled(GUI.button[id], false)
			guiSetAlpha(GUI.staticimage[id], 0.3)
			enabledButtons[GUI.staticimage[id]] = false
		end
	end
	showCursor(true)
	guiSetInputMode("no_binds_when_editing")
end
addEvent("openPlayerPanel", true)
addEventHandler("openPlayerPanel", resourceRoot, openPlayerPanel)



function closeAllWindows()
	if not guiGetVisible(GUI.window.creation) then
		guiSetVisible(GUI.window.main, false)
		guiSetVisible(GUI.window.setKey, false)
		guiSetVisible(GUI.window.sellHouse, false)
		guiSetVisible(GUI.window.changeKey, false)
		guiSetVisible(GUI.window.enterHouse, false)
		guiSetVisible(GUI.window.changeOwner, false)
		guiSetVisible(GUI.window.transHouse, false)
		guiSetInputMode("allow_binds")
		showCursor(false)
	end
end
addEvent("closeAllWindows", true)
addEventHandler("closeAllWindows", resourceRoot, closeAllWindows)