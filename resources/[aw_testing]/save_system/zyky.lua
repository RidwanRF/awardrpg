
local coordsToOverride = {}

function overrideCoordsSaving(player, x, y, z)
	coordsToOverride[player] = {x = x, y = y, z = z}
end

function cancelCoordsSavingOverride(player)
	coordsToOverride[player] = nil
end
playerGetsIntoModshop = overrideCoordsSaving
playerReturnsFromModshop = cancelCoordsSavingOverride


function playerLogin(_, theCurrentAccount)
	if not isGuestAccount(theCurrentAccount) then
		local accData = getAllAccountData(theCurrentAccount)
		if accData.savedLastPos then
			local position = fromJSON(accData.savedLastPos)
			if (accData.savedSpawnPos) and (accData.savedSpawnPos ~= "") then
				position = fromJSON(accData.savedSpawnPos)
			end
			spawnPlayer(source, position.x, position.y, position.z+1, position.rotZ, accData.savedSkin, position.int, position.dim)
			setPlayerMoney(source, accData.money)
			setTimer(setPedArmor, 500, 1, source, accData.savedArmor)
			for i, weapon in pairs(fromJSON(accData.savedWeapons)) do
				if (weapon.weap ~= 9) then
					giveWeapon(source, weapon.weap, weapon.ammo)
				end
			end
			setPedWeaponSlot(source, 0)
			setCameraTarget(source, source)
			fadeCamera(source, true, 2.0)
		else
			spawn(source, "firstLogin")
		end
		outputDebugString ("[SAVESYSTEM][LOGIN] "..getPlayerName(source).." logged in (acc "..getAccountName(theCurrentAccount)..", money "..getPlayerMoney(source)..", serial "..getPlayerSerial(source)..")")
	end
end
addEventHandler("onPlayerLogin", root, playerLogin)

function playerQuit(quitType)
	local account = getPlayerAccount(source)
	if not isGuestAccount(account) then
		setAccountData(account, "money", getPlayerMoney(source))
		local x,y,z = getElementPosition(source)
		local _,_,rotZ = getElementRotation(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)
		local overridenCoords = coordsToOverride[source]
		if (overridenCoords) then
			x,y,z = overridenCoords.x, overridenCoords.y, overridenCoords.z
			int, dim = 0, 0
		end
		if (int == 0) then	-- Принудительно выставлять 0 дименшен, если не в интерьере
			dim = 0
		end
		setAccountData(account, "savedLastPos", toJSON({x=x, y=y, z=z, rotZ=rotZ, int=int, dim=dim}, true))
		setAccountData(account, "savedSkin", getElementModel(source))
		setAccountData(account, "savedArmor", getPedArmor(source))
		local weapons = {}
		for i=0,12 do
			local weapon = getPedWeapon(source, i)
			if (weapon ~= 0) then
				weapons[i] = {["weap"]=weapon, ["ammo"]=getPedTotalAmmo(source, i) }
			end
		end
		setAccountData(account, "savedWeapons", toJSON(weapons, true))
	end
	outputDebugString ("[SAVESYSTEM][QUIT] "..getPlayerName(source).." left (acc "..getAccountName(account)..", money "..getPlayerMoney(source)..", serial "..getPlayerSerial(source)..")")
	
	if ((quitType == "Timed out") or (quitType == "Kicked") or (quitType == "Banned")) and (getPedOccupiedVehicleSeat(source) == 0) then
		local vehicle = getPedOccupiedVehicle(source)
		if (not vehicle) then return end
		if getElementData(vehicle, "doNotRemoveThisCarOnTimeout") then return end
		
		local vehicleOwner = getElementData(vehicle, "owner")
		if (getAccountName(account) == vehicleOwner) then return end
		
		local chosenOccupant
		for seat, occupant in pairs(getVehicleOccupants(vehicle)) do 
			chosenOccupant = occupant
			break
		end
		if (chosenOccupant) then
			warpPedIntoVehicle(chosenOccupant, vehicle, 0)
			outputChatBox("Водитель этой машины исчез с сервера. Теперь ты новый водитель.", chosenOccupant, 255, 100, 100)
		else
			if isResourceRunning("car_system") then
				exports.car_system:destroyVehicle(vehicle)
			else
				destroyElement(vehicle)
			end
		end
	end
end
addEventHandler("onPlayerQuit", root, playerQuit)

function onLogout(thePreviousAccount, theCurrentAccount)
	cancelEvent()
	setAccountData(thePreviousAccount, "money", getPlayerMoney(source))
	outputDebugString ("[SAVESYSTEM][LOGOUT] "..getPlayerName(source).." (acc "..getAccountName(theCurrentAccount)..", money "..getPlayerMoney(source)..", serial "..getPlayerSerial(source)..")")
end
addEventHandler("onPlayerLogout", root, onLogout)

function autosave()
	for _, player in ipairs(getElementsByType("player")) do
		local acc = getPlayerAccount(player)
		if not isGuestAccount(acc) then
			setAccountData(acc, "money", getPlayerMoney(player))
		end
	end
end
setTimer(autosave, 300000, 0)

function setSpawn(player)
	local account = getPlayerAccount(player)
	if not isGuestAccount(account) then
		local x,y,z = getElementPosition(player)
		local _,_,rotZ = getElementRotation(player)
		local int = getElementInterior(player)
		local dim = getElementDimension(player)
		setAccountData(account, "savedSpawnPos", toJSON( {["x"]=x, ["y"]=y, ["z"]=z, ["rotZ"]=rotZ, ["int"]=int, ["dim"]=dim}, true))
		outputChatBox("Координаты для спавна сохранены", player, 137, 255, 0, true)
	end
end
addCommandHandler("sspawn", setSpawn, false, false)
addCommandHandler("setspawn", setSpawn, false, false)

function resetSpawn(player)
	local account = getPlayerAccount(player)
	if not isGuestAccount(account) then
		setAccountData(account, "savedSpawnPos", "")
		setAccountData(account, "savedSpawnPos", false)
		outputChatBox("Координаты для спавна сброшены", player, 137, 255, 0, true)
	end
end
addCommandHandler("resetspawn", resetSpawn, false, false)



function onWasted()
	fadeCamera(source, false)
	setTimer(function(p) if isElement(p) then setCameraTarget(p, p) end end, 1250, 1, source)
	setTimer(spawn, 1800, 1, source, "wasted")
	setTimer(function(p) if isElement(p) then fadeCamera(p, true) end end, 2000, 1, source)
	if not isGuestAccount(getPlayerAccount(source)) then
		local weapons = {}
		for i=0,12 do
			weapons[i] = { ["weap"]=getPedWeapon(source, i), ["ammo"]=getPedTotalAmmo(source, i) }
		end
		if (weapons[1]) and (weapons[1].weap == 9) then
			weapons[1] = nil
		end
		setTimer(giveWeapons, 2000, 1, source, weapons)
	end
end
addEventHandler ("onPlayerWasted", root, onWasted)

function giveWeapons(player, weapons)
	if not isElement(player) then return end
	for i, weapon in pairs(weapons) do
		giveWeapon(player, weapon.weap, weapon.ammo)
	end
	setPedWeaponSlot(player, 0)
end

local hospitals = {
	{-2663.476,   607.376, 15.453, 180.0, 10},	-- San Fierro
	{ 2026.361, -1422.087, 17.992, 135.0, 10},	-- Los Santos Jefferson
	{ 1182.942, -1323.107, 14.578, 270.0, 10},	-- Los Santos Market
	{ -319.740,  1058.744, 20.742, 315.0, 10},	-- Fort Carson
	{ 1576.920,  1768.833, 11.671,  90.0, 10},	-- Las Venturas
	{ 1244.536,   334.287, 19.554, 335.0, 10},	-- Montgomery
	{-1514.503,  2525.530, 55.774,   0.0, 10},	-- El Quebrados
	{-2196.000, -2307.000, 31.625,  45.0,  7},	-- Angel Pine
}

function hospitalDebug()
	for _, hospital in ipairs(hospitals) do
		createColCircle(hospital[1], hospital[2], hospital[5]/2)
		createColSphere(hospital[1], hospital[2], hospital[3], hospital[5]/2)
	end
end
-- hospitalDebug()

local regularSpawns = {
	{2846.3854980469,1291.1134033203,11.390625},
	{2858.7248535156,1291.0051269531,11.390625},
}


addEventHandler("onPlayerJoin", root, function()
	spawn(source, "join")
end)


function spawn(player, spawnReason)
	if not isElement(player) then return end
	local x,y,z, rotz, diameter
	
	if (spawnReason == "wasted") then
		takePlayerMoney(player, 5000)
		outputChatBox ( "Медики нашли вас и реанимировали, но потребовали $ 5000 за свою работу.", player, 255, 255, 255, true )
		x,y,z,rotz,diameter = getNearestHospital(player)
		x, y = x + (math.random()-0.5)*diameter, y + (math.random()-0.5)*diameter
		
	elseif (spawnReason == "join") then
		x = 5000 + (math.random()-0.5)*100
		y = 5000 + (math.random()-0.5)*100
		z, rotz = 0, 0
		
	elseif (spawnReason == "firstLogin") then
		x,y,z,rotz = getRandomSpawnPoint()
		
	end
	
	spawnPlayer(player, x, y, z, rotz, getElementModel(player), 0, 0)
	fadeCamera(player, true)
	setCameraTarget(player, player)
	showChat(player, true)
end

function getNearestHospital(player)
	local nearestID, nearestDistance, distance
	local posX, posY, posZ = getElementPosition(player)
	for i, hosp in pairs(hospitals) do
		distance = ((hosp[1]-posX)^2+(hosp[2]-posY)^2+(hosp[3]-posZ)^2)^(0.5)
		if (not nearestID) or (distance < nearestDistance) then
			nearestDistance = distance
			nearestID = i
		end
	end
	return unpack(hospitals[nearestID])
end

function getRandomSpawnPoint()
	local point = regularSpawns[math.random(#regularSpawns)]
	return unpack(point)
end

--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end
