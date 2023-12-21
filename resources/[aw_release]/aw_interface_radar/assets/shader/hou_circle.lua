local circleShader = dxCreateShader ( "assets/shader/hou_circle.fx" )
local pos_start = {}
local pos_stop = {}

local sx, sy = guiGetScreenSize()
local px, py = sx/1920, sy/1080

local maskShader = dxCreateShader ( "assets/shader/hud_mask.fx" )

local renders = dxCreateRenderTarget (600, 600, true)

function hou_circle( x, y, width, height, color, angleStart, angleSweep, borderWidth, hp )
	height = height or width
	color = color or tocolor(255,255,255)
	borderWidth = borderWidth or 1e9
	angleStart = angleStart or 0
	angleSweep = angleSweep or 360
	
	if hp then
		dxSetShaderValue ( circleShader, "sCircleWidthInPixel", width )
		dxSetShaderValue ( circleShader, "sCircleHeightInPixel", height )
	else
		dxSetShaderValue ( circleShader, "sCircleWidthInPixel", width)
		dxSetShaderValue ( circleShader, "sCircleHeightInPixel", height)
	end
	dxSetShaderValue ( circleShader, "sBorderWidthInPixel", borderWidth*px )
	dxSetShaderValue ( circleShader, "sAngleStart", math.rad(angleStart) - math.pi )
	dxSetShaderValue ( circleShader, "sAngleEnd", math.rad(angleSweep) - math.pi )
	
	if hp then
		dxSetRenderTarget (renders, true)
			dxDrawImage( 0, 0, 600, 600, circleShader )
		dxSetRenderTarget ()
	else
		dxSetRenderTarget (renders, true)
			dxDrawImage( -15, -15, 630, 630, circleShader )
		dxSetRenderTarget ()
	end
	
		
	dxSetShaderValue ( maskShader, "sPicTexture", renders)
	
	dxDrawImage (x, y, width, height, maskShader, 0, 0, 0, color )
end