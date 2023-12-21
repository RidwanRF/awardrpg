local isCarshopActive = false
local skipLeaveEvent = false

function enterCarshop(carshopId)
    if isCarshopActive then
        return
    end
    triggerServerEvent("playerEnterCarshop", resourceRoot, carshopId)
end

addEvent("playerEnterCarshop", true)
addEventHandler("playerEnterCarshop", resourceRoot, function (carshopId, params)
    isCarshopActive = true

    loadCarshop(carshopId)
    showCarshopUI(true)
    CameraManager.start()
    setElementData(localPlayer, "visibleInterface", false)
    showChat(false)
    hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()
    if type(params) == "table" then
        if type(params.color) == "table" and #params.color >= 6 then
            _loadPreviewVehicleColor(unpack(params.color))
        end
    end
end)

function exitCarshop()
    if not isCarshopActive then
        return
    end
    showCarshopUI(false)
    triggerServerEvent("playerExitCarshop", resourceRoot)
end

local function handleCarshopExit()
    isCarshopActive = false

    CameraManager.stop()
    stopCarPreview()
    localPlayer.frozen = false
    showCarshopUI(false)
    showChat(true)
    hud = exports.aw_interface_hud:anim_false()
    radar = exports.aw_interface_radar:anim_false()
    speedometer = exports.aw_interface_speedometer:anim_false()
	setElementData(localPlayer, "showHud", "on")
    setElementData(localPlayer, "visibleInterface", true)
end

addEvent("playerExitCarshop", true)
addEventHandler("playerExitCarshop", resourceRoot, handleCarshopExit)
addEventHandler("onClientResourceStop", resourceRoot, handleCarshopExit)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local garageObject = createObject(Config.carshopGarageModel, Config.carshopGaragePosition)
    garageObject.dimension = Config.carshopDimension
    garageObject.interior = 1

    for id, shop in ipairs(ShopTable) do
        local marker = createMarker(shop.mrkPosX, shop.mrkPosY, shop.mrkPosZ, "cylinder", Config.doorMarkerRadius, unpack(Config.doorMarkerColor))
        marker:setData("carshopId", id, false)

        if shop.blipID then
            local blip = createBlipAttachedTo(marker, shop.blipID)
            blip.visibleDistance = 700
        end
    end
end)

addEventHandler("onClientMarkerHit", resourceRoot, function (player)
    if player ~= localPlayer then
        return
    end
    local verticalDistance = localPlayer.position.z - source.position.z
    if verticalDistance > 5 or verticalDistance < -1 then
        return
    end
    local carshopId = tonumber(source:getData("carshopId"))
    if not carshopId then
        return
    end
    if not source:getData("disabled") then
        enterCarshop(carshopId)
        source:setData("disabled", true, false)
        skipLeaveEvent = true
    end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function (player)
    if player ~= localPlayer then
        return
    end
    local verticalDistance = localPlayer.position.z - source.position.z
    if verticalDistance > 5 or verticalDistance < -1 then
        return
    end
    local carshopId = tonumber(source:getData("carshopId"))
    if not carshopId then
        return
    end
    if skipLeaveEvent then
        skipLeaveEvent = false
        return
    end
    source:setData("disabled", false, false)
end)

if Config.enableDebugCommand then
    addCommandHandler(Config.debugCommand, function (cmd, id)
        if isCarshopActive then
            exitCarshop()
        else
            enterCarshop(tonumber(id) or 1)
        end
    end)
end
