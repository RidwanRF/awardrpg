
local textures = {
	
}

function getTexture(path)
	
	local texture = textures[path] or dxCreateTexture( string.format('assets/images/%s.png', path) )
	textures[path] = textures[path] or texture

	return textures[path]

end



serverTimeDifference = 0
function _getServerTimestamp()
	local rt = getRealTime(getRealTime().timestamp + serverTimeDifference)
	rt.server = serverTime
	return rt
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	triggerServerEvent('timestamp.getFromServer', resourceRoot, getRealTime())
end)

addEvent('timestamp.receiveFromServer', true)
addEventHandler('timestamp.receiveFromServer', root, function(difference, server_ts)
	serverTimeDifference = difference
	serverTime = server_ts
end)