
addEvent("evc",true)
addEventHandler("evc",resourceRoot,
	function(ev,arg1)
		if (ev=="open_window") then
			if (not wlaczony) then
				akcja="dodaj"
				z_m=arg1
				wlaczony=true
				exports.aw_interface_notify:showInfobox("info", "Взаимодействие", "Для взаимодействия нажмите на space", getTickCount(), 150)
				triggerServerEvent("evs",resourceRoot,"wlacz_opcje_wchodzenia")

			end
		elseif (ev=="close_window") then
			if (wlaczony==true) then
				akcja="odejmij"
				triggerServerEvent("evs",resourceRoot,"wylacz_opcje_wchodzenia")
				setTimer(function()
					wlaczony=false
				end,1500,1)
			end
		elseif (ev=="wlacz_przenikanie_w_interiorze") then
			for i,v in ipairs(getElementsByType("player")) do
				if (getElementDimension(v)==getElementDimension(localPlayer)) and (getElementInterior(v)==getElementInterior(localPlayer)) then
					setElementCollidableWith(localPlayer,v,false)
				end
			end
		elseif (ev=="wylacz_przenikanie") then
			for i,v in ipairs(getElementsByType("player")) do
				if (getElementDimension(v)==getElementDimension(localPlayer)) and (getElementInterior(v)==getElementInterior(localPlayer)) then
					setElementCollidableWith(localPlayer,v,true)
				end
			end
		end
	end
)