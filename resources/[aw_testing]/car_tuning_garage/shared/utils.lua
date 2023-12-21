function table.copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.copy(orig_key)] = table.copy(orig_value)
        end
        setmetatable(copy, table.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end

function debug.log(str)
    if not Config.debugMessagesEnabled then
        return
    end
    outputDebugString("[DEBUG] " .. tostring(str))
end

function table.length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Устанавливает автомобилю ксенон по индексу из таблицы в car_components
function setVehicleXenon(vehicle, id)
    if not isResourceRunning("car_components") or not isElement(vehicle) then
        return
    end
    local r, g, b = 255, 255, 255
    if id and id > 0 then
        local colors = exports.car_components:getXenonColors()
        r, g, b = unpack(colors[id].color)
    end
    setVehicleHeadLightColor(vehicle, r, g, b)
    return r, g, b
end
