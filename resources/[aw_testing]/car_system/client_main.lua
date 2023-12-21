 
local bannedSirenCars = {
	[416] = true,	-- Ambulance
	[490] = true,	-- Range Rover SVAutobiography
	[596] = true,	-- Audi A8 D4
	[598] = true,	-- Mercedes-Benz E63 AMG
	[599] = true,	-- Toyota Land Cruiser 200
}
local alpha = 0
local tick, states
local serverNumber = tonumber(exports.config:getCCDPlanetNumber() or 0)

local colors = {
	[0] = {
		on = tocolor (155, 129, 144),
	},
	[1] = {
		on = tocolor (30, 129, 144),
	},
	[2] = {
		on = tocolor(194,152,0),
	},
}

local settingsFile = "settings.json"
usedautoColshape = createColRectangle(1692.502441, -1142.171875, 9, 25) -- Б/у салон

local currencyTable = {
	-- RUB = "₽",
	RUB = " руб.",
	USD = "$",
	EUR = "€",
}

local suppressF3Colshapes = {
	createColSphere(-2730, 1827, -1, 200),			-- Тюрьма
	createColCuboid(-3135, -1677, 50, 73, 14, 6),	-- Шахта, проход
	createColCuboid(-3232, -1753, 47, 108, 77, 7),	-- Шахта, основная часть
}
local teleportBlockCoords = {x = -2730, y = 1827, radius = 200}

GUI = {
	window = {}, 
	label = {}, 
	gridlist = {}, 
	edit = {},
	button = {},
    staticimage = {},
	radiobutton = {},
	checkbox = {},
}
local screenW, screenH = guiGetScreenSize()
local minimalSize = {x = 310, y = 440}
local vehListData = { [-1]={} }
local fuelTable = {
	[0] = 0,
}


function createPlayerWindows()
	-- ===================     Главное окно     ===================
	--[[GUI.window.main = guiCreateWindow((screenW-minimalSize.x)/2, (screenH-minimalSize.y)/ 2, minimalSize.x, minimalSize.y, "Управление транспортом", false)

	GUI.button.sell = guiCreateButton(10, 30, 90, 45, "Продать", false, GUI.window.main)
	GUI.button.blip = guiCreateButton(110, 30, 90, 45, "Метка", false, GUI.window.main)
	GUI.button.lock = guiCreateButton(210, 30, 90, 45, "Откр/Закр", false, GUI.window.main)
	GUI.gridlist.vehList = guiCreateGridList(10, 85, 290, 245, false, GUI.window.main)
	guiGridListSetSortingEnabled(GUI.gridlist.vehList, false)
	guiGridListAddColumn(GUI.gridlist.vehList, "Транспорт", 0.62)
	guiGridListAddColumn(GUI.gridlist.vehList, "Номер", 0.32)
	GUI.checkbox.sortByName = guiCreateCheckBox(80, 335, 150, 15, "Сортировать по имени", false, false, GUI.window.main)
	GUI.button.respawn = guiCreateButton(10, 360, 90, 20, "Респавн", false, GUI.window.main)
	GUI.button.remove = guiCreateButton(10, 385, 90, 20, "Убрать", false, GUI.window.main)
	GUI.button.warp = guiCreateButton(110, 360, 90, 45, "Телепорт", false, GUI.window.main)
	GUI.button.freeze = guiCreateButton(210, 360, 90, 45, "Заблоки-\nровать", false, GUI.window.main)
	GUI.button.resetHandling = guiCreateButton(210, 360, 90, 45, "Сбросить хэндлинг", false, GUI.window.main)
	GUI.label.parkingLots = guiCreateLabel(10, 415, 270, 15, "Парковочных мест занято: * из *.", false, GUI.window.main)
	guiLabelSetHorizontalAlign(GUI.label.parkingLots, "center", false)]]

	-- ===================     Продажа на б/у рынок     ===================
	GUI.window.sell = guiCreateWindow((screenW-310)/2, (screenH-150)/2, 310, 150, "Внимание!", false)
	guiSetProperty(GUI.window.sell, "AlwaysOnTop", "true")
	guiWindowSetSizable(GUI.window.sell, false)
	
	GUI.label.sellText = guiCreateLabel(21, 23, 266, 36, "За сколько вы желаете выставить автомобиль на продажу? (20-70% от цены)", false, GUI.window.sell)
	guiLabelSetHorizontalAlign(GUI.label.sellText, "center", true)
	guiLabelSetColor(GUI.label.sellText, 38, 122, 216)
	GUI.edit.carPrice = guiCreateEdit(17, 58, 273, 30, "", false, GUI.window.sell)
	GUI.button.sellOK = guiCreateButton(17, 103, 149, 36, "Выставить на продажу", false, GUI.window.sell)
	GUI.button.sellCancel = guiCreateButton(181, 103, 109, 36, "Отмена", false, GUI.window.sell)

	-- ===================     Автосалон     ===================
	GUI.window.shop = guiCreateWindow(screenW-350, screenH-450, 343, 436, "Автосалон", false)
	guiWindowSetSizable(GUI.window.shop, false)
	guiSetAlpha(GUI.window.shop, 0.8)
	
	GUI.gridlist.shop = guiCreateGridList(9, 20, 324, 329, false, GUI.window.shop)
	guiGridListSetSortingEnabled(GUI.gridlist.shop, false)
	guiGridListAddColumn(GUI.gridlist.shop, "Автомобиль", 0.65)
	guiGridListAddColumn(GUI.gridlist.shop, "Цена", 0.3)
	GUI.button.buy = guiCreateButton(14, 355, 86, 56, "Купить", false, GUI.window.shop)
	guiSetProperty(GUI.button.buy, "NormalTextColour", "FF069AF8")
	GUI.button.chooseColor = guiCreateButton(128, 355, 86, 56, "Выбрать цвет", false, GUI.window.shop)
	guiSetProperty(GUI.button.chooseColor, "NormalTextColour", "FF069AF8")
	GUI.button.closeShop = guiCreateButton(237, 355, 86, 56, "Закрыть", false, GUI.window.shop)
	guiSetProperty(GUI.button.closeShop, "NormalTextColour", "FF069AF8")
		
	-- ===================     Вне GUI Editor     ===================
	guiSetVisible(GUI.window.shop, false)
	--guiSetVisible(GUI.window.main, false)
	guiSetVisible(GUI.window.sell, false)
	addWindowToCursorControl(GUI.window.shop)
	--addWindowToCursorControl(GUI.window.main)
	addWindowToCursorControl(GUI.window.sell)
	triggerServerEvent("clientStartsResource", resourceRoot)
	
	if isResourceRunning ("car_benzin") then
		fuelTable = exports.car_benzin:getFuelTable()
	end
	
	--loadSettings()
	--saveSettings()
end
addEventHandler("onClientResourceStart", resourceRoot, createPlayerWindows)

-- ===================     Сохранение и загрузка размеров главного окна     ===================
function loadSettings()
	local data
	if fileExists(settingsFile) then 
		local file = fileOpen(settingsFile, true)
		if (file) then
			data = fromJSON(fileRead(file, fileGetSize(file)))
			fileClose(file)
		end
	end
	if (type(data) ~= "table") then data = {} end

	if (type(data.size) == "table") and tonumber(data.size.x) and tonumber(data.size.y) then
		--guiSetSize(GUI.window.main, data.size.x, data.size.y, false)
		--guiSetPosition(GUI.window.main, (screenW-data.size.x)/2, (screenH-data.size.y)/2, false)
		--recalculateMainGUIElements()
	end
	
	--guiCheckBoxSetSelected(GUI.checkbox.sortByName, data.sortByName or false)
end

local saveTimer
local needsSave = false

function saveSettings()
	if isTimer(saveTimer) then
		needsSave = true
	else
		needsSave = true
		writeSettingsFile()
		saveTimer = setTimer(writeSettingsFile, 1000, 1)
	end
end

function writeSettingsFile()
	if (needsSave) then
		local data = {size={}}
		--data.size.x, data.size.y = guiGetSize(GUI.window.main, false)
		--data.sortByName = guiCheckBoxGetSelected(GUI.checkbox.sortByName)
		
		local file = fileCreate(settingsFile)
		if (file) then
			fileWrite(file, toJSON(data, true))
			fileClose(file)
		end
		needsSave = false
	end
end

-- ===================     Обработка кнопок основного окна     ===================
local oldID, sellingBaseID, sellingVehModel
function onGUIClick()
	-- local selectedID = guiGridListGetSelectedItem(GUI.gridlist.vehList)
	local carID = sellingBaseID

	if (source == GUI.button.sellOK) then
		if not isElementWithinColShape(localPlayer, usedautoColshape) then
			outputCarSystemError("Невозможно продать автомобиль. Вы и ваш автомобиль должны находиться на спец. площадке рядом со входом на б/у рынок")
			return
		end
		local _, _, costLow, costHigh = getAllSellingPrices(sellingVehModel)
		if (costLow) then
			local gotPrice = tonumber(guiGetText(GUI.edit.carPrice))
			if (gotPrice < costLow) then
				outputCarSystemError("Нельзя поставить цену меньше "..costLow.." руб.")
				return
			end
			if (gotPrice > costHigh) then
				outputCarSystemError("Нельзя поставить цену больше "..costHigh.." руб.")
				return
			end
			triggerServerEvent("SellMyVehicle", resourceRoot, sellingBaseID, gotPrice)
			hideCarWindows()
		else
			outputCarSystemError("Невозможно продать автомобиль. Банковские операции недоступны.")
		end
	elseif (source == GUI.button.sellCancel) then
		guiSetVisible (GUI.window.sell, false)
	end
end
addEventHandler("onClientGUIClick", resourceRoot, onGUIClick)

local toggle = false
function showMainPanel (state)
	if state then
		states = state
		if not isEventHandlerAdded("onClientRender", root, alphaDesert) then
			addEventHandler ("onClientRender", root, alphaDesert)
		end

		if not isEventHandlerAdded("onClientRender", root, drawMainPanel) then
			addEventHandler ("onClientRender", root, drawMainPanel)
		end

		drawdasdasd()
	else
		states = state
	end
	toggle = state
end

_dxDrawText = dxDrawText
local sx, sy = guiGetScreenSize ()
local px, py = sx/1920, sy/1080

local imgs = {
	main = dxCreateTexture ("images/main.png"),
	main_car2 = dxCreateTexture ("images/main_car2.png"),
	main_car = dxCreateTexture ("images/main_car.png"),

	buttons = dxCreateTexture ("images/buttons.png"),
	sell = dxCreateTexture ("images/sell.png"),
	spawn = dxCreateTexture ("images/spawn.png"),
	tpVeh = dxCreateTexture ("images/tpVeh.png"),
	removeVeh = dxCreateTexture ("images/removeVeh.png"),
	replaceHend = dxCreateTexture ("images/replaceHend.png"),

	obmens = dxCreateTexture ("images/obmens.png"),
	bgpok = dxCreateTexture ("images/bgpok.png"),

	spawnd = dxCreateTexture ("images/spawnd.png"),
}


local COLOR_STATE, COLOR_HOVER, tick, state
local alpha = 0

local carData
local selectedCar = nil
local click
local scroll = 0
local scrollMax = 0
local scrollAcrive = false
local size = 0

local panel = {
	x = sx/2-(468/2)*px,
	y = sy/2-(495/2)*py,
	w = 468*px,
	h = 438*py,
}
panel.xs = panel.x + 14*px

local parks = {
	filled = 0,
	all = 0,
}

local vehListData = {}
local fonts = {

	[1] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px);
	[2] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px);

	[3] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 12*px);
	[4] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px);

	[5] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 12*px);
	[6] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px);
	[7] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px);
	[8] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px);
	[10] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px);

}
local rt = dxCreateRenderTarget (296*px, 409*py, true)

local heditButton = false
local sellButton = false

local activeConverMoney = false
local RubleConverText = 0
local tickBackSpace = 0
local promoText = "#999999Ведите промокод"
local activePromoText = false
local y2 = 0

function alphaDesert()
	if states then
		if tick then
			alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - tick)/500, "OutQuad")

			alpha2 = interpolateBetween(0,0,0,50,0,0, (getTickCount() - tick)/500, "OutQuad")
		end
	else
		if tick then
			alpha = interpolateBetween(255,0,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")

			alpha2 = interpolateBetween(50,0,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")
		end
		if alpha <= 0 then
			removeEventHandler ("onClientRender", root, drawMainPanel)
			removeEventHandler ("onClientRender", root, alphaDesert)
		end
	end
end

function drawdasdasd()
	collectgarbage()
	dxSetRenderTarget (rt, true)
		if carData then
			y2 = 0
			for i, v in ipairs(carData) do
				if i == selectedCar then
					dxDrawText (getVehicleModName(v.model):sub (1, 25), 8*px, y2+15*py - scroll, 72*px, 7*py, tocolor(255, 255, 255, 255), fonts[3], "left", "center")
					dxDrawText (convertPlateIDtoLicensep(v.licensep), 8*px, y2+32*py - scroll, 72*px, 7*py, tocolor(255, 255, 255, 255), fonts[4], "left", "center")
					dxDrawImage(0, y2 - scroll, 296*px, 52*py, imgs.main_car, 0, 0, 0, tocolor(255, 255, 255, 255))
				else
					dxDrawText (getVehicleModName(v.model):sub (1, 25), 8*px, y2+15*py - scroll, 72*px, 7*py, tocolor(255, 255, 255, 255), fonts[3], "left", "center")
					dxDrawText (convertPlateIDtoLicensep(v.licensep), 8*px, y2+32*py - scroll, 72*px, 7*py, tocolor(255, 255, 255, 255), fonts[4], "left", "center")
					dxDrawImage(0, y2 - scroll, 296*px, 1*py, imgs.main_car2, 0, 0, 0, tocolor(255, 255, 255, 255))
				end

				vehListData[i] = {ID = tonumber(v.ID), model = v.model}
				y2 = y2 + 52*py
			end
			if y2 > 409*py then
				scrollMax = y2-409*py
				size = 409*py/y2*409*py
			end
		end
	dxSetRenderTarget ()
end

function drawMainPanel()
	COLOR_STATE = tocolor(255, 255, 255, alpha)
	COLOR_HOVER = tocolor(255, 255, 255, alpha)

	--dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 150*alpha/255))

	--dxDrawImage(sx/2-(472/2)*px, sy/2-(490/2)*py+alpha2-50, 470*px, 470*py, imgs.main, 0, 0, 0, tocolor(255, 255, 255, alpha), false)

	local ybut = 0

	for i = 1, 5 do 
		dxDrawButton(sx/2-(-224/2)*px, sy/2-(400/2)*py+ybut+alpha2-50, 108*px, 74*py, imgs.buttons, i, {67,67,67,alpha}, {200, 200, 200, alpha})
		ybut = ybut + 84*py
	end

	dxDrawImage(sx/2-(-278/2)*px, sy/2-(384/2)*py+alpha2-50, 54*px, 58*py, imgs.sell, 0, 0, 0, tocolor(255,255,255,alpha))
	dxDrawImage(sx/2-(-278/2)*px, sy/2-(216/2)*py+alpha2-50, 54*px, 58*py, imgs.spawn, 0, 0, 0, tocolor(255,255,255,alpha))
	dxDrawImage(sx/2-(-272/2)*px, sy/2-(48/2)*py+alpha2-50, 60*px, 58*py, imgs.tpVeh, 0, 0, 0, tocolor(255,255,255,alpha))
	dxDrawImage(sx/2-(-272/2)*px, sy/2-(-120/2)*py+alpha2-50, 60*px, 58*py, imgs.removeVeh, 0, 0, 0, tocolor(255,255,255,alpha))
	dxDrawImage(sx/2-(-240/2)*px, sy/2-(-288/2)*py+alpha2-50, 92*px, 58*py, imgs.replaceHend, 0, 0, 0, tocolor(255,255,255,alpha))


	if cursorPosition (panel.xs, panel.y + 52*py, 296*px, 409*py) then
		if getKeyState ("mouse1") and not click then
			local y2 = 0
			for i, _ in ipairs (carData) do
				if cursorPosition (panel.xs, panel.y + 52*py + y2 - scroll, 206*px, 52*py) then
					selectedCar = i
					drawdasdasd()
				end
				y2 = y2 + 52*py
			end
		end
	end

	if not cursorPosition (panel.x, panel.y, panel.w, panel.h) and getKeyState ("mouse1") and not click then
		selectedCar = nil
		drawdasdasd()
	end
	
	if y2 > 409*py then
		--dxDrawRectangle (panel.xs + 2*px + 300*px + 5*px, panel.y + 52*py+alpha2-50, 4*px, 409*py, tocolor(65, 64, 92, alpha))

	--	dxDrawRectangle (panel.xs + 2*px + 300*px + 5*px, panel.y + 52*py + scroll/scrollMax*(409*py-size)+alpha2-50, 4*px, size, tocolor(161, 160, 203, alpha))
				
		if (cursorPosition (panel.xs + 2*px + 300*px + 5*px, panel.y + 52*py, 3*px, 409*py) and getKeyState ("mouse1")) or scrollAcrive then
			local xC, yC = getCursorPosition()
			xC, yC = xC*sx, yC*sy
			
			local scroll2 = ((yC - panel.y - 52*py - size/2) / (409*py-size)) * scrollMax
			if scroll2 >= -1 and scroll2 <= scrollMax then
				scroll = ((yC - panel.y - 52*py - size/2) / (409*py-size)) * scrollMax
				drawdasdasd()
			end
			
			scrollAcrive = true
		end
		
		if not getKeyState ("mouse1") and scrollAcrive then
			scrollAcrive = false 
		end
	end

	if rt then
		dxDrawImage (panel.xs, panel.y + 52*py + alpha2-50, 296*px, 409*py, rt, 0,0,0, tocolor(255,255,255,alpha))
	end



	
	if cursorPosition (sx/2-(-224/2)*px, sy/2-(400/2)*py, 108*px, 74*py) and getKeyState("mouse1") and not click then
		if selectedCar then
			if antiDOScheck() then
				local carID = vehListData[selectedCar].ID
				sellingBaseID = carID
				sellingVehModel = vehListData[selectedCar].model
				local _, defaultPrice = getAllSellingPrices(sellingVehModel)
				if (defaultPrice) then
					guiSetText(GUI.edit.carPrice, defaultPrice)
					guiSetVisible(GUI.window.sell, true)
				else
					outputCarSystemError("Невозможно продать автомобиль. Банковские операции недоступны.")
				end
			end
		end
	end

	if cursorPosition (sx/2-(-224/2)*px, sy/2-(232/2)*py, 108*px, 74*py) and getKeyState("mouse1") and not click then
		if selectedCar then
			if antiDOScheck() then
				local carID = vehListData[selectedCar].ID
				triggerServerEvent("respawnMyVehicle", resourceRoot, carID)
				drawdasdasd()
				setTimer(function ()
					local carID = vehListData[selectedCar].ID
					triggerServerEvent("WarpMyVehicle", resourceRoot, carID)
					drawdasdasd()
				end, 500, 1)
			end
		end
	end


	if cursorPosition (sx/2-(-224/2)*px, sy/2-(64/2)*py, 108*px, 74*py) and getKeyState("mouse1") and not click then
		if selectedCar then
				if antiDOScheck() then
					local carID = vehListData[selectedCar].ID
					triggerServerEvent("WarpMyVehicle", resourceRoot, carID, true)
					drawdasdasd()
				end
			end
		end

	if cursorPosition (sx/2-(-224/2)*px, sy/2-(-104/2)*py, 108*px, 74*py) and getKeyState("mouse1") and not click then
		if selectedCar then
				if antiDOScheck() then
					local carID = vehListData[selectedCar].ID
					triggerServerEvent("removeMyVehicle", resourceRoot, carID)
					drawdasdasd()
				end
			end
		end

	if cursorPosition (sx/2-(-224/2)*px, sy/2-(-272/2)*py, 108*px, 74*py) and getKeyState("mouse1") and not click then
		if selectedCar then
			if antiDOScheck() then
				local carID = vehListData[selectedCar].ID
				triggerServerEvent("ResetVehicleHandling", resourceRoot, carID)
				drawdasdasd()
			end
		end
	end

--	dxDrawText (parks.all-parks.filled, sx/2-(-114/2)*px, sy/2-(-464/2)*py+alpha2-50, 460*px, 590*py, tocolor(255, 255, 255, 255*alpha/255), fonts[5], "left", "top")
	dxDrawText (parks.filled.." / "..parks.all, sx/2-(-154/2)*px, sy/2-(-466/2)*py+alpha2-50, 460*px, 590*py, tocolor(193, 195, 199, 255*alpha/255), fonts[6], "left", "top")

	dxDrawText ("Гаражных мест",sx/2-(468/2)*px, sy/2-(-466/2)*py+alpha2-50, 91*px, 18*py, tocolor(255, 255, 255,alpha), fonts[7], "left", "center", false)

	if getKeyState ("mouse1") then click = true else click = false end
end


function isCursorOverRectangle(x,y,w,h)
    if isCursorShowing() then
        local mx,my = getCursorPosition()
        local cursorx,cursory = mx*sx,my*sy
        if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
            return true
        end
    end
return false
end

addEventHandler ("onClientCharacter", root, function(char)
	if activePromoText then
		local w = dxGetTextWidth (promoText..char, 1, fonts[1])
		if w > 225*px then return end
		promoText = promoText..char
	end
	if activeConverMoney then
		if numbers[char] then
			local w = dxGetTextWidth (ConverText..char, 1, fonts[1])
			if w > 300*px then return end
			ConverText = ConverText..char
		end
	end
end)

addCommandHandler("lock", function()
	for _, v in ipairs (getElementsByType("vehicle", localplayer, true)) do
		local x, y, z = getElementPosition(localPlayer)
		local x1, y2, z3 = getElementPosition(v)
		if getDistanceBetweenPoints3D(x1, y2, z3, x, y, z) <= 5 then
			for _, v1 in ipairs (carData) do
				if getElementData(v, "ID") == v1.ID then
					triggerServerEvent("LockMyVehicle", resourceRoot, v1.ID)
				end
			end
		end
	end
end)

addEventHandler("onClientKey", root, function(key, presi)
	if presi and toggle then
		--if not stat_wnd_F3 then return end
		if key == "mouse_wheel_down" then
			scroll = scroll + 25
			if scroll > scrollMax then scroll = scrollMax end
			drawdasdasd()
		elseif key == "mouse_wheel_up" then
			scroll = scroll - 25
			if scroll < 0 then scroll = 0 end
			drawdasdasd()
		end
	end
end)

local G_ALPHA_HOVER = {}

function dxDrawButton(X, Y, W, H, IMAGE_STATE, INDEX, COLORSTOCK, COLORHOVER)

	local r, g, b = unpack(COLORHOVER)

    if G_ALPHA_HOVER[INDEX] == nil then
        G_ALPHA_HOVER[INDEX] = {}
        G_ALPHA_HOVER[INDEX] = 0
    end 

    if cursorPosition(X, Y, W, H) then

        if G_ALPHA_HOVER[INDEX] <= 240 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] + 10
        end

        COLOR_HOVERINCASE = tocolor(r, g, b, G_ALPHA_HOVER[INDEX])
    else

        if G_ALPHA_HOVER[INDEX] ~= 0 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] - 10
        end

		COLOR_HOVERINCASE = tocolor(r, g, b, G_ALPHA_HOVER[INDEX])
    end

    dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, tocolor(unpack(COLORSTOCK)))
	dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, COLOR_HOVERINCASE)
end

function dxDrawText (text, x, y, w, h, color, font, alingX, alignY, wordBreak)
	_dxDrawText (text, x, y, x+w, y+h, color, 1, font, alingX, alignY, _, wordBreak or false)
end

function cursorPosition(x, y, w, h)
	if (not isCursorShowing()) then
		return false
	end
	local mx, my = getCursorPosition()
	local fullx, fully = guiGetScreenSize()
	cursorx, cursory = mx*fullx, my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function openMainWindow()
	if (getElementInterior(localPlayer) == 0) and (getElementDimension(localPlayer) <= 10) and not isPlayerInSupressF3Colshape() and not getElementData(localPlayer, "isChased") then
		local state = not toggle
		--guiSetVisible(GUI.window.main, state)
		showMainPanel (state)
		guiSetVisible(GUI.window.sell, false)
		if (state) then
			heditButton = true

			if isElementWithinColShape(localPlayer, usedautoColshape) then
				sellButton = true
			else
				sellButton = false
			end
			tick = getTickCount()
			showCursor(true)
		else
			tick = getTickCount()
			hideCursor()
		end		
	else
		hideCarWindows()
	end
end
addCommandHandler("carpanel", openMainWindow, false)
addCommandHandler("cp", openMainWindow, false)
bindKey("F3", "down", "cp")

function hideCarWindows()
	--guiSetVisible(GUI.window.main, false)
	showMainPanel (false)
	guiSetVisible(GUI.window.sell, false)
	hideCursor()
end

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

function refreshGrid(data)
	carData = data or carData

	 --table.sort(carData, function(a, b) return a.userOrder < b.userOrder end)
	table.sort(carData, function(a, b)
			local nameA = utf8.lower(getVehicleModName(a.model))
			local nameB = utf8.lower(getVehicleModName(b.model))
			return nameA < nameB
		end)

	for i, dataRow in ipairs(carData) do			
		vehListData[i] = {ID = tonumber(dataRow.ID), model = dataRow.model}
	end
	
	refreshInterchangeGrid(carData)
end
addEvent("refreshCarList", true )
addEventHandler("refreshCarList", resourceRoot, refreshGrid)


--	==========     Слежение за попаданием игрока в зоны запрещения F3     ==========
function isPlayerInSupressF3Colshape()
	for _, colshape in ipairs(suppressF3Colshapes) do
		if isElementWithinColShape(localPlayer, colshape) then
			return true
		end
	end
	return false
end

function onSuppressF3ColshapeEnter(element, matchingDimension)
	if (element == localPlayer) and (matchingDimension) then
		hideCarWindows()
		ic_closeAllWindows(false)
	end
end
for _, colshape in ipairs(suppressF3Colshapes) do
	addEventHandler("onClientColShapeHit", colshape, onSuppressF3ColshapeEnter)
end

setTimer(function()
	--if guiGetVisible(GUI.window.main) then
	if toggle then
		if (getElementInterior(localPlayer) ~= 0) or (getElementDimension(localPlayer) > 10) or getElementData(localPlayer, "isChased") then
			hideCarWindows()
		end
	end
end, 100, 0)


--	==========     Получение значка валюты из таблицы     ==========
function currencyToSymbol(currency)
	currency = currency or "RUB"
	return currencyTable[currency] or ""
end

--	==========     Разделение числа на части     ==========
function explodeNumber(number)
	number = tostring(number)
	local k
	repeat
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
	until (k==0)	-- true - выход из цикла
	return number
end

--	==========     Обновление строки с занятыми местами     ==========
function catchParkingLotsCount(filled, all)
	parks.filled = filled
	parks.all = all
	--guiSetText(GUI.label.parkingLots, "Парковочных мест занято: "..filled.." из "..(all+1)..".")
end
addEvent("catchParkingLotsCount", true)
addEventHandler("catchParkingLotsCount", resourceRoot, catchParkingLotsCount)

--	==========     Вывод сообщений в формате автосалона     ==========
function outputCarSystemInfo(text)
	outputChatBox("[Автосалон] #58FAF4"..text:gsub("#цв#", "#58FAF4"), 38, 122, 216, true)
end
function outputCarSystemError(text)
	outputChatBox("[Автосалон] #FF3232"..text:gsub("#цв#", "#FF3232"), 38, 122, 216, true)
end

--	==========     Слоумод на кнопку/действие     ==========
local antiDOSdelay, triggerEventPause = 250
function antiDOScheck()
	if isTimer(triggerEventPause) then
		return false
	else
		triggerEventPause = setTimer(function() end, antiDOSdelay, 1)
		return true
	end
end

--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end

--	==========     Контроль включения мигалок     ==========
local sirenTimer
addEventHandler("onClientVehicleEnter", root, function(player, seat)
	if (player == localPlayer) then
		if (bannedSirenCars[ getElementModel(source) ]) then
			if isTimer(sirenTimer) then killTimer(sirenTimer) end
			local licensep = tostring(getElementData(source, "licensep"))
			if (licensep:sub(1,1) ~= "b") then
				sirenTimer = setTimer(controlSirens, 100, 0)
			end
		end
	end
end)

function controlSirens()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (vehicle) then
		if getVehicleSirensOn(vehicle) then
			setVehicleSirensOn(vehicle, false)
		end
	else
		if isTimer(sirenTimer) then killTimer(sirenTimer) end
	end
end


--	==========     Проверяет, не открыто ли какое-нибудь из окон     ==========
local controlledWindows = {}
function addWindowToCursorControl(window)
	table.insert(controlledWindows, window)
end

function hideCursor()
	for _, window in ipairs(controlledWindows) do
		if guiGetVisible(window) then
			return
		end
	end
	showCursor(false)
end

function clearMemory()		
	local oldGarbage = math.floor(collectgarbage("count"))
	collectgarbage()
	outputDebugString(string.lower(getResourceName (getThisResource())).." collected "..oldGarbage-math.floor(collectgarbage("count")).." of "..oldGarbage.."KB")
end
setTimer(clearMemory, 1800000, 0)
addCommandHandler ("lag", clearMemory)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
		 local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		 if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			  for i, v in ipairs( aAttachedFunctions ) do
				   if v == func then
					return true
			   end
		  end
	 end
	end
	return false
end
