
local GUI = {
    button = {},
    window = {},
    label = {},
    memo = {}
}
local allServersData

addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenW, screenH = guiGetScreenSize()
	GUI.window.decrypt = guiCreateWindow((screenW - 420) / 2, (screenH - 340) / 2, 420, 340, "Дешифрация файлов логин-панели", false)
	guiWindowSetSizable(GUI.window.decrypt, false)

	GUI.memo.textForDecrypt = guiCreateMemo(10, 25, 400, 80, "", false, GUI.window.decrypt)
	GUI.button.decrypt = guiCreateButton(315, 115, 95, 30, "Дешифровать", false, GUI.window.decrypt)
	GUI.label.decrypted = guiCreateLabel(10, 155, 400, 130, "", false, GUI.window.decrypt)
	guiLabelSetHorizontalAlign(GUI.label.decrypted, "left", true)   
	GUI.button.copy = guiCreateButton(10, 295, 95, 35, "Копировать", false, GUI.window.decrypt)
	GUI.button.close = guiCreateButton(325, 295, 85, 35, "Закрыть", false, GUI.window.decrypt)
	
	guiSetVisible(GUI.window.decrypt, false)
end)

function buttonClick()
    if (source == GUI.button.decrypt) then
		local data = guiGetText(GUI.memo.textForDecrypt)
		for serv, servData in pairs(allServersData) do
			local decoded = teaDecode(data, servData.filePassword)
			local unJSONed = fromJSON(decoded)
			if (not unJSONed) then
				file = fileCreate("temp")
				fileWrite(file, decoded)
				fileClose(file)
				local xmlFile = xmlLoadFile("temp")
				if xmlFile then
					local enabled
					if (xmlNodeGetAttribute(xmlFile,"autologin") == "true") then
						enabled = true
					end
					local username = tostring(xmlNodeGetAttribute(xmlFile,"username"))
					local password = tostring(xmlNodeGetAttribute(xmlFile,"password"))
					local serial = tostring(xmlNodeGetAttribute(xmlFile,"serial"))
					xmlUnloadFile(xmlFile)
					fileDelete("temp")
					guiSetText(GUI.label.decrypted, "Файл автологина (старый). Сервер "..serv..".\n\nАвтологин "..(enabled and "включен" or "вЫключен")..".\nЛогин: "..tostring(username).."\nПароль: "..tostring(password).."\nСерийник: "..tostring(serial))
					triggerServerEvent("unpackAutologin", resourceRoot, username, serv, data)
					return
				end
				fileDelete("temp")
			else
				if (unJSONed.enabled ~= nil) and (unJSONed.username) and (unJSONed.password) and (unJSONed.serial) then
					guiSetText(GUI.label.decrypted, string.format("Файл автологина (новый). Сервер %s.\n\nАвтологин %s.\nЛогин: %s\nПароль: %s\nСерийник: %s",
						serv, (unJSONed.enabled and "включен" or "вЫключен"), tostring(unJSONed.username), tostring(unJSONed.password), tostring(unJSONed.serial)
					))
					triggerServerEvent("unpackAutologin", resourceRoot, unJSONed.username, serv, data)
				else
					guiSetText(GUI.label.decrypted, "Файл данных. Распакован паролем сервера "..serv..".\n"..toJSON(unJSONed, false, "spaces"))
					triggerServerEvent("unpackData", resourceRoot, serv, data)
				end
				return
			end
		end
		guiSetText(GUI.label.decrypted, "Данные расшифровать не удалось.")
		
		
	elseif (source == GUI.button.copy) then
		local text = guiGetText(GUI.label.decrypted)
		if (text ~= "") then
			outputChatBox("* #FFFFFFДанные скопированы.", 255,0,0, true)
			setClipboard(text)
		else
			outputChatBox("* #FFFFFFНечего копировать!", 255,0,0, true)
		end
	
	
	elseif (source == GUI.button.close) then
		toggleViewInfoPanel()
		
	end
end
addEventHandler("onClientGUIClick", resourceRoot, buttonClick)

function toggleViewInfoPanel()
	local state = not guiGetVisible(GUI.window.decrypt)
	guiSetVisible(GUI.window.decrypt, state)
	guiSetText(GUI.memo.textForDecrypt, "")
	guiSetText(GUI.label.decrypted, "")
	showCursor(state)

	if (not allServersData) then
		triggerServerEvent("getAllServersData", resourceRoot)
	end
	guiSetInputMode("no_binds_when_editing")
end
--addCommandHandler("viewloginfile", toggleViewInfoPanel)
addEvent("openViewInfoPanel", true)
addEventHandler("openViewInfoPanel", resourceRoot, toggleViewInfoPanel)

function catchAllServersData(serversData)
	allServersData = serversData
end
addEvent("catchAllServersData", true)
addEventHandler("catchAllServersData", resourceRoot, catchAllServersData)