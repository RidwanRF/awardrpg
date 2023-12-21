CameraManager = {}

local ANIMATION_SPEED = 2
local currentAnimationSpeed = ANIMATION_SPEED
local currentCameraState
local MOUSE_LOOK_SPEED = 50
local mouseLookEnabled = false
local MOUSE_LOOK_VERTICAL_MAX = 35
local MOUSE_LOOK_VERTICAL_MIN = -5
local cameraScrollValue = 0


local camera = {
	rotationHorizontal = 0,
	rotationVertical = 0,
	distance = 4,
	FOV = 75,
	targetPosition = Vector3(),
	roll = 0
}
local targetCamera = {}

cameraPresets = {}

cameraPresets.startingCamera = {
	targetPosition = Vector3(),
	rotationHorizontal = 165,
	rotationVertical = 6,
	distance = 4,
	FOV = 75,
	roll = 0
}

cameraPresets.freeLookCamera = {
	targetPosition = Vector3(),
	rotationHorizontal = 30,
	rotationVertical = 6,
	distance = 4,
	FOV = 75,
	roll = 0
}
local function differenceBetweenAngles(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	while difference < -180 do
		difference = difference + 360
	end
	while difference > 180 do
		difference = difference - 360
	end
	return difference
end

local function update(deltaTime)
	deltaTime = deltaTime / 1000

	for k, v in pairs(targetCamera) do
		if k == "rotationHorizontal" then
			local diff = differenceBetweenAngles(camera[k], targetCamera[k])
			camera[k] = camera[k] + diff * deltaTime * currentAnimationSpeed
		else
			camera[k] = camera[k] + (targetCamera[k] - camera[k]) * deltaTime * currentAnimationSpeed
		end
	end

	local shakeX = math.sin(getTickCount() / 740) * (math.sin(getTickCount() / 300) + 1) * 0.002
	local shakeY = math.cos(getTickCount() / 250) * (math.sin(getTickCount() / 300) + 1) * 0.0005
	local shakeZ = math.sin(getTickCount() / 430) * (math.cos(getTickCount() / 600) + 1) * 0.002
	local shakeOffset = Vector3(shakeX, shakeY, shakeZ)

	local pitch = math.rad(camera.rotationVertical)
	local yaw = math.rad(camera.rotationHorizontal)
	local cameraOffset = Vector3(math.cos(yaw) * math.cos(pitch), math.sin(yaw) * math.cos(pitch), math.sin(pitch))
	cameraOffset = cameraOffset + shakeOffset / 8
	local works = Camera.setMatrix(
		camera.targetPosition + cameraOffset * camera.distance, 
		camera.targetPosition - shakeOffset * 10, 
		camera.roll, 
		camera.FOV
	)
end

local function wrapAngle(value)
	if not value then
		return 0
	end
	value = math.mod(value, 360)
	if value < 0 then
		value = value + 360
	end
	return value
end

function CameraManager.setState(name, noAnimation, animationSpeed)
	if not noAnimation and type(animationSpeed) == "number" then
		currentAnimationSpeed = animationSpeed
	else
		currentAnimationSpeed = ANIMATION_SPEED
	end
	vehicle = getPedOccupiedVehicle ( localPlayer )
	local vehicleMatrix = vehicle.matrix
	for k, v in pairs(cameraPresets[name]) do
		if k == "targetPosition" then
			if type(v) == "string" then
				if v == "car" then				
					targetCamera.targetPosition = Vector3(vehicle.position)
				else
					local componentOffset = Vector3(vehicle:getComponentPosition(v))
					targetCamera.targetPosition = vehicleMatrix:transformPosition(componentOffset)
				end
			else
				vehicle = getPedOccupiedVehicle ( localPlayer )
				targetCamera.targetPosition = vehicleMatrix:transformPosition(v)
			end
			if noAnimation then
				camera.targetPosition = Vector3(targetCamera.targetPosition)
			end
		else
			if k == "rotationHorizontal" then
				v = wrapAngle(v)
			end
			targetCamera[k] = v
			if noAnimation then
				camera[k] = v
			end
		end
	end
	currentCameraState = name
end

local function onMouseWheel(key, state, delta)
	cameraScrollValue = math.min(1, math.max(0, cameraScrollValue + delta * 0.25))

	targetCamera.FOV = 75 - cameraScrollValue * 4.5
	targetCamera.distance = 4.5 - (2 * cameraScrollValue)
end

local function mouseMove(x, y)
	if not mouseLookEnabled then
		return
	end
	local mx = x - 0.5
	local my = y - 0.5
	targetCamera.rotationHorizontal = targetCamera.rotationHorizontal - mx * MOUSE_LOOK_SPEED
	targetCamera.rotationVertical = targetCamera.rotationVertical + my * MOUSE_LOOK_SPEED
	
	if targetCamera.rotationVertical > MOUSE_LOOK_VERTICAL_MAX then
		targetCamera.rotationVertical = MOUSE_LOOK_VERTICAL_MAX 
	elseif targetCamera.rotationVertical < MOUSE_LOOK_VERTICAL_MIN then
		targetCamera.rotationVertical = MOUSE_LOOK_VERTICAL_MIN
	end
end

local function startMouseLook()
	if mouseLookEnabled or isMTAWindowActive() then
		return
	end
	mouseLookEnabled = true
	local rotationHorizontal = camera.rotationHorizontal
	local rotationVertical = camera.rotationVertical
	if targetCamera.rotationVertical == 6 then
		CameraManager.setState("freeLookCamera", false, 6)
	end
	camera.rotationHorizontal = rotationHorizontal
	camera.rotationVertical = rotationVertical
	targetCamera.rotationHorizontal = rotationHorizontal
	targetCamera.rotationVertical = rotationVertical		
	showCursor(false)
	bindKey("mouse_wheel_up", "down" , onMouseWheel, 1)
	bindKey("mouse_wheel_down", "down" , onMouseWheel, -1)
end

local function stopMouseLook()
	if not mouseLookEnabled then
		return
	end
	mouseLookEnabled = false
	showCursor(true)
	unbindKey("mouse_wheel_up", "down" , onMouseWheel, 1)
	unbindKey("mouse_wheel_down", "down" , onMouseWheel, -1)
end

function CameraManager.start()
	CameraManager.setState("startingCamera", true)
	addEventHandler("onClientPreRender", root, update)
	addEventHandler("onClientCursorMove", root, mouseMove)
	bindKey("mouse2", "down", startMouseLook)
	bindKey("mouse2", "up", stopMouseLook)
	showCursor(true)
end

function CameraManager.stop()
	removeEventHandler("onClientPreRender", root, update)
	removeEventHandler("onClientCursorMove", root, mouseMove)
	unbindKey("mouse2", "down", startMouseLook)
	unbindKey("mouse2", "up", stopMouseLook)
	Camera.setTarget(localPlayer)
	showCursor(false)
end

addCommandHandler("cam", function (cmd, name)
	CameraManager.setState(name)
end)

function CameraManager.getTargetPosition()
	return camera.targetPosition
end

function CameraManager.isMouseLookEnabled()
	return not not mouseLookEnabled
end