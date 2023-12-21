---------------------------------------------------
-- Скрипт наложения шейдеров винилов и тонировки --
---------------------------------------------------

local vehicleShaders = {}

-- Параметры тонировки
local tintProperties = {
    -- Тонировка лобового стекла
	front = {
		data = "tint_front",
		material = "lob_steklo"
	},
	-- Тонировка переднего стекла
	side = {
		data = "tint_side",
		material = "pered_steklo"
	},
	-- Тонировка заднего стекла
	rear = {
		data = "tint_rear",
		material = "zad_steklo"
	},
	-- Тонировка передней фары
	pered = {
		data = "tint_pered",
		material = "fara_pered"
	},
	zad = {
		data = "tint_zad",
		material = "fara_zad"
	}
}

local cachedTextures = {}

local function getCachedPaintjob(path)
	local texture = cachedTextures[path]
	if not isElement(texture) then
		texture = dxCreateTexture(path, "dxt5", true, "clamp")
		cachedTextures[path] = texture
	end
	return texture
end

local function getColorTexture(r, g, b, a)
    -- Текстура для смены цвета
    local texture = dxCreateTexture(1, 1, "argb")
    -- Пустые пиксели
    local pixels = string.char(0, 0, 0, 0, 1, 0, 1, 0)
    dxSetPixelColor(pixels, 0, 0, r, g, b, a)
    texture:setPixels(pixels)
    return texture
end

-- Создать или обновить шейдеры для автомобиля
-- omitTint - если true, то не обновляет тонировку
-- omitPaintjob - если true, то не обновляет винил
local function createVehicleShaders(vehicle, omitTint, omitPaintjob)
	if not isElement(vehicle) or not isElementStreamedIn(vehicle) then
		return
	end
	local shadersTable = vehicleShaders[vehicle] or {}

	if not omitTint then
		for name, props in pairs(tintProperties) do
			local value = tonumber(vehicle:getData(props.data))
			if value then
				value = math.max(40, math.min(100, value))
				local shader = shadersTable[props.data]
				if not shader then
					shader = dxCreateShader("shaders/texture_replace.fx", 0, 200, false, "vehicle")
					engineApplyShaderToWorldTexture(shader, props.material, vehicle)
					shadersTable[props.data] = shader
				end
				local alpha = value / 100 * 255
				local texture = getColorTexture(0, 0, 0, alpha)
				dxSetShaderValue(shader, "gTexture", texture)
				destroyElement(texture)
			else
				if isElement(shadersTable[props.data]) then
					destroyElement(shadersTable[props.data])
				end
			end
		end
	end
	if not omitPaintjob then
		local paintjob = vehicle:getData("paintjob")
		local path = "textures/paintjobs/"..tostring(paintjob) .. ".png"
		if paintjob and paintjob ~= 3 and paintjob ~= "3" and fileExists(path) then
			local shader = shadersTable.paintjob
			if not shader then
				shader = dxCreateShader("shaders/texture_replace.fx", 0, 200, false, "vehicle")
				engineApplyShaderToWorldTexture(shader, "remap_body", vehicle)
				engineApplyShaderToWorldTexture(shader, "remap", vehicle)
				shadersTable.paintjob = shader
			end
			local texture = getCachedPaintjob(path)
			dxSetShaderValue(shader, "gTexture", texture)
		else
			if isElement(shadersTable.paintjob) then
				destroyElement(shadersTable.paintjob)
			end
			shadersTable.paintjob = nil
		end
	end

	vehicleShaders[vehicle] = shadersTable
end

local function removeVehicleShaders(vehicle)
	if not vehicleShaders[vehicle] then
		return false
	end
	for name, shader in pairs(vehicleShaders[vehicle]) do
		if isElement(shader) then
			destroyElement(shader)
		end
	end
	vehicleShaders[vehicle] = nil
end

addEventHandler("onClientElementStreamIn", root, function ()
	if getElementType(source) == "vehicle" then
		createVehicleShaders(source)
	end
end)

local function handleVehicleDestroy()
    removeVehicleShaders(source)
end

addEventHandler("onClientElementDestroy",   root, handleVehicleDestroy)
addEventHandler("onClientElementStreamOut", root, handleVehicleDestroy)
addEventHandler("onClientVehicleExplode",   root, handleVehicleDestroy)

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
		createVehicleShaders(vehicle)
	end
end)

addEvent("forceUpdateVehicleComponents", true)
addEventHandler("forceUpdateVehicleComponents", root, function ()
	if not vehicleShaders[source] then
		createVehicleShaders(source)
	end
end)

addEvent("forceUpdateVehicleShaders", true)
addEventHandler("forceUpdateVehicleShaders", root, function (omitTint, omitPaintjob)
	createVehicleShaders(source, omitTint, omitPaintjob)
end)
