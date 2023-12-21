
function displayNotify(title, text, time)
	animate('notify', 1)

	local id = getTickCount() + math.random()
	local animName = 'notify-'..id

	setAnimData(animName, 0.1)
	animate(animName, 1)

	local data = {
		title = title,
		text = text,
		id = id,
		animName = animName,
		start = getTickCount(),
		timer = setTimer(removeNotifyAnim, time or 5000, 1, id),
	}

	table.insert(currentNotifyList, data)
	
end
addEvent('notify.notify', true)
addEventHandler('notify.notify', root, displayNotify)

function removeNotifyAnim(id)

	for index, data in pairs( currentNotifyList ) do
		if data.id == id then

			animate(data.animName, 0, function()
				removeNotify(data.id)
			end)

			return true

		end
	end

end

function removeNotify(id)

	for index, data in pairs( currentNotifyList ) do
		if data.id == id then

			table.remove(currentNotifyList, index)
			setAnimData('notify-y', 0.1, calculateNotifyY())

			return true

		end
	end

end


local buttonsText = {
	mouse1 = 'ЛКМ',
	mouse2 = 'ПКМ',
}

function displayActionNotify(button, text, time)

	animate('action_notify', 1)

	if isTimer(actionNotifyTimer) then killTimer(actionNotifyTimer) end

	currentActionNotifyData = { title = title, button = buttonsText[button:lower()] or button, text = text }

	if time == 0 then
		animate('action_notify', 0)
	elseif time ~= 'infinite' then
		actionNotifyTimer = setTimer(function()
			animate('action_notify', 0)
		end, tonumber(time) or 3000, 1)
	end

end
addEvent('notify.actionNotify', true)
addEventHandler('notify.actionNotify', root, displayActionNotify)


