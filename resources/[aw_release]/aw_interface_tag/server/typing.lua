
local timers = {}

function resetChatTimer(player)
	if isTimer(timers[player]) then killTimer(timers[player]) end

	timers[player] = setTimer(function(player)
		if isElement(player) then
			player:setData('chat.lastMessage', nil)
		end
	end, 5000, 1, player)
end


function isPlayerMuted(player)
	return (player:getData('mute.time') or 0) > 0
end


addEventHandler('onPlayerChat', root, function(message, type)

	if type == 0 and not isPlayerMuted(source) then
		resetChatTimer(source)
		source:setData('chat.lastMessage', message)
	end

end)