
addEventHandler ( "onClientResourceStart", resourceRoot, function()
	createBlip(2929.639648, -1096.593628, 12.347619, 34, 2, 255, 0, 0, 255, 0, 350)
	createBlip(2888.192627, 2227.75, 11.940625, 34, 2, 255, 0, 0, 255, 0, 350)
	createBlip(1007.797852 , -1361.477539 , 12.425938, 34, 2, 255, 0, 0, 255, 0, 350)
	
	setTimer(fixObjects, 2000, 1)
end)
--[[
function playAllSounds()
	playOneSound(-2038.93, 178.805, 29.9375)
	playOneSound(-2038.87, 170.32, 29.9375)
	playOneSound(-2052.62, 150.469, 29.9375)
	playOneSound(2879.48, 2222.906, 13.0422)
	playOneSound(2879.42, 2231.391, 13.0422)
	playOneSound(2893.17, 2251.242, 13.0422)
	playOneSound(2919.78821, -1100.69517, 13.4422)
	playOneSound(2919.846536, -1092.21016, 13.4422)
	playOneSound(2933.872016, -1072.55283, 13.4422)
end
addEvent("playDoorSound", true)
addEventHandler("playDoorSound", resourceRoot, playAllSounds)

function playOneSound(x,y,z)
	playSFX3D("genrl", 44, 2, x,y,z, false)
	local soundLoop = playSFX3D("genrl", 44, 0, x,y,z, true)
	if soundLoop then
		setTimer(function(s,x,y,z) stopSound(s) playSFX3D("genrl", 44, 2, x,y,z, false) end, 2000, 1, soundLoop,x,y,z)
	end
end
]]

local objectsToFix = { [11326] = true, [11416] = true }
function fixObjects()
	local objects = getElementsByType ( "object", resourceRoot ) 
	for theKey,object in ipairs(objects) do 
		local id = getElementModel(object)
		if objectsToFix[id] then
			local x,y,z = getElementPosition(object)
			local rx,ry,rz = getElementRotation(object)
			local scale = getObjectScale(object)
			objLowLOD = createObject ( id, x,y,z,rx,ry,rz,true )
			setObjectScale(objLowLOD, scale)
			setLowLODElement ( object, objLowLOD )
			engineSetModelLODDistance ( id, 3000 )
			setElementStreamable ( object , false)
			setElementCollisionsEnabled ( object, true )
		end
	end
end