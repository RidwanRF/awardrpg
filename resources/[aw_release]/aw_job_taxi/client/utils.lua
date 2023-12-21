function isCursorOnElement( posX, posY, width, height )
    if isCursorShowing( ) then
        local mouseX, mouseY = getCursorPosition( )
        local clientW, clientH = guiGetScreenSize( )
        local mouseX, mouseY = mouseX * clientW, mouseY * clientH
        if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
           return true
        end
    end
    return false
end

dxDrawBordRect = function (x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius - 1, rx, radius+1, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y - 1, radius, ry+1, color)
        dxDrawRectangle(x + rx, y-1, radius, ry+1, color)

        dxDrawCircle(x, y-1, radius, 180, 270, color, color, 64)
        dxDrawCircle(x + rx, y - 1, radius, 270, 360, color, color, 64)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 64)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 64)
    end
end

standartR, standartG, standartB, standartH = 191, 32, 32, 150

function dxDrawWindow(x, y, w, h, text_1)
		local CR = getElementData(localPlayer, "ColorR") or standartR
		local CG = getElementData(localPlayer, "ColorG") or standartG
		local CB = getElementData(localPlayer, "ColorB") or standartB
		local bgcolor = tocolor(0, 0, 0, 150)
		local tcolor = tocolor(255, 255, 255, 255)
		local bgcolorp = tocolor(CR, CG, CB, 255)
		dxDrawBordRect(x, y, w, h, bgcolor, 5, false)
		--dxDrawRectangle(x, y, w, 5, bgcolorp, false)
		--dxDrawText(text_1, x, y, w + x, 30 + y, tcolor, 1,1, "default-bold", "center", "center", true, false, false, true)
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
	_dxDrawText(text, x, y, w+x, h+y, ...)
end

function dxDrawButton(x, y, w, h, text, font)
    dxDrawBordRect(x, y, w, h, tocolor(25, 25, 25, 255), 5, false)
    if isCursorOnElement(x, y, w, h) then
        dxDrawBordRect(x, y, w, h, tocolor(128, 128, 128, 255), 5, false)
    end
    dxDrawText(text, x, y, w, h, tocolor(255, 255, 255, 2555), 1, font, "center", "center", false, false, false, true)
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