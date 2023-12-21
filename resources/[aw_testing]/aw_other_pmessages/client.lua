
local screenW, screenH = guiGetScreenSize()
local GUI = {
    checkbox = {},
    edit = {},
    gridlist = {},
    window = {},
    button = {
        send = {},
        bClose = {}
    },
    memo = {
        messages = {}
    },
	editbox = {
        yourMessage = {}
	}
}
local cachedDialogs = {}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        GUI.window.playerList = guiCreateWindow(screenW-260, (screenH-450)/2, 250, 470, "Список игроков", false)
        guiWindowSetSizable(GUI.window.playerList, false)
        GUI.edit.playerListFilter = guiCreateEdit(10, 25, 230, 25, "", false, GUI.window.playerList)
        GUI.gridlist.playerList = guiCreateGridList(10, 60, 230, 355, false, GUI.window.playerList)
		guiGridListSetSortingEnabled(GUI.gridlist.playerList, false)
		guiGridListAddColumn(GUI.gridlist.playerList, "Игроки", 0.9)
        GUI.checkbox.hideColorCodes = guiCreateCheckBox(10, 425, 151, 15, "Скрыть цветовые коды", true, false, GUI.window.playerList)
        
        GUI.checkbox.onpres = guiCreateCheckBox(10, 450, 151, 15, "Запретить сообщения", false, false, GUI.window.playerList)
		


		addEventHandler("onClientGUIDoubleClick", GUI.gridlist.playerList, onGuiDoubleClick, false)
		guiSetVisible(GUI.window.playerList, false)
    end
)

function createMessageBoxWindow(player)
	local visible = guiGetVisible(GUI.window.playerList)
	if not isElement(GUI.window[player]) then
		GUI.window[player] = guiCreateWindow((screenW-300)/2, (screenH-325)/2, 300, 325, "", false)
		guiWindowSetSizable(GUI.window[player], true)
		GUI.memo.messages[player] = guiCreateMemo(10, 25, 280, 220, "", false, GUI.window[player])
		guiMemoSetReadOnly(GUI.memo.messages[player], false)
		GUI.editbox.yourMessage[player] = guiCreateEdit(10, 255, 280, 25, "", false, GUI.window[player])
		GUI.button.bClose[player] = guiCreateButton(10, 290, 70, 25, "Закрыть", false, GUI.window[player])
		GUI.button.send[player] = guiCreateButton(200, 288, 90, 26, "Отправить", false, GUI.window[player])
		
		guiSetVisible(GUI.window.playerList, visible)
		if guiCheckBoxGetSelected(GUI.checkbox.hideColorCodes) then
			guiSetText(GUI.window[player], string.gsub(getPlayerName(player), '#%x%x%x%x%x%x', '') )
		else
			guiSetText(GUI.window[player], getPlayerName(player))
		end
	end
	if cachedDialogs[player] then
		guiSetText(GUI.memo.messages[player], cachedDialogs[player])
		guiMemoSetCaretIndex(GUI.memo.messages[player], string.len(cachedDialogs[player]))
	end
	if (visible) then
		if not guiGetInputEnabled() then
			guiBringToFront(GUI.window[player])
		end
	else
		guiSetVisible(GUI.window[player], false)
	end
end

function onGuiClick()
	if (source == GUI.checkbox.hideColorCodes) then
		refreshPlayerList()
	end
	if guiCheckBoxGetSelected(GUI.checkbox.onpres) then
		setElementData(localPlayer,"nepisati",true)
		--guiSetText()
	else
		setElementData(localPlayer,"nepisati",false)
	end
	for player, guiElement in pairs(GUI.button.bClose) do
		if (source == guiElement) then
			destroyElement(GUI.window[player])
			GUI.window[player] = nil
			GUI.button.bClose[player] = nil
			GUI.editbox.yourMessage[player] = nil
			GUI.button.send[player] = nil
		end
	end
	for player, guiElement in pairs(GUI.button.send) do
		if (source == guiElement) then
			local text = guiGetText(GUI.editbox.yourMessage[player])
			if text ~= "" then
				sendMessage(player, text)
			end
		end
	end
end
addEventHandler("onClientGUIClick", resourceRoot, onGuiClick)

function onGuiDoubleClick()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.playerList)
	local player = guiGridListGetItemData(GUI.gridlist.playerList, selected, 1)
	if isElement(player) then
		if getElementData(player,"nepisati") == false then
			createMessageBoxWindow(player)
		else
			outputChatBox("Игрок не хочет, чтобы ему писали!", 255,0,0)
		end
	else
		refreshPlayerList()
	end
end

function onGuiChanged()
	if (source == GUI.edit.playerListFilter) or (source == GUI.checkbox.hideColorCodes) then
		refreshPlayerList()		
	end
end
addEventHandler("onClientGUIChanged", resourceRoot, onGuiChanged)

function onEditEnter()
	local text = guiGetText(source)
	if text ~= "" then
		for player, guiElement in pairs(GUI.editbox.yourMessage) do
			if (source == guiElement) then
				sendMessage(player, text)
			end
		end
	end
end
addEventHandler("onClientGUIAccepted", resourceRoot, onEditEnter)

function sendMessage(player, text)
	if isElement(player) then
		cachedDialogs[player] = (cachedDialogs[player] or "").."\n"..getPlayerName(localPlayer)..": "..text
		guiSetText(GUI.memo.messages[player], cachedDialogs[player])
		guiMemoSetCaretIndex(GUI.memo.messages[player], string.len(cachedDialogs[player]))
		guiSetText(GUI.editbox.yourMessage[player], "")
		triggerServerEvent("onPlayerPM", resourceRoot, player, text)
	else
		outputChatBox("Игрок вышел с сервера!", 255,50,50)
	end
end

function catchPM(sender, text)
	cachedDialogs[sender] = (cachedDialogs[sender] or "").."\n"..getPlayerName(sender)..": "..text
	createMessageBoxWindow(sender)
	onMessageIncome(sender)
end
addEvent("catchPM", true)
addEventHandler("catchPM", resourceRoot, catchPM)

local needsUserReaction = true

function toggleLS()
	local state = not guiGetVisible(GUI.window.playerList)
	for _, window in pairs(GUI.window) do
		guiSetVisible(window, state)
	end
	if state then
		refreshPlayerList()
		guiSetInputMode("no_binds_when_editing")
	else
		guiSetInputMode("allow_binds")
	end
	showCursor(state)
	needsUserReaction = not state
end
addCommandHandler("ls", toggleLS, false)
bindKey("F9", "down", "ls")

function refreshPlayerList()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.playerList)
	local filter = string.lower( guiGetText(GUI.edit.playerListFilter) )
	guiGridListClear(GUI.gridlist.playerList)
	if guiCheckBoxGetSelected(GUI.checkbox.hideColorCodes) then
		for _, player in ipairs(getElementsByType("player")) do
			local name = string.gsub(getPlayerName(player), '#%x%x%x%x%x%x', '')
			if string.find( string.lower(name), filter ) then
				local row = guiGridListAddRow(GUI.gridlist.playerList)
				guiGridListSetItemText(GUI.gridlist.playerList, row, 1, name, false, false)
				guiGridListSetItemData(GUI.gridlist.playerList, row, 1, player)
			end
			if isElement(GUI.window[player]) then
				guiSetText(GUI.window[player], name)
			end
		end
	else
		for _, player in ipairs(getElementsByType("player")) do
			local name = getPlayerName(player)
			if string.find( string.lower(name), filter ) then
				local row = guiGridListAddRow(GUI.gridlist.playerList)
				guiGridListSetItemText(GUI.gridlist.playerList, row, 1, name, false, false)
				guiGridListSetItemData(GUI.gridlist.playerList, row, 1, player)
			end
			if isElement(GUI.window[player]) then
				guiSetText(GUI.window[player], name)
			end
		end
	end
	guiGridListSetSelectedItem(GUI.gridlist.playerList, selected, 1)
end

function onSomebodyQuit()
	if isElement(GUI.window[source]) then
		guiSetText(GUI.window[source], "Игрок оффлайн")
		guiSetEnabled(GUI.button.send[source], false)
	end
end
addEventHandler("onClientPlayerQuit", root, onSomebodyQuit)






local size = screenH/6.7
local x, y = (screenW-size)/2, (screenH-size)/2
local textX, textY = nil, (size*0.85)+y
local fadeNewMessage, faderTimer, newMessageAlpha, textToWrite, textToWriteWidth

local speed = 4
local lX = screenW-1700
local drawLetter, letterIsWhite, letterColor, direction

function onMessageIncome(player)
	textToWrite = "Отправитель: "..getPlayerName(player)
	textToWriteWidth = dxGetTextWidth(textToWrite, 1, "default-bold", true)
	textX = (screenW-textToWriteWidth)/2
	fadeNewMessage = false
	if isTimer(faderTimer) then killTimer(faderTimer) end
	faderTimer = setTimer(function() fadeNewMessage = true end, 3000, 1)
	newMessageAlpha = 255
	
	drawLetter = true
	letterIsWhite = false
	letterColor = 0
	direction = -speed
end

function onRender()
	if newMessageAlpha then
		dxDrawImage(x, y, size, size, "image/newMessage.png", 0, 0, 0, tocolor(255,255,255,newMessageAlpha))
		dxDrawText(textToWrite, textX, textY, textX+textToWriteWidth, textY, tocolor(255,255,255,newMessageAlpha), 1.00, "default-bold", "center", "top", false, false, false, true, false)
		if fadeNewMessage then
			newMessageAlpha = newMessageAlpha - speed*2
			if newMessageAlpha < 0 then
				newMessageAlpha = false
			end
		end
	end
	if drawLetter then
		if letterIsWhite then
			dxDrawImage(screenW-230, (screenH-700)/2, 32, 25, "image/letter.png", 0, 0, 0, tocolor(255,255,255,letterColor))
			letterColor = letterColor + direction
			if (letterColor < 0) then
				if needsUserReaction then 
					letterColor = 0
					direction = speed
				else
					drawLetter = false
				end
			elseif (letterColor > 255) then
				letterColor = 255
				direction = -speed
			end
		else
			dxDrawImage(screenW-230, (screenH-1000)/2, 200, 40, "image/letter.png", 0, 0, 0, tocolor(255,letterColor,letterColor,255))
			letterColor = letterColor + speed*2
			if letterColor > 255 then
				letterIsWhite = true
				letterColor = 255
			end
		end
	end
end
addEventHandler("onClientRender", root, onRender)