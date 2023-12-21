
local icMarkersToColshapes = {
	[ createMarker(1045.12244, 1730.94849, 10, "cylinder", 1.5, 255,255,0,255) ] = createColRectangle(1039.38232, 1720.08472, 10.22924, 20.384),
}
createBlip(1064.84558, 1763.08716, 10, 24, 2, 255, 0, 0, 255, 0, 350)

local interchangeID, iAmReady, heIsReady, iConfirm, heConfirms, myFee, hisFee, isFirstPlayer
local screenW, screenH = guiGetScreenSize()
local vehListData, ic_youGiveGridlistData = { [-1]={} }, { [-1]={} }

addEventHandler("onClientResourceStart", resourceRoot, function()	
	-- ===================     Окно выбора игрока     ===================
	GUI.window.ic_cp_chooseplayer = guiCreateWindow((screenW-280)/2, (screenH - 285) / 2, 280, 285, "Выбор игрока", false)
	guiWindowSetSizable(GUI.window.ic_cp_chooseplayer, false)
	GUI.gridlist.ic_cp_playerList = guiCreateGridList(10, 25, 260, 200, false, GUI.window.ic_cp_chooseplayer)
	guiGridListSetSortingEnabled(GUI.gridlist.ic_cp_playerList, false)
	guiGridListAddColumn(GUI.gridlist.ic_cp_playerList, "Игрок", 0.9)
	GUI.button.ic_cp_choose = guiCreateButton(10, 235, 80, 40, "Выбрать", false, GUI.window.ic_cp_chooseplayer)
	GUI.button.ic_cp_refresh = guiCreateButton(100, 235, 80, 40, "Обновить список", false, GUI.window.ic_cp_chooseplayer)
	GUI.button.ic_cp_close = guiCreateButton(190, 235, 80, 40, "Закрыть", false, GUI.window.ic_cp_chooseplayer) 
	
	-- ===================     Окно ожидания подтверждения     ===================
	GUI.window.ic_wait = guiCreateWindow((screenW - 250) / 2, (screenH - 150) / 2, 250, 150, "Ожидание", false)
	guiWindowSetSizable(GUI.window.ic_wait, false)
	GUI.label[1] = guiCreateLabel(10, 25, 230, 75, "Ожидание подтверждения начала сделки другим игроком", false, GUI.window.ic_wait)
	guiLabelSetHorizontalAlign(GUI.label[1], "center", true)
	guiLabelSetVerticalAlign(GUI.label[1], "center")
	GUI.button.ic_waitCancel = guiCreateButton(160, 110, 80, 30, "Отмена", false, GUI.window.ic_wait) 
	
	-- ===================     Окно приглашения к обмену     ===================
	GUI.window.ic_invitation = guiCreateWindow((screenW - 250) / 2, (screenH - 170) / 2, 250, 170, "Запрос обмена", false)
	guiWindowSetSizable(GUI.window.ic_invitation, false)
	GUI.label.ic_invitator = guiCreateLabel(10, 25, 230, 90, "*** предлагает вам обмен.\n\nПодробности обмена можно будет изменить в следующем окне.", false, GUI.window.ic_invitation)
	guiLabelSetHorizontalAlign(GUI.label.ic_invitator, "center", true)
	guiLabelSetVerticalAlign(GUI.label.ic_invitator, "center")
	GUI.button.ic_inv_accept = guiCreateButton(10, 125, 90, 35, "Принять", false, GUI.window.ic_invitation)
	guiSetProperty(GUI.button.ic_inv_accept, "NormalTextColour", "FF00FF00")
	guiSetFont(GUI.button.ic_inv_accept, "default-bold-small")
	GUI.button.ic_inv_decline = guiCreateButton(150, 125, 90, 35, "Отказаться", false, GUI.window.ic_invitation)
	guiSetProperty(GUI.button.ic_inv_decline, "NormalTextColour", "FFFF0000")    
	guiSetFont(GUI.button.ic_inv_decline, "default-bold-small")
	
	-- ===================     Главное окно     ===================
	GUI.window.ic_main = guiCreateWindow((screenW - 505) / 2, (screenH - 425) / 2, 505, 425, "Обмен автомобилей", false)
	guiWindowSetSizable(GUI.window.ic_main, false)
	GUI.label[1] = guiCreateLabel(10, 25, 385, 15, "Вы отдаете:", false, GUI.window.ic_main)
	guiLabelSetHorizontalAlign(GUI.label[1], "center", false)
	GUI.gridlist.ic_youGive = guiCreateGridList(10, 50, 385, 150, false, GUI.window.ic_main)
	guiGridListSetSortingEnabled(GUI.gridlist.ic_youGive, false)
	guiGridListAddColumn(GUI.gridlist.ic_youGive, "Тип", 0.23)
	guiGridListAddColumn(GUI.gridlist.ic_youGive, "Информация", 0.72)
	GUI.label.ic_opponentName = guiCreateLabel(10, 215, 385, 15, "Вы получаете от Autoligenda:", false, GUI.window.ic_main)
	guiLabelSetHorizontalAlign(GUI.label.ic_opponentName, "center", false)
	GUI.gridlist.ic_youTake = guiCreateGridList(10, 240, 385, 150, false, GUI.window.ic_main)
	guiGridListSetSortingEnabled(GUI.gridlist.ic_youTake, false)
	guiGridListAddColumn(GUI.gridlist.ic_youTake, "Тип", 0.23)
	guiGridListAddColumn(GUI.gridlist.ic_youTake, "Информация", 0.72)
	GUI.label.fee = guiCreateLabel(10, 400, 385, 15, "", false, GUI.window.ic_main)
	GUI.button.ic_addItem = guiCreateButton(405, 25, 90, 40, "Добавить позицию", false, GUI.window.ic_main)
	GUI.button.ic_removeItem = guiCreateButton(405, 75, 90, 40, "Убрать выбранное", false, GUI.window.ic_main)
	GUI.button.ic_ready = guiCreateButton(405, 125, 90, 40, "Готов", false, GUI.window.ic_main)
	GUI.staticimage.ic_youReady = guiCreateStaticImage(421, 175, 32, 32, "assets/no.png", false, GUI.window.ic_main)
	GUI.staticimage.ic_opponentReady = guiCreateStaticImage(463, 175, 32, 32, "assets/no.png", false, GUI.window.ic_main)
	GUI.button.ic_confirm = guiCreateButton(405, 227, 90, 40, "Произвести обмен", false, GUI.window.ic_main)
	GUI.staticimage.ic_youConfirm = guiCreateStaticImage(421, 277, 32, 32, "assets/no.png", false, GUI.window.ic_main)  
	GUI.staticimage.ic_opponentConfirm = guiCreateStaticImage(463, 277, 32, 32, "assets/no.png", false, GUI.window.ic_main)
	GUI.button.ic_close = guiCreateButton(425, 380, 70, 35, "Закрыть", false, GUI.window.ic_main)
	
	-- ===================     Окно добавления позиции     ===================
	GUI.window.ic_addPosition = guiCreateWindow(((screenW-505)/2)+505, (screenH - 425) / 2, 310, 400, "Добавить позицию", false)
	guiWindowSetSizable(GUI.window.ic_addPosition, false)
	GUI.radiobutton.ic_ap_car = guiCreateRadioButton(10, 25, 100, 15, "Автомобиль", false, GUI.window.ic_addPosition)
	guiRadioButtonSetSelected(GUI.radiobutton.ic_ap_car, true)
	GUI.radiobutton.ic_ap_nomer = guiCreateRadioButton(10, 50, 100, 15, "Номер", false, GUI.window.ic_addPosition)
	GUI.radiobutton.ic_ap_money = guiCreateRadioButton(10, 75, 100, 15, "Деньги", false, GUI.window.ic_addPosition)
	GUI.label.ic_ap_amount = guiCreateLabel(10, 100, 100, 15, "Сумма:", false, GUI.window.ic_addPosition)
	GUI.edit.ic_ap_amount = guiCreateEdit(10, 125, 100, 25, "", false, GUI.window.ic_addPosition)
	guiEditSetMaxLength(GUI.edit.ic_ap_amount, 10)
	GUI.gridlist.ic_ap_cars = guiCreateGridList(10, 100, 290, 245, false, GUI.window.ic_addPosition)
	guiGridListSetSortingEnabled(GUI.gridlist.ic_ap_cars, false)
	guiGridListAddColumn(GUI.gridlist.ic_ap_cars, "Транспорт", 0.62)
	guiGridListAddColumn(GUI.gridlist.ic_ap_cars, "Номер", 0.32)    
	GUI.button.ic_ap_OK = guiCreateButton(230, 355, 70, 35, "ОК", false, GUI.window.ic_addPosition)  
	
	-- ===================     Вне GUI Editor     ===================
	guiSetVisible(GUI.window.ic_cp_chooseplayer, false)
	guiSetVisible(GUI.window.ic_wait, false)
	guiSetVisible(GUI.window.ic_invitation, false)
	guiSetVisible(GUI.window.ic_main, false)
	guiSetVisible(GUI.window.ic_addPosition, false)
	addWindowToCursorControl(GUI.window.ic_cp_chooseplayer)
	addWindowToCursorControl(GUI.window.ic_wait)
	addWindowToCursorControl(GUI.window.ic_invitation)
	addWindowToCursorControl(GUI.window.ic_main)
	guiSetEnabled(GUI.button.ic_confirm, false)
end)

local colshapeToSearchPlayers = false
function ic_onMarkerHit(hitPlayer, matchingDimension)
	if (hitPlayer == localPlayer) and (not getPedOccupiedVehicle(localPlayer)) and (matchingDimension) then
		colshapeToSearchPlayers = icMarkersToColshapes[source]
		if (colshapeToSearchPlayers) then
			local _, _, pZ = getElementPosition(localPlayer)
			local _, _, mZ = getElementPosition(source)
			if (pZ-mZ < 5) and (pZ > mZ) then
				triggerServerEvent("startInterchange", resourceRoot)
			end
		end
	end
end
for marker, _ in pairs(icMarkersToColshapes) do
	addEventHandler("onClientMarkerHit", marker, ic_onMarkerHit)
end

addEvent("ic_startInterchange", true)
addEventHandler("ic_startInterchange", resourceRoot, function(ID)
	interchangeID = ID
	ic_refreshPlayerList()
	guiSetVisible(GUI.window.ic_cp_chooseplayer, true)
	guiSetInputMode("no_binds_when_editing")
	showCursor(true)
end)

function ic_refreshPlayerList()
	guiGridListClear(GUI.gridlist.ic_cp_playerList)
	if (colshapeToSearchPlayers) then
		for _, player in ipairs(getElementsWithinColShape(colshapeToSearchPlayers, "player")) do
			if (player ~= localPlayer) then
				local row = guiGridListAddRow(GUI.gridlist.ic_cp_playerList)
				guiGridListSetItemText(GUI.gridlist.ic_cp_playerList, row, 1, getPlayerNameWOutCC(player), false, false)
				guiGridListSetItemData(GUI.gridlist.ic_cp_playerList, row, 1, player)
			end
		end
	end
end

function ic_onGUIClick()
	if (source == GUI.button.ic_cp_choose) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.ic_cp_playerList)
		if (selected > -1) then
			selectedPlayer = guiGridListGetItemData(GUI.gridlist.ic_cp_playerList, selected, 1)
			if isElement(selectedPlayer) and isElementWithinColShape(selectedPlayer, colshapeToSearchPlayers) then
				guiSetVisible(GUI.window.ic_cp_chooseplayer, false, selectedPlayer)
				colshapeToSearchPlayers = false
				guiSetVisible(GUI.window.ic_wait, true)
				isFirstPlayer = true
				triggerServerEvent("ic_Request", resourceRoot, interchangeID, selectedPlayer)
			else
				ic_refreshPlayerList()
				selectedPlayer = nil
			end
		end

	elseif (source == GUI.button.ic_cp_refresh) then
		ic_refreshPlayerList()
		
	elseif (source == GUI.button.ic_cp_close) then
		triggerServerEvent("ic_cancelInterchange", resourceRoot, interchangeID)
		ic_closeAllWindows()
		
	elseif (source == GUI.button.ic_waitCancel) then
		outputCarSystemInfo("Вы отменили своё предложение обмена")
		triggerServerEvent("ic_cancelInterchange", resourceRoot, interchangeID, false, getPlayerName(localPlayer).."#цв# отменил свое предложение обмена")
		ic_closeAllWindows()

	elseif (source == GUI.button.ic_close) then
		outputCarSystemInfo("Вы отменили сделку")
		if (isFirstPlayer) then
			triggerServerEvent("ic_cancelInterchange", resourceRoot, interchangeID, false, getPlayerName(localPlayer).."#цв# отменил сделку", "cancel by p1")
		else
			triggerServerEvent("ic_cancelInterchange", resourceRoot, interchangeID, getPlayerName(localPlayer).."#цв# отменил сделку", false, "cancel by p2")
		end
		ic_closeAllWindows()

	elseif (source == GUI.button.ic_inv_accept) then
		guiSetVisible(GUI.window.ic_invitation, false)
		triggerServerEvent("ic_inviteAccepted", resourceRoot, interchangeID)

	elseif (source == GUI.button.ic_inv_decline) then
		outputCarSystemInfo("Вы отклонили предложение обмена")
		triggerServerEvent("ic_cancelInterchange", resourceRoot, interchangeID, getPlayerName(localPlayer).."#цв# отклонил ваше предложение обмена")
	
	elseif (source == GUI.button.ic_addItem) then
		local state = not guiGetVisible(GUI.window.ic_addPosition)
		guiSetVisible(GUI.window.ic_addPosition, state)
		if state then ic_checkAddPositionWindow() end
		
	elseif (source == GUI.radiobutton.ic_ap_car) or (source == GUI.radiobutton.ic_ap_nomer) or (source == GUI.radiobutton.ic_ap_money) then
		ic_checkAddPositionWindow()	
		
	elseif (source == GUI.button.ic_ap_OK) then
		if (not iAmReady) then
			if guiRadioButtonGetSelected(GUI.radiobutton.ic_ap_car) then
				local selected = guiGridListGetSelectedItem(GUI.gridlist.ic_ap_cars)
				if (selected < 0) then
					outputCarSystemError("Не выбрана машина!")
					return
				end
				local carID = vehListData[selected].ID
				local model = vehListData[selected].model
				local carRow = findThingInYouGiveList("car", carID)
				local nomerRow = findThingInYouGiveList("nomer", carID)
				if (carRow or nomerRow) then
					outputCarSystemError("Эта машина уже находится в вашем списке обмена!")
					return
				end
				local nameString = guiGridListGetItemText(GUI.gridlist.ic_ap_cars, selected, 1).." "..guiGridListGetItemText(GUI.gridlist.ic_ap_cars, selected, 2)
				carRow = guiGridListAddRow(GUI.gridlist.ic_youGive)
				guiGridListSetItemText(GUI.gridlist.ic_youGive, carRow, 1, "Автомобиль", false, false)
				guiGridListSetItemText(GUI.gridlist.ic_youGive, carRow, 2, nameString, false, false)
				ic_youGiveGridlistData[carRow] = {rowType = "car", carID = carID, model = model}
				guiSetVisible(GUI.window.ic_addPosition, false)
				sendGridData()
			elseif guiRadioButtonGetSelected(GUI.radiobutton.ic_ap_nomer) then
				local selected = guiGridListGetSelectedItem(GUI.gridlist.ic_ap_cars)
				if (selected < 0) then
					outputCarSystemError("Не выбрана машина!")
					return
				end
				local price, currency = getCarPrice(vehListData[selected].model)
				if (price < 500000) and (not currency) then
					outputCarSystemError("Перенос номеров недоступен для автомобилей дешевле 500 000 рублей.")
					return
				end
				if (price < 8000) and (currency == "EUR") then
					outputCarSystemError("Перенос номеров недоступен для автомобилей дешевле 8000 евро.")
					return
				end
				if (price < 8500) and (currency == "USD") then
					outputCarSystemError("Перенос номеров недоступен для автомобилей дешевле 8500 долларов.")
					return
				end
				local carID = vehListData[selected].ID
				local model = vehListData[selected].model
				print (getVehicleNameFromModel (model), model, (blackListModel[model] and "Запрещен" or "Разрещен"))
				if blackListModel[model] then 
					outputCarSystemError("Для этого тс заперещен переброс номеров.")
					return
				end
				local carRow = findThingInYouGiveList("car", carID)
				local nomerRow = findThingInYouGiveList("nomer")
				if (carRow) then
					outputCarSystemError("Эта машина уже находится в вашем списке обмена!")
					return
				end
				if (nomerRow) then
					outputCarSystemError("Вы можете выставить только одну машину для обмена номеров!")
					return
				end
				local nameString = guiGridListGetItemText(GUI.gridlist.ic_ap_cars, selected, 2).." ("..guiGridListGetItemText(GUI.gridlist.ic_ap_cars, selected, 1)..")"
				nomerRow = guiGridListAddRow(GUI.gridlist.ic_youGive)
				guiGridListSetItemText(GUI.gridlist.ic_youGive, nomerRow, 1, "Номер", false, false)
				guiGridListSetItemText(GUI.gridlist.ic_youGive, nomerRow, 2, nameString, false, false)
				ic_youGiveGridlistData[nomerRow] = {rowType = "nomer", carID = carID, model = model}
				guiSetVisible(GUI.window.ic_addPosition, false)
				sendGridData()
			else
				local money = tonumber(guiGetText(GUI.edit.ic_ap_amount))
				if (not money) or (money < 0) then
					outputCarSystemError("Введена неверная сумма!")
					return
				end
				money = math.floor(money)
				local row = findThingInYouGiveList("money")
				if (not row) then
					row = guiGridListAddRow(GUI.gridlist.ic_youGive)
					guiGridListSetItemText(GUI.gridlist.ic_youGive, row, 1, "Деньги", false, false)
					ic_youGiveGridlistData[row] = {rowType = "money"}
				end
				if (money == 0) then
					guiGridListRemoveRow(GUI.gridlist.ic_youGive, row)
					sendGridData()
					return
				end
				guiGridListSetItemText(GUI.gridlist.ic_youGive, row, 2, explodeNumber(money).." руб.", false, false)
				guiGridListSetItemData(GUI.gridlist.ic_youGive, row, 2, money)
				ic_youGiveGridlistData[row].amount = money
				guiSetVisible(GUI.window.ic_addPosition, false)
				sendGridData()
			end
		else
			outputCarSystemError("Перед изменениями снимите галочку готовности!")
		end
		
	elseif (source == GUI.button.ic_removeItem) then
		if (not iAmReady) then
			local selected = guiGridListGetSelectedItem(GUI.gridlist.ic_youGive)
			if (selected < 0) then
				outputCarSystemError("Не выбрана машина!")
				return
			end
			guiGridListRemoveRow(GUI.gridlist.ic_youGive, selected)
			for i=selected, #ic_youGiveGridlistData do
				ic_youGiveGridlistData[i] = ic_youGiveGridlistData[i+1]
				ic_youGiveGridlistData[i+1] = nil
			end
			sendGridData()
		else
			outputCarSystemError("Перед изменениями снимите галочку готовности!")
		end
		
	elseif (source == GUI.button.ic_ready) then
		if antiDOScheck() then
			local state = not iAmReady
			iAmReady = state
			updateStates()
			triggerServerEvent("updateReadyState", resourceRoot, interchangeID, "ready", state)
		end
		
	elseif (source == GUI.button.ic_confirm) then
		if antiDOScheck() then
			local state = not iConfirm
			iConfirm = state
			updateStates()
			triggerServerEvent("updateReadyState", resourceRoot, interchangeID, "confirm", state)
		end
		
	end
end
addEventHandler("onClientGUIClick", resourceRoot, ic_onGUIClick)

function ic_onClientGUIDoubleClick()
	if (source == GUI.gridlist.ic_cp_playerList) then
		source = GUI.button.ic_cp_choose
		ic_onGUIClick()
		
	elseif (source == GUI.gridlist.ic_ap_cars) then
		source = GUI.button.ic_ap_OK
		ic_onGUIClick()
		
	end
end
addEventHandler("onClientGUIDoubleClick", resourceRoot, ic_onClientGUIDoubleClick)

function ic_requestsPlayer(ID, player)
	if isElement(player) then
		if (not interchangeID) then
			interchangeID = ID
			guiSetVisible(GUI.window.ic_invitation, true)
			outputCarSystemInfo(getPlayerName(player).."#цв# предлагает вам обмен")
			guiSetText(GUI.label.ic_invitator, getPlayerNameWOutCC(player).." предлагает вам обмен.\n\nПодробности обмена можно будет изменить в следующем окне.")
			guiSetInputMode("no_binds_when_editing")
			showCursor(true)
		else
			triggerServerEvent("ic_playerIsBusy", resourceRoot, ID)
		end
	end
end
addEvent("ic_requestsPlayer", true)
addEventHandler("ic_requestsPlayer", resourceRoot, ic_requestsPlayer)

function ic_inviteAccepted(player, accName)
	guiSetVisible(GUI.window.ic_wait, false)
	guiSetVisible(GUI.window.ic_main, true)
	guiSetText(GUI.label.fee, "Налог на сделку: 0 руб. Взимается: "..(isFirstPlayer and "с вас." or "с другого игрока"))
	guiSetText(GUI.label.ic_opponentName, "Вы получаете от "..getPlayerNameWOutCC(player).." (логин "..accName.."):")
	updateStates()
end
addEvent("ic_inviteAccepted", true)
addEventHandler("ic_inviteAccepted", resourceRoot, ic_inviteAccepted)

function ic_onClientGUIMove()
	if (source == GUI.window.ic_main) then
		local x, y = guiGetPosition(GUI.window.ic_main, false)
		guiSetPosition(GUI.window.ic_addPosition, x+505, y, false)
	elseif (source == GUI.window.ic_addPosition) then
		local x, y = guiGetPosition(GUI.window.ic_addPosition, false)
		guiSetPosition(GUI.window.ic_main, x-505, y, false)
	end
end
addEventHandler("onClientGUIMove", resourceRoot, ic_onClientGUIMove)

function ic_checkAddPositionWindow()
	if guiRadioButtonGetSelected(GUI.radiobutton.ic_ap_car) or guiRadioButtonGetSelected(GUI.radiobutton.ic_ap_nomer) then
		guiSetText(GUI.window.ic_addPosition, "Добавить автомобиль")
		if guiRadioButtonGetSelected(GUI.radiobutton.ic_ap_nomer) then
			guiSetText(GUI.window.ic_addPosition, "Добавить номер")
		end
		guiSetSize(GUI.window.ic_addPosition, 310, 400, false)
		guiSetVisible(GUI.gridlist.ic_ap_cars, true)
		guiSetVisible(GUI.label.ic_ap_amount, false)
		guiSetVisible(GUI.edit.ic_ap_amount, false)
		guiSetPosition(GUI.button.ic_ap_OK, 230, 355, false)
	else
		guiSetText(GUI.window.ic_addPosition, "Передача денег")
		guiSetSize(GUI.window.ic_addPosition, 130, 205, false)
		guiSetVisible(GUI.gridlist.ic_ap_cars, false)
		guiSetVisible(GUI.label.ic_ap_amount, true)
		guiSetVisible(GUI.edit.ic_ap_amount, true)
		guiSetPosition(GUI.button.ic_ap_OK, 50, 160, false)
	end
end

function refreshInterchangeGrid(data)
	local rw, cl = guiGridListGetSelectedItem(GUI.gridlist.ic_ap_cars)
	guiGridListClear(GUI.gridlist.ic_ap_cars)
	for _, dataRow in ipairs(data) do			
		local row = guiGridListAddRow(GUI.gridlist.ic_ap_cars)
		guiGridListSetItemText(GUI.gridlist.ic_ap_cars, row, 1, getVehicleModName(dataRow.model), false, true)
		guiGridListSetItemText(GUI.gridlist.ic_ap_cars, row, 2, convertPlateIDtoLicensep(dataRow.licensep), false, true)
		vehListData[row] = {ID = dataRow.ID, model = dataRow.model}
	end
	guiGridListSetSelectedItem(GUI.gridlist.ic_ap_cars, rw, cl)
end

function findThingInYouGiveList(tType, IDtoFind)
	local rows = guiGridListGetRowCount(GUI.gridlist.ic_youGive)
	for row = 0, rows-1 do
		if (ic_youGiveGridlistData[row]) and (ic_youGiveGridlistData[row].rowType == tType) then
			if (tType == "car") or (tType == "nomer") then
				if (IDtoFind) then
					local gridItemData = ic_youGiveGridlistData[row]
					if (gridItemData.carID == IDtoFind) then
						return row
					end
				else
					return row
				end
			else
				return row
			end
		end
	end
	return false
end

function sendGridData()
	myFee = 0 -- Расчет налога: 500к с машины на обмен номеров (итого 1кк), 2,5% от стоимости машин и передаваемых денег
	local dataToSend = {
		cars = {},
		nomer = nil,
		money = 0
	}
	local rows = guiGridListGetRowCount(GUI.gridlist.ic_youGive)
	-- outputChatBox(tostring(rows))
	for row = 0, rows-1 do
		local rowType = ic_youGiveGridlistData[row].rowType
		if (rowType == "car") then
			local data = ic_youGiveGridlistData[row]
			table.insert(dataToSend.cars, {data = data.carID, text = guiGridListGetItemText(GUI.gridlist.ic_youGive, row, 2)})
			if isResourceRunning("bank") then
				local price, currency = getCarPrice(data.model)
				myFee = myFee + exports.bank:convertCurrency(price*0.025, currency, "RUB")
			else
				myFee = myFee + getCarPrice(data.model)*0.025
			end
		elseif (rowType == "nomer") then
			local data = ic_youGiveGridlistData[row]
			dataToSend.nomer = {data = data.carID, text = guiGridListGetItemText(GUI.gridlist.ic_youGive, row, 2)}
			myFee = myFee + 500000
		elseif (rowType == "money") then
			dataToSend.money = ic_youGiveGridlistData[row].amount
			myFee = myFee + dataToSend.money*0.025
		end
	end
	guiSetText(GUI.label.fee, "Налог на сделку: "..explodeNumber(math.floor(myFee+(hisFee or 0))).." руб. Взимается: "..((isFirstPlayer and "с вас.") or "с другого игрока"))
	triggerServerEvent("syncGrid", resourceRoot, interchangeID, dataToSend, myFee)
	heIsReady = false
	updateStates()	
end

function catchGridData(data, fee)
	guiGridListClear(GUI.gridlist.ic_youTake)
	for _, car in ipairs(data.cars) do
		local row = guiGridListAddRow(GUI.gridlist.ic_youTake)
		guiGridListSetItemText(GUI.gridlist.ic_youTake, row, 1, "Автомобиль", false, false)
		guiGridListSetItemText(GUI.gridlist.ic_youTake, row, 2, car.text, false, false)
	end
	if (data.nomer) then
		local row = guiGridListAddRow(GUI.gridlist.ic_youTake)
		guiGridListSetItemText(GUI.gridlist.ic_youTake, row, 1, "Номер", false, false)
		guiGridListSetItemText(GUI.gridlist.ic_youTake, row, 2, data.nomer.text, false, false)
	end
	if (data.money) and (data.money ~= 0) then
		local row = guiGridListAddRow(GUI.gridlist.ic_youTake)
		guiGridListSetItemText(GUI.gridlist.ic_youTake, row, 1, "Деньги", false, false)
		guiGridListSetItemText(GUI.gridlist.ic_youTake, row, 2, explodeNumber(data.money).." руб.", false, false)
	end
	hisFee = fee
	guiSetText(GUI.label.fee, "Налог на сделку: "..explodeNumber(math.floor((myFee or 0)+(hisFee or 0))).." руб. Взимается: "..((isFirstPlayer and "с вас.") or "с другого игрока"))
	resetReady()
end
addEvent("catchGridData", true)
addEventHandler("catchGridData", resourceRoot, catchGridData)

function updateStates()
	if iAmReady then
		guiStaticImageLoadImage(GUI.staticimage.ic_youReady, "assets/yes.png")
		guiSetEnabled(GUI.button.ic_addItem, false)
		guiSetEnabled(GUI.button.ic_removeItem, false)
		guiSetVisible(GUI.window.ic_addPosition, false)
		guiSetText(GUI.button.ic_ready, "Не готов")
	else
		guiStaticImageLoadImage(GUI.staticimage.ic_youReady, "assets/no.png")
		guiSetEnabled(GUI.button.ic_addItem, true)
		guiSetEnabled(GUI.button.ic_removeItem, true)
		guiSetText(GUI.button.ic_ready, "Готов")
	end
	if heIsReady then
		guiStaticImageLoadImage(GUI.staticimage.ic_opponentReady, "assets/yes.png")
	else
		guiStaticImageLoadImage(GUI.staticimage.ic_opponentReady, "assets/no.png")
	end
	if (iAmReady and heIsReady) then
		guiSetEnabled(GUI.button.ic_confirm, true)
	else
		guiSetEnabled(GUI.button.ic_confirm, false)
		iConfirm = false
		heConfirms = false
	end
	if iConfirm then
		guiStaticImageLoadImage(GUI.staticimage.ic_youConfirm, "assets/yes.png")
	else
		guiStaticImageLoadImage(GUI.staticimage.ic_youConfirm, "assets/no.png")
	end
	if heConfirms then
		guiStaticImageLoadImage(GUI.staticimage.ic_opponentConfirm, "assets/yes.png")
	else
		guiStaticImageLoadImage(GUI.staticimage.ic_opponentConfirm, "assets/no.png")
	end
end

function updateReadyState(stateType, state)
	if (stateType == "ready") then
		heIsReady = state
	elseif (stateType == "confirm") then
		heConfirms = state
	end
	updateStates()
end
addEvent("updateReadyState", true)
addEventHandler("updateReadyState", resourceRoot, updateReadyState)

function resetReady()
	iAmReady = false 
	heIsReady = false
	heIsReady = false
	heConfirms = false
	updateStates()
end
addEvent("resetReady", true)
addEventHandler("resetReady", resourceRoot, resetReady)

function ic_closeAllWindows()
	guiSetVisible(GUI.window.ic_cp_chooseplayer, false)
	colshapeToSearchPlayers = false
	guiSetVisible(GUI.window.ic_wait, false)
	guiSetVisible(GUI.window.ic_invitation, false)
	guiSetVisible(GUI.window.ic_main, false)
	guiGridListClear(GUI.gridlist.ic_youGive)
	guiGridListClear(GUI.gridlist.ic_youTake)
	guiSetVisible(GUI.window.ic_addPosition, false)
	guiGridListSetSelectedItem(GUI.gridlist.ic_ap_cars, 0, 0)
	guiSetText(GUI.edit.ic_ap_amount, "")
	interchangeID, iAmReady, heIsReady, iConfirm, heConfirms, myFee, hisFee, isFirstPlayer = nil
	hideCursor()
end
addEvent("ic_cancelInterchange", true)
addEventHandler("ic_cancelInterchange", resourceRoot, ic_closeAllWindows)

function getPlayerNameWOutCC(player)
	return string.gsub(getPlayerName(player), '#%x%x%x%x%x%x', '')
end
