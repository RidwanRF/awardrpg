addEventHandler("onClientResourceStart", resourceRoot, function ()
	txd = engineLoadTXD ( "dockbarr.txd" )
	engineImportTXD ( txd, 3578 )
end)

fileDelete("client.lua")