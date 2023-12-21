---------------------------------------------------------------------------------------------
-- Синхронизация угла открытия кастомных капотов и багажников со стандартными капотами GTA --
---------------------------------------------------------------------------------------------

local streamedVehicles = {}

local function getModelDoorsAngle(model, ratio)
    if Config.customDoorAngles[model] then
        return unpack(Config.customDoorAngles[model])
    else
        return 0, 0, Config.doorOpenAngle
    end
end

local function getDoorOpenRatio(vehicle, id)
    local ratio = vehicle:getDoorOpenRatio(id)
    if not ratio or vehicle:getDoorState(id) == 10 then
        vehicle:setDoorOpenRatio(id, 0)
        ratio = 0
    end
    return ratio
end

-- Автоматически закрывать капот и багажник
setTimer(function ()
    for vehicle in pairs(streamedVehicles) do
        if vehicle:getDoorState(0) == 4 then
            vehicle:setDoorState(0, 0)
            vehicle:setDoorOpenRatio(0, 0)
        end
        if vehicle:getDoorState(1) == 4 then
            vehicle:setDoorState(1, 0)
            vehicle:setDoorOpenRatio(0, 0)
        end
    end
end, 1000, 0)

function getVehicleTrunkOpenAngle(vehicle)
    if not vehicle then
        return
    end
    if Config.overrideAngles[vehicle.model] and Config.overrideAngles[vehicle.model].trunkOpenAngle then
        return Config.overrideAngles[vehicle.model].trunkOpenAngle
    else
        return Config.trunkOpenAngle
    end
end

addEventHandler("onClientPreRender", root, function ()
    for vehicle, components in pairs(streamedVehicles) do
        local overrideAngles = Config.overrideAngles[vehicle.model] or {}

        -- Капот
        local bonnetOpenRatio = getDoorOpenRatio(vehicle, 0)
        local bonnetOpenAngle = overrideAngles.bonnetOpenAngle or Config.bonnetOpenAngle
        vehicle:setComponentRotation(components.bonnet, bonnetOpenRatio * bonnetOpenAngle, 0, 0)

        -- Багажник
        local trunkOpenRatio = getDoorOpenRatio(vehicle, 1)
		if (not Config.customTrunkAngle[vehicle.model]) then
			local trunkOpenAngle = trunkOpenRatio * (overrideAngles.trunkOpenAngle or Config.trunkOpenAngle)
			-- Обновить положение компонентов, привязанных к багажнику
			vehicle:setComponentRotation(components.trunk,        trunkOpenAngle, 0, 0)
            vehicle:setComponentRotation(components.trunk_badge,  trunkOpenAngle, 0, 0)
			vehicle:setComponentRotation(components.trunk_lights, trunkOpenAngle, 0, 0)

			if components.spoiler and not vehicle:getData("brake_spoiler_state") then
                -- Если для машины прописана функция спойлера и не запущена анимация
                if not isVehicleActivepartsAnimated(vehicle) and
                       AnimationParams[vehicle.model] and
                       AnimationParams[vehicle.model].spoilerFunc
                then
                    -- Прогресс анимации в зависимости от того, закрыт или открыт спойлер
                    local progress = 0
                    if vehicle:getData("active_components_state") then
                        progress = 1
                    end
                    AnimationParams[vehicle.model].spoilerFunc(vehicle, trunkOpenRatio, progress)
                elseif overrideAngles.spoilerOpenAngle then
                    vehicle:setComponentRotation(components.spoiler, trunkOpenRatio * overrideAngles.spoilerOpenAngle, 0, 0)
                else
				    vehicle:setComponentRotation(components.spoiler, trunkOpenAngle, 0, 0)
                end
			end
		else
			-- Кастомная задняя дверь (вбок например)
			local angle = Config.customTrunkAngle[vehicle.model]
			vehicle:setComponentRotation(components.trunk,       trunkOpenRatio*angle.x, trunkOpenRatio*angle.y, trunkOpenRatio*angle.z)
			vehicle:setComponentRotation(components.trunk_badge, trunkOpenRatio*angle.x, trunkOpenRatio*angle.y, trunkOpenRatio*angle.z)
			-- На спойлер временно забьем
		end

        -- Передние двери
        local leftDoorRatio = getDoorOpenRatio(vehicle, 2)
        local rightDoorRatio = getDoorOpenRatio(vehicle, 3)
		if (not AnimationParams[vehicle.model]) or (not AnimationParams[vehicle.model].frontDoorsFunc) then
			local fx, fy, fz = getModelDoorsAngle(vehicle.model)
			vehicle:setComponentRotation(components.door_lf, -leftDoorRatio*fx, -leftDoorRatio*fy, -leftDoorRatio*fz)
			vehicle:setComponentRotation(components.door_rf, -rightDoorRatio*fx, rightDoorRatio*fy, rightDoorRatio*fz)
		else
			AnimationParams[vehicle.model].frontDoorsFunc(vehicle, leftDoorRatio, rightDoorRatio)
		end

        -- Компоненты, прикреплённые к задним дверям
        leftDoorRatio = getDoorOpenRatio(vehicle, 4)
        rightDoorRatio = getDoorOpenRatio(vehicle, 5)
		if (not AnimationParams[vehicle.model]) or (not AnimationParams[vehicle.model].frontDoorsFunc) then
			local fx, fy, fz = getModelDoorsAngle(vehicle.model)
			vehicle:setComponentRotation(components.door_lr, -leftDoorRatio*fx, -leftDoorRatio*fy, -leftDoorRatio*fz)
			vehicle:setComponentRotation(components.door_rr, -rightDoorRatio*fx, rightDoorRatio*fy, rightDoorRatio*fz)
		else
			AnimationParams[vehicle.model].frontDoorsFunc(vehicle, leftDoorRatio, rightDoorRatio)
		end
        -- Обновить положение компонентов, прикреплённых к задним дверям
        vehicle:setComponentRotation("doorfender_lr" .. components.fenders_r, 0, 0, -leftDoorRatio * Config.doorOpenAngle)
        vehicle:setComponentRotation("doorfender_rr" .. components.fenders_r, 0, 0, rightDoorRatio * Config.doorOpenAngle)
        vehicle:setComponentRotation("glass_lr"      .. components.fenders_r, 0, 0, -leftDoorRatio * Config.doorOpenAngle)
        vehicle:setComponentRotation("glass_rr"      .. components.fenders_r, 0, 0, rightDoorRatio * Config.doorOpenAngle)
    end
end)

local function getActiveComponent(vehicle, name)
    local id = getVehicleComponentId(vehicle, name)
    if type(id) ~= "number" then
        id = 0
    end
    return id
end

-- Добавляет автомобиль в таблицу машин, для которых каждый кадр будет изменяться положение капота, спойлера и т. д.
-- Если автомобиль уже добавлен в таблицу - обновляет название компонентов, положение которых нужно изменять
function setupVehicleComponentsOpening(vehicle)
    if not isElement(vehicle) then
        return
    end
    local spoilerId = getVehicleSpoilerId(vehicle)
    streamedVehicles[vehicle] = {
        bonnet      = "bonnet"       .. getActiveComponent(vehicle, "bonnet"),
        trunk       = "trunk"        .. getActiveComponent(vehicle, "trunk"),
        trunk_badge = "trunk_badge"  .. getActiveComponent(vehicle, "trunk_badge"),
        spoiler     = "spoiler"      .. tostring(spoilerId),
        -- Передние двери
        door_rf     = "door_pside_f" .. getActiveComponent(vehicle, "door_pside_f"),
        door_lf     = "door_dside_f" .. getActiveComponent(vehicle, "door_dside_f"),
        -- Задние двери
        door_rr     = "door_pside_r" .. getActiveComponent(vehicle, "door_pside_r"),
        door_lr     = "door_dside_r" .. getActiveComponent(vehicle, "door_dside_r"),
        -- Активные фендеры
        fenders_r   = getActiveComponent(vehicle, "fenders_r"),
        -- Фары на багажнике
        trunk_lights = "trunk_lights" .. getActiveComponent(vehicle, "tail_lights")
    }

    local disabledSpoilers = Config.disableTrunkSpoiler[vehicle.model]
    -- Если в конфиге лежит таблица с ID спойлеров
    if spoilerId and type(disabledSpoilers) == "table" and disabledSpoilers[spoilerId] then
        streamedVehicles[vehicle].spoiler = nil
    elseif type(disabledSpoilers) == "boolean" and disabledSpoilers then
        streamedVehicles[vehicle].spoiler = nil
    end
end

addEventHandler("onClientElementStreamIn", root, function ()
    if source and source.type == "vehicle" then
        setupVehicleComponentsOpening(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function ()
    if source and source.type == "vehicle" then
        streamedVehicles[source] = nil
    end
end)

addEventHandler("onClientElementDestroy", root, function ()
    if source and source.type == "vehicle" then
        streamedVehicles[source] = nil
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        if vehicle.streamedIn then
            setupVehicleComponentsOpening(vehicle)
        end
    end
end)
