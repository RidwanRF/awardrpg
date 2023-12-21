local disabledTags = {}
local disabledChat = {}
local aclGroup = {
	Founder = aclGetGroup("Founder"),
	DeputyFounder = aclGetGroup("DeputyFounder"),
	Moderator = aclGetGroup("Moderator"),
	GA = aclGetGroup("GA"),
	ZGA = aclGetGroup("ZGA"),
}

function toggleTag(playerSource)
	local account = getPlayerAccount(playerSource)
	disabledTags[account] = not disabledTags[account]
	if disabledTags[account] then
		outputChatBox("#FFFFFFВы отключили показ админ-тега!", playerSource, 255,255,255, true)
	else
		outputChatBox("#FFFFFFВы снова включили показ админ-тега.", playerSource, 255,255,255, true)
	end	
end
addCommandHandler("toggletag", toggleTag, true, false)
addCommandHandler("tg", toggleTag, true, false)
addCommandHandler("tag", toggleTag, true, false)

function toggleChat(playerSource)
	local account = getPlayerAccount(playerSource)
	disabledChat[account] = not disabledChat[account]
	if disabledChat[account] then
		outputChatBox("#FFFFFFВы отключили получение глобального чата!", playerSource, 255,255,255, true)
	else
		outputChatBox("#FFFFFFВы снова включили получение глобального чата.", playerSource, 255,255,255, true)
	end	
end
addCommandHandler("togglechat", toggleChat, true, false)

function onChat(message, mesType)
	if (mesType == 0) or (mesType == 1) then
		cancelEvent()
		local account = getPlayerAccount(source)
		local accName = "user."..getAccountName(account)
		if isObjectInACLGroup(accName, aclGroup.Founder) and (not disabledTags[account]) then   
			outputChatBox ( "[Владелец проекта] #ff0000"..getPlayerName(source).."#ff0000: "..message, root, 255, 0, 0, true )
		elseif isObjectInACLGroup(accName, aclGroup.DeputyFounder) and (not disabledTags[account]) then   
			outputChatBox ( "[Заместитель Основателя] #FFFFFF"..getPlayerName(source).."#FFFFFF: "..message, root, 230, 20, 20, true )
		elseif isObjectInACLGroup(accName, aclGroup.GA) and (not disabledTags[account]) then   
			outputChatBox ( "[Главный Администратор] #FFFFFF"..getPlayerName(source).."#FFFFFF: "..message, root, 245, 5, 5, true )
		elseif isObjectInACLGroup(accName, aclGroup.ZGA) and (not disabledTags[account]) then
			outputChatBox ( "[Заместитель Главного Администратора] #FFFFFF"..getPlayerName(source).."#FFFFFF: "..message, root, 143, 143, 143, true )
		elseif isObjectInACLGroup(accName, aclGroup.Moderator) and (not disabledTags[account]) then
			outputChatBox ( "[Младший Модератор] #FFFFFF"..getPlayerName(source).."#FFFFFF: "..message, root, 143, 143, 143, true )
		else
			if isReklama(message) then
				outputChatBox("Вы получили мут за рекламу! Если это ошибка напишите в тех.поддержку vk.com/awardmta", source, true)
				mutePlayer(source, 1200000, "за рекламу")
				return
			end
			local lowerMessage = utf8.lower(message)
			if isFlood(source, lowerMessage) then
				if isResourceRunning("police_ccd") and not exports.police_ccd:isActivePoliceman(source) then
					outputChatBox("#FF0000 Не флудите!", source, 59,89,152, true)
					mutePlayer(source, 1800000, "за флуд", "за флуд (сообщение: \""..message.."\")")
					return
				end
			end
			
			local team, r, g, b = getPlayerTeam(source)
			if (team) then
				r, g, b = getTeamColor(team)
			else
				r, g, b = getPlayerNametagColor(source)
			end
			local sX, sY = getElementPosition(source)
			local int, dim = getElementInterior(source), getElementDimension(source)
			local regularMessage = getPlayerName(source).."#FFFFFF: "..message
			local adminMessage = "#CCCCCC[:]"..getPlayerName(source).."#CCCCCC: "..message
			 local adminMessage = "#CCCCCC[:]"..string.format("#%.2X%.2X%.2X", r, g, b)..getPlayerName(source).."#CCCCCC: "..message
			giveMessageInRadius(regularMessage, adminMessage, r, g, b, sX, sY, int, dim)
			
			if isResourceRunning("police_ccd") and isMat(lowerMessage) then
				exports.police_ccd:takeMoneyForFuck(source, 500)
			end
			if isAdvert(lowerMessage, source) then
				mutePlayer(source, 600000, "за флуд")
			elseif isCaps(message) then
				mutePlayer(source, 180000, "за капс")
			end
		end		
	end
end
addEventHandler("onPlayerChat", root, onChat)

function giveMessageInRadius(regularMessage, adminMessage, r, g, b, sX, sY, int, dim)
	for _, player in ipairs(getElementsByType("player")) do
		local x, y = getElementPosition(player)
		if (getDistanceBetweenPoints2D(sX, sY, x, y) < 500) and (getElementInterior(player) == int) and (getElementDimension(player) == dim) then
			outputChatBox(regularMessage, player, r, g, b, true)
		elseif hasObjectPermissionTo(player, "command.togglechat", false) and (not disabledChat[getPlayerAccount(player)]) then
			outputChatBox((adminMessage or string.format("#CCCCCC[:]#%X%X%X", r, g, b)..regularMessage), player, r, g, b, true)				
		end
	end
end

local floodBase = {}

function isFlood(player, text)
	if (utf8.len(text) > 10) then
		if (not floodBase[player]) then
			floodBase[player] = {}
		end
		local curTime = getRealTime().timestamp
		text = string.sub(text, 1, 32)
		if (floodBase[player][text]) and ((floodBase[player][text].lastUse > curTime-10) or (floodBase[player][text].usesCount > 5)) then
			floodBase[player][text].lastUse = curTime
			floodBase[player][text].usesCount = floodBase[player][text].usesCount + 1
			return true
		else
			if (floodBase[player][text]) then
				floodBase[player][text].lastUse = curTime
				floodBase[player][text].usesCount = floodBase[player][text].usesCount + 1
			else
				floodBase[player][text] = {
					lastUse = curTime,
					usesCount = 1
				}
			end
			return false
		end
	else
		return false
	end
end

function dischargeFlood()
	for _, player in pairs(floodBase) do
		for _, row in pairs(player) do
			row.usesCount = row.usesCount - 1
			if (row.usesCount < 1) then
				row = nil
			end
		end
	end
end
setTimer(dischargeFlood, 60000, 0)

function onQuit()
	floodBase[source] = nil
end
addEventHandler("onPlayerQuit", root, onQuit)

function isReklama(text)
	if string.find(text,"mtasa://", 1, true) then return true end
	if string.find(text,":22003", 1, true) then return true end
	if string.find(text,"46.", 1, true) then return true end
	if string.find(text,"176.", 1, true) then return true end
	if string.find(text,"46,", 1, true) then return true end
	if string.find(text,"46/", 1, true) then return true end
	return false
end

function isMat(text)
	if string.find(text,"бля") then 
		local bad, good = 0, 0
		for _ in string.gmatch(text, "бля") do bad = bad + 1 end		
		for _ in string.gmatch(text, "рубля") do good = good + 1 end	
		for _ in string.gmatch(text, "ребля") do good = good + 1 end	
		if (bad > good) then return true end
	end
	if string.find(text,"еба") then
		local bad, good = 0, 0
		for _ in string.gmatch(text, "еба") do bad = bad + 1 end		
		for _ in string.gmatch(text, "леба") do good = good + 1 end		
		for _ in string.gmatch(text, "чеба") do good = good + 1 end	
		if (bad > good) then return true end
	end					
	if string.find(text,"нах") then
		local bad, good = 0, 0
		for _ in string.gmatch(text, "нах") do bad = bad + 1 end	
		for _ in string.gmatch(text, "нахо") do good = good + 1 end	
		for _ in string.gmatch(text, "енах") do good = good + 1 end	
		for _ in string.gmatch(text, "инах") do good = good + 1 end		
		for _ in string.gmatch(text, "онах") do good = good + 1 end		
		for _ in string.gmatch(text, "нахв") do good = good + 1 end		
		for _ in string.gmatch(text, "анах") do good = good + 1 end		
		if (bad > good) then return true end
	end
	if string.find(text,"сука") then return true end				
	if string.find(text,"хуй") then return true end					
	if string.find(text,"пизд") then return true end				
	if string.find(text,"хуе") then return true end				
	if string.find(text,"ебл") then
		local bad, good = 0, 0
		for _ in string.gmatch(text, "ебл") do bad = bad + 1 end		
		for _ in string.gmatch(text, "небл") do good = good + 1 end	
		if (bad > good) then return true end
	end		
	if string.find(text,"чмо") then
		local bad, good = 0, 0
		for _ in string.gmatch(text, "чмо") do bad = bad + 1 end		
		for _ in string.gmatch(text, "чмок") do good = good + 1 end		
		if (bad > good) then return true end
	end						
	if string.find(text,"пидр") then return true end					
	if string.find(text,"мамк") then return true end				
	if string.find(text,"ганд") then return true end				
	if string.find(text,"шлюх") then return true end				
	if string.find(text,"гей") then
		local bad, good = 0, 0
		for _ in string.gmatch(text, "гей") do bad = bad + 1 end		
		for _ in string.gmatch(text, "ргей") do good = good + 1 end	
		for _ in string.gmatch(text, "гейм") do good = good + 1 end		
		if (bad > good) then return true end
	end
	if string.find(text,"ёба") then return true end						
	if string.find(text,"хуи") then return true end					
	if string.find(text,"падла") then return true end				
	if string.find(text,"паже") then return true end				
	if string.find(text,"долбан") then return true end			
	if string.find(text,"вагин") then return true end				
	if string.find(text,"манд") then
		local bad, good = 0, 0
		for _ in string.gmatch(text, "манд") do bad = bad + 1 end
		for _ in string.gmatch(text, "оманд") do good = good + 1 end
		if (bad > good) then return true end
	end		
	return false
end

local advertCounter = {}
local advertTimers = {}

function isAdvert(text, player)
	if string.find(text,"продам") or string.find(text,"продаю") or string.find(text,"прадаю") or string.find(text,"отдам")
			or string.find(text,"покупаю") or string.find(text,"куплю")
			or string.find(text,"делаю") or string.find(text,"ставлю") or string.find(text,"чип")
			or string.find(text,"принимаю") or string.find(text,"принимаем")
			or string.find(text,"buy") or string.find(text,"sell") then
		if isTimer(advertTimers[player]) then killTimer(advertTimers[player]) end
		advertTimers[player] = setTimer(decrementAdvertCounter, 60000, 0, player)
		
		advertCounter[player] = (advertCounter[player] or 0) + 1
		if (advertCounter[player] > 1) then
			outputChatBox("Внимание! Не размещайте объявления в чате. Используйте панель на F6!", player, 255, 0, 0, true)
		end
		if (advertCounter[player] < 3) then
			return false
		else
			return true
		end
	end
end

function decrementAdvertCounter(p)
	advertCounter[p] = advertCounter[p] - 1
	if (advertCounter[p] == 0) then
		killTimer(advertTimers[p])
		advertCounter[p] = nil
	end
end

function isCaps(text)
	local alphanumeric, capsCount = 0, 0
	
	for k, v in utf8.gmatch(text, "%w") do
		alphanumeric = alphanumeric + 1
	end
	
	for k, v in utf8.gmatch(text, "%u") do	
		capsCount = capsCount + 1
	end

	if (capsCount > alphanumeric/2) and (alphanumeric > 5) then
		return true
	else
		return false
	end	
end

local muted = {}

function mutePlayer(thePlayer, duration, reason, adminReason)
	local serial = getPlayerSerial(thePlayer)
	muted[serial] = true
	setPlayerMuted(thePlayer, true)
	setTimer(unMute, duration, 1, thePlayer, serial)
	
	local sX, sY = getElementPosition(thePlayer)
	local message, adminMessage
	if isResourceRunning("login") then
		message = getPlayerName(thePlayer).."#FF0000 получил мут "..reason.." (Срок - "..tostring(exports.login:timeSegmentToNiceString(duration/10000))..")"
		adminMessage = getPlayerName(thePlayer).."#FF0000 получил мут "..(adminReason or reason).." (Срок - "..tostring(exports.login:timeSegmentToNiceString(duration/10000))..")"
	else
		message = getPlayerName(thePlayer).."#FF0000 получил мут "..reason
		adminMessage = getPlayerName(thePlayer).."#FF0000 получил мут "..(adminReason or reason)
	end
	giveMessageInRadius(message, "#CCCCCC[:]#CC0000"..adminMessage, 255, 0, 0, sX, sY, getElementInterior(thePlayer), getElementDimension(thePlayer))
end

function checkPlayer()
	local serial = getPlayerSerial(source)
	if muted[serial] then
		setPlayerMuted(source, true)
	end
end
addEventHandler("onPlayerJoin", root, checkPlayer)

function unMute(thePlayer, serial)
	if isElement(thePlayer) then
		setPlayerMuted(thePlayer, false)
		outputChatBox("Срок наказания истёк. Вам снова разрешен чат!", thePlayer, 0, 255, 0, true)
	else
		for _, player in ipairs(getElementsByType("player")) do
			if (getPlayerSerial(player) == serial) then
				setPlayerMuted(player, false)
				outputChatBox("Срок наказания истёк. Вам снова разрешен чат!", player, 0, 255, 0, true)
				break
			end
		end
	end
	muted[serial] = nil	
end

function unMuteAll()
	for serial, state in pairs(muted) do
		for _, player in ipairs( getElementsByType("player") ) do
			if (getPlayerSerial(player) == serial) then
				unMute(player, serial)
			end
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, unMuteAll)

function clearchat(thePlayer)
	for i=1,20 do
		outputChatBox(" ")
	end
end
addCommandHandler("clearchat", clearchat, true, false)

function checkNick(_, newNick)
	local nick = newNick or getPlayerName(source)
	if isReklama(nick) then
		kickPlayer(source, "Incorrect nick")
	end
end
addEventHandler("onPlayerJoin", root, checkNick, true, "low")
addEventHandler("onPlayerChangeNick", root, checkNick, true, "low")

addEventHandler("onPlayerChangeNick", root, function(oldNick, newNick, changedByUser)
	if (oldNick ~= newNick) then
		outputServerLog(string.format("[NICK] %s (acc %s) is now known as %s%s",
			oldNick, getAccountName(getPlayerAccount(source)), newNick, (changedByUser and "" or " (changed by script)")
		))
	end
end)

function clearMemory()
	local oldGarbage = math.floor(collectgarbage("count"))
	collectgarbage()
end
setTimer(clearMemory, 3600000, 0)

function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end