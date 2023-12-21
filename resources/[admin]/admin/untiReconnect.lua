_redirectPlayer = redirectPlayer

function redirectPlayer (pl)
	cancelEvent (true)
	local text = "Ресурс "..getResourceName (getThisResource()).." использует перенаправку игроков!!!"
	outputServerLog (text)
	outputDebugString (text, 2)
end