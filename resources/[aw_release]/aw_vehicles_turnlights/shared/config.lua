Config = {}

-- Включает команды:
-- /testlight название - зажечь свет
Config.debugEnabled = true

Config.animatedLightsVehicles = {}

-- Цвет и яркость фар по умолчанию
Config.defaultLightColor = {1, 0.5, 0}
Config.defaultLightBrightness = 0.35
-- Фары по умолчанию
Config.defaultLights = {
    {name = "turn_left",  color = { 1,   0.5, 0   }},
    {name = "turn_right", color = { 1,   0.5, 0   }},
    {name = "rear",       color = { 0.8, 0.8, 0.8 }},
    {name = "brake",      color = { 1,   0,   0   }},
    {name = "front",      color = { 1,   1,   1   }, noShader = true},
}
-- Добавляются, если на автомобиле есть стробоскопы
Config.defaultStrobes = {
    {name = "strobe_b", color = {0, 0, 1}},
    {name = "strobe_r", color = {1, 0, 0}},
    {name = "strobe_w", color = {1, 1, 1}},
}

-- На каких машинах есть стробоскопы
Config.strobesVehicle = {}

-- Время, после которого поворотники выключаются автоматически
Config.turnDisableTime = 1200
-- Интервал мигания поворотников по умолчанию
Config.defaultTurnLightsInterval = 0.5
