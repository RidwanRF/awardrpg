
local doors = {
	{id = 11416, closed = {-3673.6,   -366.72, 11.0,  90, 0, 90}, opened = {-3669.95,  -366.72, 11.0, 0, 0, 0}},
	{id = 11416, closed = {-3681.9,   -366.72, 11.0,  90, 0, 90}, opened = {-3685.5,   -366.72, 11.0, 0, 0, 0}},
	{id = 11416, closed = {-3677.727, -366.70, 11.0,  90, 0, 90}, opened = {-3677.727, -366.71,  6.6, 0, 0, 0}},
	
	{id = 11416, closed = {-3699.721, -366.72, 11.0,  90, 0, 90}, opened = {-3696.091, -366.72, 11.0, 0, 0, 0}},
	{id = 11416, closed = {-3708.021, -366.72, 11.0,  90, 0, 90}, opened = {-3711.621, -366.72, 11.0, 0, 0, 0}},
	{id = 11416, closed = {-3703.848, -366.70, 11.0,  90, 0, 90}, opened = {-3703.848, -366.71,  6.6, 0, 0, 0}},
}
local blips = {
	{id = 34, pos = {-3690.866943, -374.109802, 10.151563}, distance = 350},
}
for index, door in ipairs(doors) do
	doors[index].object = createObject(door.id, unpack(door.closed))
end

local opened = false
function openSTO(player)
	if (not opened) then
		for _, door in ipairs(doors) do
			moveObject(door.object, 5000, door.opened[1], door.opened[2], door.opened[3], door.opened[4], door.opened[5], door.opened[6], "InOutQuad")
		end
		for index, blip in ipairs(blips) do
			blips[index].object = createBlip(blip.pos[1], blip.pos[2], blip.pos[3], blip.id, 2, 255,0,0,255, 0, blip.distance)
		end
		opened = true
	else
		for _, door in ipairs(doors) do
			moveObject(door.object, 5000, door.closed[1], door.closed[2], door.closed[3], -door.opened[4], -door.opened[5], -door.opened[6], "InOutQuad")
		end
		for _, blip in ipairs(blips) do
			if isElement(blip.object) then destroyElement(blip.object) end
		end
		opened = false
	end
end
addCommandHandler("opensto", openSTO, true, false)
openSTO()
