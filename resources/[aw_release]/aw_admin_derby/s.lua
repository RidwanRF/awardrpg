
places={
	{444,3787.11,-1547.07,121.06,63.4},
	{444,3766.35,-1566.49,121.06,19.4},
	{444,3738.48,-1565.90,121.06,329.1},
	{444,3719.98,-1545.82,121.06,279.6},
	{444,3719.13,-1519.09,121.06,233.6},
	{444,3739.20,-1499.32,121.06,192.2},
	{444,3765.60,-1501.82,121.06,145.9},
	{444,3786.18,-1519.20,121.06,101.1},
	{444,3753.90,-1496.35,121.06}
}

auta_id={}

derbyStart = false

function consoleSetPlayerPosition ( source, commandName, posX, posY, posZ )
	if not derbyStart then return end
	if getElementData(source,"kary:blokada_aj") then outputChatBox("(( Jesteś w więzieniu! ))",source) return end
	if getElementData(source,"faction:id") then outputChatBox("(( Musisz wylogować się z duty! ))",source) return end
	setElementPosition ( source, 3752.8999, -1532.9, 123.6 )
	exports.aw_interface_notify:showInfobox(source, "info", "Дерби", "Вы телепортировались на мероприятие", getTickCount(), 8000)
end
addCommandHandler ( "derby", consoleSetPlayerPosition  )



function invitation (thePlayer)
	local accName = getAccountName ( getPlayerAccount ( thePlayer ) )
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Founder" ) ) then
	derbyStart = not derbyStart
	outputChatBox(tostring(derbyStart),thePlayer)
	exports.aw_interface_notify:showInfobox(thePlayer	, "info", "Дерби", "Администраторы начали мероприятие Дерби, пропишите /derby для телепорта", getTickCount(), 8000)
   end
end
addCommandHandler("derbystart", invitation)

for k,v in ipairs(places) do
	auta_id[#auta_id+1] = createVehicle(v[1],v[2],v[3],v[4])
	setElementFrozen(auta_id[#auta_id],true)
	setElementRotation(auta_id[#auta_id],0,0,v[5])
end

function derbystart()
	outputChatBox("Zająć pojazdy, oraz przygotwać się!",getRootElement(),255,0,0)	
	outputChatBox("Za 1 minute startujemy",getRootElement(),255,0,0)
		setTimer(function()
			outputChatBox("Zostało jeszcze 30 sekund do startu",getRootElement(),255,0,0)
		end,1000*30,1)	
		setTimer(function()
			outputChatBox("Rozpoczęła się demolka! Powodzenia ;)",getRootElement(),255,0,0)
			for k,v in ipairs(auta_id) do
				setElementFrozen(v,false)
				if not getVehicleOccupant(v) then destroyElement(v) end 
			end
		end,1000*60,1)
end
addCommandHandler("startderby",derbystart)
