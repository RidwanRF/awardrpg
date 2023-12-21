
addEventHandler("onResourceStart", resourceRoot, function()
	if isResourceRunning("mysql") then
		exports.mysql:dbExec("moderation", "CREATE TABLE IF NOT EXISTS ?? (`ID` INT UNSIGNED NOT NULL PRIMARY KEY, `owner` TEXT, `licensep` VARCHAR(50), `status` VARCHAR(10), `comment` VARCHAR(255), `price` INT UNSIGNED) COLLATE=utf8_unicode_ci;")
		
		setTimer(alertOnAddingOrEmptyList, 10000, 1)
	else
		outputDebugString("[CAR_NOMERCHANGE][ERROR] Cannot onResourceStart - mysql is not active", 1)
	end
end)

addCommandHandler("ekxzovet", function(player)
	triggerClientEvent(player, "toggleModerPanel", resourceRoot)
end, true, false)

function isAdmin(player)
	return hasObjectPermissionTo(player, "command.ekxzovet", false)
end

-- ==========     Добавление в список модерируемых номеров     ==========
function addNomerToModeration(newNomer, price, accName, ownerPlayer)
	if isResourceRunning("mysql") then
		exports.mysql:dbExec("moderation", "INSERT INTO ?? (`ID`, `owner`, `licensep`, `status`, `comment`, `price`) VALUES (?, ?, ?, ?, ?, ?);",
			getFreeID("moderation"), accName, newNomer, "waiting", "", price)
		if (ownerPlayer) then
			updateStorageInfo(ownerPlayer)
		end
		
		alertOnAddingOrEmptyList()
		outputDebugString(string.format("[CAR_NOMERCHANGE][ADD] added licensep %s for %s to moderation for %i%s", newNomer, accName, price, "DONATE"))
	else
		outputDebugString("[CAR_NOMERCHANGE][ERROR] Cannot addNomerToModeration - mysql is not active", 1)
	end
end

-- ==========     Проверить на наличие номеров на модерацию и выдать/убрать уведомление     ==========
function alertOnAddingOrEmptyList(onlyEmpty)
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("alertOnAddingOrEmptyListCallback", {onlyEmpty=onlyEmpty}, "moderation", "SELECT COUNT(ID) AS count FROM ?? WHERE status = 'waiting';")
	else
		outputDebugString("[CAR_NOMERCHANGE][WARNING] Cannot alertOnAddingOrEmptyList - mysql is not active", 2)
	end
end
function alertOnAddingOrEmptyListCallback(result, args)
	local result = (result) and (result[1]) and (tonumber(result[1].count))
	if (not result) then return end
	
	if (args.onlyEmpty) and (result > 0) then return end
	
	local eventName = (result == 0) and "moderNomersEmpty" or "newModerNomer"
	
	for _, player in ipairs(getElementsByType("player")) do
		if isAdmin(player) then
			triggerClientEvent(player, eventName, resourceRoot)
		end
	end
	updateModerInfo("all")
end

-- ==========     Отправка списка номеров на модерации     ==========
function updateModerInfo(player)
	if isResourceRunning("mysql") then
		local args = {player = (player or client)}
		if isElement(player) then
			if not isAdmin(args.player) then return end
		elseif (player == "all") then
			
		elseif isElement(client) then
			if not isAdmin(args.player) then return end
		else
			return
		end
		exports.mysql:dbQueryAsync("updateModerInfoCallback", args, "moderation", "SELECT * FROM ?? WHERE status = 'waiting';")
	else
		outputDebugString("[CAR_NOMERCHANGE][WARNING] Cannot updateModerInfo - mysql is not active", 2)
	end
end
function updateModerInfoCallback(result, args)
	if (args.player == "all") then
		for _, player in ipairs(getElementsByType("player")) do
			if isAdmin(player) then
				triggerClientEvent(player, "refreshModerList", resourceRoot, result)
			end
		end
	elseif isElement(args.player) then
		triggerClientEvent(args.player, "refreshModerList", resourceRoot, result)
	end
end
addEvent("updateModerInfo", true)
addEventHandler("updateModerInfo", resourceRoot, updateModerInfo)

-- ==========     Принятие номера     ==========
function acceptLicensep(ID, anon)
	if not isAdmin(client) then return end
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("acceptLicensepCallback", {player=client, anon=anon}, "moderation", "SELECT * FROM ?? WHERE ID = ?;", ID)
	else
		outputBadMessage("Ресурс mysql неактивен!", client)
		outputDebugString("[CAR_NOMERCHANGE][WARNING] Cannot acceptLicensep - mysql is not active", 2)
	end
end
function acceptLicensepCallback(result, args)
	if not isElement(args.player) then return end
	result = result[1]
	if (not result) or (result.status ~= "waiting") then
		outputBadMessage("Номер не найден. Возможно, кто-то его уже отмодерил, сорян.", args.player)
		updateModerInfo(args.player)
		return
	end
	
	exports.mysql:dbExec("moderation", "DELETE FROM ?? WHERE ID = ?;", result.ID)
	addNomerToBase(result.licensep, result.owner)
	
	local ownerAccount = getAccount(result.owner)
	local ownerPlayer = ownerAccount and getAccountPlayer(ownerAccount)
	if (ownerPlayer) and isResourceRunning("car_system") then
		if (anon) then
			outputMessage(string.format("Ваш номер %s был одобрен!", exports.car_system:convertPlateIDtoLicensep(result.licensep)), ownerPlayer)
		else
			outputMessage(string.format("Ваш номер %s был одобрен администратором %s!", exports.car_system:convertPlateIDtoLicensep(result.licensep), getPlayerName(args.player)), ownerPlayer)
		end
		updateStorageInfo(ownerPlayer)
	end
	
	outputDebugString(string.format("[CAR_NOMERCHANGE][ACCEPT] %s (acc %s) accepted licensep %s for player %s (acc %s)",
		getPlayerName(args.player), getAccountName(getPlayerAccount(args.player)), result.licensep, (ownerPlayer and getPlayerName(ownerPlayer) or "false"), result.owner)
	)
	
	alertOnAddingOrEmptyList(true)
	updateModerInfo(args.player)
end
addEvent("acceptLicensep", true)
addEventHandler("acceptLicensep", resourceRoot, acceptLicensep)

-- ==========     Отвергание номера     ==========
function refuseLicensep(ID, anon, comment)
	if not isAdmin(client) then return end
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("refuseLicensepCallback", {player=client, anon=anon, comment=comment}, "moderation", "SELECT * FROM ?? WHERE ID = ?;", ID)
	else
		outputBadMessage("Ресурс mysql неактивен!", client)
		outputDebugString("[CAR_NOMERCHANGE][WARNING] Cannot acceptLicensep - mysql is not active", 2)
	end
end
function refuseLicensepCallback(result, args)
	if not isElement(args.player) then return end
	result = result[1]
	if (not result) or (result.status ~= "waiting") then
		outputBadMessage("Номер не найден. Возможно, кто-то его уже отмодерил, сорян.", args.player)
		updateModerInfo(args.player)
		return
	end
	
	if not isResourceRunning("bank") then
		outputBadMessage("Банк не запущен, будет невозможно вернуть донат-валюту", args.player)
		return
	end
	
	local ownerAccount = getAccount(result.owner)
	if (not ownerAccount) then
		outputBadMessage("Аккаунт владельца не найден, вернуть донат-валюту невозможно", args.player)
		return
	end
	
	exports.mysql:dbExec("moderation", "UPDATE ?? SET status = 'refused', comment = ? WHERE ID = ?;", args.comment, result.ID)
	exports.bank:giveAccountBankMoney(ownerAccount, result.price, "DONATE")
	
	local ownerPlayer = getAccountPlayer(ownerAccount)
	if (ownerPlayer) and isResourceRunning("car_system") then
		if (anon) then
			outputBadMessage(string.format("Ваш номер %s был отклонен по причине: %s. Его стоимость возвращена.", exports.car_system:convertPlateIDtoLicensep(result.licensep), args.comment), ownerPlayer)
		else
			outputBadMessage(string.format("Ваш номер %s был отклонен администратором %s по причине: %s. Его стоимость возвращена.", exports.car_system:convertPlateIDtoLicensep(result.licensep), getPlayerNameWoutColor(args.player), args.comment), ownerPlayer)
		end
		updateStorageInfo(ownerPlayer)
	end
	
	outputDebugString(string.format("[CAR_NOMERCHANGE][REFUSE] %s (acc %s) refused licensep %s for player %s (acc %s) because: %s",
		getPlayerName(args.player), getAccountName(getPlayerAccount(args.player)), result.licensep, (ownerPlayer and getPlayerName(ownerPlayer) or "false"), result.owner, args.comment)
	)
	
	alertOnAddingOrEmptyList(true)
	updateModerInfo(args.player)
end
addEvent("refuseLicensep", true)
addEventHandler("refuseLicensep", resourceRoot, refuseLicensep)

-- ==========     Удаление номера самим игроком     ==========
function deleteFromModeration(ID, player)
	if isResourceRunning("mysql") then
		exports.mysql:dbQueryAsync("deleteFromModerationCallback", {player=player}, "moderation", "SELECT * FROM ?? WHERE ID = ?;", ID)
	else
		outputBadMessage("Произошла ошибка - mysql is not active", client)
		outputDebugString("[CAR_NOMERCHANGE][WARNING] Cannot deleteFromModeration - mysql is not active", 2)
	end
end
function deleteFromModerationCallback(result, args)
	if (not result) or (not result[1]) or (not isElement(args.player)) then return end
	result = result[1]
	local account = getPlayerAccount(args.player)
	local accName = getAccountName(account)
	
	if (result.owner ~= accName) then
		return
	end
	
	if (result.status == "refused") then
		exports.mysql:dbExec("moderation", "DELETE FROM ?? WHERE ID = ?;", result.ID)
		outputMessage(string.format("Вы удалили номер %s из списка отклоненных", (isResourceRunning("car_system") and exports.car_system:convertPlateIDtoLicensep(result.licensep) or result.licensep)), args.player)
		outputDebugString(string.format("[CAR_NOMERCHANGE][DELREFUSE] %s (acc %s money %i) deleted refused licensep %s",
			getPlayerName(args.player), accName, getPlayerMoney(args.player), result.licensep))
		updateStorageInfo(args.player)
		
	elseif (result.status == "waiting") then
		if (not isResourceRunning("bank")) then
			outputBadMessage("Невозможно вернуть донат-валюту. Системная ошибка (#1).", args.player)
			return
		end
		
		exports.mysql:dbExec("moderation", "DELETE FROM ?? WHERE ID = ?;", result.ID)
		exports.bank:givePlayerBankMoney(args.player, result.price, "DONATE")
		
		outputMessage(string.format("Вы удалили номер %s из списка модерации. %i ед. донат-валюты возвращены на ваш счет.",
			(isResourceRunning("car_system") and exports.car_system:convertPlateIDtoLicensep(result.licensep) or ""), result.price), args.player)
		outputDebugString(string.format("[CAR_NOMERCHANGE][DELMODER] %s (acc %s money %i bank %i%s) deleted licensep %s from moderation for %i%s",
			getPlayerName(args.player), accName, getPlayerMoney(args.player), exports.bank:getPlayerBankMoney(args.player, "DONATE"), "DONATE", result.licensep, result.price, "DONATE"))
		updateStorageInfo(args.player)
		alertOnAddingOrEmptyList(true)
		
	end
end


--	==========     Получить имя игрока без цветового кода     ==========
function getPlayerNameWoutColor(player)
	return string.gsub(getPlayerName(player), '#%x%x%x%x%x%x', '')
end


-- ==========     Связанное с удалением аккаунтов     ==========
function wipeAccountModeration(accName)
	local data = exports.mysql:dbQuery(-1, "moderation", "SELECT * FROM ?? WHERE owner = ?;", accName)
	for _, row in ipairs(data) do
		exports.mysql:dbExec("moderation", "DELETE FROM ?? WHERE ID = ?;", row.ID)
		if (row.status == "waiting") then
			exports.bank:giveAccountBankMoney(getAccount(accName), row.price, "DONATE")
			outputDebugString(string.format("[NOMERCHANGE] Returned %i DONATE to account %s for licensep on moderation ID %i",
				row.price, row.owner, row.ID
			))
		end
		outputDebugString(string.format("[NOMERCHANGE] Deleted licensep on moderation ID %i, licensep %s, status %s, owner %s",
			row.ID, row.licensep, row.status, accName
		))
	end
	return 0, data
end
