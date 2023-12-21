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

function rgbToHsv(r, g, b, a)
    if not a then
        a = 1
    end
    r, g, b, a = r / 255, g / 255, b / 255, a / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max

    local d = max - min
    if max == 0 then s = 0 else s = d / max end

    if max == min then
        h = 0 -- achromatic
    else
        if max == r then
            h = (g - b) / d
            if g < b then h = h + 6 end
            elseif max == g then h = (b - r) / d + 2
            elseif max == b then h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v, a
end

function hsvToRgb(h, s, v, a)
    if not a then
        a = 1
    end
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255, a * 255
end

function rgbFromInt(c)
    local r = bitAnd(bitRShift(c, 16), 255)
    local g = bitAnd(bitRShift(c, 8), 255)
    local b = bitAnd(c, 255)
    return r, g, b
end

function math.clamp(x, min, max)
    return math.min(max, math.max(min, x))
end

function ARGBToHex(alpha, red, green, blue)
    return string.format("%.2X%.2X%.2X%.2X", alpha,red,green,blue)
end
