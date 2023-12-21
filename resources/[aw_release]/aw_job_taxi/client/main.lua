sw, sh = guiGetScreenSize()

zoom = 1
local baseX = 1920
local minZoom = 2
if sw < baseX then
  zoom = math.min(minZoom, baseX/sw)
end

sx,sy = guiGetScreenSize();
local px, py = sx/1920, sy/1080
screenW,screenH = (sx/px), (sy/py);


local startJobX, startJobY = screenW/2-100/2, screenH/2-300/2
local startX, startY = screenW/2-600/2, screenH/2-400/2

BoldBig = dxCreateFont("assets/Montserrat-Bold.ttf", 38*px)
Bold = dxCreateFont("assets/Montserrat-Bold.ttf", 24*px)
BoldMini = dxCreateFont("assets/Montserrat-Bold.ttf", 14*px)
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 13*px)
SemiBold2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 38*px)
SemiBoldBig2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 15*px)
SemiBoldBig3 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 38*px)
SemiBoldMini = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px)
SemiBoldMini2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 19*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 13*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 13*px)
RegularMini = dxCreateFont("assets/Montserrat-Regular.ttf", 12*px)
RegularMini2 = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px)



local assets = {
 
    job1 = dxCreateTexture ("assets/aw_ui_taxi_button_job1.png"),
    job2 = dxCreateTexture ("assets/aw_ui_taxi_button_job2.png"),

    close1 = dxCreateTexture ("assets/aw_ui_taxi_button_close1.png"),
    close2 = dxCreateTexture ("assets/aw_ui_taxi_button_close2.png"),

    rent1 = dxCreateTexture ("assets/aw_ui_taxi_button_rent1.png"),
    rent2 = dxCreateTexture ("assets/aw_ui_taxi_button_rent2.png"),

    end1 = dxCreateTexture ("assets/aw_ui_taxi_button_end1.png"),
    end2 = dxCreateTexture ("assets/aw_ui_taxi_button_end2.png"),

}

local alpha = 0
local tick, state

local current = {
	companyID = false,
	order = false,
	timer = false,
	marker = false,
	blip = false,
	pay = false,
}

local dataJob = {
	active = false,
	salary = false,
	routes = false,
}

local menu = {
	selected = 0,
	refresh = true,
	orders = {},
	visibleOrders = {},
}

bindKey("n", "down", function ()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if dataJob.active and vehicle and getElementData(vehicle, "vehicle:taxi") and getElementData(vehicle, "vehicle:taxi").owner == localPlayer and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		if not isEventHandlerAdded("onClientRender", root, taxiMenuRender) then
			state = true
			tick = getTickCount()
			addEventHandler("onClientRender", root, taxiMenuRender)
			showCursor(true)
		else
			state = nil
			tick = getTickCount()
			showCursor(false)
		end
	end
end)

for i,v in pairs(config.poses) do
	local pickup = createPickup(v.pickup[1], v.pickup[2], v.pickup[3], 3, 1275, 5)
	createBlipAttachedTo(pickup, 33, 2, 255, 255, 255, 255, 0, 55)
	addEventHandler("onClientPickupHit", pickup, function(player)
		if player == localPlayer and not getPedOccupiedVehicle(localPlayer) then
			if not isEventHandlerAdded("onClientRender", root, jobMenuRender) then
				addEventHandler("onClientRender", root, jobMenuRender)
				showCursor(true)
				showChat(false)
				hud = exports.aw_interface_hud:anim_true()
				radar = exports.aw_interface_radar:anim_true()
				current.companyID = i
			end
		end
	end)
end


jobMenuRender = function ()

	if tick then
		if state then
			alpha, alpha2 = interpolateBetween(0,0,0,255,50,0, (getTickCount() - tick)/500, "OutQuad")
		else
			alpha, alpha2 = interpolateBetween(255,50,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")
		end
	end
	if not dataJob.active then 

		dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/aw_ui_taxi_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

		dxDrawImage(sx/2-(-30/2)*px, sy/2-(1000/2)*py, 956*px, 1066*py, "assets/aw_ui_taxi_human.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawImage(sx/2-(1920/2)*px, sy/2-(-280/2)*py, 1920*px, 400*py, "assets/aw_ui_taxi_humanblackout.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
	--	dxDrawImage(sx/2-(1614/2)*px, sy/2-(774/2)*py, 479*px, 32*py, "assets/aw_ui_taxi_premium.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
		dxDrawImage(sx/2-(1620/2)*px, sy/2-(-406/2)*py, 30*px, 30*py, "assets/aw_ui_taxi_money.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
		dxDrawButton(sx/2-(1620/2)*px, sy/2-(-664/2)*py, 421*px, 57*py, assets.rent1, assets.rent2, 1) 
		dxDrawButton(sx/2-(740/2)*px, sy/2-(-664/2)*py, 407*px, 57*py, assets.job1, assets.job2, 2) 
	    dxDrawButton(sx/2-(-110/2)*px, sy/2-(-664/2)*py, 125*px, 57*py, assets.close1, assets.close2, 3) 


		dxDrawText("Работа\nВодителем такси", sx/2-(1623/2)*px, sy/2+(0/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldBig, "left", "center", false, false, false, false, false)
		dxDrawText("Забирайте пассажиров и перевозите их. Для завершения работы припаркуйте рабочий\nтранспорт неподалеку и зайдите на данный маркер снова.", sx/2-(1623/2)*px, sy/2+(235/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67), 1, Medium, "left", "center", false, false, false, false, false)
		dxDrawText("Меню заказов можно открыть нажав на N  •  Вы можете арендовать транспорт или работать на своем", sx/2-(1623/2)*px, sy/2+(370/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, Medium, "left", "center", false, false, false, false, false)
	   
	    dxDrawText("Примерный заработок в час ~", sx/2-(1623/2)*px, sy/2+(590/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, Regular, "left", "center", false, false, false, false, false)
	    dxDrawText("180 000 000", sx/2-(1500/2)*px, sy/2+(730/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, SemiBold, "left", "center", false, false, false, false, false)

	else

		dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/aw_ui_taxi_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

		dxDrawImage(sx/2-(-30/2)*px, sy/2-(1000/2)*py, 956*px, 1066*py, "assets/aw_ui_taxi_human.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawImage(sx/2-(1920/2)*px, sy/2-(-280/2)*py, 1920*px, 400*py, "assets/aw_ui_taxi_humanblackout.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
		--dxDrawImage(sx/2-(1614/2)*px, sy/2-(774/2)*py, 479*px, 32*py, "assets/aw_ui_taxi_premium.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
		dxDrawImage(sx/2-(1620/2)*px, sy/2-(-406/2)*py, 30*px, 30*py, "assets/aw_ui_taxi_money.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
		dxDrawButton(sx/2-(1620/2)*px, sy/2-(-664/2)*py, 333*px, 57*py, assets.end1, assets.end2, 4) 
	    dxDrawButton(sx/2-(895/2)*px, sy/2-(-664/2)*py, 125*px, 57*py, assets.close1, assets.close2, 5) 

		dxDrawText("Работа\nВодителем такси", sx/2-(1623/2)*px, sy/2+(0/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldBig, "left", "center", false, false, false, false, false)
		dxDrawText("Забирайте пассажиров и перевозите их. Для завершения работы припаркуйте рабочий\nтранспорт неподалеку и зайдите на данный маркер снова.", sx/2-(1623/2)*px, sy/2+(235/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67), 1, Medium, "left", "center", false, false, false, false, false)
		dxDrawText("Меню заказов можно открыть нажав на N  •  Вы можете арендовать транспорт или работать на своем", sx/2-(1623/2)*px, sy/2+(370/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, Medium, "left", "center", false, false, false, false, false)
	   
	    dxDrawText("Примерный заработок в час ~", sx/2-(1623/2)*px, sy/2+(590/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, Regular, "left", "center", false, false, false, false, false)
	    dxDrawText("180 000 000", sx/2-(1500/2)*px, sy/2+(730/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255), 1, SemiBold, "left", "center", false, false, false, false, false)

	end


end

taxiMenuRender = function ()
	if tick then
		if state then
			alpha, alpha2 = interpolateBetween(0,0,0,255,25,0, (getTickCount() - tick)/500, "OutQuad")
		else
			alpha, alpha2 = interpolateBetween(255,25,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")
		end
	end
	--dxDrawImage(startX, startY+ alpha2-25, 600, 400, "assets/images/main.png",0,0,0, tocolor(255,255,255,alpha))
	
	dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/aw_ui_taxi_black.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)


	if menu.selected == 0 then
		if current.order then
			if isTimer(current.timer) then
				if not current.pay then
					local details = getTimerDetails(current.timer)
					local sec = -(details-3*1000*60)/1000
					local minute = math.floor(sec/60)
					if minute >= 1 then
						sec = math.floor(sec - 60*minute)
					end
					dxDrawText(string.format("%02d", minute)..":"..string.format("%02d", sec), startX, startY+80 + alpha2-25, 600, 140, tocolor(255, 255, 255, alpha), 1, SemiBold, "center", "center")
					dxDrawText("Клиент ожидает!\n\n\nНеобходимо забрать клиента в течении трёх минут,\nв противном случае заказ анулируется!", startX, startY+220, 600, 140, tocolor(150, 150, 150, alpha), 1, SemiBold, "center", "center")
				else
					local details = getTimerDetails(current.timer)
					local sec = -(details-5*1000*60)/1000
					local minute = math.floor(sec/60)
					if minute >= 1 then
						sec = math.floor(sec - 60*minute)
					end
					dxDrawText(string.format("%02d", minute)..":"..string.format("%02d", sec), startX, startY+80+ alpha2-25, 600, 140, tocolor(255, 255, 255, alpha), 1, SemiBold, "center", "center")
					dxDrawText("Вы везете клиента!\n\n\nНеобходимо довездти клиента в течении пяти минут,\nв противном случае заказ анулируется!", startX, startY+220+ alpha2-25, 600, 140, tocolor(150, 150, 150, alpha), 1, SemiBold, "center", "center")
				end
			end
		else
		--	dxDrawImage(startX, startY+80+ alpha2-25, 600, 280, "assets/images/start.png",0,0,0, tocolor(255,255,255,alpha))
		end
	end

	if menu.selected == 2 then
		local playerData = getElementData(localPlayer, "taxi:data")
		local maxEXP = config.level.startEXP+config.level.nextEXP*(tonumber(playerData.level)-1)
		dxDrawText("Общая статистика:", startX+20, startY+100+ alpha2-25, 100, 25, tocolor(255, 255, 255, alpha), 1, Medium)
		dxDrawText("Сделано поездок: "..playerData.routes.."\n\nВсего заработано: $ "..playerData.salary.." \n\nУровень: "..playerData.level.."\n\nДо следущего уровня: "..maxEXP-tonumber(playerData.exp).." EXP", startX+20, startY+130+ alpha2-25, 100, 25, tocolor(255, 255, 255, alpha), 1, Medium)
		dxDrawText("Статистика смены:", startX+480, startY+100+ alpha2-25, 100, 25, tocolor(255, 255, 255, alpha), 1, Medium, "right")
		dxDrawText("Сделано поездок: "..(dataJob.routes or 0).."\n\nВсего заработано: $ "..(dataJob.salary or 0).."", startX+480, startY+130+ alpha2-25, 100, 25, tocolor(255, 255, 255, alpha), 1, Medium, "right")



		dxDrawRectangle(startX+75, startY + 300+ alpha2-25, 450, 1, tocolor(255, 255, 255, 35), false)
		dxDrawRectangle(startX+75, startY + 300+ alpha2-25, 450/maxEXP*tonumber(playerData.exp), 1, tocolor(255, 255, 255, alpha))
	end

	if isCursorOnElement(startX+495, startY+5, 101, 69) then
		--dxDrawRectangle(startX+495, startY+ alpha2-25, 101, 80, tocolor(35, 35, 35, alpha))
	elseif isCursorOnElement(startX+10, startY+5, 101, 69) then
		--dxDrawRectangle(startX+10, startY+ alpha2-25, 101, 80, tocolor(35, 35, 35, alpha))
	elseif isCursorOnElement(startX+125, startY+5, 101, 69) then
		--dxDrawRectangle(startX+115, startY+ alpha2-25, 120, 80, tocolor(35, 35, 35, alpha))
	end
	if menu.selected == 0 then
		dxDrawImage(startX+10, startY+5+ alpha2-25, 101, 69, "assets/images/orders.png",0,0,0, tocolor(255,255,255,alpha))
		dxDrawImage(startX+125, startY+5+ alpha2-25, 101, 69, "assets/images/stats.png",0,0,0, tocolor(255,255,255,alpha))
	else
		dxDrawImage(startX+10, startY+5+ alpha2-25, 101, 69, "assets/images/back.png",0,0,0, tocolor(255,255,255,alpha))
		dxDrawImage(startX+125, startY+5+ alpha2-25, 101, 69, "assets/images/refresh.png",0,0,0, tocolor(255,255,255,alpha))
	end
	dxDrawImage(startX+495, startY+5+ alpha2-25, 101, 69, "assets/images/exit.png",0,0,0, tocolor(255,255,255,alpha))


	if menu.selected == 1 then
		for i,v in pairs(menu.visibleOrders) do
			dxDrawImage(startX+16.5, startY+100+60*(i-1)+ alpha2-25, 567, 44, "assets/images/string.png",0,0,0, tocolor(255,255,255,alpha))
			if isCursorOnElement(startX+500, startY+100+60*(i-1)+ alpha2-25, 84, 44) then
				dxDrawImage(startX+500, startY+100+60*(i-1)+ alpha2-25, 84, 44, "assets/images/accept_hover.png",0,0,0, tocolor(255,255,255,alpha))
			else
				dxDrawImage(startX+500, startY+100+60*(i-1)+ alpha2-25, 84, 44, "assets/images/accept.png",0,0,0, tocolor(255,255,255,alpha))
			end
			local countryOut = getZoneName(v.start)
			local countryIn = getZoneName(v.stop)
			dxDrawText("Клиент: #969696"..v.client, startX+70, startY+100+60*(i-1)+ alpha2-25, 100, 22, tocolor(255, 255, 255, alpha), 1, SemiBold, "left", "center", false, false, false, true)
			dxDrawText("Маршрут: #969696"..countryOut.." - "..countryIn, startX+70, startY+100+60*(i-1)+22+ alpha2-25, 100, 22, tocolor(255, 255, 255, alpha), 1, SemiBold, "left", "center", false, false, false, true)
		end
	end



	dxDrawText("Свободен", startX+150, startY+365+ alpha2-25, 100, 33, tocolor(255, 255, 255, alpha), 1, Regular, "right", "center")
	if isTimer(current.timer) then
		dxDrawImage(startX+600/2-33/2-20, startY+365+ alpha2-25, 33, 33, "assets/images/round.png",0,0,0, tocolor(255,255,255,alpha))
		dxDrawImage(startX+600/2-33/2+20, startY+365+ alpha2-25, 33, 33, "assets/images/round_2.png", 0, 0, 0, tocolor(255, 100, 100, alpha))
	else
		dxDrawImage(startX+600/2-33/2-20, startY+365+ alpha2-25, 33, 33, "assets/images/round_2.png", 0, 0, 0, tocolor(100, 255, 100, alpha))
		dxDrawImage(startX+600/2-33/2+20, startY+365+ alpha2-25, 33, 33, "assets/images/round.png",0,0,0, tocolor(255,255,255,alpha))
	end
	dxDrawText("Занят", startX+350, startY+365+ alpha2-25, 100, 33, tocolor(255, 255, 255, alpha), 1, Regular, "left", "center")


	local time = string.format("%02d", getRealTime().hour)..":"..string.format("%02d", getRealTime().minute)
	dxDrawText(time, startX+395, startY+360+ alpha2-25, 200, 40, tocolor(255, 255, 255, alpha), 1, SemiBold, "right", "center")
	if alpha == 0 then
		removeEventHandler("onClientRender", root, taxiMenuRender)
	end
end


addEventHandler("onClientClick", root, function (btn, state)
	if isEventHandlerAdded("onClientRender", root, taxiMenuRender) then
		if btn == "left" and state == "down" then
			if isCursorOnElement(startX+10, startY+5, 101, 69) then
				if menu.selected == 0 then
					menu.selected = 1 
				elseif menu.selected == 1 then
					menu.selected = 0
				elseif menu.selected == 2 then
					menu.selected = 0
				end
			end
			if isCursorOnElement(startX+495, startY+5, 101, 69) then
				showCursor(false)
			    showChat(true)
			    hud = exports.aw_interface_hud:anim_false()
			    radar = exports.aw_interface_radar:anim_false()
				removeEventHandler("onClientRender", root, taxiMenuRender)
			end
			if isCursorOnElement(startX+125, startY+5, 101, 69) then
				if menu.selected == 0 then
					menu.selected = 2 
				end
				if menu.selected == 1 then
					--if menu.refresh then
						menu.visibleOrders = menu.orders
						--menu.refresh = false
					--end
				end
			end
			for i,v in pairs(menu.visibleOrders) do
				if isCursorOnElement(startX+500, startY+100+60*(i-1), 84, 44) then
					if not current.order then
						current.order = v
						startOrder()
						table.remove(menu.orders, i)
						menu.visibleOrders = menu.orders
						menu.selected = 0
					end
				end
			end
		end
	end
end)

onPlayerEnterVehicleJob = function (player)
	if player == localPlayer then
		setElementData(source, "vehicle:taxi", {owner = player})
		removeEventHandler("onClientVehicleEnter", root, onPlayerEnterVehicleJob)
	end
end

getTaxiVehicleFromPlayer = function (player)
	for i,vehicle in pairs(getElementsByType("vehicle")) do
		if getElementData(vehicle, "vehicle:taxi") then
	 		local data = getElementData(vehicle, "vehicle:taxi")
			if data.owner == player then
	 			return vehicle
	 		end
	 	end
	end
	return false
end

addEvent("onClientElementDestroy", true)
addEventHandler("onClientElementDestroy", root, function ()
	local vehicle = getTaxiVehicleFromPlayer(localPlayer)
	if getElementType(source) == "vehicle" and vehicle == source then
		stopJob()
	end
end)


function destroyTimer()
    if dataJob.active then
		stopJob()
    end
end
addEvent("destroyTimer", true)
addEventHandler("destroyTimer", resourceRoot, destroyTimer)

function destroyTimers()
	setTimer(function ()
	    if dataJob.active then
			stopJob()
			outputChatBox("#FFFFFF[Работа Такси] #FF0000Вы были не активны , и мы решили вас уволить!", _, _, _ , true)
	    end
	end,5, 1)
end

addEventHandler("onClientResourceStop", root, function ()
	if dataJob.active then
		stopJob()
	end
end)

function stopJob ()
	if dataJob.active then
		dataJob.active = false
		dataJob.salary = false
		dataJob.routes = false
		current.pay = false
		stopOrder()
		outputChatBox("Смена таксистом закончена!")
		triggerServerEvent("stopTaxiJob", resourceRoot, localPlayer)
		triggerServerEvent("destroyPedTaxi", resourceRoot, localPlayer)

		if isEventHandlerAdded("onClientVehicleEnter", root, onPlayerEnterVehicleJob) then
			removeEventHandler("onClientVehicleEnter", root, onPlayerEnterVehicleJob)
		end
        
		if isTimer(resetTimer) then killTimer(resetTimer) end
        resetTimer = setTimer(destroyTimer, 500, 1, player)
	end
end
addEvent("stopJob", true)
addEventHandler("stopJob", resourceRoot, stopJob)

startJob = function (type)
	local data = getElementData(localPlayer, "taxi:data")
	if not data then
		outputChatBox("Идет создание профиля..")
		return triggerServerEvent("onPlayerCreatedTaxiProfile", localPlayer, localPlayer)
	end
	if type == 1 then
		if tonumber(data.level) >= 5 then
			addEventHandler("onClientVehicleEnter", root, onPlayerEnterVehicleJob)
			outputChatBox("Садитесь в машину, в которой будете работать!")
		else
			return outputChatBox("Работать на своей машине\nможно только с 5 уровня!")
		end
	else
		triggerServerEvent("startTaxiJob", resourceRoot, localPlayer, config.poses[current.companyID].vehicle, config.poses[current.companyID].price)
	end
	dataJob.active = true
	dataJob.salary = 0
	dataJob.routes = 0
	outputChatBox("Вы начали смену таксистом.")
end

addEventHandler("onClientClick", root, function (btn, state)
	if isEventHandlerAdded("onClientRender", root, jobMenuRender) then
		if btn == "left" and state == "down" then
			if isCursorOnElement(sx/2-(-110/2)*px, sy/2-(-664/2)*py, 125*px, 57*py) then 
				removeEventHandler("onClientRender", root, jobMenuRender)
				showCursor(false)
				showChat(true)
			    hud = exports.aw_interface_hud:anim_false()
			    radar = exports.aw_interface_radar:anim_false()
			end
			if isCursorOnElement(sx/2-(1620/2)*px, sy/2-(-664/2)*py, 421*px, 57*py) then
				if not dataJob.active then
					removeEventHandler("onClientRender", root, jobMenuRender)
					showCursor(false)
					showChat(true)
					hud = exports.aw_interface_hud:anim_false()
					radar = exports.aw_interface_radar:anim_false()
					local taximoney = getPlayerMoney()
					if taximoney >= config.poses[current.companyID].price then
						startJob(2)
					else
						outputChatBox("Недостаточно средств для аренды автомобиля!")
					end 
				end
			end 
			if dataJob.active then
				if isCursorOnElement(sx/2-(1620/2)*px, sy/2-(-664/2)*py, 333*px, 57*py) then
					removeEventHandler("onClientRender", root, jobMenuRender)
					showCursor(false)
					showChat(true)
					hud = exports.aw_interface_hud:anim_false()
					radar = exports.aw_interface_radar:anim_false()
					stopJob()
				end
			end
			if isCursorOnElement(sx/2-(895/2)*px, sy/2-(-664/2)*py, 125*px, 57*py) then
				removeEventHandler("onClientRender", root, jobMenuRender)
				showCursor(false)
				showChat(true)
			    hud = exports.aw_interface_hud:anim_false()
			    radar = exports.aw_interface_radar:anim_false()
		end
			if isCursorOnElement(sx/2-(740/2)*px, sy/2-(-664/2)*py, 407*px, 57*py) then
				if dataJob.active then return end
				removeEventHandler("onClientRender", root, jobMenuRender)
				showCursor(false)
				showChat(true)
			    hud = exports.aw_interface_hud:anim_false()
			    radar = exports.aw_interface_radar:anim_false()
				startJob(1)
			end
		end
	end
end)

startOrder = function ()
	local order = current.order
	current.timer = setTimer(function ()
		stopOrder()
	end, 3*1000*60, 1)
	current.marker = createMarker(order.start.x, order.start.y, order.start.z, "cylinder", 2, 255, 255, 100, 50)
	current.blip = createBlipAttachedTo(current.marker, 41)
	triggerServerEvent("onPlayerAcceptTaxiOrder", resourceRoot, order.start.x, order.start.y, order.start.z)
	addEventHandler("onClientMarkerHit", current.marker, function (element)
		if element == localPlayer then
			local vehicle = getPedOccupiedVehicle(localPlayer)
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if vehicle and getElementData(vehicle, "vehicle:taxi") then
				local data = getElementData(vehicle, "vehicle:taxi")
				if data.owner == localPlayer then
					destroyElement(current.marker)
					destroyElement(current.blip)
					if isTimer(current.timer) then
						killTimer(current.timer)
						current.timer = false
					end
					current.timer = setTimer(function ()
						stopOrder()
					end, 5*1000*60, 1)
					triggerServerEvent("warpPedIntoVehicleTaxi", resourceRoot)
					current.marker = createMarker(order.stop.x, order.stop.y, order.stop.z, "cylinder", 2, 255, 0, 0, 200)
					current.blip = createBlipAttachedTo(current.marker, 41)
					current.distance = math.ceil(getDistanceBetweenPoints2D(order.start.x, order.start.y, order.stop.x, order.stop.y))
					local playerData = getElementData(localPlayer, "taxi:data")
					current.pay = math.floor(current.distance*config.salary[tonumber(playerData.level)].rubles)
					current.exp = math.floor(current.distance*config.salary[tonumber(playerData.level)].exp)
					current.bons = config.salary[tonumber(playerData.level)].bons
					addEventHandler("onClientMarkerHit", current.marker, function (element)
						if element == localPlayer then
							local vehicle = getPedOccupiedVehicle(localPlayer)
							if vehicle and getElementData(vehicle, "vehicle:taxi") then
								local data = getElementData(vehicle, "vehicle:taxi")
								if data.owner == localPlayer then
									triggerServerEvent("destroyPedTaxi", resourceRoot, localPlayer, current.pay)
									local playerData = getElementData(localPlayer, "taxi:data")
									playerData.routes = tonumber(playerData.routes) + 1
									playerData.salary = tonumber(playerData.salary) + current.pay
									dataJob.routes = dataJob.routes + 1
									dataJob.salary = dataJob.salary + current.pay
									setElementData(localPlayer, "taxi:data", playerData)
									outputChatBox ("Клиент заплатил вам $ "..current.pay)
									outputChatBox ("Опыта получено: "..current.exp)
									giveEXP(current.exp)
									--exports.mtaMain:givePlayerBons(localPlayer, current.bons)
									stopOrder()
								end
							end
						end
					end)
				end
			end
		end
	end)
end

stopOrder = function ()
	if isElement(current.marker) then
		destroyElement(current.marker)
		destroyElement(current.blip)
	end
	if isTimer(current.timer) then
		killTimer(current.timer)
	end
	current.timer = false
	current.order = false
	current.pay = false
	menu.orders = {}
	--menu.refresh = true
end

getRandomOrders = function ()
	local goodDistances = {}
	local x, y, _ = getElementPosition(localPlayer)
	for i, point in ipairs(config.points) do
		local dist = getDistanceBetweenPoints2D(x, y, point[1], point[2])
		if (dist > 300) and (dist < 500) then
			table.insert(goodDistances, i)
		end
	end
	if #goodDistances == 0 then
		local pointDist, pointID = 65535, nil
		for i, point in ipairs(config.points) do
			local dist = getDistanceBetweenPoints2D(x, y, point[1], point[2])
			if (dist > 500) and (dist < pointDist) then
				pointDist = dist
				pointID = i
			end
		end
		table.insert(goodDistances, pointID)
	end
	return goodDistances
end

refreshOrders = function ()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if dataJob.active and vehicle and getElementData(vehicle, "vehicle:taxi") and getElementData(vehicle, "vehicle:taxi").owner == localPlayer and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		local goodDistances = getRandomOrders()
		if #menu.orders < 4 then
			count = math.random(1, #goodDistances)
			table.insert(menu.orders, {client = "БОТ", start = Vector3(unpack(config.points[goodDistances[count]])), stop = Vector3(unpack(config.points[math.random(1, #config.points)]))})
			outputChatBox("У вас появился новый заказ!\nМеню заказов - N")
		end
	end
end

setTimer(refreshOrders, math.random(1, 2)*1000*60, 0)

giveEXP = function (count)
	local data = getElementData(localPlayer, "taxi:data")
	if data then
		local maxEXP = config.level.startEXP+config.level.nextEXP*(tonumber(data.level-1))
		data.exp = tonumber(data.exp) + tonumber(count)
		if tonumber(maxEXP) <= data.exp then
			if tonumber(data.level) >= config.level.maximal then
				data.exp = config.level.startEXP+config.level.nextEXP*(tonumber(data.level-1))
				setElementData(localPlayer, "taxi:data", data)
				return
			end
			data.level = data.level + 1
			data.exp = (tonumber(maxEXP) - tonumber(data.exp))*-1
		end
	end
	setElementData(localPlayer, "taxi:data", data)
end


function dxDrawCursor(x,y,w,h)
	local sx, sy = guiGetScreenSize()
	if isCursorShowing() then
		local mx,my = getCursorPosition() 
		local cursorx,cursory = mx*sx, my*sy
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		end
	end
    return false
end

local G_ALPHA_HOVER = {}

function dxDrawButton(X, Y, W, H, IMAGE_STATE, IMAGE_HOVER, INDEX)
    if G_ALPHA_HOVER[INDEX] == nil then
        G_ALPHA_HOVER[INDEX] = {}
        G_ALPHA_HOVER[INDEX] = 0
    end
    
    
    if dxDrawCursor(X, Y, W, H) then
        if G_ALPHA_HOVER[INDEX] <= 240 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] + 12
        end
        COLOR_HOVER = tocolor(255, 255, 255,  G_ALPHA_HOVER[INDEX])
    else
        if G_ALPHA_HOVER[INDEX] ~= 0 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] - 12
        end
        COLOR_HOVER = tocolor(255, 255, 255,  G_ALPHA_HOVER[INDEX])
    end
    dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, COLOR_STATE)
    dxDrawImage(X, Y, W, H, IMAGE_HOVER, 0,0,0, COLOR_HOVER)
end