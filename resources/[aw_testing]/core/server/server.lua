
function getTimeDifference(date)

	local ts = getRealTime().timestamp - date.timestamp
	date.timestamp = nil
	date.hour = date.hour + 1
	date.day = date.monthday

	local os_time = os.time(date)
	return ts, os_time
end

addEvent('timestamp.getFromServer', true)
addEventHandler('timestamp.getFromServer', resourceRoot, function(date)
	triggerClientEvent(client, 'timestamp.receiveFromServer', client, getTimeDifference(date))
end)

RESOURCES_STARTUP = {
	"nrp_shared",
	"nrp_handler_camera",
},

addEventHandler( "onResourceStart", resourceRoot, function( ) 
	for i, v in pairs( RESOURCES_STARTUP ) do
		local res = getResourceFromName( v )
		if res then
			startResource( res )
		end
	end
end)