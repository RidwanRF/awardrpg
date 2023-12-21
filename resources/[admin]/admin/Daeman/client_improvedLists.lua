
-- Таблица разбиения транспорта на группы
local vehicleList = {
	{
		name = "4-door cars",
		models = {400, 404, 405, 409, 418, 420, 421, 426, 438, 445, 458, 466, 467, 470, 479, 490, 492, 507,
			516, 529, 540, 546, 547, 550, 551, 560, 561, 566, 567, 579, 580, 585, 596, 597, 598, 604,
		},
	},
	{
		name = "2-door cars",
		models = {401, 402, 410, 411, 412, 415, 419, 422, 424, 429, 434, 436, 439, 442, 444, 451, 457, 474,
			475, 477, 478, 480, 489, 491, 494, 495, 496, 500, 502, 503, 504, 505, 506, 517, 518, 526,
			527, 533, 534, 535, 536, 541, 542, 543, 545, 549, 554, 555, 556, 557, 558, 559, 562, 565,
			575, 576, 587, 589, 599, 600, 602, 603, 605,
		},
	},
	{
		name = "Trucks & buses",
		models = {403, 407, 408, 413, 414, 416, 423, 427, 428, 431, 433, 437, 440, 443, 455, 456, 459, 482,
			483, 498, 499, 508, 514, 515, 524, 525, 528, 544, 552, 573, 578, 582, 588, 601, 609,
		},
	},
	{
		name = "Bikes",
		models = {448, 461, 462, 463, 468, 471, 521, 522, 523, 581, 586},
	},
	{
		name = "Boats",
		models = {430, 446, 452, 453, 454, 472, 473, 484, 493, 595},
	},
	{
		name = "Helicopters",
		models = {417, 425, 447, 469, 487, 488, 497, 548, 563},
	},
}

-- Таблица разбиения оружия на группы по слотам
local weaponList = {
	{	-- Тяжелое оружие
		name = "Heavy Weapons",
		slots = {[3] = true, [5] = true, [6] = true, [7] = true},
	},
	{	-- Легкое оружие
		name = "Light Weapons",
		slots = {[2] = true, [4] = true},
	},
	{	-- Холодное оружие
		name = "Melee",
		slots = {[0] = true, [1] = true, [10] = true},
	},
	{	-- Специальное
		name = "Special",
		slots = {[9] = true, [11] = true, [12] = true},
	},
	{	-- Метательное
		name = "Projectiles",
		slots = {[8] = true},
	},
}

local GUI = {
    gridlist = {},
    window = {},
    button = {},
    edit = {},
    tab = {},
    tabpanel = {},
}
local guiCreated = false
-- ==========     Создание гуи     ==========
local vehicleGUIOpen = false
local weaponGUIOpen = false
function createAdditionalGUI(mainWindow, tabPanel, tab, vehButton, playersGridList, weaponButton)
	-- Сохранение ссылок
	GUI.window.main = mainWindow
	GUI.tabpanel.main = tabPanel
	GUI.tab.players = tab
	GUI.button.adminGiveVehicle = vehButton
	GUI.gridlist.players = playersGridList
	GUI.button.adminGiveWeapon = weaponButton
	
	-- Гуи транспорта
	local x, y = guiGetPosition(GUI.window.main, false)
	local width, _ = guiGetSize(GUI.window.main, false)
	GUI.window.vehList = guiCreateWindow(x+width, y, 310, 520, "Vehicle list", false)
	guiWindowSetSizable(GUI.window.vehList, false)
	GUI.edit.vehSearch = guiCreateEdit(10, 25, 240, 25, "", false, GUI.window.vehList)
	GUI.button.spawnVehicle = guiCreateButton(250, 25, 50, 25, "Spawn", false, GUI.window.vehList)
	GUI.gridlist.vehicle = guiCreateGridList(10, 50, 290, 435, false, GUI.window.vehList)
	guiGridListSetSortingEnabled(GUI.gridlist.vehicle, false)
	guiGridListAddColumn(GUI.gridlist.vehicle, "ID", 0.15)
	guiGridListAddColumn(GUI.gridlist.vehicle, "SA name", 0.25)
	guiGridListAddColumn(GUI.gridlist.vehicle, "Mod name", 0.50)
	GUI.button.closeVehicle = guiCreateButton(255, 485, 45, 25, "Close", false, GUI.window.vehList)
	
	-- Гуи оружия
	GUI.window.weaponList = guiCreateWindow(x+width, y, 210, 520, "Weapon list", false)
	guiWindowSetSizable(GUI.window.weaponList, false)
	GUI.edit.weaponSearch = guiCreateEdit(10, 25, 140, 25, "", false, GUI.window.weaponList)
	GUI.button.giveWeapon = guiCreateButton(150, 25, 50, 25, "Give", false, GUI.window.weaponList)
	GUI.gridlist.weapon = guiCreateGridList(10, 50, 190, 435, false, GUI.window.weaponList)
	guiGridListSetSortingEnabled(GUI.gridlist.weapon, false)
	guiGridListAddColumn(GUI.gridlist.weapon, "ID", 0.18)
	guiGridListAddColumn(GUI.gridlist.weapon, "Name", 0.67)
	GUI.button.closeWeapon = guiCreateButton(155, 485, 45, 25, "Close", false, GUI.window.weaponList)
	
	-- Прочее
	createEventHandlers()
	guiSetVisible(GUI.window.vehList, false)
	guiSetVisible(GUI.window.weaponList, false)
	fillVehicleTable()
	guiCreated = true
end

-- ==========     Обработка событий гуи     ==========
function createEventHandlers()
addEventHandler("onClientGUIClick", resourceRoot, function()
	if (source == GUI.button.adminGiveVehicle) or (source == GUI.button.closeVehicle) then
		vehicleGUIOpen = not vehicleGUIOpen
		guiSetVisible(GUI.window.vehList, vehicleGUIOpen)
		if (vehicleGUIOpen) then
			refreshGUIVehicleList()
			weaponGUIOpen = false
			guiSetVisible(GUI.window.weaponList, false)
		end
	elseif (source == GUI.edit.vehSearch) then
		guiSetText(GUI.edit.vehSearch, "")
	elseif (source == GUI.button.spawnVehicle) then
		spawnSelectedCar()
		
	elseif (source == GUI.button.adminGiveWeapon) or (source == GUI.button.closeWeapon) then
		weaponGUIOpen = not weaponGUIOpen
		guiSetVisible(GUI.window.weaponList, weaponGUIOpen)
		if (weaponGUIOpen) then
			refreshGUIWeaponList()
			vehicleGUIOpen = false
			guiSetVisible(GUI.window.vehList, false)
		end
	elseif (source == GUI.edit.weaponSearch) then
		guiSetText(GUI.edit.weaponSearch, "")
	elseif (source == GUI.button.giveWeapon) then
		giveSelectedWeapon()
	end
end)

addEventHandler("onClientGUIDoubleClick", resourceRoot, function()
	if (source == GUI.gridlist.vehicle) then
		spawnSelectedCar()
	elseif (source == GUI.gridlist.weapon) then
		giveSelectedWeapon()
	end
end)

addEventHandler("onClientGUIAccepted", resourceRoot, function()
	if (source == GUI.edit.vehSearch) then
		spawnSelectedCar()
	elseif (source == GUI.edit.weaponSearch) then
		giveSelectedWeapon()
	end
end)

addEventHandler("onClientGUIChanged", resourceRoot, function()
	if (source == GUI.edit.vehSearch) then
		refreshGUIVehicleList()
	elseif (source == GUI.edit.weaponSearch) then
		refreshGUIWeaponList()
	end
end)

addEventHandler("onClientGUITabSwitched", resourceRoot, function()
	if (source == GUI.tab.players) then
		guiSetVisible(GUI.window.vehList, vehicleGUIOpen)
		guiSetVisible(GUI.window.weaponList, weaponGUIOpen)
	else
		guiSetVisible(GUI.window.vehList, false)
		guiSetVisible(GUI.window.weaponList, false)
	end
end)

addEventHandler("onClientGUIMove", resourceRoot, function()
	if (source == GUI.window.main) then
		local x, y = guiGetPosition(GUI.window.main, false)
		local width, _ = guiGetSize(GUI.window.main, false)
		
		local oldX, oldY = guiGetPosition(GUI.window.vehList, false)
		x, y = math.floor(x + width), math.floor(y)
		oldX, oldY = math.floor(oldX), math.floor(oldY)
		if (x ~= oldX) or (y ~= oldY) then
			guiSetPosition(GUI.window.vehList, x, y, false)
		end
		
		oldX, oldY = guiGetPosition(GUI.window.weaponList, false)
		oldX, oldY = math.floor(oldX), math.floor(oldY)
		if (x ~= oldX) or (y ~= oldY) then
			guiSetPosition(GUI.window.weaponList, x, y, false)
		end
		
	elseif (source == GUI.window.vehList) then
		local x, y = guiGetPosition(GUI.window.vehList, false)
		local width, _ = guiGetSize(GUI.window.main, false)
		local oldX, oldY = guiGetPosition(GUI.window.main, false)
		
		x, y = math.floor(x - width), math.floor(y)
		oldX, oldY = math.floor(oldX), math.floor(oldY)
		if (x ~= oldX) or (y ~= oldY) then
			guiSetPosition(GUI.window.main, x, y, false)
		end
	
	elseif (source == GUI.window.weaponList) then
		local x, y = guiGetPosition(GUI.window.weaponList, false)
		local width, _ = guiGetSize(GUI.window.main, false)
		local oldX, oldY = guiGetPosition(GUI.window.main, false)
		
		x, y = math.floor(x - width), math.floor(y)
		oldX, oldY = math.floor(oldX), math.floor(oldY)
		if (x ~= oldX) or (y ~= oldY) then
			guiSetPosition(GUI.window.main, x, y, false)
		end
		
	end
end)

end

function onClientGUIOpen()
	if (guiGetSelectedTab(GUI.tabpanel.main) == GUI.tab.players) then
		guiSetVisible(GUI.window.vehList, vehicleGUIOpen)
		guiSetVisible(GUI.window.weaponList, weaponGUIOpen)
	end
end

function onClientGUIClose()
	guiSetVisible(GUI.window.vehList, false)
	guiSetVisible(GUI.window.weaponList, false)
end


-- ==========     Работа с оружием     ==========
-- Выбирает и выдает оружие
function giveSelectedWeapon()
	local selectedWeapon = guiGridListGetSelectedItem(GUI.gridlist.weapon)
	if (selectedWeapon == -1) then
		aMessageBox("error", "No weapon selected!")
		return
	end
	
	local selectedPlayer = guiGridListGetSelectedItem(GUI.gridlist.players)
	if (selectedPlayer == -1) then
		aMessageBox("error", "No player selected!")
		return
	end
	local player = getPlayerFromName(guiGridListGetItemPlayerName(GUI.gridlist.players, selectedPlayer, 1))
	if (not player) then
		aMessageBox("error", "No player selected!")
		return
	end
	
	selectedWeapon = guiGridListGetItemData(GUI.gridlist.weapon, selectedWeapon, 1)
	if isResourceRunning("inventory_system") then
		local itemName = exports.inventory_system:getWeaponClassNameFromId(selectedWeapon)
		if (itemName) then
			local itemClass = exports.inventory_system:getItemClass(itemName)
			if (itemClass.ammo ~= itemName) then
				triggerServerEvent("adminGiveItem", resourceRoot, player, itemName, 1, true, true)
				triggerServerEvent("adminGiveItem", resourceRoot, player, itemClass.ammo, aCurrentAmmo, true, false)
			else
				triggerServerEvent("adminGiveItem", resourceRoot, player, itemName, aCurrentAmmo, true, false)
			end
			return
		end
	end
	triggerServerEvent("aPlayer", localPlayer, player, "giveweapon", selectedWeapon, aCurrentAmmo)
end

-- Заполнение списка оружия
function refreshGUIWeaponList()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.weapon)
	selected = (selected ~= -1) and guiGridListGetItemData(GUI.gridlist.weapon, selected, 1) or false
	
	guiGridListClear(GUI.gridlist.weapon)
	local filter = guiGetText(GUI.edit.weaponSearch)
	filter = (filter ~= "") and utf8.lower(filter) or false
	for _, group in ipairs(weaponList) do
		local groupRow = guiGridListAddRow(GUI.gridlist.weapon)
		guiGridListSetItemText(GUI.gridlist.weapon, groupRow, 2, group.name, true, false)
		local groupEmpty = true
		for _, weapData in ipairs(group.weapons) do
			if weaponMatchesFilter(weapData, filter) then
				local row = guiGridListAddRow(GUI.gridlist.weapon, tostring(weapData.id), tostring(weapData.name))
				guiGridListSetItemData(GUI.gridlist.weapon, row, 1, weapData.id)
				if (selected == weapData.id) then
					guiGridListSetSelectedItem(GUI.gridlist.weapon, row, 1)
				end
				groupEmpty = false
			end
		end
		if (groupEmpty) then
			guiGridListRemoveRow(GUI.gridlist.weapon, groupRow)
		end
	end
	if (guiGridListGetSelectedItem(GUI.gridlist.weapon) == -1) then
		guiGridListSetSelectedItem(GUI.gridlist.weapon, 1, 1)
	end
end

function weaponMatchesFilter(data, filter)
	if (filter) then
		return utf8.find(data.id, filter) or utf8.find(data.nameLower, filter)
	else
		return true
	end
end

-- Подготовка списка оружия
local function fillWeaponTable()
	for _, group in ipairs(weaponList) do group.weapons = {} end
	local restricted = {[19]=true,[20]=true,[21]=true,}
	for weaponID = 0, 46 do
		if (not restricted[weaponID]) then
			local weaponSlot = getSlotFromWeapon(weaponID)
			for _, group in ipairs(weaponList) do
				if (group.slots[weaponSlot]) then
					local name = getWeaponNameFromID(weaponID)
					table.insert(group.weapons, {id = weaponID, name = name, nameLower = utf8.lower(name)})
				end
			end
		end
	end
end
fillWeaponTable()


-- ==========     Работа с машинами     ==========
-- Выбирает и спавнит машину
function spawnSelectedCar()
	local selectedVehicle = guiGridListGetSelectedItem(GUI.gridlist.vehicle)
	if (selectedVehicle == -1) then
		aMessageBox("error", "No vehicle selected!")
		return
	end
	
	local selectedPlayer = guiGridListGetSelectedItem(GUI.gridlist.players)
	if (selectedPlayer == -1) then
		aMessageBox("error", "No player selected!")
		return
	end
	local player = getPlayerFromName(guiGridListGetItemPlayerName(GUI.gridlist.players, selectedPlayer, 1))
	if (not player) then
		aMessageBox("error", "No player selected!")
		return
	end
	
	selectedVehicle = guiGridListGetItemData(GUI.gridlist.vehicle, selectedVehicle, 1)
	triggerServerEvent("aPlayer", localPlayer, player, "givevehicle", selectedVehicle)
end

-- Заполнение списка автомобилей
function refreshGUIVehicleList()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.vehicle)
	selected = (selected ~= -1) and guiGridListGetItemData(GUI.gridlist.vehicle, selected, 1) or false
	
	guiGridListClear(GUI.gridlist.vehicle)
	local filter = guiGetText(GUI.edit.vehSearch)
	filter = (filter ~= "") and utf8.lower(filter) or false
	for _, group in ipairs(vehicleList) do
		local groupRow = guiGridListAddRow(GUI.gridlist.vehicle)
		guiGridListSetItemText(GUI.gridlist.vehicle, groupRow, 2, group.name, true, false)
		local groupEmpty = true
		for _, vehData in ipairs(group.vehicles) do
			if vehicleMatchesFilter(vehData, filter) then
				local row = guiGridListAddRow(GUI.gridlist.vehicle, tostring(vehData.model), tostring(vehData.name), tostring(vehData.modName))
				guiGridListSetItemData(GUI.gridlist.vehicle, row, 1, vehData.model)
				if (selected == vehData.model) then
					guiGridListSetSelectedItem(GUI.gridlist.vehicle, row, 1)
				end
				groupEmpty = false
			end
		end
		if (groupEmpty) then
			guiGridListRemoveRow(GUI.gridlist.vehicle, groupRow)
		end
	end
	if (guiGridListGetSelectedItem(GUI.gridlist.vehicle) == -1) then
		guiGridListSetSelectedItem(GUI.gridlist.vehicle, 1, 1)
	end
end

function vehicleMatchesFilter(data, filter)
	if (filter) then
		return utf8.find(data.model, filter) or utf8.find(data.modNameLower, filter) or utf8.find(data.nameLower, filter)
	else
		return true
	end
end

-- Подготовка списка автомобилей
function fillVehicleTable()
	local carSystRun = isResourceRunning("car_system")
	local usedVehicles = {}
	for _, group in ipairs(vehicleList) do
		group.vehicles = {}
		for _, model in ipairs(group.models) do
			usedVehicles[model] = true
			local modName = carSystRun and exports.car_system:getVehicleModName(model) or ""
			local name = getVehicleNameFromModel(model)
			modName = (modName ~= name) and (modName) or ""
			table.insert(group.vehicles, {model = model, modName = modName, name = name, modNameLower = utf8.lower(modName), nameLower = utf8.lower(name)})
		end
	end
	table.insert(vehicleList, {name = "Other", vehicles = {}, models = {}})	-- Будет добавлять пустую таблицу при каждом перезапуске карсистема, но это не критично
	local groupID = #vehicleList
	for model = 400, 609 do
		if (not usedVehicles[model]) then
			local name = getVehicleNameFromModel(model)
			if (name) and (name ~= "") then
				local modName = carSystRun and exports.car_system:getVehicleModName(model) or ""
				modName = (modName ~= name) and (modName) or ""
				table.insert(vehicleList[groupID].vehicles, {model = model, modName = modName, name = name, modNameLower = utf8.lower(modName), nameLower = utf8.lower(name)})
				table.insert(vehicleList[groupID].models, model)
			end
		end
	end
end
addEventHandler("onClientResourceStart", root, function(res)
	if (getResourceName(res) == "car_system") and (guiCreated) then
		fillVehicleTable()
		refreshGUIVehicleList()
	end
end)


--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end
