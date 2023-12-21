function replaceModel()
    local txd = engineLoadTXD('g65.txd',470)
    engineImportTXD(txd,470)
    local dff = engineLoadDFF('g65.dff',470)
    engineReplaceModel(dff,470) 

    local txd = engineLoadTXD('c63.txd',561)
    engineImportTXD(txd,561)
    local dff = engineLoadDFF('c63.dff',561)
    engineReplaceModel(dff,561) 

    local txd = engineLoadTXD('mclaren1.txd',480)
    engineImportTXD(txd,480)
    local dff = engineLoadDFF('mclaren1.dff',480)
    engineReplaceModel(dff,480) 


    local txd = engineLoadTXD('car3.txd',545)
    engineImportTXD(txd,545)
    local dff = engineLoadDFF('car3.dff',545)
    engineReplaceModel(dff, 545) 

    local txd = engineLoadTXD('750.txd',597)
    engineImportTXD(txd,597)
    local dff = engineLoadDFF('750.dff',597)
    engineReplaceModel(dff, 597) 

    local txd = engineLoadTXD('gls.txd',560)
    engineImportTXD(txd,560)
    local dff = engineLoadDFF('gls.dff',560)
    engineReplaceModel(dff,560) 

    local txd = engineLoadTXD('enzo.txd',442)
    engineImportTXD(txd,442)
    local dff = engineLoadDFF('enzo.dff',442)
    engineReplaceModel(dff,442) 


        local txd = engineLoadTXD('camry70.txd',492)
    engineImportTXD(txd,492)
    local dff = engineLoadDFF('camry70.dff',492)
    engineReplaceModel(dff,492) 
    
    
    local txd = engineLoadTXD('e34.txd',566)
    engineImportTXD(txd,566)
    local dff = engineLoadDFF('e34.dff',566)
    engineReplaceModel(dff,566) 
    
    
    local txd = engineLoadTXD('lx570.txd',579)
    engineImportTXD(txd,579)
    local dff = engineLoadDFF('lx570.dff',579)
    engineReplaceModel(dff,579)   

    local txd = engineLoadTXD('f80.txd',598)
    engineImportTXD(txd,598)
    local dff = engineLoadDFF('f80.dff',598)
    engineReplaceModel(dff,598)     
  
    local txd = engineLoadTXD('m4_G82.txd',402)
    engineImportTXD(txd,402)
    local dff = engineLoadDFF('m4_G82.dff',402)
    engineReplaceModel(dff,402)    



    
    local txd = engineLoadTXD('isf.txd',439)
    engineImportTXD(txd,439)
    local dff = engineLoadDFF('isf.dff',439)
    engineReplaceModel(dff,439)    

    








end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), replaceModel)
addCommandHandler ( 'reloadcar', replaceModel )