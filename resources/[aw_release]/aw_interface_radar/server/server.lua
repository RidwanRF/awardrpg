--=============================================================================================[Script by HAYZEN]=====================================================================================================--

function startWork(key)
	if (key == 'arandlyMTA') then
		triggerClientEvent(client, 'youCanWork', resourceRoot, 'arandly')
	end
end
addEvent('canIwork', true)
addEventHandler('canIwork', resourceRoot, startWork)

function renewRadarBorder(playersTable, state)
	triggerClientEvent(playersTable, "renewRadarBorder", resourceRoot, state)
end

--====================================================================================================================================================================================================================--

