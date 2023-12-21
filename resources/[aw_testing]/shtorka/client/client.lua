
-- // Таблица
data = {}
data.state = {}
data.target = {}
data.shader = {}
data.procces = {}
data.animation = {}

-- // Установить шейдер
func_shader_setup = function(vehicle)
	
	if data.shader[vehicle] then
		func_shader_destroy(vehicle)
	end
	
	data.shader[vehicle] 	= dxCreateShader("assets/shader/shader.fx", 0 , 125, true, "vehicle")
	data.target[vehicle] 	= dxCreateRenderTarget(128, 35, true)
	data.procces[vehicle] 	= data.procces[vehicle] or 0
	
	for _, texture in ipairs(game_table_texture) do
		engineApplyShaderToWorldTexture(data.shader[vehicle], texture, vehicle)
	end
	
	-- // Применить картинку к шейдеру
	dxSetRenderTarget(data.target[vehicle], true)
	dxDrawRectangle(0, 0, 128, data.procces[vehicle] / 2, tocolor(0, 0, 0, 255))
	dxSetRenderTarget()
	dxSetShaderValue(data.shader[vehicle], "gTexture", data.target[vehicle])
	
end

-- // Удалить шейдер
func_shader_destroy = function(vehicle)
	if isElement(vehicle) then
		if data.shader[vehicle] then
			for _, texture in ipairs(game_table_texture) do
				engineRemoveShaderFromWorldTexture(data.shader[vehicle], texture, vehicle)
			end
			destroyElement(data.shader[vehicle])
			data.shader[vehicle] = nil
		end
		if data.target[vehicle] then
			destroyElement(data.target[vehicle])
			data.target[vehicle] = nil
		end
	end
end

-- // Обновление шторки
func_shader_render = function()
	for vehicle, shader in pairs(data.shader) do
		if isElement(vehicle) then
			if data.procces[vehicle] > 70 or data.procces[vehicle] < -1 then
				if data.procces[vehicle] > 70 then
					data.procces[vehicle] = 70
				else
					data.procces[vehicle] = 0
				end
				data.animation[vehicle] = false
			else
				data.animation[vehicle] = true
			end
			if data.animation[vehicle] then
				dxSetRenderTarget(data.target[vehicle], true)
				dxDrawRectangle(0, 0, 128, data.procces[vehicle] / 2, tocolor(0, 0, 0, 255))
				dxSetRenderTarget()
				dxSetShaderValue(data.shader[vehicle], "gTexture", data.target[vehicle])
				
				for _, texture in ipairs(game_table_texture) do
					engineApplyShaderToWorldTexture(data.shader[vehicle], texture, vehicle)
				end
			end
			if data.state[vehicle] then
				data.procces[vehicle] = data.procces[vehicle] + 1
			else
				data.procces[vehicle] = data.procces[vehicle] - 1
			end
		end
	end
end
addEventHandler("onClientRender", root, func_shader_render)

-- // Установить шторку
addEvent("vehicle:shtorka", true)
addEventHandler("vehicle:shtorka", resourceRoot, function(vehicle)
	if getElementData(vehicle, "vehicle:shtorka") or false then
		if data.state[vehicle] == nil then
			data.state[vehicle] = true
		else
			data.state[vehicle] = not data.state[vehicle]
		end
	else
		if data.state[vehicle] == true then
			data.state[vehicle] = false
		end
	end
end)

-- // Обновление шторки
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
	local px, py, pz = getElementPosition(localPlayer)
	local table = getElementsWithinRange(px, py, pz, 300, "vehicle")
	for _, vehicle in pairs(table) do
		if isElementStreamedIn(vehicle) then
            func_shader_setup(vehicle)
        end
	end
end)

-- // Обновление шторки
addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) ~= "vehicle" then
		return
	end
	func_shader_setup(source)
end)

-- // Удаление шторки
addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) ~= "vehicle" then
		return
	end
	if data.shader[source] then
		func_shader_destroy(source)
	end
end)

-- // Обновление шторки
addEventHandler("onClientRestore", root, function()
    local px, py, pz = getElementPosition(localPlayer)
	local table = getElementsWithinRange(px, py, pz, 300, "vehicle")
	for _, vehicle in pairs(table) do
		if isElementStreamedIn(vehicle) then
            func_shader_setup(vehicle)
        end
    end
end)

-- // Удаление шторки
addEventHandler("onClientElementDestroy", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		func_shader_destroy(source)
	end
end)

-- // Удаление шторки
addEventHandler("onClientVehicleRespawn", root, function()
	if getElementType(source) == "vehicle" then
		func_shader_setup(source)
	end
end)