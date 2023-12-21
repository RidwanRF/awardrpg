
local curDriftPoints = 0
local idleTime

maxDriftTime = 2500
local mul = 1

lastCollisionHit = getTickCount(  )

local mul = 1
local mulTable = {
    {0, 1},
    {10000, 2},
    {100000, 3},
    {200000, 4},
    {500000, 5},
}

function isValidVehicle()
    if not localPlayer.vehicle then return end

    if getVehicleOccupant(localPlayer.vehicle) ~= localPlayer
    or getVehicleType(localPlayer.vehicle) ~= "Automobile" then
        return false
    end

    -- local _,_,rz = getVehicleComponentRotation(localPlayer.vehicle, 'wheel_lb_dummy')
    -- if (math.floor(rz) ~= 180) then return end

    return localPlayer.vehicle
end

local function calcMul()
    for k,v in pairs(table.reverse(mulTable)) do
        if v[1] < curDriftPoints then
            return v[2]
        end
    end
    return 1
end

function getDriftData()
    if isElement(localPlayer.vehicle) then
        return math.floor(curDriftPoints), mul
    else
        return 0, 0
    end
end

function getDriftString()

    if not drifting then
        return 'ДРИФТ СОРВАН'
    end

    if (getTickCount() - lastCollisionHit) < 1000 then
        return 'СТОЛКНОВЕНИЕ'
    end

    if isTimer(shifintgTimer) then
        return 'ПЕРЕКЛАДКА +1000'
    end

    if curDirftAngle == 0 then
        return 'МАЛЕНЬКИЙ УГОЛ'
    end

    return 'ДРИФТ'

end

function updateDrift()

    if not isValidVehicle() then return end

    local tick = getTickCount()

    local driftAngle, velocity, side = getDriftAngle()
    curDirftAngle = driftAngle
    local _, _, rz = getElementRotation(localPlayer.vehicle)

    if isBetween( driftAngle, 20, 30 ) and getElementSpeed(localPlayer.vehicle, 'kmh') >= 50 then
        shiftingCompleteAngle = side == 'left' and rz+90 or rz-90
    end

    if not isTimer(shifintgTimer) then

        if shiftingCompleteAngle and isBetween( rz%360, shiftingCompleteAngle-10, shiftingCompleteAngle+10 ) then

            score = score + Config.shiftingAdd

            animate('drift.shifting', 1)
            shifintgTimer = setTimer(animate, 1000, 1, 'drift.shifting', 0)

            shiftingCompleteAngle = nil


        end

    end

    curDriftTime = tick - (idleTime or 0)
    drifting = curDriftTime < maxDriftTime

    if not drifting and score ~= 0 then
        triggerServerEvent("finishDrift", localPlayer, math.floor(curDriftPoints))
        curDriftPoints = 0

        score = 0
    end

    mul = calcMul()
    
    if driftAngle ~= 0 then
        if drifting then
            score = score + math.floor(driftAngle*velocity)*mul*0.7
        else
            score = math.floor(driftAngle*velocity)*mul*0.7
        end

        curDriftPoints = score
        idleTime = tick
    end
end

function getDriftAngle()
    local vx,vy,vz = getElementVelocity(localPlayer.vehicle)

    local modV = math.sqrt(vx*vx + vy*vy)

    if (getTickCount() - lastCollisionHit) < 1000 then
        return 0, modV
    end

    if not isVehicleOnGround(localPlayer.vehicle) then return 0,modV end
    
    local rx,ry,rz = getElementRotation(localPlayer.vehicle)
    local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
    local side = 'right'
    if sn < 0 then
        side = 'left'
    end
    
    if modV <= 0.2 then return 0,modV end
    
    local cosX = (sn*vx + cs*vy)/modV
    if cosX > 0.966 or cosX < 0 then return 0,modV end



    return math.deg(math.acos(cosX))*0.5, modV, side
end

addEventHandler('onClientVehicleCollision', root, function(hitElement, force)
    if source ~= localPlayer.vehicle then return end
    if force < 30 then return end


    lastCollisionHit = getTickCount()
    curDriftPoints = 0
    score = 0

end)