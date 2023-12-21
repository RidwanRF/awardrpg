sw, sh = guiGetScreenSize()

zoom = 1
local baseX = 1920
local minZoom = 2
if sw < baseX then
  zoom = math.min(minZoom, baseX/sw)
end

sx,sy = guiGetScreenSize();
local px, py = sx/1920, sy/1080
screenW,screenH = (sx/px), (sy/py);

local myScreenSource, enabled
local logo = true

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		myScreenSource = dxCreateScreenSource(sw, sh)         
	end
)
 
function cleanmyscreen()
	if myScreenSource then
		dxUpdateScreenSource( myScreenSource )                  
		dxDrawImage(sw - sw, sh - sh, sw, sh, myScreenSource, 0, 0, 0, tocolor(255,255,255, 255), true)
		if logo then
		--	dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px,1080*py, "assets/aw_ui_hideinterface.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		end
	end
end

function tooglecleanmyscreen()
	if getKeyState("lshift") or getKeyState("rshift") then
		enabled = not enabled
		if enabled then
			addEventHandler( "onClientRender", root, cleanmyscreen)
		else
			removeEventHandler( "onClientRender", root, cleanmyscreen)
		end
	end
end
bindKey ("O", "down", tooglecleanmyscreen)
