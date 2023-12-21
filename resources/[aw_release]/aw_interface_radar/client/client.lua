function math.round(number)
    return tonumber(("%.0f"):format(number))
end

sw, sh = guiGetScreenSize()

zoom = 1
local baseX = 1920
local minZoom = 2
if sw < baseX then
  zoom = math.min(minZoom, baseX/sw)
end

sx,sy = guiGetScreenSize();
local px, py = sx/1920, sy/1080
screenW,screenH = (sx/px), (sy/py);

local Progress = 0

local SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px) 
local Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px) 

local radar = 
{
	x = math.round(sx/2-(1820/2)*px),
	y = math.round(sy/2-(-115*py-249/2)*py),
	width  = 249*px,
	height = 249*px,
	allSize = 0.5*px,
}

function getRadarCoords()
	return sx/2-(radar.x)*px, sx/2-(radar.y/2)*px, radar.width*px, radar.height*py
end

local map = {
	left = 1500, right = 1500, top = 1500, bottom = 1500,
	scale = 0.5,
}


local anim = false

local blipSize = 
{
	size = 20*px,
	markerSize = 8*px,
}



local delayingBlipIcons = 
{
	[4] = true,
}



local k = radar.height/radar.width
radar.halfWidth, radar.halfHeight = math.round(radar.width/2), math.round(radar.height/2)



radar.border = 
{
	left = radar.x, right  = radar.x+radar.width,
	top  = radar.y, bottom = radar.y+radar.height,
}



radar.center = 
{
	x = radar.x+radar.halfWidth,
	y = radar.y+radar.halfHeight,
}



map.width, map.height			   = map.left+map.right, map.top+map.bottom
map.centerShiftX, map.centerShiftY = (map.left - map.right)*px, (map.top - map.bottom)*px



blipSize.halfSize		 = blipSize.size/2*px
blipSize.halfMarkerSize = blipSize.markerSize/2*px



local texture = {
	radar = 		dxCreateTexture("assets/aw_ui_radar_map.png", "dxt1", true, "clamp"),
}

local curRadar = texture.radar
--local delayedBlips = {}
--local blips = {}

local radarRenderTarget = dxCreateRenderTarget(radar.width, radar.height, true)
local maskShader = dxCreateShader("assets/shader/hud_mask.fx")
local maskTexture = dxCreateTexture("assets/aw_ui_radar_mask.png")
dxSetShaderValue(maskShader, "gTexture", radarRenderTarget)
dxSetShaderValue(maskShader, "sMaskTexture", maskTexture)

function getCameraParameters()
	local camera = {}
	camera.element = getCamera()
	_, _, camera.rot = getElementRotation(camera.element)
	camera.x, camera.y, camera.z = getCameraMatrix ()
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

local delayedBlips = {}	
local currentBlips = {}

function dxCreateText (text, x, y, w, h, color, size, font, left, top)
	dxDrawText (text, x, y, x + w, y + h, color, size, font, left, top)
end

function renderRadar()
	if anim == true then
		Progress = Progress + 9
		if (Progress > 220) then
			Progress = 255 
		end
	elseif anim == false then
		Progress = Progress - 9
		if (Progress < 0) then
			Progress = 0
		end
	end


	local target = getTargetParameters()
	currentBlips = {}
	delayedBlips = {}
	local localDim = localPlayer.dimension
	for _, blip in pairs(getElementsByType("blip")) do
		if blip.dimension == localDim then
			if (not delayingBlipIcons[ getBlipIcon(blip) ]) then
				x, y = getElementPosition(blip)
				maxDistance = getBlipVisibleDistance(blip)
				dist = getDistanceBetweenPoints2D(target.x, target.y, x, y)
				attached = getElementAttachedTo(blip)

				atDim = isElement(attached) and getElementDimension(attached) or localDim
				if atDim == localDim and
				dist < maxDistance and (attached ~= localPlayer) then
					table.insert(currentBlips, blip)
				end
			else
				table.insert(delayedBlips, blip)
			end
		end
	end



	if (maskTexture) and (getElementInterior(localPlayer) == 0) then
		local camera = getCameraParameters()
		local target = getTargetParameters()
		local zoom = 1

		local x, y, z = getElementPosition(localPlayer)

        local zone = getZoneName(x, y, z)

        local city = getZoneName(x, y, z, true)

		local weaponID = getPedWeapon (localPlayer) 

		local weapon = getWeaponNameFromID(weaponID)

		local ammo = getPedTotalAmmo (localPlayer)

		local clip = getPedAmmoInClip (localPlayer)

		dxSetRenderTarget(radarRenderTarget, false)


			local cX, cY = ((target.x*map.scale + map.centerShiftX)*zoom), ((-target.y*map.scale + map.centerShiftY)*zoom)
			if texture.radar then
				dxDrawImage(target.mapX * zoom + radar.halfWidth, target.mapY * zoom + radar.halfHeight,map.width * zoom, map.height * zoom,texture.radar, camera.rot,cX, cY)
			end
		dxSetRenderTarget() 
		maskShader:setValue("gUVPosition", 0, 0)
		maskShader:setValue("gUVScale", 1, 1)
		maskShader:setValue("gUVRotCenter", 0.5, 0.5)
		dxSetShaderValue(maskShader, "sPicTexture", radarRenderTarget)
		dxDrawImage(sx/2-(1820/2)*px, sy/2-(-479/2)*py, 249*px,249*py, maskShader,0,0,0,tocolor (255,255,255,255 - Progress))
		dxDrawImage(sx/2-(1820/2)*px, sy/2-(-479/2)*py, 249*px,249*py, "assets/aw_ui_radar_border.png",0,0,0,tocolor (255,255,255,255 - Progress),true)
	--	dxDrawImage(sx/2-(1583/2)*px, sy/2-(-963/2)*py, 10*px,10*py, "assets/aw_ui_radar_health.png",0,0,0,tocolor (255,255,255,255 - Progress),true)
    local health = math.floor(getElementHealth(localPlayer))
	hou_circle(sx/2-(1820/2)*px, sy/2-(-479/2)*py, 249*px,249*py, tocolor(255, 255, 255, 255 - Progress),  0, health/100*360, 4*px)
	
	
		for _, blip in pairs( currentBlips ) do
			drawBlipOnMap(blip, camera, target, zoom)
		end

		for _, blip in pairs(delayedBlips) do
			drawBlipOnMap(blip, camera, target, zoom)
		end
		
		if (target.element) then
			dxDrawImage(radar.center.x-blipSize.halfSize, radar.center.y-blipSize.halfSize, blipSize.size*px, blipSize.size*py, "assets/aw_ui_radar_player.png",0,0,0,tocolor (255,255,255,255 - Progress),true)
		else
			dxDrawImage(radar.center.x-blipSize.halfSize, radar.center.y-blipSize.halfSize, blipSize.size*px, blipSize.size*py, "assets/aw_ui_radar_player.png",0,0,0,tocolor (255,255,255,255 - Progress),true)
		end
	end
end

function anim_true()
	anim = true
end
addEvent("anim_true", true)
addEventHandler("anim_true", root, anim_true)

function anim_false()
	anim = false
end
addEvent("anim_false", true)
addEventHandler("anim_false", root, anim_false)

local prit = false
function drawBlipOnMap(blip, camera, target, zoom)
	if not blip then
		return
	end
	local icon = getBlipIcon(blip)
	local x, y, z = getElementPosition(blip)
	local myPosX, myPosY = getElementPosition (localPlayer)
	
	local xShift = (x-target.x)*map.scale*zoom
	local yShift = (target.y-y)*map.scale*zoom
	local blipPosX = xShift*camera.cos - yShift*camera.sin
	local blipPosY = xShift*camera.sin + yShift*camera.cos
	local distance = getDistanceBetweenPoints2D (x, y, myPosX, myPosY)
	
	if icon == 10 then
		--print (distance, radar.halfWidth+95)
	end
	local alp = 255
	if distance > (radar.halfWidth+200*radar.allSize)/zoom then
		if blip ~= 41 then alp = 150 end
		blipPosX, blipPosY = repairCoordinates(xShift, yShift, camera, zoom, blipPosX, blipPosY, { myPosX, myPosY, x, y } )
	end
	
	local cx,cy,_,tx,ty = getCameraMatrix()

	if (icon > 0) then
		

		dxDrawImage((radar.center.x + blipPosX - blipSize.halfSize*px),(radar.center.y + blipPosY - blipSize.halfSize*py),blipSize.size*px, blipSize.size*py, "assets/images/blip/"..icon..".png", 0, 0, 0,tocolor(255,255,255,255 - Progress),true)

	else
		local r, g, b = getBlipColor(blip)
		local size = getBlipSize(blip)
		if (z-target.z > 5) then
			icon = "up"
		elseif (z-target.z < -5) then
			icon = "down"
		end
		dxDrawImage((radar.center.x + blipPosX - blipSize.halfMarkerSize*size*px),(radar.center.y + blipPosY - blipSize.halfMarkerSize*size*py),blipSize.markerSize*size*px, blipSize.markerSize*size*py, "assets/images/blip/"..icon..".png", 0, 0, 0, tocolor(r, g, b, 255  - Progress),true)
	end
end



local function cc(x, min, max)
    return math.min(max, math.max(min, x))
end



function repairCoordinates(xShift, yShift, camera, zoom, oldX, oldY, fixCC )
    local rX, rY = cc(xShift/radar.halfWidth, -1, 1), cc(yShift/radar.halfHeight, -1, 1)
    local angle = math.deg(math.atan(rY/rX))

    local fixC = 0
	--local m = "0"
	if fixCC[1] >= fixCC[3] then
	    fixC = -90
		--m = "1"
	elseif fixCC[1] < fixCC[3] then
	    fixC = 90
		--m = "2"
	end
	
    local fullangle = camera.rot + angle + fixC

	local newX = (radar.halfWidth-distFromLine*px) * math.sin(math.rad(fullangle))
	local newY = (radar.halfHeight-distFromLine*px) * -math.cos(math.rad(fullangle))
    return newX, newY
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end



local allowedToWork
triggerServerEvent("canIwork", resourceRoot, "arandlyMTA")
function startWork(key)
	if (key == "arandly") then
		setPlayerHudComponentVisible("radar", false)
		bindKey("F11", "up", function()
			toggleRadar()
		end)
		toggleRadar(true)
		allowedToWork = true
	end
end
addEvent("youCanWork", true)
addEventHandler("youCanWork", resourceRoot, startWork)



local radarIsVisible
function toggleRadar(state)
	if (state == true) and (not radarIsVisible) then
		addEventHandler('onClientHUDRender', root, renderRadar, true, "low")
		radarIsVisible = true
	elseif (state == false) and (radarIsVisible) then
		removeEventHandler('onClientHUDRender', root, renderRadar)
		radarIsVisible = false
	else
		toggleRadar(not radarIsVisible)
	end
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	setPlayerHudComponentVisible("radar", true)
end)



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
	if (not allowedToWork) then return end
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



function getRadarCoords()
	return sx/2-(radar.x)*px, sx/2-(radar.y/2)*px, radar.width*px, radar.height*py
end


-- ==========     Изменение цвета окантовки вокруг радара     ==========
-- Настройки
local radiusColorDelta = 5 
local restoreDelta = 10
local white = tocolor(255, 255, 255)

setTimer (function()
	local clr = getColor ()
	white = tocolor(unpack(clr))
end, 50, 1)

-- Переменные состояния
local customAnimation = false
local hasPolicemenInRadius, hasChase = false, false
local currentColor = {255, 255, 255}
local colorPhase = 1

function getRadarBorderColor()
	if (not customAnimation) then
		return white
	else
		if (hasChase) then
			if (colorPhase == 2) then
				local color = math.min(math.min(currentColor[1], currentColor[2]) + chaseColorDelta, 255)
				currentColor = {color, color, 255}
				if (color == 255) then
					colorPhase = 3
				end
				return tocolor(unpack(currentColor))
			
			elseif (colorPhase == 3) then
				local color = math.max(math.min(currentColor[2], currentColor[3]) - chaseColorDelta, 0)
				currentColor = {255, color, color}
				if (color == 0) then
					colorPhase = 4
				end
				return tocolor(unpack(currentColor))
			
			elseif (colorPhase == 4) then
				local color = math.min(math.min(currentColor[2], currentColor[3]) + chaseColorDelta, 255)
				currentColor = {255, color, color}
				if (color == 255) then
					colorPhase = 1
				end
				return tocolor(unpack(currentColor))
			
			else
				local color = math.max(math.min(currentColor[1], currentColor[2]) - chaseColorDelta, 0)
				currentColor = {color, color, 255}
				if (color == 0) then
					colorPhase = 2
				end
				return tocolor(unpack(currentColor))
			end
			
		elseif (hasPolicemenInRadius) then
			if (colorPhase == 4) then
				local b = math.min(currentColor[3] + radiusColorDelta, 255) 
				--local b = 255 - (255-g)/2
				currentColor = {255, 255, b}
				if (b == 255) then
					colorPhase = 3
				end
				return tocolor(unpack(currentColor))
				
			else
				local b = math.max(currentColor[3] - radiusColorDelta, 0)
				--local g = 255 - (255-b)/2
				currentColor = {255, 255, b}
				if (b == 0) then
					colorPhase = 4
				end
				return tocolor(unpack(currentColor))
			end
			print (currentColor[3])
		
		else
			currentColor = {
				math.min(255, currentColor[1]+restoreDelta),
				math.min(255, currentColor[2]+restoreDelta),
				math.min(255, currentColor[3]+restoreDelta),
			}
			if (currentColor[1] == 255) and (currentColor[2] == 255) and (currentColor[3] == 255) then
				--customAnimation = false
				return white
			else
				return tocolor(unpack(currentColor))
			end
		end
	end
end

-- Поиск погони за игроком или машиной, в которой он сидит
setTimer(function()
	if (getPlayerWantedLevel() == 0) then
		hasChase = false
		hasPolicemenInRadius = false
		return
	end
	
	local newChaseState = false
	if getElementData(localPlayer, "isChased") then
		newChaseState = true
	else
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (vehicle) then
			for _, occupant in pairs(getVehicleOccupants(vehicle)) do
				if getElementData(occupant, "isChased") then
					newChaseState = true
					break
				end
			end
		end
	end
	if (newChaseState) then
		hasChase = true
		customAnimation = true
	else
		hasChase = false
	end
end, 1000, 0)

-- Индикатор наличия полицейских в радиусе
local policemanNearTimer
addEvent("renewRadarBorder", true)
addEventHandler("renewRadarBorder", resourceRoot, function(state)
	if (state == "policemanNear") then
		if (getPlayerWantedLevel() == 0) then return end
		hasPolicemenInRadius = true
		customAnimation = true
		if isTimer(policemanNearTimer) then killTimer(policemanNearTimer) end
		policemanNearTimer = setTimer(resetPolicemanNearState, 15000, 1)
		
	else
		outputDebugString("Unknown state in renewRadarBorder: "..inspect(state), 2)
	end
end)

function resetPolicemanNearState()
	hasPolicemenInRadius = false
end

function cursorPosition(x, y, w, h)
	if (not isCursorShowing()) then
		return false
	end
	local mx, my = getCursorPosition()
	local fullx, fully = guiGetScreenSize()
	cursorx, cursory = mx*fullx, my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end


function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end
