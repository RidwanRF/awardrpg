local targetAnimData = {}
local curAnimData = {}

function setAnimData(key, speed, value)
    targetAnimData[key] = {value or 0, speed}
    curAnimData[key] = value or 0
end

function setAnimSpeed(key, speed)
    local animData = getAnimData(key)
    setAnimData(key, speed, animData)
end

function removeAnimData(key)
    if not key then return end
    targetAnimData[key] = nil
    curAnimData[key] = nil
end

function animate(key, to, callback)
    if not targetAnimData[key] then return end
    if targetAnimData[key][1] == to then return end
    targetAnimData[key][1] = to
    targetAnimData[key].callback = callback
end

function getAnimData(key)
    return curAnimData[key], (targetAnimData[key] or {})[1]
end

function getAnimDatas(keys)
    local result = {}
    for _, key in pairs(keys) do
        result[key] = curAnimData[key]
    end
    return result
end

function updateAnimationValues()
    for k,v in pairs(targetAnimData) do
        if v[1] and v[2] then
            step = (v[1] - curAnimData[k]) / (1 / (v[2]))
            curAnimData[k] = curAnimData[k] + step

            if math.abs( curAnimData[k] - v[1] ) < 0.1 and v.callback then
                v.callback()
                v.callback = nil
            end

        end
    end
end


if localPlayer then
    addEventHandler('onClientRender', root, updateAnimationValues)
else
    setTimer(function()
        updateAnimationValues()
    end, 50, 0)
end
