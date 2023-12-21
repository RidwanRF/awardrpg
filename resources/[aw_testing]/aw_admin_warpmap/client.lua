--[Позиция по X][Позиция по Y][Позиция по Z][Максимальная скорость]
local scx,scy = guiGetScreenSize()
local px = scx/1920
local sizeX, sizeY = 400*px,600*px
local posX,posY = 10*px,scy-sizeY-100*px
local screen = dxCreateScreenSource( scx,scy )

igrok = nil

stat_wndMp = false

sWidth, sHeight = guiGetScreenSize()
Auflosung_x = 1600
Auflosung_y = 900
px = sWidth/Auflosung_x
py = sHeight/Auflosung_y
local gps=guiCreateStaticImage(500*px,150*py,600*px,600*py,"image/gps.png",false)
guiSetVisible(gps,false)
addEventHandler("onClientGUIClick",gps,function(button,state,absoluteX,absoluteY)
	if button=="left" then
		local mapposx,mapposy=guiGetPosition(gps,true)
		local mapsizex,mapsizey=guiGetSize(gps,true)
		local cursorx,cursory=getCursorPosition()
		local cursorxt=(cursorx*16000-8000)
		local cursoryt=(cursory*9000-4500)*-1--9000/ 600 = 15
		if mapposx<=cursorx and mapposy<=cursory and mapposx+mapsizey>=cursorx and mapposy+mapsizey>=cursory then
			triggerServerEvent("WarpPl", localPlayer, igrok, cursorxt,cursoryt,getGroundPosition(cursorxt,cursoryt, 3000), false)
			setTimer(function()
				triggerServerEvent("WarpPl", localPlayer, igrok, cursorxt,cursoryt,getGroundPosition(cursorxt,cursoryt, 3000), true)
			end, 50, 1)
			outputChatBox("Вы успешно телепортировали игрока "..getPlayerName(igrok).."",255,255,255,true)
		end
	end
end)

stat_wnd_tp = false

function wnd_tp ()
	dxDrawWindow(494*px,120*py,610*px,660*py, "Кликните куда желаете сделать тп")
	dxDrawButton(499*px,755*py,600*px,20*py, "Закрыть")
end

function click_mps (button, state)
	if stat_wnd_tp == true then
		if button == "left" and state == "down" then
			if cursorPosition(499*px,755*py,600*px,20*py) then
				stat_wnd_tp = false
				removeEventHandler("onClientRender", root, wnd_tp)
				guiSetVisible(gps,false)
				showCursor(false)
				igrok = nil
				clic_st = true
			end
		end
	end
end
addEventHandler("onClientClick", root, click_mps)

local selectionsi_player = 0
local presi_player = false
local scrollsi_player = 0
local scrollMaxsi_player = 0
local rtsi_player = dxCreateRenderTarget(230,255, true )
local clksi_player = false

function wnd_mp ()

	--dxDrawWindow(494*px,120*py,610*px,635*py, "Кликните куда желаете сделать тп")
	dxDrawWindow(scx / 2 - 125,scy / 2 - 150,250,325, "Выберите игрока для ТП по карте")
	dxDrawButton(scx / 2 - 120,scy / 2 + 150,240,20, "Телепорт")
	dxDrawRectangle(scx / 2 - 120,scy / 2 - 120,240,265, tocolor(0,0,0,200), false)

	------------------------------------------------------------------------------------------------------------------
	
	dxUpdateScreenSource( screen )
	dxSetRenderTarget( rtsi_player,true )
	if scrollsi_player < 0 then scrollsi_player = 0
	elseif scrollsi_player >= scrollMaxsi_player then scrollsi_player = scrollMaxsi_player end
	local sy = 0
		for k , player in pairs(getElementsByType("player")) do
			if k == selectionsi_player then
				dxDrawRectangle(0,sy-scrollsi_player,240,15,tocolor(69,69,69, 255))
			else
				dxDrawRectangle(0,sy-scrollsi_player,240,15,tocolor(150,150,150,200))
			end
			dxDrawText(getPlayerName(player),0,sy-scrollsi_player - 15,235,sy-scrollsi_player+30,tocolor(255,255,255),1,"default-bold","center","center", false, false, false, true)
			sy = sy + 16
		end
	dxSetRenderTarget()
	dxDrawImage(scx / 2 - 115,scy / 2 - 115,230,255,rtsi_player)
	if sy >= 255 then
		scrollMaxsi_player = sy-255
	end
	local spy = 0
	for k , player in pairs(getElementsByType("player")) do
		if cursorPosition(scx / 2 - 115,scy / 2 - 115,230,255) then
			if cursorPosition(scx / 2 - 115,scy / 2 - 115+spy-scrollsi_player,230,15) then
				if getKeyState("mouse1") and not clksi_player then
					selectionsi_player = k
					igrok = player
				end
			end
		end
		spy = spy + 16
	end	
	if getKeyState("mouse1") then clksi_player = true else clksi_player = false end
end

addEventHandler("onClientKey",root,function(key,presi_player)
	if presi_player then
		if not stat_wndMp then return end
		if key == "mouse_wheel_down" then
			scrollsi_player = scrollsi_player + 12
		elseif key == "mouse_wheel_up" then
			scrollsi_player = scrollsi_player - 12
		end
	end
end)

function click_mp (button, state)
	if stat_wndMp == true then
		if button == "left" and state == "down" then
			if cursorPosition(scx / 2 - 120,scy / 2 + 150,240,20) then
				if selectionsi_player == 0 then
					outputChatBox("Выберите игрока",255,255,255,true)
				else
					selectionsi_player = 0
					stat_wndMp = false
					removeEventHandler("onClientRender", root, wnd_mp)
					stat_wnd_tp = true
					addEventHandler("onClientRender", root, wnd_tp)	
					guiSetVisible(gps,true)
					clic_st = false
				end
			end
		end
	end
end
addEventHandler("onClientClick", root, click_mp)

clic_st = true

function open_MP ()
	triggerServerEvent("get_player_acl_tp",localPlayer)
	if getElementData(localPlayer, "mpPan") == true then
		if clic_st == true then
			if stat_wndMp == false then
				stat_wndMp = true
				showCursor(true)
				selectionsi_player = 0
				igrok = nil
				addEventHandler("onClientRender", root, wnd_mp)
			else
				stat_wndMp = false
				showCursor(false)
				selectionsi_player = 0
				igrok = nil
				removeEventHandler("onClientRender", root, wnd_mp)	
			end
		end
	else
		outputChatBox("Вам недоступна данная панель",255,255,255, true)
	end
end
bindKey(bind,"down",open_MP)
