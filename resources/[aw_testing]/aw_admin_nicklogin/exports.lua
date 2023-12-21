loginResourceActive = false

function checkResource(resource)
	local resName = getResourceName(resource)
	if (resName == "login") then
		local state = getResourceState(resource)
		if (state == "running") or (state == "starting") then
			loginResourceActive = true
		else
			loginResourceActive = false
		end		
	end
end
addEventHandler("onClientResourceStart", root, checkResource)
addEventHandler("onClientResourceStop", root, checkResource)

addEventHandler("onClientResourceStart", resourceRoot, function()
	local res = getResourceFromName("login")
	if (res) and (getResourceState(res) == "running") then
		loginResourceActive = true
	end
end)