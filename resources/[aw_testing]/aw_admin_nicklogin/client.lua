
local settingsFile = "settings.json"
local minWindowSize = {x = 635, y = 480}
local dotsCount = 5
local columnWidth = {0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2}
local bottomEditboxes = {"nick", "login", "serial", "date", "IP", "actions", "action", "lastColorNick"}
local gridlistColumns = {"Ник (без цвета)", "Логин", "Серийник", "Дата/время (МСК)", "IP", "Использований", "Посл. действие", "Посл. ник с цветом"}
local columnNumber = {nick = 1, login = 2, serial = 3, date = 4, IP = 5, actions = 6, action = 7, lastColorNick = 8}

local GUI = {
    checkbox = {}, edit = {}, window = {},
    radiobutton = {}, button = {}, label = {},
    scrollpane = {}, gridlist = {},
	staticimage = {
		dot = {},
	},
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenW, screenH = guiGetScreenSize()
	GUI.window.main = guiCreateWindow((screenW-minWindowSize.x)/2, (screenH-minWindowSize.y)/2, minWindowSize.x, minWindowSize.y, "Никлогин", false)
	
	GUI.label[1] = guiCreateLabel(10, 30, 40, 15, "Поиск:", false, GUI.window.main)
	GUI.edit.search = guiCreateEdit(60, 25, 260, 25, "", false, GUI.window.main)
	GUI.button.search = guiCreateButton(330, 25, 105, 25, "Искать", false, GUI.window.main)
	
	for i = 1, dotsCount do
		GUI.staticimage.dot[i] = guiCreateStaticImage(444 + (i-1)*21, 29, 16, 16, "dot.png", false, GUI.window.main)
		guiSetVisible(GUI.staticimage.dot[i], false)
	end
	GUI.label.limit = guiCreateLabel(445, 30, 135, 15, "ЛИМИТ ЗАПИСЕЙ (300)", false, GUI.window.main)
	guiLabelSetColor(GUI.label.limit, 255, 0, 0)
	
	GUI.radiobutton.nick = guiCreateRadioButton(10, 60, 125, 15, "Ник (без цвета)", false, GUI.window.main)
	GUI.label.selectNick = guiCreateLabel(10, 75, 125, 30, "Если в строке есть цвет, он будет убран", false, GUI.window.main)
	guiLabelSetHorizontalAlign(GUI.label.selectNick, "left", true)
	GUI.radiobutton.login = guiCreateRadioButton(145, 60, 55, 15, "Логин", false, GUI.window.main)
	guiRadioButtonSetSelected(GUI.radiobutton.login, true)
	GUI.radiobutton.lastEvent = guiCreateRadioButton(210, 60, 110, 15, "Посл. действие", false, GUI.window.main)
	GUI.radiobutton.serial = guiCreateRadioButton(145, 90, 75, 15, "Серийник", false, GUI.window.main)
	GUI.radiobutton.ip = guiCreateRadioButton(230, 90, 35, 15, "IP", false, GUI.window.main)
	GUI.checkbox.wildcard = guiCreateCheckBox(10, 115, 220, 15, "Показывать неполные совпадения", true, false, GUI.window.main)
	
	GUI.scrollpane.table = guiCreateScrollPane(10, 140, 235, 15, false, GUI.window.main)
	GUI.radiobutton.successful = guiCreateRadioButton(0, 0, 105, 15, "Входы/выходы", false, GUI.scrollpane.table)
	guiRadioButtonSetSelected(GUI.radiobutton.successful, true)
	GUI.radiobutton.actions = guiCreateRadioButton(115, 0, 120, 15, "Прочие действия", false, GUI.scrollpane.table)
	
	GUI.label[7] = guiCreateLabel(330, 60, 100, 15, "Фильтр по дате:", false, GUI.window.main)
	GUI.label[5] = guiCreateLabel(330, 85, 20, 15, "От:", false, GUI.window.main)
	GUI.edit.dateFrom = guiCreateEdit(355, 80, 90, 25, "", false, GUI.window.main)
	guiEditSetMaxLength(GUI.edit.dateFrom, 10)
	GUI.label[6] = guiCreateLabel(330, 115, 20, 15, "До:", false, GUI.window.main)
	GUI.edit.dateTo = guiCreateEdit(355, 110, 90, 25, "", false, GUI.window.main)
	guiEditSetMaxLength(GUI.edit.dateTo, 10)
	GUI.label[4] = guiCreateLabel(450, 60, 135, 45, "Форматы: ДД.ММ,\nГГ-ММ-ДД, ГГГГ-ММ-ДД,\nДД.ММ.ГГ, ДД.ММ.ГГГГ", false, GUI.window.main)
	guiLabelSetHorizontalAlign(GUI.label[4], "left", true)
	GUI.button.clearDate = guiCreateButton(450, 110, 80, 25, "Очистить", false, GUI.window.main)
	
	GUI.gridlist.list = guiCreateGridList(10, 165, 615, 250, false, GUI.window.main)
	guiGridListSetSortingEnabled(GUI.gridlist.list, false)
	for index, columnName in ipairs(gridlistColumns) do
		guiGridListAddColumn(GUI.gridlist.list, columnName,	columnWidth[index])
	end
	GUI.edit.nick = guiCreateEdit(10, 420, 145, 25, "", false, GUI.window.main)
	GUI.edit.login = guiCreateEdit(160, 420, 145, 25, "", false, GUI.window.main)
	GUI.edit.serial = guiCreateEdit(310, 420, 250, 25, "", false, GUI.window.main)
	GUI.edit.date = guiCreateEdit(565, 420, 60, 25, "", false, GUI.window.main)
	GUI.edit.IP = guiCreateEdit(565, 420, 60, 25, "", false, GUI.window.main)
	GUI.edit.actions = guiCreateEdit(565, 420, 60, 25, "", false, GUI.window.main)
	GUI.edit.action = guiCreateEdit(310, 420, 250, 25, "", false, GUI.window.main)
	GUI.edit.lastColorNick = guiCreateEdit(565, 420, 60, 25, "", false, GUI.window.main)
	GUI.button.saveWidth = guiCreateButton(10, 450, 150, 20, "Сохр. ширину столбцов", false, GUI.window.main)    
	GUI.button.sendToBanPanel = guiCreateButton(385, 450, 150, 20, "Передать в банпанель", false, GUI.window.main)  
	GUI.button.copyAll = guiCreateButton(545, 450, 80, 20, "Копир. всё", false, GUI.window.main)    
	
	GUI.button.close = guiCreateButton(585, 25, 40, 35, "X", false, GUI.window.main)
	
	guiSetVisible(GUI.window.main, false)
	guiSetVisible(GUI.label.limit, false)
	guiSetVisible(GUI.button.sendToBanPanel, false)
	
	loadSettings()
	saveSettings()
end)


-- ===================     Действия     ===================
addEventHandler("onClientGUIClick", resourceRoot, function()
	if (source == GUI.button.search) then
		searchButtonAction()
		
	elseif (source == GUI.label.selectNick) then
		guiRadioButtonSetSelected(GUI.radiobutton.nick, true)
		
	elseif (source == GUI.radiobutton.successful) or (source == GUI.radiobutton.actions) then
		if guiRadioButtonGetSelected(GUI.radiobutton.successful) then
			guiGridListSetColumnTitle(GUI.gridlist.list, columnNumber.action, "Посл. действие")
			guiGridListSetColumnTitle(GUI.gridlist.list, columnNumber.actions, "Использований")
		else
			guiGridListSetColumnTitle(GUI.gridlist.list, columnNumber.action, "Действие")
			guiGridListSetColumnTitle(GUI.gridlist.list, columnNumber.actions, "Повторений")
		end
		
	elseif (source == GUI.button.clearDate) then
		guiSetText(GUI.edit.dateFrom, "")
		guiSetText(GUI.edit.dateTo, "")
		
	elseif (source == GUI.button.close) then
		toggleWindow()
		
	elseif (source == GUI.gridlist.list) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.list)
		guiSetText(GUI.edit.nick,	guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.nick) or "")
		guiSetText(GUI.edit.login,	guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.login) or "")
		guiSetText(GUI.edit.serial,	guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.serial) or "")
		guiSetText(GUI.edit.date,	guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.date) or "")
		guiSetText(GUI.edit.IP,		guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.IP) or "")
		guiSetText(GUI.edit.actions, guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.actions) or "")
		guiSetText(GUI.edit.action,	guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.action) or "")
		guiSetText(GUI.edit.lastColorNick, guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.lastColorNick) or "")
		
	elseif (source == GUI.button.saveWidth) then
		columnWidth = getAllColumnsWidth()
		recalculateEditsSize()
		saveSettings()
		
	elseif (source == GUI.button.copyAll) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.list)
		if (selected > -1) then
			local infoCollection = {
				{text = "Ник (без цв. кода): ",		 column = columnNumber.nick},
				{text = "\nПосл. ник с цв. кодом: ", column = columnNumber.lastColorNick},
				{text = "\nЛогин: ", 				 column = columnNumber.login},
				{text = "\nДействие: ",				 column = columnNumber.action},
				{text = "\nДата/время (МСК): ",		 column = columnNumber.date},
				{text = "\nПовторений действия: ",	 column = columnNumber.actions},
				{text = "\nСерийный номер: ",		 column = columnNumber.serial},
				{text = "\nIP: ",					 column = columnNumber.IP},
			}
			local text = ""
			for _, info in ipairs(infoCollection) do
				text = text..info.text..(guiGridListGetItemText(GUI.gridlist.list, selected, info.column) or "")
			end
			setClipboard(text)
			outputChatGood("Текст скопирован.")
		else
			outputChatBad("Не выбрана строка для копирования!")
		end
		
	elseif (source == GUI.button.sendToBanPanel) then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.list)
		if (selected > -1) then
			if isResourceRunning("login") then
				exports.login:receiveInfoFromNicklogin(
					guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.login) or "",	-- Логин
					guiGridListGetItemText(GUI.gridlist.list, selected, columnNumber.serial) or ""	-- Серийник
				)
			end
		else
			outputChatBad("Не выбрана строка для отправки!")
		end
		
	end
end)

function searchButtonAction()
	local dateFrom = guiGetText(GUI.edit.dateFrom)
	local dateTo = guiGetText(GUI.edit.dateTo)
	local timeFrom = getTimeTableFromInput(dateFrom, "minDayTime")
	local timeTo = getTimeTableFromInput(dateTo, "maxDayTime")
	if (not timeFrom) and (dateFrom ~= "") then
		outputChatBad("Ошибка разбора фильтра по дате (поле \"от\")")
		return
	end
	if (not timeTo) and (dateTo ~= "") then
		outputChatBad("Ошибка разбора фильтра по дате (поле \"до\")")
		return
	end
	
	local params = {
		searchType = (
			guiRadioButtonGetSelected(GUI.radiobutton.nick) and "nick" or
			guiRadioButtonGetSelected(GUI.radiobutton.login) and "login" or
			guiRadioButtonGetSelected(GUI.radiobutton.lastEvent) and "lastEvent" or
			guiRadioButtonGetSelected(GUI.radiobutton.serial) and "serial" or
			guiRadioButtonGetSelected(GUI.radiobutton.ip) and "ip"
		),
		
		wildcard = guiCheckBoxGetSelected(GUI.checkbox.wildcard),
		
		Table = guiRadioButtonGetSelected(GUI.radiobutton.successful) and "successful" or "actions",
		
		timeFrom = timeFrom,
		timeTo = timeTo,
	}
	
	local text = guiGetText(GUI.edit.search)
	if (params.searchType == "nick") then
		text = text:gsub("#%x%x%x%x%x%x", "")
	end
	startDots()
	triggerServerEvent("getList", resourceRoot, text, params)
end

-- Преобразование введенной даты в таблицу
function getTimeTableFromInput(dateString, dayTime)
	if (dateString == "") then return false end
	local timeTable
	
	local usingHyphens = ipairsAll(split(dateString, "-"), tonumber)
	if (#usingHyphens >= 3) then
		usingHyphens = ipairsAll(usingHyphens, math.floor)
		if (usingHyphens[1] < 0) or (usingHyphens[1] > 99 and usingHyphens[1] < 1000) or (usingHyphens[1] > 9999) then return false end
		if (usingHyphens[2] > 12) or (usingHyphens[2] < 1) then return false end
		if (usingHyphens[3] > 31) or (usingHyphens[3] < 1) then return false end
		if (usingHyphens[1] < 100) then
			usingHyphens[1] = usingHyphens[1] + 2000
		end
		timeTable = {year = usingHyphens[1], month = usingHyphens[2], day = usingHyphens[3]}
	else
		local usingDots = ipairsAll(split(dateString, "."), tonumber)
		if (#usingDots >= 3) then
			if (usingDots[1] > 31) or (usingDots[1] < 1) then return false end
			if (usingDots[2] > 12) or (usingDots[2] < 1) then return false end
			if (usingDots[3] < 0) or (usingDots[3] > 99 and usingDots[3] < 1000) or (usingDots[3] > 9999) then return false end
			if (usingDots[3] < 100) then
				usingDots[3] = usingDots[3] + 2000
			end
			timeTable = {day = usingDots[1], month = usingDots[2], year = usingDots[3]}
		elseif (#usingDots == 2) then
			if (usingDots[1] > 31) or (usingDots[1] < 1) then return false end
			if (usingDots[2] > 12) or (usingDots[2] < 1) then return false end
			timeTable = {day = usingDots[1], month = usingDots[2], year = getRealTime().year+1900}
		end
	end
	
	if (not timeTable) then return false end
	if (dayTime == "minDayTime") then
		timeTable.hour = 0
		timeTable.min = 0
		timeTable.sec = 0
		return timeTable
	elseif (dayTime == "maxDayTime") then
		timeTable.hour = 23
		timeTable.min = 59
		timeTable.sec = 59
		return timeTable
	else
		return false
	end
end

-- Применение указанной функции ко всем элементам по ipairs
function ipairsAll(data, func)
	for i = 1, #data do
		data[i] = func(data[i])
	end
	return data
end

-- Получение инфы в таблицу
local gridListData, bannedInList = {}, {}
function catchList(list, hasBanpanelAccess, banned)
	guiGridListClear(GUI.gridlist.list)
	for _, element in ipairs(bottomEditboxes) do
		guiSetText(GUI.edit[element], "")
	end
	gridListData = list
	bannedInList = banned
	fillGridlist()
	if (#list == 300) then
		guiSetVisible(GUI.label.limit, true)
	else
		guiSetVisible(GUI.label.limit, false)
	end
	stopDots()
	guiSetVisible(GUI.button.sendToBanPanel, hasBanpanelAccess)
end
addEvent("catchList", true)
addEventHandler("catchList", resourceRoot, catchList)

function fillGridlist()
	for _, row in ipairs(gridListData) do
		local gridListRow = guiGridListAddRow(GUI.gridlist.list)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.nick, tostring(row.nickShort), false, false)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.login, tostring(row.login), false, false)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.serial, tostring(row.serial), false, false)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.date, tostring(row.date), false, false)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.IP, (row.ip and tostring(row.ip)) or "NULL", false, false)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.actions, tostring(row.hits), false, false)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.action, tostring(row.action or row.reason), false, false)
        guiGridListSetItemText(GUI.gridlist.list, gridListRow, columnNumber.lastColorNick, tostring(row.nick), false, false)
		if (bannedInList[row.login]) and (row.login ~= "guest") then
			guiGridListSetItemColor(GUI.gridlist.list, gridListRow, columnNumber.login, 127, 127, 127)
		end
		if (bannedInList[row.serial]) then
			guiGridListSetItemColor(GUI.gridlist.list, gridListRow, columnNumber.serial, 127, 127, 127)
		end
	end
end

function toggleWindow()
	local state = not guiGetVisible(GUI.window.main)
	guiSetInputMode("no_binds_when_editing")
	guiSetVisible(GUI.window.main, state)
	showCursor(state)
end
addEvent("toggleNickLoginWindow", true)
addEventHandler("toggleNickLoginWindow", resourceRoot, toggleWindow)


-- ===================     Экспортные функции     ===================
function searchInNicklogin(searchType, value)
	if not guiGetVisible(GUI.window.main) then toggleWindow() end
	guiBringToFront(GUI.window.main)
	if (searchType == "nick") then
		guiRadioButtonSetSelected(GUI.radiobutton.nick, true)
	elseif (searchType == "login") then
		guiRadioButtonSetSelected(GUI.radiobutton.login, true)
	elseif (searchType == "serial") then
		guiRadioButtonSetSelected(GUI.radiobutton.serial, true)
	elseif (searchType == "ip") then
		guiRadioButtonSetSelected(GUI.radiobutton.ip, true)
	end
	guiCheckBoxSetSelected(GUI.checkbox.wildcard, false)
	guiSetText(GUI.edit.search, value)
	
	searchButtonAction()
end


-- ===================     Бегающие точки     ===================
local dotsDelay = 250
local cycleFrom = 3
local dotsPattern = {
	{1},
	{1,2},
	
	{1,2,3},
	{2,3,4},
	{3,4,5},
	{4,5,1},
	{5,1,2},
}
local dotsPhase, dotsTimer

function startDots()
	dotsPhase = 1
	if not isTimer(dotsTimer) then
		dotsTimer = setTimer(cycleDots, dotsDelay, 0)
	end
end

function stopDots()
	if isTimer(dotsTimer) then killTimer(dotsTimer) end
	for i = 1, dotsCount do
		guiSetVisible(GUI.staticimage.dot[i], false)
	end
end

function cycleDots()
	for i = 1, dotsCount do
		guiSetVisible(GUI.staticimage.dot[i], false)
	end
	for _, dot in ipairs(dotsPattern[dotsPhase]) do
		guiSetVisible(GUI.staticimage.dot[dot], true)
	end
	
	dotsPhase = dotsPhase + 1
	if (dotsPhase > #dotsPattern) then
		dotsPhase = cycleFrom
	end
end


-- ===================     Изменение положения элементов при изменении размеров окна     ===================
function recalculateMainGUIElements()
	local window = {}
	window.x, window.y = guiGetSize(GUI.window.main, false)
	if (window.x < minWindowSize.x) and (window.y < minWindowSize.y) then
		guiSetSize(GUI.window.main, minWindowSize.x, minWindowSize.y, false)
		window = minWindowSize
	elseif (window.x < minWindowSize.x) then
		guiSetSize(GUI.window.main, minWindowSize.x, window.y, false)
		window.x = minWindowSize.x
	elseif (window.y < minWindowSize.y) then
		guiSetSize(GUI.window.main, window.x, minWindowSize.y, false)
		window.y = minWindowSize.y
	end
	
	guiSetPosition(GUI.button.close, window.x-50, 25, false)
	guiSetSize(GUI.gridlist.list, window.x-20, window.y-230, false)
	guiSetPosition(GUI.button.saveWidth, 10, window.y-30, false)
	guiSetPosition(GUI.button.copyAll, window.x-90, window.y-30, false)
	guiSetPosition(GUI.button.sendToBanPanel, window.x-250, window.y-30, false)
	
	recalculateEditsSize()
end

function recalculateEditsSize()
	local windowWidth, yPos = guiGetSize(GUI.window.main, false)
	yPos = yPos - 60
	local sum = 0.0
	for index, _ in ipairs(bottomEditboxes) do
		sum = sum + columnWidth[index]
	end
	
	local multiplier = (windowWidth - 20)/sum
	local currentPos = 10
	local elemSize
	for index, element in ipairs(bottomEditboxes) do
		elemSize = math.floor(columnWidth[index]*multiplier)
		guiSetPosition(GUI.edit[element], currentPos, yPos, false)
		guiSetSize(GUI.edit[element], elemSize, 25, false)
		currentPos = currentPos + elemSize
	end
end

function getAllColumnsWidth()
	local width = {}
	for index = 1, guiGridListGetColumnCount(GUI.gridlist.list) do
		width[index] = guiGridListGetColumnWidth(GUI.gridlist.list, index, true)
	end
	return width
end

addEventHandler("onClientGUISize", resourceRoot, function()
	if (source == GUI.window.main) then
		recalculateMainGUIElements()
	end
end)


-- ===================     Сохранение и загрузка настроек     ===================
-- Получение и применение настроек
function loadSettings()
	local data = readJSONFile(settingsFile)
	if (type(data) ~= "table") then data = {} end
	
	if (type(data.columnWidth) == "table") then
		local selected = guiGridListGetSelectedItem(GUI.gridlist.list)
		for index = 1, guiGridListGetColumnCount(GUI.gridlist.list) do
			guiGridListRemoveColumn(GUI.gridlist.list, 1)
		end
		
		columnWidth = {}
		for index, columnName in ipairs(gridlistColumns) do
			columnWidth[index] = tonumber(data.columnWidth[index]) or 0.2
			guiGridListAddColumn(GUI.gridlist.list, columnName, columnWidth[index])
		end
		
		fillGridlist()
		guiGridListSetSelectedItem(GUI.gridlist.list, selected, 1)
	end

	if (type(data.size) == "table") and tonumber(data.size.x) and tonumber(data.size.y) then
		local screenW, screenH = guiGetScreenSize()
		guiSetPosition(GUI.window.main, (screenW-data.size.x)/2, (screenH-data.size.y)/2, false)
		guiSetSize(GUI.window.main, data.size.x, data.size.y, false)
		recalculateMainGUIElements()
	end
end

function readIngameSettings()
	local data = {size={}}
	data.size.x, data.size.y = guiGetSize(GUI.window.main, false)
	data.columnWidth = columnWidth
	return data
end

-- Неизменные функции
function readJSONFile(fileName)
	if fileExists(fileName) then 
		local file = fileOpen(fileName, true)
		if (file) then
			local data = fromJSON(fileRead(file, fileGetSize(file)))
			fileClose(file)
			return data
		end
	end
end
local needsSave, saveTimer
function saveSettings()
	if isTimer(saveTimer) then
		needsSave = true
	else
		needsSave = true
		writeSettingsFile()
		saveTimer = setTimer(writeSettingsFile, 1000, 1)
	end
end
function writeSettingsFile()
	if (needsSave) then
		needsSave = false
		local data = readIngameSettings()
		local file = fileCreate(settingsFile)
		if (file) then
			fileWrite(file, toJSON(data, true))
			fileClose(file)
		end
	end
end


-- ==========     Мелкие функции     ==========
-- Сообщения в чат
function outputChatGood(text)
	outputChatBox("[NICKLOGIN] "..text, 255,255,255, true)
end
function outputChatBad(text)
	outputChatBox("[NICKLOGIN] #FF0000"..text, 255,255,255, true)
end

-- Проверка, что ресурс запущен
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end
