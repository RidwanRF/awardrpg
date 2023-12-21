local pickups={
	
	{cords1={2196.96582, 1677.18054, 12.36719},cords2={2202.77197, 1655.95386, 1024.46753,0,0,0,1,0},cords3={2202.77197, 1655.95386, 1024.46753,0,0,0,0,0},cords4={2196.96582, 1677.18054, 12.36719,0,0,0,0,0}},
	
}

for i,v in ipairs(pickups) do
	v.cords1_p=createPickup(v.cords1[1],v.cords1[2],v.cords1[3],3,1239,51,0)
	setElementDimension(v.cords1_p,v.cords4[7] or 0)
	setElementInterior(v.cords1_p,v.cords4[8] or 0)
	v.cords3_p=createPickup(v.cords3[1],v.cords3[2],v.cords3[3],3,1239,51,0)
	setElementDimension(v.cords3_p,v.cords2[7] or 0)
	setElementInterior(v.cords3_p,v.cords2[8] or 0)
end

addEventHandler("onPickupHit",resourceRoot,
	function(el)
		if (getElementType(el)~="player") or (isPedInVehicle(el)) then
			return
		end
		local z_m=nil
		for i,v in ipairs(pickups) do
			if (source==v.cords1_p) or (source==v.cords3_p) then
				z_m=v
			end
		end
		if (not z_m) then
			return
		end
		triggerClientEvent(el,"evc",resourceRoot,"open_window",z_m)
	end
)

addEventHandler("onPickupLeave",resourceRoot,
	function(el)
		if (getElementType(el)~="player") then
			return
		end
		local z_m=nil
		for i,v in ipairs(pickups) do
			if (source==v.cords1_p) or (source==v.cords3_p) then
				z_m=v
			end
		end
		if (not z_m) then
			return
		end
		triggerClientEvent(el,"evc",resourceRoot,"close_window")
	end
)

function isElementWithinPickup(theElement, thePickup)
	if (isElement(theElement) and getElementType(thePickup) == "pickup") then
		local x, y, z = getElementPosition(theElement)
		local x2, y2, z2 = getElementPosition(thePickup)
		if (getDistanceBetweenPoints3D(x2, y2, z2, x, y, z) <= 1.5) then
			return true
		end
	end
	return false
end

function opcja(plr)
	local z_m=nil
	for i,v in ipairs(pickups) do
		if (isElementWithinPickup(plr,v.cords1_p)) or (isElementWithinPickup(plr,v.cords3_p)) then
			z_m=v
		end
	end
	if (not z_m) then
		return
	end
	if (isPedInVehicle(plr)) then
		return
	end
	if (getElementDimension(plr)==z_m.cords2[7]) and (getElementInterior(plr)==z_m.cords2[8]) then
		triggerClientEvent(plr,"evc",resourceRoot,"close_window")
		fadeCamera(plr, false, 0.8)

		setTimer(function(plr)
			if (isPedInVehicle(plr)) then
				removePedFromVehicle(plr)
			end
			setElementFrozen(plr,true)
			setElementDimension(plr,z_m.cords4[7] or 0)
			setElementInterior(plr,z_m.cords4[8] or 0)
			setElementPosition(plr,z_m.cords4[1],z_m.cords4[2],z_m.cords4[3])
		end, 800, 1,plr)
		setTimer(function(plr)
			fadeCamera(plr, true)
			setElementRotation(plr,z_m.cords4[4],z_m.cords4[5],z_m.cords4[6])
			setCameraTarget(plr, plr)

			triggerClientEvent(plr,"evc",resourceRoot,"close_window")
			setElementFrozen(plr,false)

		end, 3000, 1,plr)
	elseif (getElementDimension(plr)==z_m.cords4[7]) and (getElementInterior(plr)==z_m.cords4[8]) then
		triggerClientEvent(plr,"evc",resourceRoot,"close_window")
		fadeCamera(plr, false, 0.8)
		setTimer(function(plr)
			if (isPedInVehicle(plr)) then
				removePedFromVehicle(plr)
			end
			setElementFrozen(plr,true)
			setElementDimension(plr,z_m.cords2[7] or 0)
			setElementInterior(plr,z_m.cords2[8] or 0)
			setElementPosition(plr,z_m.cords2[1],z_m.cords2[2],z_m.cords2[3])
		end, 800, 1,plr)
		setTimer(function(plr)
			fadeCamera(plr, true)
			setElementRotation(plr,z_m.cords2[4],z_m.cords2[5],z_m.cords2[6])
			setCameraTarget(plr, plr)
			triggerClientEvent(plr,"evc",resourceRoot,"close_window")
			setElementFrozen(plr,false)
		end, 3000, 1,plr)
	else

	end
end

addEvent("evs",true)
addEventHandler("evs",resourceRoot,
	function(ev)
		if (ev=="wlacz_opcje_wchodzenia") then
			bindKey(client,"space","down",opcja,client)
		elseif (ev=="wylacz_opcje_wchodzenia") then
			unbindKey(client,"space","down",opcja)
		end
	end
)
