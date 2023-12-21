
-- ==========     Создание гуи и реакция на нажатия     ==========
local GUI = {
    tab = {},
    edit = {},
    window = {},
    tabpanel = {},
    checkbox = {},
    button = {},
    gridlist = {},
    label = {},
    combobox = {},
    radiobutton = {},
}
local selectedRadioButton
local sortingCriteriaTable = {}
local pagesCount = 1
addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenW, screenH = guiGetScreenSize()
	GUI.window.bans = guiCreateWindow((screenW - 555) / 2, (screenH - 580) / 2, 555, 580, "Баны аккаунтов", false)
	guiWindowSetSizable(GUI.window.bans, false)
	GUI.tabpanel.bans = guiCreateTabPanel(10, 25, 535, 510, false, GUI.window.bans)

	-- Вкладка "Игроки"
	GUI.tab.players = guiCreateTab("Игроки", GUI.tabpanel.bans)

	GUI.label[1] = guiCreateLabel(10, 14, 55, 15, "Логин", false, GUI.tab.players)
	GUI.edit.banLogin = guiCreateEdit(75, 10, 250, 25, "", false, GUI.tab.players)
	guiEditSetMaxLength(GUI.edit.banLogin, 100)
	GUI.button.banFindSerial = guiCreateButton(335, 10, 110, 25, "Посл. серийник", false, GUI.tab.players)
	GUI.button.intoNickloginLogin = guiCreateButton(454, 10, 71, 25, "В никлогин", false, GUI.tab.players)

	GUI.label[2] = guiCreateLabel(10, 49, 55, 15, "Серийник", false, GUI.tab.players)
	GUI.edit.banSerial = guiCreateEdit(75, 45, 250, 25, "", false, GUI.tab.players)
	guiEditSetMaxLength(GUI.edit.banSerial, 33)
	GUI.button.intoNickloginSerial = guiCreateButton(335, 45, 190, 25, "Искать в никлогине", false, GUI.tab.players)

	GUI.label[3] = guiCreateLabel(10, 84, 55, 15, "Срок", false, GUI.tab.players)
	GUI.edit.banTime = guiCreateEdit(75, 80, 160, 25, "", false, GUI.tab.players)
	guiEditSetMaxLength(GUI.edit.banTime, 10)
	GUI.combobox.banPeriod = guiCreateComboBox(245, 80, 80, 110, "", false, GUI.tab.players)
	guiComboBoxAddItem(GUI.combobox.banPeriod, "Минуты")
	guiComboBoxAddItem(GUI.combobox.banPeriod, "Часы")
	guiComboBoxAddItem(GUI.combobox.banPeriod, "Сутки")
	guiComboBoxAddItem(GUI.combobox.banPeriod, "Недели")
	guiComboBoxAddItem(GUI.combobox.banPeriod, "Месяцы")
	GUI.button.ban1Day = guiCreateButton(335, 80, 40, 25, "1 д.", false, GUI.tab.players)
	GUI.button.ban3Days = guiCreateButton(385, 80, 40, 25, "3 д.", false, GUI.tab.players)
	GUI.button.ban1Week = guiCreateButton(435, 80, 40, 25, "1 нед.", false, GUI.tab.players)
	GUI.button.ban2Weeks = guiCreateButton(485, 80, 40, 25, "2 нед.", false, GUI.tab.players)
	GUI.button.ban1Month = guiCreateButton(335, 115, 50, 25, "1 мес.", false, GUI.tab.players)
	GUI.button.ban3Months = guiCreateButton(395, 115, 50, 25, "3 мес.", false, GUI.tab.players)
	GUI.button.banForever = guiCreateButton(455, 115, 70, 25, "Навсегда", false, GUI.tab.players)

	GUI.label[4] = guiCreateLabel(10, 119, 55, 15, "Причина", false, GUI.tab.players)
	GUI.edit.banReason = guiCreateEdit(75, 115, 250, 25, "", false, GUI.tab.players)
	guiEditSetMaxLength(GUI.edit.banReason, 50)
	GUI.button.ban = guiCreateButton(10, 150, 75, 25, "Забанить", false, GUI.tab.players)

	GUI.label[5] = guiCreateLabel(95, 153, 40, 15, "Поиск:", false, GUI.tab.players)
	GUI.edit.searchPlayers = guiCreateEdit(135, 150, 150, 25, "", false, GUI.tab.players)
	GUI.button.refreshPlayers = guiCreateButton(295, 150, 70, 25, "Обновить", false, GUI.tab.players)
	GUI.button.choosePlayer = guiCreateButton(375, 150, 150, 25, "^^^ Выбрать из списка", false, GUI.tab.players)
	GUI.gridlist.players = guiCreateGridList(10, 185, 515, 265, false, GUI.tab.players)
	guiGridListSetSortingEnabled(GUI.gridlist.players, false)
	guiGridListAddColumn(GUI.gridlist.players, "Ник", 0.40)
	guiGridListAddColumn(GUI.gridlist.players, "Логин", 0.40)
	guiGridListAddColumn(GUI.gridlist.players, "Расстояние", 0.11)
	GUI.checkbox.hideColorCodes = guiCreateCheckBox(10, 460, 155, 15, "Скрыть цветовые коды", true, false, GUI.tab.players)
	GUI.checkbox.sortByDistance = guiCreateCheckBox(175, 460, 185, 15, "Сортировать по расстоянию", true, false, GUI.tab.players)
	
	--[[
	-- Окно с причинами банов
	local x, y = guiGetPosition(GUI.window.bans)
	GUI.window.reasons = guiCreateWindow(x + 10, y, 300, 580, "Причины бана", false)
	guiWindowSetSizable(GUI.window.reasons, false)
	GUI.label[1] = guiCreateLabel(10, 29, 40, 15, "Поиск:", false, GUI.window.reasons)
	GUI.edit.reasonSearch = guiCreateEdit(60, 25, 230, 25, "", false, GUI.window.reasons)
	GUI.label[2] = guiCreateLabel(10, 55, 70, 15, "Подстроить:", false, GUI.window.reasons)
	GUI.scrollbar.reasonDuration = guiCreateScrollBar(10, 75, 280, 19, true, false, GUI.window.reasons)
	GUI.label.selectedPeriod = guiCreateLabel(10, 54, 280, 16, "", false, GUI.window.reasons)
	guiLabelSetHorizontalAlign(GUI.label.selectedPeriod, "right", false)    
	GUI.gridlist.reasons = guiCreateGridList(10, 100, 280, 435, false, GUI.window.reasons)
	guiGridListAddColumn(GUI.gridlist.reasons, "№", 0.1)
	guiGridListAddColumn(GUI.gridlist.reasons, "Причина", 0.8)
	guiGridListAddColumn(GUI.gridlist.reasons, "Срок", 0.5)
	GUI.button.selectReason = guiCreateButton(10, 540, 70, 30, "Выбрать", false, GUI.window.reasons)
	GUI.button.closeReason = guiCreateButton(220, 540, 70, 30, "Закрыть", false, GUI.window.reasons)
	]]
	
	-- Вкладка "Баны и поиск"
	GUI.tab.bans = guiCreateTab("Баны и поиск", GUI.tabpanel.bans)

	GUI.label[5] = guiCreateLabel(10, 14, 95, 15, "Логин/серийник", false, GUI.tab.bans)
	GUI.edit.searchLogin = guiCreateEdit(115, 10, 150, 25, "", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.searchLogin, 50)

	GUI.label[6] = guiCreateLabel(10, 44, 95, 15, "Кто забанил", false, GUI.tab.bans)
	GUI.edit.searchAdmin = guiCreateEdit(115, 40, 150, 25, "", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.searchAdmin, 50)

	GUI.label[7] = guiCreateLabel(10, 74, 95, 15, "Причина", false, GUI.tab.bans)
	GUI.edit.searchReason = guiCreateEdit(115, 70, 150, 25, "", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.searchReason, 50)

	GUI.label[8] = guiCreateLabel(275, 7, 250, 15, "Дата начала", false, GUI.tab.bans)
	guiLabelSetHorizontalAlign(GUI.label[8], "center", false)
	GUI.label[9] = guiCreateLabel(275, 30, 15, 15, "С", false, GUI.tab.bans)
	guiLabelSetHorizontalAlign(GUI.label[9], "center", false)
	GUI.edit.searchStartLeft = guiCreateEdit(300, 25, 95, 25, "", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.searchStartLeft, 10)
	GUI.label[10] = guiCreateLabel(405, 30, 15, 15, "По", false, GUI.tab.bans)
	guiLabelSetHorizontalAlign(GUI.label[10], "center", false)
	GUI.edit.searchStartRight = guiCreateEdit(430, 25, 95, 25, "", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.searchStartRight, 10)

	GUI.label[11] = guiCreateLabel(275, 52, 250, 15, "Дата окончания", false, GUI.tab.bans)
	guiLabelSetHorizontalAlign(GUI.label[11], "center", false)
	GUI.label[12] = guiCreateLabel(275, 75, 15, 15, "С", false, GUI.tab.bans)
	--guiLabelSetHorizontalAlign(GUI.label[15], "center", false)
	GUI.edit.searchEndLeft = guiCreateEdit(300, 70, 95, 25, "", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.searchEndLeft, 10)
	GUI.label[13] = guiCreateLabel(405, 75, 15, 15, "По", false, GUI.tab.bans)
	guiLabelSetHorizontalAlign(GUI.label[13], "center", false)
	GUI.edit.searchEndRight = guiCreateEdit(430, 70, 95, 25, "", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.searchEndRight, 10)

	GUI.button.search = guiCreateButton(10, 100, 80, 30, "Поиск", false, GUI.tab.bans)
	GUI.button.clearSearch = guiCreateButton(100, 100, 70, 30, "Очистить", false, GUI.tab.bans)
	
	GUI.label[1] = guiCreateLabel(330, 97, 195, 15, "Сортировка:", false, GUI.tab.bans)
	guiLabelSetHorizontalAlign(GUI.label[1], "center", false)
	GUI.combobox.sortType = guiCreateComboBox(330, 115, 120, 150, "", false, GUI.tab.bans)
	GUI.combobox.sortDirection = guiCreateComboBox(460, 115, 65, 70, "", false, GUI.tab.bans)
	guiComboBoxAddItem(GUI.combobox.sortDirection, "Убыв")
	guiComboBoxAddItem(GUI.combobox.sortDirection, "Возр")
	guiComboBoxSetSelected(GUI.combobox.sortDirection, 0)

	GUI.gridlist.bans = guiCreateGridList(10, 140, 515, 310, false, GUI.tab.bans)
	guiGridListAddColumn(GUI.gridlist.bans, "Логин", 0.145)
	guiGridListAddColumn(GUI.gridlist.bans, "Серийник", 0.08)
	guiGridListAddColumn(GUI.gridlist.bans, "Кем забанен", 0.145)
	guiGridListAddColumn(GUI.gridlist.bans, "Начало бана", 0.145)
	guiGridListAddColumn(GUI.gridlist.bans, "Длительность", 0.11)
	guiGridListAddColumn(GUI.gridlist.bans, "Конец бана", 0.145)
	guiGridListAddColumn(GUI.gridlist.bans, "Причина", 0.145)
	guiGridListSetSortingEnabled(GUI.gridlist.bans, false)

	GUI.button.refreshBans = guiCreateButton(10, 455, 125, 25, "Обновить список", false, GUI.tab.bans)
	GUI.radiobutton.activeBans = guiCreateRadioButton(145, 450, 75, 15, "Активные", false, GUI.tab.bans)
	guiRadioButtonSetSelected(GUI.radiobutton.activeBans, true)
	selectedRadioButton = GUI.radiobutton.activeBans
	GUI.radiobutton.oldBans = guiCreateRadioButton(145, 465, 75, 15, "Истекшие", false, GUI.tab.bans)
	GUI.label[16] = guiCreateLabel(230, 459, 25, 15, "Стр:", false, GUI.tab.bans)
	GUI.edit.page = guiCreateEdit(255, 455, 40, 25, "1", false, GUI.tab.bans)
	guiEditSetMaxLength(GUI.edit.page, 5)
	GUI.label.pages = guiCreateLabel(300, 459, 120, 15, "из 1", false, GUI.tab.bans)
	GUI.button.pageMinus = guiCreateButton(350, 455, 25, 25, "<-", false, GUI.tab.bans)
	GUI.button.pagePlus = guiCreateButton(380, 455, 25, 25, "+>", false, GUI.tab.bans)
	GUI.button.getBanInfo = guiCreateButton(420, 455, 105, 25, "Инфо ==>>", false, GUI.tab.bans)
	
	GUI.label.banListOutdated = guiCreateLabel(10, 540, 305, 30, "Список банов был изменен.\nОбновите его при необходимости.", false, GUI.window.bans)   

	-- Вкладка "Инфо о бане"
	GUI.tab.info = guiCreateTab("Инфо о бане", GUI.tabpanel.bans)
	guiSetEnabled(GUI.tab.info, false)

	GUI.label[15] = guiCreateLabel(10, 10, 90, 15, "ID:", false, GUI.tab.info)
	GUI.label.infoID = guiCreateLabel(110, 10, 415, 15, "", false, GUI.tab.info)

	GUI.label[16] = guiCreateLabel(10, 35, 90, 15, "Логин:", false, GUI.tab.info)
	GUI.label.infoLogin = guiCreateLabel(110, 35, 355, 15, "", false, GUI.tab.info)
	GUI.button.infoCopyLogin = guiCreateButton(475, 30, 50, 20, "Copy", false, GUI.tab.info)

	GUI.label[17] = guiCreateLabel(10, 60, 90, 15, "Серийник:", false, GUI.tab.info)
	GUI.label.infoSerial = guiCreateLabel(110, 60, 355, 15, "", false, GUI.tab.info)
	GUI.button.infoCopySerial = guiCreateButton(475, 55, 50, 20, "Copy", false, GUI.tab.info)

	GUI.label[18] = guiCreateLabel(10, 85, 90, 15, "Админ:", false, GUI.tab.info)
	GUI.label.infoAdmin = guiCreateLabel(110, 85, 355, 15, "", false, GUI.tab.info)
	GUI.button.infoCopyAdmin = guiCreateButton(475, 80, 50, 20, "Copy", false, GUI.tab.info)

	GUI.label[19] = guiCreateLabel(10, 110, 90, 15, "Причина:", false, GUI.tab.info)
	GUI.label.infoReason = guiCreateLabel(110, 110, 355, 15, "", false, GUI.tab.info)
	GUI.button.infoCopyReason = guiCreateButton(475, 105, 50, 20, "Copy", false, GUI.tab.info)

	GUI.label[20] = guiCreateLabel(10, 135, 90, 15, "Начало бана:", false, GUI.tab.info)
	GUI.label.infoStart = guiCreateLabel(110, 135, 355, 15, "", false, GUI.tab.info)
	GUI.button.infoCopyStart = guiCreateButton(475, 130, 50, 20, "Copy", false, GUI.tab.info)

	GUI.label[21] = guiCreateLabel(10, 160, 90, 15, "Длительность:", false, GUI.tab.info)
	GUI.label.infoDuration = guiCreateLabel(110, 160, 415, 15, "", false, GUI.tab.info)

	GUI.label[22] = guiCreateLabel(10, 185, 90, 15, "Окончание:", false, GUI.tab.info)
	GUI.label.infoEnd = guiCreateLabel(110, 185, 355, 15, "", false, GUI.tab.info)
	GUI.button.infoCopyEnd = guiCreateButton(475, 180, 50, 20, "Copy", false, GUI.tab.info)
	GUI.button.infoCopyAll = guiCreateButton(410, 210, 115, 35, "Скопировать всё", false, GUI.tab.info)

	GUI.checkbox.unbanLogin = guiCreateCheckBox(10, 255, 400, 15, "Разбанить логин (банов этого логина: 1)", false, false, GUI.tab.info)
	GUI.checkbox.unbanSerial = guiCreateCheckBox(10, 280, 400, 15, "Разбанить серийник (банов этого серийника: 1)", false, false, GUI.tab.info)
	GUI.button.unban = guiCreateButton(10, 305, 85, 35, "Разбанить", false, GUI.tab.info)

	GUI.button.close = guiCreateButton(460, 545, 85, 25, "Закрыть", false, GUI.window.bans)

	-- Настройка и процедурное заполнение
	guiSetVisible(GUI.window.bans, false)
	
	local sortingVariants = {
		{name = "По умолчанию",	criteria = "default"},
		{name = "Логин",		criteria = "account"},
		{name = "Серийник",		criteria = "serial"},
		{name = "Кем забанен",	criteria = "admin"},
		{name = "Начало бана",	criteria = "banStart"},
		{name = "Длительность",	criteria = "duration"},
		{name = "Конец бана",	criteria = "banEnd"},
		{name = "Причина",		criteria = "reason"},
	}
	for _, variant in ipairs(sortingVariants) do
		local item = guiComboBoxAddItem(GUI.combobox.sortType, variant.name)
		sortingCriteriaTable[item] = variant
	end
	sortingCriteriaTable[-1] = sortingCriteriaTable[0]
	guiComboBoxSetSelected(GUI.combobox.sortType, 0)
	
	guiSetVisible(GUI.label.banListOutdated, false)
end)

addEventHandler("onClientGUIClick", resourceRoot, function()
    if (source == GUI.button.close) then
		guiSetVisible(GUI.window.bans, false)
		showCursor(false)
		
	-- Страница "Игроки"
    elseif (source == GUI.button.refreshPlayers) or (source == GUI.checkbox.hideColorCodes) or (source == GUI.checkbox.sortByDistance) then
		refreshPlayersList()
		
    elseif (source == GUI.button.choosePlayer) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.players)
		if (selected ~= -1) then
			local account = guiGridListGetItemText(GUI.gridlist.players, selected, 2)
			guiSetText(GUI.edit.banLogin, account)
			triggerServerEvent("findSerial", resourceRoot, account)
		else
			outputChatBox("Не выбран игрок!", 255,0,0)
		end
		
	elseif (source == GUI.button.banFindSerial) then
		local accName = guiGetText(GUI.edit.banLogin)
		triggerServerEvent("findSerial", resourceRoot, accName)
		
	elseif (source == GUI.button.intoNickloginLogin) then
		local accName = guiGetText(GUI.edit.banLogin)
		exports.nicklogin:searchInNicklogin("login", accName)
		
	elseif (source == GUI.button.intoNickloginSerial) then
		local serial = guiGetText(GUI.edit.banSerial)
		exports.nicklogin:searchInNicklogin("serial", serial)
		
	elseif (source == GUI.button.ban1Day) then
		guiComboBoxSetSelected(GUI.combobox.banPeriod, 2)
		guiSetText(GUI.edit.banTime, "1")
		
	elseif (source == GUI.button.ban3Days) then
		guiComboBoxSetSelected(GUI.combobox.banPeriod, 2)
		guiSetText(GUI.edit.banTime, "3")
		
	elseif (source == GUI.button.ban1Week) then
		guiComboBoxSetSelected(GUI.combobox.banPeriod, 3)
		guiSetText(GUI.edit.banTime, "1")
		
	elseif (source == GUI.button.ban2Weeks) then
		guiComboBoxSetSelected(GUI.combobox.banPeriod, 3)
		guiSetText(GUI.edit.banTime, "2")
		
	elseif (source == GUI.button.ban1Month) then
		guiComboBoxSetSelected(GUI.combobox.banPeriod, 4)
		guiSetText(GUI.edit.banTime, "1")
		
	elseif (source == GUI.button.ban3Months) then
		guiComboBoxSetSelected(GUI.combobox.banPeriod, 4)
		guiSetText(GUI.edit.banTime, "3")
		
	elseif (source == GUI.button.banForever) then
		local curTime = getRealTime().timestamp
		local months = math.floor((2147483647 - curTime) / 2592000)
		guiComboBoxSetSelected(GUI.combobox.banPeriod, 4)
		guiSetText(GUI.edit.banTime, months)
		
	elseif (source == GUI.button.ban) then
		banPlayer()
		
	-- Страница "Баны и поиск"
	elseif (source == GUI.button.search) then
		if parseInputParameters() then
			requestBansList()
		end
	
	elseif (source == GUI.button.clearSearch) then
		guiSetText(GUI.edit.searchLogin, "")
		guiSetText(GUI.edit.searchAdmin, "")
		guiSetText(GUI.edit.searchReason, "")
		guiSetText(GUI.edit.searchStartLeft, "")
		guiSetText(GUI.edit.searchStartRight, "")
		guiSetText(GUI.edit.searchEndLeft, "")
		guiSetText(GUI.edit.searchEndRight, "")
		guiComboBoxSetSelected(GUI.combobox.sortType, 0)
		guiComboBoxSetSelected(GUI.combobox.sortDirection, 0)
		parseInputParameters()
		requestBansList()
	
	elseif (source == GUI.button.refreshBans) then
		requestBansList()
		
	elseif (source == GUI.radiobutton.activeBans) or (source == GUI.radiobutton.oldBans) then
		if (selectedRadioButton ~= source) then
			selectedRadioButton = source
			guiSetText(GUI.edit.page, 1)
			requestBansList()
		end
		
	elseif (source == GUI.button.pagePlus) then
		local page = tonumber(guiGetText(GUI.edit.page)) or 1
		page = math.floor(page) + 1
		if (page > pagesCount) then
			page = pagesCount
		end
		guiSetText(GUI.edit.page, page)
		requestBansList()
		
	elseif (source == GUI.button.pageMinus) then
		local page = tonumber(guiGetText(GUI.edit.page)) or 1
		page = math.floor(page) - 1
		if (page < 1) then
			page = 1
		end
		guiSetText(GUI.edit.page, page)
		requestBansList()
		
	elseif (source == GUI.button.getBanInfo) then
		getBanInfo()
		
	-- Страница "Инфо о бане"
	elseif (source == GUI.button.infoCopyLogin) then
		local text = tostring(guiGetText(GUI.label.infoLogin))
		outputChatBox("Скопировано в буфер обмена: "..text)
		setClipboard(text)
		
	elseif (source == GUI.button.infoCopySerial) then
		local text = tostring(guiGetText(GUI.label.infoSerial))
		outputChatBox("Скопировано в буфер обмена: "..text)
		setClipboard(text)
		
	elseif (source == GUI.button.infoCopyAdmin) then
		local text = tostring(guiGetText(GUI.label.infoAdmin))
		outputChatBox("Скопировано в буфер обмена: "..text)
		setClipboard(text)
		
	elseif (source == GUI.button.infoCopyReason) then
		local text = tostring(guiGetText(GUI.label.infoReason))
		outputChatBox("Скопировано в буфер обмена: "..text)
		setClipboard(text)
		
	elseif (source == GUI.button.infoCopyStart) then
		local text = dateTimeToString(tempBanInfo.banStart, ".")
		outputChatBox("Скопировано в буфер обмена: "..text)
		setClipboard(text)
		
	elseif (source == GUI.button.infoCopyEnd) then
		local text = dateTimeToString(tempBanInfo.banEnd, ".")
		outputChatBox("Скопировано в буфер обмена: "..text)
		setClipboard(text)
		
	elseif (source == GUI.button.infoCopyAll) then	
		copyAllInfo()
		
	elseif (source == GUI.button.unban) then
		unbanFromInfo()
		
    end
end)

addEventHandler("onClientGUIAccepted", resourceRoot, function()
	if (source == GUI.edit.page) then
		local page = tonumber(guiGetText(GUI.edit.page)) or 1
		page = math.floor(page)
		if (page > pagesCount) then
			page = pagesCount
		elseif (page < 1) then
			page = 1
		end
		guiSetText(GUI.edit.page, page)
		requestBansList()
	end
end)

addEventHandler("onClientGUIChanged", resourceRoot, function()
	if (source == GUI.edit.searchPlayers) then
		refreshPlayersList()
	end
end)

local banListOutdated, bansLoaded = false
addEventHandler("onClientGUITabSwitched", resourceRoot, function()
	if (source == GUI.tab.bans) then
		if (not bansLoaded) then
			parseInputParameters()
			requestBansList()
		end
		guiSetVisible(GUI.label.banListOutdated, banListOutdated)
	else
		guiSetVisible(GUI.label.banListOutdated, false)
	end
end)

addEventHandler("onClientGUIDoubleClick", resourceRoot, function()
	if (source == GUI.gridlist.bans) then
		getBanInfo()
	end
end)


-- ==========     Управление списком банов     ==========
local currentFilter
function parseInputParameters()
	local dateConvertList = {
		{element = GUI.edit.searchStartLeft, filterName = "startLeft", errorString = "левом поле даты начала бана"},
		{element = GUI.edit.searchStartRight, filterName = "startRight", errorString = "правом поле даты начала бана"},
		{element = GUI.edit.searchEndLeft, filterName = "endLeft", errorString = "левом поле даты окончания бана"},
		{element = GUI.edit.searchEndRight, filterName = "endRight", errorString = "правом поле даты окончания бана"},
	}
	for _, control in ipairs(dateConvertList) do
		local text = guiGetText(control.element)
		if (text ~= "") then
			local y, m, d = convertStringToYMD(text)
			if (y) then
				dateConvertList[control.filterName] = {y=y, m=m, d=d}
			else
				outputChatBox("Неверный формат даты в "..control.errorString)
				return false
			end
		end
	end
	
	currentFilter = {}
	local login = guiGetText(GUI.edit.searchLogin)
	if (login ~= "") then currentFilter.login = string.trim(login) end
	local admin = guiGetText(GUI.edit.searchAdmin)
	if (admin ~= "") then currentFilter.admin = string.trim(admin) end
	local reason = guiGetText(GUI.edit.searchReason)
	if (reason ~= "") then currentFilter.reason = string.trim(reason) end
	
	if (dateConvertList.startLeft) then
		local Date = dateConvertList.startLeft
		currentFilter.startLeft = getTimestamp(Date.y, Date.m, Date.d, 0,0,0)-10800		-- получить начало дня по МСК (-10800 = GMT+3)
	end
	if (dateConvertList.startRight) then
		local Date = dateConvertList.startRight
		currentFilter.startRight = getTimestamp(Date.y, Date.m, Date.d, 23,59,59)-10800 -- получить конец дня по МСК
	end
	if (dateConvertList.endLeft) then
		local Date = dateConvertList.endLeft
		currentFilter.endLeft = getTimestamp(Date.y, Date.m, Date.d, 0,0,0)-10800
	end
	if (dateConvertList.endRight) then
		local Date = dateConvertList.endRight
		currentFilter.endRight = getTimestamp(Date.y, Date.m, Date.d, 23,59,59)-10800
	end
	
	local sortType = guiComboBoxGetSelected(GUI.combobox.sortType)
	currentFilter.sortingCriteria = sortingCriteriaTable[sortType].criteria
	local sortDirection = guiComboBoxGetSelected(GUI.combobox.sortDirection)
	currentFilter.sortingAsc = (sortDirection == 1)
	return true
end

function requestBansList()
	local activeBans = guiRadioButtonGetSelected(GUI.radiobutton.activeBans)
	local page = math.floor(tonumber(guiGetText(GUI.edit.page)) or 0)
	
	antiDOSsend("banList", 1000, "getBansList", resourceRoot, currentFilter, activeBans, page)
end

local activeBansUsed
addEvent("takeBansList", true)
addEventHandler("takeBansList", resourceRoot, function(bans, page, pages, activeBans)
	bansLoaded = true
	activeBansUsed = activeBans
	pagesCount = pages
	banListOutdated = false
	guiSetVisible(GUI.label.banListOutdated, false)
	guiSetText(GUI.label.pages, "из "..pages)
	guiSetText(GUI.edit.page, page)
	
	guiGridListClear(GUI.gridlist.bans)
	for _, row in ipairs(bans) do
		local gridRow = guiGridListAddRow(GUI.gridlist.bans)
		guiGridListSetItemText(GUI.gridlist.bans, gridRow, 1, tostring(row.account or ""), false, false)
		guiGridListSetItemData(GUI.gridlist.bans, gridRow, 1, row.ID)
		guiGridListSetItemText(GUI.gridlist.bans, gridRow, 2, tostring(row.serial or ""), false, false)
		guiGridListSetItemText(GUI.gridlist.bans, gridRow, 3, tostring(row.admin), false, false)
		guiGridListSetItemText(GUI.gridlist.bans, gridRow, 4, tostring(dateTimeToString(row.banStart, "-")), false, true)
		guiGridListSetItemText(GUI.gridlist.bans, gridRow, 5, tostring(timeSegmentToNiceString(row.duration, true)), false, true)
		guiGridListSetItemText(GUI.gridlist.bans, gridRow, 6, tostring(dateTimeToString(row.banEnd, "-")), false, true)
		guiGridListSetItemText(GUI.gridlist.bans, gridRow, 7, tostring(row.reason), false, false)
	end
end)

function getBanInfo()
	local row = guiGridListGetSelectedItem(GUI.gridlist.bans)
	if (row == -1) then
		outputChatBox("Не выбран бан!", 255,0,0)
		return
	end
	local id = guiGridListGetItemData(GUI.gridlist.bans, row, 1)
	triggerServerEvent("getBanInfo", resourceRoot, id, activeBansUsed)
end

-- Конвертация строк в человеко-понятном формате в дату
function convertStringToYMD(dateString)
	local y = tonumber(string.sub(dateString, 1, 4))	-- 20160727
	local m = tonumber(string.sub(dateString, 5, 6))
	local d = tonumber(string.sub(dateString, 7, 8))
	if (not y) or (not m) or (not d) or (y < 1970) or (y > 2037) or (m < 1) or (m > 12) or (d < 1) or (d > 31) then
		y = tonumber(string.sub(dateString, 1, 2))		-- 160727
		m = tonumber(string.sub(dateString, 3, 4))
		d = tonumber(string.sub(dateString, 5, 6))
		if y then y = 2000 + y end
	end
	if (not y) or (not m) or (not d) or (y < 1970) or (y > 2037) or (m < 1) or (m > 12) or (d < 1) or (d > 31) then
		local array = split(dateString, "-")			-- 2016-07-27 и 16-07-27
		y = tonumber(array[1])
		m = tonumber(array[2])
		d = tonumber(array[3])
		if y and (y < 100) then y = 2000 + y end
	end
	if (not y) or (not m) or (not d) or (y < 1970) or (y > 2037) or (m < 1) or (m > 12) or (d < 1) or (d > 31) then
		local array = split(dateString, "/")			-- 2016/07/27 и 16/07/27
		y = tonumber(array[1])
		m = tonumber(array[2])
		d = tonumber(array[3])
		if y and (y < 100) then y = 2000 + y end
	end
	if (not y) or (not m) or (not d) or (y < 1970) or (y > 2037) or (m < 1) or (m > 12) or (d < 1) or (d > 31) then
		local array = split(dateString, ".")			-- 27.07.2016 и 27.07.16
		d = tonumber(array[1])
		m = tonumber(array[2])
		y = tonumber(array[3])
		if y and (y < 100) then y = 2000 + y end
	end
	if (not y) or (not m) or (not d) or (y < 1970) or (y > 2037) or (m < 1) or (m > 12) or (d < 1) or (d > 31) then
		local array = split(dateString, ",")			-- 27,07,2016 и 27,07,16
		d = tonumber(array[1])
		m = tonumber(array[2])
		y = tonumber(array[3])
		if y and (y < 100) then y = 2000 + y end
	end
	if y and m and d and (y > 1969) and (y < 2038) and (m > 0) and (m < 13) and (d > 0) and (d < 32) then
		return y, m, d
	else
		return false
	end
end

addEvent("banListOutdated", true)
addEventHandler("banListOutdated", resourceRoot, function()
	banListOutdated = true
	if (guiGetSelectedTab(GUI.tabpanel.bans) == GUI.tab.bans) then
		guiSetVisible(GUI.label.banListOutdated, true)
	end
end)


-- ==========     Страница информации о бане     ==========
local tempBanInfo
addEvent("takeBanInfo",true)
addEventHandler("takeBanInfo", resourceRoot, function(data, countLogin, countSerial, isActive)
	tempBanInfo = data
	local curTime = getRealTime().timestamp
	local timeToBanEnd = data.banEnd-curTime
	local isMinus = timeToBanEnd < 0
	guiSetEnabled(GUI.tab.info, true)
	guiSetSelectedTab(GUI.tabpanel.bans, GUI.tab.info)
	guiSetText(GUI.label.infoID, data.ID)
	if (data.account) and (data.account ~= "") then
		guiSetText(GUI.label.infoLogin, data.account)
		guiSetEnabled(GUI.button.infoCopyLogin, true)
	else
		guiSetText(GUI.label.infoLogin, "не указан")
		guiSetEnabled(GUI.button.infoCopyLogin, false)
	end
	if (data.serial) and (data.serial ~= "") then
		guiSetText(GUI.label.infoSerial, data.serial)
		guiSetEnabled(GUI.button.infoCopySerial, true)
	else
		guiSetText(GUI.label.infoSerial, "не указан")
		guiSetEnabled(GUI.button.infoCopySerial, false)
	end
	if (data.reason) and (data.reason ~= "") then
		guiSetText(GUI.label.infoReason, data.reason)
		guiSetEnabled(GUI.button.infoCopyReason, true)
	else
		guiSetText(GUI.label.infoReason, "не указана")
		guiSetEnabled(GUI.button.infoCopyReason, false)
	end
	guiSetText(GUI.label.infoAdmin, data.admin)
	guiSetText(GUI.label.infoStart, dateTimeToString(data.banStart)..", "..timeSegmentToNiceString(curTime-data.banStart, true).." назад")
	guiSetText(GUI.label.infoDuration, timeSegmentToNiceString(data.duration, true))
	if not isMinus then
		guiSetText(GUI.label.infoEnd, dateTimeToString(data.banEnd)..", через "..timeSegmentToNiceString(data.banEnd-curTime, true))
	else
		guiSetText(GUI.label.infoEnd, dateTimeToString(data.banEnd)..", "..timeSegmentToNiceString(curTime-data.banEnd, true).." назад")
	end
	guiSetText(GUI.checkbox.unbanLogin, "Разбанить логин (текущих банов этого логина: "..countLogin..")")
	guiSetText(GUI.checkbox.unbanSerial, "Разбанить серийник (текущих банов этого серийника: "..countSerial..")")
	if (isActive) then
		guiSetEnabled(GUI.button.unban, true)
	else
		guiSetEnabled(GUI.button.unban, false)
	end
end)

function copyAllInfo()
	local text = string.format("Логин: %s\nСерийник: %s\nАдмин: %s\nПричина: %s\nНачало бана: %s\nДлительность: %s\nОкончание: %s\nВ настоящее время (%s) бан %s.",
		tostring(guiGetText(GUI.label.infoLogin)),
		tostring(guiGetText(GUI.label.infoSerial)),
		tostring(guiGetText(GUI.label.infoAdmin)),
		tostring(guiGetText(GUI.label.infoReason)),
		tostring(guiGetText(GUI.label.infoStart)),
		tostring(guiGetText(GUI.label.infoDuration)),
		tostring(guiGetText(GUI.label.infoEnd)),
		dateTimeToString(getRealTime().timestamp),
		guiGetEnabled(GUI.button.unban) and "действует" or "неактивен"
	)
	setClipboard(text)
	outputChatBox("Информация скопирована в буфер обмена")
end

function unbanFromInfo()
	local ID = tempBanInfo.ID
	local unbanLogin = guiCheckBoxGetSelected(GUI.checkbox.unbanLogin)
	local unbanSerial = guiCheckBoxGetSelected(GUI.checkbox.unbanSerial)
	if (not unbanLogin) and (not unbanSerial) then
		outputChatBox("А что разбанивать-то? :) Выбери либо логин, либо серийник.")
		return
	end
	if (unbanLogin) and (tempBanInfo.account) and (tempBanInfo.account ~= "") then
		unbanLogin = tempBanInfo.account
	else
		unbanLogin = false
	end
	if (unbanSerial) and (tempBanInfo.serial) and (tempBanInfo.serial ~= "") then
		unbanSerial = tempBanInfo.serial
	else
		unbanSerial = false
	end		
	triggerServerEvent("unbanAccount", resourceRoot, ID, unbanLogin, unbanSerial)
end
















-- ==========     Другое     ==========
function receiveInfoFromNicklogin(login, serial)
	guiSetText(GUI.edit.banLogin, login)
	guiSetText(GUI.edit.banSerial, serial)
	if not guiGetVisible(GUI.window.bans) then
		openBanPanel()
	end
	guiSetSelectedTab(GUI.tabpanel.bans, GUI.tab.players)
	guiBringToFront(GUI.window.bans)
end

function banPlayer()
	local accName = guiGetText(GUI.edit.banLogin)
	local serial = guiGetText(GUI.edit.banSerial):gsub("^%s*(.-)%s*$", "%1")
	local banTime = tonumber( guiGetText(GUI.edit.banTime) )
	local banPeriod = guiComboBoxGetSelected(GUI.combobox.banPeriod)
	local reason = guiGetText(GUI.edit.banReason)
	if (accName == "") and (serial == "") then
		outputChatBox("Не указано, кого банить!", 255,0,0)
	elseif (not banTime) then
		outputChatBox("Срок бана неверный!", 255,0,0)
	elseif (banTime < 0) then
		outputChatBox("Время бана меньше нуля!", 255,0,0)
	elseif (banPeriod == -1) then
		outputChatBox("Не указан период бана!", 255,0,0)
	else
		if (banPeriod == 0) then
			banTime = banTime*60
		elseif (banPeriod == 1) then
			banTime = banTime*3600
		elseif (banPeriod == 2) then
			banTime = banTime*86400
		elseif (banPeriod == 3) then
			banTime = banTime*604800
		elseif (banPeriod == 4) then
			banTime = banTime*2592000
		end
		if (banTime < 0) or (banTime > 2147483647) then
			outputChatBox("Переполнение времени бана. Максимум: ~260 месяцев.", 255,0,0)
			return
		end
		triggerServerEvent("banPlayer", resourceRoot, accName, serial, math.floor(banTime), reason)
	end
end

addEvent("takeSerial",true)
addEventHandler("takeSerial", resourceRoot, function(serial)
	guiSetText(GUI.edit.banSerial, serial)
end)

function openBanPanel()
	if not guiGetVisible(GUI.window.bans) then
		refreshPlayersList()
		guiSetInputMode("no_binds_when_editing")
		guiSetVisible(GUI.window.bans, true)
		showCursor(true)
	else
		guiSetVisible(GUI.window.bans, false)
		showCursor(false)
	end		
end
addEvent("openBanPanel",true)
addEventHandler("openBanPanel", resourceRoot, openBanPanel)


-- ==========     Обновление списка игроков онлайн     ==========
function refreshPlayersList()
	local filter, filterWOutCC = utf8.lower(guiGetText(GUI.edit.searchPlayers))
	if (filter ~= "") then
		filterWOutCC = removeColorCode(filter)
	else
		filter = false
	end
	
	local selected = guiGridListGetSelectedItem(GUI.gridlist.players)
	selected = (selected ~= -1) and selected
	local selectedAccount = (selected) and guiGridListGetItemText(GUI.gridlist.players, selected, 2)
	selectedAccount = (selectedAccount ~= "guest") and selectedAccount
	local selectedPlayer = (selected) and (not selectedAccount) and guiGridListGetItemText(GUI.gridlist.players, selected, 1)
	
	local ccHidden = guiCheckBoxGetSelected(GUI.checkbox.hideColorCodes)
	local sortByDistance = guiCheckBoxGetSelected(GUI.checkbox.sortByDistance)
	local pX, pY, pZ = getCameraMatrix()
	
	local playersTable = {}
	if (filter) then
		for _, player in ipairs(getElementsByType("player")) do
			local name = getPlayerName(player)
			local nameWoutCC = removeColorCode(name)
			local accName = getElementData(player, "accountName") or ""
			local nameLower, nameWoutCCLower, accNameLower = utf8.lower(name), utf8.lower(nameWoutCC), utf8.lower(accName)
			local x, y, z = getElementPosition(player)
			if string.find(nameLower, filter, 1, true) or string.find(nameLower, filterWOutCC, 1, true)
			or string.find(nameWoutCCLower, filter, 1, true) or string.find(nameWoutCCLower, filterWOutCC, 1, true)
			or string.find(accNameLower, filter, 1, true) or string.find(accNameLower, filterWOutCC, 1, true) then
				table.insert(playersTable, {
					name = (ccHidden) and (nameWoutCC) or (name),
					player = player,
					accName = accName,
					pos = {x=x, y=y, z=z},
					dist = getDistanceBetweenPoints3D(pX, pY, pZ, x, y, z),
				})
			end
		end
	else
		for _, player in ipairs(getElementsByType("player")) do
			local x, y, z = getElementPosition(player)
			table.insert(playersTable, {
				name = (ccHidden) and removeColorCode(getPlayerName(player)) or getPlayerName(player),
				player = player,
				accName = getElementData(player, "accountName"),
				pos = {x=x, y=y, z=z},
				dist = getDistanceBetweenPoints3D(pX, pY, pZ, x, y, z),
			})
		end
	end
	
	if (sortByDistance) then
		table.sort(playersTable, function(a, b)
			return a.dist < b.dist		-- Возвращать true когда первый меньше второго
		end)
	end
	
	guiGridListClear(GUI.gridlist.players)
	for _, data in ipairs(playersTable) do
		local row = guiGridListAddRow(GUI.gridlist.players)
		guiGridListSetItemText(GUI.gridlist.players, row, 1, data.name, false, false)
		guiGridListSetItemData(GUI.gridlist.players, row, 1, data.player, false, false)
		guiGridListSetItemText(GUI.gridlist.players, row, 2, data.accName or "", false, false)
		guiGridListSetItemText(GUI.gridlist.players, row, 3, getDirectionInfo(pX, pY, data.pos.x, data.pos.y, data.dist), false, false)
		
		if (selected) then
			if (selectedAccount == data.accName) then
				guiGridListSetSelectedItem(GUI.gridlist.players, row, 1)
				selected = false
			elseif (selectedPlayer == data.name) then
				guiGridListSetSelectedItem(GUI.gridlist.players, row, 1)
				selected = false
			end
		end
	end
end

function getDirectionInfo(x1, y1, x2, y2, distance)
	local angle = -math.deg( math.atan2(x2-x1, y2-y1) )
	angle = (angle < 0) and (angle + 360) or (angle)
	local direction
	if (angle < 22.5) or (angle > 337.5) then
		direction = "С"
	elseif (angle < 67.5) then
		direction = "СЗ"
	elseif (angle < 112.5) then
		direction = "З"
	elseif (angle < 157.5) then
		direction = "ЮЗ"
	elseif (angle < 202.5) then
		direction = "Ю"
	elseif (angle < 247.5) then
		direction = "ЮВ"
	elseif (angle < 292.5) then
		direction = "В"
	else
		direction = "СВ"
	end
	return string.format("%iм. %s", distance, direction)
end


-- ==========     Вспомогательные функции     ==========
-- Удаление цветового кода
function removeColorCode(text)
	return text:gsub("#%x%x%x%x%x%x", "")
end

-- Обрезка пробелов в начале и конце
function string.trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end
