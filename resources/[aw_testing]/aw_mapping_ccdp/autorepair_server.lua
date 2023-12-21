
local doorLV1 = createObject(11416, 2879.48, 2222.906, 15.0047, 0, 85.5, 0)
local doorLV2 = createObject(11416, 2879.42, 2231.391, 13.7047, 0, 0, 0)
local doorLV3 = createObject(11416, 2893.17, 2251.242, 14.8047, 0, 0, 90)
setObjectScale(doorLV3, 1.07 )
local doorLS1 = createObject(11416, 2919.78821, -1100.69517, 15.4047, 0, 85.5, -0.799)
local doorLS2 = createObject(11416, 2919.846536, -1092.21016, 15.4047, 0, 85.5, -0.799)
local doorLS3 = createObject(11416, 2933.872016, -1072.55283, 15.4047, 0, 85.5, -90.799)
setObjectScale(doorLS3, 1.07 )

--[[
local doorSF1 = createObject(11416, -2038.93, 178.805, 29.9375, 0, 0, 180)
local doorSF2 = createObject(11416, -2038.87, 170.32, 29.9375, 0, 0, 180)
local doorSF3 = createObject(11416, -2052.62, 150.469, 29.9375, 0, 0, 90)
setObjectScale(doorSF3, 1.07 )
local doorLV1 = createObject(11416, 2879.48, 2222.906, 13.0422, 0, 0, 0)
local doorLV2 = createObject(11416, 2879.42, 2231.391, 13.0422, 0, 0, 0)
local doorLV3 = createObject(11416, 2893.17, 2251.242, 13.0422, 0, 0, -90)
setObjectScale(doorLV3, 1.07 )
local doorLS1 = createObject(11416, 2919.78821, -1100.69517, 13.4422, 0, 0, -0.799)
local doorLS2 = createObject(11416, 2919.846536, -1092.21016, 13.4422, 0, 0, -0.799)
local doorLS3 = createObject(11416, 2933.872016, -1072.55283, 13.4422, 0, 0, -90.799)
setObjectScale(doorLS3, 1.07 )
local timer, opened

function toggleAllDoors(playerSource)
	if isTimer(timer) then
		outputChatBox("Двери всё ещё движутся!",playerSource,255,0,0)
		return
	end
	if (not opened) then
		moveObject(doorSF1, 2000, -2038.93, 178.805, 31.9, 0, 85.5, 0)
		moveObject(doorSF2, 2000, -2038.87, 170.32, 31.9, 0, 85.5, 0)
		moveObject(doorSF3, 2000, -2052.62, 150.469, 31.9, 0, 85.5, 0)
		moveObject(doorLV1, 2000, 2879.48, 2222.906, 15.0047, 0, 85.5, 0)
		moveObject(doorLV2, 2000, 2879.42, 2231.391, 15.0047, 0, 85.5, 0)
		moveObject(doorLV3, 2000, 2893.17, 2251.242, 15.0047, 0, 85.5, 0)
		moveObject(doorLS1, 2000, 2919.78821, -1100.69517, 15.4047, 0, 85.5, 0)
		moveObject(doorLS2, 2000, 2919.846536, -1092.21016, 15.4047, 0, 85.5, 0)
		moveObject(doorLS3, 2000, 2933.872016, -1072.55283, 15.4047, 0, 85.5, 0)
		
		outputChatBox("Двери начали открываться!",playerSource,0,255,0)
		triggerClientEvent("playDoorSound", resourceRoot)
		timer = setTimer(function() end, 2000, 1)
		opened = true
	else
		moveObject (doorSF1, 2000, -2038.93, 178.805, 29.9375, 0, -85.5, 0)
		moveObject(doorSF2, 2000, -2038.87, 170.32, 29.9375, 0, -85.5, 0)
		moveObject(doorSF3, 2000, -2052.62, 150.469, 29.9375, 0, -85.5, 0)
		moveObject(doorLV1, 2000, 2879.48, 2222.906, 13.0422, 0, -85.5, 0)
		moveObject(doorLV2, 2000, 2879.42, 2231.391, 13.0422, 0, -85.5, 0)
		moveObject(doorLV3, 2000, 2893.17, 2251.242, 13.0422, 0, -85.5, 0)
		moveObject(doorLS1, 2000, 2919.78821, -1100.69517, 13.4422, 0, -85.5, 0)
		moveObject(doorLS2, 2000, 2919.846536, -1092.21016, 13.4422, 0, -85.5, 0)
		moveObject(doorLS3, 2000, 2933.872016, -1072.55283, 13.4422, 0, -85.5, 0)
		
		outputChatBox("Двери начали закрываться!",playerSource,0,255,0)
		triggerClientEvent("playDoorSound", resourceRoot)
		timer = setTimer(function() end, 2000, 1)
		opened = false
	end
end
addCommandHandler("opensto", toggleAllDoors, true, false)

toggleAllDoors(resourceRoot)
]]
