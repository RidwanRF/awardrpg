sx,sy = guiGetScreenSize();
local px, py = sx/1920, sy/1080
screenW,screenH = (sx/px), (sy/py);

Black = dxCreateFont("assets/Montserrat-Black.ttf", 10*px)
BoldBig = dxCreateFont("assets/Montserrat-Bold.ttf", 36*px)
Bold = dxCreateFont("assets/Montserrat-Bold.ttf", 24*px)
BoldMini = dxCreateFont("assets/Montserrat-Bold.ttf", 14*px)
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 12*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 36*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 36*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 14*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 10*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 10*px)

local Progress = 0

local anim = false

function drawSpeed()
	local veh = getPedOccupiedVehicle(localPlayer)
		if veh then
			if not veh or getVehicleOccupant ( veh ) ~= localPlayer then return true end
		    if not driveDistance then lastTick = getTickCount() driveDistance = getElementData(veh, "driveDistance") or 0 end
			local neux, neuy, neuz = getElementPosition(veh)

			

			function getFormatSpeed(unit)
				if unit < 10 then
					unit = "00" .. unit
				elseif unit < 100 then
					unit = "0" .. unit
				elseif unit >= 1000 then
					unit = "0"
				end
				return unit
			end
			

				fuel = math.floor(exports.car_benzin:getCarFuel(veh))

			if not fuel then
				fuel = -1
			end
			local vehicleHealth = getElementHealth ( veh ) / 10


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

	
function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.49 * 100 * 1.609344)
        end
    else
        return false
    end
end
local kmh = math.floor(getElementSpeed(getPedOccupiedVehicle(getLocalPlayer()), "kmh"))

        --    dxDrawImage(sx/2-(-917/2)*px, sy/2-(-65/2)*py, 499*px,503*py, "assets/aw_ui_speedometer_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
		    dxDrawImage(sx/2-(-1320/2)*px, sy/2-(-482/2)*py, 239*px,219*py, "assets/aw_ui_speedometer_speedmask2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			dxDrawImage(sx/2-(-1558/2)*px, sy/2-(-860/2)*py, 22*px,23*py, "assets/aw_ui_speedometer_fuel.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
		    dxDrawImage(sx/2-(-1698/2)*px, sy/2-(-701/2)*py, 9*px,15*py, "assets/aw_ui_speedometer_arrow1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
		    dxDrawImage(sx/2-(-1426/2)*px, sy/2-(-701/2)*py, 9*px,15*py, "assets/aw_ui_speedometer_arrow1.png", 180, 0, 0, tocolor(255, 255, 255, 255 - Progress))

			if exports.aw_vehicles_turnlights:getVehicleLightProperty(veh, "turn_right", "state") then
				dxDrawImage(sx/2-(-1698/2)*px, sy/2-(-701/2)*py, 9*px,15*py, "assets/aw_ui_speedometer_arrow2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			end
			  
			if exports.aw_vehicles_turnlights:getVehicleLightProperty(veh, "turn_left", "state") then
				dxDrawImage(sx/2-(-1426/2)*px, sy/2-(-701/2)*py, 9*px,15*py, "assets/aw_ui_speedometer_arrow2.png", 180, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			end

		    dxDrawText(getFormatSpeed(kmh), sx/2-(-980/2)*px, sy/2+(-1505/2)*py,  sx/2-(-2168/2)*px,sy/2+(2927/2)*py, tocolor(255, 255, 255, 255 - Progress), 1, SemiBoldBig, "center", "center", false, false, false, true, false)

			dxDrawText("km/h", sx/2-(-995/2)*px, sy/2+(-1333/2)*py,  sx/2-(-2168/2)*px,sy/2+(2927/2)*py, tocolor(255, 255, 255, 255 - Progress), 1, MediumMini, "center", "center", false, false, false, false, false)

			dxDrawText(fuel.." %", sx/2-(-995/2)*px, sy/2+(-1110/2)*py,  sx/2-(-2168/2)*px,sy/2+(2927/2)*py, tocolor(255, 255, 255, 255 - Progress), 1, MediumMini, "center", "center", false, false, false, false, false)


			hou_circle(sx/2-(-1320/2)*px, sy/2-(-482/2)*py, 239*px,219*py, -180, tocolor(255, 255, 255, 255 - Progress), 360, 300 / 300 * kmh, 40 )

		
			if getVehicleEngineState(veh) then
				dxDrawImage(sx/2-(-1615/2)*px, sy/2-(-590/2)*py, 8*px,12*py, "assets/aw_ui_speedometer_engine2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			else
				dxDrawImage(sx/2-(-1615/2)*px, sy/2-(-590/2)*py, 8*px,12*py, "assets/aw_ui_speedometer_engine1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			end

			if isVehicleLocked(veh) then
				dxDrawImage(sx/2-(-1512/2)*px, sy/2-(-590/2)*py, 13*px,11*py, "assets/aw_ui_speedometer_door2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			else
				dxDrawImage(sx/2-(-1512/2)*px, sy/2-(-590/2)*py, 13*px,11*py, "assets/aw_ui_speedometer_door1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			end

			if getVehicleOverrideLights( veh ) == 2 then
				dxDrawImage(sx/2-(-1560/2)*px, sy/2-(-590/2)*py, 15*px,11*py, "assets/aw_ui_speedometer_lights2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			elseif getVehicleOverrideLights( veh ) == 1 then

				dxDrawImage(sx/2-(-1560/2)*px, sy/2-(-590/2)*py, 15*px,11*py, "assets/aw_ui_speedometer_lights2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
			elseif getVehicleOverrideLights( veh ) == 0 then

				dxDrawImage(sx/2-(-1560/2)*px, sy/2-(-590/2)*py, 15*px,11*py, "assets/aw_ui_speedometer_lights1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress))
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

function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100 * 1.609344)
        end
    else
        return false
    end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end


addEventHandler ( 'onClientResourceStart', resourceRoot, function()
	local res = getResourceFromName ( 'car_benzin' )
	if res and getResourceState ( res ) == 'running' then
		setElementData(localPlayer, 'showSpeedometer', true)
	end
	if not isPedInVehicle ( localPlayer ) then return end
	local v = getPedOccupiedVehicle ( localPlayer )
	if getPedOccupiedVehicleSeat ( localPlayer ) ~= 0 then return end
	addEventHandler("onClientRender", getRootElement(), drawSpeed)
	tick = getTickCount ()
	anim = false
end)

addEventHandler ( 'onClientVehicleEnter', root, function ( pl, seat )
	if pl ~= localPlayer then return end
	if seat ~= 0 then return end
	if not isEventHandlerAdded("onClientRender", getRootElement(), drawSpeed) then
     	addEventHandler("onClientRender", getRootElement(), drawSpeed)
	end
	tick = getTickCount ()
	anim = false
end)

addEventHandler ( 'onClientVehicleStartExit', root, function ( pl, seat )
	if pl ~= localPlayer then return end
	if seat ~= 0 then return end
	tick = getTickCount ()
	anim = true
end )

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
                     return true
                end
           end
      end
     end
     return false
end
