local currentCarshop = {}
local currentCarshopId
local selectedVehicle = 1

function getCarshopInterior()
    if not currentCarshop then
        return Config.interiors.default
    end
    if currentCarshop.garage then
        return Config.interiors[currentCarshop.garage]
    else
        return Config.interiors.default
    end
end

function getCurrentCarshop()
    return currentCarshop or {}
end

function getCarshopCars()
    if not currentCarshop or not currentCarshop.cars then
        return {}
    end
    return currentCarshop.cars
end

function loadCarshop(carshopId)
    currentCarshop = ShopTable[carshopId]
    currentCarshopId = carshopId
    selectedVehicle = 1
end

function getCarshopId()
    return currentCarshopId
end
