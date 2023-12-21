
local _createVehicle = createVehicle
function createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    local veh
    if model >= 400 and model <= 611 then
        veh = _createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    else
        veh = _createVehicle(411, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    end

    setElementData(veh, "vehicle:model", model)

    return veh
end

function spawncarServer(plr, model)
 local x, y, z = getElementPosition(plr)
 local spcar = createVehicle(model, x, y, z)
  if not isElement(spcar) then
   outputChatBox("Введите правильный ID транспорта! 400 - 611", plr)
    return false
end
 outputChatBox("Авто "..getVehicleName(spcar).." был заспавнен")
  return spcar
end

addEvent("spawncarServer2", true)
local function halloweenspcar(model)
 local plr = client
 spawncarServer(plr, model)
 
end
addEventHandler("spawncarServer2", resourceRoot, halloweenspcar)
