
local moderData = {}

function createModerationGui()
	local screenW, screenH = guiGetScreenSize()
	GUI.window.moderation = guiCreateWindow((screenW - 530) / 2, (screenH - 315) / 2, 530, 315, "Номера на модерации", false)
	guiWindowSetSizable(GUI.window.moderation, false)

	GUI.label.moderLicensep = guiCreateLabel(10, 25, 265, 15, "", false, GUI.window.moderation)
	GUI.staticimage.moderPreview = guiCreateStaticImage(10, 50, 235, 50, "files/blank.png", false, GUI.window.moderation)
	GUI.checkbox.anonymous = guiCreateCheckBox(10, 110, 135, 15, "Сообщать анонимно", false, false, GUI.window.moderation)  
	GUI.label[2] = guiCreateLabel(10, 142, 55, 15, "Причина:", false, GUI.window.moderation)
	GUI.edit.refuseReason = guiCreateEdit(70, 135, 205, 30, "", false, GUI.window.moderation)
	guiEditSetMaxLength(GUI.edit.refuseReason, 30)  
	GUI.staticimage.moderOk = guiCreateStaticImage(10, 175, 128, 128, "files/yes128.png", false, GUI.window.moderation)
	GUI.staticimage.moderRefuse = guiCreateStaticImage(148, 175, 128, 128, "files/no128.png", false, GUI.window.moderation)
	GUI.gridlist.moderation = guiCreateGridList(285, 25, 235, 225, false, GUI.window.moderation)
	guiGridListSetSortingEnabled (GUI.gridlist.moderation, false)
	guiGridListAddColumn(GUI.gridlist.moderation, "Номер", 0.46)
	guiGridListAddColumn(GUI.gridlist.moderation, "Заказчик", 0.46)
	GUI.button.closeModer = guiCreateButton(425, 260, 95, 45, "Закрыть", false, GUI.window.moderation)
	
	guiSetVisible(GUI.window.moderation, false)
	addEventHandler("onClientMouseEnter", resourceRoot, onHover)
	addEventHandler("onClientMouseLeave", resourceRoot, onLeave)
end

function refreshModerList(data)
	-- local rw, cl = guiGridListGetSelectedItem(GUI.gridlist.moderation)
	guiGridListClear(GUI.gridlist.moderation)
	for _, dataRow in ipairs(data) do			
		local row = guiGridListAddRow(GUI.gridlist.moderation)
		guiGridListSetItemText(GUI.gridlist.moderation, row, 1, exports.car_system:convertPlateIDtoLicensep(dataRow.licensep), false, true)
		guiGridListSetItemText(GUI.gridlist.moderation, row, 2, tostring(dataRow.owner), false, true)
		moderData[row] = dataRow
	end
	-- guiGridListSetSelectedItem(GUI.gridlist.moderation, rw, cl)
end
addEvent("refreshModerList", true)
addEventHandler("refreshModerList", resourceRoot, refreshModerList)

addEventHandler("onClientGUIClick", resourceRoot, function()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.moderation)
	selected = (selected > -1) and selected or false
	
	if (source == GUI.button.closeModer) then
		closeModerationGui()
	
	elseif (source == GUI.gridlist.moderation) then
		if (selected) then
			previewModerLicensep(moderData[selected].licensep)
		else
			guiSetText(GUI.label.moderLicensep, "")
			guiStaticImageLoadImage(GUI.staticimage.moderPreview, "files/blank.png")
		end
	
	elseif (source == GUI.staticimage.moderOk) then
		if (selected) then
			local ID = moderData[selected].ID
			local anon = guiCheckBoxGetSelected(GUI.checkbox.anonymous)
			local comment = guiGetText(GUI.edit.refuseReason)
			if (comment ~= "") then
				outputBadMessage("Если хочешь принять, убери причину")
				return
			end
			guiGridListSetSelectedItem(GUI.gridlist.moderation, 0, 0)
			triggerServerEvent("acceptLicensep", resourceRoot, ID, anon)
		else
			outputBadMessage("Номер не выбран!")
		end
	
	elseif (source == GUI.staticimage.moderRefuse) then
		if (selected) then
			local ID = moderData[selected].ID
			local anon = guiCheckBoxGetSelected(GUI.checkbox.anonymous)
			local comment = guiGetText(GUI.edit.refuseReason)
			if (comment == "") then
				outputBadMessage("Пожалуйста, напиши причину!")
				return
			end
			guiSetText(GUI.edit.refuseReason, "")
			guiGridListSetSelectedItem(GUI.gridlist.moderation, 0, 0)
			triggerServerEvent("refuseLicensep", resourceRoot, ID, anon, comment)
		else
			outputBadMessage("Номер не выбран!")
		end
	end
end)

function renewPreview()
	local selected = guiGridListGetSelectedItem(GUI.gridlist.moderation)
	if (selected > -1) then
		previewModerLicensep(moderData[selected].licensep)
	else
		guiSetText(GUI.label.moderLicensep, "")
		guiStaticImageLoadImage(GUI.staticimage.moderPreview, "files/blank.png")
	end
end

function previewModerLicensep(nomer)
	setTexturePreview(GUI.staticimage.moderPreview, nomer)
	if isResourceRunning("car_system") then
		local licensep = exports.car_system:convertPlateIDtoLicensep(nomer)
		guiSetText(GUI.label.moderLicensep, string.format("Номер: %s %s", nomer, licensep))
	else
		guiSetText(GUI.label.moderLicensep, string.format("Номер: %s", nomer))
	end
end












function onHover()
	if (source == GUI.staticimage.moderOk) or (source == GUI.staticimage.moderRefuse) then
		guiSetAlpha(source, 0.8)
	end
end
function onLeave()
	if (source == GUI.staticimage.moderOk) or (source == GUI.staticimage.moderRefuse) then
		guiSetAlpha(source, 1.0)
	end
end

-- ==========     Открытие/закрытие панели     ==========
addEvent("toggleModerPanel", true)
addEventHandler("toggleModerPanel", resourceRoot, function()
	_= guiGetVisible(GUI.window.moderation) and closeModerationGui() or openModerationGui()
end)

function openModerationGui()
	guiSetVisible(GUI.window.moderation, true)
	guiSetInputMode("no_binds_when_editing")
	showCursor(true)
	triggerServerEvent("updateModerInfo", resourceRoot)
end

function closeModerationGui()
	guiSetVisible(GUI.window.moderation, false)
	if (not guiGetVisible(GUI.window.main)) then
		showCursor(false)
	end
	return true
end

-- ==========     Значок о наличии номеров на модерацию     ==========
local screenW, screenH = guiGetScreenSize()
local speed = 4
local lX = screenW-314-64
local drawLetter, letterColor, direction

function onMessageIncome()
	drawLetter = true
	letterColor = 0
	direction = -speed
end
addEvent("newModerNomer", true)
addEventHandler("newModerNomer", resourceRoot, onMessageIncome)

function closeMessages()
	drawLetter = false
end
addEvent("moderNomersEmpty", true)
addEventHandler("moderNomersEmpty", resourceRoot, closeMessages)

function onRender()
	if drawLetter then
		dxDrawImage(lX, 40, 64, 69, "files/EKX_notify.png", 0, 0, 0, tocolor(255,255,255,letterColor))
		letterColor = letterColor + direction
		if (letterColor < 0) then
			letterColor = 0
			direction = speed
		elseif (letterColor > 255) then
			letterColor = 255
			direction = -speed
		end
	end
end
addEventHandler("onClientRender", root, onRender)












