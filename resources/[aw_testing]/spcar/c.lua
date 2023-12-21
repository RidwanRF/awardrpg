local gui = {}

        gui.window = guiCreateWindow(0.33, 0.27, 0.35, 0.57, "SpawnCar", true)
        guiWindowSetSizable(gui.window, false)
		guiSetVisible(gui.window, false)

        gui.label = guiCreateLabel(0.21, 0.06, 0.58, 0.23, "SpawnCar", true, gui.window)
        guiSetFont(gui.label, "default-bold")
        guiLabelSetColor(gui.label, 253, 236, 47)
        guiLabelSetHorizontalAlign(gui.label, "center", false)
        gui.editbox = guiCreateEdit(0.29, 0.32, 0.42, 0.18, "Введите в это поле ID авто", true, gui.window)
        gui.button = guiCreateButton(0.28, 0.67, 0.42, 0.19, "Заспавнить", true, gui.window) 


local function spawn()
 local spawncar = guiGetText(gui.editbox)
 spawncar = tonumber(spawncar)
 if not spawncar then
    outputChatBox("Введите правильный ID транспорта! 400 - 611", 255,0,0)

 
         return
     end
	 triggerServerEvent("spawncarServer2", resourceRoot, spawncar)
	 guiSetVisible(gui.window, false)
     showCursor(false)
end
addEventHandler("onClientGUIClick", gui.button, spawn, false)		
	
local function spawncarGUI()
guiSetVisible(gui.window, true)
showCursor(true, true)

end
addCommandHandler("spcar", spawncarGUI)

	
