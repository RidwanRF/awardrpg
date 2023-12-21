local start = false

function resaveFile (text)
	local time = os.date("%d.%m")
	fileCopy (":car_wheels_system/client/wheels_position.lua", 
		string.format (":car_wheels_system/client/wheels_position (%s).lua", time), true)
		
	local f = fileCreate (":car_wheels_system/client/wheels_position.lua")
	fileWrite (f, text)
	fileClose(f)
	startResource (getResourceFromName("car_wheels_system"))
	start = false
end
addEvent ("resavewheels", true)
addEventHandler ("resavewheels", resourceRoot, resaveFile)


function startWrite (pl)
	if start then outputChatBox ("Кто-то уже прописывает колеса!", pl, 255, 0, 0) return end
	if getResourceFromName ("car_wheels_system") and getResourceState (getResourceFromName ("car_wheels_system")) then
		stopResource (getResourceFromName ("car_wheels_system"))
	end
	start = true
	triggerClientEvent (pl, "startWriteWheels", resourceRoot)
end
addCommandHandler ("writewheels", startWrite)