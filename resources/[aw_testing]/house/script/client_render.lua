
local pictX, pictY = 64, 64
local black, white = tocolor(0,0,0, 255), tocolor(255,255,255, 255)
myHouseBlips = {}
local screenW, screenH = guiGetScreenSize()

function refreshMyHouseBlips()
	for i, blip in pairs( myHouseBlips ) do
		if isElement(blip) then destroyElement(blip) end
		myHouseBlips[i] = nil
	end
	for _, marker in ipairs( getElementsByType("marker", resourceRoot) ) do
		local data = getElementData(marker, "houseData")
		if (data) and (data.owner == myAccount) then
			myHouseBlips[data.ID] = createBlipAttachedTo(marker, 7, 0, 0,0,0,255,0, 500)
		end
	end
end
addEvent("refreshHouseBlips", true)
addEventHandler("refreshHouseBlips", resourceRoot, refreshMyHouseBlips)

function renderHouseInfo()
	for i, marker in ipairs(getElementsByType("marker", resourceRoot, true)) do
		local houseData = getElementData(marker, "houseData")
		if (houseData) and (houseData.cost) then
			local x, y, z = getElementPosition(marker);
			local cX, cY, cZ = getCameraMatrix();
			local dist = getDistanceBetweenPoints3D(cX, cY, cZ, x, y, z)
			if (dist > 3) and (dist < 30) then
				local px, py = getScreenFromWorldPosition( x, y, z + 1.8, 0.06 )
				if px then
					if isLineOfSightClear(cX, cY, cZ, x, y, z, true, true, false, true, false, false, false, marker) then
						local owner = houseData.owner
						local r,g,b = getMarkerColor(marker)
						if (owner == "") then owner = "отсутствует." end
						if (owner == myAccount) then r,g,b = 56, 120, 172 end
						dxDrawText("Владелец: "..owner,		px+1,	py+screenH/38,	px+1,	py+1,	black, 1, 'default-bold', 'center', 'center', false, false )
						dxDrawText("Владелец: "..owner,		px,		py+screenH/38,	px,		py,		white, 1, 'default-bold', 'center', 'center', false, false )
						dxDrawImage(px-pictX/2, py-screenH/17, pictX, pictY, "images/house_icon.png", 0, 0, 0, tocolor(r,g,b, 255) );
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, renderHouseInfo)

function explodePrice(price)
	local nPrice = math.ceil(tonumber(price))
	price = tostring(nPrice)
	if (nPrice < 1000) then
		return price
	elseif (nPrice < 1000000) then
		return string.sub(price, -6, -4).." "..string.sub(price, -3)
	elseif (nPrice < 1000000000) then
		return string.sub(price, -9, -7).." "..string.sub(price, -6, -4).." "..string.sub(price, -3)
	end
end

local allHouseBlips = {}

bindKey("i", "both", function(_, keyState)
	if (keyState == "down") then
		for _, marker in ipairs( getElementsByType("marker", resourceRoot) ) do
			local houseData = getElementData(marker, "houseData")
			if (houseData) and (houseData.owner) then
				if (houseData.owner ~= myAccount) then
					if (houseData.owner ~= "") then
						table.insert(allHouseBlips, createBlipAttachedTo(marker, 32, 0,0,0,0,255,0, 10000))
					else
						table.insert(allHouseBlips, createBlipAttachedTo(marker, 31, 0,0,0,0,255,0, 10000))
					end
				end
			end
		end
	else
		for i, blip in pairs( allHouseBlips ) do
			if isElement(blip) then destroyElement(blip) end
			allHouseBlips[i] = nil
		end
	end
end )