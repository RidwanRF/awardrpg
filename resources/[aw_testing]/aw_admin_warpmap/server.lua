function WarpPl (players, cursorxt,cursoryt, sp, stat)
	local veh = getPedOccupiedVehicle (players)
	if not veh then
		setElementPosition(players, cursorxt,cursoryt,sp)
		local x1,y1,z1 = getElementPosition( players )
		setElementPosition(players, x1,y1,z1 + 2)
	else
		setElementPosition(veh, cursorxt,cursoryt,sp)
		local x1,y1,z1 = getElementPosition( veh )
		setElementPosition(veh, x1,y1,z1 + 2)
	end
	if stat == true then
	outputChatBox("Администратор "..getPlayerName(source).." #FFFFFFтелепортировал вас по карте",players,255,255,255,true)
	end
end
addEvent("WarpPl", true)
addEventHandler("WarpPl",getRootElement(),WarpPl)

