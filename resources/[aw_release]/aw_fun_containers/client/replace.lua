local models = {
	{"assets/models/containers.txd", "assets/models/container_body.dff", "assets/models/container_body.col", 2555},
	{"assets/models/containers.txd", "assets/models/container_gate1.dff", "assets/models/container_gate1.col", 1867},
	{"assets/models/containers.txd", "assets/models/container_gate2.dff", "assets/models/container_gate2.col", 1868},
}

addEventHandler("onClientResourceStart",resourceRoot,
function()
	for i = 1, #models do	
		engineImportTXD(engineLoadTXD(models[i][1]),models[i][4])
		engineReplaceModel(engineLoadDFF(models[i][2]),models[i][4])
		engineReplaceCOL(engineLoadCOL(models[i][3]),models[i][4])
		engineSetModelLODDistance(models[i][4], 1500)
	end
end)

--createObject(2555, -633.93359, 2217.3457, 704)
--createObject(1934, 2876.0480957031, 1674.75, 12)
--createObject(2324, 2876.0480957031, 1674.75, 12)