local vehicles = {}

addEventHandler("onResourceStop", root, function(res)
    for k,v in pairs(vehicles) do
        if v.resource == res and isElement(v.veh) then
            destroyElement(v.veh)
            table.remove(vehicles, k)
        end
    end
end, true, "low-9999")

