
-- // {money = количество_денег, command = "команда", chat = "вывод_в_чат"}
local get_setting_table_money =
{
	{money = 3000000000, command = "bonus", chat = "Вы успешно ввели бонус-код, и получили $ 3 000 000 000"},
}

-- // Элемент дерева
local get_root_element = getResourceRootElement(getThisResource())

-- // Старт ресурса
function func_start_resource_server()
	if not get_setting_table_money or #get_setting_table_money == 0 then
		return
	end
	for index, table in ipairs(get_setting_table_money) do
		if table.money and table.command and table.chat then

			addCommandHandler(table.command, function(player)

				-- // Аккаунт
				local account = getPlayerAccount(player)

				-- // Вошел ли в аккаунт
				if isGuestAccount(account) then 
					return 
				end

				-- // Проверка на бонус
				local data = getAccountData(account, "500kkk2")

				-- // Получение бонуса
				if not data then
					outputChatBox(table.chat, player, 255,255,255, true)
					setAccountData(account, "500kkk2", true)
					exports.bank:givePlayerBankMoney(player, table.money, "RUB")
				else
					outputChatBox("* Вы уже забрали свой бонус.", player, 255,255,255, true)
				end

			end)
		else
			outputDebugString("[ERROR] [GIVE MONEY] [NOT COMPONENT TABLE]")
		end
	end
end
addEventHandler("onResourceStart", get_root_element, func_start_resource_server)

-- // Игрок вошел в аккаунт
addEventHandler("onPlayerLogin", root, function()
	if not get_setting_table_money or #get_setting_table_money == 0 then
		return
	else
		outputChatBox("* Используйте /bonus для получения бонуса.", source, 255,255,255, true)
	end
end)