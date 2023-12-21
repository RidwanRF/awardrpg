Config = {}

Config.debugEnabled = false

Config.size = {
	[0] = 0, -- {размер шины, высота колёс}
	[1] =  0.01,
	[2] = -0.01,
    [3] = -0.04,
    [4] = -0.06
}

Config.wheelDummies = {
    "wheel_rf_dummy",
    "wheel_lf_dummy",
    "wheel_rb_dummy",
    "wheel_lb_dummy"
}

Config.texturesName = {"sidewall", "yokohamo", "yokohama", "bridgestone", "tread", "13", "11", "12", "4", "shina", "tire"}

Config.defaultRadius = 0.7
Config.defaultWidth  = 1

-- Автомобили, на которых запрещено изменение вылета колёс
Config.disableWheelsOffset = {
    [403] = true,
    [515] = true,
    [448] = true,
    [461] = true,
    [462] = true,
    [463] = true,
    [468] = true,
    [471] = true,
    [521] = true,
    [522] = true,
    [523] = true,
    [581] = true,
    [586] = true,
}

-- Радиус колёс по умолчанию для указанных автомобилей
Config.overrideWheelsRadius = {
    [400] = 0.768,
    [404] = 0.66,
    [429] = 0.7,	
    [420] = 0.9,	
    [604] = 0.9,	
    [409] = 0.82,
    [421] = 0.65,
    [445] = 0.68,
    [458] = 0.72,
    [504] = 0.80,	
    [470] = 0.894,
    [490] = 0.92,
    [516] = 0.75,
    [550] = 0.76,
    [551] = 0.77,
    [567] = 0.92,
    [579] = 0.9,
    [580] = 0.78,
    [585] = 0.75,
    [401] = 0.74,
    [410] = 0.62,
    [415] = 0.68,
    [419] = 0.64,
    [424] = 0.85,
    [434] = 0.8,
    [442] = 0.68,
    [444] = 1.5,
    [451] = 0.75,
    [457] = 0.5,
    [477] = 0.76,
    [489] = 0.9,
    [491] = 0.65,
    [494] = 0.82,
    [495] = 0.972,
    [500] = 0.8,
    [502] = 0.82,
    [503] = 0.82,
    [505] = 0.9,
    [517] = 0.75,
    [518] = 0.66,
    [535] = 0.74,
    [541] = 0.75,
    [542] = 0.74,
    [549] = 0.684,
    [554] = 0.84,
    [556] = 1.5,
    [557] = 1.5,
    [562] = 0.68,
    [565] = 0.75,
    [589] = 0.74,
    [599] = 0.95,
    [403] = 1.1,
    [407] = 1.0,
    [408] = 01.06,
    [413] = 0.72,
    [414] = 0.76,
    [416] = 0.864,
    [427] = 0.936,
    [428] = 0.914,
    [431] = 1.0,
    [433] = 1.2,
    [437] = 1.0,
    [443] = 1.082,
    [455] = 1.2,
    [456] = 0.84,
    [483] = 0.66,
    [498] = 0.76,
    [499] = 0.8,
    [508] = 0.8,
    [514] = 1.106,
    [515] = 1.18,
    [524] = 1.12,
    [525] = 0.92,
    [528] = 0.85,
    [544] = 1.0,
    [552] = 0.84,
    [573] = 1.14,
    [578] = 1.0,
    [582] = 0.77,
    [588] = 0.86,
    [601] = 1.366,
    [609] = 0.76,
    [448] = 0.464,
    [461] = 0.67,
    [462] = 0.464,
    [463] = 0.654,
    [468] = 0.62,
    [471] = 0.6,
    [521] = 0.68,
    [522] = 0.68,
    [523] = 0.68,
    [581] = 0.68,
    [586] = 0.654,
    [527] = 0.75,
    [533] = 0.78,
}
