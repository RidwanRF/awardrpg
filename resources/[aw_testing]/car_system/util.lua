standartR, standartG, standartB, standartH = 150, 150, 150, 150

function dxDrawCheckButton(x, y, w, h, text, chek, stat )
	local mx, my = getMousePos()
	local CR = getElementData(localPlayer, "ColorR") or standartR
	local CG = getElementData(localPlayer, "ColorG") or standartG
	local CB = getElementData(localPlayer, "ColorB") or standartB
	local CH = getElementData(localPlayer, "ColorH") or standartH
	local color1 = tocolor(CR, CG, CB, 255)
	local color2 = tocolor(255, 255, 255, 255)
	local color3 = tocolor(CR, CG, CB, 255)
	local tcolorr = tocolor(22, 22, 22, 255)
	if isPointInRect(mx, my, x, y, w, h) then
		color3 = tocolor(CR, CG, CB, CH)
	end
	local pos = x
	dxDrawRectangle(x, y, w, h, color1, false)
	dxDrawRectangle(x + 2, y + 2, w - 4, h - 4, color2, false)
	if chek then
		dxDrawRectangle(pos + 4, y + 4, w - 8, h - 8, color3, false)
	end
	
	if stat == false then
		dxDrawLine(x, y, x + w, y + h, tcolorr, 2, false)
		dxDrawLine(x, y + h, x + w, y, tcolorr, 2, false)
	end
	dxDrawText(text, pos + 25, y + 6, 30 + pos + 25, h - 12 + y + 6, tcolor, 1,1, "default-bold", "left", "center", true, false, false, true)
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

function isMouseClick()
	return wasMousePressedInCurrentFrame
end