
local screenW, screenH = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		-- ================= ОКНО УКАЗАНИЯ ПАРОЛЯ ПРИ ПОКУПКЕ =================
		GUI.window.setKey = guiCreateWindow((screenW - 250) / 2, (screenH - 150) / 2, 250, 150, "Ключ | Пароль", false)
		guiWindowSetSizable(GUI.window.setKey, false)

		GUI.label[1] = guiCreateLabel(10, 25, 230, 30, "Вы собираетесь купить этот дом.\nВведите будущий ключ:", false, GUI.window.setKey)
		guiLabelSetHorizontalAlign(GUI.label[1], "center", false)
		guiSetFont(GUI.label[1], "default-bold-small")
		guiLabelSetColor(GUI.label[1], 0, 153, 255)
		GUI.edit.setKey = guiCreateEdit(20, 65, 210, 25, "Ключ", false, GUI.window.setKey)
		guiSetFont(GUI.edit.setKey, "default-bold-small")
		guiEditSetMaxLength(GUI.edit.setKey, 30)
		GUI.button.buyHouse = guiCreateButton(20, 100, 75, 30, "Принять", false, GUI.window.setKey)
		guiSetFont(GUI.button.buyHouse, "default-bold-small")
		GUI.button.closeSetKey = guiCreateButton(155, 100, 75, 30, "Отмена", false, GUI.window.setKey)
		guiSetFont(GUI.button.closeSetKey, "default-bold-small")

		-- ================= ОКНО ЗАПРОСА ПАРОЛЯ ПРИ ПРОДАЖЕ =================
		GUI.window.sellHouse = guiCreateWindow((screenW - 250) / 2, (screenH - 150) / 2, 250, 150, "Ключ | Пароль", false)
		guiWindowSetSizable(GUI.window.sellHouse, false)

		GUI.label[1] = guiCreateLabel(10, 25, 230, 30, "Если вы продадите дом, то получите только 50% от его стоимости", false, GUI.window.sellHouse)
		guiLabelSetHorizontalAlign(GUI.label[1], "center", true)
		guiSetFont(GUI.label[1], "default-bold-small")
		guiLabelSetColor(GUI.label[1], 0, 153, 255)
		GUI.edit.keyToSell = guiCreateEdit(20, 65, 210, 25, "Ключ", false, GUI.window.sellHouse)
		guiSetFont(GUI.edit.keyToSell, "default-bold-small")
		guiEditSetMaxLength(GUI.edit.keyToSell, 30)
		GUI.button.sellHouse = guiCreateButton(20, 100, 75, 30, "Принять", false, GUI.window.sellHouse)
		guiSetFont(GUI.button.sellHouse, "default-bold-small")
		GUI.button.closeSell = guiCreateButton(155, 100, 75, 30, "Отмена", false, GUI.window.sellHouse)
		guiSetFont(GUI.button.closeSell, "default-bold-small")

		-- ================= ОКНО СМЕНЫ ПАРОЛЯ =================
		GUI.window.changeKey = guiCreateWindow((screenW - 250) / 2, (screenH - 220) / 2, 250, 220, "Ключ | Пароль", false)
		guiWindowSetSizable(GUI.window.changeKey, false)

		GUI.label[1] = guiCreateLabel(10, 25, 230, 30, "Для смены ключа вам необходимо ввести новый ключ", false, GUI.window.changeKey)
		guiLabelSetHorizontalAlign(GUI.label[1], "center", true)
		guiSetFont(GUI.label[1], "default-bold-small")
		guiLabelSetColor(GUI.label[1], 0, 153, 255)
		-- GUI.edit.changeKeyOld = guiCreateEdit(20, 65, 210, 25, "Старый ключ", false, GUI.window.changeKey)
		-- guiSetFont(GUI.edit.changeKeyOld, "default-bold-small")
		-- guiEditSetMaxLength(GUI.edit.changeKeyOld, 30)
		GUI.edit.changeKeyNew1 = guiCreateEdit(20, 100, 210, 25, "Новый ключ", false, GUI.window.changeKey)
		guiSetFont(GUI.edit.changeKeyNew1, "default-bold-small")
		guiEditSetMaxLength(GUI.edit.changeKeyNew1, 30)
		GUI.edit.changeKeyNew2 = guiCreateEdit(20, 135, 210, 25, "Повторить ключ", false, GUI.window.changeKey)
		guiSetFont(GUI.edit.changeKeyNew2, "default-bold-small")
		guiEditSetMaxLength(GUI.edit.changeKeyNew2, 30)
		GUI.button.OKchangeKey = guiCreateButton(20, 170, 75, 30, "Принять", false, GUI.window.changeKey)
		guiSetFont(GUI.button.OKchangeKey, "default-bold-small")
		GUI.button.closeChangeKey = guiCreateButton(155, 170, 75, 30, "Отмена", false, GUI.window.changeKey)
		guiSetFont(GUI.button.closeChangeKey, "default-bold-small")

		-- ================= ОКНО ЗАПРОСА ПАРОЛЯ ПРИ ВХОДЕ =================
		GUI.window.enterHouse = guiCreateWindow((screenW - 250) / 2, (screenH - 150) / 2, 250, 150, "Ключ | Пароль", false)
		guiWindowSetSizable(GUI.window.sellHouse, false)

		GUI.label[1] = guiCreateLabel(10, 25, 230, 30, "Введите ключ\nдля входа в дом", false, GUI.window.enterHouse)
		guiLabelSetHorizontalAlign(GUI.label[1], "center", true)
		guiSetFont(GUI.label[1], "default-bold-small")
		guiLabelSetColor(GUI.label[1], 0, 153, 255)
		GUI.edit.keyToEnter = guiCreateEdit(20, 65, 210, 25, "Ключ", false, GUI.window.enterHouse)
		guiSetFont(GUI.edit.keyToEnter, "default-bold-small")
		guiEditSetMaxLength(GUI.edit.keyToEnter, 30)
		GUI.button.enterHouse = guiCreateButton(20, 100, 75, 30, "Принять", false, GUI.window.enterHouse)
		guiSetFont(GUI.button.enterHouse, "default-bold-small")
		GUI.button.closeEnter = guiCreateButton(155, 100, 75, 30, "Отмена", false, GUI.window.enterHouse)
		guiSetFont(GUI.button.closeEnter, "default-bold-small")
	
		-- ================= СОЗДАНО ВНЕ GUI EDITOR =================
		guiSetVisible(GUI.window.setKey, false)
		guiSetVisible(GUI.window.sellHouse, false)
		guiSetVisible(GUI.window.changeKey, false)
		guiSetVisible(GUI.window.enterHouse, false)	
	end
)

addEventHandler("onClientGUIClick", resourceRoot, function()
	-- Открытие диалоговых окон
	if ((source==GUI.label.buy or source==GUI.staticimage.buy) and enabledButtons[GUI.staticimage.buy])
			or (source == GUI.button.buy) then
		guiSetVisible(GUI.window.main, false)
		guiSetVisible(GUI.window.setKey, true)
		guiSetText(GUI.edit.setKey, "Ключ")
		playSound("sounds/click_question.wav")

	elseif ((source==GUI.label.sell or source==GUI.staticimage.sell) and enabledButtons[GUI.staticimage.sell])
			or (source == GUI.button.sell) then
		guiSetVisible(GUI.window.main, false)
		guiSetVisible(GUI.window.sellHouse, true)
		guiSetText(GUI.edit.keyToSell, "Ключ")
		playSound("sounds/click_question.wav")

	elseif ((source==GUI.label.changeKey or source==GUI.staticimage.changeKey) and enabledButtons[GUI.staticimage.changeKey])
			or (source == GUI.button.changeKey) then
		guiSetVisible(GUI.window.main, false)
		guiSetVisible(GUI.window.changeKey, true)
		-- guiSetText(GUI.edit.changeKeyOld, "Старый ключ")
		guiSetText(GUI.edit.changeKeyNew1, "Новый ключ")
		guiSetText(GUI.edit.changeKeyNew2, "Повторить ключ")
		playSound("sounds/click_question.wav")

	elseif ((source==GUI.label.enter or source==GUI.staticimage.enter) and enabledButtons[GUI.staticimage.enter])
			or (source == GUI.button.enter) then
		if (currentMarkerData.owner == "") or (currentMarkerData.owner == myAccount) then
			if not getElementData(localPlayer, "isChased") then
				guiSetVisible(GUI.window.main, false)
				showCursor(false)
				triggerServerEvent("enterHouse", resourceRoot, currentMarkerData)
			else
				outputChatBad("Невозможно зайти в дом. За вами ведется погоня.")
			end
		else
			guiSetVisible(GUI.window.main, false)
			guiSetVisible(GUI.window.enterHouse, true)
			guiSetText(GUI.edit.keyToEnter, "Ключ")
			playSound("sounds/click_question.wav")
		end
	
	-- Первые нажатия на поля ввода
	elseif (source == GUI.edit.setKey) or (source == GUI.edit.keyToSell) or (source == GUI.edit.keyToEnter) then
		if (guiGetText(GUI.edit.setKey) == "Ключ") then guiSetText(GUI.edit.setKey, "") end
		if (guiGetText(GUI.edit.keyToSell) == "Ключ") then guiSetText(GUI.edit.keyToSell, "") end
		if (guiGetText(GUI.edit.keyToEnter) == "Ключ") then guiSetText(GUI.edit.keyToEnter, "") end

	-- elseif (source == GUI.edit.changeKeyOld) then
		-- if (guiGetText(GUI.edit.changeKeyOld) == "Старый ключ") then guiSetText(GUI.edit.changeKeyOld, "") end

	elseif (source == GUI.edit.changeKeyNew1) then
		if (guiGetText(GUI.edit.changeKeyNew1) == "Новый ключ") then guiSetText(GUI.edit.changeKeyNew1, "") end

	elseif (source == GUI.edit.changeKeyNew2) then
		if (guiGetText(GUI.edit.changeKeyNew2) == "Повторить ключ") then guiSetText(GUI.edit.changeKeyNew2, "") end

	elseif (source == GUI.edit.changeOwnerKey) then
		if (guiGetText(GUI.edit.changeOwnerKey) == "Ключ") then guiSetText(GUI.edit.changeOwnerKey, "") end

	-- Согласие в диалоговых окнах
	elseif (source == GUI.button.buyHouse) then
		local text = guiGetText(GUI.edit.setKey)
		if (text ~= "") and (text ~= "Ключ") then
			guiSetVisible(GUI.window.setKey, false)
			showCursor(false)
			triggerServerEvent("buyHouse", resourceRoot, currentMarkerData, text)
		else
			outputChatBad("Введите ключ!")
		end

	elseif (source == GUI.button.sellHouse) then
		local text = guiGetText(GUI.edit.keyToSell)
		if (text ~= "") and (text ~= "Ключ") then
			if (text == currentMarkerData.key) then
				guiSetVisible(GUI.window.sellHouse, false)
				showCursor(false)
				triggerServerEvent("sellHouse", resourceRoot, currentMarkerData)
			else
				outputChatBad("Неверный ключ!")
				guiSetVisible(GUI.window.main, true)
				guiSetVisible(GUI.window.sellHouse, false)
			end
		else
			outputChatBad("Введите ключ!")
		end

	elseif (source == GUI.button.OKchangeKey) then
		-- local oldKey = guiGetText(GUI.edit.changeKeyOld)
		local newKey1 = guiGetText(GUI.edit.changeKeyNew1)
		local newKey2 = guiGetText(GUI.edit.changeKeyNew2)
		-- if (oldKey == "") or (oldKey == "Старый ключ") then
			-- outputChatBad("Введите старый ключ!")
			-- return
		-- end
		if (newKey1 == "") or (newKey1 == "Новый ключ") then
			outputChatBad("Введите новый ключ!")
			return
		end
		if (newKey2 == "") or (newKey2 == "Повторить ключ") then
			outputChatBad("Введите новый ключ повторно!")
			return
		end
		if newKey1 ~= newKey2 then
			outputChatBad("Новые ключи не совпадают!")
			return
		end
		-- if (oldKey == currentMarkerData.key) then
			guiSetVisible(GUI.window.changeKey, false)
			showCursor(false)
			triggerServerEvent("changeKey", resourceRoot, currentMarkerData, oldKey, newKey1)
		-- else
			-- outputChatBad("Старый ключ неверен!")
			-- guiSetVisible(GUI.window.main, true)
			-- guiSetVisible(GUI.window.changeKey, false)
		-- end

	elseif (source == GUI.button.enterHouse) then
		local key = guiGetText(GUI.edit.keyToEnter)
		if (key == currentMarkerData.key) then
			if not getElementData(localPlayer, "isChased") then
				guiSetVisible(GUI.window.enterHouse, false)
				showCursor(false)
				triggerServerEvent("enterHouse", resourceRoot, currentMarkerData)
			else
				outputChatBad("Невозможно зайти в дом. За вами ведется погоня.")
			end
		else
			outputChatBad("Неверный ключ!")
			guiSetVisible(GUI.window.main, true)
			guiSetVisible(GUI.window.enterHouse, false)
		end
	
	-- Закрытие окон
	elseif (source == GUI.button.closeSetKey) then
		guiSetVisible(GUI.window.main, true)
		guiSetVisible(GUI.window.setKey, false)

	elseif (source == GUI.button.closeSell) then
		guiSetVisible(GUI.window.main, true)
		guiSetVisible(GUI.window.sellHouse, false)

	elseif (source == GUI.button.closeChangeKey) then
		guiSetVisible(GUI.window.main, true)
		guiSetVisible(GUI.window.changeKey, false)

	elseif (source == GUI.button.closeEnter) then
		guiSetVisible(GUI.window.main, true)
		guiSetVisible(GUI.window.enterHouse, false)

	elseif (source == GUI.button.close) then
		guiSetVisible(GUI.window.main, false)
		showCursor(false)

	end
end)

