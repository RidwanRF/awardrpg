ShopTable = {}

if isResourceRunning("car_system") then
    ShopTable = exports.car_system:getShopTable()
end

function getCarshopGarage(carshopId)
    if not carshopId or not ShopTable[carshopId] then
        return Config.interiors.default
    end
    local name = ShopTable[carshopId].garage
    if not name or not Config.interiors[name] then
        return Config.interiors.default
    end
    return Config.interiors[name]
end
