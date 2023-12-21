

local _createVehicle = createVehicle
function createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    local veh
    if model >= 400 and model <= 611 then
        veh = _createVehicle(model, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    else
        veh = _createVehicle(411, x, y, z, rx, ry, rz, plate, direction, var1, var2)
    end

    setElementData(veh, "vehicle:model", model)
end

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


BoldBig = dxCreateFont("assets/Montserrat-Bold.ttf", 38*px)
Bold = dxCreateFont("assets/Montserrat-Bold.ttf", 24*px)
BoldMini = dxCreateFont("assets/Montserrat-Bold.ttf", 14*px)
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 13*px)
SemiBold2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 19*px)
SemiBoldBig2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 15*px)
SemiBoldMini = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px)
SemiBoldMini2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
SemiBoldBig3 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 38*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 19*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 13*px)
MediumText = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px)
RegularMini = dxCreateFont("assets/Montserrat-Regular.ttf", 12*px)
RegularMini2 = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px)



local assets = {
 
    editbox1 = dxCreateTexture ("assets/aw_ui_containers_button_editbox1.png"),
    editbox2 = dxCreateTexture ("assets/aw_ui_containers_button_editbox2.png"),

    close1 = dxCreateTexture ("assets/aw_ui_containers_button_close1.png"),
    close2 = dxCreateTexture ("assets/aw_ui_containers_button_close2.png"),

    place1 = dxCreateTexture ("assets/aw_ui_containers_button_place1.png"),
    place2 = dxCreateTexture ("assets/aw_ui_containers_button_place2.png"),
	
    take1 = dxCreateTexture ("assets/aw_ui_containers_button_take1.png"),
    take2 = dxCreateTexture ("assets/aw_ui_containers_button_take2.png"),

    sell1 = dxCreateTexture ("assets/aw_ui_containers_button_sell1.png"),
    sell2 = dxCreateTexture ("assets/aw_ui_containers_button_sell2.png"),

}


local container = {
	buy = {
		sX = screenW/2-348/2,
		sY = screenH/2-376/2,
		owner = "sell",
		startPrice = 0,
		currentPrice = 2,
	},
	control = {
		sX = screenW/2-260/2,
		sY = screenH/2-432/2,
		items = {
		},
		selected = false,
	},
	timer = false,
}

local COLOR_STATE, COLOR_HOVER, tick, state
alpha = 0


local bankMoneyRub = (exports.bank:getPlayerBankMoney("RUB") or 0) 
local bankMoneyDon = (exports.bank:getPlayerBankMoney("DONATE") or 0) 



container.buy.render = function ()
    if state then
		if tick then
			alpha, alpha2 = interpolateBetween(0,0,0,255,50,0, (getTickCount() - tick)/500, "OutQuad")
		end
	else
		if tick then
			alpha, alpha2 = interpolateBetween(255,50,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")
		end
	end
	COLOR_STATE = tocolor(255, 255, 255, alpha)
	COLOR_HOVER = tocolor(255, 255, 255, alpha)
	local isContainer = getElementData(container.current, "container:data")
	if isContainer then

		dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/aw_ui_containers_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

		dxDrawButton(sx/2-(-1630/2)*px, sy/2-(880/2)*py, 46*px, 45*py, assets.close1, assets.close2, 1)   
		dxDrawButton(sx/2-(1720/2)*px, sy/2-(-726/2)*py, 389*px, 51*py, assets.place1, assets.place2, 2)   
		dxDrawButton(sx/2-(1510/2)*px, sy/2-(-527/2)*py, 175*px, 51*py, assets.editbox1, assets.editbox2, 3)   

		dxDrawImage(sx/2-(707/2)*px, sy/2-(604/2)*py, 1196*px, 644*py, "assets/aw_ui_containers_medium.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
	
		dxDrawImage(sx/2-(1430/2)*px, sy/2-(460/2)*py, 92*px, 92*py, "assets/aw_ui_containers_noicon.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
	
		dxDrawImage(sx/2-(1703/2)*px, sy/2-(-245/2)*py, 371*px, 51*py, "assets/aw_ui_containers_leader.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
	
		dxDrawImage(sx/2-(1490/2)*px, sy/2-(40/2)*py, 155*px, 55*py, "assets/aw_ui_containers_timer.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
	
		dxDrawRectangle(sx/2-(713/2)*px, sy/2-(-777/2)*py, 1225*px, 1*py, tocolor(255, 255, 255, 67* (alpha/255)), false)
	
		dxDrawText("#999999$ #ffffff"..convertNumber(bankMoneyRub), sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBold, "right", "center", false, false, false, true, false)
	
		dxDrawText(convertNumber(bankMoneyDon).." #999999AW", sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1566/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBold, "right", "center", false, false, false, true, false)
	
		dxDrawText("Аукцион контейнеров", sx/2-(705/2)*px, sy/2+(-80/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "left", "center", false, false, false, false, false)
		dxDrawText("— Возможное содержимое контейнера", sx/2-(705/2)*px, sy/2+(187/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Medium, "left", "center", false, false, false, false, false)
	
		dxDrawText("Контейнер", sx/2-(1170/2)*px, sy/2+(50/2)*py,  sx/2-(1500/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumBig, "center", "center", false, false, false, false, false)
		dxDrawText("Начальная стоимость составляет", sx/2-(1170/2)*px, sy/2+(238/2)*py,  sx/2-(1500/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "center", "center", false, false, false, false, false)
		dxDrawText("$ "..convertNumber(isContainer.startPrice), sx/2-(1170/2)*px, sy/2+(420/2)*py,  sx/2-(1500/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig2, "center", "center", false, false, false, false, false)
		dxDrawText("Осталось времени до конца аукциона", sx/2-(1170/2)*px, sy/2+(1440/2)*py,  sx/2-(1500/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "center", "center", false, false, false, false, false)
		dxDrawText((isContainer.time or 90).." сек.", sx/2-(1072/2)*px, sy/2+(1700/2)*py,  sx/2-(1600/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBold, "center", "center", false, false, false, false, false)
		dxDrawText("Последняя ставка", sx/2-(1170/2)*px, sy/2+(2020/2)*py,  sx/2-(1500/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "center", "center", false, false, false, false, false)
		dxDrawText("#"..isContainer.owner, sx/2-(1644/2)*px, sy/2+(2265/2)*py,  sx/2-(1600/2)*px,sy/2+(-1675/2)*py, tocolor(242, 173, 74, 255* (alpha/255)), 1, SemiBold2, "left", "center", false, false, false, false, false)
		dxDrawText("$ "..convertNumber(isContainer.currentPrice), sx/2-(1144/2)*px, sy/2+(2265/2)*py,  sx/2-(1024/2)*px,sy/2+(-1675/2)*py, tocolor(242, 173, 74, 255* (alpha/255)), 1, SemiBold2, "right", "center", false, false, false, false, false)
		dxDrawText("Введите сумму ставки, которую хотите поставить", sx/2-(1170/2)*px, sy/2+(2583/2)*py,  sx/2-(1500/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "center", "center", false, false, false, false, false)

	
		dxDrawText("С более подробным списком можно ознакомиться у въезда #999999 на территорию контейнеров", sx/2-(705/2)*px, sy/2+(3457/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumMini, "left", "center", false, false, false, true, false)
	
		container.buy.edit = dxDrawEdit(sx/2-(1510/2)*px, sy/2-(-527/2)*py, 175*px, 51*py, "Введите сумму", 47, "", "price")

	end
	if alpha == 0 then
		removeEventHandler("onClientRender",root, container.buy.render)
	end
end

container.control.render = function ()
	
	COLOR_STATE = tocolor(255, 255, 255, alpha)
	COLOR_HOVER = tocolor(255, 255, 255, alpha)
    if state then
		if tick then
			alpha, alpha2 = interpolateBetween(0,0,0,255,50,0, (getTickCount() - tick)/500, "OutQuad")
		end
	else
		if tick then
			alpha, alpha2 = interpolateBetween(255,50,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")
		end
	end

	if not isElement(container.current) then return end

	local isContainer = getElementData(container.current, "container:data")

	if isContainer then
--		dxDrawRectangle(0, 0, screenW, screenH, tocolor(0, 0, 0, 150* (alpha/255)))

		for i=1, 1 do
			local itemX = math.fmod(i-1, 3)*100
			local itemY = math.floor((i-1)/3)*100

			if container.control.selected == i then

			end

			if isContainer.items[i] then
				--dxDrawImage(container.buy.sX + 160, container.control.sY + itemY + 100+alpha2-50, 50, 50, "assets/images/"..isContainer.items[i].type..".png",0,0,0, tocolor(255,255,255,alpha))
				container.control.selected = i
			else
				container.control.selected = false
			end
		end

		local text = ""
		if container.control.selected then
			

			dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/aw_ui_containers_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

			dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/aw_ui_containers_prize.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
		
			dxDrawImage(sx/2-(730/2)*px, sy/2-(450/2)*py, 718*px, 344*py, "assets/"..isContainer.items[container.control.selected].name..".png",0,0,0, tocolor(255,255,255,255* (alpha/255)), false)

			dxDrawButton(sx/2-(472/2)*px, sy/2-(-674/2)*py, 215*px, 51*py, assets.take1, assets.take2, 4)   
			dxDrawButton(sx/2-(2/2)*px, sy/2-(-674/2)*py, 238*px, 51*py, assets.sell1, assets.sell2, 5)   

		
		   dxDrawText("Поздравляем!", sx/2-(1350/2)*px, sy/2+(140/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)
		   dxDrawText("Вы успешно открыли контейнер, и выбили из него", sx/2-(1350/2)*px, sy/2+(400/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, RegularMini, "center", "center", false, false, false, false, false)
		  
		   dxDrawText(isContainer.items[container.control.selected].name, sx/2-(1350/2)*px, sy/2+(2500/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig3, "center", "center", false, false, false, false, false)
		   dxDrawText("Цена продажи в порту $ "..convertNumber(isContainer.items[container.control.selected].pricePort), sx/2-(1350/2)*px, sy/2+(2800/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, RegularMini2, "center", "center", false, false, false, false, false)


			if isContainer.items[container.control.selected].type == "vehicle" then
		
			end

		else
			text = [[Выберите слот с предметом, 
			чтобы управлять им.]]
		end

		
	end
	if alpha == 0 then
		removeEventHandler("onClientRender",root, container.control.render)
	end
end

container.onKey = function ()
	if not isElement(container.current) then container.current = false return end
	local isContainer = getElementData(container.current, "container:data")
	if isElement(isContainer.gate1) then
		if not isEventHandlerAdded("onClientRender", root, container.buy.render) then
			addEventHandler("onClientRender", root, container.buy.render)
			showCursor(true)
			showChat(false)
			hud = exports.aw_interface_hud:anim_true()
			radar = exports.aw_interface_radar:anim_true()
			state = true
		    tick = getTickCount()
		end
	else
		if isEventHandlerAdded("onClientRender", root, container.buy.render) then
			state = nil
			tick = getTickCount()
		end
		if not isEventHandlerAdded("onClientRender", root, container.control.render) then
			if isContainer.owner == getPlayerName(localPlayer) then
				addEventHandler("onClientRender", root, container.control.render)
				state = true
				tick = getTickCount()
				showCursor(true)
				showChat(false)
				hud = exports.aw_interface_hud:anim_true()
				radar = exports.aw_interface_radar:anim_true()
			end
		end
	end
end

addEventHandler("onClientMarkerHit", root, function (element)
	local isContainer = getElementData(source, "container:data")
	if element == localPlayer and isContainer and not getPedOccupiedVehicle(localPlayer) then
		container.current = source
		bindKey("lalt", "down", container.onKey)
	end
end)

addEventHandler("onClientMarkerLeave", root, function (element)
	local isContainer = getElementData(source, "container:data")
	if element == localPlayer and isContainer then
		container.current = false
		unbindKey("lalt", "down", container.onKey)
		state = nil
		tick = getTickCount()
		guiSetInputEnabled(false)
		showCursor(false)
		showChat(true)
		hud = exports.aw_interface_hud:anim_false()
		radar = exports.aw_interface_radar:anim_false()
	end
end)



addEventHandler("onClientClick", root, function (btn, states)
	if btn ~= "left" or states ~= "down" then return end
	if isEventHandlerAdded("onClientRender", root, container.buy.render) then
		if cursorPosition(sx/2-(1720/2)*px, sy/2-(-726/2)*py, 389*px, 51*py) then
			local isContainer = getElementData(container.current, "container:data")
			if isContainer then
				if container.buy.edit ~= "" and tonumber(container.buy.edit) > isContainer.currentPrice and exports.bank:getPlayerBankMoney("RUB") >= tonumber(container.buy.edit) then
					for i,v in pairs(getElementsByType("marker")) do
						local data = getElementData(v, "container:data")
						if data then
							if data.owner == getPlayerName(localPlayer) then
								exports.aw_interface_notify:showInfobox("info", "Контейнеры", "Вы не можете открывать больше\nодного контейнера одновременно!", getTickCount(), 8000)
							return end
						end
					end
					if isTimer(container.timer) then
						local ms = getTimerDetails(container.timer)
						local minutes = ms/1000/190
						local seconds = ms/1000
						local time = 15
						if minutes >= 1 then
							time = math.floor(minutes).." мин."
						else
							time = math.floor(seconds).." сек."
						end
						exports.aw_interface_notify:showInfobox("info", "Контейнеры", "Следующий контейнер вы \nсможете открыть через "..time.."!", getTickCount(), 8000)
					return end
					local am = math.floor(isContainer.currentPrice + isContainer.currentPrice*0.05)
					if tonumber(container.buy.edit) < am then
						exports.aw_interface_notify:showInfobox("info", "Контейнеры", "Цена контейнера должна\nбыть равна $ "..am.." и выше!", getTickCount(), 8000)
					return end
					isContainer.currentPrice = tonumber(container.buy.edit)
					isContainer.owner = getPlayerName(localPlayer)
					isContainer.destroy = false
					isContainer.time = 16
					setElementData(container.current, "container:data", isContainer)
					state = nil
					tick = getTickCount()
					guiSetInputEnabled(false)
					showCursor(false)
					showChat(true)
					hud = exports.aw_interface_hud:anim_false()
					radar = exports.aw_interface_radar:anim_false()
				end
			end
		elseif cursorPosition(sx/2-(-1630/2)*px, sy/2-(880/2)*py, 46*px, 45*py) then
			state = nil
			tick = getTickCount()
			guiSetInputEnabled(false)
			showCursor(false)
			showChat(true)
			hud = exports.aw_interface_hud:anim_false()
			radar = exports.aw_interface_radar:anim_false()
		end
	end
	if isEventHandlerAdded("onClientRender", root, container.control.render) then -- Продать в порту
		if cursorPosition(sx/2-(2/2)*px, sy/2-(-674/2)*py, 238*px, 51*py) then
			local isContainer = getElementData(container.current, "container:data")
			if container.control.selected then
				for i,v in pairs(isContainer.items) do
					if i == container.control.selected then
						triggerServerEvent("giveContainerMoney", resourceRoot, localPlayer, v.pricePort)
						table.remove(isContainer.items, i)
						setElementData(container.current, "container:data", isContainer)
						if #isContainer.items == 0 then
							container.control.selected = false
							triggerServerEvent("destroyContainer", localPlayer, isContainer.ID)
							if isEventHandlerAdded("onClientRender", root, container.control.render) then
								state = nil
								tick = getTickCount()
							end
							showCursor(false)
							showChat(true)
							hud = exports.aw_interface_hud:anim_false()
							radar = exports.aw_interface_radar:anim_false()
							container.timer = setTimer(function ()
								container.timer = false
							end, 30000, 1)
						end
					end
				end
			end
		end
		if cursorPosition(sx/2-(472/2)*px, sy/2-(-674/2)*py, 215*px, 51*py) then -- Оставить себе
			local isContainer = getElementData(container.current, "container:data")
			if container.control.selected then
				for i,v in pairs(isContainer.items) do
					if i == container.control.selected then
						if v.type == "vehicle" then
							triggerServerEvent("givePlayerContainerVehicle", localPlayer, localPlayer, v.model)
						end
						table.remove(isContainer.items, i)
						if #isContainer.items == 0 then
							container.control.selected = false
							triggerServerEvent("destroyContainer", localPlayer, isContainer.ID)
							if isEventHandlerAdded("onClientRender", root, container.control.render) then
								state = nil
								tick = getTickCount()
							end
							showCursor(false)
							showChat(true)
							hud = exports.aw_interface_hud:anim_false()
							radar = exports.aw_interface_radar:anim_false()
							container.timer = setTimer(function ()
								container.timer = false
							end, 30000, 1)
						end
					end
				end
			end
		end
	end
end)

getPriceContainer = function (items)
	local price = 0
	for i,v in pairs(items) do
		price = price + v.pricePort
	end
	return convertNumber(price)
end

container.info = function ()
    local x, y, z = getElementPosition(localPlayer)
    for i,v in pairs(getElementsByType("marker", resourceRoot, true)) do
        local zx, zy, zz = getElementPosition(v)
        if getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) then
            local distance = getDistanceBetweenPoints3D (x, y, z, zx, zy, zz)
            if distance <= 4 then
                local data = getElementData(v, "container:data")
                local screenX, screenY = getScreenFromWorldPosition(zx, zy, zz+0.95, 0.06)
                if screenX and screenY then
						if data.markerOut == v and isElement(data.gate1) then
							if data.owner == "sell" then
								dxCreateText2("Данный контейнер свободен!\nВы можете начать торг!\nНачальная цена: $ "..convertNumber(data.startPrice).." \nОбновится через "..(data.destroy or 120).." сек.\n\nНажмите ALT", screenX, screenY, 0, 0, tocolor(255, 255, 255, 255), 1.00, MediumText, "center", "center", false, false, false, true, false)
							else
								dxCreateText2("За этот контейнер ведутся торги!\n"..data.owner.. " предложил за него:\n".."$ "..convertNumber(data.currentPrice).." \nВремени осталось: "..(data.time or 90).."\nПредложите больше?\n\nНажмите ALT", screenX, screenY, 0, 0, tocolor(255, 255, 255, 255), 1.00, MediumText, "center", "center", false, false, false, true, false)
							end
						end
						if data.markerOut == v and not isElement(data.gate1) then
							if data.owner == getPlayerName(localPlayer) then
								dxCreateText2("Вы владелец данного контейнера!\n\nНажмите ALT", screenX, screenY, 0, 0, tocolor(255, 255, 255, 255), 1.00, MediumText, "center", "center", false, false, false, true, false)
							end
						end
						if data.markerOut == v and isElement(data.gate1) then
							if #data.items == 1 then
								if getElementData(localPlayer,"groupTag") == 1 then
									dxCreateText2(exports.car_system:getVehicleModName(data.items[1].model).. "\n $ "..getPriceContainer(data.items).."", screenX, screenY+150, 0, 0, tocolor(170, 50, 50, 255), 1.00, Medium, "center", "center", false, false, false, true, false)
								end
							else
								if getElementData(localPlayer,"groupTag") == 1 then
									dxCreateText2("$ "..getPriceContainer(data.items).."", screenX, screenY+150, 0, 0, tocolor(170, 50, 50, 255), 1.00, fonts[5], "center", "center", false, false, false, true, false)
								end
							end
						end
					end
				end
			end
		end
	end
addEventHandler("onClientRender", root, container.info)

shader = {}
cached = {}

function getCached(path)
    local texture = cached[path]
    if not isElement(texture) then
        texture = dxCreateTexture(path, "dxt5", true, "clamp")
        cached[path] = texture
    end
    return texture
end


function createShader(object)
    if not isElement(object) or not isElementStreamedIn(object) then
        return
    end
    local containershader = getElementData(object, "container")
    if containershader then
        if not shader[object] then
            shader[object] = {}
            shader[object].shader = dxCreateShader("assets/texture_replace.fx", 0, 200, true, "object")
            shader[object].shader2 = dxCreateShader("assets/texture_replace.fx", 0, 200, true, "object")
            shader[object].shader3 = dxCreateShader("assets/texture_replace.fx", 0, 200, true, "object")
            shader[object].shader4 = dxCreateShader("assets/texture_replace.fx", 0, 200, true, "object")
            shader[object].floor = engineApplyShaderToWorldTexture(shader[object].shader, "con_floor", object)
            shader[object].gate = engineApplyShaderToWorldTexture(shader[object].shader2, "con_gate", object)
            shader[object].wall = engineApplyShaderToWorldTexture(shader[object].shader3, "con_wall", object)
            shader[object].wall_dop = engineApplyShaderToWorldTexture(shader[object].shader4, "con_wall_dop", object)
        end
        local textures = {
            [1] = {
                floor = getCached("assets/textures/Russia/con_floor.png"),
                gate = getCached("assets/textures/Russia/con_gate.png"),
                wall = getCached("assets/textures/Russia/con_wall.png"),
                wall_dop = getCached("assets/textures/Russia/con_wall_dop.png"),
            },
            [2] = {
                floor = getCached("assets/textures/USA/con_floor.png"),
                gate = getCached("assets/textures/USA/con_gate.png"),
                wall = getCached("assets/textures/USA/con_wall.png"),
                wall_dop = getCached("assets/textures/USA/con_wall_dop.png"),
            },
            [3] = {
                floor = getCached("assets/textures/Dubai/con_floar.png"),
                gate = getCached("assets/textures/Dubai/con_gate.png"),
                wall = getCached("assets/textures/Dubai/con_wall.png"),
                wall_dop = getCached("assets/textures/Dubai/con_wall_dop.png"),
            },
        }
        dxSetShaderValue(shader[object].shader, "gTexture", textures[tonumber(containershader)].floor)
        dxSetShaderValue(shader[object].shader2, "gTexture", textures[tonumber(containershader)].gate)
        dxSetShaderValue(shader[object].shader3, "gTexture", textures[tonumber(containershader)].wall)
        dxSetShaderValue(shader[object].shader4, "gTexture", textures[tonumber(containershader)].wall_dop)
    else
        if isElement(shader[object]) then
            destroyElement(shader[object])
        end
        shader[object] = nil
    end
end
addEvent("onCreateVinilShader", true)
addEventHandler("onCreateVinilShader", root, createShader)

function removeShader(object)
    if not shader[object] then
        return false
    end
    if isElement(shader[object]) then
        destroyElement(shader[object])
    end
    shader[object] = nil
end

addEventHandler("onClientElementStreamIn", root, function ()
    if getElementType(source) == "object" then
        createShader(source)
    end
end)

function handleDestroy()
    removeShader(source)
end
addEventHandler("onClientElementDestroy", root, handleDestroy)
addEventHandler("onClientElementStreamOut", root, handleDestroy)

addEventHandler("onClientResourceStart", resourceRoot, function ()
    for i, object in ipairs(getElementsByType("object", root, true)) do
        createShader(object)
    end
end)

addEventHandler("onClientElementDataChange", root, function ()
    if getElementType(source) == "object" then
        createShader(source)
    end
end)

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


function dxCreateText2 (text, x, y, w, h, color, size, font, left, top)
	dxDrawText (text, x, y, x + w, y + h, color, size, font, left, top)
end


function ContainerWindowClose()
	removeEventHandler("onClientRender",root, container.buy.render)
	guiSetInputEnabled(false)
	showCursor(false)
	showChat(true)
	hud = exports.aw_interface_hud:anim_false()
	radar = exports.aw_interface_radar:anim_false()
end
addEvent("ContainerWindowClose",true)
addEventHandler("ContainerWindowClose",root,ContainerWindowClose)