
-- Машины с выдвижными фарами
hasActiveHeadlights = {
	[410] = true,	-- Toyota AE86
	[562] = true,	-- Nissan Silvia S13
	[439] = true,	-- Dodge Charger R/T 426 HEMI
	[576] = true,	-- Mazda RX-7
}

-- Таблица замены старых записей об апгрейдах новыми
oldUpgradesToNew = {
	-- Колеса
	[1025] = {"wheels", 1}, [1073] = {"wheels", 2}, [1074] = {"wheels", 3}, [1075] = {"wheels", 4}, [1076] = {"wheels", 5},
	[1077] = {"wheels", 6}, [1078] = {"wheels", 7}, [1079] = {"wheels", 8}, [1080] = {"wheels", 9}, [1081] = {"wheels", 10},
	[1082] = {"wheels", 11}, [1083] = {"wheels", 12}, [1084] = {"wheels", 13}, [1085] = {"wheels", 14}, [1096] = {"wheels", 15},
	[1097] = {"wheels", 16}, [1098] = {"wheels", 17},
	-- Спойлеры
	[1000] = {"spoiler", 1}, [1001] = {"spoiler", 2}, [1002] = {"spoiler", 3}, [1003] = {"spoiler", 4}, [1014] = {"spoiler", 5},
	[1015] = {"spoiler", 6}, [1016] = {"spoiler", 7}, [1023] = {"spoiler", 8}, [1049] = {"spoiler", 9}, [1050] = {"spoiler", 10},
	[1058] = {"spoiler", 11}, [1060] = {"spoiler", 12}, [1138] = {"spoiler", 13}, [1139] = {"spoiler", 14}, [1146] = {"spoiler", 15},
	[1147] = {"spoiler", 16}, [1158] = {"spoiler", 17}, [1162] = {"spoiler", 18}, [1163] = {"spoiler", 19}, [1164] = {"spoiler", 20},
}

-- Винилы, устанавливаемые на машины сразу при покупке
stockPaintjobs = {
}

-- Список апгрейдов, хранимых в элементдате машины и сохраняемых в базу
upgradeVariants = {"bumper_f","bumper_r","skirts","fenders_f","fenders_r","misc","head_lights","tail_lights","scoop","bonnet","spoiler","trunk",
	"trunk_badge","splitter","diffuser","interior","interiorparts","door_pside_f","door_dside_f","kit","licence_frame",
	"wheels","wheels_r","wheels_f","wheels_razval_f","wheels_razval_r","wheels_offset_f","wheels_offset_r","wheels_profile", "wheels_radius","wheels_width","wheels_color","wheels_width_f","wheels_width_r", "blik_color", "coverType", "wheels_tire", "wheels_brakes",
	"exhaust", "bonnet_attach", "strob", "isTuning", "vyhlop", "splitter_front", "roof_", "mirror_rf","mirror_lf", "doorfender_rr", "doorfender_lr", "doorfender_rf", "doorfender_lf", "grill", "wheels_prof",
	"door_dside_r", -- левая задняя дверь
	"door_pside_r" -- правая задняя дверь
}

-- Названия валют для отображения
currencyTable = {
	-- RUB = "₽",	-- Есть проблемы с отображением символа на разных системах
	RUB = " руб.",
	USD = "$",
	EUR = "€",
}

-- Территории для автоочистки
colshapes = {
	createColPolygon(-1656.350586, 1310.805664, -- Междугородний автобус СФ
					-1696.366211, 1321.799805,
					-1645.207031, 1270.267578,
					-1621.288086, 1291.845703,
					-1626.420288, 1313.418335,
					-1662.972656, 1351.308594),
	createColRectangle(1194.408203, -1837.673828, 88.745117, 47.487305), -- Междугородний автобус ЛС
	createColRectangle(-543.761536, 2545.731689, 40, 95), -- Такси
	usedauto = createColRectangle(1692.502441, -1142.171875, 10, 25), -- Б/у салон
	createColCuboid(-2056.71, 151.32, 27.8, 16.5, 31, 5.5 ), -- СТО СФ
	createColCuboid(2920.62, -1104.26, 11.34, 16.5, 31, 5.5 ), -- СТО ЛС пляж
	createColCuboid(2880.15, 2219.5, 10.94, 16.5, 31, 5.5 ), -- СТО ЛВ
	createColCuboid ( 997.5 , -1370.3 , 12.3, 20, 14.5, 5.5 ), -- СТО ЛС город
	createColRectangle(-2096.34375 , -102.916992, 79, 23), -- Автошкола
	createColPolygon(-2006.866211 , 130.698242, -- Спавн
					-2001.251953, 218.192383,
					-1998.124023, 188.451172,
					-1997.329102, 38.445312,
					-2016.833984, 38.438477,
					-2016.651367, 220.443359),
	createColPolygon(2178.233887, -1790.634521, -- Работа автобуса в ЛС
					2177.539062, -1785.902344,
					2177.053711, -1766.044922,
					2194.780273, -1745.737305,
					2195.586914, -1815.50293,
					2150.569336, -1815.630859,
					2150.553711, -1786.064453),
	createColRectangle(1467.751953, 2323.514648, 90, 60), -- Работа автобуса в ЛВ
	createColCuboid(-2602.052734, 578.182617, 13.458882, 63, 84, 8.5), -- Работа автобуса в СФ
	createColRectangle(1357.5, 663.4, 40, 134.5) -- Старое ЕКХ
}

-- Машины, которые не занимают слоты в гараже
notSlottingCar = {
	[448] = true, -- Pizzaboy
	[457] = true, -- Ока
	[462] = true, -- Мопед
	[403] = true, -- Камаз
	[414] = true, -- Фусо
	[431] = true, -- Икарус
	[437] = true, -- Лиаз
	[515] = true, -- Ивеко
	[525] = true, -- Эвакуатор
	[582] = true, -- Спринтер
	[597] = true, -- Полиц машина
	[497] = true  -- Полиц вертолет
}
-- Машины, которые должны продаваться за 0 руб
overPricedCar = {
	[497] = true, -- Полицейский вертолет
	[597] = true, -- Полцейская ешка
	[525] = true  -- Эвакуатор
}
-- То, что не должно попадать на б/у рынок
notSoldableCar = {
	[448] = true, -- Pizzaboy
	[462] = true, -- Мопед
	
	[506] = true, -- Bugatti Chiron 2017
	[536] = true, -- Koenigsegg Regera 2016
	
	[403] = true, -- Камаз 53215
	[431] = true, -- Volvo Keolis
	[437] = true, -- Mercedes-Benz O345
	[515] = true, -- Scania R620
}


-- Различные таблицы, которые надо разобрать
isHeli = {	-- Костыль, иначе не дает менять номера на машинах из списка notSoldableCar
	[417] = true, -- Ми-26
	[425] = true, -- Heli
	[447] = true, -- Heli
	[469] = true, -- Robinson R22
	[487] = true, -- MBB Bo 105
	[488] = true, -- Heli
	[497] = true, -- Police Helicopter
	[548] = true, -- Heli
	[563] = true  -- Eurocopter EC130
}
isBoat = {
	[430] = true, -- 
	[446] = true, -- Wellcraft 38 Scarab KV
	[452] = true, -- 
	[453] = true, -- Reefer
	[454] = true, -- Princess 50
	[472] = true, -- Tropic
	[473] = true, -- Надувная лодка
	[484] = true, -- 
	[493] = true, -- Lampadati Toro
	[595] = true  -- Blade
}
isMotorcycle = {
	[448] = true, -- Мото
	[461] = true, -- Мото
	[462] = true, -- Мото
	[463] = true, -- Мото
	[468] = true, -- Мото
	[471] = true, -- Мото
	[521] = true, -- Мото
	[522] = true, -- Мото
	[523] = true, -- Мото
	[581] = true, -- Мото
	[586] = true  -- Мото
}


-- local notSlottingCarsList = "448, 457, 462, 403, 414, 431, 437, 515, 525, 582, 597, 497"
notSlottingCarsList = "a"
local function createNotSlottingCarsList()
	local tempTable = {}
	for index, _ in pairs(notSlottingCar) do
		table.insert(tempTable, index)
	end
	notSlottingCarsList = table.concat(tempTable, ",")
end
createNotSlottingCarsList()