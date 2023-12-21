local initialColors = {}
local initialPaintjob
local initialToner = {}
local initialFlare = {}
local vehicle
local timersVeh = {}
local eventsVeh = {}

function setupColorPreview()
    vehicle = localPlayer.vehicle
    if not vehicle then
        return
    end
    initialColors = {
        body       = {getVehicleColorByName("body")},
        additional = {getVehicleColorByName("additional")},
        wheels     = {getVehicleColorByName("wheels")},
        hlbody	   = {getVehicleColorByName("hlbody")},
        ColorType  = {getVehicleColorByName("ColorType")}
    }
    
    initialPaint = vehicle:getData("colorType")
    initialPaintjob = vehicle:getData("paintjob")
    initialToner = {
        front = vehicle:getData("tint_front") or 0,
        side  = vehicle:getData("tint_side")  or 0,
        rear  = vehicle:getData("tint_rear")  or 0,
    }
    initialFlare = {
		pered  = vehicle:getData("tint_pered")  or 0,
		zad  = vehicle:getData("tint_zad")  or 0,
    }
end

function getInitialToner(name)
    return initialToner[name] or 0
end

function getInitialPaint()
    return initialPaint
end

function getInitialFlare(name)
    return initialFlare[name] or 0
end

function getInitialPaintjob()
    return initialPaintjob
end

function calculateTonerPrice()
    local price = 0
    local changedValues = {}
    for name, value in pairs(initialToner) do
        if not value then value = 40 end
        value = math.floor(math.max(40, math.min(100, value)))
        local targetValue = math.floor(vehicle:getData("tint_"..tostring(name)))
        if math.abs(targetValue - value) > 3 then
            price = price + Config.tintPrices[tostring(name)]
            changedValues[name] = targetValue
        end
    end
    return price, changedValues
end

function getVehicleColorByName(name)
    local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
    if name == "body" then
        return r1, g1, b1
    elseif name == "additional" then
        return r2, g2, b2
    elseif name == "wheels" then
        local color = vehicle:getData("wheels_color")
        if type(color) ~= "string" then
            color = "#FFFFFF"
        end
        return getColorFromString(color)
    elseif name == "hlbody" then
		local color_r, color_g, color_b = unpack( (vehicle:getData('colorTypeRGB') or { 0, 0, 0 }) )
    	return color_r*255, color_g*255, color_b*255
    elseif name == "ColorType" then
		local colorType = vehicle:getData('colorType') or 1
    	return colorType
    end
end

function previewVehicleColor(name, r, g, b)
    if name == "body" then
        local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
        setVehicleColor(vehicle, r, g, b, r2, g2, b2)
    elseif name == "additional" then
        local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
        setVehicleColor(vehicle, r1, g1, b1, r, g, b)
    elseif name == "wheels" then
        vehicle:setData("wheels_color", string.format("#%.2X%.2X%.2X", r, g, b), false)
        triggerEvent("forceUpdateVehicleComponents", vehicle)
    elseif name == "hlbody" then
		vehicle:setData("colorTypeRGB", {r/255, g/255, b/255})
        triggerEvent("forceUpdateVehicleComponents", vehicle)
		triggerEvent("forceUpdateVehicleShadersCrutch", vehicle)
    end
end

-- Убирает предпросмотр цвета и прочего с автомобиля
function resetVehiclePreview()
    if not initialColors.body then
        return
    end
    local r1, g1, b1 = unpack(initialColors.body)
    local r2, g2, b2 = unpack(initialColors.additional)
    local r3, g3, b3 = unpack(initialColors.hlbody)
	local colorType = unpack(initialColors.ColorType)
    setVehicleColor(vehicle, r1, g1, b1, r2, g2, b2)
    vehicle:setData("wheels_color", string.format("#%.2X%.2X%.2X", unpack(initialColors.wheels)), false)
    vehicle:setData("paintjob", initialPaintjob, false)
    vehicle:setData("tint_front", initialToner.front, false)
    vehicle:setData("tint_side",  initialToner.side, false)
    vehicle:setData("tint_rear",  initialToner.rear, false)
	vehicle:setData("tint_pered", initialFlare.pered, false)
	vehicle:setData("tint_zad", initialFlare.zad, false)
	if colorType == 1 then colorType = false end
	vehicle:setData('colorType', colorType)
	vehicle:setData('colorTypeRGB', {r3/255, g3/255, b3/255})
	
    triggerEvent("forceUpdateVehicleComponents", vehicle)
    triggerEvent("forceUpdateVehicleShadersCrutch", vehicle)
    triggerEvent("forceUpdateVehicleShaders", vehicle, false, false)
end

function previewVehicleColor2(ctype)
	currentTypeColor = ctype
end

function buyVehicleColor(name, r, g, b)
    triggerServerEvent("paintGarageBuyVehicleColor", resourceRoot, name, r, g, b, currentTypeColor)
end

local paintSound

function playPaintSound()
    if isElement(paintSound) then
        return
    end
    paintSound = playSFX("genrl", 136, 28, true)

    local function fade(deltaTime)
        deltaTime = deltaTime / 1000
        paintSound.volume = paintSound.volume - deltaTime * 2
        if paintSound.volume <= 0 then
            removeEventHandler("onClientPreRender", root, fade)
            destroyElement(paintSound)
            paintSound = nil
        end
    end

    setTimer(function ()
        addEventHandler("onClientPreRender", root, fade)
    end, 1500, 1)
end

function calculateFlarePrice()
    local price = 0
    local valute = {}
    for name, value in pairs(initialFlare) do
        if not value then value = 40 end
        value = math.floor(math.max(40, math.min(100, value)))
        local targetValue = math.floor(vehicle:getData("tint_"..tostring(name)))
        if math.abs(targetValue - value) > 3 then
            price = price + Config.flarePrices[tostring(name)]
            valute[name] = targetValue
        end
    end
    return price, valute
end

addEvent("paintGarageBuyVehicleColor", true)
addEventHandler("paintGarageBuyVehicleColor", resourceRoot, function (name, r, g, b)
    previewVehicleColor(name, r, g, b)
    initialColors[name] = {getVehicleColorByName(name)}
    playPaintSound()
end)

addEvent("paintGarageBuyVehicleColorType", true)
addEventHandler("paintGarageBuyVehicleColorType", resourceRoot, function (name, stype)
    previewVehicleColor(name, r, g, b)
    initialColors[name] = {getVehicleColorByName(name)}
    playPaintSound()
end)

addEvent("paintGarageBuyToner", true)
addEventHandler("paintGarageBuyToner", resourceRoot, function (sides)
    for name, value in pairs(sides) do
        initialToner[name] = value
    end
end)

addEvent("paintGarageBuyFlare", true)
addEventHandler("paintGarageBuyFlare", resourceRoot, function (sides)
    for name, value in pairs(sides) do
        initialFlare[name] = value
    end
end)

addEvent("paintGarageBuyPaintjob", true)
addEventHandler("paintGarageBuyPaintjob", resourceRoot, function (paintjob, resetColor)
    initialPaintjob = paintjob
    if resetColor then
        initialColors.body = {255,255,255}
        initialColors.additional = {255,255,255}
    end
end)

--previewVehicleColor2(2)

--localPlayer.vehicle:setData('colorType', 2)
--localPlayer.vehicle:setData('colorTypeRGB', { 255, 0, 0 })
----triggerEvent("forceUpdateVehicleComponents", localPlayer.vehicle)
--triggerEvent("forceUpdateVehicleShadersCrutch", localPlayer.vehicle)
