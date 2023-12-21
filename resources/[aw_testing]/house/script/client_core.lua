
local houseEnterMarkers = {}
local houseExitMarkers = {}
local markersByID = {}
local exitMarkersByID = {}
myAccount = false

GUI = {
	button = {},
	edit = {},
	gridlist = {},
	label = {},
	staticimage = {},
	window = {}
}


-- ==========     СОЗДАНИЕ МАРКЕРОВ ДОМОВ     ==========
function onResourceStart()
	triggerServerEvent("getAllHouses", resourceRoot)
end
addEventHandler("onClientResourceStart", resourceRoot, onResourceStart)

function takeAllHouses(houseData)
	for _, hdata in pairs(houseData) do
		createHouse(hdata)
	end
	refreshMyHouseBlips()
end
addEvent("takeAllHouses", true)
addEventHandler("takeAllHouses", resourceRoot, takeAllHouses)

function createHouse(hdata)
	local enterMarker = createMarker(hdata.enterMrkX, hdata.enterMrkY, hdata.enterMrkZ - 0.3, 'corona', 1.3, 0,153,0, 0)
	setElementData(enterMarker, "houseData", {ID = hdata.ID, cost = hdata.cost, owner = hdata.owner} )
	if (hdata.owner ~= "") then
		setMarkerColor(enterMarker, 255, 51, 36, 0)
	end
	
	local exitMarker = createMarker(hdata.exitMrkX, hdata.exitMrkY, hdata.exitMrkZ - 0.3, 'corona', 1.3, 255,255,255, 0)
	setElementData(exitMarker, "houseData", {ID = hdata.ID, exitPointX = hdata.exitPointX, exitPointY = hdata.exitPointY, exitPointZ = hdata.exitPointZ} )	
	setElementInterior(exitMarker, hdata.int)
	setElementDimension(exitMarker, hdata.dim)
	
	houseEnterMarkers[enterMarker] = true
	houseExitMarkers[exitMarker] = true
	markersByID[hdata.ID] = enterMarker
	exitMarkersByID[hdata.ID] = exitMarker
end
addEvent("createHouse", true)
addEventHandler("createHouse", resourceRoot, createHouse)

function updateHouse(ID, key, newValue)
	if (key == "owner") then
		local markerData = getElementData(markersByID[ID], "houseData")
		local oldOwner = markerData.owner
		markerData.owner = newValue
		setElementData(markersByID[ID], "houseData", markerData)
		if (oldOwner == myAccount) or (newValue == myAccount) then
			refreshMyHouseBlips()
		end
		if (newValue ~= "") then
			setMarkerColor(markersByID[ID], 255, 51, 36, 0)
		else
			setMarkerColor(markersByID[ID], 0,153,0, 0)
		end
	end
end
addEvent("updateHouse", true)
addEventHandler("updateHouse", resourceRoot, updateHouse)

function removeHouse(ID)
	local owner = getElementData(markersByID[ID], "houseData").owner
	if isElement(markersByID[ID]) then destroyElement(markersByID[ID]) end
	if isElement(exitMarkersByID[ID]) then destroyElement(exitMarkersByID[ID]) end
	if (owner == myAccount) then
		refreshMyHouseBlips()
	end
end
addEvent("removeHouse", true)
addEventHandler("removeHouse", resourceRoot, removeHouse)


-- ==========     ВХОД/ВЫХОД ИЗ ДОМА     ==========
function enterMarkerHit(player, matchingDimension)
	if (player == localPlayer) and (houseEnterMarkers[source]) and (not isPedInVehicle(player)) and (matchingDimension) then
		if myAccount then
			local ID = getElementData(source, "houseData").ID
			triggerServerEvent("givePlayerPanel", resourceRoot, ID)
		else
			outputChatBad("Авторизуйтесь, пожалуйста!")
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, enterMarkerHit)

function enterMarkerLeave(player)
	if (player == localPlayer) then
		closeAllWindows()
	end
end
addEventHandler("onClientMarkerLeave", resourceRoot, enterMarkerLeave)

function exitMarkerHit(player, matchingDimension)
	if (player == localPlayer) and (houseExitMarkers[source]) and (not isPedInVehicle(player)) and (matchingDimension) then
		local data = getElementData(source, "houseData")
		triggerServerEvent("exitHouse", resourceRoot, data)
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, exitMarkerHit)



-- ==========     ПОЛУЧЕНИЕ АККАУНТА     ==========
triggerServerEvent("getMyAccount", resourceRoot)

function takeMyAccount(accName)
	myAccount = accName
	refreshMyHouseBlips()
end
addEvent("takeAccount", true)
addEventHandler("takeAccount", resourceRoot, takeMyAccount)


-- ==========     МЕЛКИЕ ФУНКЦИИ     ==========
function outputChatOK(text)
	outputChatBox("[Домоуправление] #33FF24"..text, 56,120,172, true)
end

function outputChatBad(text)
	outputChatBox("[Домоуправление] #FF3324"..text, 56,120,172, true)
end

function playConfirm()
	playSound("sounds/click_confirm.wav")
end
addEvent("playConfirm", true)
addEventHandler("playConfirm", resourceRoot, playConfirm)

function getMyHouses()
	local myHouses = {}
	for i, blip in pairs(myHouseBlips) do
		local x,y,z = getElementPosition(blip)
		table.insert(myHouses, {x=x,y=y,z=z})
	end
	return myHouses
end

function getAllHouseMarkers()
	local newTable = {}
	for marker, _ in pairs(houseEnterMarkers) do
		if isElement(marker) then
			table.insert(newTable, marker)
		end
	end
	return newTable
end

-- ==========     Разбивка числа на части     ==========
function explodeNumber(number)
    number = tostring(number)
    local k
    repeat
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
    until (k==0)    -- true - выход из цикла
    return number
end
