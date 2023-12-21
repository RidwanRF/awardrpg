local sx, sy = guiGetScreenSize() 
local zoom = sx < 1920 and math.min(2, 1920 / sx) or 1

local w, h = 12000, 2000
local kutas = dxCreateRenderTarget(w, h, true)
local x, y, z = 2193.6416015625,1394.8071289062,13.069192886353

function rt()
    dxSetRenderTarget(kutas, true)
        -- dxDrawRectangle(0, 0, w, h, tocolor(12, 12, 14))
        dxDrawText("Автосалон", w/2, h/2, _, _, white, 110, "default-bold", "center", "center")
        dxDrawText("Высокого класса", w/2, h/2+700, _, _, tocolor(144, 144, 144), 20, "default-bold", "center", "center")
    dxSetRenderTarget()


end

addEventHandler("onClientRender", root,     
    function()
    
        dxDrawMaterialLine3D(x, y, z, x, y, z-1, kutas, 5, white, false, 2193.6149902344,1393.9567871094,11.682639122009)
    
    end
)

rt()