local enterMarker = createMarker(1717.75, -1130.3, 23, "cylinder", 2.5, 127, 127, 127, 70)
local blip = createBlip(1717.75, -1130.3, 23, 38)
setBlipVisibleDistance(blip, 500)
-- local exitMarker = createMarker(1806.24585, -1144.000366, 84.482811, "cylinder", 4.0, 255, 0, 255, 70)
-- setElementInterior(exitMarker, 1)
-- setElementDimension(exitMarker, 1)

local elevatorMarkers = {
	createMarker(1748.35, -1125.6, -35.517, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6, -31.217, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6, -26.917, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6, -22.617, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6, -18.317, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6, -14.017, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6,  -9.717, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6,  -5.417, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6,  -1.117, "cylinder", 1.5, 60, 60, 60, 120),
	createMarker(1748.35, -1125.6,   3.183, "cylinder", 1.5, 60, 60, 60, 120)
}

function onEnterMarkerHit(hitPlayer, matchingDimension)
	if (hitPlayer == localPlayer) and (not getPedOccupiedVehicle(localPlayer)) and (matchingDimension) then
		local _, _, pZ = getElementPosition(localPlayer)
		local _, _, mZ = getElementPosition(enterMarker)
		if (pZ-mZ < 5) and (pZ > mZ) then
			triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -34, 0, 1, 1)
		end
	end
end
addEventHandler("onClientMarkerHit", enterMarker, onEnterMarkerHit)

local checkingHeightTimer
local preferredHeight

function renewPlayerHeightCheck(height)
	if (height < 10) then
		preferredHeight = height
		if isTimer(checkingHeightTimer) then
			killTimer(checkingHeightTimer)
		end
		checkingHeightTimer = setTimer(checkPlayerHeight, 2000, 1)
	else
		preferredHeight = nil
	end
end
addEvent("startPlayerCheck", true)
addEventHandler("startPlayerCheck", resourceRoot, renewPlayerHeightCheck)

function checkPlayerHeight()
	if (preferredHeight) then
		local _, _, pZ = getElementPosition(localPlayer)
		if (pZ < preferredHeight) then
			triggerServerEvent("fixPlayer", resourceRoot, preferredHeight)
		end
		checkingHeightTimer = setTimer(checkPlayerHeight, 3000, 1)
	end
end

local GUI = {
	window = {},
	label = {},
	button = {}
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- =====     Окно покупки машины     =====
	local screenW, screenH = guiGetScreenSize()
	GUI.window.confirm = guiCreateWindow((screenW-310)/2, (screenH-120)/2, 310, 120, "Покупка б/у авто", false)
	guiSetProperty(GUI.window.confirm, "AlwaysOnTop", "true")
	guiWindowSetSizable(GUI.window.confirm, false)
	GUI.label[1] = guiCreateLabel(21, 33, 266, 36, "Вы желаете приобрести данное ТС?", false, GUI.window.confirm)
	guiLabelSetHorizontalAlign(GUI.label[1], "center", true)
	guiLabelSetColor(GUI.label[1], 38, 122, 216)
	GUI.button.yes = guiCreateButton(17, 73, 129, 36, "Да", false, GUI.window.confirm)
	GUI.button.no = guiCreateButton(161, 73, 129, 36, "Нет", false, GUI.window.confirm)
	
	-- =====     Окно лифта     =====
	GUI.window.elevator = guiCreateWindow((screenW - 190) / 2, (screenH - 275) / 2, 190, 275, "Лифт", false)
	guiWindowSetSizable(GUI.window.elevator, false)
	GUI.button[10] = guiCreateButton(100, 25, 80, 30, "Этаж 10", false, GUI.window.elevator)
	GUI.button[9] = guiCreateButton(100, 65, 80, 30, "Этаж 9", false, GUI.window.elevator)
	GUI.button[8] = guiCreateButton(100, 105, 80, 30, "Этаж 8", false, GUI.window.elevator)
	GUI.button[7] = guiCreateButton(100, 145, 80, 30, "Этаж 7", false, GUI.window.elevator)
	GUI.button[6] = guiCreateButton(100, 185, 80, 30, "Этаж 6", false, GUI.window.elevator)
	GUI.button[5] = guiCreateButton(10, 25, 80, 30, "Этаж 5", false, GUI.window.elevator)
	GUI.button[4] = guiCreateButton(10, 65, 80, 30, "Этаж 4", false, GUI.window.elevator)
	GUI.button[3] = guiCreateButton(10, 105, 80, 30, "Этаж 3", false, GUI.window.elevator)
	GUI.button[2] = guiCreateButton(10, 145, 80, 30, "Этаж 2", false, GUI.window.elevator)
	GUI.button[1] = guiCreateButton(10, 185, 80, 30, "Этаж 1", false, GUI.window.elevator)
	GUI.button.street = guiCreateButton(10, 235, 80, 30, "Улица", false, GUI.window.elevator)
	GUI.button.cancel = guiCreateButton(100, 235, 80, 30, "Отмена", false, GUI.window.elevator)
	guiSetFont(GUI.button.cancel, "default-bold-small")  
	
	-- =====     Вне GUI Editor     =====
	guiSetVisible(GUI.window.confirm, false)
	guiSetVisible(GUI.window.elevator, false)
end) 

addEventHandler("onClientGUIClick", resourceRoot, function()
	if (source == GUI.button.yes) then
		guiSetVisible(GUI.window.confirm, false)
		showCursor(false)
		if getPedOccupiedVehicle(localPlayer) then 
			triggerServerEvent("OnPlayerBuyNewUsedCar", resourceRoot) 
		end
		
	elseif (source == GUI.button.no) then
		guiSetVisible(GUI.window.confirm, false)
		showCursor(false)
		
	end
end)

function onEnterVehicle(theVehicle, seat)
	if (source == localPlayer) then
		if getElementData(theVehicle, "usedauto.ID") then
			guiSetVisible(GUI.window.confirm, true)
			showCursor ( true )
		end
	end
end
addEventHandler("onClientPlayerVehicleEnter", root, onEnterVehicle)

for level, marker in ipairs(elevatorMarkers) do
	setElementInterior(marker, 1)
	setElementDimension(marker, level)
end

function onElevatorMarkerHit(hitPlayer, matchingDimension)
	if (hitPlayer == localPlayer) and (source == elevatorMarkers[getElementDimension(localPlayer)]) and (not getPedOccupiedVehicle(localPlayer)) and (matchingDimension) then
		local _, _, pZ = getElementPosition(localPlayer)
		local _, _, mZ = getElementPosition(source)
		if (pZ - mZ) < 5 and (pZ > mZ) then
			guiSetVisible(GUI.window.elevator, true)
			local dim = getElementDimension(localPlayer)
			for level, button in ipairs(GUI.button) do
				if (level ~= dim) then
					guiSetEnabled(button, true)
				else
					guiSetEnabled(button, false)
				end
			end
			showCursor(true)
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, onElevatorMarkerHit)

addEventHandler("onClientGUIClick", resourceRoot, function()
	if (source == GUI.button.cancel) then
		guiSetVisible(GUI.window.elevator, false)
		showCursor(false)
	elseif (source == GUI.button.street) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1717.75, -1134.2, 25, 270, 0, 0)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = nil
		showCursor(false)
	elseif (source == GUI.button[1]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -33.517, 270, 1, 1)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -35.5
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[2]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -29.217, 270, 1, 2)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -31.2
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[3]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -24.917, 270, 1, 3)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -26.9
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[4]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -20.617, 270, 1, 4)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -22.6
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[5]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -16.317, 270, 1, 5)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -18.3
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[6]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -12.017, 270, 1, 6)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -14.0
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[7]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -7.717, 270, 1, 7)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -9.7
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[8]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, -3.417, 270, 1, 8)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -5.417
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[9]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, 0.883, 270, 1, 9)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = -1.117
		-- renewPlayerHeightCheck()
		showCursor(false)
	elseif (source == GUI.button[10]) then
		triggerServerEvent("usedauto.warpPlayer", resourceRoot, 1751.5, -1125.6, 5.183, 270, 1, 10)
		guiSetVisible(GUI.window.elevator, false)
		-- preferredHeight = 3.1
		-- renewPlayerHeightCheck()
		showCursor(false)
	end
end)
































