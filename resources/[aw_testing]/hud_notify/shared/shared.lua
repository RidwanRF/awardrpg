
function notify(player, title, text, time)
	if localPlayer then
		displayNotify(player, title, text)
	else
		triggerClientEvent(player, 'notify.notify', resourceRoot, title, text, time)
	end
end


function actionNotify(player, button, text, time)
	if localPlayer then
		displayActionNotify(player, button, text)
	else
		triggerClientEvent(player, 'notify.actionNotify', resourceRoot, button, text, time)
	end
end