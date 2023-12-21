function replaceModel()
    txd = engineLoadTXD('flag.txd',3853)
    engineImportTXD(txd,3853)
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )