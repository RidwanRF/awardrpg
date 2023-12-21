local screenW,screenH = guiGetScreenSize()
local middleX,middleY = screenW/2,screenH/2

local localPlayer  = getLocalPlayer()
local thisResource = getThisResource()
local toggle        = false
local zoom          = 1
local zoomRate      = 0.1
local movementSpeed = 5
local minZoomLimit  = 1
local maxZoomLimit  = 5

local xOffset = 0
local yOffset = 0

local x,y         = 0,0
local hSize,vSize = 0,0

local R,G,B,A      = 255,255,255,175
local mapDrawColor = tocolor(R,G,B,A)
local normalColor  = tocolor(255,255,255,255)

local mapFile                           = "images/map.png"
local topLeftWorldX,topLeftWorldY       = -3000,3000
local lowerRightWorldX,lowerRightWorldY = 3000,-3000
local mapWidth,mapHeight                = 6000,6000
local pixelsPerMeter                    = screenH/6000
local imageOwnerResource                = getThisResource()

toggleControl("radar",false)

local tableLegend = {
	{23, "Автосалон"},
	{24, "ЕКХ"},
	{34, "Настройка автомобилей"},
	{14, "Тюнинг"},
	{46, "Заправка"},
	{45, "Магазин одежды"},
	{31, "Свободный дом"},
	{32, "Занятый дом"},
	{7, "Ваш дом"},
	{44, "Квартиры"},
	{52, "Свободный бизнес"},
	{36, "Занятый бизнес"},
}

local tableBinds = {
	{"Num +", "Приблизить"},
	{"Num -", "Отдалить"},
	{"Num 8", "Вверх"},
	{"Num 2", "Вниз"},
	{"Num 4", "Влево"},
	{"Num 6", "Вправо"},
}

local abs=math.abs

function calculateFirstCoordinates()  -- This function is for making export functions work without the map having been opened once
	hSize=pixelsPerMeter*mapWidth*zoom
	vSize=pixelsPerMeter*mapHeight*zoom
	
	x=middleX-hSize/2+xOffset*zoom
	y=middleY-vSize/2+yOffset*zoom
end
addEventHandler("onClientResourceStart",getResourceRootElement(),calculateFirstCoordinates)

function unloadImageOnOwnerResourceStop(resource)
	if resource==imageOwnerResource and resource~=thisResource then
		setPlayerMapImage()
	end
end
addEventHandler("onClientResourceStop",getRootElement(),unloadImageOnOwnerResourceStop)

function drawMap()
	if not toggle then
		dxDrawImage(0,0,0,0,mapFile,0,0,0,0,false)

	else
		checkMovement()
		
		hSize=pixelsPerMeter*mapWidth*zoom
		vSize=pixelsPerMeter*mapHeight*zoom
		
		x=middleX-hSize/2+xOffset*zoom
		y=middleY-vSize/2+yOffset*zoom
		dxDrawRectangle(0, 0, screenW, screenH, tocolor(15, 15, 15, 220))
		dxDrawImage(x,y,hSize,vSize,mapFile,0,0,0,mapDrawColor,true)

		--dxDrawRectangle(23, 53-25, 204, 25*#tableLegend+4+25, tocolor(80, 80, 80, 200), true)
		--dxDrawRectangle(25, 53-23, 200, 23, tocolor(40, 40, 40, 200), true)
		dxDrawText("Обозначения", 23*2, (53-25)*2, 204, 25, tocolor(255, 255, 255, 255), 1, "clear", "center", "center", false, false, true)
		for i,v in pairs(tableLegend) do
			dxDrawRectangle(25, 55+25*(i-1), 200, 25, tocolor(40, 40, 40, 200), true)
			dxDrawImage(25, 55+25*(i-1), 25, 25, "images/"..v[1]..".png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
			dxDrawText(v[2], 55, (55 + 25*(i-1))*2, 105, 25, tocolor(255, 255, 255, 255), 1, "clear", "left", "center", false, false, true)
		end

		--dxDrawRectangle(screenW-204-23, 53-25, 204, 25*#tableBinds+4+25, tocolor(80, 80, 80, 200), true)
		--dxDrawRectangle(screenW-200-25, 53-23, 200, 23, tocolor(40, 40, 40, 200), true)
		dxDrawText("Управление", (screenW-204-23)*2, (53-25)*2, 204, 25, tocolor(255, 255, 255, 255), 1, "clear", "center", "center", false, false, true)
		for i,v in pairs(tableBinds) do
			dxDrawRectangle(screenW-200 - 25, 55+25*(i-1), 200, 25, tocolor(40, 40, 40, 200), true)
			dxDrawText(v[1], screenW-200-20, (55 + 25*(i-1))*2, 105, 25, tocolor(255, 255, 255, 255), 1, "clear", "left", "center", false, false, true)
			dxDrawText(v[2], screenW-105 - 50, (55 + 25*(i-1))*2, 105, 25, tocolor(255, 255, 255, 255), 1, "clear", "left", "center", false, false, true)
		end
		--outputChatBox(mapFile)
		
		drawRadarAreas()
		drawBlips()
		drawLocalPlayerArrow()
	end
end
addEventHandler("onClientRender",getRootElement(),drawMap)

function drawRadarAreas()
	local radarareas=getElementsByType("radararea")
	if #radarareas>0 then
		local tick=abs(getTickCount()%1000-500)
		local aFactor=tick/500
		
		for k,v in ipairs(radarareas) do
			local x,y=getElementPosition(v)
			local sx,sy=getRadarAreaSize(v)
			local r,g,b,a=getRadarAreaColor(v)
			local flashing=isRadarAreaFlashing(v)
			
			if flashing then
				a=a*aFactor
			end
			
			local hx1,hy1 = getMapFromWorldPosition(x,y+sy)
			local hx2,hy2 = getMapFromWorldPosition(x+sx,y)
			local width   = hx2-hx1
			local height  = hy2-hy1
			
			dxDrawRectangle(hx1,hy1,width,height,tocolor(r,g,b,a),true)
		end
	end
end

function drawBlips()
	for k,v in ipairs(getElementsByType("blip")) do
		if not getElementData(v,"DoNotDrawOnMaximap") then
			local icon=getBlipIcon(v) or 0
			local size=(getBlipSize(v) or 2)*6
			local r,g,b,a=getBlipColor(v)
			
			if icon~=0 then
				r,g,b=255,255,255
				size=20
			end
			
			local x,y,z=getElementPosition(v)
			x,y=getMapFromWorldPosition(x,y)
			
			local halfsize=size/2
			
			dxDrawImage(x-halfsize,y-halfsize,size,size,"images/"..icon..".png",0,0,0,tocolor(r,g,b,a),true)
		end
	end
end

function drawLocalPlayerArrow()
	local x,y,z=getElementPosition(localPlayer)
	local r=getPedRotation(localPlayer)
	
	local mapX,mapY=getMapFromWorldPosition(x,y)
	
	dxDrawImage(mapX-12,mapY-12,24,24,"images/localPlayer.png",(-r)%360,0,0,normalColor,true)
end

function zoomOutRecalculate()
	local newVSize=pixelsPerMeter*mapHeight*zoom
	if newVSize>screenH then
		local newY=middleY-newVSize/2+yOffset*zoom
		
		if newY>0 then
			yOffset=-(middleY-newVSize/2)/zoom
		elseif newY<=(-newVSize+screenH) then
			yOffset=(middleY-newVSize/2)/zoom
		end
	else
		yOffset=0
	end
	
	local newHSize=pixelsPerMeter*mapWidth*zoom
	if newHSize>screenW then
		local newX=middleX-newHSize/2+xOffset*zoom
		
		if newX>=0 then
			xOffset=-(middleX-newHSize/2)/zoom
		elseif newX<=(-newHSize+screenW) then
			xOffset=(middleX-newHSize/2)/zoom
		end
	else
		xOffset=0
	end
end

function checkMovement()
	-- Zoom
	if getPedControlState("radar_zoom_in") and zoom<maxZoomLimit then
		zoom=zoom+zoomRate
		if zoom>maxZoomLimit then zoom=maxZoomLimit end
	elseif getPedControlState("radar_zoom_out") and zoom>minZoomLimit then
		zoom=zoom-zoomRate
		if zoom<minZoomLimit then zoom=minZoomLimit end
		
		zoomOutRecalculate()
	end
	
	-- Move
	if getPedControlState("radar_move_north") then
		local newY=y-yOffset*zoom+(yOffset+movementSpeed)*zoom
		if newY<0 then
			yOffset=yOffset+movementSpeed
		end
	end
	if getPedControlState("radar_move_south") then
		local newY=y-yOffset*zoom+(yOffset-movementSpeed)*zoom
		if newY>(-vSize+screenH) then
			yOffset=yOffset-movementSpeed
		end
	end
	if getPedControlState("radar_move_west") then
		local newXOff=(xOffset+movementSpeed)
		local newX=x-xOffset*zoom+newXOff*zoom
		
		if newX<0 then
			xOffset=xOffset+movementSpeed
		end
	end
	if getPedControlState("radar_move_east") then
		local newX=x-xOffset*zoom+(xOffset-movementSpeed)*zoom
		if newX>(-hSize+screenW) then
			xOffset=xOffset-movementSpeed
		end
	end
end

addEvent("onClientPlayerMapHide")
addEvent("onClientPlayerMapShow")

function toggleMap()
	if toggle then
		if triggerEvent("onClientPlayerMapHide",getRootElement(),false) then
			toggle=false
			toggleControl("radar",false)
			showCursor(false)
			setElementData(localPlayer, "player:interface", true)
			showChat(true)
		end
	else
		if triggerEvent("onClientPlayerMapShow",getRootElement(),false) then
			toggle=true
			if tonumber(getElementData(localPlayer, "player:admin") or 0) >= 5 then
				showCursor(true)
			end
			setElementData(localPlayer, "player:interface", false)
			showChat(false)
		end
	end
end
bindKey("F11","up",toggleMap)

-- Export functions

function getPlayerMapBoundingBox()
	return x,y,x+hSize,y+vSize
end

function setPlayerMapBoundingBox(startX,startY,endX,endY)
	if type(startX)=="number" and type(startY)=="number" and type(endX)=="number" and type(endY)=="number" then
--		TODO
		return true
	end
	return false
end

function isPlayerMapVisible()
	return toggle
end

function setPlayerMapVisible(newToggle)
	if type(newToggle)=="boolean" then
		toggle=newToggle
		
		if toggle then
			triggerEvent("onClientPlayerMapShow",getRootElement(),true)
		else
			triggerEvent("onClientPlayerMapHide",getRootElement(),true)
		end
		
		return true
	end
	return false
end

function getMapFromWorldPosition(worldX,worldY)
	local mapX=x+pixelsPerMeter*(worldX-topLeftWorldX)*zoom
	local mapY=y+pixelsPerMeter*(topLeftWorldY-worldY)*zoom
	return mapX,mapY
end

function getWorldFromMapPosition(mapX,mapY)
	local worldX=topLeftWorldX+mapWidth/hSize*(mapX-x)
	local worldY=topLeftWorldY-mapHeight/vSize*(mapY-y)
	return worldX,worldY
end



function gotoLocation(button,state,aX,aY)
	if (button=="right") and (state=="down") and isPlayerMapVisible() then
		if tonumber(getElementData(localPlayer, "player:admin") or 0) >= 5 then
			local x, y = getWorldFromMapPosition(aX,aY)
			local hit, hitX, hitY, hitZ = processLineOfSight(x, y, 3000, x, y, -3000)
			local z = hitZ or 0
			distanceToGround = 0.4
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if vehicle then
				setElementPosition(vehicle, x, y, z + distanceToGround + 1)
			else
				setElementPosition(localPlayer, x, y, z + distanceToGround + 1)
			end
		end
	end
end
addEventHandler("onClientClick",getRootElement(),gotoLocation)

local states={
	["radar_zoom_in"]=false,
	["radar_zoom_out"]=false,
	["radar_move_north"]=false,
	["radar_move_south"]=false,
	["radar_move_east"]=false,
	["radar_move_west"]=false,
}

local _getPedControlState = getPedControlState
function getPedControlState(control)
	local state=states[control]
	if state==nil then
		return _getPedControlState(localPlayer, control)
	else
		return state
	end
end

local function handleStateChange(key,state,control)
	states[control]=(state=="down")
end

for control,state in pairs(states) do
	for key,states in pairs(getBoundKeys(control)) do
		bindKey(key,"both",handleStateChange,control)
	end
end