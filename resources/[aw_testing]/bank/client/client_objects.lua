
createBlip(1411.91, -1699.78, 15.20, 16, 2, 255,255,255,255, 0, 300)

local ATMdata = {
	{	-- банк возле мэрии в лс
		name = "Банк CCDPlanet", blip = false,
		location = {posX = 361.829, posY = 173.618, posZ = 1008.382, markerSize = 2, interior = 3}
	},{	-- банкомат в помещении банка в ЛС
		name = "Банкомат CCDPlanet #1", blip = false,
		location = {posX = 360.075, posY = 188.584, posZ = 1008.382, ATM = true, ATMRot = 0, interior = 3}
	},{	-- банкомат в помещении банка в ЛС
		name = "Банкомат CCDPlanet #2", blip = false,
		location = {posX = 364.075, posY = 188.584, posZ = 1008.382, ATM = true, ATMRot = 0, interior = 3}
	},
	{	-- банк в эдово
		name = "Банк CCDPlanet, сельское отделение #1",
		location = {posX = 2310.985, posY = -9.282661, posZ = 26.742, markerSize = 2}
	},
	{	-- банк в селе ЛВ
		name = "Банк CCDPlanet, сельское отделение #2",
		location = {posX = -828.335, posY = 1503.145, posZ = 19.633, markerSize = 2}
	},
	{	-- в райончике китайских магазинов
		name = "Банкомат CCDPlanet #3",
		location = {posX = 2630.666, posY = 1655.393, posZ = 11.023, ATM = true, ATMRot = 180}
	},
	{	-- возле спавна
		name = "Банкомат CCDPlanet #4",
		location = {posX = -1981.185, posY = 141.0, posZ = 27.687, ATM = true, ATMRot = 90}
	},
	{	-- заправка на трассе справа внизу
		name = "Банкомат CCDPlanet #5",
		location = {posX = -1557.328, posY = -2736.244, posZ = 48.743, ATM = true, ATMRot = 35}
	},
	{	-- азиатский автосалон
		name = "Банкомат CCDPlanet #7",
		location = {posX = -1648.794, posY = 1203.2, posZ = 7.25, ATM = true, ATMRot = 180}
	},
	{	-- дорогие авто
		name = "Банкомат CCDPlanet #8",
		location = {posX = 1026.238, posY = 1028.0, posZ = 11, ATM = true, ATMRot = 235}
	},
	{	-- автосалон тойоты
		name = "Банкомат CCDPlanet #9",
		location = {posX = 1068.0, posY = 1721.3, posZ = 10.820, ATM = true, ATMRot = 0}
	},
	{	-- бургер возле американского салона
		name = "Банкомат CCDPlanet #10",
		location = {posX = 1878.450, posY = 2074.1, posZ = 11.062, ATM = true, ATMRot = 0}
	},
	{	-- возле мотосалона
		name = "Банкомат CCDPlanet #11",
		location = {posX = 2140.1, posY = -1163.265, posZ = 23.992, ATM = true, ATMRot = -90}
	},
	{	-- возле б/у
		name = "Банкомат CCDPlanet #12",
		location = {posX = 1723.2, posY = -1141.423, posZ = 24.085, ATM = true, ATMRot = 270}
	},
	{	-- возле жертвы
		name = "Банкомат CCDPlanet #13",
		location = {posX = 456.1, posY = -1487.059, posZ = 31.083, ATM = true, ATMRot = 70}
	},
	{	-- сзади бургера
		name = "Банкомат CCDPlanet #14",
		location = {posX = 791, posY = -1614.029, posZ = 13.382, ATM = true, ATMRot = 90}
	},

	{	-- на ЕКХ2
		name = "Банкомат CCDPlanet #66",
		location = {posX = 1396.12, posY = 664.48, posZ = 10.9, ATM = false, ATMRot = 0}
	},
	{	-- в заброшенном аэропорту
		name = "Банкомат CCDPlanet #16",
		location = {posX = 414.542, posY = 2533.53, posZ = 16.578, ATM = true, ATMRot = 0}
	},
	{	-- на СТО в ЛВ
		name = "Банкомат CCDPlanet #17",
		location = {posX = 2872.8, posY = 2242.135, posZ = 12.143, ATM = true, ATMRot = 90}
	},
	{	-- возле тонера в порту ЛС
		name = "Банкомат CCDPlanet #18",
		location = {posX = 2503.5, posY = -2561.909, posZ = 13.648, ATM = true, ATMRot = 90}
	},

	{	-- работа автобусника в ЛС
		name = "Банкомат CCDPlanet #20",
		location = {posX = 1528.5, posY = 2355.714, posZ = 10.820, ATM = true, ATMRot = -90}
	},
	{	-- Заправка возле казино
		name = "Банкомат CCDPlanet #21",
		location = {posX = 2108.161, posY = 897.4, posZ = 11.179, ATM = true, ATMRot = 180}
	},
	{	-- Заправка возле штрафов ЛВ
		name = "Банкомат CCDPlanet #22",
		location = {posX = 2188.3, posY = 2478.569, posZ = 11.242, ATM = true, ATMRot = -90}
	},

	{	-- Новое ЕКХ 1
		name = "Банкомат CCDPlanet #24",
		location = {posX = -1945.189, posY = -866.5, posZ = 32.218, ATM = true, ATMRot = 180}
	},
	{	-- Новое ЕКХ 2
		name = "Банкомат CCDPlanet #25",
		location = {posX = -1964.350, posY = -851.2, posZ = 32.226, ATM = true, ATMRot = 0}
	},
	{	-- SPAWN
		name = "Банкомат CCDPlanet #26",
		location = {posX = -2039.797, posY = 1819.72, posZ = 5.1, ATM = true, ATMRot = 70}
	},
	{	-- Containers
		name = "Банкомат CCDPlanet #27",
		location = {posX = -1457.4455566406, posY = -509.75933837891, posZ = 14.17760848999, ATM = true, ATMRot = -30}
		---1457.4455566406, -510.75933837891, 14.17760848999
	},
	{	-- Casino
		name = "Банкомат CCDPlanet #28",
		location = {posX = 2021.953, posY =  999.5, posZ = 10.85, ATM = true, ATMRot = 180}
	},
	{	-- Donate baza#1
		name = "Банкомат CCDPlanet #29",
		location = {posX = 2843.4162597656, posY =  1294.3376464844, posZ = 11.43, ATM = false, ATMRot = 0}
	},

	{	-- JOB HELI
		name = "Банкомат CCDPlanet #30",
		location = {posX = 1855.5, posY =  -2410.94921875, posZ = 13.62, ATM = true, ATMRot = 90}
	},

}

local ATMmarkers = {}
local warpMarkers = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	for id, atm in ipairs(ATMdata) do
		if (atm.location) then
			local marker = createMarker(atm.location.posX, atm.location.posY, atm.location.posZ-1, "cylinder", (atm.location.markerSize or 1), 255,232,61, 100)--250,0,0
			setElementInterior(marker, atm.location.interior or 0)
			ATMmarkers[marker] = id
			if (atm.location.ATM) then
				local x, y, z, rotRad = atm.location.posX, atm.location.posY, atm.location.posZ-0.35, math.rad(atm.location.ATMRot)
				x = x + math.sin(rotRad) * 0.6
				y = y + math.cos(rotRad) * 0.6
				local atmObj = createObject(2942, x, y, z, 0, 0, (360-atm.location.ATMRot) ) 
				setElementInterior(atmObj, atm.location.interior or 0)
				setElementCollisionsEnabled(atmObj, false)
			end
		end
		if defaultTrue(atm.blip) then
			createBlip(atm.location.posX, atm.location.posY, atm.location.posZ, 15, 2, 255,255,255,255, 0, 300)
		end
	end
end)

addEventHandler("onClientMarkerHit", resourceRoot, function(hitPlayer, matchingDimension)
	if (hitPlayer == localPlayer) and (matchingDimension) and not getPedOccupiedVehicle(localPlayer) then
		local _, _, pZ = getElementPosition(localPlayer)
		local _, _, mZ = getElementPosition(source)
		if (pZ-mZ < 5) and (pZ > mZ) then
			if (ATMmarkers[source]) then
				local atm = ATMdata[ ATMmarkers[source] ]
				setVisible(true)
			end
		end
	end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(leavePlayer, matchingDimension)
	if (leavePlayer == localPlayer) and (matchingDimension) and not getPedOccupiedVehicle(localPlayer) and (ATMmarkers[source]) then
		setVisible(false)
	end
end)


-- ==========     Переход из тернарной логики в бинарную     ==========
function defaultFalse(arg)
	return arg or false
end
function defaultTrue(arg)
	return (arg == nil) or arg
end
