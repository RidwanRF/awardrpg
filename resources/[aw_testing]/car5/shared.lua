replace = {

    [613] = {
        dff = "porschetaycan.dff",
        txd = "porschetaycan.txd",
        parentId = 400,
    },
    [614] = {
        dff = "ferrarisf90.dff",
        txd = "ferrarisf90.txd",
        parentId = 400,
    },
    [615] = {
        dff = "test.dff",
        txd = "test.txd",
        parentId = 599,
    },
    [616] = {
        dff = "test2.dff",
        txd = "test2.txd",
        parentId = 400,
    }
}

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



local _createVehicle = createVehicle
function createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    local veh
    if model >= 400 and model <= 611 then
        veh = _createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    else
        veh = _createVehicle(411, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    end

    setElementData(veh, "vehicle:model", model)

    return veh
end