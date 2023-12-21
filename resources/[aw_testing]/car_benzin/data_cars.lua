
local fullEthanolMultiplier = 1.5

function getRefuelSpeedFromCapacity(capacity)
	if (capacity < 200) then
		return 5
	elseif (capacity < 500) then
		return 10
	elseif (capacity < 1000) then
		return 20
	else
		return 40
	end
end

fuels = {
	["AI92"]	= {price =  38.95, octane =  92, fType = "petrol",	name = "АИ-92"},
	["AI95"]	= {price =  42.25, octane =  95, fType = "petrol",	name = "АИ-95"},
	["AI98"]	= {price =  46.60, octane =  98, fType = "petrol",	name = "АИ-98"},
	["AI98plus"]= {price =  65.20, octane = 100, fType = "petrol",	name = "АИ-98+"},
	["E85"]		= {price = 440.00, octane = 105, fType = "petrol",	name = "E85"},
	
	["DT"]		= {price =  40.37, octane = 50,	fType = "diesel",	name = "ДТ"},
	["DTplus"]	= {price =  42.40, octane = 55,	fType = "diesel",	name = "ДТ+"},
	
	["A100"]	= {price =   5.80, octane = 100, fType = "electric", name = "A100"},
	["TC1"]		= {price =  39.00, octane = 40,	 fType = "other",	 name = "TC-1"},
}

local multipliersTable = {
	["AI92"]	= {
		{octane = 92, multiplier = 1},
		{octane = 95, multiplier = 1.04},
		{octane = 98, multiplier = 1.06},
		{octane = 100, multiplier = 1.09},
		{octane = 105, multiplier = 0.8},
	},
	["AI95"]	= {
		{octane = 92, multiplier = 0.95},
		{octane = 95, multiplier = 1},
		{octane = 98, multiplier = 1.04},
		{octane = 100, multiplier = 1.08},
		{octane = 105, multiplier = 1.07},
	},
	["AI98"]	= {
		{octane = 92, multiplier = 0.91},
		{octane = 95, multiplier = 0.97},
		{octane = 98, multiplier = 1},
		{octane = 100, multiplier = 1.06},
		{octane = 105, multiplier = 1.11},
	},
	["AI98plus"]	= {
		{octane = 92, multiplier = 0.87},
		{octane = 95, multiplier = 0.93},
		{octane = 98, multiplier = 0.97},
		{octane = 100, multiplier = 1},
		{octane = 105, multiplier = 1.15},
	},
	["DT"]		= {
		{octane = 50, multiplier = 1},
		{octane = 55, multiplier = 1.05},
	},
	["DTplus"]		= {
		{octane = 50, multiplier = 0.95},
		{octane = 55, multiplier = 1},
	},
}

carData = {
	-- Игрок
	[-1] = {tank = 35, 		consumption = 0,	fuel = "AI92",		maxSpd = 0},
	[0]	= {tank = 1337, 	consumption = 10,	fuel = "AI92",		maxSpd = 750},
	
	-- 4-дверные
	[400] = {tank = 85,		consumption = 22,	fuel = "AI98plus",	maxSpd = 284},
	[404] = {tank = 100,		consumption = 10,	fuel = "AI98plus",		maxSpd = 340},
	[405] = {tank = 100,		consumption = 17,	fuel = "AI98",		maxSpd = 280},
	[409] = {tank = 78,		consumption = 23,	fuel = "AI98",		maxSpd = 260},
	[418] = {tank = 70,		consumption = 23,	fuel = "AI98plus",	maxSpd = 260},
	[420] = {tank = 52,		consumption = 20,	fuel = "AI98",		maxSpd = 250},
	[421] = {tank = 100,		consumption = 9,	fuel = "AI92",		maxSpd = 340},
	[426] = {tank = 73,		consumption = 12,	fuel = "AI92",		maxSpd = 250},
	[438] = {tank = 78,		consumption = 23,	fuel = "AI98",		maxSpd = 260},
	[445] = {tank = 55,		consumption = 12,	fuel = "AI95",		maxSpd = 195},
	[458] = {tank = 80,		consumption = 20,	fuel = "AI98",		maxSpd = 290},
	[466] = {tank = 60,		consumption = 17,	fuel = "AI98",		maxSpd = 250},
	[467] = {tank = 70,		consumption = 17,	fuel = "AI95",		maxSpd = 220},
	[470] = {tank = 96,		consumption = 25,	fuel = "AI98",		maxSpd = 260},
	[479] = {tank = 80,		consumption = 19,	fuel = "AI98",		maxSpd = 340},
	[490] = {tank = 105,	consumption = 21,	fuel = "AI98",		maxSpd = 220},
	[492] = {tank = 75,		consumption = 22,	fuel = "AI98plus",	maxSpd = 290},
	[507] = {tank = 80,		consumption = 13,	fuel = "AI95",		maxSpd = 230},
	[516] = {tank = 100,	consumption = 22,	fuel = "AI95",		maxSpd = 200},
	[529] = {tank = 90,		consumption = 18,	fuel = "AI98plus",	maxSpd = 290},
	[540] = {tank = 80,		consumption = 25,	fuel = "AI95",		maxSpd = 210},
	[546] = {tank = 60,		consumption = 25,	fuel = "AI98plus",		maxSpd = 400},
	[547] = {tank = 43,		consumption = 10,	fuel = "AI95",		maxSpd = 210},
	[550] = {tank = 70,		consumption = 20,	fuel = "AI98",		maxSpd = 280},
	[551] = {tank = 90,		consumption = 19,	fuel = "AI98plus",	maxSpd = 325},
	[560] = {tank = 100,		consumption = 17,	fuel = "AI95",		maxSpd = 245},
	[561] = {tank = 100,		consumption = 18,	fuel = "AI98plus",	maxSpd = 250},
	[566] = {tank = 100,		consumption = 18,	fuel = "AI98",		maxSpd = 195},
	[567] = {tank = 100,	consumption = 21,	fuel = "AI95",		maxSpd = 235},
	[579] = {tank = 100,		consumption = 19,	fuel = "AI98",		maxSpd = 292},
	[580] = {tank = 100,		consumption = 20,	fuel = "AI98plus",	maxSpd = 285},
	[585] = {tank = 100,		consumption = 15,	fuel = "AI92",		maxSpd = 275},
	[596] = {tank = 100,		consumption = 16,	fuel = "AI98",		maxSpd = 235},
	[597] = {tank = 100,		consumption = 25,	fuel = "AI98",		maxSpd = 450},
	[598] = {tank = 100,		consumption = 25,	fuel = "AI98",		maxSpd = 290},
	[604] = {tank = 100,		consumption = 25,	fuel = "AI98",		maxSpd = 290},
	
	-- 2-дверные
	[401] = {tank = 100,		consumption = 16,	fuel = "AI92",		maxSpd = 200},
	[402] = {tank = 100,		consumption = 25,	fuel = "AI98",		maxSpd = 330},
	[410] = {tank = 100,		consumption = 10,	fuel = "AI92",		maxSpd = 230},
	[411] = {tank = 100,		consumption = 20,	fuel = "AI98",		maxSpd = 330},
	[412] = {tank = 100,		consumption = 32,	fuel = "AI98",		maxSpd = 370},
	[415] = {tank = 100,		consumption = 32,	fuel = "AI98",		maxSpd = 330},
	[419] = {tank = 100,		consumption = 8.6,	fuel = "AI92",		maxSpd = 135},
	[422] = {tank = 100,		consumption = 20,	fuel = "AI98plus",	maxSpd = 325},
	[424] = {tank = 100,		consumption = 20,	fuel = "AI98plus",	maxSpd = 255},
	[429] = {tank = 100,		consumption = 12,	fuel = "AI95",		maxSpd = 460},
	[434] = {tank = 100,		consumption = 24,	fuel = "AI98",		maxSpd = 290},
	[436] = {tank = 100,		consumption = 24,	fuel = "AI98",		maxSpd = 290},
	[439] = {tank = 100,		consumption = 23,	fuel = "AI92",		maxSpd = 325},
	[442] = nil,
	[444] = nil,
	[451] = {tank = 100,		consumption = 25,	fuel = "AI98",		maxSpd = 300},
	[457] = {tank = 100,		consumption = 6,	fuel = "AI92",		maxSpd = 100},
	[474] = {tank = 100,		consumption = 6,	fuel = "AI98",		maxSpd = 270},
	[475] = {tank = 100,		consumption = 20,	fuel = "AI95",		maxSpd = 225},
	[477] = {tank = 100,		consumption = 19,	fuel = "AI98",		maxSpd = 270},
	[478] = nil,
	[480] = {tank = 100,		consumption = 17,	fuel = "AI98plus",		maxSpd = 600},
	[489] = {tank = 100,	consumption = 25,	fuel = "AI98plus",		maxSpd = 310},
	[491] = {tank = 100,		consumption = 19,	fuel = "AI98plus",	maxSpd = 400},
	[494] = {tank = 100,		consumption = 19,	fuel = "AI98plus",	maxSpd = 300},
	[495] = {tank = 100,	consumption = 25,	fuel = "AI98",		maxSpd = 200},
	[496] = {tank = 100,		consumption = 10,	fuel = "AI92",		maxSpd = 240},
	[500] = {tank = 100,		consumption = 23,	fuel = "AI98",		maxSpd = 290},
	[502] = {tank = 100,		consumption = 23,	fuel = "AI98",		maxSpd = 350}, 
	[503] = {tank = 100,	consumption = 23,	fuel = "AI98plus",		maxSpd = 750}, 
	[504] = {tank = 100,	consumption = 23,	fuel = "AI98plus",		maxSpd = 425}, 
	[505] = {tank = 90,		consumption = 28,	fuel = "AI98plus",	maxSpd = 280},
	[506] = {tank = 90,		consumption = 28,	fuel = "AI98plus",	maxSpd = 600},
	[517] = {tank = 64,		consumption = 18,	fuel = "AI98",		maxSpd = 270},
	[518] = {tank = 43,		consumption = 13,	fuel = "AI92",		maxSpd = 335},
	[526] = {tank = 97,		consumption = 25,	fuel = "AI98",		maxSpd = 325},
	[527] = {tank = 60,		consumption = 18,	fuel = "AI98plus",	maxSpd = 280},
	[533] = {tank = 50,		consumption = 17,	fuel = "AI98",		maxSpd = 240},
	[534] = {tank = 70,		consumption = 27,	fuel = "AI92",		maxSpd = 295},
	[535] = {tank = 92,		consumption = 20,	fuel = "AI95",		maxSpd = 360},
	[536] = {tank = 82,		consumption = 28,	fuel = "AI98plus",	maxSpd = 395},
	[541] = {tank = 64,		consumption = 17,	fuel = "AI98plus",	maxSpd = 330},
	[542] = {tank = 90,		consumption = 30,	fuel = "AI98plus",	maxSpd = 335},
	[543] = {tank = 65,		consumption = 15,	fuel = "AI98",		maxSpd = 200},
	[545] = {tank = 100,		consumption = 25,	fuel = "AI98plus",		maxSpd = 425},
	[549] = {tank = 100,	consumption = 18,	fuel = "AI98",		maxSpd = 235},
	[554] = {tank = 100,	consumption = 18,	fuel = "AI98",		maxSpd = 235},
	[555] = {tank = 65,		consumption = 19,	fuel = "AI98",		maxSpd = 245},
	[556] = nil,
	[557] = nil,
	[558] = {tank = 65,		consumption = 19,	fuel = "AI98",		maxSpd = 245},
	[559] = {tank = 35,		consumption = 5,	fuel = "AI98plus",		maxSpd = 550},
	[562] = {tank = 60,		consumption = 16,	fuel = "AI98",		maxSpd = 165},
	[565] = {tank = 50,		consumption = 17,	fuel = "AI95",		maxSpd = 370},
	[575] = {tank = 100,		consumption = 17,	fuel = "AI95",		maxSpd = 230},
	[576] = {tank = 76,		consumption = 15,	fuel = "AI95",		maxSpd = 220},
	[587] = {tank = 50,		consumption = 10,	fuel = "AI92",		maxSpd = 200},
	[589] = {tank = 70,		consumption = 27,	fuel = "AI92",		maxSpd = 290},
	[599] = {tank = 87,		consumption = 25,	fuel = "AI98",		maxSpd = 280},
	[600] = nil,
	[602] = {tank = 52,		consumption = 14,	fuel = "AI98",		maxSpd = 250},
	[603] = {tank = 93,		consumption = 14,	fuel = "AI98",		maxSpd = 250},
	[604] = {tank = 93,		consumption = 14,	fuel = "AI98",		maxSpd = 270},	
	[605] = nil,
	
	-- Грузовики
	[403] = {tank = 100,	consumption = 28,	fuel = "DT",		maxSpd = 130},
	[407] = nil,
	[408] = nil,
	[413] = nil,
	[414] = {tank = 100,	consumption = 18,	fuel = "AI92",		maxSpd = 160},
	[416] = {tank = 83,		consumption = 15,	fuel = "AI98",		maxSpd = 290},
	[423] = nil,
	[427] = nil,
	[428] = nil,
	[431] = {tank = 100,	consumption = 120,	fuel = "A100",		maxSpd = 125},	-- https://en.wikipedia.org/wiki/Battery_electric_bus	energy consumption 1.2 kWh/km = 120 кВтч на 100 км, запас 260 км (160 миль)
	[433] = nil,
	[437] = {tank = 100,	consumption = 45,	fuel = "DT",		maxSpd = 135},
	[440] = nil,
	[443] = nil,
	[455] = nil,
	[456] = {tank = 85,		consumption = 25,	fuel = "AI98plus",	maxSpd = 290},
	[459] = nil,
	[482] = nil,
	[483] = {tank = 100,		consumption = 25,	fuel = "AI98plus",	maxSpd = 290},
	[498] = nil,
	[499] = {tank = 80,		consumption = 10,	fuel = "DT",		maxSpd = 135},
	[508] = {tank = 75,		consumption = 19,	fuel = "AI98",		maxSpd = 290},
	[514] = nil,
	[515] = {tank = 100,	consumption = 25,	fuel = "DT",		maxSpd = 130},
	[524] = nil,
	[525] = {tank = 70,		consumption = 23,	fuel = "DT",		maxSpd = 150},
	[528] = nil,
	[544] = nil,
	[552] = nil,
	[573] = nil,
	[578] = nil,
	[582] = {tank = 75,		consumption = 15,	fuel = "DTplus",	maxSpd = 145},
	[588] = nil,
	[601] = nil,
	[609] = nil,
	
	-- Мотоциклы
	[448] = {tank = 10,		consumption = 4,	fuel = "AI92",		maxSpd = 50},	-- Pizzaboy
	[461] = {tank = 16,		consumption = 10,	fuel = "AI95",		maxSpd = 190},
	[462] = {tank = 10,		consumption = 4,	fuel = "AI92",		maxSpd = 50},
	[468] = {tank = 18,		consumption = 6,	fuel = "AI92",		maxSpd = 190},
	[521] = {tank = 17,		consumption = 10,	fuel = "AI95",		maxSpd = 310},
	[522] = {tank = 21,		consumption = 10,	fuel = "AI95",		maxSpd = 300},
	[586] = {tank = 17,		consumption = 10,	fuel = "AI95",		maxSpd = 190},
	
	-- Вертолеты
	[417] = {tank = 11600,	consumption = 1462,	fuel = "TC1",		maxSpd = 265},
	[425] = nil,
	[447] = nil,
	[469] = {tank = 136,	consumption = 20.5,	fuel = "TC1",		maxSpd = 175},
	[487] = {tank = 570,	consumption = 160,	fuel = "TC1",		maxSpd = 232},
	[488] = nil,
	[497] = {tank = 710,	consumption = 100,	fuel = "TC1",		maxSpd = 200},
	[548] = nil,
	[563] = {tank = 540,	consumption = 85,	fuel = "TC1",		maxSpd = 235},
	
	-- Лодки
	[430] = nil,
	[446] = {tank = 100,	consumption = 35,	fuel = "AI95",		maxSpd = 190},
	[452] = nil,
	[453] = {tank = 100,	consumption = 25,	fuel = "AI92",		maxSpd = 190},
	[454] = {tank = 100,	consumption = 65,	fuel = "AI95",		maxSpd = 190},
	[472] = {tank = 230,	consumption = 20,	fuel = "AI95",		maxSpd = 190},
	[473] = {tank = 12,		consumption = 3,	fuel = "AI92",		maxSpd = 190},
	[484] = nil,
	[493] = {tank = 100,	consumption = 25,	fuel = "AI95",		maxSpd = 190},
	[595] = {tank = 100,	consumption = 30,	fuel = "AI95",		maxSpd = 190},
	
	-- Самолеты
	[593] = {tank = 100,	consumption = 106,	fuel = "TC1",		maxSpd = 190},		-- Аэронавигационный запас топлива 15%, Практическая дальность полета — 990 км
	
	-- Другое
	[486] = {tank = 360,	consumption = 106,	fuel = "DT",		maxSpd = 100},		-- Бульдозер
}

function getMultiplerFromOctane(realOctane, idealFuel)
	local fuelData = multipliersTable[idealFuel]
	if (fuelData) then
		if (realOctane <= fuelData[1].octane) then
			return fuelData[1].multiplier
			
		elseif (realOctane >= fuelData[#fuelData].octane) then
			return fuelData[#fuelData].multiplier
			
		else
			for i = 1, #fuelData-1 do
				if (realOctane > fuelData[i].octane) and (realOctane < fuelData[i+1].octane) then
					-- Нижнее значение + ((Число-Нижняя граница)/(Верхняя граница-Нижняя граница)*(Верхнее значение-Нижнее значение))
					return fuelData[i].multiplier + ((realOctane-fuelData[i].octane)/(fuelData[i+1].octane-fuelData[i].octane) * (fuelData[i+1].multiplier-fuelData[i].multiplier))
				end
			end
		end
		
		return 1.0 -- На всякий случай
	else
		return 1.0
	end
end

function getEthanolMultiplier(realOctane)
	realOctane = tonumber(realOctane)
	if (realOctane) then
		local ethanolOctane = fuels["E85"].octane
		local lastGasolineOctane = fuels["AI98plus"].octane
		if (realOctane > lastGasolineOctane) then
			-- Нижнее значение + ((Число-Нижняя граница)/(Верхняя граница-Нижняя граница)*(Верхнее значение-Нижнее значение))
			return 1.0 + ((realOctane-lastGasolineOctane)/(ethanolOctane-lastGasolineOctane)*(fullEthanolMultiplier-1.0))
		else
			return 1.0
		end
	else
		return 1.0
	end
end
