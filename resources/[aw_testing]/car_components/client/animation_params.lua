-- Настройки анимации активных компонентов для каждого автомобиля

local function defaultSpoilerFunc(vehicle, ratio, progress, t)
    local px = t.stockX or 0
    local py = t.stockY or 0
    local pz = t.stockZ or 0
    local x = px + (t.distX or 0) * progress
    local y = py + (t.distY or 0) * progress
    local z = pz + (t.distZ or 0) * progress
    local rx = ratio * getVehicleTrunkOpenAngle(vehicle) + (t.rotX or 0) * progress
    local ry = (t.rotY or 0) * progress
    local rz = (t.rotZ or 0) * progress
    vehicle:setComponentPosition(t.name, x, y, z)
    vehicle:setComponentRotation(t.name, rx, ry, rz)
end

AnimationParams = {
    [506] = {   -- Bugatti Chiron
        spoilerFunc = function(vehicle, trunkOpenRatio, spoilerProgress)
            if vehicle:getComponentVisible("spoiler0") then
                spoilerProgress = getEasingValue(spoilerProgress, "InOutQuad")
                vehicle:setComponentRotation("spoiler0", -10*spoilerProgress, 0, 0)
                
            elseif vehicle:getComponentVisible("spoiler1") then
                spoilerProgress = getEasingValue(spoilerProgress, "InOutQuad")
                vehicle:setComponentRotation("spoiler1", -10*spoilerProgress, 0, 0)
                
            elseif vehicle:getComponentVisible("spoiler2") then
                spoilerProgress = getEasingValue(spoilerProgress, "InOutQuad")
                vehicle:setComponentRotation("spoiler2", -10*spoilerProgress, 0, 0)
            end
            vehicle:setComponentRotation("spoi", -10*spoilerProgress, 0, 0)
        end,
    },
[438] = {
        spoilerFunc = function (vehicle, ratio, progress)
            defaultSpoilerFunc(vehicle, 0, progress, {
                name = "spoiler0",
                distY = 0.04,
                distZ = -0.35,
                rotX = -20.0,
                stockX = 0,
                stockY = -1.285,
                stockZ = 0.6,
                attach = true
            })
            defaultSpoilerFunc(vehicle, 0, progress, {
                name = "spoiler1",
                distY = 0.04,
                distZ = -0.35,
                rotX = -20.0,
                stockX = 0,
                stockY = -1.285,
                stockZ = 0.6,
                attach = true
            })          
        end,

    }, 
    [536] = {   -- Koenigsegg Agera
        frontDoorsFunc = function(vehicle, leftDoorRatio, rightDoorRatio)
            local doorPoint = rotatePointAroundPointOnXY({x=-0.934, y=0.859, z=-0.180}, {x=-0.871, y=0.508, z=-0.181}, -leftDoorRatio*math.pi/2)
            local easing = getEasingValue(leftDoorRatio, "OutQuad")
            local rotX, rotY, rotZ = getEasingValue(leftDoorRatio, "InQuad")*-90, easing*math.cos(leftDoorRatio*math.pi/2)*-15, easing*math.sin(leftDoorRatio*math.pi/2)*15
            vehicle:setComponentRotation("doorArm_L", 0, 0, leftDoorRatio*-90)
            vehicle:setComponentPosition("door_L", doorPoint.x, doorPoint.y, doorPoint.z)
            vehicle:setComponentRotation("door_L", rotX, rotY, rotZ)
            vehicle:setComponentPosition("glassL", doorPoint.x, doorPoint.y, doorPoint.z)
            vehicle:setComponentRotation("glassL", rotX, rotY, rotZ)

            doorPoint = rotatePointAroundPointOnXY({x=0.933, y=0.859, z=-0.181}, {x=0.871, y=0.508, z=-0.181}, rightDoorRatio*math.pi/2)
            easing = getEasingValue(rightDoorRatio, "OutQuad")
            rotX, rotY, rotZ = getEasingValue(rightDoorRatio, "InQuad")*-90, easing*math.cos(rightDoorRatio*math.pi/2)*15, easing*math.sin(rightDoorRatio*math.pi/2)*-15
            vehicle:setComponentRotation("doorArm_R", 0, 0, rightDoorRatio*90)
            vehicle:setComponentPosition("door_R", doorPoint.x, doorPoint.y, doorPoint.z)
            vehicle:setComponentRotation("door_R", rotX, rotY, rotZ)
            vehicle:setComponentPosition("glassR", doorPoint.x, doorPoint.y, doorPoint.z)
            vehicle:setComponentRotation("glassR", rotX, rotY, rotZ)
        end
        --[[spoilerFunc = function(vehicle, trunkOpenRatio, spoilerProgress)
            local trunkAngle, spoilerPoint
            if (trunkOpenRatio == 0) then
                trunkAngle = 0
                spoilerPoint = {x=0, y=-2.110, z=0.268}
            else
                trunkAngle = -54 * trunkOpenRatio
                spoilerPoint = rotatePointAroundPointOnYZ({x=0, y=-0.389, z=0.504}, {x=0, y=-2.110, z=0.268}, math.rad(trunkAngle))
            end
            vehicle:setComponentPosition("movspoiler", spoilerPoint.x, spoilerPoint.y, spoilerPoint.z)
            vehicle:setComponentRotation("movspoiler", trunkAngle + spoilerProgress*15, 0, 0)
        end,]]
    },
    [529] = {   -- Porsche Panamera Turbo
        spoilerFunc = function(vehicle, ratio, progress)
            local trunkAngle = -54 * ratio
            local vertEasing = getEasingValue(progress, "OutBack", 0.0, 0.0, 1.5)
            local rotatEasing = getEasingValue(progress, "OutQuad")
            
            local upperPos = rotatePointAroundPointOnYZ({x=0, y=-1.094, z=0.887}, {x=(0.159*progress), y=(-1.974 - vertEasing*0.011), z=(0.558 + vertEasing*0.061)}, math.rad(trunkAngle))
            local middlePos = rotatePointAroundPointOnYZ({x=0, y=-1.094, z=0.887}, {x=0, y=(-1.994 - progress*0.031), z=(0.529 + progress*0.084)}, math.rad(trunkAngle))
            local lowPos = rotatePointAroundPointOnYZ({x=0, y=-1.094, z=0.887}, {x=0, y=(-1.963 - progress*0.02), z=(0.481 + progress*0.061)}, math.rad(trunkAngle))
        
            
            vehicle:setComponentPosition("up_left",  -upperPos.x, upperPos.y, upperPos.z)
            vehicle:setComponentRotation("up_left", trunkAngle+(-21.782*rotatEasing), 0, -1.3*vertEasing)
            
            vehicle:setComponentPosition("up_right", upperPos.x, upperPos.y, upperPos.z)
            vehicle:setComponentRotation("up_right", trunkAngle+(-21.782*rotatEasing), 0, 1.3*vertEasing)
            
            vehicle:setComponentPosition("middle",  0, middlePos.y, middlePos.z)
            vehicle:setComponentRotation("middle", trunkAngle+(-24*rotatEasing), 0, 0)
            
            vehicle:setComponentPosition("low",  0, lowPos.y, lowPos.z)
            vehicle:setComponentRotation("low", trunkAngle, 0, 0)
        end
    },

   [549] = {	-- Countach
        frontDoorsFunc = function(vehicle, leftDoorRatio, rightDoorRatio)
			local doorPoint = rotatePointAroundPointOnXY({x= -1.0410566329956, y=1.1562789678574, z=0.091153532266617}, {x= -1.0410566329956, y=1.1562789678574, z=0.091153532266617}, -leftDoorRatio*math.pi/2)
			local easing = getEasingValue(leftDoorRatio, "OutQuad")
			local rotX, rotY, rotZ = getEasingValue(leftDoorRatio, "InQuad")*-50, easing*math.cos(leftDoorRatio*math.pi/2)*-10, easing*math.sin(leftDoorRatio*math.pi/2)*-0
			vehicle:setComponentRotation("doorArm_L", 0, 0, leftDoorRatio*-90)
			vehicle:setComponentPosition("door_L", doorPoint.x, doorPoint.y, doorPoint.z)
			vehicle:setComponentRotation("door_L", rotX, rotY, rotZ)
			vehicle:setComponentPosition("window_L", doorPoint.x, doorPoint.y, doorPoint.z)
			vehicle:setComponentRotation("window_L", rotX, rotY, rotZ)

			doorPoint = rotatePointAroundPointOnXY({x=1.0410566329956, y=1.1564526557922, z=0.091552719473839}, {x=1.0410566329956, y=1.1564526557922, z=0.091552719473839}, rightDoorRatio*math.pi/2)
			easing = getEasingValue(rightDoorRatio, "OutQuad")
			rotX, rotY, rotZ = getEasingValue(rightDoorRatio, "InQuad")*-50, easing*math.cos(rightDoorRatio*math.pi/2)*15, easing*math.sin(rightDoorRatio*math.pi/2)*0
			vehicle:setComponentRotation("doorArm_R", 0, 0, rightDoorRatio*90)
			vehicle:setComponentPosition("door_R", doorPoint.x, doorPoint.y, doorPoint.z)
			vehicle:setComponentRotation("door_R", rotX, rotY, rotZ)
			vehicle:setComponentPosition("window_R", doorPoint.x, doorPoint.y, doorPoint.z)
			vehicle:setComponentRotation("window_R", rotX, rotY, rotZ)
		end,
    },


    -- Lamborghini Aventador LP700-4
    [542] = {
        spoilerFunc = function (vehicle, ratio, progress)
            defaultSpoilerFunc(vehicle, 0, progress, {
                name = "movspoiler",
                distY = -0.02,
                distZ = 0.069,
                rotX = -20.0,
                stockY = -2.389,
                stockZ = 0.35,
            })

            --[[defaultSpoilerFunc(vehicle, 0, progress, {
                name = "movspoiler2",
                distZ = 0.015,
                rotX = 3.0,
                rotY = -10.0,
                stockX = -0.804,
                stockY = -1.733,
                stockZ = 0.451
            })

            defaultSpoilerFunc(vehicle, 0, progress, {
                name = "movspoiler3",
                distZ = 0.015,
                rotX = 3.0,
                rotY = 10.0,
                stockX = 0.804,
                stockY = -1.733,
                stockZ = 0.451
            })]]--
        end,
        conflictParts = {"spoiler1", "spoiler2", "spoiler3"},
        conflictUpgradeSlots = {2},
    },
}



