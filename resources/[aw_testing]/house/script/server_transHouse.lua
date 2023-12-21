
function transHouse(id, newOwner, sellerMoney)
	if (not sellerMoney) or (sellerMoney < 0) then return end
	sellerMoney = math.min(sellerMoney, 1000*1000*1000)
	local hData = houseData[id]
	local accName = getAccountName(getPlayerAccount(client))
	local inf = getAccountData(getPlayerAccount(client), "INF")
	if (inf) and (inf > 10000) then
		outputChatBad("У вас имеются неоплаченные штрафы!", client)
		return
	end
	local result = dbPoll(dbQuery(db, "SELECT owner FROM house_data WHERE ID = ?", hData.ID), -1)
	if (result[1].owner ~= accName) then
		outputChatBad("Это не ваш дом!", client)
		return
	end
	if not isElement(newOwner) then
		outputChatBad("Этот игрок вышел с сервера!", client)
		return
	end
	local newOwnerAcc = getPlayerAccount(newOwner)
	if isGuestAccount(newOwnerAcc) then
		outputChatBad("Невозможно передать дом, игрок еще не вошёл в свой аккаунт.", client)
		return
	end
	local newOwnerAccName = getAccountName(newOwnerAcc)
	local buyerHouses = getHousesCount(newOwnerAccName)
	if (buyerHouses >= maxHousesCount) then
		outputChatBad("Невозможно передать дом, у игрока слишком много недвижимости!", client)
		outputChatBad(getPlayerName(client).." #FF3324хотел продать вам дом, но у вас уже слишком много недвижимости!", newOwner)
		return
	end
	triggerClientEvent(newOwner, "transHouseOffer", resourceRoot, hData, client, sellerMoney)
	outputDebugString("[HOUSE][TRANSHOUSE_OFFER] "..getPlayerName(client).." (acc "..accName.." money "..getPlayerMoney(client)..") created offer to sell house (id "..hData.ID..") for "..sellerMoney.." to "..getPlayerName(newOwner).." (acc "..getAccountName(getPlayerAccount(newOwner)).." money "..getPlayerMoney(newOwner)..")")
	outputChatOK(getPlayerName(client).." #32FF32предложил вам купить его дом!", newOwner)
	outputChatOK(getPlayerName(newOwner).." #32FF32получил ваше предложение.", client)
end
addEvent("transHouse", true)
addEventHandler("transHouse", resourceRoot, transHouse)

function acceptHouseOffer(ID, seller, money)
	if not isElement(seller) then
		outputChatBad("Продавец вышел с сервера. Сделка невозможна.", client)
		return
	end
	local sellerAccName = getAccountName(getPlayerAccount(seller))
	local buyerAccName = getAccountName(getPlayerAccount(client))
	local inf = getAccountData(getPlayerAccount(client), "INF")
	if (inf) and (inf > 10000) then
		outputChatBad("У вас имеются неоплаченные штрафы!", client)
		outputChatBad("У покупателя имеются неоплаченные штрафы!", seller)
		return
	end
	local result = dbPoll(dbQuery(db, "SELECT owner FROM house_data WHERE ID = ?", ID), -1)
	if (result[1].owner ~= sellerAccName) then
		outputChatBad("Дом не принадлежит своему прежнему владельцу. Сделка невозможна.", client)
		outputChatBad("Не пытайся продать дом два раза.", seller)
		return
	end
	local buyerMoney = math.floor(money*1.1)
	if (getPlayerMoney(client) < buyerMoney) then
		outputChatBad("У вас недостаточно денег для покупки.", client)
		outputChatBad("У покупателя недостаточно денег для покупки.", seller)
		return
	end
	if (getPlayerMoney(seller) + money > 99999999) then
		outputChatBad("Продавец не сможет унести все деньги после сделки.", client)
		outputChatBad("Вы не сможете унести все деньги после сделки.", seller)
		return
	end
	local buyerHouses = getHousesCount(buyerAccName)
	if (buyerHouses >= maxHousesCount) then
		outputChatBad("Невозможно передать дом, у игрока слишком много недвижимости!", seller)
		outputChatBad(getPlayerName(seller).." #FF3324хотел продать вам дом, но у вас уже слишком много недвижимости!", client)
		return
	end
	local moneyToTake = buyerMoney
	local moneyToGive = money
	local moneyToFee = moneyToTake - moneyToGive
	takePlayerMoney(client, moneyToTake)
	givePlayerMoney(seller, moneyToGive)
	dbExec(db, "UPDATE house_data SET owner = ? WHERE id = ?", buyerAccName, ID)
	outputDebugString("[HOUSE][TRANSHOUSE] "..getPlayerName(client).." (acc "..buyerAccName.." money "..getPlayerMoney(client)..") bought house (id "..ID..") from "..getPlayerName(seller).." (acc "..sellerAccName.." money "..getPlayerMoney(seller)..") for: taken: "..moneyToTake..", given: "..moneyToGive..", fee: "..moneyToFee)
	updateHouse(ID, "owner", buyerAccName)
	outputChatOK("Вы успешно купили дом за $ "..moneyToTake.." Ключ: #FFFF00"..houseData[ID].key, client)
	outputChatOK("Вы успешно продали дом за $ "..moneyToGive.."", seller)
	local carsystRes = getResourceFromName("car_system")
	if (carsystRes) and (getResourceState(carsystRes) == "running") then
		exports.car_system:updateVehicleInfo(client)
		exports.car_system:updateVehicleInfo(seller)
	end
end
addEvent("acceptHouseOffer", true)
addEventHandler("acceptHouseOffer", resourceRoot, acceptHouseOffer)

function declineHouseOffer(ID, seller, money)
	outputChatOK("Вы отказались покупать дом.", client)
	if isElement(seller) then
		outputChatBad(getPlayerName(client).." #FF3232отклонил ваше предложение.", seller)
		outputDebugString("[HOUSE][TRANSHOUSE_DECLINE] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client)).." money "..getPlayerMoney(client)..") rejected a purchase of house (id "..ID..") for "..money.." from "..getPlayerName(seller).." (acc "..getAccountName(getPlayerAccount(seller)).." money "..getPlayerMoney(seller)..")")
	else
		outputDebugString("[HOUSE][TRANSHOUSE_DECLINE] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client)).." money "..getPlayerMoney(client)..") rejected a purchase of house (id "..ID..") for "..money.." from Not-a-player")
	end
end
addEvent("declineHouseOffer", true)
addEventHandler("declineHouseOffer", resourceRoot, declineHouseOffer)

























