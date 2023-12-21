Config = {}

Config.prices = {
    hlbody = 5500,
    body = 5500,
    additional = 2500,
    wheels = 6000,
}

Config.tintPrices = {
    front = 20000000,
    side  = 20000000,
    rear  = 20000000
}

Config.paintjobPrice = 2000000
Config.paintjobRemovePrice = 200000

-- Виды транспорта, которые можно красить
Config.allowedVehicleTypes = {
    Automobile = true,
    Bike = true
}

Config.blipId = 63
Config.debugMessagesEnabled = false

-- Координаты объекта гаража
Config.paintGaragePosition = Vector3(0, 0, 200)
Config.paintGarageModel = 1909

-- Положение машины в покрасочной
Config.garageVehiclePosition = Vector3(5586.9, 1165.5999755859, 59)
Config.garageVehicleRotation = Vector3(0, 0, 0)
Config.garageInterior = 0

-- Входы в покрасочные
Config.garageMarkerRadius = 3.5
Config.garageMarkerBlip = 27
Config.garageMarkerColor = {255, 255, 255, 100}
Config.paintGarageMarkers = {

    { position = Vector3(1952.11023, 2089.46509, 11), angle = -90 },
    { position = Vector3(1041.83032, 2277.74805, 11), angle = -90 },


}

PalitraColor = {
    {1,"Обычная",0},
}

-- Цены на тип краски
Config.acril = 0 -- Обычная 
Config.gradient = 350000 -- Перламутровая
Config.matte = 400000 -- Матовая

texturesRemap = {"remap", "body", "remap_body"} 
