

addEventHandler('onClientRender', root, function()
	local typing = isChatBoxInputActive() or isConsoleActive()
	local prev = localPlayer:getData('chat.typing')

	if typing ~= prev then
		localPlayer:setData('chat.typing', typing)
	end
end)
