local unlerp = function(from,to,lerp) return (lerp-from)/(to-from) end
 
function dxDrawProgressBar( startX, startY, width, height, progress, color, backColor )
    dxDrawRectangle (startX, startY, width, height, backColor)
	dxDrawRectangle (startX + 1*px, startY + 1*py, (width - 2*px)*progress, height - 2*py, color)
	dxDrawText ("Идет пропись колес ("..math.floor(progress*100).."%)", startX, startY, startX + width, startY + height, tocolor (255, 255, 255), 1.7, "default-bold", "center", "center")
end