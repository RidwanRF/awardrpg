
setHeatHaze(0)
--resetHeatHaze()

local shaders = {}
textures = {}
local appliedShaders = {}

function apllyPlatesToAllCars()
	dxSetBlendMode("add")
	for _, vehicle in ipairs( getElementsByType("vehicle", root, true) ) do
		applyPlateToVehicle(vehicle)
	end
	dxSetBlendMode("blend")
end
addEvent("RefreshCarPlates", true)
addEventHandler("RefreshCarPlates", root, apllyPlatesToAllCars)
addEventHandler("onClientResourceStart", resourceRoot, apllyPlatesToAllCars)

addEventHandler("onClientElementStreamIn",root,
    function()
        if getElementType(source) == "vehicle" then
            applyPlateToVehicle(source)
        end
    end
)

addEventHandler("onClientElementStreamOut", root,
    function()
        if getElementType(source) == "vehicle" then
			if isElement(appliedShaders[source]) then
				destroyElement(appliedShaders[source])
				appliedShaders[source] = nil
			end	
        end
    end
)

addEventHandler("onClientElementDataChange", root,
	function (key, oldValue)
		if (getElementType(source) == "vehicle") and (key == "licensep" or key == "usedauto.nomer" or key == "avtosalon.nomer" or key == "job.nomer") then
			applyPlateToVehicle(source)
		end
	end
)

function applyPlateToVehicle(vehicle)
	if not isElement(vehicle) then return end
	local plateID = getElementData(vehicle, "licensep")
	if (not plateID) then plateID = getElementData(vehicle, "usedauto.nomer") end
	if (not plateID) then plateID = getElementData(vehicle, "autosalon.nomer") end
	if (not plateID) then plateID = getElementData(vehicle, "job.nomer") end
	if (not plateID) then return end
	if (not gameScreenState) then
		table.insert(delayedPlates, vehicle)
		return
	end
	--outputChatBox(tostring(plateID))
	if not isElement(shaders[plateID]) then
		if not isElement(textures[plateID]) then
			-- if (string.sub(plateID, 1, 1) ~= "h") and fileExists("images/"..plateID..".png") then
				-- textures[plateID] = dxCreateTexture("images/"..plateID..".png", "dxt1")
			-- else
				if (not generatePlate(plateID)) then return end
			-- end
		end
		dxSetBlendMode("add")
		shaders[plateID] = dxCreateShader("files/texReplace.fx", 0, 100, false, "vehicle")
		dxSetShaderValue(shaders[plateID], "gTexture", textures[plateID])
		dxSetBlendMode("blend")
	end
	dxSetBlendMode("add")
	if isElement(appliedShaders[vehicle]) then
		engineRemoveShaderFromWorldTexture(appliedShaders[vehicle], "Nomer", vehicle)
	end
	appliedShaders[vehicle] = shaders[plateID]
    engineApplyShaderToWorldTexture(shaders[plateID], "Nomer", vehicle)
	dxSetBlendMode("blend")
end

-- function repairPlates()
	-- for plateID, _ in pairs(shaders) do
		-- destroyElement(shaders[plateID])
		-- shaders[plateID] = nil
		-- destroyElement(textures[plateID])
		-- textures[plateID] = nil
		-- fileDelete("images/"..plateID..".png")
	-- end
	-- apllyPlatesToAllCars()
-- end
-- addCommandHandler("repairplates", repairPlates, false)


--addEvent("refreshPlateAfterModshop", true)
--addEventHandler("refreshPlateAfterModshop", root, applyTintToVehicle)

--[[

function f123()
	local thisRes = getElementsByType("shader", resourceRoot)
	local all = getElementsByType("shader")
	local texThisRes = getElementsByType("texture", resourceRoot)
	local allTextures = getElementsByType("texture")
	dxDrawText("thisRes = "..#thisRes.."\nall = "..#all.."\ntexThisRes = "..#texThisRes.."\nallTextures = "..#allTextures, 1213, 131, 1399, 164, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, false, false, false)
end
addEventHandler ( "onClientRender", root, f123)


]]