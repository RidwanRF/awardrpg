
local nomerInInfoPanel
local moneyFederal = 200
local moneyWars = 150
local moneyDiplomat = 270
local moneyPolice = 120
local moneyNameName = "Не выбран номер"

GUI = {
    tab = {},
    tabpanel = {},
    edit = {},
    button = {},
    window = {},
    label = {},
    radiobutton = {},
    staticimage = {},
    gridlist = {},
    checkbox = {},
}
addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenW, screenH = guiGetScreenSize()
	GUI.window.main = guiCreateWindow((screenW - 520) / 2, (screenH - 360) / 2, 520, 360, "Смена номера", false)
	guiWindowSetSizable(GUI.window.main, false)
	
    GUI.label.donateglobal = guiCreateLabel(15, 30, 585, 15, "Донат счет:", false, GUI.window.main)
	guiSetFont(GUI.label.donateglobal, "clear-normal")
	GUI.label.donatetext = guiCreateLabel(95, 30, 585, 15, "", false, GUI.window.main)
	guiSetFont(GUI.label.donatetext, "clear-normal")

	GUI.label.oldSmall = guiCreateLabel(15, 50, 585, 15, "Старый номер:", false, GUI.window.main)
	guiSetFont(GUI.label.oldSmall, "clear-normal")
	GUI.label.oldNomer = guiCreateLabel(120, 50, 585, 15, "", false, GUI.window.main)

	GUI.label.newSmall = guiCreateLabel(15, 70, 585, 15, "Новый номер:", false, GUI.window.main)
	guiSetFont(GUI.label.newSmall, "clear-normal")
	GUI.label.newNomer = guiCreateLabel(110, 70, 585, 15, "", false, GUI.window.main)

	GUI.button.close = guiCreateButton(410, 30, 95, 25, "Закрыть", false, GUI.window.main)

	--// tab 
	GUI.tabpanel.main = guiCreateTabPanel(15, 95, 490, 250, false, GUI.window.main)

	GUI.tab.auto = guiCreateTab("Автомобили", GUI.tabpanel.main)
	GUI.radiobutton.rus = guiCreateRadioButton(10, 10, 165, 15, "Номер России", false, GUI.tab.auto)
	guiRadioButtonSetSelected(GUI.radiobutton.rus, true)
	GUI.radiobutton.ukr = guiCreateRadioButton(10, 35, 165, 15, "Номер Украины", false, GUI.tab.auto)
	GUI.radiobutton.blr = guiCreateRadioButton(10, 85, 165, 15, "Номер Белоруссии", false, GUI.tab.auto)
	GUI.radiobutton.kaz = guiCreateRadioButton(10, 60, 165, 15, "Номер Казахстана", false, GUI.tab.auto)
	GUI.edit.halfLeft = guiCreateEdit(10, 110, 110, 25, "", false, GUI.tab.auto)
	GUI.edit.halfRight = guiCreateEdit(130, 110, 45, 25, "", false, GUI.tab.auto)
	GUI.edit.full = guiCreateEdit(10, 110, 165, 25, "", false, GUI.tab.auto)
	GUI.button.apply = guiCreateButton(10, 145, 165, 25, "Перейти к покупке", false, GUI.tab.auto)

	GUI.label[21] = guiCreateLabel(400, 10, 75, 195, "Примеры:\n\nРоссия:\na123вc 22\n\nУкраина:\nAB1234CE\n\nКазахстан:\n123ABC 12\n\nБелоруссия:\n1234AB5", false, GUI.tab.auto)
	guiLabelSetHorizontalAlign(GUI.label[21], "center", false)

	GUI.tab.moto = guiCreateTab("Мотоциклы", GUI.tabpanel.main)

	GUI.label[22] = guiCreateLabel(10, 10, 135, 15, "Номер для мотоцикла:", false, GUI.tab.moto)
	guiLabelSetHorizontalAlign(GUI.label[22], "center", false)
	GUI.edit.moto1 = guiCreateEdit(10, 35, 135, 25, "", false, GUI.tab.moto)
	guiEditSetMaxLength(GUI.edit.moto1, 4)
	GUI.edit.moto2 = guiCreateEdit(10, 70, 62, 25, "", false, GUI.tab.moto)
	guiEditSetMaxLength(GUI.edit.moto2, 2)
	GUI.edit.moto3 = guiCreateEdit(83, 70, 62, 25, "", false, GUI.tab.moto)
	guiEditSetMaxLength(GUI.edit.moto3, 2)
	GUI.button.checkMoto = guiCreateButton(155, 35, 85, 25, "Проверить", false, GUI.tab.moto)
	GUI.button.applyMoto = guiCreateButton(155, 70, 85, 25, "Применить", false, GUI.tab.moto)
	GUI.label[40] = guiCreateLabel(10, 105, 135, 15, "Пример: 1234 aв 12", false, GUI.tab.moto)
	guiLabelSetHorizontalAlign(GUI.label[40], "center", false)

    --
    --
  --  local moneyFederal = 200
--local moneyWars = 150
--local moneyDiplomat = 320
--local moneyPolice = 100
--local moneyNameName = 180
    --
	GUI.tab.donate = guiCreateTab("Донат номера", GUI.tabpanel.main)
    
    guiCreateStaticImage( 10, 10, 130, 32, "files/nm/plate_j.png", false, GUI.tab.donate )
	GUI.edit.editFederal = guiCreateEdit(150, 10, 120, 32, "", false, GUI.tab.donate)
	GUI.button.applyFederal = guiCreateButton(280, 10, 195, 32, "Купить федеральные номера\nза "..moneyFederal.." донат ед.", false, GUI.tab.donate)
	guiEditSetMaxLength(GUI.edit.editFederal, 6)

    guiCreateStaticImage( 10, 50, 130, 32, "files/nm/plate_k.png", false, GUI.tab.donate )
	GUI.edit.editWars = guiCreateEdit(150, 50, 120, 32, "", false, GUI.tab.donate)
	GUI.button.applyWars = guiCreateButton(280, 50, 195, 32, "Купить военные номера\nза "..moneyWars.." донат ед.", false, GUI.tab.donate)
	guiEditSetMaxLength(GUI.edit.editWars, 8)


	guiCreateStaticImage( 10, 90, 130, 32, "files/nm/plate_l.png", false, GUI.tab.donate )
	GUI.edit.editDiplomat = guiCreateEdit(150, 90, 120, 32, "", false, GUI.tab.donate)
	GUI.button.applyDiplomat = guiCreateButton(280, 90, 195, 32, "Купить дипломат. номера\nза "..moneyDiplomat.." донат ед.", false, GUI.tab.donate)
	guiEditSetMaxLength(GUI.edit.editDiplomat, 8)

	guiCreateStaticImage( 10, 130, 130, 32, "files/nm/plate_b.png", false, GUI.tab.donate )
	GUI.edit.editPolice = guiCreateEdit(150, 130, 120, 32, "", false, GUI.tab.donate)
	GUI.button.applyPolice = guiCreateButton(280, 130, 195, 32, "Купить полицейскиие номера\nза "..moneyPolice.." донат ед.", false, GUI.tab.donate)
	guiEditSetMaxLength(GUI.edit.editPolice, 7)

	--guiCreateStaticImage( 10, 170, 130, 32, "files/nm/plate_h.png", false, GUI.tab.donate )
	GUI.edit.editNamename = guiCreateEdit(150, 170, 120, 32, "", false, GUI.tab.donate)
	GUI.button.applyNamename = guiCreateButton(280, 170, 195, 32, "Купить именные номера\nза "..moneyNameName, false, GUI.tab.donate)
	guiEditSetMaxLength(GUI.edit.editNamename, 8)

	GUI.radiobutton.nameclassic = guiCreateRadioButton(10, 165, 165, 15, "Именной белый", false, GUI.tab.donate)
	GUI.radiobutton.nameblack = guiCreateRadioButton(10, 185, 165, 15, "Именной черный ", false, GUI.tab.donate)
	GUI.radiobutton.namegold = guiCreateRadioButton(10, 205, 165, 15, "Именной золотой", false, GUI.tab.donate)
	--
	--
	--
	
	-- Окно информации о номере
	GUI.window.info = guiCreateWindow((screenW - 220) / 2, (screenH - 335) / 2, 220, 335, "Информация о номере", false)
	guiWindowSetMovable(GUI.window.info, false)
	guiWindowSetSizable(GUI.window.info, false)
	guiSetAlpha(GUI.window.info, 1.00)
	GUI.label.info_currentNomer = guiCreateLabel(10, 25, 200, 15, "Номер:", false, GUI.window.info)
	GUI.label.info_template = guiCreateLabel(10, 50, 200, 75, "Шаблон:\n|z***zz|**| (любые ТРИ повторяющиеся буквы)\n|*YYG**|**| (любые ДВЕ повторяющиеся цифры)", false, GUI.window.info)
	guiLabelSetHorizontalAlign(GUI.label.info_template, "left", true)
	GUI.label.info_cost = guiCreateLabel(10, 135, 200, 75, "Стоимость:\nЗа донат-валюту: 500 ед.\nЗа игровую валюту: 24 000 000₽", false, GUI.window.info)
	guiLabelSetHorizontalAlign(GUI.label.info_cost, "left", true)
	GUI.label[1] = guiCreateLabel(10, 220, 200, 15, "Купить:", false, GUI.window.info)
	GUI.radiobutton.info_forGame = guiCreateRadioButton(10, 245, 200, 15, "За игровую валюту", false, GUI.window.info)
	guiRadioButtonSetSelected(GUI.radiobutton.info_forGame, true)
	GUI.radiobutton.info_forDonat = guiCreateRadioButton(10, 270, 200, 15, "За донат-валюту", false, GUI.window.info)
	GUI.button.info_buy = guiCreateButton(10, 295, 95, 30, "Купить", false, GUI.window.info)
	GUI.button.info_close = guiCreateButton(115, 295, 95, 30, "Закрыть", false, GUI.window.info)


	
	-- Вне GUI Editor
	createAdminControls()
	createStorageGUI()
	createModerationGui()
	guiSetVisible(GUI.window.main, false)
	guiSetEnabled(GUI.tab.auto, false)
	guiSetEnabled(GUI.tab.moto, false)
	guiSetVisible(GUI.window.info, false)
	addEventHandler("onClientGUIBlur", GUI.window.info, onGUIBlur)
	addEventHandler("onClientGUIBlur", GUI.window.confirm, onGUIBlur)
end)

function onGUIBlur()
	if (source == GUI.window.info) and guiGetVisible(GUI.window.info) or 
		(source == GUI.window.confirm) and guiGetVisible(GUI.window.confirm) then
		addEventHandler("onClientPreRender", root, revertFocus)
	end
end
function revertFocus()
	if guiGetVisible(GUI.window.info) then
		guiBringToFront(GUI.window.info)
	elseif guiGetVisible(GUI.window.confirm) then
		guiBringToFront(GUI.window.confirm)
	end
	removeEventHandler("onClientPreRender", root, revertFocus)
end

local textboxes = {last = "rus"}

function openPanelFunc()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end
	local nomer = getElementData(veh, "licensep")
	if not nomer then return end
	
	clearFields()
	if nomerIsCorrect(nomer) then
		local test = string.sub(nomer, 1, 1)
		if (test == "a") then
			guiRadioButtonSetSelected(GUI.radiobutton.rus, true)
			guiSetText(GUI.edit.halfLeft, replaceEngToRus(string.sub(nomer, 3, 8)) )
			guiSetText(GUI.edit.halfRight, string.sub(nomer, 9, 11))
			guiSetText(GUI.edit.adminAuto, string.sub(nomer, 3, 11))
			textboxes.last = "rus"

		elseif (test == "j") then 
			guiRadioButtonSetSelected(GUI.radiobutton.federal, true)
			guiSetText(GUI.edit.donateLeft, replaceEngToRus(string.sub(nomer, 3, 8)) )
			textboxes.last = "fed"
			
		elseif (test == "b") then
			guiSetText(GUI.edit.adminAutoPolic, string.sub(nomer, 3, 10))
			
		elseif (test == "c") then
			guiSetText(GUI.edit.moto1, string.sub(nomer, 3, 6) )
			guiSetText(GUI.edit.moto2, replaceEngToRus(string.sub(nomer, 7, 8)) )
			guiSetText(GUI.edit.moto3, string.sub(nomer, 9, 11))
			guiSetText(GUI.edit.adminMoto, string.sub(nomer, 3, 11))
			
		elseif (test == "d") then
			guiSetText(GUI.edit.adminMotoPolic, string.sub(nomer, 3, 10))
			
		elseif (test == "e") then
			guiRadioButtonSetSelected(GUI.radiobutton.kaz, true)
			guiSetText(GUI.edit.halfLeft, string.sub(nomer, 3, 8) )
			guiSetText(GUI.edit.halfRight, string.sub(nomer, 9, 10) )
			guiSetText(GUI.edit.adminKaz, string.sub(nomer, 3, 10) )
			textboxes.last = "kaz"
			
		elseif (test == "f") then
			guiRadioButtonSetSelected(GUI.radiobutton.ukr, true)
			guiSetText(GUI.edit.full, string.sub(nomer, 3, 10) )
			guiSetText(GUI.edit.adminUkr, string.sub(nomer, 3, 10) )
			textboxes.last = "ukr"
			
		elseif (test == "g") then
			guiRadioButtonSetSelected(GUI.radiobutton.blr, true)
			guiSetText(GUI.edit.full, string.sub(nomer, 3, 9) )
			guiSetText(GUI.edit.adminBelrus, string.sub(nomer, 3, 9) )
			textboxes.last = "blr"
			
		elseif (test == "h") then
			guiSetText(GUI.edit.orderInput, string.sub(nomer, 3) )
			guiSetText(GUI.edit.adminText, string.sub(nomer, 3) )
		end
	end
	showCountryFields()
	
	nomer = exports.car_system:convertPlateIDtoLicensep(nomer)
	--fitTextIntoField(nomer, GUI.label.oldNomer)
	--fitTextIntoField(nomer, GUI.label.newNomer)	
	guiSetText(GUI.label.oldNomer, nomer)
	guiSetText(GUI.label.newNomer, nomer)
	guiSetText(GUI.label.donatetext, convertNumber(exports.bank:getPlayerBankMoney("DONATE")))
	guiSetVisible(GUI.window.main, true)
	local model = getElementModel(veh)
	if (isBike[model]) then
		guiSetEnabled(GUI.tab.auto, false)
		guiSetEnabled(GUI.tab.moto, true)
		guiSetSelectedTab(GUI.tabpanel.main, GUI.tab.moto)
	else
		guiSetEnabled(GUI.tab.auto, true)
		guiSetEnabled(GUI.tab.moto, false)
		guiSetSelectedTab(GUI.tabpanel.main, GUI.tab.auto)
	end
	if getElementData(localPlayer, "function.nomerChange") then
		guiSetVisible(GUI.tab.admin, true)	
	else
		guiSetVisible(GUI.tab.admin, false)	
	end
	showCursor(true)
	guiSetInputMode("no_binds_when_editing")
end
addEvent("openPanel", true)
addEventHandler("openPanel", resourceRoot, openPanelFunc)


function buttonClicksPlayer()
    if (source == GUI.button.close) then
		closePanelFunc()

	--donat nomera 
	elseif (source == GUI.button.applyDonate) then
		local nomer, example = "", ""
		if guiRadioButtonGetSelected(GUI.radiobutton.federal) then
			nomer = "j-"..guiGetText(GUI.edit.donateLeft)
			nomer = replaceRusToEng(nomer)
			example = "a123bc"
		end
		
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("getInputInfo", resourceRoot, nomer)

    elseif (source == GUI.button.apply) then
		local nomer, example = "", ""
		if guiRadioButtonGetSelected(GUI.radiobutton.rus) then
			nomer = "a-"..guiGetText(GUI.edit.halfLeft)..guiGetText(GUI.edit.halfRight)
			nomer = replaceRusToEng(nomer)
			example = "а123вс | 12"
		
		elseif guiRadioButtonGetSelected(GUI.radiobutton.kaz) then
			nomer = guiGetText(GUI.edit.halfLeft)..guiGetText(GUI.edit.halfRight)
			nomer = "e-"..string.upper(nomer)
			example = "123ABC | 12"
		
		elseif guiRadioButtonGetSelected(GUI.radiobutton.ukr) then
			nomer = "f-"..string.upper(guiGetText(GUI.edit.full))
			example = "AB1234CE"
		
		elseif guiRadioButtonGetSelected(GUI.radiobutton.blr) then
			nomer = "g-"..string.upper(guiGetText(GUI.edit.full))
			example = "1234AB5"
		
		end
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: "..example)
			return
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("getInputInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.checkMoto) then
		local nomer = "c-"..guiGetText(GUI.edit.moto1)..guiGetText(GUI.edit.moto2)..guiGetText(GUI.edit.moto3)
		nomer = replaceRusToEng(nomer)
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 1234 | aв | 12")
			return
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("getInputInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.applyMoto) then
		local nomer = "c-"..guiGetText(GUI.edit.moto1)..guiGetText(GUI.edit.moto2)..guiGetText(GUI.edit.moto3)
		nomer = replaceRusToEng(nomer)
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 1234 | aв | 12")
			return
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("getInputInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.info_close) then
		guiSetVisible(GUI.window.info, false)
		
    elseif (source == GUI.button.info_buy) then
		if (not guiRadioButtonGetSelected(GUI.radiobutton.info_forDonat)) and (not guiRadioButtonGetSelected(GUI.radiobutton.info_forGame)) then
			outputBadMessage("Не выбрана валюта покупки!")
			return
		end
		local buyType = guiRadioButtonGetSelected(GUI.radiobutton.info_forDonat) and "DONATE"
		triggerServerEvent("applyFromInput", resourceRoot, nomerInInfoPanel, buyType)
		guiSetVisible(GUI.window.info, false)
		
	elseif (source == GUI.radiobutton.rus) or (source == GUI.radiobutton.ukr)
		or (source == GUI.radiobutton.blr) or (source == GUI.radiobutton.kaz) 
		or (source == GUI.radiobutton.federal) then
		showCountryFields()
		
	end
	
end
addEventHandler("onClientGUIClick", resourceRoot, buttonClicksPlayer)

function openInfoWindow(nomer, template, priceText, donatPriceText, canBeBought, price, donatPrice, bankMoney)
	if guiGetVisible(GUI.window.main) then
		guiSetVisible(GUI.window.info, true)
		guiBringToFront(GUI.window.info)
		nomerInInfoPanel = nomer
		guiSetText(GUI.label.info_currentNomer, "Номер: "..exports.car_system:convertPlateIDtoLicensep(nomer))
		guiSetText(GUI.label.info_template, template)
		if (canBeBought) then
			guiSetText(GUI.label.info_cost, string.format("Стоимость:\n%s%sУ вас %s донат-единиц", (priceText or ""), (donatPriceText or ""), tostring(bankMoney)))
			guiSetEnabled(GUI.button.info_buy, true)
			if (price) then
				guiSetEnabled(GUI.radiobutton.info_forGame, true)
			else
				guiSetEnabled(GUI.radiobutton.info_forGame, false)
				guiRadioButtonSetSelected(GUI.radiobutton.info_forGame, false)
			end
			if (donatPrice) then
				guiSetEnabled(GUI.radiobutton.info_forDonat, true)
			else
				guiSetEnabled(GUI.radiobutton.info_forDonat, false)
				guiRadioButtonSetSelected(GUI.radiobutton.info_forDonat, false)
			end
		else
			guiSetText(GUI.label.info_cost, "Стоимость:\nДанный номер недоступен для покупки")
			guiSetEnabled(GUI.button.info_buy, false)
			guiSetEnabled(GUI.radiobutton.info_forGame, false)
			guiSetEnabled(GUI.radiobutton.info_forDonat, false)
		end
	end
end
addEvent("takeInputInfo", true)
addEventHandler("takeInputInfo", resourceRoot, openInfoWindow)


function closePanelFunc()
	closeStorageWindow()
	closeConfirmWindow()
	guiSetVisible(GUI.window.main, false)
	guiSetVisible(GUI.window.info, false)
	if (not guiGetVisible(GUI.window.moderation)) then
		showCursor(false)
	end
end
addEvent("closePanel", true)
addEventHandler("closePanel", resourceRoot, closePanelFunc)



-- Разная черновая работа с полями
function clearFields()
	guiSetText(GUI.edit.halfLeft, "")
	guiSetText(GUI.edit.halfRight, "")
	guiSetText(GUI.edit.moto1, "")
	guiSetText(GUI.edit.moto2, "")
	guiSetText(GUI.edit.moto3, "")
	guiSetText(GUI.edit.full, "")
	guiSetText(GUI.edit.adminAuto, "")
	guiSetText(GUI.edit.adminAutoPolic, "")
	guiSetText(GUI.edit.adminMoto, "")
	guiSetText(GUI.edit.adminMotoPolic, "")
	guiSetText(GUI.edit.adminUkr, "")
	guiSetText(GUI.edit.adminKaz, "")
	guiSetText(GUI.edit.adminBelrus, "")
	guiSetText(GUI.edit.adminText, "")
end

function showCountryFields()
	if (textboxes.last == "rus") then
		textboxes.rusNom = guiGetText(GUI.edit.halfLeft)
		textboxes.rusReg = guiGetText(GUI.edit.halfRight)
	elseif (textboxes.last == "kaz") then
		textboxes.kazNom = guiGetText(GUI.edit.halfLeft)
		textboxes.kazReg = guiGetText(GUI.edit.halfRight)
	elseif (textboxes.last == "ukr") then
		textboxes.ukr = guiGetText(GUI.edit.full)
	elseif (textboxes.last == "blr") then
		textboxes.blr = guiGetText(GUI.edit.full)
	end
	guiSetVisible(GUI.edit.halfLeft, false)
	guiSetVisible(GUI.edit.halfRight, false)
	guiSetVisible(GUI.edit.full, false)
	if guiRadioButtonGetSelected(GUI.radiobutton.rus) then
		guiSetVisible(GUI.edit.halfLeft, true)
		guiSetVisible(GUI.edit.halfRight, true)
		guiEditSetMaxLength(GUI.edit.halfLeft, 6)
		guiEditSetMaxLength(GUI.edit.halfRight, 3)
		guiSetText(GUI.edit.halfLeft, textboxes.rusNom or "")
		guiSetText(GUI.edit.halfRight, textboxes.rusReg or "")
		textboxes.last = "rus"
	
	elseif guiRadioButtonGetSelected(GUI.radiobutton.kaz) then
		guiSetVisible(GUI.edit.halfLeft, true)
		guiSetVisible(GUI.edit.halfRight, true)
		guiEditSetMaxLength(GUI.edit.halfLeft, 6)
		guiEditSetMaxLength(GUI.edit.halfRight, 2)
		guiSetText(GUI.edit.halfLeft, textboxes.kazNom or "")
		guiSetText(GUI.edit.halfRight, textboxes.kazReg or "")
		textboxes.last = "kaz"
	
	elseif guiRadioButtonGetSelected(GUI.radiobutton.ukr) then
		guiSetVisible(GUI.edit.full, true)
		guiEditSetMaxLength(GUI.edit.full, 8)
		guiSetText(GUI.edit.full, textboxes.ukr or "")
		textboxes.last = "ukr"
	
	elseif guiRadioButtonGetSelected(GUI.radiobutton.blr) then
		guiSetVisible(GUI.edit.full, true)
		guiEditSetMaxLength(GUI.edit.full, 7)
		guiSetText(GUI.edit.full, textboxes.blr or "")
		textboxes.last = "blr"

    elseif guiRadioButtonGetSelected(GUI.radiobutton.federal) then
    	guiSetVisible(GUI.edit.donateLeft, true)
		guiEditSetMaxLength(GUI.edit.donateLeft, 6)
		guiSetText(GUI.edit.donateLeft, textboxes.fed or "")
		textboxes.last = "fed"
	
	end
end

-- Подгонка шрифта по ширине
local fontCache = {gui = {}, dx = {}}
function fitTextIntoField(text, field)
	local scale, font, width = 70
	repeat
		if (not fontCache.dx[scale]) then
			fontCache.dx[scale] = dxCreateFont("files/arialbd.ttf", scale, true)
		end
		width = dxGetTextWidth(text, 1, fontCache.dx[scale])
		scale = scale - 1
		if not width then width = 669 end
    until (width < 670)
	
	if (not fontCache.gui[scale]) then
		fontCache.gui[scale] = guiCreateFont("files/arialbd.ttf", scale)
	end
	guiSetFont(field, fontCache.gui[scale])
	guiSetText(field, text)
end

-- Вывод сообщений в чат
function outputMessage(text)
	outputChatBox("[Смена номера] #32FF32"..text, 255, 255, 255, true)
end

function outputBadMessage(text)
	outputChatBox("[Смена номера] #FF3232"..text, 255, 255, 255, true)
end

-- Замена русских символов на английские и обратно
function replaceRusToEng(str)
	str = string.gsub(str, "а", "a")
	str = string.gsub(str, "в", "b")
	str = string.gsub(str, "е", "e")
	str = string.gsub(str, "к", "k")
	str = string.gsub(str, "м", "m")
	str = string.gsub(str, "н", "h")
	str = string.gsub(str, "о", "o")
	str = string.gsub(str, "р", "p")
	str = string.gsub(str, "с", "c")
	str = string.gsub(str, "т", "t")
	str = string.gsub(str, "у", "y")
	str = string.gsub(str, "х", "x")
	return str
end
function replaceEngToRus(str)
	str = string.gsub(str, "b", "в")
	str = string.gsub(str, "k", "к")
	str = string.gsub(str, "m", "м")
	str = string.gsub(str, "h", "н")
	str = string.gsub(str, "t", "т")
	return str
end

-- Проигрывание звука при смене номера
function playSound(x,y,z)
	playSFX3D("script", 150, 0, x,y,z, false)
end
addEvent("playWrenchSound", true)
addEventHandler("playWrenchSound", resourceRoot, playSound)

--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end


--	==========     Админское гуи     ==========
function createAdminControls()
	GUI.tab.admin = guiCreateTab("Админ панель", GUI.tabpanel.main)

	GUI.label[23] = guiCreateLabel(10, 10, 115, 25, "Россия, авто, норм:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[23], "center")
	GUI.label[26] = guiCreateLabel(10, 35, 120, 25, "Россия, авто, полиц:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[26], "center")
	GUI.label[27] = guiCreateLabel(10, 60, 120, 25, "Россия, мото, норм:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[27], "center")
	GUI.label[28] = guiCreateLabel(10, 85, 125, 25, "Россия, мото, полиц:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[28], "center")
	GUI.label[29] = guiCreateLabel(10, 110, 120, 25, "Украина, авто, норм:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[29], "center")
	GUI.label[30] = guiCreateLabel(10, 135, 130, 25, "Казахстан, авто, норм:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[30], "center")
	GUI.label[31] = guiCreateLabel(10, 160, 145, 25, "Белоруссия, авто, норм:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[31], "center")
	GUI.label[32] = guiCreateLabel(10, 185, 55, 25, "Надпись:", false, GUI.tab.admin)
	guiLabelSetVerticalAlign(GUI.label[32], "center")
	
	GUI.edit.adminAuto = guiCreateEdit(135, 10, 110, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminAuto, 9)
	GUI.edit.adminAutoPolic = guiCreateEdit(140, 35, 105, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminAutoPolic, 8)
	GUI.edit.adminMoto = guiCreateEdit(140, 60, 105, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminMoto, 8)
	GUI.edit.adminMotoPolic = guiCreateEdit(145, 85, 100, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminMotoPolic, 7)
	GUI.edit.adminUkr = guiCreateEdit(140, 110, 105, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminUkr, 8)
	GUI.edit.adminKaz = guiCreateEdit(150, 135, 95, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminKaz, 8)
	GUI.edit.adminBelrus = guiCreateEdit(165, 160, 80, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminBelrus, 7)
	GUI.edit.adminText = guiCreateEdit(75, 185, 170, 25, "", false, GUI.tab.admin)
	guiEditSetMaxLength(GUI.edit.adminText, 30)
	
	GUI.label.admHelpNorm = guiCreateLabel(255, 10, 65, 25, "a123bc123", false, GUI.tab.admin)
	guiLabelSetHorizontalAlign(GUI.label.admHelpNorm, "center", false)
	guiLabelSetVerticalAlign(GUI.label.admHelpNorm, "center")
	GUI.label.admHelpPolic = guiCreateLabel(255, 35, 65, 25, "a1234123", false, GUI.tab.admin)
	guiLabelSetHorizontalAlign(GUI.label.admHelpPolic, "center", false)
	guiLabelSetVerticalAlign(GUI.label.admHelpPolic, "center")
	GUI.label.admHelpMoto = guiCreateLabel(255, 60, 65, 25, "1234ab12", false, GUI.tab.admin)
	guiLabelSetHorizontalAlign(GUI.label.admHelpMoto, "center", false)
	guiLabelSetVerticalAlign(GUI.label.admHelpMoto, "center")
	GUI.label.admHelpMotoPolic = guiCreateLabel(255, 85, 65, 25, "1234a12", false, GUI.tab.admin)
	guiLabelSetHorizontalAlign(GUI.label.admHelpMotoPolic, "center", false)
	guiLabelSetVerticalAlign(GUI.label.admHelpMotoPolic, "center")
	GUI.label.admHelpUkr = guiCreateLabel(255, 110, 65, 25, "AB1234CE", false, GUI.tab.admin)
	guiLabelSetHorizontalAlign(GUI.label.admHelpUkr, "center", false)
	guiLabelSetVerticalAlign(GUI.label.admHelpUkr, "center")
	GUI.label.admHelpKaz = guiCreateLabel(255, 135, 65, 25, "123ABC12", false, GUI.tab.admin)
	guiLabelSetHorizontalAlign(GUI.label.admHelpKaz, "center", false)
	guiLabelSetVerticalAlign(GUI.label.admHelpKaz, "center")
	GUI.label.admHelpBelrus = guiCreateLabel(255, 160, 65, 25, "1234AB5", false, GUI.tab.admin)
	guiLabelSetHorizontalAlign(GUI.label.admHelpBelrus, "center", false)
	guiLabelSetVerticalAlign(GUI.label.admHelpBelrus, "center")
	
	GUI.button.adminChkNorm = guiCreateButton(330, 10, 60, 25, "Провер.", false, GUI.tab.admin)
	GUI.button.adminChkPolic = guiCreateButton(330, 35, 60, 25, "Провер.", false, GUI.tab.admin)
	GUI.button.adminChkMoto = guiCreateButton(330, 60, 60, 25, "Провер.", false, GUI.tab.admin)
	GUI.button.adminChkMotoPolic = guiCreateButton(330, 85, 60, 25, "Провер.", false, GUI.tab.admin)
	GUI.button.adminChkUkr = guiCreateButton(330, 110, 60, 25, "Провер.", false, GUI.tab.admin)
	GUI.button.adminChkKaz = guiCreateButton(330, 135, 60, 25, "Провер.", false, GUI.tab.admin)
	GUI.button.adminChkBelrus = guiCreateButton(330, 160, 60, 25, "Провер.", false, GUI.tab.admin)
	GUI.button.adminChkText = guiCreateButton(330, 185, 60, 25, "Провер.", false, GUI.tab.admin)
	
	GUI.button.adminApplyNorm = guiCreateButton(390, 10, 60, 25, "Примен.", false, GUI.tab.admin)
	GUI.button.adminApplyPolic = guiCreateButton(390, 35, 60, 25, "Примен.", false, GUI.tab.admin)
	GUI.button.adminApplyMoto = guiCreateButton(390, 60, 60, 25, "Примен.", false, GUI.tab.admin)
	GUI.button.adminApplyMotoPolic = guiCreateButton(390, 85, 60, 25, "Примен.", false, GUI.tab.admin)
	GUI.button.adminApplyUkr = guiCreateButton(390, 110, 60, 25, "Примен.", false, GUI.tab.admin)
	GUI.button.adminApplyKaz = guiCreateButton(390, 135, 60, 25, "Примен.", false, GUI.tab.admin)
	GUI.button.adminApplyBelrus = guiCreateButton(390, 160, 60, 25, "Примен.", false, GUI.tab.admin)
	GUI.button.adminApplyText = guiCreateButton(390, 185, 60, 25, "Примен.", false, GUI.tab.admin)    

	guiSetVisible(GUI.tab.admin, false)
end

function buttonClicksAdmin()
    if (source == GUI.label.admHelpNorm) then
		guiSetText(GUI.edit.adminAuto, "a123bc123")
		
    elseif (source == GUI.label.admHelpPolic) then
		guiSetText(GUI.edit.adminAutoPolic, "a1234123")
		
    elseif (source == GUI.label.admHelpMoto) then
		guiSetText(GUI.edit.adminMoto, "1234ab12")
		
    elseif (source == GUI.label.admHelpMotoPolic) then
		guiSetText(GUI.edit.adminMotoPolic, "1234a12")
		
    elseif (source == GUI.label.admHelpUkr) then
		guiSetText(GUI.edit.adminUkr, "AB1234CE")
		
    elseif (source == GUI.label.admHelpKaz) then
		guiSetText(GUI.edit.adminKaz, "123ABC12")
		
    elseif (source == GUI.label.admHelpBelrus) then
		guiSetText(GUI.edit.adminBelrus, "1234AB5")
		
    elseif (source == GUI.button.adminChkNorm) then
		local nomer = "a-"..guiGetText(GUI.edit.adminAuto)
		nomer = replaceRusToEng(nomer)
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: а123вс12")
		else
			outputMessage("Недопустимых символов не обнаружено")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminChkPolic) then
		local nomer = "b-"..guiGetText(GUI.edit.adminAutoPolic)
		nomer = replaceRusToEng(nomer)
		--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminChkMoto) then
		local nomer = "с-"..guiGetText(GUI.edit.adminMoto)
		nomer = replaceRusToEng(nomer)
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 1234ав12")
		else
			outputMessage("Недопустимых символов не обнаружено")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminChkMotoPolic) then
		local nomer = "d-"..guiGetText(GUI.edit.adminMotoPolic)
		nomer = replaceRusToEng(nomer)
		--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminChkUkr) then
		local nomer = "f-"..string.upper(guiGetText(GUI.edit.adminUkr))
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: AB1234CE")
		else
			outputMessage("Недопустимых символов не обнаружено")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminChkKaz) then
		local nomer = guiGetText(GUI.edit.adminKaz)
		nomer = "e-"..string.upper(nomer)
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 123ABC12")
		else
			outputMessage("Недопустимых символов не обнаружено")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminChkBelrus) then
		nomer = "g-"..string.upper(guiGetText(GUI.edit.adminBelrus))
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 1234AB5")
		else
			outputMessage("Недопустимых символов не обнаружено")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminChkText) then
		nomer = "h-"..guiGetText(GUI.edit.adminText)
		outputMessage("Проверка синтаксиса не производится. Можно использовать только латинские символы")
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("GetAdminInfo", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyNorm) then
		local nomer = "a-"..guiGetText(GUI.edit.adminAuto)
		nomer = replaceRusToEng(nomer)
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: а123bc12")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyPolic) then
		local nomer = "b-"..guiGetText(GUI.edit.adminAutoPolic)
		nomer = replaceRusToEng(nomer)
		--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyMoto) then
		local nomer = "c-"..guiGetText(GUI.edit.adminMoto)
		nomer = replaceRusToEng(nomer)
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 1234ab12")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyMotoPolic) then
		local nomer = "d-"..guiGetText(GUI.edit.adminMotoPolic)
		nomer = replaceRusToEng(nomer)
		--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyUkr) then
		local nomer = "f-"..string.upper(guiGetText(GUI.edit.adminUkr))
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: AB1234CE")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyKaz) then
		local nomer = "e-"..string.upper(guiGetText(GUI.edit.adminKaz))
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 123ABC12")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyBelrus) then
		nomer = "g-"..string.upper(guiGetText(GUI.edit.adminBelrus))
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Пример: 1234AB5")
		end
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
		
    elseif (source == GUI.button.adminApplyText) then
		nomer = "h-"..guiGetText(GUI.edit.adminText)
		outputMessage("Проверка синтаксиса не производится. Можно использовать только любые символы")
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		triggerServerEvent("ApplyAdminNomer", resourceRoot, nomer)
	-- DONAT 
	-- федеральные
    elseif (source == GUI.button.applyFederal) then
    	--
    	local text = guiGetText(GUI.edit.editFederal)
		--text = convertSymbols(text)
		if not isCorrectNumber("ju", text) then
			    outputBadMessage("Неправильный номер. Пример: A123AA > [A123AA]")
			return
		end
    	--
    	if exports.bank:getPlayerBankMoney("DONATE") < moneyFederal then
    		outputChatBox("#ff3333Недостаточно донат единиц, чтобы купить федеральные номера!", 255, 255, 255, true)
        else
			local nomer = "j-"..guiGetText(GUI.edit.editFederal)
			nomer = replaceRusToEng(nomer)
			--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
			guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
			triggerServerEvent("applyDonatesNomer", resourceRoot, nomer, moneyFederal)
		end
	-- военные
	elseif (source == GUI.button.applyWars) then
		local text = guiGetText(GUI.edit.editWars)
		--text = convertSymbols(text)
		if not isCorrectNumber("black", text) then
			    outputBadMessage("Неправильный номер. Пример: 1234AA22 > [1234AA|22]")
			return
		end
    	if exports.bank:getPlayerBankMoney("DONATE") < moneyWars then
    		outputChatBox("#ff3333Недостаточно донат единиц, чтобы купить военные номера!", 255, 255, 255, true)
        else
			local nomer = "k-"..guiGetText(GUI.edit.editWars)
			nomer = replaceRusToEng(nomer)
			--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
			guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
			triggerServerEvent("applyDonatesNomer", resourceRoot, nomer, moneyWars)
		end
	-- дипломат
	elseif (source == GUI.button.applyDiplomat) then
		local text = guiGetText(GUI.edit.editDiplomat)
		--text = convertSymbols(text)
		if not isCorrectNumber("red", text) then
			    outputBadMessage("Неправильный номер. Пример: 111AA122 > [111AA1|22]")
			return
		end
		nomer = "l-"..string.upper(guiGetText(GUI.edit.editDiplomat))
    	if exports.bank:getPlayerBankMoney("DONATE") < moneyDiplomat then
    		outputChatBox("#ff3333Недостаточно донат единиц, чтобы купить дипломат. номера!", 255, 255, 255, true)
        else
			local nomer = "l-"..guiGetText(GUI.edit.editDiplomat)
			nomer = replaceRusToEng(nomer)
			--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
			guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
			triggerServerEvent("applyDonatesNomer", resourceRoot, nomer, moneyDiplomat)
		end
	-- полицейские 
	elseif (source == GUI.button.applyPolice) then
		local text = guiGetText(GUI.edit.editPolice)
		--text = convertSymbols(text)
		if not isCorrectNumber("police", text) then
			    outputBadMessage("Неправильный номер. Пример: A123422 > [A1234|22]")
			return
		end
		nomer = "b-"..string.upper(guiGetText(GUI.edit.editPolice))
    	if exports.bank:getPlayerBankMoney("DONATE") < moneyPolice then
    		outputChatBox("#ff3333Недостаточно донат единиц, чтобы купить дипломат. номера!", 255, 255, 255, true)
        else
			local nomer = "b-"..guiGetText(GUI.edit.editPolice)
			nomer = replaceRusToEng(nomer)
			--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
			guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
			triggerServerEvent("applyDonatesNomer", resourceRoot, nomer, moneyPolice)
		end
	-- именные 
	elseif (source == GUI.button.applyNamename) then
		if guiRadioButtonGetSelected(GUI.radiobutton.nameclassic) then
			nomer = "h-"..string.upper(guiGetText(GUI.edit.editNamename))
			if exports.bank:getPlayerBankMoney("DONATE") < moneyNameName then
				outputChatBox("#ff3333Недостаточно донат единиц, чтобы купить дипломат. номера!", 255, 255, 255, true)
			else
				local nomer = "h-"..guiGetText(GUI.edit.editNamename)
				--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
				guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
				triggerServerEvent("applyDonatesNomer", resourceRoot, nomer, moneyNameName)
			end
		elseif guiRadioButtonGetSelected(GUI.radiobutton.nameblack) then
			nomer = "r-"..string.upper(guiGetText(GUI.edit.editNamename))
			if exports.bank:getPlayerBankMoney("DONATE") < moneyNameName then
				outputChatBox("#ff3333Недостаточно донат единиц, чтобы купить дипломат. номера!", 255, 255, 255, true)
			else
				local nomer = "r-"..guiGetText(GUI.edit.editNamename)
				--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
				guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
				triggerServerEvent("applyDonatesNomer", resourceRoot, nomer, moneyNameName)
			end
		
		elseif guiRadioButtonGetSelected(GUI.radiobutton.namegold) then
			nomer = "o-"..string.upper(guiGetText(GUI.edit.editNamename))
			if exports.bank:getPlayerBankMoney("DONATE") < moneyNameName then
				outputChatBox("#ff3333Недостаточно донат единиц, чтобы купить дипломат. номера!", 255, 255, 255, true)
			else
				local nomer = "o-"..guiGetText(GUI.edit.editNamename)
				--outputMessage("Проверка синтаксиса не производится. Будь аккуратен, следуй примеру")
				guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
				triggerServerEvent("applyDonatesNomer", resourceRoot, nomer, moneyNameName)
			end
		end
	elseif (source == GUI.radiobutton.nameclassic) or (source == GUI.radiobutton.nameblack) or (source == GUI.radiobutton.namegold) then
		showNameBox()
	end
end
addEventHandler("onClientGUIClick", resourceRoot, buttonClicksAdmin)

function showNameBox()
	if guiRadioButtonGetSelected(GUI.radiobutton.nameclassic) then
		guiSetText ( GUI.button.applyNamename, "Купить именные номера\nза 240 донат ед." )
		moneyNameName = 240
	elseif guiRadioButtonGetSelected(GUI.radiobutton.nameblack) then
		guiSetText ( GUI.button.applyNamename, "Купить именные номера\nза 280 донат ед."  )
		moneyNameName = 280
	elseif guiRadioButtonGetSelected(GUI.radiobutton.namegold) then
		guiSetText ( GUI.button.applyNamename, "Купить именные номера\nза 320 донат ед."  )
		moneyNameName = 320
	end
end

--	==========     Информация о владельцах номера     ==========
function printAdminInfo(licensep, data)
	local userFriendlyLicensep = exports.car_system:convertPlateIDtoLicensep(licensep)
	local textToCopy = "Информация по номеру "..userFriendlyLicensep..":"
	outputChatBox("Информация по номеру "..userFriendlyLicensep..":")
	
	local carSystem, usedAuto, storage, moderation, other = {}, {}, {}, {}, {}
	for _, row in ipairs(data) do
		if (row.model) and (not row.usedauto) then
			table.insert(carSystem, row)
		elseif (row.model) and (row.usedauto) then
			table.insert(usedAuto, row)
		elseif (row.time) then
			table.insert(storage, row)
		elseif (row.status) then
			table.insert(moderation, row)
		else
			table.insert(other, row)
		end
	end
	
	if (#carSystem > 0) then
		outputChatBox("В личных автомобилях:")
		textToCopy = textToCopy.."\n\tВ личных автомобилях:"
		for _, row in ipairs(carSystem) do
			outputChatBox(row.owner.." - "..exports.car_system:getVehicleModName(row.model))
			textToCopy = textToCopy.."\n\t\t"..row.owner.." - "..exports.car_system:getVehicleModName(row.model)
		end
	end
	
	if (#usedAuto > 0) then
		outputChatBox("На б/у рынке:")
		textToCopy = textToCopy.."\n\tНа б/у рынке:"
		for _, row in ipairs(usedAuto) do
			outputChatBox(row.owner.." - "..exports.car_system:getVehicleModName(row.model))
			textToCopy = textToCopy.."\n\t\t"..row.owner.." - "..exports.car_system:getVehicleModName(row.model)
		end
	end
	
	if (#storage > 0) then
		outputChatBox("В хранилище:")
		textToCopy = textToCopy.."\n\tВ хранилище:"
		for _, row in ipairs(storage) do
			outputChatBox(row.owner.." - осталось "..calculateTimeDiff(row.time + storageTime, getRealTime().timestamp))
			textToCopy = textToCopy.."\n\t\t"..row.owner.." - осталось "..calculateTimeDiff(row.time + storageTime, getRealTime().timestamp)
		end
	end
	
	if (#moderation > 0) then
		outputChatBox("На модерации:")
		textToCopy = textToCopy.."\n\tНа модерации:"
		for _, row in ipairs(moderation) do
			outputChatBox(row.owner)
			textToCopy = textToCopy.."\n\t\t"..row.owner
		end
	end
	
	if (#other > 0) then
		outputChatBox("Имеются неизвестные сведения ("..#other.." шт.)")
		textToCopy = textToCopy.."\n\tНеизвестно:"
		for _, row in ipairs(other) do
			textToCopy = textToCopy.."\n"..inspect(row)
		end
	end
	
	setClipboard(textToCopy)
	outputChatBox("Текст скопирован")
end
addEvent("printAdminInfo", true)
addEventHandler("printAdminInfo", resourceRoot, printAdminInfo)

function convertNumber(number)  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')    
		if (k == 0) then      
			break   
		end  
	end  
	return formatted
end

convertableSymbolsTable =
{
	{'A','А'},
	{'B','В'},
	{'C','С'},
	{'Y','У'},
	{'O','О'},
	{'P','Р'},
	{'T','Т'},
	{'E','Е'},
	{'X','Х'},
	{'M','М'},
	{'H','Н'},
	{'K','К'},
}

function convertSymbols(text)
	local str = utf8.upper(text)
	for k,v in pairs(convertableSymbolsTable) do
		str = utf8.gsub(str,v[2],v[1])
	end
	return str
end

function isCorrectNumber(type,str)
	str = string.upper(str)
	if type == "ju" then
		if string.find(str,"^([ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])") and #str <= 9 then
			return true
		end
    -- 111AA122 ~ red 
    elseif type == "red" then
		if string.find(str,"^(%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY]%d)(%d%d+)$") and #str <= 9 then
			return true
		end
	--
	elseif type == "ru" then
		if string.find(str,"^([ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 9 then
			return true
		end
	elseif type == "ru2" then
		if string.find(str,"^([ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 9 then
			return true
		end
	elseif type == "ru3" then
		if string.find(str,"^([ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])$") and #str <= 6 then
			return true
		end
	elseif type == "tr" then
		if string.find(str,"^([ABCEHKMOPTXY][ABCEHKMOPTXY]%d%d%d[ABCEHKMOPTXY])(%d%d+)$") and #str <= 9 then
			return true
		end
	elseif type == "moto" then
		if string.find(str,"^(%d%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 8 then
			return true
		end
	elseif type == "motop" then
		if string.find(str,"^(%d%d%d%d[ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d+)$") and #str <= 8 then
			return true
		end
	elseif type == "ua" then
		if string.find(str,"^([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY])$" ) and #str <= 8 then
			return true
		end
	elseif type == "kz" then
		if string.find(str,"^(%d%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d)$" ) and #str <= 8 then
			return true
		end
	elseif type == "by" then
		if string.find(str,"^(%d%d%d%d)([ABEIKMHOPCTX][ABEIKMHOPCTX][-])(%d)$" ) and #str <= 10 then
			return true
		end
	elseif type == "arm" then
		if string.find(str,"^(%d%d)([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d)$" ) and #str <= 10 then
			return true
		end
	elseif type == "police" then
		if string.find(str,"^([ABCEHKMOPTXY])(%d%d%d%d%d%d)$" ) and #str <= 8 then
			return true
		end
	elseif type == "bus" then
		if string.find(str,"^([ABCEHKMOPTXY][ABCEHKMOPTXY])(%d%d%d%d%d)$" ) and #str <= 7 then
			return true
		end
	elseif type == "black" then
		if string.find(str,"^(%d%d%d%d)([ABEIKMHOPCTX][ABEIKMHOPCTX])(%d%d)$" ) and #str <= 8 then --1234AA116
			return true
		end
	elseif type == "c" then
		if utf8.len(str) <= 14 then
			return true
		end
	end
end












