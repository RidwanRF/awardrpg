PScreen = Vector2(guiGetScreenSize());
scale = math.min(math.max(PScreen.y / 1080, 0.65), 2)


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function clearMemory()      
    local oldGarbage = math.floor(collectgarbage("count"))
    collectgarbage()
    outputDebugString(string.lower(getResourceName (getThisResource())).." collected "..oldGarbage-math.floor(collectgarbage("count")).." of "..oldGarbage.."KB")
end
setTimer(clearMemory, 1800000, 0)


function isCursorPosition(x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local cursorx, cursory = mx * PScreen.x, my * PScreen.y
        if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
            return true
        end
    end
    return false
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

_dxGetTextWidth = dxGetTextWidth
local DGTWData = {};

function dxGetTextWidth(text, scale, font, colorCode)
    if DGTWData[text] and
        DGTWData[text].scale == scale and
        DGTWData[text].font == font and
        DGTWData[text].colorCode == colorCode then

        return DGTWData[text].value
    end

    DGTWData[text] = {
        scale = scale;
        text = text;
        font = font;
        colorCode = colorCode;
        value = _dxGetTextWidth(text, scale, font, colorCode)
    }
    return DGTWData[text].value;
end

-- Разделение числа на разряды
function explodeNumber(number)
    number = tostring(number)
    local k
    repeat
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
    until (k==0)    -- true - выход из цикла
    return number
end

function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end

