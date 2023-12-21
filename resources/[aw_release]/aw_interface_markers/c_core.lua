local sx, sy = guiGetScreenSize() 
local zoom = sx < 1920 and math.min(2, 1920 / sx) or 1

local cashe = {}
    cashe.tick = getTickCount()
    cashe.tick2 = getTickCount()
    cashe.markerTextures = {}
local t = {}
    t[1] = dxCreateTexture("files/hexagon.png", "argb", true, "clamp")

local markerTextures = {"default"}
for i, v in ipairs(markerTextures) do
    if fileExists("files/"..v..".png") then
        cashe.markerTextures[v] = dxCreateTexture("files/"..v..".png", "argb", true, "clamp")
    end
end

function renderMarkers()
    for i, v in ipairs(getMarkers()) do
        local x, y, z = getElementPosition(v)
        local markerTexture = (getElementData(v, "marker:texture") and cashe.markerTextures[getElementData(v, "marker:texture")] or cashe.markerTextures["default"])
        local r, g, b = getMarkerColor(v)
        local size2 = getMarkerSize(v)

        local size = interpolateBetween(0, 0, 0, size2, 0, 0, (getTickCount()-cashe.tick)/2000, "InOutQuad")
        local _size = interpolateBetween(0, 0, 0, size2, 0, 0,  math.max(0, (getTickCount()-cashe.tick-200))/2000, "InOutQuad")
        local __size = interpolateBetween(0, 0, 0, size2, 0, 0, math.max(0, (getTickCount()-cashe.tick-400))/2000, "InOutQuad")
        local a = interpolateBetween(255, 0, 0, 0, 0, 0, (getTickCount()-cashe.tick)/2000, "OutInQuad")
        local _a = interpolateBetween(255, 0, 0, 0, 0, 0, math.max(0, (getTickCount()-cashe.tick-200))/2000, "OutInQuad")
        local __a = interpolateBetween(255, 0, 0, 0, 0, 0, math.max(0, (getTickCount()-cashe.tick-400))/2000, "OutInQuad")

        dxDrawMaterialLine3D(x+size, y+size, z, x-size, y-size, z, t[1], 3*size, tocolor(r, g, b, a), x, y, z+1) --circle 1
       -- dxDrawMaterialLine3D(x+_size, y+_size, z, x-_size, y-_size, z, t[1], 3*_size, tocolor(r, g, b, _a), x, y, z+1) --circle2
      --  dxDrawMaterialLine3D(x+__size, y+__size, z, x-__size, y-__size, z, t[1], 3*__size, tocolor(r, g, b, __a), x, y, z+1) --circle3

        if markerTexture and getElementData(v, "marker:texture") ~= nil then
            local markerBounce = interpolateBetween(0, 0, 0, 0.3, 0, 0, (getTickCount()-cashe.tick2)/2000, "SineCurve")
        --    dxDrawMaterialLine3D(x, y, z+1+size2+markerBounce, x, y, z+1+markerBounce, markerTexture, size2, tocolor(r, g, b)) --markerTexture
        end

        if (getTickCount()-cashe.tick)/1400 >= 1 then
            cashe.tick = getTickCount()
        end
    end
end
addEventHandler("onClientRender", getRootElement(), renderMarkers)

function setMarkerTexture(marker, texture)
    setElementData(marker, "marker:texture", texture, false)
end

function setMarkerGroundTexture(marker, texture)
    setElementData(marker, "marker:groundTexture", texture, false)
end

function getMarkers()
    local t = {}
    local x, y, z = getElementPosition(localPlayer)
    local int, dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
    for i, v in ipairs(getElementsWithinRange(x, y, z, 30, "marker")) do
        if getMarkerType(v) == 'cylinder' then 
            --if getElementAlpha(v) == 0 then
                setElementAlpha(v, 35)
                local _int, _dim = getElementInterior(v), getElementDimension(v)
                if int == _int and dim == _dim then
                    t[#t+1] = v
                end
            --end
        end
    end
    return t
end