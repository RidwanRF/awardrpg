local vals = {
	owner = nil,
	warp = true,
	pos = nil,
	players = {},
	vehs = {},
}

addCommandHandler ("mp", function(pl)
	if not isAdmin(pl) then return end
	triggerClientEvent (pl, "drawGUI", resourceRoot, vals)
end)

addCommandHandler ("tpmp", function(pl)
	if not vals.pos or not vals.owner then return end
	if not vals.warp then
		pl:outputChat ("Телепорт на МП закрыт", 255, 0, 0)
		return
	end
	
	local prevPos = pl.position
	local t = toJSON ({prevPos.x, prevPos.y, prevPos.z}, true)
	
	pl:setData ("mp:lastPos", t)
	if pl.vehicle then
		pl.vehicle.velocity = Vector3 (0, 0, 0)
		pl.vehicle.frozen = true
		pl.vehicle.locked = true
		removePedFromVehicle (pl)
	end
	
	setElementPosition (pl, vals.pos + Vector3 (math.random(-2, 2), math.random(-2, 2), 0), true)
	pl:outputChat ("Вы телепортировались на МП", 0, 255, 0)
	
	table.insert (vals.players, pl)
	updateListAdmin ()
end)

addCommandHandler ("nomp", function(pl)
	local lastPos = pl:getData ("mp:lastPos")
	
	if lastPos and type(fromJSON (lastPos)) == "table" then
		local t = fromJSON (lastPos)
		setElementPosition (pl, Vector3 (t[1], t[2], t[3]), true)
		
		pl:setData ("mp:lastPos", nil)
		
		local i = getIndexPlayer (pl)
		if not i then return end
		table.remove (vals.players, i)
		updateListAdmin ()
		
		pl:outputChat ("Вы покинули МП", 255, 0, 0)
	end
end)

addEvent ("event", true)
addEventHandler ("event", resourceRoot, function(arg1, arg2)
	if arg1 == "mp" then
		if arg2 == "create" then
			if vals.owner then client:outputChat ("МП уже кто-то проводит", 255, 0, 0) return end
			vals.owner = (client.name):gsub("#%x%x%x%x%x%x", "")
			vals.pos = Vector3(client.position)
			outputChatBox ("МП началось!", root, 255, 200, 0, true)
			if vals.warp then
				outputChatBox ("/tpmp чтобы отправиться на МП!", root, 255, 200, 0, true)
			end
		elseif arg2 == "delete" then
			if not vals.owner then return end
			vals.owner = nil
			vals.pos = nil
			for i, v in ipairs (vals.players) do
				kickPlayer (v)
			end
			outputChatBox ("МП окончено!", root, 255, 200, 0, true)
		end
	elseif arg1 == "warp" then
		if not vals.owner then return end
		vals.warp = not vals.warp
		outputChatBox ("Телепорт на МП: "..(vals.warp and "#00FF00открыт #FFCC00(/tpmp)" or "#FF0000закрыт"), root, 255, 200, 0, true)
	elseif arg1 == "hp" then
		local hp = 100
		if arg2 then
			if tonumber(arg2) then
				hp = tonumber(arg2)
			end
		end
		for i, v in ipairs (vals.players) do
			v.health = hp
			v:outputChat ("Вам пополнили HP", 0, 255, 0)
		end
	elseif arg1 == "armor" then
		local val = 100
		if arg2 then
			if tonumber(arg2) then
				val = tonumber(arg2)
			end
		end
		for i, v in ipairs (vals.players) do
			v.armor = val
			v:outputChat ("Вам пополнили Броню", 0, 255, 0)
		end
	elseif arg1 == "kick" then
		if not arg2 then
			client:outputChat ("Вы не выбрали игрока", 255, 0, 0)
			return
		end
		kickPlayer (vals.players[tonumber(arg2 + 1)])
	elseif arg1 == "veh" then
		if not arg2 or arg2 and not tonumber(arg2) then
			client:outputChat ("Вы не ввели ID машины", 255, 0, 0)
			return
		end
		for i, v in ipairs (vals.players) do
			local pos = v.position
			local veh = createVehicle (tonumber(arg2), pos)
			warpPedIntoVehicle (v, veh)
			vals.vehs[v] = veh
			
			veh:setData ("licensep", "h-МП")
		end
	end
	updateListAdmin ()
end)

function kickPlayer (pl)
	local lastPos = pl:getData ("mp:lastPos")
	
	if lastPos and type(fromJSON (lastPos)) == "table" then
		local t = fromJSON (lastPos)
		setElementPosition (pl, Vector3 (t[1], t[2], t[3]), true)
		
		pl:setData ("mp:lastPos", nil)
		
		local i = getIndexPlayer (pl)
		if not i then return end
		table.remove (vals.players, i)
		updateListAdmin ()
		
		pl:outputChat ("Вас выгнали с МП", 255, 0, 0)
		
		if vals.vehs[pl] then
			destroyElement (vals.vehs[pl])
		end
	end
end

addEventHandler ("onPlayerQuit", root, function()
	local i = getIndexPlayer (source)
	if not i then return end
	table.remove (vals.players, i)
	updateListAdmin ()
end)

function updateListAdmin ()
	triggerClientEvent (root, "mp:updateList", resourceRoot, vals)
end

function isAdmin(pl)
	local groups = {"GLAdmin"}
	for i, v in ipairs (groups) do
        if isObjectInACLGroup("user."..pl.account.name, aclGetGroup(v)) then
           return true
        end
	end
	return false
end

function getIndexPlayer (pl)
	for i, v in ipairs (vals.players) do
		if v == pl then
			return i
		end
	end
	return false
end