
function convertPlateIDtoLicensep(plateID)
	if (not plateID) then return "" end
	local licensep
	local test = string.sub(plateID, 1, 1)
	if (test == "a") then
		licensep = "|"..utf8.upper(strRep(string.sub(plateID, 3, 8))).."|"..string.sub(plateID, 9, 11).."|"
	elseif (test == "b") then
		licensep = "|"..utf8.upper(strRep(string.sub(plateID, 3, 7))).."|"..string.sub(plateID, 8, 10).."|"
	elseif (test == "c") then
		licensep = "|"..string.sub(plateID, 3, 6).."|"..utf8.upper(strRep(string.sub(plateID, 7, 8))).."|"..string.sub(plateID, 9, 10).."|"
	elseif (test == "d") then
		licensep = "|"..string.sub(plateID, 3, 6).."|"..utf8.upper(strRep(string.sub(plateID, 7, 7))).."|"..string.sub(plateID, 8, 9).."|"
	elseif (test == "e") then
		licensep = "|"..utf8.upper(strRep(string.sub(plateID, 3, 8))).."|"..string.sub(plateID, 9, 10).."|"
	elseif (test == "f") then
		licensep = "|"..string.sub(plateID, 3, 4).."|"..string.sub(plateID, 5, 8)..""..string.sub(plateID, 9, 10).."|"
	elseif (test == "g") then
		licensep = "|"..string.sub(plateID, 3, 6).."|"..string.sub(plateID, 7, 8).."-"..string.sub(plateID, 9, 9).."|"
	elseif (test == "h") then
		licensep = "|"..string.sub(plateID, 3, string.len(plateID)).."|"
	elseif (test == "o") then
		licensep = "|"..string.sub(plateID, 3, string.len(plateID)).."|"
	elseif (test == "i") then
		licensep = "|"..utf8.upper(strRep(string.sub(plateID, 3, 7))).."|"..string.sub(plateID, 8, 9).."|"
	elseif (test == "j") then
		licensep = "|"..strRep(string.sub(plateID, 3, 8)).."|"
	elseif (test == "m") then
		licensep = "|"..strRep(string.sub(plateID, 3, 8)).."|"..string.sub(plateID, 9, 11).."|"
	elseif (test == "k") then
		licensep = "|"..strRep(string.sub(plateID, 3, 8)).."|"..string.sub(plateID, 9, 10).."|"
	elseif (test == "l") then
		licensep = "|"..strRep(string.sub(plateID, 3, 9)).."|"..string.sub(plateID, 10, 12).."|"
	else
		return ""
	end
	return licensep
end

function strRep(str)
	str = string.gsub(str, "b", "в")
	str = string.gsub(str, "k", "к")
	str = string.gsub(str, "m", "м")
	str = string.gsub(str, "h", "н")
	str = string.gsub(str, "t", "т")
	return str
end

function getAllSellingPrices(model)
	if isResourceRunning("bank") then
		local price, currency = getCarPrice(model)
		local realPrice = exports.bank:convertCurrency(price, currency)
		realPrice = math.floor(realPrice/1000)*1000		-- Округляем до тысяч
		
		local defaultPrice = math.floor(realPrice*0.55)
		local minSellPrice = math.floor(realPrice*0.2)
		local maxSellPrice = math.floor(realPrice*0.7)
		
		return realPrice, defaultPrice, minSellPrice, maxSellPrice
	else
		return false
	end
end

blackListModel = { --Таблица ТС для которых запрещена замена номеров на ЕКХ - [ID] = true,
	[493] = true, 
	[454] = true, 
	[453] = true, 
	[446] = true, 
	[472] = true, 
	[595] = true, 
	[473] = true, 
	[563] = true, 
	[487] = true, 
	[469] = true, 
	[417] = true, 
}

deniedSellCar = { --Таблица ТС которые нельзя продавать на БУ - [ID] = true,
	[412] = true,
}

numbers = {
	["0"] = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
	["6"] = true,
	["7"] = true,
	["8"] = true,
	["9"] = true,
}