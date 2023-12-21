----------------------------------------------
--
-- Изменение цвета дисков
--
----------------------------------------------

local vehicleColorShaders = {}
local textureName = "rimpaint"
-- Шейдер яркости
local brightnessShader
-- Максимальное значение цвета колеса (определяет яркость)
local MAX_COLOR_VALUE = 150
-- Частота обновления глобального шейдера яркости
local BRIGHTNESS_UPDATE_INTERVAL = 60 * 60 * 1000

local function getColorTexture(r, g, b)
    -- Текстура для смены цвета
    local texture = dxCreateTexture(1, 1, "argb")
    -- Пустые пиксели
    local pixels = string.char(0, 0, 0, 0, 1, 0, 1, 0)
    dxSetPixelColor(pixels, 0, 0, r, g, b)
    dxSetTexturePixels(texture, pixels)
    return texture
end

-- Зависимость яркости от времени суток
local function getBrightnessMul()
    return 1+(math.abs(getTime()-12)/12)*1.25
end

local function getVehicleColorShader(vehicle, r, g, b)
    local shader = vehicleColorShaders[vehicle]
    if not isElement(shader) then
        shader = dxCreateShader("assets/shaders/texture_replace.fx")
        vehicleColorShaders[vehicle] = shader
    end
    -- Передать текстуру в шейдер и удалить её
    local texture = getColorTexture(r, g, b)
    dxSetShaderValue(shader, "gTexture", texture)
    destroyElement(texture)
    return shader
end

function applyWheelColor(vehicle, object, color)
    engineApplyShaderToWorldTexture(brightnessShader, "*", object)

    -- Уменьшение яркости цвета
    local brightness = getBrightnessMul()
    for i, c in ipairs(color) do
        color[i] = c/255*MAX_COLOR_VALUE/brightness
    end
    local shader = getVehicleColorShader(vehicle, unpack(color))
    engineApplyShaderToWorldTexture(shader, textureName, object)
end

function removeVehicleShaders(vehicle)
    if isElement(vehicleColorShaders[vehicle]) then
        destroyElement(vehicleColorShaders[vehicle])
    end
    vehicleColorShaders[vehicle] = nil
end

local function updateBrightnessShader()
    local brightness = MAX_COLOR_VALUE / getBrightnessMul()
    local texture = getColorTexture(brightness, brightness, brightness)
    dxSetShaderValue(brightnessShader, "gTexture", texture)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    brightnessShader = dxCreateShader("assets/shaders/texture_replace.fx")
    updateBrightnessShader()
    setTimer(updateBrightnessShader, BRIGHTNESS_UPDATE_INTERVAL, 0)
end)

function getVehicleWheelsColor(vehicle)
    local color = vehicle:getData("wheels_color")
    if type(color) ~= "string" then
        color = "#FFFFFF"
    end
    return getColorFromString(color)
end

function setVehicleWheelsColor(vehicle, r, g, b)
    if r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255 then
        return nil
    end
    vehicle:setData("wheels_color", string.format("#%.2X%.2X%.2X", r, g, b), false)
end
