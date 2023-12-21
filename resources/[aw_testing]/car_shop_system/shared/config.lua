Config = {}

Config.carshopDimension = 1

Config.doorMarkerRadius = 1
Config.doorMarkerColor  = {255, 0, 0, 125}

Config.enableDebugCommand = false
Config.debugCommand       = "carshop"
Config.carshopGarageModel = 3927
Config.carshopGaragePosition = Vector3(0, 0, 0.0)

Config.testDriveTime = 720
Config.testDrivePriceMul = 0
Config.testdrivePosition = Vector3(1491.6285, 728.2135, 12.00625)

Config.interiors = {
    default = {
        vehiclePosition = Config.carshopGaragePosition + Vector3(0.5, -4.0, 0),
        vehicleRotation = Vector3(0, 0, 135),
        interior = 1,
        cameraDistance  = 11,
    },

    heli_shop = {
        vehiclePosition = Vector3(1584.398438, 1193.519531, 10.744588),
        cameraDistance  = 14,
    },

    boat_shop = {
        vehiclePosition = Vector3(1047.772, -2373.333, 0.227),
        vehicleRotation = Vector3(0, 0, 140),
        cameraDistance  = 14,
    }
}