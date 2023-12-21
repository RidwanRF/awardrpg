

local modes = {1, 4, 2, 3}
local curCameraMode = 1
local modesCount = 4

function increaseMode(step)
	curCameraMode = curCameraMode + step

	if curCameraMode > modesCount then curCameraMode = modesCount end
	if curCameraMode < 1 then curCameraMode = 1 end

	setCameraViewMode(modes[curCameraMode])
end

addEventHandler('onClientKey', root, function(key, state)
	if isCursorShowing() then return end
	if key == 'v' then return cancelEvent() end
	if not localPlayer.vehicle then return end

	if localPlayer.vehicle.model == 408 then return end

	if getKeyState('tab') then return end

	if key == 'mouse_wheel_down' then
		increaseMode(1)
	elseif key == 'mouse_wheel_up' then
		increaseMode(-1)
	end
end)