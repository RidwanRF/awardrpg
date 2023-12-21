
local previewFile = "files/orderPreview.png"

local storageData = {}

function createStorageGUI()	
	GUI.button.openStorage = guiCreateButton(410, 60, 95, 25, "Хранилище >", false, GUI.window.main)
	
	GUI.tab.storage = guiCreateTab("Хранилище", GUI.tabpanel.main) 				
	
	GUI.label[23] = guiCreateLabel(10, 13, 95, 15, "Именной номер:", false, GUI.tab.storage)
	GUI.edit.orderInput = guiCreateEdit(115, 10, 130, 25, "", false, GUI.tab.storage)
	guiEditSetMaxLength(GUI.edit.orderInput, 40)
	GUI.button.orderPreview = guiCreateButton(10, 45, 115, 30, "Предпросмотр", false, GUI.tab.storage)
	GUI.button.order = guiCreateButton(135, 45, 110, 30, "Заказать", false, GUI.tab.storage)
	GUI.staticimage.orderPreview = guiCreateStaticImage(10, 85, 235, 50, "files/blank.png", false, GUI.tab.storage)
	
	GUI.label[27] = guiCreateLabel(10, 140, 235, 30, "Установить номер из хранилища\nСтоимость - "..savingPrices.onlyLoad.text, false, GUI.tab.storage)
	guiLabelSetHorizontalAlign(GUI.label[27], "left", true)
	GUI.button.setFromStorage = guiCreateButton(10, 175, 190, 25, "Установить из хранилища", false, GUI.tab.storage)
	GUI.label[25] = guiCreateLabel(255, 10, 190, 45, "Сохранить номер с машины\nи поставить случайный.\nСтоимость - "..savingPrices.saveSetRandom.text, false, GUI.tab.storage)
	guiLabelSetHorizontalAlign(GUI.label[25], "left", true)
	GUI.button.saveAndReplaceRandom = guiCreateButton(255, 65, 190, 35, "Сохранить\nи заменить случайным", false, GUI.tab.storage)
	GUI.label[26] = guiCreateLabel(255, 115, 190, 46, "Сохранить номер с машины\nи поставить с хранилища\nСтоимость - "..savingPrices.saveLoad.text, false, GUI.tab.storage)
	guiLabelSetHorizontalAlign(GUI.label[26], "left", true)
	GUI.button.saveAndReplace = guiCreateButton(255, 170, 190, 30, "Сохранить и установить", false, GUI.tab.storage)

	local x, y = guiGetPosition(GUI.window.main, false)
	local sX, sY = guiGetSize(GUI.window.main, false)
	GUI.window.storage = guiCreateWindow(x+sX, y, 265, sY, "Хранилище номеров", false)
	guiWindowSetSizable(GUI.window.storage, false)  
	
	GUI.gridlist.storage = guiCreateGridList(10, 25, 245, 475, false, GUI.window.storage)
	guiGridListSetSortingEnabled (GUI.gridlist.storage, false)
	guiGridListAddColumn(GUI.gridlist.storage, "Номер", 0.45)
	guiGridListAddColumn(GUI.gridlist.storage, "Время хранения", 0.45)
	GUI.button.removeFromStorage = guiCreateButton(190, 510, 65, 25, "Удалить", false, GUI.window.storage) 
	GUI.button.viewFromStorage = guiCreateButton(10, 510, 115, 25, "<<< Просмотр", false, GUI.window.storage)
		
	local screenW, screenH = guiGetScreenSize()
	GUI.window.confirm = guiCreateWindow((screenW-250)/2, (screenH-175)/2, 250, 175, "Подтверждение", false)
	guiWindowSetSizable(GUI.window.confirm, false)
	guiSetAlpha(GUI.window.confirm, 1.00)

	GUI.label.confirmText = guiCreateLabel(10, 25, 230, 100, "", false, GUI.window.confirm)
	guiLabelSetHorizontalAlign(GUI.label.confirmText, "left", true)
	GUI.button.confirmOK = guiCreateButton(10, 135, 60, 30, "Да", false, GUI.window.confirm)
	GUI.button.confirmCancel = guiCreateButton(180, 135, 60, 30, "Нет", false, GUI.window.confirm)
	
	guiSetVisible(GUI.window.storage, false)
	guiSetVisible(GUI.window.confirm, false)
end

-- ==========     Обновление списка номеров     ==========
function refreshStorageList(data)
	local rw, cl = guiGridListGetSelectedItem(GUI.gridlist.storage)
	guiGridListClear(GUI.gridlist.storage)
	for _, dataRow in ipairs(data) do
		local row = guiGridListAddRow(GUI.gridlist.storage)
		guiGridListSetItemText(GUI.gridlist.storage, row, 1, exports.car_system:convertPlateIDtoLicensep(dataRow.licensep), false, true)
		local text
		if (dataRow.time) then
			text = calculateTimeDiff(dataRow.time + storageTime, getRealTime().timestamp)
		else
			text = (dataRow.status == "waiting") and "[на модерации]" or "["..dataRow.comment.."]"
		end
		guiGridListSetItemText(GUI.gridlist.storage, row, 2, text, false, true)
		storageData[row] = dataRow
	end
	guiGridListSetSelectedItem(GUI.gridlist.storage, rw, cl)
end
addEvent("refreshStorageList", true)
addEventHandler("refreshStorageList", resourceRoot, refreshStorageList)

addEventHandler("onClientGUIClick", resourceRoot, function()
	if (source == GUI.button.openStorage) then
		guiSetSelectedTab(GUI.tabpanel.main, GUI.tab.storage)
		
	elseif (source == GUI.button.orderPreview) then
		local nomer = "h-"..guiGetText(GUI.edit.orderInput)
		previewLicensep(nomer)
		
	elseif (source == GUI.button.viewFromStorage) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.storage)
		if (selected > -1) then
			previewLicensep(storageData[selected].licensep)
		end
	
	elseif (source == GUI.button.saveAndReplaceRandom) then
		saveAndReplaceRandom()
	
	elseif (source == GUI.button.setFromStorage) then
		setFromStorage()
	
	elseif (source == GUI.button.saveAndReplace) then
		saveAndReplace()
	
	elseif (source == GUI.button.order) then
		local nomer = "h-"..string.trim(guiGetText(GUI.edit.orderInput))
		if not nomerIsCorrect(nomer) then
			outputBadMessage("Проверьте правильность ввода номера. Он не должен содержать кириллицу и запрещенные символы")
			return
		end
		previewLicensep(nomer)
		triggerServerEvent("getInputInfo", resourceRoot, nomer)
		guiSetText(GUI.label.newNomer, exports.car_system:convertPlateIDtoLicensep(nomer))
		
	elseif (source == GUI.button.removeFromStorage) then
		removeNomer()
		
	elseif (source == GUI.button.confirmCancel) then
		closeConfirmWindow()
	
	elseif (source == GUI.button.confirmOK) then
		local data = getConfirmData()
		if (data.func == "saveAndReplaceRandom") then
			saveAndReplaceRandomAfterConfirm()
		elseif (data.func == "setFromStorage") then
			setFromStorageAfterConfirm(data.storageID)
		elseif (data.func == "saveAndReplace") then
			saveAndReplaceAfterConfirm(data.storageID)
		elseif (data.func == "removeNomer") then
			triggerServerEvent("removeNomer", resourceRoot, data.storageID, data.info)
		end
		closeConfirmWindow()
	
	end
end)

-- ==========     Сохранить и заменить случайным     ==========
function saveAndReplaceRandom()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы сохранить номер.") return
	end
	local licensep = getElementData(vehicle, "licensep")
	if (not licensep) then
		outputBadMessage("Вы не можете сохранить номер. Это не личная машина.") return
	end
	if (licensep:sub(1, 1) == "b") then
		outputBadMessage("Вы не можете сохранить полицейский номер.")
		return
	end
	local data = {func = "saveAndReplaceRandom"}
	local text = string.format("Вы действительно хотите сохранить номер %s с %s и установить случайный?.\nСтоимость - %s",
		exports.car_system:convertPlateIDtoLicensep(licensep), exports.car_system:getVehicleModName(vehicle), savingPrices.saveSetRandom.text)
	openConfirmWindow(text, data)
end
function saveAndReplaceRandomAfterConfirm()
	if not isResourceRunning("car_system") or not isResourceRunning("mysql") or not isResourceRunning("bank") then
		outputBadMessage("Невозможно сохранить номер.")
		return
	end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы сохранить номер.")
		return
	end
	local ID = getElementData(vehicle, "ID")
	if (not ID) then
		outputBadMessage("Вы не можете сохранить номер. Это не личная машина.")
		return
	end
	if (exports.bank:getPlayerBankMoney(savingPrices.saveSetRandom.currency) < savingPrices.saveSetRandom.amount) then
		outputBadMessage("Вы не можете сохранить номер. У вас недостаточно средств на банковском счету. Стоимость: "..savingPrices.saveSetRandom.text)
		return
	end
	triggerServerEvent("saveAndReplaceRandom", resourceRoot)
end

-- ==========     Установить из хранилища     ==========
function setFromStorage()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.storage)
	if (selected < 0) then
		outputBadMessage("Выберите номер из списка.")
		return
	end
	local info = storageData[selected]
	if (not info) then
		outputBadMessage("Произошла неизвестная ошибка (#10).")
		return
	end
	if (not info.time) then
		outputBadMessage("Невозможно установить номер, который не был проверен администрацией.")
		return
	end
	local storageID = info.ID
	if (not storageID) then
		outputBadMessage("Произошла неизвестная ошибка (#11).")
		return
	end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы установить номер.")
		return
	end
	local licensep = getElementData(vehicle, "licensep")
	if (not licensep) then
		outputBadMessage("Вы не можете установить номер. Это не личная машина.")
		return
	end
	local data = {func = "setFromStorage", storageID = storageID}
	local text = string.format("Вы действительно хотите установить номер %s на %s? Текущий номер %s будет удален.\nСтоимость - %s",
		exports.car_system:convertPlateIDtoLicensep(info.licensep), exports.car_system:getVehicleModName(vehicle), exports.car_system:convertPlateIDtoLicensep(licensep), savingPrices.onlyLoad.text)
	openConfirmWindow(text, data)
end
function setFromStorageAfterConfirm(storageID)
	if not isResourceRunning("car_system") or not isResourceRunning("mysql") or not isResourceRunning("bank") then
		outputBadMessage("Невозможно установить номер.")
		return
	end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы установить номер.")
		return
	end
	local ID = getElementData(vehicle, "ID")
	if (not ID) then
		outputBadMessage("Вы не можете установить номер. Это не личная машина.")
		return
	end
	if (exports.bank:getPlayerBankMoney(savingPrices.onlyLoad.currency) < savingPrices.onlyLoad.amount) then
		outputBadMessage("Вы не можете установить номер. У вас недостаточно средств на банковском счету. Стоимость: "..savingPrices.onlyLoad.text)
		return
	end
	triggerServerEvent("setFromStorage", resourceRoot, storageID)
end

-- ==========     Сохранить и заменить     ==========
function saveAndReplace()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.storage)
	if (selected < 0) then
		outputBadMessage("Выберите номер из списка.")
		return
	end
	local info = storageData[selected]
	if (not info) then
		outputBadMessage("Произошла неизвестная ошибка (#12).")
		return
	end
	if (not info.time) then
		outputBadMessage("Невозможно установить номер, который не был проверен администрацией.")
		return
	end
	local storageID = info.ID
	if (not storageID) then
		outputBadMessage("Произошла неизвестная ошибка (#13).")
		return
	end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы установить номер.")
		return
	end
	local licensep = getElementData(vehicle, "licensep")
	if (not licensep) then
		outputBadMessage("Вы не можете установить номер. Это не личная машина.")
		return
	end
	if (licensep:sub(1, 1) == "b") then
		outputBadMessage("Вы не можете сохранить полицейский номер.")
		return
	end
	local data = {func = "saveAndReplace", storageID = storageID}
	local text = string.format("Вы действительно хотите установить номер %s на %s? Текущий номер %s будет сохранен в хранилище.\nСтоимость - %s",
		exports.car_system:convertPlateIDtoLicensep(info.licensep), exports.car_system:getVehicleModName(vehicle), exports.car_system:convertPlateIDtoLicensep(licensep), savingPrices.saveLoad.text)
	openConfirmWindow(text, data)

end
function saveAndReplaceAfterConfirm(storageID)
	if not isResourceRunning("car_system") or not isResourceRunning("mysql") or not isResourceRunning("bank") then
		outputBadMessage("Невозможно заменить номер (#14).")
		return
	end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) then
		outputBadMessage("Вы должны сидеть в машине, чтобы заменить номер.")
		return
	end
	local ID = getElementData(vehicle, "ID")
	if (not ID) then
		outputBadMessage("Вы не можете заменить номер. Это не личная машина.")
		return
	end
	if (exports.bank:getPlayerBankMoney(savingPrices.saveLoad.currency) < savingPrices.saveLoad.amount) then
		outputBadMessage("Вы не можете заменить номер. У вас недостаточно средств на банковском счету. Стоимость: "..savingPrices.saveLoad.text)
		return
	end
	triggerServerEvent("saveAndReplace", resourceRoot, storageID)
end

-- ==========     Удалить номер     ==========
function removeNomer()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.storage)
	if (selected < 0) then
		outputBadMessage("Выберите номер из списка.")
		return
	end
	local info = storageData[selected]
	if (not info) then
		outputBadMessage("Произошла неизвестная ошибка (#15).")
		return
	end
	local storageID = info.ID
	if (not storageID) then
		outputBadMessage("Произошла неизвестная ошибка (#16).")
		return
	end
	local data = {func = "removeNomer", storageID = storageID, info = info}
	local text
	if (info.time) then
		text = string.format("Вы действительно хотите удалить номер %s из хранилища?\nВнимание! Его стоимость возвращена не будет.", exports.car_system:convertPlateIDtoLicensep(info.licensep))
	elseif (info.status ~= "refused") then
		text = string.format("Вы действительно хотите удалить находящийся на модерации номер %s?", exports.car_system:convertPlateIDtoLicensep(info.licensep))
	end
	if (text) then
		openConfirmWindow(text, data)
	else
		triggerServerEvent("removeNomer", resourceRoot, storageID, info)
	end
end

-- ==========     Предпросмотр номера     ==========
function previewLicensep(nomer)
	setTexturePreview(GUI.staticimage.orderPreview, nomer)
	if isResourceRunning("car_system") then
		nomer = exports.car_system:convertPlateIDtoLicensep(nomer)
		fitTextIntoField(nomer, GUI.label.newNomer)	
	end
end
function setTexturePreview(staticimage, nomer)
	if isResourceRunning("car_realnomer") then
		local _, texture = exports.car_realnomer:generatePlate(nomer)
		if (texture) then
			texture = dxConvertPixels(texture, 'png')
			local file = fileCreate(previewFile)
			fileWrite(file, texture)
			fileClose(file)
			guiStaticImageLoadImage(staticimage, previewFile)
		end
	end
end

-- ==========     Мелкая работа с окнами     ==========
addEventHandler("onClientGUITabSwitched", resourceRoot, function()
	if (source == GUI.tab.storage) then
		guiSetVisible(GUI.window.storage, true)
		triggerServerEvent("updateStorageInfo", resourceRoot)
	else
		guiSetVisible(GUI.window.storage, false)
	end
end)

addEventHandler("onClientGUIMove", resourceRoot, function()
	if (source == GUI.window.main) then
		local x, y = guiGetPosition(GUI.window.main, false)
		local sX, sY = guiGetSize(GUI.window.main, false)
		guiSetPosition(GUI.window.storage, x+sX, y, false)
	elseif (source == GUI.window.storage) then
		local x, y = guiGetPosition(GUI.window.storage, false)
		local sX, sY = guiGetSize(GUI.window.main, false)
		guiSetPosition(GUI.window.main, x-sX, y, false)
	end
end)

function closeStorageWindow()
	guiSetVisible(GUI.window.storage, false)
end

-- ==========     Окно подтверждения     ==========
local confirmData

function openConfirmWindow(text, data)
	guiSetVisible(GUI.window.confirm, true)
	guiBringToFront(GUI.window.confirm)
	guiSetText(GUI.label.confirmText, text)
	confirmData = data
end

function getConfirmData()
	return confirmData
end

function closeConfirmWindow()
	guiSetVisible(GUI.window.confirm, false)
	confirmData = nil
end


-- ==========     Подвал     ==========

-- Получение строки с разницей времени
function calculateTimeDiff(time1, time2)
	local timeData = getRealTime(math.abs(time1-time2), false)
	timeData.monthday = timeData.monthday - 1
	timeData.year = timeData.year - 70
	
	if (timeData.year > 0) then
		local tType = getNameType(timeData.year)
		if (tType == 1) then
			return timeData.year.." год"
		elseif (tType == 2) then
			return timeData.year.." года"
		else
			return timeData.year.." лет"
		end
	elseif (timeData.month > 0) then
		local tType = getNameType(timeData.month)
		if (tType == 1) then
			return timeData.month.." месяц"
		elseif (tType == 2) then
			return timeData.month.." месяца"
		else
			return timeData.month.." месяцев"
		end
	elseif (timeData.monthday > 0) then
		local tType = getNameType(timeData.monthday)
		if (tType == 1) then
			return timeData.monthday.." день"
		elseif (tType == 2) then
			return timeData.monthday.." дня"
		else
			return timeData.monthday.." дней"
		end
	elseif (timeData.hour > 0) then
		local tType = getNameType(timeData.hour)
		if (tType == 1) then
			return timeData.hour.." час"
		elseif (tType == 2) then
			return timeData.hour.." часа"
		else
			return timeData.hour.." часов"
		end
	else
		local tType = getNameType(timeData.minute)
		if (tType == 1) then
			return timeData.minute.." минута"
		elseif (tType == 2) then
			return timeData.minute.." минуты"
		else
			return timeData.minute.." минут"
		end
	end
end
function getNameType(number)
	-- 1 = 1 год, 2 = 2,3,4 года, 3 = 5,6,... лет
	if (number > 9) and (number < 20) then return 3 end
	number = number - (math.floor(number/10)*10)
	if (number == 1) then return 1 end
	if (1 < number) and (number < 5) then return 2 end
	return 3
end

-- Обрезка пробелов в начале и конце
function string.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

