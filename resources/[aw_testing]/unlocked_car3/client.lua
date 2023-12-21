function replaceModel()

txd = engineLoadTXD('rs6.txd',551)
engineImportTXD(txd,551)
dff = engineLoadDFF('rs6.dff',551)
engineReplaceModel(dff,551)
txd = engineLoadTXD('s5.txd',589)
engineImportTXD(txd,589)
dff = engineLoadDFF('s5.dff',589)
engineReplaceModel(dff,589)
txd = engineLoadTXD('taycan.txd',546)
engineImportTXD(txd,546)
dff = engineLoadDFF('taycan.dff',546)
engineReplaceModel(dff,546)
txd = engineLoadTXD('2109.txd',419)
engineImportTXD(txd,419)
dff = engineLoadDFF('2109.dff',419)
engineReplaceModel(dff,419)
txd = engineLoadTXD('g80.txd',604)
engineImportTXD(txd,604)
dff = engineLoadDFF('g80.dff',604)
engineReplaceModel(dff,604)




end

addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)

addCommandHandler ( 'reloadcar', replaceModel )