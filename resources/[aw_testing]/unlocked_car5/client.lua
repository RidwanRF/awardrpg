function replaceModel()
txd = engineLoadTXD('superfast.txd',541)
engineImportTXD(txd,541)
dff = engineLoadDFF('superfast.dff',541)
engineReplaceModel(dff,541)
txd = engineLoadTXD('F40.txd',496)
engineImportTXD(txd,496)
dff = engineLoadDFF('F40.dff',496)
engineReplaceModel(dff,496)
txd = engineLoadTXD('jeep.txd',420)
engineImportTXD(txd,420)
dff = engineLoadDFF('jeep.dff',420)
engineReplaceModel(dff,420)
txd = engineLoadTXD('clk.txd',451)
engineImportTXD(txd,451)
dff = engineLoadDFF('clk.dff',451)
engineReplaceModel(dff,451)
txd = engineLoadTXD('laferrari.txd',401)
engineImportTXD(txd,401)
dff = engineLoadDFF('laferrari.dff',401)
engineReplaceModel(dff,401)
txd = engineLoadTXD('720s.txd',415)
engineImportTXD(txd,415)
dff = engineLoadDFF('720s.dff',415)
engineReplaceModel(dff,415)
txd = engineLoadTXD('mustang.txd',412)
engineImportTXD(txd,412)
dff = engineLoadDFF('mustang.dff',412)
engineReplaceModel(dff,412)
txd = engineLoadTXD('teslaX.txd',466)
engineImportTXD(txd,466)
dff = engineLoadDFF('teslaX.dff',466)
engineReplaceModel(dff,466)
txd = engineLoadTXD('x5f95.txd',529)
engineImportTXD(txd,529)
dff = engineLoadDFF('x5f95.dff',529)
engineReplaceModel(dff,529)












end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )