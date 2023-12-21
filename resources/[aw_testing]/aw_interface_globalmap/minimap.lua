function math.round(number)
    return tonumber(("%.0f"):format(number))
end


local screenW, screenH = guiGetScreenSize()
local defaultScreen = {width = 1920, height = 1080}

-- Настраиваемые параметры
local radar = {
	x	   = 50;
	y	   = math.round( screenH - 50 - 300*screenH/defaultScreen.height );
	width  = math.round( 300*screenW/defaultScreen.width				),
	height = math.round( 300*screenW/defaultScreen.width				),
}
local map = {
	left = 1500, right = 1500, top = 1500, bottom = 1500,
	scale = 0.5, -- Количество пикселей в 1 линейном метре карты
}
local blipSize = {
	size = 25,
	markerSize = 8,
}
local borderImage = {
	x	   = math.round( 75												),
	y	   = math.round( screenH-40-(330*screenH/defaultScreen.height)	),
	width  = math.round( 300*screenW/defaultScreen.width				),
	height = math.round( 300*screenH/defaultScreen.height				),
}
-- Автоматически рассчитываемые параметры
local k = radar.height/radar.width -- Коэффициент наклона прямой, проведенной из центра карты в ее угол
radar.halfWidth, radar.halfHeight = math.round(radar.width/2), math.round(radar.height/2)
radar.border = {
	left = radar.x, right  = radar.x+radar.width,
	top  = radar.y, bottom = radar.y+radar.height,
}
radar.center = {
	x = radar.x+radar.halfWidth,
	y = radar.y+radar.halfHeight,
}

local delayingBlipIcons = {
	[35] = true,
	--[17] = true,
	--[41] = true,
	--[56] = true,
}


map.width, map.height			   = map.left+map.right, map.top+map.bottom
map.centerShiftX, map.centerShiftY = (map.left - map.right)/2, (map.top - map.bottom)/2

blipSize.halfSize		 = blipSize.size/2
blipSize.halfMarkerSize = blipSize.markerSize/2

local texture = {
--	water = dxCreateTexture("images/water.png", "dxt1", true, "clamp"),
	radar = "images/map.png",
}

local radarRenderTarget = dxCreateRenderTarget(radar.width, radar.height, true)

local maskShader = dxCreateShader("assets/mask3d.fx")
local maskTexture = dxCreateTexture("assets/mask.png")

dxSetShaderValue(maskShader, "gTexture", radarRenderTarget)
dxSetShaderValue(maskShader, "sMaskTexture", maskTexture)



-- Отрисовка карты
function getCameraParameters()
	local camera = {}
	camera.element = getCamera()
	_, _, camera.rot = getElementRotation(camera.element)
	local radianRotation = math.rad(camera.rot)
	camera.sin = math.sin(radianRotation)
	camera.cos = math.cos(radianRotation)
	return camera
end

function getTargetParameters()
	local target = {}
	target.element = getCameraTarget()
	if (target.element) then
		target.x, target.y, target.z = getElementPosition(target.element)
		_, _, target.rot = getElementRotation(target.element)
		local spX, spY, spZ = getElementVelocity(target.element)
		target.speed = (spX^2 + spY^2 + spZ^2)^(0.5)*180
	else
		target.x, target.y, target.z = getCameraMatrix()
		target.rot = 0
		target.speed = 0
	end
	target.mapX = -target.x*map.scale-map.left
	target.mapY =  target.y*map.scale-map.top
	return target
end

function renderRadar()
	if getElementData(localPlayer, "showHud") == "off" then return end
	if getElementData(localPlayer, "select:hud") ~= "minimal" then return end
	if (maskTexture) and (getElementInterior(localPlayer) == 0) then

		-- Подготовка переменных
		local camera = getCameraParameters()
		local target = getTargetParameters()

		local zoom = 1.0
		if (target.speed < 50) then
			zoom = 1.2
		elseif (target.speed < 160) then
			zoom = 1.2 - (target.speed-50)/183.333
		else
			zoom = 0.6
		end

		-- Рисуем карту

		dxSetRenderTarget(radarRenderTarget, true)

		--dxDrawImage(0, 0, radar.width, radar.height, texture.water)

		dxDrawImage(target.mapX*zoom + radar.halfWidth, target.mapY*zoom + radar.halfHeight,
					map.width*zoom, map.height*zoom,
					texture.radar, camera.rot,
					(target.x*map.scale + map.centerShiftX)*zoom, (-target.y*map.scale + map.centerShiftY)*zoom
		)

		dxSetRenderTarget()

		maskShader:setValue("gUVPosition", 0, 0)
		maskShader:setValue("gUVScale", 1, 1)

		maskShader:setValue("gUVRotCenter", 0.5, 0.5)
		dxSetShaderValue(maskShader, "sPicTexture", radarRenderTarget)
		dxSetShaderValue(maskShader, "sMaskTexture", maskTexture)
		--maskShader:setValue("sMaskTexture", maskTexture)

																-- Возвращаемся к рисованию на экран
		dxDrawImage(radar.x, radar.y, radar.width, radar.height, maskShader)
		dxDrawImage(radar.x, radar.y, radar.width, radar.height, "assets/border.png", 0, 0, 0, tocolor(255, 255, 255, 155))		-- Рисуем карту на экране
		--hou_circle(radar.x+radar.width/2, radar.y+radar.height/2, radar.width, radar.height, tocolor(35,35,35,155), 0,360, 3)

		local delayedBlips = {}		
		for _, blip in ipairs(getElementsByType("blip")) do
			if (not delayingBlipIcons[ getBlipIcon(blip) ]) then	
				local x, y, z = getElementPosition(blip)
				local maxDistance = getBlipVisibleDistance(blip)			
				if (getDistanceBetweenPoints2D(target.x, target.y, x, y) < maxDistance) and (getElementAttachedTo(blip) ~= localPlayer) then
					drawBlipOnMap(blip, camera, target, zoom)
				end
			else
				table.insert(delayedBlips, blip)
			end
		end
		-- Рисуем блип игрока/цели
		if (target.element) then
			dxDrawImage(radar.center.x-blipSize.halfSize, radar.center.y-blipSize.halfSize, blipSize.size, blipSize.size, "images/localPlayer.png", camera.rot-target.rot)
		else
			dxDrawImage(radar.center.x-blipSize.halfSize, radar.center.y-blipSize.halfSize, blipSize.size, blipSize.size, "images/localPlayer.png", camera.rot-target.rot)
		end
	end
end

function drawBlipOnMap(blip, camera, target, zoom)
	local icon = getBlipIcon(blip)
	local x, y, z = getElementPosition(blip)
	local xShift = (x-target.x)*map.scale*zoom
	local yShift = (target.y-y)*map.scale*zoom
	local blipPosX = xShift*camera.cos - yShift*camera.sin
	local blipPosY = xShift*camera.sin + yShift*camera.cos

    local distance = math.sqrt(math.pow(blipPosX, 2) + math.pow(blipPosY, 2))

	if distance > radar.halfWidth then
        blipPosX, blipPosY = repairCoordinates(xShift, yShift, camera, zoom, blipPosX, blipPosY)
	end
	local cx,cy,_,tx,ty = getCameraMatrix()

	if (icon > 0) then
		if distance > radar.halfWidth - 10 then
				dxDrawImage(radar.center.x  + blipPosX - blipSize.halfSize,
							radar.center.y + blipPosY - blipSize.halfSize,
							blipSize.size, blipSize.size, "images/"..icon..".png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		else
				dxDrawImage(radar.center.x + blipPosX - blipSize.halfSize,
							radar.center.y + blipPosY - blipSize.halfSize,
							blipSize.size, blipSize.size, "images/"..icon..".png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		end
	else
		local r, g, b = getBlipColor(blip)
		local size = getBlipSize(blip)
		--if (z-target.z > 5) then
		--	icon = "up"
		--elseif (z-target.z < -5) then
		--	icon = "down"
		--end
		dxDrawImage(radar.center.x + blipPosX - blipSize.halfMarkerSize*size,
					radar.center.y + blipPosY - blipSize.halfMarkerSize*size,
					blipSize.markerSize*size, blipSize.markerSize*size, "images/"..icon..".png", 0, 0, 0, tocolor(r, g, b) )
	end
end


local function cc(x, min, max)
    return math.min(max, math.max(min, x))
end

function repairCoordinates(xShift, yShift, camera, zoom, oldX, oldY)
    local angle = math.atan2( oldY, oldX )
    local newX = (radar.halfWidth - 10)*math.cos(angle) 
	local newY = (radar.halfHeight - 10)*math.sin(angle) 
    return newX, newY
end



local radarIsVisible
function toggleRadar(state)
	if (state == true) and (not radarIsVisible) then
		addEventHandler('onClientHUDRender', root, renderRadar)
		radarIsVisible = true
	elseif (state == false) and (radarIsVisible) then
		removeEventHandler('onClientHUDRender', root, renderRadar)
		radarIsVisible = false
	end
end

function isRadar()
	return radarIsVisible or true
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	setPlayerHudComponentVisible("radar", true)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	setPlayerHudComponentVisible("radar", false)
end)


-- Включение/отключение показа игроков
local showPlayers
local playerBlips = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	if fileExists("showPlayers/false") then
		showPlayers = false
	elseif fileExists("showPlayers/true") then
		showPlayers = true
	else
		showPlayers = "near"
	end
	refreshPlayerBlips()
	toggleRadar(true)
end)

function refreshPlayerBlips()
	for i, blip in pairs(playerBlips) do
		if isElement(blip) then destroyElement(blip) end
		playerBlips[i] = nil
	end
	if (showPlayers == "near") then
		for _, player in ipairs( getElementsByType("player") ) do
			local r,g,b = getPlayerNametagColor(player)
			playerBlips[player] = createBlipAttachedTo(player, 0, 2, r, g, b, 255, 0, 500)
		end
	elseif (showPlayers) then
		for _, player in ipairs( getElementsByType("player") ) do
			local r,g,b = getPlayerNametagColor(player)
			playerBlips[player] = createBlipAttachedTo(player, 0, 2, r, g, b)
		end
	else
		local r,g,b = getPlayerNametagColor(localPlayer)
		playerBlips[localPlayer] = createBlipAttachedTo(localPlayer, 0, 2, r, g, b)
	end
end

function createBlipForPlayer(player)
	if isElement(player) then
		local r,g,b = getPlayerNametagColor(player)
		if (showPlayers == "near") then
			playerBlips[player] = createBlipAttachedTo(player, 0, 2, r, g, b, 255, 0, 500)
		elseif (showPlayers) then
			playerBlips[player] = createBlipAttachedTo(player, 0, 2, r, g, b)
		end
	end
end
addEventHandler("onClientPlayerJoin", root, function()
	setTimer(createBlipForPlayer, 1000, 1, source)
end)

addEventHandler("onClientPlayerQuit", root, function()
	if isElement(playerBlips[source]) then destroyElement(playerBlips[source]) end
end)

function togglePlayerBlips()
	if (showPlayers == "near") then
		if fileExists("showPlayers/true") then fileDelete("showPlayers/true") end
		fileClose(fileCreate("showPlayers/false"))
		showPlayers = false
		refreshPlayerBlips()
		outputChatBox("Показ игроков на карте отключен.", 30,255,30)

	elseif (showPlayers) then
		if fileExists("showPlayers/true") then fileDelete("showPlayers/true") end
		showPlayers = "near"
		refreshPlayerBlips()
		outputChatBox("Показ игроков на карте включен в ограниченном радиусе.", 30,255,30)

	else
		if fileExists("showPlayers/false") then fileDelete("showPlayers/false") end
		fileClose(fileCreate("showPlayers/true"))
		showPlayers = true
		refreshPlayerBlips()
		outputChatBox("Показ игроков на карте включен.", 30,255,30)

	end
end
addCommandHandler("players", togglePlayerBlips, false)

function playersShowType()
	return showPlayers
end

-- Получение координат радара
function getRadarCoords()
	return radar.x, radar.y, radar.width, radar.height
end

