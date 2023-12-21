
local autologinData
local trustedSerial
local currentLogin
addEvent("onPlayerLogin", true)

-- ==========     Запрос данных при старте ресурса и автологин     ==========
addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("getServerInfo", resourceRoot)
end)

addEvent("catchInfo", true)
addEventHandler("catchInfo", resourceRoot, function(serverData, accName, serial)
	GUI.serverNomer = serverData.smallServerName
	autologinData = {
		xmlFileName = "login_"..serverData.xmlName..".xml",
		xmlDecryptedFileName = "login_dec_"..serverData.xmlName..".xml",
		jsonFileName = "login_"..serverData.jsonName..".xml",
		filePassword = serverData.filePassword,
	}
	trustedSerial = serial

	if (accName) then
		currentLogin = accName
		return
	end
	
	local enabled, username, password = readAutologinFile()
	if (enabled) then
		if (username) and (password) and (username ~= "") and (password ~= "") then
			triggerServerEvent("requestAutologin", resourceRoot, username, password)
			return
		end
	end
	
	--fadeCamera(false, 0, 0,0,0)
	openMainWindow()
end)

function unsuccessfulAutologin(ban)
	printBanInfo(ban)
	--fadeCamera(false, 0, 0,0,0)
	openMainWindow()
end
addEvent("unsuccessfulAutologin", true)
addEventHandler("unsuccessfulAutologin", resourceRoot, unsuccessfulAutologin)

function printBanInfo(ban)
	if (type(ban) == "table") then
		local currentTime = getRealTime().timestamp
		if (ban.account) then
			outputChatBad(string.format("Внимание! Этот аккаунт был забанен администратором %s на %s.", tostring(ban.admin), timeSegmentToNiceString(ban.duration, true)))
			outputChatBad(string.format("Время окончания бана: %s.", dateTimeToString(ban.banEnd, ".")))
			outputChatBad(string.format("Аккаунт будет разблокирован через %s.", timeSegmentToNiceString(ban.banEnd-currentTime, true)))
		elseif (ban.serial) then
			outputChatBad(string.format("Внимание! Этот компьютер был забанен администратором %s на %s.", tostring(ban.admin), timeSegmentToNiceString(ban.duration, true)))
			outputChatBad(string.format("Время окончания бана: %s.", dateTimeToString(ban.banEnd, ".")))
			outputChatBad(string.format("Компьютер будет разблокирован через %s.", timeSegmentToNiceString(ban.banEnd-currentTime, true)))
		end
		if (ban.reason) and (ban.reason ~= "") then
			outputChatBad(string.format("Причина бана: %s.", tostring(ban.reason)))
		end
	end
end
addEvent("printBanInfo", true)
addEventHandler("printBanInfo", resourceRoot, printBanInfo)

addEvent("successfulAutologin", true)
addEventHandler("successfulAutologin", resourceRoot, function()
	outputChatGood("Для смены пароля #ABCDEF/changepassword.")
	outputChatGood("Для выключения автологина #ABCDEF/disableauto.")
	fadeCamera(true, 3)
	closeAllWindows()
end)


-- ==========     Логин     ==========
local loginAttempts = 0
local slowLoginTimer
function nothing() end
function loginMe(username, password)
	if not isTimer(slowLoginTimer) then
		if (username == "") then
			outputChatBad("Ошибка! Пожалуйста, введите свой логин!")
			return
		end
		if (password == "") then
			outputChatBad("Ошибка! Пожалуйста, введите пароль!")
			return
		end
		triggerServerEvent("requestLogin", resourceRoot, username, password, loginAttempts)
		slowLoginTimer = setTimer(nothing, 15000, 1)
	else
		outputChatBad(string.format("Вы пытаетесь войти слишком быстро! Пожалуйста, подождите еще %i секунд.", math.ceil(getTimerDetails(slowLoginTimer)/1000)))
	end
end

addEvent("successfulLogin", true)
addEventHandler("successfulLogin", resourceRoot, function(username, password)
	writeAutologinFile(false, username, password)
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "")
	setTimer(outputChatGood, 1000, 1, "Добро пожаловать на Award RPG!")
	fadeCamera(true, 3)
	setCameraTarget(localPlayer)
	closeAllWindows()
	loginAttempts = nil
end)

addEvent("updateLoginAttempts", true)
addEventHandler("updateLoginAttempts", resourceRoot, function(serverAttempts)
	loginAttempts = serverAttempts
	if (loginAttempts < 5) then
		outputChatBad("Внимание! Неверный логин или пароль!")
		outputChatBad("Попытки войти в аккаунт: [#008AFF"..loginAttempts.."/5#FFFFFF]")
	else
		outputChatBad("Внимание! Неверный логин или пароль!")
		outputChatBad("Внимание! Максимальное количество попыток залогиниться! [#008AFF5/5#FFFFFF]")
		outputChatBad("Ты будешь кикнут через #008AFF5 секунд#FFFFFF!")
	end
end)

-- ==========     Регистрация     ==========
local badPasswords = {
	["123456"] = true, ["password"] = true, ["12345678"] = true, ["qwerty"] = true, ["abc123"] = true,
	["123456789"] = true, ["111111"] = true, ["1234567"] = true, ["iloveyou"] = true, ["123123"] = true,
	["admin"] = true, ["1234567890"] = true, ["letmein"] = true, ["1234"] = true, ["monkey"] = true,
	["shadow"] = true, ["sunshine"] = true, ["12345"] = true, ["password1"] = true, ["azerty"] = true,
	["trustno1"] = true, ["000000"] = true,
}

local screenW, screenH = guiGetScreenSize()
local mainX = 1920
local sx, sy = (screenW/mainX), (screenH/1080)


function registerMe(username, password, passwordConfirm)
	if (username == "") then
		outputChatBad("Ошибка! Введи логин, под которым хотел бы зарегистрироваться!")
		--guiSetText(login_tab_error_msg, "Введите логин")
		setTimer(function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		return
	end
	if (password == "") then
		outputChatBad("Ошибка! Пожалуйста, введи свой пароль!")
		--guiSetText(login_tab_error_msg, "Пожалуйста, введи свой пароль!")
		setTimer(function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		return
	end
	if (passwordConfirm == "") then
		outputChatBad("Ошибка! Пожалуйста, введи подтверждение пароля!")
		--guiSetText(login_tab_error_msg, "Пожалуйста, введи подтверждение пароля")
		setTimer(function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		return
	end
	if (password ~= passwordConfirm) then
		outputChatBad("Ошибка! Пароли не совпадают!")
	--	guiSetText(login_tab_error_msg, "Пароли не совпадают!")
		setTimer(function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		return
	end
	if (utf8.len(password) < 4) then
		outputChatBad("Ошибка! Этот пароль слишком короткий! Допустимы пароли длиной не менее 4 символов.")
	-------	guiSetText(login_tab_error_msg, "Этот пароль слишком короткий!\nДопустим минимум 4 символа.")
		setTimer(function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		return
	end
	if (badPasswords[password]) then
		outputChatBad("Ошибка! Этот пароль слишком простой!")
		------guiSetText(login_tab_error_msg, "Этот пароль слишком простой!")
		setTimer(function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		return
	end
	if (username == password) then
		outputChatBad("Ошибка! Пароль не должен совпадать с логином!")
	-------	guiSetText(login_tab_error_msg, "Пароль не должен совпадать с логином!")
		setTimer(function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		return
	end
	antiDOSsend("register", 3000, "requestRegister", resourceRoot, username,  password)
end

addEvent("successfulRegister", true)
addEventHandler("successfulRegister", resourceRoot, function(username, password)
	antiDOSsend("register", 3000, false)
	--outputChatGood("#bd3839* Вы успешно зарегистрировались! #FFFFFF[Логин: "..username.." | Пароль: "..password.."]")
	---outputChatGood("#bd3839* Приятной игры на#FFFFFF Anubis RPG!")
	guiSetText(GUI.edit.regLogin, "")
	guiSetText(GUI.edit.regPass, "")
	guiSetText(GUI.edit.regPass2, "")
	openMainWindow()
	setTimer ( function () 
		--triggerServerEvent("addCarF3", resourceRoot, getLocalPlayer()) 
		--outputChatBox("#ffcc00Вы получили личный транспорт. Откройте F3, чтобы воспользоваться гаражом!", 255,0,0, true)
	end, 60000, 1)
end)




addCommandHandler("enableauto", function()
	local enabled, username, password = readAutologinFile()
	if (not enabled) then
		writeAutologinFile(true, username, password)
		outputChatGood("#bd3839*Вы успешно включили Автологин теперь вы будете автоматически логиниться #ffffffпри каждом входе на сервер.")
		setTimer(outputChatGood, 1000, 1, "#bd3839* Для отключения автологина пропишите : #ffffff/disableauto")
	else
		outputChatGood("#bd3839* Автологин уже включен.")
	end
end, false)

addCommandHandler("disableauto", function()
	local enabled, username, password = readAutologinFile()
	if (enabled) then
		writeAutologinFile(false, username, password)
		outputChatGood("#bd3839* Автологин уже выключен.")
	else
		outputChatGood("#bd3839* Автологин уже выключен.")
	end
end, false)

function autlogin_On ()
	if (not enabled) then
		writeAutologinFile(true, username, password)
		--outputChatGood("Автологин #00FF00ВКЛЮЧЕН#FFFFFF! Ты будешь автоматически логиниться при каждом входе на сервер.")
	else
		--outputChatGood("Автологин уже #00FF00ВКЛЮЧЕН#FFFFFF!")
	end
end



-- ==========     Смена пароля     ==========
addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenW, screenH = guiGetScreenSize()
	GUI.window.passwchange = guiCreateWindow((screenW - 300) / 2, (screenH - 235) / 2, 300, 235, "Смена пароля", false)
	guiWindowSetSizable(GUI.window.passwchange, false)

	GUI.label[1] = guiCreateLabel(20, 20, 260, 17, "Старый пароль:", false, GUI.window.passwchange)
	guiSetFont(GUI.label[1], "default-bold-small")
	guiLabelSetHorizontalAlign(GUI.label[1], "center", false)
	guiLabelSetVerticalAlign(GUI.label[1], "center")
	GUI.edit.oldPassword = guiCreateEdit(20, 40, 260, 25, "", false, GUI.window.passwchange)
	guiEditSetMasked(GUI.edit.oldPassword, true)
	GUI.label[2] = guiCreateLabel(20, 70, 260, 17, "Новый пароль:", false, GUI.window.passwchange)
	guiSetFont(GUI.label[2], "default-bold-small")
	guiLabelSetHorizontalAlign(GUI.label[2], "center", false)
	guiLabelSetVerticalAlign(GUI.label[2], "center")
	GUI.edit.newPassword = guiCreateEdit(20, 90, 260, 25, "", false, GUI.window.passwchange)
	guiEditSetMaxLength(GUI.edit.newPassword, 30)
	guiEditSetMasked(GUI.edit.newPassword, true)
	GUI.label[3] = guiCreateLabel(20, 120, 260, 17, "Повторите новый пароль:", false, GUI.window.passwchange)
	guiLabelSetHorizontalAlign(GUI.label[3], "center", false)
	guiLabelSetVerticalAlign(GUI.label[3], "center")
	guiSetFont(GUI.label[3], "default-bold-small")
	GUI.edit.newPasswordConfirm = guiCreateEdit(20, 140, 260, 25, "", false, GUI.window.passwchange)
	guiEditSetMaxLength(GUI.edit.newPasswordConfirm, 30)
	guiEditSetMasked(GUI.edit.newPasswordConfirm, true)
	GUI.button.OK = guiCreateButton(20, 175, 125, 50, "OK", false, GUI.window.passwchange)
	GUI.button.cancel = guiCreateButton(155, 175, 125, 50, "Отмена", false, GUI.window.passwchange)    
	
	guiSetVisible(GUI.window.passwchange, false)
end)

function pasChangeButtClicks()
    if (source == GUI.button.OK) then
		local oldPass = guiGetText(GUI.edit.oldPassword)
		local newPass = guiGetText(GUI.edit.newPassword)
		local newPassConf = guiGetText(GUI.edit.newPasswordConfirm)
		if (oldPass == "") then
			outputChatBad("Невозможно поменять пароль - введите старый пароль")
			return
		end
		if (newPass == "") then
			outputChatBad("Невозможно поменять пароль - введите новый пароль")
			return
		end
		if (newPassConf == "") then
			outputChatBad("Невозможно поменять пароль - введите подтверждение пароля")
			return
		end
		if (newPass ~= newPassConf) then
			outputChatBad("Невозможно поменять пароль - новые пароли не совпадают")
			return
		end
		if (utf8.len(newPass) < 4) then
			outputChatBad("Невозможно поменять пароль - допустимы пароли длиной не менее 4 символов.")
			return
		end
		if (badPasswords[newPass]) then
			outputChatBad("Невозможно поменять пароль - новый пароль слишком простой!")
			return
		end
		if (newPass == currentLogin) then
			outputChatBad("Ошибка! Пароль не должен совпадать с логином!")
			return
		end
		antiDOSsend("register", 3000, "requestRegister", resourceRoot, username, password)
		
	elseif (source == GUI.button.cancel) then
		guiSetText(GUI.edit.oldPassword, "")
		guiSetText(GUI.edit.newPassword, "")
		guiSetText(GUI.edit.newPasswordConfirm, "")
		toggleChangePasswordWindow()
		
    end
end
addEventHandler("onClientGUIClick", resourceRoot, pasChangeButtClicks)

function toggleChangePasswordWindow()
	local state = not guiGetVisible(GUI.window.passwchange)
	guiSetVisible(GUI.window.passwchange, state)
	guiSetInputMode("no_binds_when_editing")
	showCursor(state)
end
addCommandHandler("changePassword", toggleChangePasswordWindow, false)

addEvent("closeChangepassWindow", true)
addEventHandler("closeChangepassWindow", resourceRoot, function(newPassword)
	outputChatGood("Пароль был успешно изменен!")
	local enabled, username, password = readAutologinFile()
	writeAutologinFile(enabled, username, newPassword)
	guiSetText(GUI.edit.oldPassword, "")
	guiSetText(GUI.edit.newPassword, "")
	guiSetText(GUI.edit.newPasswordConfirm, "")
	guiSetVisible(GUI.window.passwchange, false)
	showCursor(false)
end)


--	==========     Слоумод на кнопку/действие     ==========
local sendData = {}
local sendTimers = {}

function antiDOSsend(actionGroup, pause, ...)
	local args = {...}
	if isTimer(sendTimers[actionGroup]) then
		sendData[actionGroup] = args[1] and args
	else
		if (args[1]) then
			triggerServerEvent(...)
			sendData[actionGroup] = false
			sendTimers[actionGroup] = setTimer(slowSend, pause, 1, actionGroup)
		end
	end
end

function slowSend(actionGroup)
	if (sendData[actionGroup]) then
		triggerServerEvent(unpack(sendData[actionGroup]))
		sendData[actionGroup] = nil
	end
end

--	==========     Вывод сообщений в чат     ==========
function outputChatGood(text)
	outputChatBox("#FFFFFF"..text, 0,0,255, true)
end
function outputChatBad(text)
	outputChatBox("#FFFFFF"..text, 255,0,0, true)
end


-- ========
-- ==========     Управление файлами автологина     ==========
function readAutologinFile()
	if fileExists(autologinData.jsonFileName) then
		local file = fileOpen(autologinData.jsonFileName)
		if (file) then
			local readData = fileRead(file, 1024)
			fileClose(file)
			
			local data = fromJSON(readData, autologinData.filePassword)
			if (data) and (type(data) == "table") then
				local enabled = data.enabled and true or false
				local username = tostring(data.username)
				local password = tostring(data.password)
				local serial = tostring(data.serial)
				
				if (serial == trustedSerial) then
					return enabled, username, password
				else
					triggerServerEvent("incorrectSerialInFile", resourceRoot, serial, username, readData, true)
				end
			end
		end
	else
		return readXmlAutologinFile()
	end
	return false
end

function writeAutologinFile(enabled, username, password)
	local data = toJSON({enabled=enabled, username=username, password=password, serial=trustedSerial}, true), autologinData.filePassword
	local file = fileCreate(autologinData.jsonFileName)
	if (file) then
		fileWrite(file, data)
		fileClose(file)
	end
end

-- ==========     Чтение устаревших XML-файлов автологина     ==========
function readXmlAutologinFile()
	decryptXmlFile()
	local xmlFile = xmlLoadFile(autologinData.xmlDecryptedFileName)
	local enabled, username, password, serial
	if (xmlFile) then
		if (xmlNodeGetAttribute(xmlFile,"autologin") == "true") then
			enabled = true
		end
		username = tostring(xmlNodeGetAttribute(xmlFile,"username"))
		password = tostring(xmlNodeGetAttribute(xmlFile,"password"))
		serial = tostring(xmlNodeGetAttribute(xmlFile,"serial"))
		xmlUnloadFile(xmlFile)
		fileDelete(autologinData.xmlDecryptedFileName)
		
		if (serial == trustedSerial) or (serial == "false") then
			fileDelete(autologinData.xmlFileName)
			writeAutologinFile(enabled, username, password)
			return enabled, username, password
		else
			local readData = toJSON({enabled = enabled, username = username, password = password, serial = serial}, true)
			readData = readData, autologinData.filePassword
			triggerServerEvent("incorrectSerialInFile", resourceRoot, serial, username, readData)
		end
	end
	return false
end
function decryptXmlFile()
	local testNode = xmlLoadFile(autologinData.xmlFileName)
	if (not testNode) then
		if fileExists(autologinData.xmlFileName) then
			local file = fileOpen(autologinData.xmlFileName, true)
			local data = fileRead(file, 1024)
			fileClose(file)
			
			data = data, autologinData.filePassword
			
			file = fileCreate(autologinData.xmlDecryptedFileName)
			fileWrite(file, data)
			fileClose(file)
		end
	else
		xmlUnloadFile(testNode)
		fileCopy(autologinData.xmlFileName, autologinData.xmlDecryptedFileName, false)
		fileCopy(autologinData.xmlFileName, "temp", false)
		encryptXmlFile()
		fileCopy("temp", autologinData.xmlDecryptedFileName, false)
		fileDelete("temp")
	end
end
function encryptXmlFile()
	local file = fileOpen(autologinData.xmlDecryptedFileName, true)
	local data = fileRead(file, 1024)
	fileClose(file)
	fileDelete(autologinData.xmlDecryptedFileName)
	
	data = data, autologinData.filePassword
	
	file = fileCreate(autologinData.xmlFileName)
	fileWrite(file, data)
	fileClose(file)
end

local settingsFile = "settings.json"
function loadSettings()
	local data
	if fileExists(settingsFile) then 
		local file = fileOpen(settingsFile, true)
		if (file) then
			data = fromJSON(fileRead(file, fileGetSize(file)))
			fileClose(file)
		end
	end
	if (type(data) ~= "table") then data = {} end
	
	local user = GUI.enteredLogin
	local pass = GUI.enteredPass
	
	editbot["checkbox"] = data.save or false
	GUI.enteredLogin = data.user or ""
	GUI.enteredPass = data.pass or ""
end

local needsSave, saveTimer = false
function saveSettings()
	if isTimer(saveTimer) then
		needsSave = true
	else
		needsSave = true
		writeSettingsFile()
		saveTimer = setTimer(writeSettingsFile, 1000, 1)
	end
end

function writeSettingsFile()
	if (needsSave) then
		local data = {}
		data.save = editbot["checkbox"]
		if data.save then
			data.user = GUI.enteredLogin
			data.pass = GUI.enteredPass
		end

		local file = fileCreate(settingsFile)
		if (file) then
			fileWrite(file, toJSON(data, true))
			fileClose(file)
		end
		
		needsSave = false
	end
end