	GUIEditor = {
		scrollpane = {},
		edit = {},
		button = {},
		window = {},
		label = {},
		gridlist = {}
	}


	GUIEditor.window[1] = guiCreateWindow(0.36, 0.34, 0.28, 0.38, "Окно проведения МП", true)
	guiWindowSetSizable(GUIEditor.window[1], false)

	GUIEditor.gridlist[1] = guiCreateGridList(0.02, 0.06, 0.46, 0.69, true, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[1], "Игроки", 0.5)
	guiGridListAddColumn(GUIEditor.gridlist[1], "Логин", 0.3)
	
	GUIEditor.button[1] = guiCreateButton(0.51, 0.06, 0.23, 0.07, "Создать МП", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
	
	GUIEditor.button[2] = guiCreateButton(0.51, 0.15, 0.23, 0.07, "Закончить МП", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")
	
	GUIEditor.button[3] = guiCreateButton(0.76, 0.06, 0.23, 0.16, "Телепорт \nВКЛ/ОТКЛ", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[3], "NormalTextColour", "FFAAAAAA")
	
	GUIEditor.button[4] = guiCreateButton(0.76, 0.91, 0.23, 0.07, "Закрыть", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[4], "NormalTextColour", "FFFD0000")
	
	GUIEditor.label[1] = guiCreateLabel(0.04, 0.76, 0.47, 0.06, "Создал МП: ", true, GUIEditor.window[1])
	guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
	
	GUIEditor.button[5] = guiCreateButton(0.51, 0.31, 0.23, 0.10, "Пополнить HP", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[5], "NormalTextColour", "FFFF4E00")
	
	GUIEditor.button[7] = guiCreateButton(0.51, 0.44, 0.23, 0.10, "Пополнить Броню", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[7], "NormalTextColour", "FFFF4E00")
	
	GUIEditor.button[8] = guiCreateButton(0.76, 0.31, 0.23, 0.10, "Выгнать", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[8], "NormalTextColour", "FFFF0000")
	
	GUIEditor.edit[1] = guiCreateEdit(0.51, 0.76, 0.29, 0.07, "", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.edit[1], "NormalTextColour", "FFFF0000")
	
	GUIEditor.label[2] = guiCreateLabel(0.51, 0.71, 0.29, 0.06, "Поле для ввода данных:", true, GUIEditor.window[1])
	guiLabelSetColor(GUIEditor.label[2], 255, 0, 0)
	guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
	
	GUIEditor.button[9] = guiCreateButton(0.51, 0.57, 0.23, 0.10, "Выдать машины", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[9], "NormalTextColour", "FFFF4E00")
	
	-- GUIEditor.button[10] = guiCreateButton(0.04, 0.91, 0.22, 0.07, "Инфо", true, GUIEditor.window[1])
	-- guiSetProperty(GUIEditor.button[10], "NormalTextColour", "FFD8DF1F")
	
	GUIEditor.label[3] = guiCreateLabel(0.04, 0.82, 0.47, 0.06, "Телепорт: открыт/закрыт", true, GUIEditor.window[1])
	guiLabelSetVerticalAlign(GUIEditor.label[3], "center")


	GUIEditor.window[2] = guiCreateWindow(0.64, 0.34, 0.17, 0.38, "Информация", true)
	guiWindowSetSizable(GUIEditor.window[2], false)

	GUIEditor.scrollpane[1] = guiCreateScrollPane(0.03, 0.06, 0.94, 0.92, true, GUIEditor.window[2])

	GUIEditor.label[4] = guiCreateLabel(0.02, 0.12, 0.95, 0.86, "• Допустимые ID авто:\n    - 572 (Газоно-косилка)\n    - 571 (Карт)\n    - 411 (Mercedes-Benz AMG GT)\n    - 556 (Monster 2)\n    - 557 (Monster 3)\n    - 407 (Пожарка)\n    - 504 (Для дерби)", true, GUIEditor.scrollpane[1])
	GUIEditor.label[5] = guiCreateLabel(0.02, 0.03, 0.95, 0.06, "Панель разработана by AngelAlpha", true, GUIEditor.scrollpane[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[5], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[5], "center")

	GUIEditor.window[1].visible = false
	GUIEditor.window[2].visible = false


local vals = {}


function updateList(t)
	vals = t
	
	if not GUIEditor.window[1].visible then return end
	guiGridListClear (GUIEditor.gridlist[1])
	for i, v in ipairs (vals.players) do
		guiGridListAddRow (GUIEditor.gridlist[1], (v.name):gsub("#%x%x%x%x%x%x",""), (v:getData ("accountName") or "N/A"))
	end
	
	if vals.owner then
		GUIEditor.label[1].text = "Создал МП: "..vals.owner
		GUIEditor.button[1].enabled = false
		GUIEditor.button[2].enabled = true
	else
		GUIEditor.label[1].text = "Создал МП: N/A"
		GUIEditor.button[1].enabled = true
		GUIEditor.button[2].enabled = false
	end
	
	GUIEditor.label[3].text = vals.warp and "Телепорт: открыт" or "Телепорт: закрыт"
end
addEvent ("mp:updateList", true)
addEventHandler ("mp:updateList", resourceRoot, updateList)

addEvent ("drawGUI", true)
addEventHandler ("drawGUI", resourceRoot, function(t)
	if GUIEditor.window[1].visible then return end
	GUIEditor.window[1].visible = true
	showCursor (true)
	
	updateList(t)
end)

addEventHandler ("onClientGUIClick", resourceRoot, function()
	local t = GUIEditor.button
	if source == t[1] then
		triggerServerEvent ("event", resourceRoot, "mp", "create")
	elseif source == t[2] then
		triggerServerEvent ("event", resourceRoot, "mp", "delete")
	elseif source == t[3] then
		triggerServerEvent ("event", resourceRoot, "warp")
	elseif source == t[4] then
		GUIEditor.window[1].visible = false
		GUIEditor.window[2].visible = false
		showCursor (false)
	elseif source == t[5] then
		triggerServerEvent ("event", resourceRoot, "hp", GUIEditor.edit[1].text)
	elseif source == t[7] then
		triggerServerEvent ("event", resourceRoot, "armor", GUIEditor.edit[1].text)
	elseif source == t[8] then
		local i = guiGridListGetSelectedItem (GUIEditor.gridlist[1])
		triggerServerEvent ("event", resourceRoot, "kick", i)
	elseif source == t[9] then
		triggerServerEvent ("event", resourceRoot, "veh", GUIEditor.edit[1].text)
	elseif source == t[10] then
		GUIEditor.window[1].visible = not GUIEditor.window[1].visible
	end
end)