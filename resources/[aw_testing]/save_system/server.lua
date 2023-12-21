-- ==========     Загрузка и сохранение данных     ==========
addEventHandler("onPlayerLogin", root, function(_, theCurrentAccount)
	local accData = getAllAccountData(theCurrentAccount)
	
	local playerProps = (accData.playerProperties) and fromJSON(accData.playerProperties) or {}
	playerProps.skin = playerProps.skin or 235	-- Применение скина по дефолту вместо сохраненного
	playerProps.health = playerProps.health or 100
	playerProps.armor = playerProps.armor or 0

	setElementData(source, "skinSavePerson", playerProps.skin)
	
	local spawned = false
	if (accData.savedSpawnPos) then
		local pos = fromJSON(accData.savedSpawnPos)
		if (pos) then 
			spawned = spawnPlayer(source, pos.x, pos.y, pos.z+1, pos.rotZ, playerProps.skin, pos.int, pos.dim)
		end
	end
	if (not spawned) and (accData.savedLastPos) then
		local pos = fromJSON(accData.savedLastPos)
		if (pos) then 
			spawned = spawnPlayer(source, pos.x, pos.y, pos.z+1, pos.rotZ, playerProps.skin, pos.int, pos.dim)
		end
	end
	if (not spawned) then
		spawn(source, "firstLogin")
	end
	
	setTimer(afterSpawn, 50, 1, source, playerProps.health, playerProps.armor)
	setPlayerMoney(source, accData.money or 0)
	outputDebugString(string.format("[SAVESYSTEM][LOGIN] %s logged in (acc %s, money %i, serial %s)",
		getPlayerName(source), getAccountName(theCurrentAccount), getPlayerMoney(source), getPlayerSerial(source)
	))
	setCameraTarget(source, source)
	fadeCamera(source, true, 2.0)
end)
function afterSpawn(player, health, armor)
	if isElement(player) then
		setElementHealth(player, health)
		setPedArmor(player, armor)
	end
end

addEventHandler("onPlayerQuit", root, function(quitType)
	local account = getPlayerAccount(source)
	if not isGuestAccount(account) then
		setAccountData(account, "money", getPlayerMoney(source))
		
		local x,y,z, rotZ, int, dim
		local override = getOverridenCoords(source)
		if (not override) then
			x,y,z = getElementPosition(source)
			_,_,rotZ = getElementRotation(source)
			int = getElementInterior(source)
			dim = (int ~= 0) and getElementDimension(source) or 0	-- Принудительно выставлять 0 дименшен, если не в интерьере
		else
			x,y,z = override.x, override.y, override.z
			int, dim = 0, 0
		end
		setAccountData(account, "savedLastPos", toJSON({x=x, y=y, z=z, rotZ=rotZ, int=int, dim=dim}, true))
		
		local playerProps = getAccountData(account, "playerProperties")
		playerProps = (playerProps) and fromJSON(playerProps) or {}
		local health = getElementHealth(source)
		health = (health > 0) and (health) or nil
		playerProps.health = health
		playerProps.armor = getPedArmor(source)
		playerProps.skin = getElementModel(source)
		setAccountData(account, "playerProperties", toJSON(playerProps, true))
		cancelCoordsSavingOverride(source)
		cancelSkinOverride(source)
	end
	exports.aw_server_logs:log("BANK-QUIT", "[BANK][Вышел с сервера] "..getPlayerName(source).." аккунт "..getAccountName(account).." вышес с сервера его баланс "..convertNumber(getPlayerMoney(source)).." - "..convertNumber(exports.bank:getPlayerBankMoney(source,"RUB")).." $. - "..convertNumber(exports.bank:getPlayerBankMoney(source,"DONATE")).." D-Coins.")
	
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
end)

function onLogout(thePreviousAccount, theCurrentAccount)
	cancelEvent()
	setAccountData(thePreviousAccount, "money", getPlayerMoney(source))
	outputDebugString(string.format("[SAVESYSTEM][LOGOUT] %s (acc %s, money %i, serial %s)",
		getPlayerName(source), getAccountName(thePreviousAccount), getPlayerMoney(source), getPlayerSerial(source)
	))
end
addEventHandler("onPlayerLogout", root, onLogout)

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		local acc = getPlayerAccount(player)
		if not isGuestAccount(acc) then
			setAccountData(acc, "money", getPlayerMoney(player))
		end
	end
end, 300000, 0)


-- ==========     Сохранение точки спавна игроком     ==========
function setSpawn(player)
	local account = getPlayerAccount(player)
	if not isGuestAccount(account) then
		local x,y,z = getElementPosition(player)
		local _,_,rotZ = getElementRotation(player)
		local int = getElementInterior(player)
		local dim = (int ~= 0) and getElementDimension(player) or 0
		setAccountData(account, "savedSpawnPos", toJSON({x=x, y=y, z=z, rotZ=rotZ, int=int, dim=dim}, true))
		outputChatBox("Координаты для спавна сохранены", player, 137, 255, 0, true)
	end
end
addCommandHandler("sspawn", setSpawn, false, false)
addCommandHandler("setspawn", setSpawn, false, false)

addCommandHandler("resetspawn", function(player)
	local account = getPlayerAccount(player)
	if not isGuestAccount(account) then
		setAccountData(account, "savedSpawnPos", "")
		setAccountData(account, "savedSpawnPos", false)
		outputChatBox("Координаты для спавна сброшены", player, 137, 255, 0, true)
	end
end, false, false)



-- ==========     Сохранение скина вместо текущего     ==========
local skinsToOverride = {}
function getOverridenSkin(player)
	return skinsToOverride[player]
end

function overrideSkin(player, skin)
	skinsToOverride[player] = skin
end

function cancelSkinOverride(player)
	skinsToOverride[player] = nil
end



-- ==========     Сохранение временных координат     ==========
local coordsToOverride = {}
function getOverridenCoords(player)
	return coordsToOverride[player]
end

function overrideCoordsSaving(player, x, y, z)
	coordsToOverride[player] = {x = x, y = y, z = z}
end

function cancelCoordsSavingOverride(player)
	coordsToOverride[player] = nil
end


-- ==========     Подавление обычного спавна     ==========
local playersToSuppressSpawn = {}
addEventHandler("onPlayerQuit", root, function()
	playersToSuppressSpawn[source] = false
end)

function isSpawnSuppressed(player)
	return playersToSuppressSpawn[player]
end

function suppressSpawn(player)
	playersToSuppressSpawn[player] = true
end

function cancelSpawnSuppressing(player)
	playersToSuppressSpawn[player] = nil
	if isElement(player) and isPedDead(player) then
		respawnWastedPlayer(player)
	end
end


-- ==========     Функции спавна     ==========
function spawn(player, spawnReason)
	if not isElement(player) then return end
	local x,y,z, rotz, diameter, model
	
	if (spawnReason == "join") then
		x = 5000 + (math.random()-0.5)*100
		y = 5000 + (math.random()-0.5)*100
		z, rotz = 0, 0
		model = 0
		
	elseif (spawnReason == "wasted") then
		takePlayerMoney(player, 5000)
		outputChatBox("Медики нашли вас и реанимировали, но потребовали 5000 за свою работу.", player, 255,255,255, true)
		x,y,z,rotz,diameter = getNearestHospital(player)
		x, y = x + (math.random()-0.5)*diameter, y + (math.random()-0.5)*diameter
		model = getElementModel(player)
		
	elseif (spawnReason == "firstLogin") then
		x,y,z,rotz = getRandomSpawnPoint()
		model = 235
	end
	
	spawnPlayer(player, x, y, z, rotz, model, 0, 0)
	setCameraTarget(player, player)
	fadeCamera(player, true)
end

addEventHandler("onPlayerJoin", root, function()
	spawn(source, "join")
end)

-- Респавн после смерти
local respawnDelay = 5000

function respawnWastedPlayer(player)
	fadeCamera(source, false)
	if not isSpawnSuppressed(source) then
		setTimer(spawn, respawnDelay, 1, source, "wasted")
	end
end

addEventHandler("onPlayerWasted", root, function()
	respawnWastedPlayer(source)
end)

-- Точки обычного спавна (вокзал СФ)
local regularSpawns = {
	{2846.3854980469,1291.1134033203,11.390625},
	{2858.7248535156,1291.0051269531,11.390625},

}
function getRandomSpawnPoint()
	local point = regularSpawns[math.random(#regularSpawns)]
	return unpack(point)
end

-- Больницы
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
function getNearestHospital(player)
	local nearestHospital = hospitals[1]
	local nearestDistance = 65535
	local posX, posY, posZ = getElementPosition(player)
	for i, hosp in pairs(hospitals) do
		local distance = ((hosp[1]-posX)^2+(hosp[2]-posY)^2+(hosp[3]-posZ)^2)^(0.5)
		if (distance < nearestDistance) then
			nearestDistance = distance
			nearestHospital = hosp
		end
	end
	return unpack(nearestHospital)
end

function hospitalDebug()
	for _, hospital in ipairs(hospitals) do
		createColCircle(hospital[1], hospital[2], hospital[5]/2)
		createColSphere(hospital[1], hospital[2], hospital[3], hospital[5]/2)
	end
end
-- hospitalDebug()

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end
