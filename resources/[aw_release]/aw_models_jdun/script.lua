local txd = engineLoadTXD("jdun.txd")
            engineImportTXD(txd, 1580)
local dff = engineLoadDFF("jdun.dff", 1580)
            engineReplaceModel(dff, 1580)
local col = engineLoadCOL ("jdun.col" )
            engineReplaceCOL ( col, 1580)

local txd = engineLoadTXD("pc.txd")
            engineImportTXD(txd, 1579)
local dff = engineLoadDFF("pc.dff", 1579)
            engineReplaceModel(dff, 1579)

 local txd = engineLoadTXD("beer.txd")
            engineImportTXD(txd, 2209)
local dff = engineLoadDFF("beer.dff", 2209)
            engineReplaceModel(dff, 2209)

local txd = engineLoadTXD("campfire.txd")
            engineImportTXD(txd, 4526)
local dff = engineLoadDFF("campfire.dff", 4526)
            engineReplaceModel(dff, 4526)