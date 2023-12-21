-- Выбор свободного dimension для игрока

local dimensionsOffset = 1000
local usedDimensions = {}

function getDimensionForPlayer(player)
    if not isElement(player) then
        return 0
    end
    local maxPlayers = getMaxPlayers()
    for i = 1, maxPlayers do
        if not isElement(usedDimensions[i]) or usedDimensions[i] == player then
            usedDimensions[i] = player
            return dimensionsOffset + i
        end
    end
end

function clearPlayerDimension(player)
    if not isElement(player) then
        return
    end
    if isElement(usedDimensions[player.dimension - dimensionsOffset]) then
        usedDimensions[player.dimension - dimensionsOffset] = nil
    end
end

addEventHandler("onResourceStop", resourceRoot, function ()
    for i = 1, getMaxPlayers() do
        if isElement(usedDimensions[i]) then
            usedDimensions[i].dimension = 0
            usedDimensions[i].interior = 0
            if usedDimensions[i].vehicle then
                usedDimensions[i].vehicle.dimension = 0
                usedDimensions[i].vehicle.interior = 0
            end
        end
    end
end)