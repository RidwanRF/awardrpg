setTimer(function()
    local x, y, z = getElementPosition(localPlayer)
    for i = 0, 49 do
        local gx, gy, gz = getGaragePosition(i)
        local distance = getDistanceBetweenPoints3D(gx, gy, gz, x, y, z)
        local garageState = distance < 25
        if isGarageOpen(i) ~= garageState then
            setGarageOpen(i, garageState)
        end
    end
end, 1000, 0)