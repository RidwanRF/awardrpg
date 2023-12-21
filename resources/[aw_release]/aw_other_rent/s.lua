local Timer = 10000
addEvent("onVehicleDestroy", true)
PublicVehicles = {}
PublicVehicles.__index = PublicVehicles

function PublicVehicles:new(...)
	local instance = {}
	setmetatable(instance, PublicVehicles)
	if PublicVehicles:constructor(...) then
		return instance
	end
	return false
end

function PublicVehicles:constructor(...)
	self.func = {}
	self.timer = {}
	self.place = {}
	self.rent = {}
	self.func.onVehicleStartEnter = function(player, seat) self:onVehicleStartEnter(player, source, seat) end
	self.func.onPlayerQuit = function() self:onPlayerQuit(source) end
	self.func.isEmptyPlace = function() self:isEmptyPlace() end
	self.func.loadCoroutine = function() self:coroutineEmpty() end
	self.func.onVehicleDestroy = function() self:destroyElement(client) end

	setTimer(self.func.isEmptyPlace, Timer, 1)
	addEventHandler("onPlayerQuit", getRootElement(), self.func.onPlayerQuit)
	addEventHandler("onVehicleStartEnter", resourceRoot, self.func.onVehicleStartEnter)
	addEventHandler("onVehicleDestroy", root, self.func.onVehicleDestroy)

	return true
end

function PublicVehicles:onVehicleStartEnter(player, source, seat)
	if (seat == 0 and self.rent[player] and self.rent[player] ~= source) then
		-- уведомление вы уже взяли мопед напрокат
		exports.aw_interface_notify:showInfobox(source, "info", "Аренда транспорта", "Вы уже взяли транспорт в аренду!", getTickCount(), 8000)
		cancelEvent()
	elseif seat == 0 and getElementData(source, "publicOwner") and getElementData(source, "publicOwner") ~= getPlayerName(player) then
		-- уведомление вы не взяли этот мопед напрокат
		exports.aw_interface_notify:showInfobox(source, "info", "Аренда транспорта", "Не вы взяли этот транспорт в аренду!", getTickCount(), 8000)
		cancelEvent()
	elseif seat == 0 and not self.rent[player] then
		self.rent[player] = source
		setElementData(source, "publicOwner", getPlayerName(player))
		source:setFrozen(false)
	end
end


function PublicVehicles:destroyElement(player)
	if self.rent[player] and isElement( self.rent[player] ) then
		destroyElement(self.rent[player])
	end
	self.rent[player] = nil
end

function PublicVehicles:createVehicle(...)
	local veh = createVehicle(arg[1], arg[2], arg[3], arg[4]-0.4, 0, 0, arg[5])
	setElementInterior(veh, arg[7] or 0)
	setElementDimension(veh, arg[8] or 0)
	setElementFrozen(veh, true)
end

function PublicVehicles:isEmptyPlace()
	if self.coroutine == nil or coroutine.status(self.coroutine) == "dead" then
		self.coroutine = coroutine.create(self.func.loadCoroutine)
		coroutine.resume(self.coroutine)
	end
end


function PublicVehicles:coroutineEmpty()
	for i,v in ipairs(self.place) do
		local sphere = createColSphere(v.x, v.y, v.z, 1)
		if #getElementsWithinColShape(sphere) < 1 then
			self:createVehicle(v.model, v.x, v.y, v.z, v.angle, v.interior, v.dimension)
		end
		destroyElement(sphere)
		if i%5 == 0 then
			setTimer(function() coroutine.resume(self.coroutine) end, 1000, 1)
			coroutine.yield()
		end
	end
	self.coroutine = nil
	if self.coroutine == nil or coroutine.status(self.coroutine) == "dead" then
		if isTimer(self.func.isEmptyPlace) then killTimer( self.func.isEmptyPlace ) end
		setTimer(self.func.isEmptyPlace, Timer, 1)
		collectgarbage()
	end
end


function PublicVehicles:createPlace(model, x, y, z, angle, interior, dimension, showBlip)
	PublicVehicles:createVehicle(model, x, y, z, angle, interior, dimension)
	table.insert(self.place, {model = model, x = x, y = y, z = z, angle = angle, interior = interior, dimension = dimension})
    if showBlip then
        local blip = createBlip(x, y, z, 0, 2, 255, 153, 153, 255)
        setElementData(blip, "icon", 37)
    end
end

function PublicVehicles:onPlayerQuit()
	if self.rent[source] and isElement(self.rent[source]) then
		destroyElement(self.rent[source])
		self.rent[source] = nil
	end
	if isTimer(self.timer[source]) then
		killTimer(self.timer[source])
	end
end



vehicles = PublicVehicles:new()
vehicles:createPlace(462, 2824.6232910156,1293.4660644531,10.770564079285, -90, 0) 
vehicles:createPlace(462, 2824.6232910156,1296.4660644531,10.770564079285, -90, 0) 