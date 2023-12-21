
addEventHandler("onPlayerLogin",root,function (_,acc)
	data = getAccountData(acc,"flares:toggle") or false
	setElementData (source, "flares:toggle",data)
	triggerClientEvent(source, "flares:toogle", root,data)
end)



addEventHandler("onPlayerQuit",root,function ()
	acc = getPlayerAccount(source)
	flares = getElementData(source,"flares:toggle") or false

	setAccountData(acc, "flares:toggle", flares)

end)
