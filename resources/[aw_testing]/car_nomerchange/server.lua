
function onStart()
	for _, player in ipairs(getElementsByType("player")) do
		if isAdmin(player) then
			setElementData(player, "function.nomerChange", true)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, onStart)

function onLogin(thePreviousAccount, theCurrentAccount, autoLogin)
	if isAdmin(source) then
		setElementData(source, "function.nomerChange", true)
	end
end
addEventHandler("onPlayerLogin", root, onLogin)

local bikes = {
	["Bike"] = true,
	["BMX"] = true,
	["Quad"] = true,
}
local notBikes = {
	["Automobile"] = true,
	["Trailer"] = true,
	["Monster Truck"] = true,
}
function isBikeType(vehType)
	return bikes[vehType]
end
function isAutomobileType(vehType)
	return notBikes[vehType]
end

function applyNomerFromInput(newNomer, moneyType)
	if (string.sub(newNomer, 1, 1) == "h") then
		orderLicensep(newNomer, moneyType, client)
		return
	end

	local vehicle = getPedOccupiedVehicle(client)
	if not vehicle then return end
	
	if (string.sub(newNomer, 1, 1) == "c") then
		if not isBikeType(getVehicleType(vehicle)) then
			outputBadMessage("Вы не можете поставить номер мотоцикла на другой транспорт.", client)
			return
		end
	else
		if not isAutomobileType(getVehicleType(vehicle)) then
			outputBadMessage("Вы не можете поставить автомобильный номер на данный транспорт.", client)
			return
		end
	end
	
	local oldNomer = getElementData(vehicle, "licensep")
	if not oldNomer then return end
	if (oldNomer:sub(1, 1) == "b") then
		outputBadMessage("Вы не можете изменить номер на полицейском автомобиле.", client)
		return
	end
	
	local filtersText, canBeBought, donatePriceText, donatSum, priceText, price = getNomerTypeAndCost(newNomer, oldNomer)
	if (not canBeBought) then
		outputBadMessage("Вы не можете поставить этот номер. Он не доступен за игровые деньги.", client)
		return
	end
	if existsNomer(newNomer) then
		outputBadMessage("Этот номер уже занят, попробуйте другой", client)
		return
	end
	local accName = getAccountName(getPlayerAccount(client))
	local vehOwner = getElementData(vehicle, "owner")
	if (accName ~= vehOwner) then
		outputBadMessage("Вы не можете поменять номер. Это не ваша машина.", client)
		return
	end
	local ID = getElementData(vehicle, "ID")
	if (not ID) then
		outputBadMessage("Вы не можете поменять номер. Это не личная машина.", client)
		return
	end
	local donatUsed = false
	if (moneyType == "DONATE") and (isResourceRunning("bank")) then
		if (not donatSum) then
			outputBadMessage("Невозможно поставить номер. Ошибка в стоимости номера.", client)
			return
		end	
		if (exports.bank:getPlayerBankMoney(client, "DONATE") < donatSum) then
			outputBadMessage("Невозможно поставить номер. У вас недостаточно средств. Стоимость: "..explodeNumber(donatSum).." ед.", client)
			return
		end	
		exports.bank:takePlayerBankMoney(client, donatSum, "DONATE")
		donatUsed = true
	else
		if (not price) then
			outputBadMessage("Невозможно поставить номер. Ошибка в стоимости номера.", client)
			return
		end	
		if (getPlayerMoney(client) < price) then
			outputBadMessage("Невозможно поставить номер. У вас недостаточно средств. Стоимость: "..explodeNumber(price).." рублей.", client)
			return
		end	
		takePlayerMoney(client, price)
	end
	exports.car_system:changeNomer(ID, newNomer, client)
	setElementData(vehicle, "licensep", newNomer)
	outputMessage("Вы успешно сменили номер!", client)
	triggerClientEvent(client, "closePanel", resourceRoot)
	outputDebugString("[CAR-NMRCHNG] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..", money "..getPlayerMoney(client)..
		") applied numberplate "..newNomer.." (old "..oldNomer..") to his "..exports.car_system:getVehicleModName(vehicle).." ("..getElementModel(vehicle)..") for "..(donatUsed and tostring(donatSum).."DONATE" or tostring(price)))
	triggerClientEvent("playWrenchSound", resourceRoot, getElementPosition(client))
end
addEvent("applyFromInput", true)
addEventHandler("applyFromInput", resourceRoot, applyNomerFromInput)

function applyAdminNomer(newNomer)
	if not isAdmin(client) then
		outputDebugString(string.format("[CAR-NMRCHNG][CHEAT] %s (acc %s IP %s serial %s) tried to set admin licensep (%s)",
			getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerIP(client), getPlayerSerial(client), tostring(newNomer)), 1)
		return
	end
	local vehicle = getPedOccupiedVehicle(client)
	if not vehicle then return end
	local oldNomer = getElementData(vehicle, "licensep")
	if not oldNomer then return end
	if existsNomer(newNomer) then
		outputBadMessage("Этот номер уже был занят, установлен принудительно", client)
	end
	local accName = getAccountName(getPlayerAccount(client))
	local vehOwner = getElementData(vehicle, "owner")
	if accName ~= vehOwner then
		outputBadMessage("Предупреждение: это не ваша машина.", client)
	end
	local ID = getElementData(vehicle, "ID")
	if not ID then
		outputBadMessage("Невозможно поменять номер. Это не личная машина.", client)
		return
	end
	exports.car_system:changeNomer(ID, newNomer, getAccountPlayer(getAccount(vehOwner)))
	setElementData(vehicle, "licensep", newNomer)
	outputMessage("Вы успешно сменили номер!", client)
	triggerClientEvent(client, "closePanel", resourceRoot)
	outputDebugString("[CAR-NMRCHNG][ADMIN] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..", money "..getPlayerMoney(client)..
		") applied numberplate "..newNomer.." (old "..oldNomer..") to "..exports.car_system:getVehicleModName(vehicle).." ("..getElementModel(vehicle)..", owner "..vehOwner..")")
	triggerClientEvent("playWrenchSound", resourceRoot, getElementPosition(client))
end
addEvent("ApplyAdminNomer", true)
addEventHandler("ApplyAdminNomer", resourceRoot, applyAdminNomer)

function applyDonatesNomer(newNomer, money)
	local vehicle = getPedOccupiedVehicle(client)
	if not vehicle then return end
	local oldNomer = getElementData(vehicle, "licensep")
	if not oldNomer then return end
	if existsNomer(newNomer) then
		outputBadMessage("[Донат номера] Этот номер уже занят!", client)
		return
	end
	local accName = getAccountName(getPlayerAccount(client))
	local vehOwner = getElementData(vehicle, "owner")
	if accName ~= vehOwner then
		    outputBadMessage("[Донат номера] Это не ваша машина.", client)
		return
	end
	local ID = getElementData(vehicle, "ID")
	if not ID then
		outputBadMessage("[Донат номера] Невозможно поменять номер. Это не личная машина.", client)
		return
	end
	exports.car_system:changeNomer(ID, newNomer, getAccountPlayer(getAccount(vehOwner)))
	setElementData(vehicle, "licensep", newNomer)
	outputMessage("[Донат номера] Вы успешно сменили номер!", client)
	triggerClientEvent(client, "closePanel", resourceRoot)
	--
	exports.bank:takePlayerBankMoney(client, money, "DONATE")
	--
	outputDebugString("[CAR-NMRCHNG][ADMIN] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..", money "..getPlayerMoney(client)..
		") applied numberplate "..newNomer.." (old "..oldNomer..") to "..exports.car_system:getVehicleModName(vehicle).." ("..getElementModel(vehicle)..", owner "..vehOwner..")")
	triggerClientEvent("playWrenchSound", resourceRoot, getElementPosition(client))
end
addEvent("applyDonatesNomer", true)
addEventHandler("applyDonatesNomer", resourceRoot, applyDonatesNomer)

function outputMessage(text, player)
	outputChatBox("[Смена номера] #32FF32"..text, player, 255, 255, 255, true)
end

function outputBadMessage(text, player)
	outputChatBox("[Смена номера] #FF3232"..text, player, 255, 255, 255, true)
end

-- ==================     Получение информации о номере     ==================
function getInfoAboutNomer(fullNomer)
	local filtersText, canBeBought, donatePriceText, donatSum, priceText, price = getNomerTypeAndCost(fullNomer)
	local bankMoney = isResourceRunning("bank") and exports.bank:getPlayerBankMoney(client, "DONATE") or 0
	local isExist = existsNomer(fullNomer)
	triggerClientEvent(client, "takeInputInfo", resourceRoot, fullNomer, filtersText, priceText, donatePriceText, (canBeBought and not isExist), price, donatSum, bankMoney)
end
addEvent("getInputInfo", true)
addEventHandler("getInputInfo", resourceRoot, getInfoAboutNomer)

function getAdminInfo(fullNomer)
	local filtersText, canBeBought, donatePriceText, donatSum, priceText, price = getNomerTypeAndCost(fullNomer)
	local bankMoney = isResourceRunning("bank") and exports.bank:getPlayerBankMoney(client, "DONATE") or 0
	local exists, data = existsNomer(fullNomer)
	if exists then
		triggerClientEvent(client, "printAdminInfo", resourceRoot, fullNomer, data)
	end
	triggerClientEvent(client, "takeInputInfo", resourceRoot, fullNomer, filtersText, priceText, donatePriceText, (canBeBought and not isExist), price, donatSum, bankMoney)
end
addEvent("GetAdminInfo", true)
addEventHandler("GetAdminInfo", resourceRoot, getAdminInfo)

function getNomerTypeAndCost(newNomer)
	local filter = {}
	local prices = {}
	local donatePrices = {}
	local canBeBought = true
	local nomerType = string.sub(newNomer, 1, 1)
	
	if (nomerType == "a") then
		local bukv, cifr, region = {}, {}
		bukv[1], bukv[2], bukv[3], cifr[1], cifr[2], cifr[3], region = convertRusNomerToElements(newNomer)
	
		if (newNomer == "a-x777xx777") then																-- Уникальные
			table.insert(filter, "|х777хх|777|")
			table.insert(donatePrices, 500)
		elseif (bukv[1] == bukv[2]) and (bukv[2] == bukv[3]) and (cifr[1] == cifr[2]) and (cifr[2] == cifr[3]) then
			table.insert(filter, "|zYYYzz|**| (все повторяющиеся буквы И цифры)")
			table.insert(prices, 4500000)
			table.insert(donatePrices, 100)
		elseif (bukv[1] == "p") and (bukv[2] == "h") and (bukv[3] == "a") and (region == 97) then
			table.insert(filter, "|р***на|97|")
			canBeBought = false
		else
			if (bukv[1] == "a") and (bukv[2] == "m") and (bukv[3] == "p") and (region == 77) then		-- Правила букв
				table.insert(filter, "|a***мр|97|")
				table.insert(prices, 3100000)
				table.insert(donatePrices, 120)
			elseif (bukv[1] == "a") and (bukv[2] == "m") and (bukv[3] == "p") and (region == 97) then
				table.insert(filter, "|a***мр|77|")
				table.insert(prices, 3100000)
				table.insert(donatePrices, 130)
			elseif (bukv[1] == bukv[2]) and (bukv[2] == bukv[3]) then
				table.insert(filter, "|z***zz|**| (любые ТРИ повторяющиеся буквы)")
				table.insert(prices, 1950000)
				table.insert(donatePrices, 80)	
			elseif (bukv[1] == "e") and (bukv[2] == "k") and (bukv[3] == "x") then
				table.insert(filter, "|е***кх|**|")
				table.insert(prices, 2900000)
				table.insert(donatePrices, 120)
			elseif (bukv[1] == "b") and (bukv[2] == "o") and (bukv[3] == "p") then
				table.insert(filter, "|в***ор|**|")
				table.insert(prices, 2990000)
				table.insert(donatePrices, 110)
			elseif (bukv[1] == "x") and (bukv[2] == "a") and (bukv[3] == "m") then
				table.insert(filter, "|х***ам|**|")
				table.insert(prices, 3000000)
				table.insert(donatePrices, 110)
			end
			if (cifr[1] == cifr[2]) and (cifr[2] == cifr[3]) then										-- Правила цифр
				table.insert(filter, "|*YYY**|**| (любые ТРИ повторяющиеся цифры)")
				table.insert(prices, 2100000)
				table.insert(donatePrices, 70)
			elseif (cifr[1] == cifr[2]) or (cifr[1] == cifr[3]) or (cifr[2] == cifr[3]) then
				table.insert(filter, "|*YYG**|**| (любые ДВЕ повторяющиеся цифры)")
				table.insert(prices, 1200000)
				table.insert(donatePrices, 100)
			end
		end
		if (#filter == 0) then
			table.insert(filter, "обычный номер")
			table.insert(prices, 289000)
		end
	
	
	elseif (nomerType == "b") then
		table.insert(filter, "номер полиции")
		canBeBought = false
		
	elseif (nomerType == "c") then
		table.insert(filter, "мотоциклетный номер")
		table.insert(prices, 300000)
	
	elseif (nomerType == "d") then
		table.insert(filter, "номер полицейского мотоцикла")
		canBeBought = false
	
	elseif (nomerType == "e") then
		local n1, n2, n3, b1, b2, b3 = string.sub(newNomer, 3, 3), string.sub(newNomer, 4, 4), string.sub(newNomer, 5, 5), string.sub(newNomer, 6, 6), string.sub(newNomer, 7, 7), string.sub(newNomer, 8, 8)
		if (n1==n2 and n2==n3) or (b1==b2 and b2==b3) then
			table.insert(filter, "номер Казахстана (3 одинаковых символа)")
			table.insert(prices, 2100000)
			table.insert(donatePrices, 100)
		else
			table.insert(filter, "номер Казахстана")
			table.insert(prices, 240000)
			table.insert(donatePrices, 20)
		end
		
	elseif (nomerType == "f") then
		local b1, b2, n1, n2, n3, n4, b3, b4 = string.sub(newNomer, 3, 3), string.sub(newNomer, 4, 4), string.sub(newNomer, 5, 5), string.sub(newNomer, 6, 6), string.sub(newNomer, 7, 7), string.sub(newNomer, 8, 8), string.sub(newNomer, 9, 9), string.sub(newNomer, 10, 10)
		if ((b1..b2 == "AA") or (b1..b2 == "II")) and ((b3..b4 == "BC") or (b3..b4 == "KA") or (b3..b4 == "KI") or (b3..b4 == "KM") or (b3..b4 == "KC") or (b3..b4 == "BP")) then
			table.insert(filter, "номер Украины (специальный)")
			table.insert(donatePrices, 50)
		elseif (n1==n2 and n2==n3 and n3==n4) then
			table.insert(filter, "номер Украины (4 одинаковые цифры)")
			table.insert(prices, 3200000)
			table.insert(donatePrices, 90)
		elseif (n1==n2 and n2==n3) or (n1==n2 and n2==n4) or (n1==n3 and n3==n4) or (n2==n3 and n3==n4) then
			table.insert(filter, "номер Украины (3 повторяющиеся цифры)")
			table.insert(prices, 2400000)
			table.insert(donatePrices, 80)
		else
			table.insert(filter, "номер Украины")
			table.insert(prices, 320000)
			table.insert(donatePrices, 30)
		end
		
	elseif (nomerType == "g") then
		local n1, n2, n3, n4 = string.sub(newNomer, 3, 3), string.sub(newNomer, 4, 4), string.sub(newNomer, 5, 5), string.sub(newNomer, 6, 6)
		if (n1==n2 and n2==n3 and n3==n4) then
			table.insert(filter, "номер Белоруссии (4 одинаковые цифры)")
			table.insert(prices, 2700000)	
			table.insert(donatePrices, 70)		
		elseif (n1==n2 and n2==n3) or (n1==n2 and n2==n4) or (n1==n3 and n3==n4) or (n2==n3 and n3==n4) then
			table.insert(filter, "номер Белоруссии (3 одинаковые цифры)")
			table.insert(prices, 2100000)	
			table.insert(donatePrices, 50)		
		else
			table.insert(filter, "номер Белоруссии")
			table.insert(prices, 175000)
			table.insert(donatePrices, 20)
		end
		
	elseif (nomerType == "h") then
		table.insert(filter, "надпись")
		table.insert(donatePrices, 200)
	end
	
	local filtersText, donatePriceText, priceText, donatSum, sum = "", "", "", 0, false
	filtersText = table.concat(filter, ",\n")
	filtersText = string.format("Шаблон%s номера:\n", ((#filtersText > 1) and "ы" or ""), filtersText)
	if (canBeBought) then
		donatePriceText = table.concat(donatePrices, " + ")
		for _, row in ipairs(donatePrices) do
			donatSum = donatSum + row
		end
		if (donatSum == 0) then
			donatSum = false
		end
		donatePriceText = donatSum and string.format("За донат-валюту: %s = %s ед.\n", donatePriceText, explodeNumber(donatSum)) or ""
		
		for _, row in ipairs(prices) do
			if (not sum) or (sum < row) then
				sum = row
			end
		end
		priceText = sum and string.format("За игровую валюту: %s руб.\n", explodeNumber(sum)) or ""
	end
	return filtersText, canBeBought, donatePriceText, donatSum, priceText, sum
end

function convertRusNomerToElements(nomer)
	local b1 = string.sub(nomer, 3, 3)
	local c1 = string.sub(nomer, 4, 4)
	local c2 = string.sub(nomer, 5, 5)
	local c3 = string.sub(nomer, 6, 6)
	local b2 = string.sub(nomer, 7, 7)
	local b3 = string.sub(nomer, 8, 8)
	local reg = tonumber(string.sub(nomer, 9, 11))
	return b1, b2, b3, c1, c2, c3, reg
end

--	==========     Разделение числа на части     ==========
function explodeNumber(number)
	number = tostring(number)
	while (k~=0) do      
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')
	end  
	return number
end

-- ==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end

function existsNomer(nomer)
	local _, data = exports.car_system:checkNomerExistance(nomer)
	if (#data > 0) then
		return true, data
	else
		return false
	end
end

-- ==========     Связанное с удалением аккаунтов     ==========
function endOfWipe()
	setTimer(restartResource, 1000, 1, resource)
end

function wipeAccount(accName)
	local equivalent, data = 0, {}
	equivalent, data = wipeAccountModeration(accName)
	local temp, tempData = wipeAccountStorage(accName)
	equivalent = equivalent + temp
	for _, row in ipairs(tempData) do table.insert(data, row) end
	return equivalent, data
end
