GUI = {
    checkbox = {},
    edit = {},
    gridlist = {},
    window = {},
    label = {},
    button = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
		local screenW, screenH = guiGetScreenSize()
        GUI.window.main = guiCreateWindow((screenW - 580) / 2, (screenH - 390) / 2, 580, 390, "Админ-панель групп", false)
        guiWindowSetSizable(GUI.window.main, false)
		
        GUI.label[1] = guiCreateLabel(10, 25, 275, 15, "Список групп:", false, GUI.window.main)
        guiLabelSetHorizontalAlign(GUI.label[1], "center", false)
        GUI.gridlist.teams = guiCreateGridList(10, 45, 275, 200, false, GUI.window.main)
		guiGridListAddColumn(GUI.gridlist.teams, "Название", 0.3)
		guiGridListAddColumn(GUI.gridlist.teams, "Руководитель", 0.3)
		guiGridListAddColumn(GUI.gridlist.teams, "Цвет тега", 0.3)
        GUI.label[2] = guiCreateLabel(295, 25, 275, 15, "Участники данной группы:", false, GUI.window.main)
        guiLabelSetHorizontalAlign(GUI.label[2], "center", false)
        GUI.gridlist.members = guiCreateGridList(295, 45, 275, 200, false, GUI.window.main)
        guiGridListAddColumn(GUI.gridlist.members, "Логин", 0.5)
        guiGridListAddColumn(GUI.gridlist.members, "Ник", 0.5)
		
        GUI.label[3] = guiCreateLabel(10, 259, 77, 15, "Ввод данных:", false, GUI.window.main)
        GUI.edit.main = guiCreateEdit(87, 255, 198, 25, "", false, GUI.window.main)
        guiEditSetMaxLength(GUI.edit.main, 100)
        GUI.checkbox.enableButtons = guiCreateCheckBox(295, 365, 145, 15, "Активировать кнопки", false, false, GUI.window.main)
		
        GUI.button.createTeam = guiCreateButton(10, 290, 85, 40, "Создать группу", false, GUI.window.main)
        GUI.button.changeName = guiCreateButton(105, 290, 85, 40, "Сменить название", false, GUI.window.main)
        GUI.button.changeOwner = guiCreateButton(200, 290, 85, 40, "Сменить руководителя", false, GUI.window.main)
        GUI.button.changeColor = guiCreateButton(105, 340, 85, 40, "Сменить цвет", false, GUI.window.main)  
        GUI.button.deleteTeam = guiCreateButton(10, 340, 85, 40, "Удалить группу", false, GUI.window.main)
        GUI.button.addByNick = guiCreateButton(295, 255, 85, 40, "Добавить по нику", false, GUI.window.main)
        GUI.button.addByAccount = guiCreateButton(390, 255, 85, 40, "Добавить по логину", false, GUI.window.main)
        GUI.button.fire = guiCreateButton(485, 255, 85, 40, "Выгнать", false, GUI.window.main)
		
        GUI.button.close = guiCreateButton(485, 340, 85, 40, "Закрыть", false, GUI.window.main) 

		
        GUI.window.user = guiCreateWindow((screenW - 295) / 2, (screenH - 390) / 2, 295, 390, "Управление группой", false)
        guiWindowSetSizable(GUI.window.user, false)
        GUI.label[4] = guiCreateLabel(10, 25, 275, 15, "Участники данной группы:", false, GUI.window.user)
        guiLabelSetHorizontalAlign(GUI.label[4], "center", false)
        GUI.gridlist.userMembers = guiCreateGridList(10, 45, 275, 200, false, GUI.window.user)
        guiGridListAddColumn(GUI.gridlist.userMembers, "Логин", 0.5)
        guiGridListAddColumn(GUI.gridlist.userMembers, "Ник", 0.5)
        GUI.button.userAddByNick = guiCreateButton(10, 255, 85, 40, "Добавить по нику", false, GUI.window.user)
        GUI.button.userAddByAccount = guiCreateButton(105, 255, 85, 40, "Добавить по логину", false, GUI.window.user)
        GUI.button.userFire = guiCreateButton(200, 255, 85, 40, "Выгнать", false, GUI.window.user)
        GUI.button.userClose = guiCreateButton(105, 340, 85, 40, "Закрыть", false, GUI.window.user)
        GUI.edit.user = guiCreateEdit(10, 305, 180, 25, "", false, GUI.window.user)
        guiEditSetMaxLength(GUI.edit.user, 100)  		
		
		guiSetVisible(GUI.window.main, false)
		guiSetVisible(GUI.window.user, false)
		addEventHandler("onClientGUIClick", GUI.gridlist.teams, gridlistClick, false)
    end
)


function gridlistClick()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.teams)
	if selected ~= -1 then
		local teamID = guiGridListGetItemData(GUI.gridlist.teams, selected, 1)
		triggerServerEvent("getTeamMembers", resourceRoot, localPlayer, teamID)
	else
		guiGridListClear(GUI.gridlist.members)
	end
end

local state = false
local currentTeam = false
function onGUIClick()
	if (source == GUI.button.close) or (source == GUI.button.userClose) then
		guiSetVisible(GUI.window.main, false)
		guiSetVisible(GUI.window.user, false)
		guiSetInputMode("allow_binds")
		showCursor(false)
		state = false
	
	elseif (source == GUI.button.createTeam) then
		local name = guiGetText(GUI.edit.main)
		if (name == "") then
			outputChatBox("Введи название группы!", 255, 50, 50)
			return
		end
		triggerServerEvent("createGroup", resourceRoot, name)
	
	elseif (source == GUI.button.changeName) then
		local name = guiGetText(GUI.edit.main)
		local id = guiGridListGetItemData(GUI.gridlist.teams, guiGridListGetSelectedItem(GUI.gridlist.teams) )
		if (not id) then
			outputChatBox("Не выбрана группа!", 255, 50, 50)
			return
		end
		if (name == "") then
			outputChatBox("Введи новое название группы!", 255, 50, 50)
			return
		end
		triggerServerEvent("changeGroupName", resourceRoot, id, name)
	
	elseif (source == GUI.button.changeOwner) then
		local acc = guiGetText(GUI.edit.main)
		local id = guiGridListGetItemData(GUI.gridlist.teams, guiGridListGetSelectedItem(GUI.gridlist.teams) )
		if (not id) then
			outputChatBox("Не выбрана группа!", 255, 50, 50)
			return
		end
		if (acc == "") then
			outputChatBox("Введи аккаунт нового владельца!", 255, 50, 50)
			return
		end
		triggerServerEvent("changeGroupOwner", resourceRoot, id, acc)
	
	elseif (source == GUI.button.changeColor) then
		local id = guiGridListGetItemData(GUI.gridlist.teams, guiGridListGetSelectedItem(GUI.gridlist.teams) )
		local color = split(guiGetText(GUI.edit.main), ",")
		local r = tonumber(color[1]) or 255
		local g = tonumber(color[2]) or 255
		local b = tonumber(color[3]) or 255
		if (not id) then
			outputChatBox("Не выбрана группа!", 255, 50, 50)
			return
		end
		if (type(r) ~= "number") or (type(g) ~= "number") or (type(b) ~= "number") then
			outputChatBox("Введи цвет в формате r,g,b, или не вводи ничего", 255, 50, 50)
			return
		end
		triggerServerEvent("changeGroupColor", resourceRoot, id, r, g, b)
	
	elseif (source == GUI.button.deleteTeam) then
		local id = guiGridListGetItemData(GUI.gridlist.teams, guiGridListGetSelectedItem(GUI.gridlist.teams) )
		if (not id) then
			outputChatBox("Не выбрана группа!", 255, 50, 50)
			return
		end
		triggerServerEvent("deleteGroup", resourceRoot, id)
	
	elseif (source == GUI.button.addByNick) or (source == GUI.button.userAddByNick) then
		local teamID = guiGridListGetItemData(GUI.gridlist.teams, guiGridListGetSelectedItem(GUI.gridlist.teams) )
		if not teamID then teamID = currentTeam end
		if (not teamID) then
			outputChatBox("Не выбрана группа!", 255, 50, 50)
			return
		end
		local nick = guiGetText(GUI.edit.main)
		if (nick == "") then nick = guiGetText(GUI.edit.user) end
		if (nick == "") then
			outputChatBox("Введи ник игрока!", 255, 50, 50)
			return
		end
		triggerServerEvent("addMemberByNick", resourceRoot, teamID, nick)
	
	elseif (source == GUI.button.addByAccount) or (source == GUI.button.userAddByAccount) then
		local teamID = guiGridListGetItemData(GUI.gridlist.teams, guiGridListGetSelectedItem(GUI.gridlist.teams) )
		if not teamID then teamID = currentTeam end
		if (not teamID) then
			outputChatBox("Не выбрана группа!", 255, 50, 50)
			return
		end
		local accName = guiGetText(GUI.edit.main)
		if (accName == "") then accName = guiGetText(GUI.edit.user) end
		if (accName == "") then
			outputChatBox("Введи аккаунт игрока!", 255, 50, 50)
			return
		end
		triggerServerEvent("addMemberByAcc", resourceRoot, teamID, accName)
	
	elseif (source == GUI.button.fire) or (source == GUI.button.userFire) then
		local teamID = guiGridListGetItemData(GUI.gridlist.teams, guiGridListGetSelectedItem(GUI.gridlist.teams) )
		if not teamID then teamID = currentTeam end
		if (not teamID) then
			outputChatBox("Не выбрана группа!", 255, 50, 50)
			return
		end
		local memberID = guiGridListGetItemData(GUI.gridlist.members, guiGridListGetSelectedItem(GUI.gridlist.members) )
		if not memberID then memberID = guiGridListGetItemData(GUI.gridlist.userMembers, guiGridListGetSelectedItem(GUI.gridlist.userMembers) ) end
		if (not memberID) then
			outputChatBox("Не выбран игрок!", 255, 50, 50)
			return
		end
		triggerServerEvent("fireMember", resourceRoot, teamID, memberID)
	
	elseif (source == GUI.checkbox.enableButtons) then
		enableButtons()
		
	end
end
addEventHandler("onClientGUIClick", resourceRoot, onGUIClick)

function enableButtons()
	local state = guiCheckBoxGetSelected(GUI.checkbox.enableButtons)
	guiSetEnabled(GUI.button.createTeam, state)
	guiSetEnabled(GUI.button.changeName, state)
	guiSetEnabled(GUI.button.changeOwner, state)
	guiSetEnabled(GUI.button.changeColor, state)
	guiSetEnabled(GUI.button.deleteTeam, state)
	guiSetEnabled(GUI.button.addByNick, state)
	guiSetEnabled(GUI.button.addByAccount, state)
	guiSetEnabled(GUI.button.fire, state)
end

function openMainWindow(isAdmin, ID)
	state = not state
	if isAdmin then
		guiSetVisible(GUI.window.main, state)
		triggerServerEvent("requestTeams", resourceRoot)
		guiCheckBoxSetSelected(GUI.checkbox.enableButtons, false)
		enableButtons()
	end
	if ID then
		guiSetVisible(GUI.window.user, state)
		triggerServerEvent("getTeamMembers", resourceRoot, localPlayer, ID)
		currentTeam = ID
	end
	showCursor(state)
	if state then
		guiSetInputMode("no_binds_when_editing")
	else
		guiSetInputMode("allow_binds")
	end		
end
addEvent("togglePanel", true)
addEventHandler("togglePanel", resourceRoot, openMainWindow)

function refreshTeamList(data)
	local selRow, selColumn = guiGridListGetSelectedItem(GUI.gridlist.teams)
	guiGridListClear(GUI.gridlist.teams)	
	for _, dataRow in ipairs(data) do
		local row = guiGridListAddRow(GUI.gridlist.teams)
		guiGridListSetItemText(GUI.gridlist.teams, row, 1, tostring(dataRow.name), false, false)
		guiGridListSetItemText(GUI.gridlist.teams, row, 2, tostring(dataRow.owner), false, false)
		guiGridListSetItemText(GUI.gridlist.teams, row, 3, tostring(dataRow.colorR..","..dataRow.colorG..","..dataRow.colorB), false, false)
		guiGridListSetItemData(GUI.gridlist.teams, row, 1, dataRow.ID)
		guiGridListSetItemColor(GUI.gridlist.teams, row, 1, dataRow.colorR, dataRow.colorG, dataRow.colorB)
	end
	guiGridListSetSelectedItem(GUI.gridlist.teams, selRow, selColumn)
end
addEvent("refreshTeamList", true)
addEventHandler("refreshTeamList", resourceRoot, refreshTeamList)

function refreshMemberList(data)
	local selRow, selColumn = guiGridListGetSelectedItem(GUI.gridlist.members)
	guiGridListClear(GUI.gridlist.members)	
	guiGridListClear(GUI.gridlist.userMembers)	
	for _, dataRow in ipairs(data) do
		local row = guiGridListAddRow(GUI.gridlist.members)
		guiGridListSetItemText(GUI.gridlist.members, row, 1, tostring(dataRow.account), false, false)
		guiGridListSetItemText(GUI.gridlist.members, row, 2, tostring(dataRow.player), false, false)
		guiGridListSetItemData(GUI.gridlist.members, row, 1, dataRow.ID)
		row = guiGridListAddRow(GUI.gridlist.userMembers)
		guiGridListSetItemText(GUI.gridlist.userMembers, row, 1, tostring(dataRow.account), false, false)
		guiGridListSetItemText(GUI.gridlist.userMembers, row, 2, tostring(dataRow.player), false, false)
		guiGridListSetItemData(GUI.gridlist.userMembers, row, 1, dataRow.ID)
	end
	guiGridListSetSelectedItem(GUI.gridlist.members, selRow, selColumn)
	guiGridListSetSelectedItem(GUI.gridlist.userMembers, selRow, selColumn)
end
addEvent("refreshMemberList", true)
addEventHandler("refreshMemberList", resourceRoot, refreshMemberList)