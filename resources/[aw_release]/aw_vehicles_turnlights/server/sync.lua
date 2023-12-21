addEvent("syncSpecialAnim", true)
addEventHandler("syncSpecialAnim", root, function ()
    triggerClientEvent("syncSpecialAnim", source)
end)
