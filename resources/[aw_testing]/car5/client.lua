local models = {}

function loadVehicleModel(id, data)
    local model = engineRequestModel("vehicle", data.parentId)
    models[id] = model

    engineImportTXD(engineLoadTXD("data/" .. data.txd), model)
    engineReplaceModel(engineLoadDFF("data/" .. data.dff), model)
end

function changeVehicleModel(vehicle)
    local model = tonumber(getElementData(vehicle, "vehicle:model"))
    if not model then return end

    if models[model] then
        local upgrades = getVehicleUpgrades(vehicle)
        setElementModel(vehicle, models[model]) 
        for k,v in pairs(upgrades) do
            addVehicleUpgrade(vehicle, v)
        end

        local handling = replace[model].handling
        if handling then
            for k,v in pairs(handling) do
                setVehicleHandling(vehicle, k, v)
            end
        end
    end
end

addEventHandler("onClientElementDataChange", root, function(key)
    if getElementType(source) ~= "vehicle" then return end
    if key ~= "vehicle:model" then return end
    changeVehicleModel(source)
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) ~= "vehicle" then return end
    changeVehicleModel(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k,v in pairs(replace) do
        loadVehicleModel(k, v)
    end

    for k,v in pairs(getElementsByType("vehicle")) do
        changeVehicleModel(v)
    end
end)


local _getVehicleType = getVehicleType

function getVehicleType(model)
    if model >= 400 and model <= 611 then
        return _getVehicleType(model)
    end

    if replace[model] then
        return _getVehicleType(replace[model].parentId)
    end
    return "Automobile"
end