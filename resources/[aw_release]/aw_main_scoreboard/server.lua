local timePlayed = {}
local timePlayedSession = {}
local lastTimeUpdate = {}
local countPlayers = 0
 
local function onPlayerLogin(_, playerAccount)
	if (playerAccount) then
		local played = getAccountData(playerAccount, "timePlayed")
		local oldPlayed
		if getAccountData(playerAccount, "Time Played") then
			oldPlayed = {}
			oldPlayed.h = getAccountData(playerAccount, "Time Played-hours")
			oldPlayed.m = getAccountData(playerAccount, "Time Played-min")
			oldPlayed.s = getAccountData(playerAccount, "Time Played-sec")
			setAccountData(playerAccount, "Time Played", 0)
			setAccountData(playerAccount, "Time Played-hours", 0)
			setAccountData(playerAccount, "Time Played-min", 0)
			setAccountData(playerAccount, "Time Played-sec", 0)
			setAccountData(playerAccount, "Time Played", false)
			setAccountData(playerAccount, "Time Played-hours", false)
			setAccountData(playerAccount, "Time Played-min", false)
			setAccountData(playerAccount, "Time Played-sec", false)
		end
		if (played) then
			timePlayed[source] = tonumber(played) or 0
		elseif (oldPlayed) then
			timePlayed[source] = (tonumber(oldPlayed.h) or 0)*3600 + (tonumber(oldPlayed.m) or 0)*60 + (tonumber(oldPlayed.s) or 0)
		else
			timePlayed[source] = 0
		end
		timePlayedSession[source] = 0
		lastTimeUpdate[source] = getRealTime().timestamp
		-- setElementData(source, "timePlayed", math.floor(timePlayed[source]/3600).." ч.")
		if math.floor(timePlayed[source]/60) < 60 then
			setElementData(source, "timePlayed", math.floor(timePlayed[source]/60).." мин")
		else
			setElementData(source, "timePlayed", math.floor(timePlayed[source]/3600).." час")
		end
		if math.floor(timePlayedSession[source]/60) < 60 then
			setElementData(source, "timePlayedSession", math.floor(timePlayedSession[source]/60).." мин")
		else
			setElementData(source, "timePlayedSession", math.floor(timePlayedSession[source]/3600).." час")
		end
	end
end
addEventHandler("onPlayerLogin", root, onPlayerLogin)

local function onPlayerQuit(pl)
	local playerAccount = getPlayerAccount(pl)
	if (playerAccount) and not isGuestAccount(playerAccount) then
		setAccountData(playerAccount, "timePlayed", timePlayed[pl] or 0)
	end
	timePlayed[pl] = nil
	timePlayedSession[pl] = nil
end
addEventHandler("onPlayerQuit", root, function() onPlayerQuit(source) end)

local counter = 0
local function updateTime()
	local saveTime = false
	if (counter % 5 == 0) then saveTime = true end
	counter = counter + 1
	
	local curTimestamp = getRealTime().timestamp
	for player, pTime in pairs(timePlayedSession) do
		timePlayedSession[player] = pTime + (curTimestamp - lastTimeUpdate[player])
		if math.floor(timePlayedSession[player]/60) < 60 then
			setElementData(player, "timePlayedSession", math.floor(timePlayedSession[player]/60).." мин")
		else
			setElementData(player, "timePlayedSession", math.floor(timePlayedSession[player]/3600).." час")
		end
	end
	
	for player, pTime in pairs(timePlayed) do
		timePlayed[player] = pTime + (curTimestamp - lastTimeUpdate[player])
		
		lastTimeUpdate[player] = curTimestamp
		if math.floor(timePlayed[player]/60) < 60 then
			setElementData(player, "timePlayed", math.floor(timePlayed[player]/60).." мин")
		else
			setElementData(player, "timePlayed", math.floor(timePlayed[player]/3600).." час")
		end
		
		if (saveTime) then
			local acc = getPlayerAccount(player)
			if (acc) and not isGuestAccount(acc) then
				setAccountData(acc, "timePlayed", timePlayed[player])
			end
		end
	end
	collectgarbage()
end
setTimer(updateTime, 60000, 0)

local function onResourceStart()
	for i, player in ipairs(getElementsByType("player")) do
		local account = getPlayerAccount(player)
		if (account) and not isGuestAccount(account) then
			source = player
			onPlayerLogin(_, account)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

local function onResourceStop()
	for _, player in ipairs(getElementsByType("player")) do
		onPlayerQuit(player)
	end
end
addEventHandler("onResourceStop", resourceRoot, onResourceStop)

function playerCount ( )
	if eventName == "onPlayerJoin" then
		countPlayers = countPlayers + 1
	elseif eventName == "onPlayerQuit" then
		countPlayers = countPlayers - 1
	end
	triggerClientEvent (root, "tab:online", resourceRoot, countPlayers, getMaxPlayers())
end
addEventHandler ( "onPlayerJoin", getRootElement(), playerCount )
addEventHandler ( "onPlayerQuit", getRootElement(), playerCount )

function getPlayerCounts ()
	local count = 0
	for i, v in ipairs (getElementsByType ("player")) do
		if v and isElement (v) then
			count = count + 1
		end
	end
	return count
end

local players = {}
addEventHandler("onPlayerJoin", root, function ()
	if #players == 0 then
		players[1] = source
		source:setData("player:ID", 1)
		return
	end
	for i = 1, #players + 1 do
		if not isElement(players[i]) then
			players[i] = source
			source:setData("player:ID", i)
			return
		end
	end
 end)

addEventHandler("onPlayerQuit", root, function ()
	for id, pl in pairs (players) do
		if pl == source then
			players[id] = nil
			break
		end
	end
end)

addEventHandler("onResourceStart", resourceRoot, function ()
	for i, p in ipairs(getElementsByType("player")) do
		p:setData("player:ID", i)
		players[i] = p
	end
	
	countPlayers = getPlayerCounts ()
	
	-- setTimer(function()
		-- triggerClientEvent (root, "tab:online", resourceRoot, countPlayers, getMaxPlayers())
	-- end, 1000, 1)
	maxPlayers = getMaxPlayers()
end)