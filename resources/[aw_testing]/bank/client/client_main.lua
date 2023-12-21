
local bankData = nil
exchangeCourse = nil
x2Activated = nil

-- ==========     Функции банка     ==========
function exchange(amount, sourceCurrency, destCurrency)
	local neededMoney
	if (sourceCurrency ~= "DONATE") then
		neededMoney = calculateSumNeededToExchange(amount, sourceCurrency, destCurrency)
	else
		amount, neededMoney = calculateSumNeededToExchange(amount, sourceCurrency, destCurrency), amount
	end
	if (not bankData) then
		return false, "\nПроизошла неизвестная ошибка.", "\nКод ошибки: #40"
	elseif (not amount) then
		return false, "\nНе введена сумма для передачи.", "\nКод ошибки: #41"
	elseif (amount < 0) then
		return false, "\nПожалуйста, введите положительное число.", "\nКод ошибки: #42"
	elseif (not neededMoney) then
		return false, "\nПроизошла неизвестная ошибка.", "\nКод ошибки: #43"
	elseif (getPlayerBankMoney(sourceCurrency) < neededMoney) then
		return false, "\nНедостаточно средств на счете.", "\nКод ошибки: #44"
	else
		triggerServerEvent("exchange", resourceRoot, amount, neededMoney, sourceCurrency, destCurrency)
		return true
	end
end

function transfer(money, player)
	if (not bankData) then
		return false, "\nПроизошла неизвестная ошибка.", "\nКод ошибки: #13"
	elseif (not money) then
		return false, "\nНе введена сумма для передачи.", "\nКод ошибки: #15"
	elseif (money < 0) then
		return false, "\nПожалуйста, введите положительное число.", "\nКод ошибки: #16"
	elseif (getPlayerBankMoney() < money) then
		return false, "\nНедостаточно средств на счете.", "\nКод ошибки: #17"
	elseif (not player) then
		return false, "\nНе выбран игрок.", "\nКод ошибки: #18"
	elseif (not isElement(player)) then
		return false, "\nИгрок вышел с сервера.", "\nКод ошибки: #19"
	else
		triggerServerEvent("transfer", resourceRoot, money, player)
		return true
	end
end

function deposit(money)
	if (not bankData) then
		return false, "\nПроизошла неизвестная ошибка.", "\nКод ошибки: #7"
	elseif (not money) then
		return false, "\nНе введена сумма для снятия.", "\nКод ошибки: #9"
	elseif (money < 0) then
		return false, "\nПожалуйста, введите положительное число.", "\nКод ошибки: #10"
	elseif (getPlayerMoney() - money < 0) then
		return false, "\nУ вас недостаточно наличных.", "\nКод ошибки: #11"
	else
		triggerServerEvent("deposit", resourceRoot, money)
		return true
	end
end

function withdraw(money)
	if (not bankData) then
		return false, "\nПроизошла неизвестная ошибка.", "\nКод ошибки: #1"
	elseif (not money) then
		return false, "\nНе введена сумма для снятия.", "\nКод ошибки: #3"
	elseif (money < 0) then
		return false, "\nПожалуйста, введите положительное число.", "\nКод ошибки: #6"
	elseif (getPlayerBankMoney() < money) then
		return false, "\nНедостаточно средств на счете.", "\nКод ошибки: #4"
	elseif (getPlayerMoney() + money > 99999999) then
		return false, "\nВы не сможете иметь такое количество наличных.", "\nКод ошибки: #5"
	else
		triggerServerEvent("withdraw", resourceRoot, money)
		return true
	end
end

function fines(money)
	if (not bankData) then
		return false, "\nПроизошла неизвестная ошибка.", "\nКод ошибки: #1"
	elseif (getPlayerBankMoney() < money) then
		return false, "\nНедостаточно средств на счете.", "\nКод ошибки: #4"
	else
		triggerServerEvent("fines", resourceRoot, money)
		return true
	end
end

function showError(text1, text2)
	showErrorFromServer(text1, text2)
end
addEvent("showError", true)
addEventHandler("showError", resourceRoot, showError)

function showInterestMessage(data)
	local tempString = ""
	if (data.RUB > 0) then
		tempString = data.RUB.."$"
	end
	if (data.USD > 0) then
		if (tempString ~= "") then
			tempString = tempString..", "..data.USD.."$"
		else
			tempString = data.USD.."$"
		end
	end
	if (data.EUR > 0) then
		if (tempString ~= "") then
			tempString = tempString..", "..data.EUR.."€"
		else
			tempString = data.EUR.."€"
		end
	end
	outputChatBox("[Банк] На ваши счета поступили "..tempString.." в качестве процентов по вашим счетам. Спасибо за использование нашего банка!", 50,255,50)
end
addEvent("showInterestMessage", true)
addEventHandler("showInterestMessage", resourceRoot, showInterestMessage)






-- ==========     Экспортные функции     ==========
function getPlayerBankMoney(currency)
	return bankData and bankData[currency or "RUB"] or 0
end

function convertCurrency(amount, curFrom, curTo)
	curFrom = curFrom or "RUB"
	curTo = curTo or "RUB"
	return amount/exchangeCourse[curFrom][curTo]
end

-- ==========     Вспомогательные функции     ==========
function calculateSumNeededToExchange(amount, curFrom, curTo)
	amount = tonumber(amount)
	if (curFrom ~= "DONATE") then
		return math.ceil(amount * exchangeCourse[curFrom][curTo])
	else
		if (amount < 100) then
			return math.ceil(amount * 1000000)
		elseif (amount < 300) then
			return math.ceil(amount * 1500000)
		elseif (amount < 500) then
			return math.ceil(amount * 2000000)
		else
			return math.ceil(amount * 2500000)
		end
	end
end

function explodeNumber(number)
	number = tostring(number)
	local k
	repeat
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
	until (k==0)	-- true - выход из цикла
	return number
end

-- ==========     Получение инфы при старте ресурса     ==========
addEventHandler("onClientResourceStart", resourceRoot, function()
	triggerServerEvent("giveBankData", resourceRoot)
end)

local onLoginMessageShown = false

function catchBankData(data, course, x2)
	bankData = data
	exchangeCourse = course
	x2Activated = x2
	if (not onLoginMessageShown) and (data) then
		showBankInfo()
		onLoginMessageShown = true
	end
end
addEvent("catchBankData", true)
addEventHandler("catchBankData", resourceRoot, catchBankData)

-- ==========     Показ инфы о состоянии счетов     ==========
function showBankInfo()
	if (bankData) then
		local data = bankData
		if (data.RUB and (data.RUB > 0)) or (data.USD and (data.USD > 0)) or (data.EUR and (data.EUR > 0)) or (data.DONATE and (data.DONATE > 0)) then
			local moneyText = ""
			if data.RUB and (data.RUB > 0) then
				moneyText = explodeNumber(data.RUB).." долларов"
			end
			if data.DONATE and (data.DONATE > 0) then
				if (moneyText ~= "") then moneyText = moneyText..", " end
				moneyText = moneyText..explodeNumber(data.DONATE).." донат-единиц"
			end
			outputChatBox("[Банк] На вашем банковском счету: "..moneyText..".", 255,255,255,true)
		else
			outputChatBox("[Банк] На вашем банковском счету: $ 0.", 255,255,255,true)
		end
	end
end

addCommandHandler("bank", function(_, arg1)
	if (not arg1) then
		showBankInfo()
	end
end, false)
