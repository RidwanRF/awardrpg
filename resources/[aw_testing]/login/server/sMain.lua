local accountNumber = 10                  --// Кол-во аккаунтов разрешенно регистрировать 

local serversData = {
	["test"] = {
		smallServerName = "test",
		xmlName = "2E2A3B537799651",	-- string.sub(md5(getServerName()), 0, 15)
		jsonName = "2E2A3B537799651FA",
		filePassword = "[{xYED_n2PDjmD\}"
	},
	["1"] = {
		smallServerName = "1",
		xmlName = "539B05BCE3125C8",
		jsonName = "539B05BCE3125C888",
		filePassword = "CN6g30№=2=AnEAs7"
	},
	["2"] = {
		smallServerName = "2",
		xmlName = "B69D50D8C6CE024",
		jsonName = "B69D50D8C6CE02412",
		filePassword = "RD}UuU>Lp_x№it3d"
	},
	["3"] = {
		smallServerName = "3",
		xmlName = "2BACDB51E8FF86F",
		jsonName = "2BACDB51E8FF86F96",
		filePassword = "rTsjFXzPob4uGzZe"
	},
	["4"] = {
		smallServerName = "4",
		xmlName = "67CE26AB8C9D1E0",
		jsonName = "67CE26AB8C9D1E039",
		filePassword = "f4INOdE7odC7*9№i"
	},
	["5"] = {
		smallServerName = "5",
		xmlName = "FFA9AC398F914EF",
		jsonName = "FFA9AC398F914EFC9",
		filePassword = "JN]c8=aKK%OMeP20"
	}
}

local thisServerData = serversData[ exports.config:getCCDPlanetNumber() ]
addEvent("getServerInfo", true)
addEventHandler("getServerInfo", resourceRoot, function()
	local acc = getPlayerAccount(client)
	local accName = (not isGuestAccount(acc)) and getAccountName(acc)
	triggerClientEvent(client, "catchInfo", resourceRoot, thisServerData, accName, getPlayerSerial(client))
end)

addEvent("requestAutologin",true)
addEventHandler("requestAutologin", resourceRoot, function(username, encodedPassword)
	local banInfo = isBanned(username, client, getPlayerSerial(client))
	if (banInfo) then
		if isResourceRunning("nicklogin") then
			exports.nicklogin:addFailedLogin(client, username, "Autologin: acc/serial is banned")
		end
		triggerClientEvent(client, "unsuccessfulAutologin", resourceRoot, banInfo)
		return
	end
	local password = encodedPassword
	local account = getAccount(username, password)
	if (account) then
		if logIn(client, account, password) then
			triggerClientEvent(client, "successfulAutologin", resourceRoot)
		else
			if isResourceRunning("nicklogin") then
				exports.nicklogin:addFailedLogin(client, username, "Autologin: unknown login error")
			end
			--outputChatBad("Неизвестная ошибка при входе!", client)
			triggerClientEvent(source,"showMsgText",getRootElement(),"Login")
		end
	else
		if isResourceRunning("nicklogin") then
			if getAccount(username) then
				exports.nicklogin:addFailedLogin(client, username, "Autologin: wrong password")
			else
				exports.nicklogin:addFailedLogin(client, username, "Autologin: wrong login")
			end
		end
		outputChatBad("Ошибка авто-логина, логин или пароль неверен!", client)
		triggerClientEvent(source,"showMsgText",getRootElement(),"Login")
		triggerClientEvent(client, "unsuccessfulAutologin", resourceRoot)
	end
end)

addEvent("incorrectSerialInFile",true)
addEventHandler("incorrectSerialInFile", resourceRoot, function(serial, login, packedData, jsonUsed)
	outputDebugString("[LOGIN][SERIALERROR] "..getPlayerName(client).." (IP "..getPlayerIP(client).." serial "..getPlayerSerial(client)..") tried to use loginfile for acc "..tostring(login).." with serial "..tostring(serial)..". Data read: "..tostring(packedData))
	if isResourceRunning("nicklogin") then
		exports.nicklogin:addFailedLogin(client, login, "Autologin: wrong serial")
	end
end)


-- ==========     Пользовательские действия     ==========
-- Логин
addEvent("requestLogin",true)
addEventHandler("requestLogin", resourceRoot, function(username, encodedPassword, loginAttempts)
	local password = encodedPassword
	local account = getAccount(username, password)
	if (account) then
		local ban = isBanned(username, client, getPlayerSerial(client))
		if (ban) then
			if isResourceRunning("nicklogin") then
				exports.nicklogin:addFailedLogin(client, username, "Acc/serial is banned")
			end
			triggerClientEvent(client, "printBanInfo", resourceRoot, ban)
			return
		end
		if logIn(client, account, password) then
			triggerClientEvent(client, "successfulLogin", resourceRoot, username, encodedPassword)
		else
			if isResourceRunning("nicklogin") then
				exports.nicklogin:addFailedLogin(client, username, "Unknown login error")
			end
			triggerClientEvent(source,"showMsgText",getRootElement(),"Login")
		end
	else
		local accWOutPassword = getAccount(username)
		if (accWOutPassword) then
			outputDebugString("[AUTH][BADPASS] "..getPlayerName(client).." (IP "..getPlayerIP(client).." serial "..getPlayerSerial(client)..") ввел неверный пароль от аккаунта "..username)
			triggerClientEvent(source,"showMsgText",getRootElement(),"Login")
			if isResourceRunning("nicklogin") then
				exports.nicklogin:addFailedLogin(client, username, "Wrong password")
			end
		else
			outputDebugString("[AUTH][NOTEXIST] "..getPlayerName(client).." (IP "..getPlayerIP(client).." serial "..getPlayerSerial(client)..") попытался зайти в несуществующий аккаунт "..username)
			triggerClientEvent(source,"showMsgText",getRootElement(),"Login")
			if isResourceRunning("nicklogin") then
				exports.nicklogin:addFailedLogin(client, username, "Wrong login")
			end
		end
		loginAttempts = loginAttempts + 1
		triggerClientEvent(client, "updateLoginAttempts", resourceRoot, loginAttempts)
		if (loginAttempts > 4) then
			setTimer(kick, 5000, 1, client)
		end
	end
end)

function kick(player)
	if isElement(player) then
		kickPlayer(player, "Ошибка логина")
	end
end

addEvent("requestRegister",true)
addEventHandler("requestRegister", resourceRoot, function(username, password, ply)
	username = tostring(username)
	password = tostring(password)
	local account = getAccount(username)
	if (account) then
		triggerClientEvent(source,"showMsgText",getRootElement(),"Login","Аккаунт с таким логином уже существует!")
		return
	end
	if addAccount(username, password) then
		outputDebugString("[AUTH][REGISTER] "..getPlayerName(client).." registered account "..username)
		if isResourceRunning("nicklogin") then
			exports.nicklogin:addFailedLogin(client, username, "Account register")
		end
		--
		triggerClientEvent(client, "successfulRegister", resourceRoot, username, password)
	else
		--outputChatBad("Неизвестная ошибка! Пожалуйста, выбери другое имя пользователя/пароль и повтори попытку.", client)
		triggerClientEvent(source,"showMsgText",getRootElement(),"Login","Пожалуйста, выбери другой логин или пароль!")
	end
end)

-- Смена пароля
addEvent("changePassword",true)
addEventHandler("changePassword", resourceRoot, function(oldPass, newPassEncoded)
	local accName = getAccountName(getPlayerAccount(client))
	local account = getAccount(accName, oldPass)
	if (not account) then
		outputDebugString("[LOGIN][PASSCHERROR] "..getPlayerName(client).." (acc "..accName..") entered wrong password while changing it")
		outputChatBad("Невозможно поменять пароль - старый пароль неверен", client)
		return
	end
	newPass = newPassEncoded
	setAccountPassword(account, newPass, "plaintext")
	account = getAccount(accName, newPass)
	if (not account) then
		outputDebugString("[LOGIN][ERROR] "..getPlayerName(client).." (acc "..accName..") wanted to change his password and got unknown error (newPass = "..tostring(newPass)..")")
		outputChatBad("Произошла ошибка при установке пароля, обратитесь к администратору", client)
		return
	end
	outputDebugString("[LOGIN][PASSWCHANGE] "..getPlayerName(client).." (acc "..accName.." serial "..getPlayerSerial(client)..") changed his password")
	if isResourceRunning("nicklogin") then
		exports.nicklogin:addFailedLogin(client, accName, "Password change")
	end
	triggerClientEvent(client, "closeChangepassWindow", resourceRoot, newPassEncoded)
end)


-- ==========     Служебные функции     ==========
addEventHandler("onResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		local acc = getPlayerAccount(player)
		if not isGuestAccount(acc) then
			setElementData(player, "accountName", getAccountName(acc))
		end
	end
end)

addEventHandler("onPlayerLogin", root, function(_, theCurrentAccount)
	local accName = getAccountName(theCurrentAccount)
	setElementData(source, "accountName", accName)
	triggerClientEvent(source, "onPlayerLogin", root, accName)
end)


-- ==========     Просмотр файлов автологина     ==========
addCommandHandler("viewloginfile", function(playerSource)
	triggerClientEvent(playerSource, "openViewInfoPanel", resourceRoot)
end, true, false)

addEvent("getAllServersData",true)
addEventHandler("getAllServersData", resourceRoot, function()
	triggerClientEvent(client, "catchAllServersData", resourceRoot, serversData)
end)

local db = dbConnect("sqlite", "database/unpacks.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS unpacks (ID INTEGER PRIMARY KEY AUTOINCREMENT, admin TEXT, time TEXT, server TEXT, login TEXT, data TEXT)")

addEvent("unpackData",true)
addEventHandler("unpackData", resourceRoot, function(serv, packedData)
	local accName = getAccountName(getPlayerAccount(client))
	dbExec(db, "INSERT INTO unpacks VALUES(NULL, ?, ?, ?, NULL, ?)", accName, dateTimeToString(nil, "-"), serv, tostring(packedData))
	outputDebugString("[LOGIN][UNPACK] "..getPlayerName(client).." (acc "..accName.." serial "..getPlayerSerial(client)..") unpacked data. Pass: server"..tostring(serv)..", data: "..tostring(packedData))
end)

addEvent("unpackAutologin",true)
addEventHandler("unpackAutologin", resourceRoot, function(username, server, decoded)
	local accName = getAccountName(getPlayerAccount(client))
	dbExec(db, "INSERT INTO unpacks VALUES(NULL, ?, ?, ?, ?, ?)", accName, dateTimeToString(nil, "-"), server, tostring(username), tostring(decoded))
	outputDebugString("[LOGIN][UNPACK] "..getPlayerName(client).." (acc "..accName.." serial "..getPlayerSerial(client)..") unpacked autologin. Acc "..tostring(username)..", used pass: server"..tostring(server)..", data: "..tostring(decoded))
end)


--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end


--	==========     Вывод сообщений в чат     ==========
function outputChatBad(text, player)
	outputChatBox("* #FFFFFF"..text, player, 255,0,0, true)
end

addEvent("checkRegSerialPlayer",true)
addEventHandler("checkRegSerialPlayer", resourceRoot, 
	function(player)
		local serial = getPlayerSerial(player)
		local accounts = getAccountsBySerial(serial)
        if #accounts > 1 then 
            triggerClientEvent(player, "checkTextAccount", player)
        else
        	triggerClientEvent(player, "registerYep", player)
        end
    end
)
