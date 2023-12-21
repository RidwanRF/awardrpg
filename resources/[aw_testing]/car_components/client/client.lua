-- function getVehicleWindowOpenRatio()
-- 	return 1
-- end
-- function getVehicleWindowsOffset()
-- 	return {1,1,1,1,1,1, rx=0,ry=0,rz=0,x=0,y=0,z=0}
-- end

-- mta_setVehicleComponentPosition = setVehicleComponentPosition
-- function setVehicleComponentPosition(veh, name, x,y,z)
-- 	mta_setVehicleComponentPosition(veh, name, x,y,z)
-- end

-- mta_setVehicleComponentRotation = setVehicleComponentRotation
-- function setVehicleComponentRotation(veh, name, x,y,z)
-- 	mta_setVehicleComponentRotation(veh, name, x,y,z)
-- end

-- mta_getVehicleComponentPosition = getVehicleComponentPosition
-- function getVehicleComponentPosition(veh, name)
-- 	print('position', name)
-- 	return mta_getVehicleComponentPosition(veh, name)
-- end

-- mta_getVehicleComponentRotation = getVehicleComponentRotation
-- function getVehicleComponentRotation(veh, name)
-- 	print('rotation', name)
-- 	return mta_getVehicleComponentRotation(veh, name)
-- end


-- Vehicle.getComponentPosition = getVehicleComponentPosition
-- Vehicle.getComponentRotation = getVehicleComponentRotation

-- local veh = exports['game_veh_autosalon']:findVeh(8395)
-- setClipboard(toJSON(getVehicleComponents(veh)))
-- local name = 'door_rf_dummy'

-- addEventHandler('onClientRender', root, function()
-- 	local table = {}
-- 	x,y,z = getVehicleComponentRotation(veh, name)
-- 	print(x,y,z,getTickCount())
-- end)

-- function getVehicleSpoilerId()
-- 	return 222
-- end
-- function getVehicleComponentId()
-- 	return 222
-- end

function bindKey()
end

function getKeyState(name)
	return false
end


function setVehicleComponentVisible() end

local bannedModels = {
	--[434]=true,
}
local doors = {
	 ['door_lf_dummy']={
	 	['door_dside_f0']=true,
	 	['door_dside_f1']=true,
	 	['door_dside_f2']=true,
	 	['door_dside_f3']=true,
	 	['door_dside_f4']=true,
	 	['door_dside_f5']=true,
	 	['fl_glass_r']=true,
	 	['door_lf']=true,
	 	['window_lf']=true,
	 	['door_dside_f']=true,
	 	['door_lside_f']=true,
	 },
	 ['door_rf_dummy']={
	 	['door_pside_f0']=true,
	 	['door_pside_f1']=true,
	 	['door_pside_f2']=true,
	 	['door_pside_f3']=true, 
	 	['door_pside_f4']=true,
	 	['door_pside_f5']=true,
	 	['fr_glass_r']=true,
	 	['door_rf']=true,
	 	['window_rf']=true,
	 	['door_dside_f']=true,
	 	['door_lside_f']=true,
	 },
	 ['door_lr_dummy']={
	 	['door_dside_r0']=true,
	 	['door_dside_r1']=true,
	 	['door_dside_r2']=true,
	 	['door_dside_r3']=true,
	 	['door_dside_r4']=true,
	 	['door_dside_r5']=true,
	 	['rl_glass_r']=true,
	 	['door_lr']=true,
	 	['window_lr']=true,
	 	['door_dside_f']=true,
	 	['door_lside_f']=true,
	 },
	 ['door_rr_dummy']={
	 	['door_pside_r0']=true,
	 	['door_pside_r1']=true,
	 	['door_pside_r2']=true,
	 	['door_pside_r3']=true,
	 	['door_pside_r4']=true,
	 	['rr_glass_r']=true,
	 	['door_rr']=true,
	 	['window_rr']=true,
	    ['door_dside_f']=true,
	 	['door_lside_f']=true,
	 },
	 ['door_lr_dummy']={
	 	['door_dside_l0']=true,
	 	['door_dside_l1']=true,
	 	['door_dside_l2']=true,
	 	['door_dside_l3']=true,
	 	['door_dside_l4']=true,
	 	['door_dside_l5']=true,
	 	['rl_glass_r']=true,
	 	['door_lr']=true,
	 	['window_lr']=true,
	 	['door_dside_f']=true,
	 	['door_lside_f']=true,

	 },
}
addEventHandler('onClientRender', root, function()
	for k,vehicle in pairs(getElementsByType('vehicle')) do
		if isElementStreamedIn(vehicle) then

			local model = getElementModel(vehicle)
			if not bannedModels[model] then

				local components = getVehicleComponents(vehicle)

				for k,v in pairs(doors) do
					if components[k] then
						local rx,ry,rz = getVehicleComponentRotation(vehicle, k)
						for k1,v1 in pairs(v) do
							if components[k1] then
								setVehicleComponentRotation(vehicle, k1, rx,ry,rz)
							end
						end
					end
				end

			end
		end
	end
end)


mta_addEventHandler = addEventHandler
function addEventHandler(name, element, func, flag, step, ...)
	if name == 'onClientKey' then return end
	if name == 'onClientElementStreamIn' then
		flag = true
		step = 'high+200000'
	end
	mta_addEventHandler(name, element, function(...)
		Vehicle.setComponentVisible = setVehicleComponentVisible
		Vehicle.setComponentRotation = function(v, c, x,y,z)
			if c:find('movpart') then return end
			if c:find('spoiler') then return end

			local model = getElementModel(v)

			if model == 506 then return end
			if model == 434 then return end

			if model == 551 then
				z = -z
			end

			if model == 490 then
				setVehicleComponentRotation(v, 'halloween1', -2, -20, -34)
				setVehicleComponentRotation(v, 'halloween2', -2, -20, -34)
			end


			if model == 526 then
				if c == 'window_lf' then
					setVehicleComponentRotation(v, 'door_L', x, y, z)
				elseif c == 'window_rf' then
					setVehicleComponentRotation(v, 'door_R', x, y, z)
				end
			end

			setVehicleComponentRotation(v, c, x, y, z)
		end
		Vehicle.setComponentPosition = function(v, c, x,y,z)
			if c:find('movpart') then return end
			if c:find('spoiler') then return end

			local model = getElementModel(v)

			if model == 506 then return end
			if model == 434 then return end

			setVehicleComponentPosition(v, c, x, y, z)
		end
		func(...)
	end, flag, step, ...)
end