
local x2Activated = false

local exchangeCourse = {
	-- https://www.vtb24.ru/personal/service/cash/operations/Pages/default.aspx
	-- https://www.vtb24.ru/banking/currency/
	-- exchangeCourse[Что отдаю][Что получаю] = Сколько должен отдать, чтобы получить 1.
	-- Я отдаю 1,1517 доллара, получаю 1 евро. 
	-- Я отдаю 1 евро, получаю 1.0981 доллар.
	USD = {
		RUB = 1/64.10,
		USD = 1,
		EUR = 1.1429	
	},
	RUB = {
		RUB = 1,
		USD = 65.50,
		EUR = 75.00
	},
	EUR = {
		RUB = 1/71.55,
		USD = 1/1.0981,
		EUR = 1
	}
}

local percentLimit = {
	RUB = 500000,
	USD = 10000,
	EUR = 10000,
}

local transferFeeTimeout = 3600*23 + 30*60	-- 23:30
local transferFeeFile = "transferFee.json"

local currencyTable = {
	-- RUB = "₽",
	RUB = " руб.",
	USD = "$",
	EUR = "€",
	DONATE = " ед. донат-валюты",
}

-- local bankDataExample = {
	-- RUB = 123456,
	-- USD = 123456,
	-- EUR = 123456,
	-- DONATE = 123456,
	-- acc = userdata 0xFFCC00,
	-- accName = "Daeman"
-- }
local bankData = {}

-- ==========     Подсчет комссии за передачу денег     ==========
local playersTransferred = {}

addEventHandler("onResourceStart", resourceRoot, function()
	local lastTransferReset = get("lastTransferReset") or 0
	local timestamp = getRealTime().timestamp
	if (timestamp-lastTransferReset > transferFeeTimeout) then
		if fileExists(transferFeeFile) then
			fileDelete(transferFeeFile)
			outputDebugString("[BANK] Transfers JSON deleted")
		end
		set("lastTransferReset", timestamp)
		return
	end
	if fileExists(transferFeeFile) then
		local file = fileOpen(transferFeeFile, true)
		playersTransferred = fromJSON(fileRead(file, fileGetSize(file)))
		fileClose(file)
		outputDebugString("[BANK] Loaded transfers JSON")
	end
end)

function saveTransferFeeFile()
	local file = fileCreate(transferFeeFile)
	fileWrite(file, toJSON(playersTransferred, true))
	fileClose(file)
end

function calculateFee(sender, receiver, amount)
	local data = playersTransferred[sender] and playersTransferred[sender][receiver] or {amount = 0, fee = 0}
	amount = amount + data.amount
	if (amount < 100*1000) then
		return 0
		
	elseif (amount < 500*1000) then
		local fee = amount * 0.01	-- 1%
		fee = fee - data.fee
		return (fee > 0) and math.floor(fee) or 0
		
	elseif (amount < 3*1000*1000) then
		local fee = amount * 0.05	-- 5%
		fee = fee - data.fee
		return (fee > 0) and math.floor(fee) or 0
		
	else
		local fee = amount * 0.1	-- 10%
		fee = fee - data.fee
		return (fee > 0) and math.floor(fee) or 0
	end
end

function onSuccessfulTransfer(sender, receiver, amount, fee)
	playersTransferred[sender] = playersTransferred[sender] or {}
	playersTransferred[sender][receiver] = playersTransferred[sender][receiver] or {}
	local data = playersTransferred[sender][receiver]
	data.amount = (data.amount or 0) + amount
	data.fee = (data.fee or 0) + fee
	saveTransferFeeFile()
end

addEvent("getTransferFee", true)
addEventHandler("getTransferFee", resourceRoot, function(amount, player)
	amount = tonumber(amount)
	if (amount) and isElement(player) then
		local senderAccount = getAccountName(getPlayerAccount(client))
		local receiverAccount = getAccountName(getPlayerAccount(player))
		local fee = calculateFee(senderAccount, receiverAccount, amount)
		triggerClientEvent(client, "catchFee", resourceRoot, fee)
		-- iprint(fee)
	end
end)

-- ==========     Обновление курсов при старте     ==========
addEventHandler("onResourceStart", resourceRoot, function()
	fetchRemote("https://api.fixer.io/latest?base=RUB&symbols=USD,EUR", onCurrencyIncome)
end)
function onCurrencyIncome(result, errorCode)
	if (result ~= "ERROR") then
		local data = fromJSON(result)
		data = data.rates or {}
		if (data.USD) and (data.EUR) then
			local randDifference = (math.random() + 1)/100
			exchangeCourse.RUB.USD = math.round(1/data.USD + (1/data.USD*randDifference), 2)
			exchangeCourse.USD.RUB = 1 / (1/data.USD - (1/data.USD*randDifference))
			
			randDifference = (math.random() + 1)/100
			exchangeCourse.RUB.EUR = math.round(1/data.EUR + (1/data.EUR*randDifference), 2)
			exchangeCourse.EUR.RUB = 1 / (1/data.EUR - (1/data.EUR*randDifference))
			
			randDifference = (math.random() + 1)/100
			exchangeCourse.USD.EUR = data.USD/data.EUR + (data.USD/data.EUR*randDifference)
			exchangeCourse.EUR.USD = data.EUR/data.USD + (data.EUR/data.USD*randDifference)
			-- каким же охуительным был вывод этих формул
			
			outputDebugString("[BANK] New exchange courses: "..inspect(exchangeCourse))
			for _, player in ipairs(getElementsByType("player")) do
				triggerClientEvent(player, "catchBankData", resourceRoot, bankData[getPlayerAccount(player)], exchangeCourse, x2Activated)
			end
		else
			outputDebugString("[BANK][WARNING] Error getting currencies - wrong data ("..tostring(result)..")", 2)
		end
	else
	--	outputDebugString("[BANK][WARNING] Error getting currencies - code "..tostring(errorCode).."(https://wiki.multitheftauto.com/wiki/Template:Error_codes_for_callRemote_and_fetchRemote)", 2)
	end
end

function math.round(number, decimals)
	return tonumber(string.format("%."..(tonumber(decimals) or 0).."f", tostring(number)))
end


-- ==========     Функции банка     ==========
function exchange(amount, neededMoney, sourceCurrency, destCurrency)
	if not isElement(client) then return false end
	local acc = getPlayerAccount(client)
	if (sourceCurrency ~= "DONATE") then
		neededMoney = calculateSumNeededToExchange(amount, sourceCurrency, destCurrency)
	else
		amount, neededMoney = calculateSumNeededToExchange(neededMoney, sourceCurrency, destCurrency), neededMoney
	end
	
	if (not bankData) then
		outputChatBox("[Банк] Произошла неизвестная ошибка.", client, 255,255,255)
	elseif (not bankData[acc]) then
		outputChatBox("[Банк] Произошла неизвестная ошибка.", client, 255,255,255)
	elseif (not amount) then
		outputChatBox("[Банк] Не введена сумма для передачи.", client, 255,255,255)
	elseif (amount < 0) then
		outputChatBox("[Банк] Пожалуйста, введите положительное число.", client, 255,255,255)
	elseif (not neededMoney) then
		outputChatBox("[Банк] Произошла неизвестная ошибка.", client, 255,255,255)
	elseif (getPlayerBankMoney(client, sourceCurrency) < neededMoney) then
		outputChatBox(getPlayerBankMoney(client, sourceCurrency).." "..neededMoney)
		outputChatBox("[Банк] Недостаточно средств на счету.", client, 255,255,255)
	else
		takePlayerBankMoney(client, neededMoney, sourceCurrency)
		givePlayerBankMoney(client, amount, destCurrency)
		outputChatBox("[Банк] Вы успешно совершили обмен валюты.", client, 255,255,255)
		outputDebugString("[BANK][EXCHANGE] "..getPlayerName(client).." (acc ".. getAccountName(acc).." money "..getPlayerMoney(client)..
			" bank "..getPlayerBankMoney(client, sourceCurrency)..tostring(sourceCurrency)..", "..getPlayerBankMoney(client, destCurrency)..tostring(destCurrency)..
			") exchanged "..tostring(neededMoney)..tostring(sourceCurrency).." to "..tostring(amount)..tostring(destCurrency))
	end
end
addEvent("exchange", true)
addEventHandler("exchange", resourceRoot, exchange)



function calculateSumNeededToExchange(amount, curFrom, curTo)
	if (curFrom ~= "DONATE") then
		return math.ceil(amount * exchangeCourse[curFrom][curTo])
	else
		if (not x2Activated) then
			if (amount < 100) then
				return math.ceil(amount * 1000000)
			elseif (amount < 300) then
				return math.ceil(amount * 1500000)
			elseif (amount < 500) then
				return math.ceil(amount * 2000000)
			else
				return math.ceil(amount * 2500000)
			end
		else
			return math.ceil(amount * 10000)
		end
	end
end

function transfer(money, player)
	if not isElement(client) then 
		return false
	end
	money = tonumber(money)
	money = math.floor(money)

    local receiverAccount = getAccount(player)

	local acc = getPlayerAccount(client)

	if (acc) and not isGuestAccount(acc) then
        if acc == receiverAccount then
            outputChatBox("[Банк] Вы указали свой логин", client, 255, 255, 255)      
            return
        end
    end

    if not (receiverAccount) then
        outputChatBox("[Банк] Такого аккаунта не существует", client, 255, 255, 255)      
        return
    end

    local receiverPlayer = getAccountPlayer(receiverAccount)

    local fines = isResourceRunning("police_ccd") and exports.police_ccd:getPlayerFines(client) or 0
	local fee = calculateFee(getAccountName(acc), getAccountName(receiverAccount), money)

	if (not bankData) then
		outputChatBox("[Банк] Произошла неизвестная ошибка", client, 255,255,255)
	elseif (not bankData[acc]) then
		outputChatBox("[Банк] Произошла неизвестная ошибка", client, 255,255,255)
	elseif (money < 0) then
		outputChatBox("[Банк] Пожалуйста, введите положительное число", client, 255,255,255)
	elseif (getPlayerBankMoney(client) < money + fee) then
		outputChatBox("[Банк] Недостаточно средств на счете", client, 255,255,255)
	elseif (fines > 150000) then
		outputChatBox("[Банк] У вас имеются неоплаченные штрафы", client, 255,255,255)
	elseif isGuestAccount(receiverAccount) then
		outputChatBox("[Банк] Игрок еще не вошёл в свой аккаунт", client, 255,255,255)
	else
		takePlayerBankMoney(client, money + fee)
		giveAccountBankMoney(receiverAccount, money)			
		
		outputChatBox("Вы успешно перевели "..explodeNumber(money).." руб. на счет игрока с логином "..player, client, 255, 255, 255)
        outputDebugString(string.format("[BANK][TRANSFER] %s transferred %i to %s",
            getPlayerName(client), money, getAccountName(receiverAccount)
        ))

		onSuccessfulTransfer(getAccountName(acc), getAccountName(receiverAccount), money, fee)

	    if receiverPlayer then
	        outputChatBox("На твой счет переведены "..explodeNumber(money).." руб. от "..getPlayerNameWoutColor(client), receiverPlayer, 255, 255, 255)
	    end

	    exports['Loger']:printToLog('[БАНК]', string.format('%s (%s) перевёл %s руб на аккаунт с логином (%s)', 
		
				removeHex(getPlayerName(client)), 
				
				getAccountName(getPlayerAccount(client)), 
				
				explodeNumber(money),
				
				getAccountName(receiverAccount)

			) 
		)

		triggerClientEvent(client, "Bank : ClearEditBox", resourceRoot)
	end
end
addEvent("transfer", true)
addEventHandler("transfer", resourceRoot, transfer)

function deposit(money)
	if not isElement(client) then return false end
	local acc = getPlayerAccount(client)
	local fines = isResourceRunning("police_ccd") and exports.police_ccd:getPlayerFines(client) or 0
	if (not bankData) then
		outputChatBox("[Банк] Произошла неизвестная ошибка.", client, 255,255,255)
	elseif (not bankData[acc]) then
		outputChatBox("[Банк] Произошла неизвестная ошибка.", client, 255,255,255)
	elseif (not money) then
		outputChatBox("[Банк] Не введена сумма для снятия.", client, 255,255,255)
	elseif (money < 0) then
		outputChatBox("[Банк] Пожалуйста, введите положительное число.", client, 255,255,255)
	elseif (getPlayerMoney(client) - money < 0) then
		outputChatBox("[Банк] У вас недостаточно наличных.", client, 255,255,255)
	elseif (fines > 150000) then
		outputChatBox("[Банк] У вас имеются неоплаченные штрафы.", client, 255,255,255)
	else
		givePlayerBankMoney(client, money)
		takePlayerMoney(client, money)
		outputDebugString("[BANK][DEPOSIT] "..getPlayerName(client).." (acc ".. getAccountName(acc).." money "..getPlayerMoney(client).." bank "..getPlayerBankMoney(client)..") deposited "..money.." to his account")
		outputChatBox("[Банк] Вы успешно пополнили свой счет на "..explodeNumber(money).." руб.", client, 255,255,255)
	end
end
addEvent("deposit", true)
addEventHandler("deposit", resourceRoot, deposit)

function withdraw(money)
	if not isElement(client) then return false end
	local acc = getPlayerAccount(client)
	if (not bankData) then
		outputChatBox("[Банк] Произошла неизвестная ошибка.", client, 255,255,255)
	elseif (not bankData[acc]) then
		outputChatBox("[Банк] Произошла неизвестная ошибка.", client, 255,255,255)
	elseif (not money) then
		outputChatBox("[Банк] Не введена сумма для снятия.", client, 255,255,255)
	elseif (money < 0) then
		outputChatBox("[Банк] Пожалуйста, введите положительное число.", client, 255,255,255)
	elseif (getPlayerBankMoney(client) < money) then
		outputChatBox("[Банк] Недостаточно средств на счету.", client, 255,255,255)
	elseif (getPlayerMoney(client) + money > 99999999) then
		outputChatBox("[Банк] Вы не сможете иметь такое количество наличных.", client, 255,255,255)
	else
		takePlayerBankMoney(client, money)
		givePlayerMoney(client, money)
		outputDebugString("[BANK][WITHDRAW] "..getPlayerName(client).." (acc ".. getAccountName(acc).." money "..getPlayerMoney(client).." bank "..getPlayerBankMoney(client)..") had withdrawn "..money.." from his account")
		outputChatBox("[Банк] Вы успешно сняли со своего счета "..explodeNumber(money).." руб.", client, 255,255,255)
	end
end
addEvent("withdraw", true)
addEventHandler("withdraw", resourceRoot, withdraw)

function fines()
	if cooldownTest(client) then
		local fines = exports.police_ccd:getPlayerFines(client) or 0
		if (fines <= 0) then
			outputChatBox("[Банк] У вас нет неоплаченных штрафов", client, 255,255,255)
			return
		end
		if (getPlayerMoney(client) >= fines) then
			takePlayerBankMoney(client, fines)
			addPlayerFine(client, -fines)
			outputDebugString("[BANK][PAYFINE] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..", money "..getPlayerMoney(client)..") paid all fines ("..fines..")")
			outputChatBox("[Банк] Все нарушения были оплачены", client, 255,255,255)
		else
			outputChatBox("[Банк] Недостаточно средств на счете", client, 255,255,255)
		end
	end
end
addEvent("fines",true)
addEventHandler("fines", resourceRoot, fines)

function payFines(money)
	if cooldownTest(client) then
		money = tonumber(money)
		if (not money) or (money <= 0) then return end
		money = math.floor(money)
		
		local fines = exports.police_ccd:getPlayerFines(client) or 0
		if (getPlayerBankMoney(client) < money) then
			outputChatBox("[Банк] У вас недостаточно средств для оплаты.", client, 255,255,255)
			return
		end

		takePlayerBankMoney(client, money)
		addPlayerFine(client, -money)

		outputDebugString(string.format("[BANK][PAYFINE] %s (acc %s, money %i) paid some fines (%i). Current fines: %i",
			getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerMoney(client), money, exports.police_ccd:getPlayerFines(client) or 0
		))
		outputChatBox("[Банк] Оплата на сумму "..money.." руб. успешно совершена.", client, 255,255,255)
		triggerClientEvent(client, "Bank : ClearEditBox", resourceRoot)
	end
end
addEvent("payFines",true)
addEventHandler("payFines", resourceRoot, payFines)

local cooldown = {}
function cooldownTest(player)
	if (cooldown[player]) then
		return false
	else
		cooldown[player] = true
		setTimer(resetCooldown, 1000, 1, player)
		return true
	end
end

function resetCooldown(player)
	cooldown[player] = nil
end

function addPlayerFine(player, fine)
	local acc = getPlayerAccount(player)
	local fines = getAccountData(acc, "INF") or 0
	fines = fines + fine
	setElementData(player, "INF", fines)
	setAccountData(acc, "INF", fines)
end

-- ==========     Экспортные функции     ==========
function givePlayerBankMoney(player, amount, currency)
	local acc = getPlayerAccount(player)
	if (not bankData) or (not bankData[acc]) then
		outputDebugString("[BANK][ERROR] Invalid data array on givePlayerBankMoney. bankData: "..tostring(bankData)..", bankData[acc]: "..tostring(bankData[acc])..", player: "..getPlayerName(player), 1)
		return false
	end
	local curMoney = bankData[acc][currency or "RUB"] or 0
	bankData[acc][currency or "RUB"] = curMoney + amount
	triggerClientEvent(player, "catchBankData", resourceRoot, bankData[acc], exchangeCourse, x2Activated)
	saveData(player)
	return true
end

function takePlayerBankMoney(player, amount, currency)
	local acc = getPlayerAccount(player)
	if (not bankData) or (not bankData[acc]) then
		outputDebugString("[BANK][ERROR] Invalid data array on takePlayerBankMoney. bankData: "..tostring(bankData)..", bankData[acc]: "..tostring(bankData[acc])..", player: "..getPlayerName(player), 1)
		return false
	end
	local curMoney = bankData[acc][currency or "RUB"] or 0
	bankData[acc][currency or "RUB"] = curMoney - amount
	triggerClientEvent(player, "catchBankData", resourceRoot, bankData[acc], exchangeCourse, x2Activated)
	saveData(player)
	return true
end

function getPlayerBankMoney(player, currency)
	local acc = getPlayerAccount(player)
	return bankData and bankData[acc] and bankData[acc][currency or "RUB"] or 0
end

function giveAccountBankMoney(account, amount, currency)
	local player = getAccountPlayer(account)
	if (player) then
		givePlayerBankMoney(player, amount, currency)
		return true
	else
		local data = loadData(account)
		local curMoney = data[currency or "RUB"] or 0
		data[currency or "RUB"] = curMoney + amount
		saveData(false, data)
		return true
	end
end

function takeAccountBankMoney(account, amount, currency)
	local player = getAccountPlayer(account)
	if (player) then
		takePlayerBankMoney(player, amount, currency)
	else
		local data = loadData(account)
		local curMoney = data[currency or "RUB"] or 0
		data[currency or "RUB"] = curMoney - amount
		saveData(false, data)
	end
end

function getAccountBankMoney(account, currency)
	local player = getAccountPlayer(account)
	if (player) then
		return getPlayerBankMoney(player, currency)
	else
		local data = loadData(account)
		return data[currency or "RUB"] or 0
	end
end

function convertCurrency(amount, curFrom, curTo)
	curFrom = curFrom or "RUB"
	curTo = curTo or "RUB"
	return amount/exchangeCourse[curFrom][curTo]
end

-- ==========     Передача банковских данных игроку     ==========
function returnBankData()
	local acc = getPlayerAccount(client)
	triggerClientEvent(client, "catchBankData", resourceRoot, bankData[acc], exchangeCourse, x2Activated)
end
addEvent("giveBankData", true)
addEventHandler("giveBankData", resourceRoot, returnBankData)

-- ==========     Сохранение и загрузка банковских данных     ==========
function loadData(account)
	local bdData = getAccountData(account, "bank")
	
	local oldData = getAccountData(account, "bank.balance")
	if oldData then
		setAccountData(account, "bank.balance", oldData)
		setAccountData(account, "bank.balance", false)
	end
	if (not bdData) then
		if oldData then
			bdData = toJSON({RUB = tonumber(oldData)}, true)
		else
			bdData = toJSON({}, true)
		end
		setAccountData(account, "bank", bdData)
	end
	
	bdData = fromJSON(bdData)
	bdData.acc = account
	bdData.accName = getAccountName(account)
	bdData.RUB = bdData.RUB and tonumber(bdData.RUB)
	return bdData
end

function saveData(player, data)
	local account = (data and data.acc) or getPlayerAccount(player)
	data = data or bankData[account]
	if (data) then
		local temp1, temp2 = data.acc, data.accName
		data.acc, data.accName = nil, nil
		setAccountData(account, "bank", toJSON(data, true))
		data.acc, data.accName = temp1, temp2
	end
end

-- ==========     Обработка сохранения и загрузки данных     ==========
function onLogin(_, theCurrentAccount)
	local bdData = loadData(theCurrentAccount)
	bankData[theCurrentAccount] = bdData
	triggerClientEvent(source, "catchBankData", resourceRoot, bdData, exchangeCourse, x2Activated)
	outputDebugString(string.format("[BANK][LOGIN] %s (acc %s) bank money: %i RUB, %i USD, %i EUR, %i DONATE",
		getPlayerName(source), getAccountName(theCurrentAccount), (bdData.RUB or 0), (bdData.USD or 0), (bdData.EUR or 0), (bdData.DONATE or 0)
	))
end
addEventHandler("onPlayerLogin", root, onLogin)

addEventHandler("onResourceStart", resourceRoot, function()
	for _, player in ipairs(getElementsByType("player")) do
		local acc = getPlayerAccount(player)
		if not isGuestAccount(acc) then
			bankData[acc] = loadData(acc)
		end
	end
end)

function onQuit()
	saveData(source)
	bankData[ getPlayerAccount(source) ] = nil
end
addEventHandler("onPlayerQuit", root, onQuit)


-- ==========     Показ инфы о состоянии счетов     ==========
addCommandHandler("bank", function(playerSource, _, ...)
	local args = {...}
	if (args[1]) then
		local input = table.concat(args, " ")
		local player = findPlayerByName(input)
		local playerAccount = player and getPlayerAccount(player)
		if (playerAccount) then
			local playerName = getPlayerName(player)
			local playerNameNoColor = getPlayerNameWoutColor(player)
			local accName = getAccountName(playerAccount)
			outputChatBox(string.format("[Банк] Счет игрока %s (%s, acc %s): %s. На руках %s руб.", playerNameNoColor, playerName, accName, getMoneyString(playerAccount), getPlayerMoney(player)),
				playerSource, 50,255,100, false)
		end
		local account = findAccountByName(input)
		if (account) then
			local accName = getAccountName(account)
			outputChatBox(string.format("[Банк] Счет аккаунта %s: %s. На руках %s руб.", accName, getMoneyString(account), (getAccountData(account, "money") or 0)),
				playerSource, 50,255,100, false)
		end
		if (not playerAccount) and (not account) then
			outputChatBox("Ни игрок, ни аккаунт такой не найден!", playerSource, 255,50,50)
		end
	end
end, true, false)

function getMoneyString(account)
	local data = loadData(account)
	return string.format("%i RUB, %i USD, %i EUR, %i DONATE", (data.RUB or 0), (data.USD or 0), (data.EUR or 0), (data.DONATE or 0))
end

function findPlayerByName(name)
	local player = getPlayerFromName(name)
	if (player) then
		return player
	end
	local playersTable = getElementsByType("player")
	for _, player in ipairs(playersTable) do
		local playerName = getPlayerName(player)
		if string.find(playerName, name, 1, true) then
			return player
		end
	end
	local lowerName = name:lower()
	for _, player in ipairs(playersTable) do
		local lowerPlayerName = getPlayerName(player):lower()
		if string.find(lowerPlayerName, lowerName, 1, true) then
			return player
		end
	end
	for _, player in ipairs(playersTable) do
		local playerName = getPlayerName(player):gsub('#%x%x%x%x%x%x', ''):lower()
		if string.find(playerName, lowerName, 1, true) then
			return player
		end
	end
	return false
end

function findAccountByName(name)
	local account = getAccount(name)
	if (account) then
		return account
	end
	local accountsTable = getAccounts()
	for _, account in ipairs(accountsTable) do
		local accName = getAccountName(account)
		if utf8.find(accName, name, 1, true) then
			return account
		end
	end
	local lowerName = utf8.lower(name)
	for _, account in ipairs(accountsTable) do
		local accName = utf8.lower(getAccountName(account))
		if utf8.find(accName, lowerName, 1, true) then
			return account
		end
	end
	return false
end


-- ==========     Вспомогательные функции     ==========
function explodeNumber(number)
	number = tostring(number)
	local k
	repeat
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
	until (k==0)	-- true - выход из цикла
	return number
end

function getPlayerNameWoutColor(player)
	return string.gsub(getPlayerName(player), '#%x%x%x%x%x%x', '')
end

-- ==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end
