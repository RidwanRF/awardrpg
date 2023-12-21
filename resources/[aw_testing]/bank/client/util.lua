sX, sY = guiGetScreenSize();
px = sX < 1920 and math.min(2, 1920 / sX) or 1
px = sX > 1920 and math.min(2, sX / 1920) or px


bold = dxCreateFont("file/Montserrat-SemiBold.ttf", 15/px)
regular = dxCreateFont("file/Montserrat-Medium.ttf", 11/px)
medium = dxCreateFont("file/Montserrat-Medium.ttf", 13/px)
mediumBold = dxCreateFont("file/Montserrat-Medium.ttf", 16/px)
boldSmall = dxCreateFont("file/Montserrat-Medium.ttf", 11/px)
boldSmallSec = dxCreateFont("file/Montserrat-SemiBold.ttf", 13/px)
boldBig = dxCreateFont("file/Montserrat-SemiBold.ttf", 55/px)

local bAlpha = {}
for i = 1, 10 do
	bAlpha[i] = 255
end

local sAlpha = {}
for i = 1, 10 do
	sAlpha[i] = 0
end



function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
	dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
	dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
	dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
	dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
	dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
	dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
	dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
	dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
	dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing ( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
		return true
	else
		return false
	end
end



function dxText(x, y, w, h, color, thisFont, align, text)
	dxDrawText(text, x, y, w + x, h + y, color, 1, thisFont, align, "center", false, true, false, true, false)
end



function dxDrawButton(x, y, alpha, text, id)
	local mx, my = getMousePos()
	if isPointInRect(mx, my, x - 2, y, 135/px, 44/px) then
		bAlpha[id] = bAlpha[id] - 15
		if bAlpha[id] <= 0 then
			bAlpha[id] = 0
		end
	else
		bAlpha[id] = bAlpha[id] + 15
		if bAlpha[id] >= 255 then
			bAlpha[id] = 255
		end
	end
	--dxDrawImage(x, y, 135/px, 44/px, "file/button2.png", 0, 0, 0, tocolor(255,255,255,(255-bAlpha[id])*(alpha/255)))
	dxDrawImage(x, y, 135/px, 44/px, "file/button.png", 0, 0, 0, tocolor(255,255,255,(255-bAlpha[id])*(alpha/255)))
	dxDrawText(text, x, y-2/px, 135/px+x, 44/px+y, tocolor(255, 255, 255, alpha), 1, boldSmall, "center", "center", true, false, false, true)
end

function dxDrawSecButton(x, y, alpha, text, id)
	local mx, my = getMousePos()
	if isPointInRect(mx, my, x - 2, y, 280/px, 44/px) then
		bAlpha[id] = bAlpha[id] - 15
		if bAlpha[id] <= 0 then
			bAlpha[id] = 0
		end
	else
		bAlpha[id] = bAlpha[id] + 15
		if bAlpha[id] >= 255 then
			bAlpha[id] = 255
		end
	end
	--dxDrawImage(x, y, 280/px, 44/px, "file/buttonSec.png", 0, 0, 0, tocolor(255,255,255,bAlpha[id]*(alpha/255)*0.1))
	dxDrawImage(x, y, 280/px, 44/px, "file/buttonSec.png", 0, 0, 0, tocolor(255,255,255,(255-bAlpha[id])*(alpha/255)))
	dxDrawText(text, x, y-2/px, 280/px+x, 44/px+y, tocolor(255, 255, 255, alpha), 1, boldSmall, "center", "center", true, false, false, true)
end

function dxDrawTupeButton(x, y, alpha, text, selected, id)
	local mx, my = getMousePos()
	if selected then

		sAlpha[id] = sAlpha[id] + 15
		if sAlpha[id] >= 255 then
			sAlpha[id] = 255
		end
	else
		sAlpha[id] = sAlpha[id] - 15
		if sAlpha[id] <= 0 then
			sAlpha[id] = 0
		end
	end
	if isPointInRect(mx, my, x - 2, y, 117/px, 40/px) then
		bAlpha[id] = bAlpha[id] + 15
		if bAlpha[id] >= 255 then
			bAlpha[id] = 255
		end
	else
		bAlpha[id] = bAlpha[id] - 15
		if bAlpha[id] <= 0 then
			bAlpha[id] = 0
		end
	end

	dxDrawImage(x, y, 117/px, 40/px, "file/type.png", 0, 0, 0, tocolor(255,255,255,alpha))

	dxDrawImage(x, y, 117/px, 40/px, "file/type.png", 0, 0, 0, tocolor(255,255,255,bAlpha[id]*(alpha/255)))
	dxDrawImage(x, y, 117/px, 40/px, "file/type.png", 0, 0, 0, tocolor(255,255,255,bAlpha[id]*(alpha/255)*0.6))
	dxDrawImage(x, y, 117/px, 40/px, "file/typeSelected.png", 0, 0, 0, tocolor(255,255,255,(alpha/255)*(sAlpha[id])))
	dxDrawText(text, x, y-2/px, 117/px+x, 40/px+y, tocolor(255, 255, 255, alpha), 1, boldSmall, "center", "center", true, false, false, true)
end

function dxDrawCloseButton(x, y, w, h, alpha, text)
	local mx, my = getMousePos()
	local bgcolor = tocolor(40, 42, 63, alpha)
	if isPointInRect(mx, my, x - 2, y, w, h) then
		bgcolor = tocolor(60, 61, 81, alpha)
	else
		bgcolor = tocolor(40, 42, 63, alpha)
	end
	dxDrawRoundedRectangle(x, y, w, h, 10/px, bgcolor)
	dxDrawText(text, x, y, w + x, h + y, tocolor(255, 255, 255, alpha), 1, font2, "center", "center", true, false, false, true)
end




function isPointInRect(x, y, rx, ry, rw, rh)
	if x >= rx and y >= ry and x <= rx + rw and y <= ry + rh then
		return true
	else
		return false
	end
end

function cursorPosition(x, y, w, h)
	if (not isCursorShowing()) then
		return false
	end
	local mx, my = getCursorPosition()
	local fullx, fully = guiGetScreenSize()
	cursorx, cursory = mx*fullx, my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function getMousePos()
	local xsc, ysc = guiGetScreenSize()
	local mx, my = getCursorPosition()
	if not mx or not my then
		mx, my = 0, 0
	end
	return mx * xsc, my * ysc
end


function ConvertNumber(number)
	local formatted = number   
	while true do       
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1 %2")     
		if (k == 0) then       
			break   
		end
	end   
	return formatted 
end

function ConvertPrice(number)
	local formatted = number   
	while true do       
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1 %2")     
		if (k == 0) then       
			break   
		end
	end   
	return formatted 
end




------editbox

widthText = 0


EditText = ""

function forEditBoxes(c)
	if EditSelected ~= false then
		if utf8.len(EditText) < 20 then
			EditText = EditText .. c
			widthText = dxGetTextWidth(EditText, 1, regular) or 0 
		end
	end
end

function lockKeysEditBox(button, press)
	if EditSelected ~= false then
		if button == 'backspace' and press then
			EditText = utf8.sub(EditText, 1,utf8.len(EditText)-1)
			widthText = dxGetTextWidth(EditText, 1, regular) or 0 
		else
			cancelEvent()
		end
	end
end


function dxDrawEdit(x, y, w, h, id, alpha, text)
	local mx, my = getMousePos()
	--dxDrawRectangle(x, y, w, h, tocolor(255, 255, 0, alpha / 5.9))
	if isPointInRect(mx, my, x - 2, y, w, h) then
		bAlpha[id] = bAlpha[id] + 15
		if bAlpha[id] >= 255 then
			bAlpha[id] = 255
		end
	else
		bAlpha[id] = bAlpha[id] - 15
		if bAlpha[id] <= 0 then
			bAlpha[id] = 0
		end
	end
	dxDrawImage(x, y, w, h, "file/input.png", 0, 0, 0, tocolor(255,255,255,alpha))
	dxDrawImage(x, y, w, h, "file/input.png", 0, 0, 0, tocolor(255,255,255,bAlpha[id]*(alpha/255)))
	if EditText == "" then
		widthText = 0
		if not EditSelected then
			dxDrawText(text, x, y, w + x, h + y, tocolor(255, 255, 255, alpha*0.4), 1, regular, "center", "center", true, false, false, true)
		end
	else
		dxDrawText(EditText, x, y, w + x, h + y, tocolor(255, 255, 255, alpha), 1, regular, "center", "center", true, false, false, true)
	end
	if EditSelected then
		if getTickCount() - (countL or 0) < 500 then
			dxDrawText("|", x+widthText, y-1, w+x, h + y-1, tocolor(255, 255, 255, alpha), 1, regular,"center", "center", true, false, false, true)
		end
	end
end

function getDxEditText()
	return EditText or ""
end


--- sec editbox

widthTextSec = 0


EditTextSec = ""

function forEditBoxesSec(c)
	if EditSelectedSec ~= false then
		if not tonumber(c) then return end
		if utf8.len(EditTextSec) < 15 then
			EditTextSec = EditTextSec .. c
			widthTextSec = dxGetTextWidth(ConvertNumber(EditTextSec), 1, regular) or 0 
		end
	end
end

function lockKeysEditBoxSec(button, press)
	if EditSelectedSec ~= false then
		if button == 'backspace' and press then
			EditTextSec = utf8.sub(EditTextSec, 1,utf8.len(EditTextSec)-1)
			widthTextSec = dxGetTextWidth(ConvertNumber(EditTextSec), 1, regular) or 0 
		else
			cancelEvent()
		end
	end
end


function dxDrawEditSec(x, y, w, h, id, alpha, text)
	local mx, my = getMousePos()
	--dxDrawRectangle(x, y, w, h, tocolor(255, 255, 0, alpha / 5.9))
	if isPointInRect(mx, my, x - 2, y, w, h) then
		bAlpha[id] = bAlpha[id] + 15
		if bAlpha[id] >= 255 then
			bAlpha[id] = 255
		end
	else
		bAlpha[id] = bAlpha[id] - 15
		if bAlpha[id] <= 0 then
			bAlpha[id] = 0
		end
	end
	dxDrawImage(x, y, w, h, "file/input.png", 0, 0, 0, tocolor(255,255,255,alpha))
	dxDrawImage(x, y, w, h, "file/input.png", 0, 0, 0, tocolor(255,255,255,bAlpha[id]*(alpha/255)))
	if EditTextSec == "" then
		widthTextSec = 0
		if not EditSelectedSec then
			dxDrawText(ConvertNumber(text), x, y, w + x, h + y, tocolor(255, 255, 255, alpha*0.4), 1, regular, "center", "center", true, false, false, true)
		end
	else
		dxDrawText(ConvertNumber(EditTextSec), x, y, w + x, h + y, tocolor(255, 255, 255, alpha), 1, regular, "center", "center", true, false, false, true)
	end
	if EditSelectedSec then
		if getTickCount() - (countL or 0) < 500 then
			dxDrawText("|", x+widthTextSec, y-1, w+x, h + y-1, tocolor(255, 255, 255, alpha), 1, regular,"center", "center", true, false, false, true)
		end
	end
end

function getDxEditTextSec()
	return EditTextSec or ""
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