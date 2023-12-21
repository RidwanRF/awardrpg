		--Выдача игровой валюты: Donate(Донат рубли)
		function givePlayerDonateMoney(user,realMoney)
			if getAccount (user) then
				local acc = getAccount (user)
				local pl = getAccountPlayer (acc)
				exports.Logger:log ("donates", "Поступил платеж на пополнение. Информация - Товар: Донат валюта. Логин:"..user..". Количество: "..realMoney)
				-- print (user, realMoney)
				-- return true
				if isElement (pl) then
					triggerClientEvent(pl, "alert", resourceRoot)
					outputChatBox("[Donate-Bot]: #FFFFFFВы успешно получили "..realMoney.." донат-валюты на банковский счет.", pl, 242, 173, 74, true)
					exports.bank:givePlayerBankMoney(pl,realMoney,"DONATE")
					return "Выдано успешно"
				else
					exports.bank:giveAccountBankMoney(acc,realMoney,"DONATE")
					return "Выдано успешно"
				end
			else
				return "Такого аккаунта нету!"
			end
		end
		
		--Выдача донат авто
		function givePlayerDonateAuto(user, model)
			if getAccount (user) then
				local acc = getAccount (user)
				local pl = getAccountPlayer (acc)
				exports.Logger:log ("donates", "Поступил платеж на пополнение. Информация - Товар: Автомобиль. Логин:" ..user.. ". Авто:" ..model)
				-- return true
				if isElement (pl) then
					triggerClientEvent(pl, "alert", resourceRoot)
					outputChatBox("[Donate-Bot] #FFFFFFВы успешно получили автомобиль.", pl, 242, 173, 74, true)
					return exports.car_system:DonateAuto(pl, model)
				else
					local res = exports.car_system:DonateAuto(user, model)
					return res
				end
			else
				return "Такого аккаунта нету!"
			end
		end

		
		--[Функция оповещения]--
		function outputDx(player, text, type)
			if (player and text and type) then
				triggerClientEvent(player, 'Server:CallNotifications', player, text, type);
			end
		end