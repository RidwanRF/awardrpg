

local _createVehicle = createVehicle
function createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    local veh
    if model >= 400 and model <= 611 then
        veh = _createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    else
        veh = _createVehicle(411, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    end

    setElementData(veh, "vehicle:model", model)
end


local players = {}

local positions = {

	[1] = {
		body = {2348.6999511719, 2748, 13.5, 0, 0, 270},
		gate1 = {2355, 2747.8999023438, 13.5, 0, 0, 270},
		gate2 = {2355, 2748, 13.5, 0, 0, 270},
		markerOut = {2356.1000976562, 2748.6999511719, 11.60000038147, "cylinder", 1, 79, 70, 229, 75},
		markerIn = {2355.6000976562, 2746.8000488281, 11.60000038147, "cylinder", 0, 55, 55, 55, 75},
		vehicle = {2349, 2747.8999023438, 12.699999809265, 0, 0, 270},
	},
	[2] = {
		body = {2348.6999511719, 2766.8, 13.5, 0, 0, 270},
		gate1 = {2355, 2766.6999511719, 13.5, 0, 0, 270},
		gate2 = {2355, 2766.8000488281, 13.5, 0, 0, 270},
		markerOut = {2356.1000976562, 2767.6000976562, 11.60000038147, "cylinder", 1, 79, 70, 229, 75},
		markerIn = {2355.6000976562, 2765.6999511719, 11.60000038147, "cylinder", 0, 55, 55, 55, 75},
		vehicle = {2349, 2747.8999023438, 12.699999809265, 0, 0, 270},
	},
	[3] = {
		body = {2348.6999511719, 2780.3999023438, 13.5, 0, 0, 269.19689941406},
		gate1 = {2355, 2780.3000488281, 13.5, 0, 0, 270},
		gate2 = {2355, 2780.3999023438, 13.5, 0, 0, 270},
		markerOut = {2356.1000976562, 2781, 11.60000038147, "cylinder", 1, 79, 70, 229, 75},
		markerIn = {2355.6000976562, 2779.1999511719, 11.60000038147, "cylinder", 0, 55, 55, 55, 75},
		vehicle = {2349, 2780.3000488281, 12.699999809265, 0, 0, 270},
	},
	[4] = {
		body = {2368.1000976562, 2752.6999511719, 13.5, 0, 0, 180},
		gate1 = {2368.1000976562, 2746.3999023438, 13.5, 0, 0, 180},
		gate2 = {2368, 2746.3999023438, 13.5, 0, 0, 180},
		markerOut = {2368.8999023438, 2745.3999023438, 11.60000038147, "cylinder", 1, 79, 70, 229, 75},
		markerIn = {2366.8999023438, 2745.6000976562, 11.60000038147, "cylinder", 0, 55, 55, 55, 75},
		vehicle = {2368.1000976562, 2752.1000976562, 12.699999809265, 0, 0, 180},
	},
	[5] = {
		body = {2400.1999511719, 2752.6999511719, 13.5, 0, 0, 179.99450683594},
		gate1 = {2400.1999511719, 2746.3999023438, 13.5, 0, 0, 180},
		gate2 = {2400.1999511719, 2746.3999023438, 13.5, 0, 0, 180},
		markerOut = {2401.1000976562, 2745.3999023438, 11.60000038147, "cylinder", 1, 79, 70, 229, 75},
		markerIn = {2398.8999023438, 2745.6000976562, 11.60000038147, "cylinder", 0, 55, 55, 55, 75},
		vehicle = {2400.1999511719, 2752.1000976562, 12.699999809265, 0, 0, 180},
	},

}

local containers = {
	vehicle = {
		[1] = { -- АВТОМОБИЛИ эконом

		    {model = 429, price = 7000000000,chance = 0.01},
			{model = 480, price = 3500000000,chance = 0.2},
			{model = 477, price = 950000000,chance = 0.7},
			{model = 541, price = 750000000,chance = 0.9},
			{model = 560,price = 830000000, chance = 1.3},
			{model = 602,price = 390000000, chance = 3.1},

		},
		[2] = { -- АВТОМОБИЛИ USA

		{model = 429, price = 7000000000,chance = 0.01},
		{model = 480, price = 3500000000,chance = 0.2},
		{model = 477, price = 950000000,chance = 0.7},
		{model = 541, price = 750000000,chance = 0.9},
		{model = 560,price = 830000000, chance = 1.3},
		{model = 602,price = 390000000, chance = 3.1},
		},
		[3] = { -- АВТОМОБИЛИ DUBAI

		{model = 429, price = 7000000000,chance = 0.01},
		{model = 480, price = 3500000000,chance = 0.2},
		{model = 477, price = 950000000,chance = 0.7},
		{model = 541, price = 750000000,chance = 0.9},
		{model = 560,price = 830000000, chance = 1.3},
		{model = 602,price = 390000000, chance = 3.1},

		},
	},
	antiques = {
		[1] = {
			{name = "Ваза «Викторианский мотив»", price = 25000, chance = 0.9},
			{name = "Каминные часы «Пастораль»", price = 19000, chance = 0.7},	
		},
		[2] = {
			{name = "Карманные золотые часы «Мозер»", price = 160000, chance = 0.55},
			{name = "Фарфоровые каминные часы «Royal Bonn»", price = 150000, chance = 0.67},
		},
		[3] = {
			{name = "Часы Rolex «белое золото с брилиантами»", price = 1000000, chance = 0.15},
			{name = "Вино Screaming Eagle", price = 800000, chance = 0.11},
		},
	},
	cloth = { 
		[1] = {  
			{name = "Burberry", price = 15000, chance = 0.4},  
			{name = "Prada", price = 19000, chance = 0.6},  
		}, 
		[2] = { 
			{name = "Zara", price = 60000, chance = 0.5},  
			{name = "Giorgio Armani", price = 90000, chance = 0.6}, 
			{name = "Dior", price = 65000, chance = 0.7},  
			{name = "Burberry", price = 55000, chance = 0.5},  
			{name = "Louis Vuitton", price = 55000, chance = 0.4}, 
		}, 
		[3] = { 
			{name = "Columbia", price = 200000, chance = 0.5}, 
			{name = "Givenchy", price = 340000, chance = 0.8}, 
			{name = "Kenzo", price = 450000, chance = 0.7},  
		}, 
	},
	technique = { 
		[1] = { 
			{name = "Miele", price = 15000, chance = 0.2}, 
			{name = "Thomas", price = 12000, chance = 0.4}, 
			{name = "Hansa", price = 10000, chance = 0.8},  
		}, 
		[2] = {  
			{name = "Sunny", price = 55000, chance = 0.55}, 
			{name = "Samsung", price = 70000, chance = 0.25}, 
			{name = "LG", price = 90000, chance = 0.35},  
		}, 
		[3] = { 
			{name = "Toshiba", price = 90000, chance = 0.3},  
			{name = "Panasonic", price = 200000, chance = 0.15}, 
			{name = "Sony", price = 500000, chance = 0.15}, 
			{name = "Kenwood", price = 350000, chance = 0.3},  
		},
	},
}


local array = {
	[1] = {"vehicle", 0.25},
--	[2] = {"antiques", 0.5},
--	[3] = {"technique", 0.8},
--	[4] = {"cloth", 0.9},
}

local prices = {
	[1] = {800000000, 2000000000},
	[2] = {800000000, 2000000000},
	[3] = {800000000, 2000000000},
}

getRandomContainerTypeItem = function ()
	local randomType = math.random(1, #array)
	local item = array[randomType]
	local chance = tonumber(item[2])
	local randomNumber = math.random(0,100)+(math.random(0,100)/100)
	if randomNumber <= chance then
		return item[1]
	end
end

getRandomContainerItem = function (randomType, type)
	local randomItem = math.random(1, #containers[randomType][type])
	local item = containers[randomType][type][randomItem]
	local chance = tonumber(item.chance)
	local randomNumber = math.random(0,100)+(math.random(0,100)/100)
	if randomNumber <= chance then
		return item
	end
end

getRandomTableContainer = function (type)
	local arrayM = {}
	for i = 1, 9 do
		local randomType = nil
		if i == 1 then repeat randomType = getRandomContainerTypeItem() until randomType ~= nil end
		if i ~= 1 then repeat randomType = getRandomContainerTypeItem() until randomType ~= nil and randomType ~= "vehicle" end
		if i == 1 and randomType == "vehicle" then
			repeat item = getRandomContainerItem(randomType, type) until item ~= nil
			local model = item.model
			local modelInfo = item.chance
			local price = item.price
    		local name = exports.car_system:getVehicleModName(model)
    		table.insert(arrayM, {model = model, type = "vehicle", name = name, pricePort = price - price*0.2, priceOriginal = price})
    		return arrayM
    	else
    		repeat item = getRandomContainerItem(randomType, type) until item ~= nil
    		table.insert(arrayM, {type = randomType, name = item.name, pricePort = item.price - item.price*0.2, priceOriginal = item.price})
		end
	end
	return arrayM
end


getPriceRandomContainer = function (items)
	local price = 0
	for i,v in pairs(items) do
		price = price + v.pricePort
	end
	local random = math.random(1, 2)
	if random == 1 then
		local rand = math.random(100, 200)
		price = price + price*tonumber(rand/1000)
	else
		local rand = math.random(300, 400)
		price = price - price*tonumber(rand/1000)
	end
	return math.floor(price)
end

isContainer = function (id)
	for i,v in pairs(getElementsByType("marker")) do
		local data = getElementData(v, "container:data")
		if data and tonumber(data.ID) == tonumber(id) then
			return v
		end
	end
	return false
end

local timers = {}
local deletes = {}
local times = {}

spawnContainer = function (id)
	if isContainer(id) then
		local data = getElementData(isContainer(id), "container:data")
		if data.owner == "sell" then
			data.destroy = 120
			data.type = math.random(1, 3)
			data.items = getRandomTableContainer(data.type)
			data.startPrice = math.random(prices[data.type][1], prices[data.type][2])
			data.currentPrice = data.startPrice 
			setElementData(data.body, "container", data.type)
			setElementData(data.gate1, "container", data.type)
			setElementData(data.gate2, "container", data.type)
			setElementData(data.markerOut, "container:data", data)
			setElementData(data.markerIn, "container:data", data)
		end
	else
		local v = positions[id]
		local data = {}
		data.ID = id
		data.owner = "sell"
		data.type = math.random(1, 3)
		data.items = getRandomTableContainer(data.type)
		data.startPrice = math.random(prices[data.type][1], prices[data.type][2])
		data.currentPrice = data.startPrice 
		data.destroy = 120
		data.markerOut = createMarker(unpack(v.markerOut))
		data.markerIn = createMarker(unpack(v.markerIn))
		data.body = createObject(2555, unpack(v.body))
		setElementData(data.body, "container", data.type)
		data.gate1 = createObject(1867, unpack(v.gate1))
		data.gate2 = createObject(1868, unpack(v.gate2))
		setElementData(data.gate1, "container", data.type)
		setElementData(data.gate2, "container", data.type)
		setElementData(data.markerOut, "container:data", data)
		setElementData(data.markerIn, "container:data", data)
	end
	if isTimer(timers[id]) then killTimer(timers[id]) end
	timers[id] = setTimer(function ()
		local v = isContainer(id)
		local data = getElementData(v, "container:data")
		if data then
			if (data.destroy) then
				if (data.destroy) >= 1 then
					data.destroy = tonumber(data.destroy or 120) - 1
					setElementData(v, "container:data", data)
				else
					spawnContainer(id)
				end
			end
			if (data.time) then
				if (data.time) >= 1 then
					data.time = tonumber(data.time or 30) - 1
					setElementData(v, "container:data", data)
				else
					local container = getElementData(v, "container:data")
					if container.stopped then return end
					container.stopped = true
					setElementData(v, "container:data", container)
	    			local owner = getPlayerFromName(container.owner)
					triggerClientEvent(root, "ContainerWindowClose", root)
	    			if isElement(owner) then

	    				triggerEvent("takeContainerMoney", resourceRoot, owner, container.currentPrice)
	    				destroyElement(container.gate2)
	    				destroyElement(container.gate1)
						
	    				if #container.items == 1 then
						--	--container.vehicle = createVehicle(container.items[1].model, unpack(positions[tonumber(container.ID)].vehicle))
						--	setVehicleLocked(container.vehicle, true)
						--	setTimer(setElementFrozen, 500, 1, container.vehicle, true)
						end
	    				setElementData(container.markerIn, "container:data", container)
	    				setElementData(container.markerOut, "container:data", container)
						exports.aw_interface_notify:showInfobox(source, "info", "Контейнеры", "У вас есть 2 минуты, чтобы решить что делать с этим контейнером!", getTickCount(), 8000)
	    				deletes[container.ID] = setTimer(function ()
	    					destroyContainer(container.ID)
	    				end, 600000, 1)
	    			end
				end
			end
		end
	end, 1000, 0)
end


createContainer = function ()
	for i = 1, #positions do
		spawnContainer(i)
	end
	outputChatBox ( "#f2ad4a[Аукцион контейнеров Las-Venturas] #FFFFFFПриехала новая партия контейнеров, поспешите сделать ставку!", source, _,_,_, true )
end
timeconnen = function ()
	outputChatBox ( "#f2ad4a[Аукцион контейнеров Las-Venturas] #FFFFFFЧерез 5 минут будет спавн новых контейнеров", source, _,_,_, true )
end
createContainer()
setTimer(timeconnen, 600000, 0)
setTimer(createContainer, 900000, 0)
addCommandHandler("refcontainers", createContainer, true)

destroyContainer = function (id)
	if isTimer(deletes[id]) then killTimer(deletes[id]) end
	for i,v in pairs(getElementsByType("marker")) do
		if isElement(v) then
			local container = getElementData(v, "container:data")
			if container and tonumber(container.ID) == tonumber(id) then
				if isElement(container.body) then destroyElement(container.body) end
				if isElement(container.gate1) then destroyElement(container.gate1) end
				if isElement(container.gate2) then destroyElement(container.gate2) end
				if isElement(container.vehicle) then destroyElement(container.vehicle) end
				if isElement(container.markerOut) then destroyElement(container.markerOut) end
				if isElement(container.markerIn) then destroyElement(container.markerIn) end
				if isTimer(timers[id]) then killTimer(timers[id]) end
			end
		end
	end
end
addEvent("destroyContainer", true)
addEventHandler("destroyContainer", root, destroyContainer)

addEventHandler("onPlayerQuit", root, function ()
	for i,v in pairs(getElementsByType("marker")) do
		local data = getElementData(v, "container:data")
		if data and tostring(data.owner) == getPlayerName(source) then
			destroyContainer(data.ID)
		end
	end
end)

createBlip(2358.9382324219,2757.8601074219,10.8203125, 28, 1, 255, 255, 255, 255, 0, 400)

addEvent("givePlayerContainerVehicle", true)
addEventHandler("givePlayerContainerVehicle", root, function (player, model, paintjob)
	exports.car_system:addBase(player, model, paintjob or nil, 255, 255, 255, 255, 255, 255, math.random(10, 99))
end)


addEvent("takeContainerMoney", true)
addEventHandler("takeContainerMoney", resourceRoot, function (player, amount)
	local account = getPlayerAccount(player)
	exports.bank:takePlayerBankMoney(player, amount, "RUB")
end)

addEvent("giveContainerMoney", true)
addEventHandler("giveContainerMoney", resourceRoot, function (player, amount)
	local account = getPlayerAccount(player)
	exports.bank:giveAccountBankMoney(account, amount, "RUB")
end)