----------------------------------------------
--
-- Сменные рамки номерных знаков
--
----------------------------------------------

local TEXTURE_NAME    = "license_frame"
local TEXTURE_FORMAT  = "dxt5"
local TEXTURE_MIPMAPS = true

-- Текстуры рамок
local licenseFrameTextures = {}

-- Шейдеры замены текстур на автомобилях
local vehicleShaders = {}

local function getVehicleShader(vehicle)
    if not vehicle then
        return
    end
    if vehicleShaders[vehicle] then
        return vehicleShaders[vehicle]
    end
    local shader = dxCreateShader("shaders/texture_replace.fx")
    engineApplyShaderToWorldTexture(shader, TEXTURE_NAME, vehicle)
    vehicleShaders[vehicle] = shader
    return shader
end

local function removeVehicleShader(vehicle)
    if vehicle and isElement(vehicleShaders[vehicle]) then
        destroyElement(vehicleShaders[vehicle])
        vehicleShaders[vehicle] = nil
    end
end

function setupVehicleLicenseFrames(vehicle)
    if not isElement(vehicle) then
        return false
    end
    if not isLicenseFrameChangeAllowed(vehicle.model) then
        return
    end
    -- Получить id рамки из даты
    local frameId = tonumber(vehicle:getData("licence_frame"))
    if not frameId or frameId == 0 then
        removeVehicleShader(vehicle)
        return
    end
    local texture = licenseFrameTextures[frameId]
    if not texture then
        outputDebugString("Invalid licence_frame value: " .. tostring(frameId))
        return
    end
    -- Установить шейдер и положить в него текстуру
    local shader = getVehicleShader(vehicle)
    shader:setValue("gTexture", texture)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Загрузить текстуры рамок
    local i = 1
    while true do
        local path = "textures/frame" .. tostring(i) .. ".png"
        if not fileExists(path) then
            break
        end
        licenseFrameTextures[i] = dxCreateTexture(path, TEXTURE_FORMAT, TEXTURE_MIPMAPS)
        i = i + 1
    end
end, true, "high")

local function handleVehicleDestroy()
    if source.type ~= "vehicle" then
        return
    end
    removeVehicleShader(source)
end

-- Проверка доступности смены номерных рамок по наличию соответствующей текстуры
function isLicenseFrameChangeAllowed(model)
    if not model then
        return false
    end
    for i, name in ipairs(engineGetModelTextureNames(model)) do
        if name == TEXTURE_NAME then
            return true
        end
    end
    return false
end

addEventHandler("onClientElementDestroy",   root, handleVehicleDestroy)
addEventHandler("onClientElementStreamOut", root, handleVehicleDestroy)
addEventHandler("onClientVehicleExplode",   root, handleVehicleDestroy)

