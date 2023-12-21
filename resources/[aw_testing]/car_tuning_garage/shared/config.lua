Config = {}

Config.tuningGarageModel = 1908

-- Расположение объекта гаража
Config.tuningGaragePosition = Vector3(0, 0, 197)

-- Команда для входа в тюнинг из любого места
Config.debugEnableTuningCommand = false
Config.debugTuningCommand = "tuning"
Config.debugMessagesEnabled = false

-- Положение автомобиля в тюнинге
Config.tuningVehiclePosition = Vector3(5604.2001953125, 1165.5999755859, 59)
Config.tuningVehicleRotation = Vector3(0, 0, 0)
Config.tuningInterior = 0

-- Автомобили, для которых запрещён тюнинг
Config.disabledVehicleModels = {
    [499] = true,
    [437] = true,
    [431] = true,
    [515] = true,
    [403] = true,
    [414] = true,
}

-- Входы в тюнинг
Config.tuningMarkers = {

    { position = Vector3(1952.11023, 2072, 10.9),     angle = -90 },
    { position = Vector3(1041.83032, 2260.29058, 10.9),     angle = -90 },

}

Config.tuningMarkerRadius = 3.5
Config.tuningMarkerBlip = 14
Config.tuningMarkerColor = {255, 255, 255, 100}

-- Ограничения настрек колёс
Config.wheelPropertiesLimits = {
    offset = {-0.06, 0.22},
    razval = {0, 30},
    radius = {0.7, 1.3},
    width  = {0.8, 1.6},
}

Config.wheelPropertiesPrices = {
    wheels_offset_f = 10000,
    wheels_offset_r = 10000,

    wheels_razval_f = 10000,
    wheels_razval_r = 10000,

    wheels_radius = 10000,

    wheels_width_f = 10000,
    wheels_width_r = 10000,
}

Config.wheelProperties = {
    "wheels_offset_f",
    "wheels_offset_r",
    "wheels_razval_f",
    "wheels_razval_r",
    "wheels_radius",
    "wheels_width_f",
    "wheels_width_r",
}
