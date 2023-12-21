
Config = {
	minDepositPeriod = 7,
	maxDepositPeriod = 31,			-- Заменяется потом на число дней в месяце
	
	depositsLimit = 1000*1000 * 100,	-- Сумма, с которой раньше набегало 500к в день
	depositsCountLimit = 10,		-- Максимальное число вкладов
	
	depositPercentWeekly = 7.00,	-- Процент в неделю
	depositPercentWeeklyLower = 4.00,	-- Нижняя величина процента
	
	depositClosingPenalty = 20.00,	-- Штраф за досрочное закрытие
	
	payoutPortion = 100,			-- Размер порции для выплаты
}

function getDepositPercentValue(depositPeriod)
	local value = map(depositPeriod, Config.minDepositPeriod, Config.maxDepositPeriod, Config.depositPercentWeeklyLower, Config.depositPercentWeekly)
	return tonumber(string.format("%.2f", value))
end

currencyTable = {
	RUB = "руб.",	-- "₽"
	USD = "$",
	EUR = "€",
	DONATE = "ед. донат-валюты",
}

function getCurrencySymbol(currency)
	return currencyTable[currency] or ""
end

-- Определение количества дней в месяце
local daysInMonths = {
	31, -- январь
	28, -- февраль
	31, -- март
	30, -- апрель
	31, -- май
	30, -- июнь
	31, -- июль
	31, -- август
	30, -- сентябрь
	31, -- октябрь
	30, -- ноябрь
	31, -- декабрь
}
function getDaysInMonth(month, year)
	if (month ~= 2) then
		return daysInMonths[month]
	else
		if (year % 4 == 0) then
			if (year % 100 == 0) then
				if (year % 400 == 0) then
					return 29
				end
				return 28
			end
			return 29
		end
		return 28
	end
end


-- Информационные сообщения
if (localPlayer) then
	function outputBankMessage(text)
		outputChatBox(""..text, 50,255,50, true)
	end
else
	function outputBankMessage(text, player)
		outputChatBox(""..text, player, 50,255,50, true)
	end
end

-- Сообщения об ошибках
if (localPlayer) then
	function outputBadMessage(text)
		outputChatBox(""..text, 50,255,50, true)
	end
else
	function outputBadMessage(text, player)
		outputChatBox(""..text, player, 50,255,50, true)
	end
end

-- Разделение числа на разряды
function explodeNumber(number)
	number = tostring(number)
	local k
	repeat
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
	until (k==0)	-- true - выход из цикла
	return number
end

-- Усечение числа в заданных границах
function math.clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
end

-- Функция пропорционально переносит значение (value) из текущего диапазона значений (fromLow .. fromHigh) в новый диапазон (toLow .. toHigh), заданный параметрами.
function map(value, fromLow, fromHigh, toLow, toHigh)
	return (value-fromLow) * (toHigh-toLow) / (fromHigh-fromLow) + toLow
end
