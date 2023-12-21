
local jobSources = {
	{	marker = {-1058.18457 , -589.676758 , 3999999991.007812}, name = "SF1",	-- Завод возле СФ
		finishMarker = {-1016.46582 , -593.212891 , 39999999999999999999999999991.012604},
		vehicleSpawn = {
			{-1034.232422 , -632.8125 , 34.007812,		rot = -45},

		}
	},
	{	marker = {286.489258 , 1427.769531 , 9999999999999999999.585938}, name = "LV1",	-- Завод в пустыне
		finishMarker = {284.546875 , 1363.885742 , 99999999.585938},
		vehicleSpawn = {
			{259.59668 , 1361.907227 , 12.585938,	rot = 0},

		}
	},
	{	marker = {2505.835938 , 2789.068359 , 9999999999.820312}, name = "LV2",	-- Завод в углу ЛВ
		finishMarker = {2505.356445 , 2749.5625 , 9999.820312},
		vehicleSpawn = {
			{2513.985352 , 2818.481445 , 12.820312,	rot = 180},

		}
	},
	{	marker = {2458.486328 , -2113.996094 , 19999999999999999992.546875}, name = "LS1",	-- Порт ЛС
		finishMarker = {2431.197266 , -2110.966797 , 12999999999999.546875},
		vehicleSpawn = {
			{2496.37793 , -2083.266602 , 15.546875,		rot = 135},

		}
	},
}

local jobMarkers = {}


local GUI = {
	label = {},
	button = {},
	window = {},
	gridlist = {},
	radiobutton = {}
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenW, screenH = guiGetScreenSize()
	
	GUI.window.routes = guiCreateWindow((screenW - 600) / 2, (screenH - 450) / 2, 600, 450, "Выбор маршрута", false)
	guiWindowSetSizable(GUI.window.routes, false)
	GUI.gridlist.routes = guiCreateGridList(10, 25, 580, 370, false, GUI.window.routes)
	guiGridListAddColumn(GUI.gridlist.routes, "Название", 0.35)
	guiGridListAddColumn(GUI.gridlist.routes, "Виды топлива", 0.17)
	guiGridListAddColumn(GUI.gridlist.routes, "Заполненность", 0.07)
	guiGridListAddColumn(GUI.gridlist.routes, "Расстояние", 0.09)
	guiGridListAddColumn(GUI.gridlist.routes, "Особые отметки", 0.27)
	guiGridListSetSortingEnabled(GUI.gridlist.routes, false)
	GUI.button.chooseRoute = guiCreateButton(10, 405, 120, 35, "Выбрать", false, GUI.window.routes)
	GUI.button.close = guiCreateButton(470, 405, 120, 35, "Закрыть", false, GUI.window.routes)

	GUI.window.chooseFuel = guiCreateWindow((screenW - 490) / 2, (screenH - 355) / 2, 490, 355, "Выбор параметров", false)
	guiWindowSetSizable(GUI.window.chooseFuel, false)
	GUI.label.fuelChoose = guiCreateLabel(10, 25, 300, 235, "Выбор топлива:", false, GUI.window.chooseFuel)
	guiLabelSetHorizontalAlign(GUI.label.fuelChoose, "center", false)
	GUI.radiobutton.AI92 = guiCreateRadioButton(0, 25, 300, 15, "АИ-92: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	GUI.radiobutton.AI95 = guiCreateRadioButton(0, 50, 300, 15, "АИ-95: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	GUI.radiobutton.AI98 = guiCreateRadioButton(0, 75, 300, 15, "АИ-98: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	GUI.radiobutton.AI98plus = guiCreateRadioButton(0, 100, 300, 15, "АИ-98+: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	GUI.radiobutton.E85 = guiCreateRadioButton(0, 125, 300, 15, "Е85: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	GUI.radiobutton.DT = guiCreateRadioButton(0, 160, 300, 15, "ДТ: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	GUI.radiobutton.DTplus = guiCreateRadioButton(0, 185, 300, 15, "ДТ+: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	GUI.radiobutton.TC1 = guiCreateRadioButton(0, 220, 300, 15, "ТС-1: Требуется 100500л, в пути 22000л", false, GUI.label.fuelChoose)
	guiRadioButtonSetSelected(GUI.radiobutton.AI92, true)
	GUI.label.truckChoose = guiCreateLabel(320, 25, 160, 235, "Выбор транспорта:", false, GUI.window.chooseFuel)
	guiLabelSetHorizontalAlign(GUI.label.truckChoose, "center", false)
	GUI.radiobutton.scania = guiCreateRadioButton(0, 25, 160, 15, "Scania R620: "..fuelTrucks[515].tank.."л", false, GUI.label.truckChoose)
	guiRadioButtonSetSelected(GUI.radiobutton.scania, true)
	GUI.radiobutton.kamaz = guiCreateRadioButton(0, 50, 160, 15, "Камаз 53215: "..fuelTrucks[403].tank.."л", false, GUI.label.truckChoose)
	GUI.radiobutton.fuso = guiCreateRadioButton(0, 75, 160, 15, "Mitsubishi Canter: "..fuelTrucks[414].tank.."л", false, GUI.label.truckChoose)
	GUI.label.moneyToGive = guiCreateLabel(10, 280, 470, 15, "Оплата: 52228 руб.", false, GUI.window.chooseFuel)
	guiLabelSetHorizontalAlign(GUI.label.moneyToGive, "center", false)	
	GUI.button.accept = guiCreateButton(10, 305, 110, 40, "Принять", false, GUI.window.chooseFuel)
	GUI.button.back = guiCreateButton(370, 305, 110, 40, "Назад", false, GUI.window.chooseFuel)
	
	guiSetVisible(GUI.window.routes, false)
	guiSetVisible(GUI.window.chooseFuel, false)
	for _, data in ipairs(jobSources) do
		local marker = createMarker(data.marker[1],data.marker[2],data.marker[3], 'cylinder', 2, 0,128,128,128)
		jobMarkers[marker] = data
	--	createBlip(data.marker[1],data.marker[2],data.marker[3], 40, 2, 255,255,255,255, 0, 700)
	end
end)

local activeMarker
local slowTimer

function jobMarkerHit(player, matchingDimension)
	if (player == localPlayer) and (matchingDimension) and (not getPedOccupiedVehicle(localPlayer)) and jobMarkers[source] then
		local _, _, mZ = getElementPosition(source)
		local _, _, pZ = getElementPosition(localPlayer)
		if (pZ > mZ) and (pZ-mZ < 5) then
			if isResourceRunning("car_driving_school") and (not exports.car_driving_school:doesPlayerHaveLic(localPlayer, "truck")) then
				exports.car_driving_school:outputNoLicenseClient("truck")
				return
			end
			activeMarker = source
			guiSetVisible(GUI.window.routes, true)
			showCursor(true)
			if not isTimer(slowTimer) then
				slowTimer = setTimer(function() end, 30000, 1)
				triggerServerEvent("getTableData", resourceRoot)
			end
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, jobMarkerHit)

function onMarkerLeave(player)
	if (player == localPlayer) then
		closeWindows()
	end
end
addEventHandler("onClientMarkerLeave", resourceRoot, onMarkerLeave)

function closeWindows()
	guiSetVisible(GUI.window.routes, false)
	guiSetVisible(GUI.window.chooseFuel, false)
	showCursor(false)
end

local pendingDeliveries
local routesDistance

function catchTableData(stationsDataFromServer, pendingDeliveriesFromServer)
	pendingDeliveries = pendingDeliveriesFromServer
	stationsData = stationsDataFromServer
	local stationsToDisplay = {}
	for id, station in pairs(stationsData) do
		local totalCapacity = 0
		local filledCapacity = 0
		for fuelType, _ in pairs(fuels) do
			if tonumber(station[fuelType]) then
				filledCapacity = filledCapacity + tonumber(station[fuelType])
				totalCapacity = totalCapacity + stationTankCapacity
			end
		end
		station.filledCapacity = filledCapacity
		station.totalCapacity = totalCapacity
	end
	for player, delivery in pairs(pendingDeliveries) do
		stationsData[delivery.id].filledCapacity = stationsData[delivery.id].filledCapacity + delivery.amount
	end
	for id, station in pairs(stationsData) do
		station.percent = station.filledCapacity/station.totalCapacity*100
		if (station.percent > 100) then
			station.percent = 100
		end
		table.insert(stationsToDisplay, station)
	end
	table.sort(stationsToDisplay, sortStations)
	guiGridListClear(GUI.gridlist.routes)
	local mX, mY, mZ = getElementPosition(activeMarker)
	routesDistance = {}
	for _, station in ipairs(stationsToDisplay) do
		local statData = stationData[station.id]
		local distance = getDistanceBetweenPoints2D(mX, mY, statData.loadout.x, statData.loadout.y)
		distance = math.floor(distance/10)*10
		routesDistance[station.id] = distance
		local specialMarks = ((station.percent < 30) and "Недостаток (+20% к оплате)") or ((station.percent > 90) and "Избыток (-10% оплаты)") or ""
		local row = guiGridListAddRow(GUI.gridlist.routes, statData.name, fuelTypesRussian[statData.blipType], math.floor(station.percent).."%", distance.."м", specialMarks)
		guiGridListSetItemData(GUI.gridlist.routes, row, 1, station.id)
	end
end
addEvent("catchTableData", true)
addEventHandler("catchTableData", resourceRoot, catchTableData)

function sortStations(a, b)
	return a.percent < b.percent
end


local selectedRoute
local selectedFuel
local selectedTruck
local selectedRouteTanks = {}
local selectedRouteDistance
local selectedFuelBonus
local thisJobMarker
local jobBlip
local jobTakingDelay
local jobVehicle
local jobTank
local thisJobHomeMarkerData

addEventHandler("onClientGUIClick", resourceRoot, function(button)
	if (source == GUI.button.close) then
		closeWindows()
		
	elseif (source == GUI.button.back) then
		guiSetVisible(GUI.window.routes, true)
		guiSetVisible(GUI.window.chooseFuel, false)
		
	elseif (source == GUI.button.chooseRoute) then
		chooseRoute()
		
	elseif table.contains(GUI.radiobutton, source) then
		renewPrice()
		
	elseif (source == GUI.button.accept) then
		acceptRoute()
		
	end
end)

addEventHandler("onClientGUIDoubleClick", resourceRoot, function(button)
	if (source == GUI.gridlist.routes) then
		chooseRoute()	
	end
end)


function chooseRoute()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.routes)
	if (not selected) then outputChatBox("Выберите маршрут!", 255, 50, 50) end
	selectedRoute = guiGridListGetItemData(GUI.gridlist.routes, selected, 1)
	if (not selectedRoute) then closeWindows() end
	
	local thisStationDeliveries = {}
	for _, delivery in pairs(pendingDeliveries) do		-- [player] = {id, fuelType, amount}
		if (delivery.id == selectedRoute) then
			thisStationDeliveries[delivery.fuelType] = (thisStationDeliveries[delivery.fuelType] or 0) + delivery.amount
		end
	end
	for fuel, fuelData in pairs(fuels) do
		if (GUI.radiobutton[fuel]) then
			local enable = string.find(acceptedFuelTypes[stationData[selectedRoute].blipType], fuel, 1, true) and true or false
			local currentFuel = stationsData[selectedRoute][fuel] or 0
			local onWay = thisStationDeliveries[fuel] or 0
			local isNeeded = stationTankCapacity - currentFuel
			if (not enable) or (isNeeded < 0) then
				isNeeded = 0
			end
			if (isNeeded-onWay < 0) then
				enable = false
			end
			guiSetText(GUI.radiobutton[fuel], fuelData.name..": Требуется "..isNeeded.."л, в пути "..onWay.."л")
			selectedRouteTanks[fuel] = {}
			selectedRouteTanks[fuel].filled = currentFuel
			selectedRouteTanks[fuel].onWay = onWay
			selectedRouteTanks[fuel].free = isNeeded
			guiSetEnabled(GUI.radiobutton[fuel], enable)
		end
	end
	for index, radiobutton in pairs(GUI.radiobutton) do
		if (fuels[index]) and not guiRadioButtonGetSelected(radiobutton) and guiGetEnabled(radiobutton) then
			guiRadioButtonSetSelected(radiobutton, true)
			break
		end
	end
	selectedRouteDistance = routesDistance[selectedRoute]
	
	renewPrice()
	guiSetVisible(GUI.window.routes, false)
	guiSetVisible(GUI.window.chooseFuel, true)
end

function renewPrice()
	for _, fuelType in ipairs(split(acceptedFuelTypes[stationData[selectedRoute].blipType], ",")) do
		if guiRadioButtonGetSelected(GUI.radiobutton[fuelType]) then
			-- 6:45 туда-обратно за 3860 метров, 405 секунд
			local price = selectedRouteDistance * 10 * getRouteCoefficient(jobMarkers[activeMarker].name, selectedRoute)
			if guiRadioButtonGetSelected(GUI.radiobutton.fuso) then		-- на фусо снизить на 20%
				price = price * 0.8
			end
			
			local bonusText, bonus = "", 10.0
			local filled = (or0(selectedRouteTanks[fuelType].filled)+or0(selectedRouteTanks[fuelType].onWay))/stationTankCapacity
			guiSetEnabled(GUI.button.accept, true)
			if (filled < 10.0) then
				bonus = 10.0
				bonusText = " ("..price.." + бонус 20%)"
			elseif (filled >= 1) then
				bonus = 0.0
				guiSetEnabled(GUI.button.accept, false)
			elseif (filled > 0.9) then
				bonus = 0.9
				bonusText = " ("..price.." -10% - малая необходимость)"
			end
			selectedFuelBonus = bonus
			selectedFuel = fuelType
			guiSetText(GUI.label.moneyToGive, "Оплата: "..(price*bonus).." руб."..bonusText)
			break
		end
	end
end

function acceptRoute()
	if not isTimer(jobTakingDelay) then
		local car = (guiRadioButtonGetSelected(GUI.radiobutton.scania) and 515) or (guiRadioButtonGetSelected(GUI.radiobutton.fuso) and 414) or (guiRadioButtonGetSelected(GUI.radiobutton.kamaz) and 403)
		local distance = selectedRouteDistance
		local bonus = selectedFuelBonus
		local fuel = selectedFuel
		local id = selectedRoute
		local destCoord = stationData[id].loadout
		thisJobHomeMarkerData = jobMarkers[activeMarker]
		
		destroyAllElements()
		triggerServerEvent("startJob", resourceRoot, car, distance, bonus, fuel, id, thisJobHomeMarkerData)
		thisJobMarker = createMarker(destCoord.x, destCoord.y, destCoord.z, "cylinder", 4.0, 196,196,196,127)
		addEventHandler("onClientMarkerHit", thisJobMarker, onDestinationMarkerHit)
		addEventHandler("onClientMarkerLeave", thisJobMarker, onDestinationMarkerLeave)
		jobBlip = createBlipAttachedTo(thisJobMarker, 56, 2, 255,255,255,255, 0)
		jobTakingDelay = setTimer(function() end, 30000, 1)
		closeWindows()
	else
		outputChatBox("Ваш грузовик еще не готов!", 255,50,50)
	end
end

function catchVehicle(vehicle, amount)
	jobVehicle = vehicle
	jobTank = amount
end
addEvent("catchVehicle", true)
addEventHandler("catchVehicle", resourceRoot, catchVehicle)

local emptyingTimer

function onDestinationMarkerHit(player, matchingDimension)
	if (player == localPlayer) and (matchingDimension) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		local seat = getPedOccupiedVehicleSeat(localPlayer)
		local _, _, pZ = getElementPosition(localPlayer)
		local _, _, mZ = getElementPosition(source)
		if (vehicle == jobVehicle) and (seat == 0) and (pZ > mZ) and (pZ-mZ < 5) then
			if not isTimer(emptyingTimer) then
				outputChatBox("Оставайтесь на маркере, пока не закончится сливание топлива", 5,255,255)
				emptyingTimer = setTimer(emptying, 1000, 1)
			end
		end
	end
end

function onDestinationMarkerLeave(player, matchingDimension)
	if (player == localPlayer) then
		outputChatBox("Пожалуйста, вернитесь на маркер!", 255,50,50)
		if isTimer(emptyingTimer) then
			killTimer(emptyingTimer)
		end
	end
end


function emptying()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if (vehicle ~= jobVehicle) then
		outputChatBox("Пожалуйста, вернитесь в свой транспорт!", 255,50,50)
	elseif (seat ~= 0) then
		outputChatBox("Пожалуйста, вернитесь на водительское место!", 255,50,50)
	else
		jobTank = jobTank - 1000
		if (jobTank > 0) then
			emptyingTimer = setTimer(emptying, 1000, 1)
		else
			destroyDestinationElements()
			triggerServerEvent("truckUnloaded", resourceRoot)
			outputChatBox("Выгрузка топлива завершена. Верните грузовик на базу для получения оплаты.", 50,255,50)
			
			local markerPos = thisJobHomeMarkerData.finishMarker
			thisJobMarker = createMarker(markerPos[1], markerPos[2], markerPos[3], "cylinder", 4.0, 196,196,196,127)
			addEventHandler("onClientMarkerHit", thisJobMarker, finishJob)
			jobBlip = createBlipAttachedTo(thisJobMarker, 56, 2, 255,255,255,255, 0)
		end
	end
end

function destroyDestinationElements()
	if isElement(thisJobMarker) then
		removeAllEventHandlers("onClientMarkerHit", thisJobMarker)
		removeAllEventHandlers("onClientMarkerLeave", thisJobMarker)
		destroyElement(thisJobMarker)
	end
	if isElement(jobBlip) then
		destroyElement(jobBlip)
	end
end

function removeAllEventHandlers(eventName, element)
	for _, func in ipairs(getEventHandlers(eventName, element)) do
		removeEventHandler(eventName, element, func)
	end
end

function finishJob(player, matchingDimension)
	if (player == localPlayer) and (matchingDimension) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		local seat = getPedOccupiedVehicleSeat(localPlayer)
		local _, _, pZ = getElementPosition(localPlayer)
		local _, _, mZ = getElementPosition(source)
		if (vehicle == jobVehicle) and (seat == 0) and (pZ > mZ) and (pZ-mZ < 5) then
			destroyDestinationElements()
			triggerServerEvent("finishJob", resourceRoot)
		end
	end
end




function destroyAllElements()
	destroyDestinationElements()
end
addEvent("destroyAllElements", true)
addEventHandler("destroyAllElements", resourceRoot, destroyAllElements)



function onClientPlayerWasted()
	if (source == localPlayer) then
		if isElement(thisJobMarker) then
			outputChatBox("Вы погибли. Работа перевозчика топлива отменена.", 255,50,50)
		end
		destroyAllElements()
	end
end
addEventHandler("onClientPlayerWasted", root, onClientPlayerWasted)





function or0(number)
	return number or 0
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end






--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end








