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

function isVehicleMovingBackwards(vehicle)
    if vehicle.velocity.length < 0.05 then
        return false, false
    end

    local direction = vehicle.matrix.forward
    local velocity = vehicle.velocity.normalized

    local dot = direction.x * velocity.x + direction.y * velocity.y
    local det = direction.x * velocity.y - direction.y * velocity.x

    local angle = math.deg(math.atan2(det, dot))
    return math.abs(angle) > 120, true
end

--    ==========     Слоумод на кнопку/действие     ==========
local sendData = {}
local sendTimers = {}

local function slowSend(actionGroup)
    if (sendData[actionGroup]) then
        setElementData(unpack(sendData[actionGroup]))
        sendData[actionGroup] = nil
    end
end

function antiDOSsend(actionGroup, pause, ...)
    if isTimer(sendTimers[actionGroup]) then
        sendData[actionGroup] = {...}
    else
        setElementData(...)
        sendData[actionGroup] = false
        sendTimers[actionGroup] = setTimer(slowSend, pause, 1, actionGroup)
    end
end

function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end
