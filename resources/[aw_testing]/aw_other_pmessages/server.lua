
local activeDialogs = {}

function sendPM(player, text)
	if isElement(player) then
		if (not activeDialogs[client]) or (not activeDialogs[client][player]) then
			outputServerLog(string.format("[PMESSAGE] Dialog: %s (%s) -> %s (%s)",
				getPlayerName(client), getAccountName(getPlayerAccount(client)),
				getPlayerName(player), getAccountName(getPlayerAccount(player))
			))
			activeDialogs[client] = activeDialogs[client] or {}
			activeDialogs[client][player] = true
		end
		
		outputServerLog(string.format("[PMESSAGE] %s -> %s: \"%s\"",
			getAccountName(getPlayerAccount(client)), getAccountName(getPlayerAccount(player)), tostring(text)
		))
		triggerClientEvent(player, "catchPM", resourceRoot, client, text)
	else
		outputServerLog(string.format("[PMESSAGE] %s -> %s: \"%s\"",
			getAccountName(getPlayerAccount(client)), inspect(player), tostring(text)
		))
	end
end
addEvent("onPlayerPM", true)
addEventHandler("onPlayerPM", resourceRoot, sendPM)

addEventHandler("onPlayerQuit", root, function()
	activeDialogs[source] = nil
end)

-- Перенаправление команды msg
addEventHandler("onPlayerPrivateMessage", root, function(message, recipient)
	cancelEvent()
	client = source
	sendPM(recipient, string.gsub(message, getPlayerName(recipient).." ", "", 1))
	outputChatBox("Пожалуйста, используйте личные сообщения (F9)", source, 255,0,0)
end)
