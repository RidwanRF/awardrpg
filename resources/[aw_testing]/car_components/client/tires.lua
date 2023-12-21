
local TEXTURE_NAME    = "sidewall" --== license_frame ==--
local TEXTURE_FORMAT  = "dxt5"
local TEXTURE_MIPMAPS = true

-- Текстуры рамок
local WheelTextures = {}

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

function setupVehicleTires(vehicle)
    if not isElement(vehicle) then
        return false
    end
    if not isTiresChangeAllowed(vehicle.model) then
        return
    end
    -- Получить id рамки из даты
    local tireId = tonumber(vehicle:getData("tire"))
    if not tireId or tireId == 0 then
        removeVehicleShader(vehicle)
        return
    end
    local texture = TiresTextures[tireId]
    if not texture then
        outputDebugString("Invalid tires value: " .. tostring(tireId))
        return
    end
    -- Установить шейдер и положить в него текстуру
    local shader = getVehicleShader(vehicle)
    shader:setValue("gTexture", texture)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    -- Загрузить текстуры резины
    local i = 1
    while true do
        local path = "textures/tires/tire" .. tostring(i) .. ".png"
        if not fileExists(path) then
            break
        end
        WheelTextures[i] = dxCreateTexture(path)--, TEXTURE_FORMAT, TEXTURE_MIPMAPS)
        i = i + 1
    end
end, true, "high")

local function handleVehicleDestroy()
    if source.type ~= "vehicle" then
        return
    end
    removeVehicleShader(source)
end

-- Проверка доступности смены резины по наличию соответствующей текстуры
function isTiresChangeAllowed(model)
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

