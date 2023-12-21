function replaceModel()

txd = engineLoadTXD('w126.txd',482)
engineImportTXD(txd,482)
dff = engineLoadDFF('w126.dff',482)
engineReplaceModel(dff,482)
txd = engineLoadTXD('w140.txd',516)
engineImportTXD(txd,516)
dff = engineLoadDFF('w140.dff',516)
engineReplaceModel(dff,516)
txd = engineLoadTXD('w213.txd',585)
engineImportTXD(txd,585)
dff = engineLoadDFF('w213.dff',585)
engineReplaceModel(dff,585)
txd = engineLoadTXD('w222.txd',567)
engineImportTXD(txd,567)
dff = engineLoadDFF('w222.dff',567)
engineReplaceModel(dff,567)
txd = engineLoadTXD('r33.txd',410)
engineImportTXD(txd,410)
dff = engineLoadDFF('r33.dff',410)
engineReplaceModel(dff,410)


end

addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( 'reloadcar', replaceModel )