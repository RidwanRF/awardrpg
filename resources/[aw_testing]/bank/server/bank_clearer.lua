local command = "resetbank"

local adminGroup = "Console"

addCommandHandler(command, function(player, cmd, login)

	local accName = getAccountName ( getPlayerAccount ( player ) )
	
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( adminGroup ) ) then
		
		if not login then outputChatBox("/"..command.." login", player, 255, 0, 0, true) return end
		
		local account = getAccount (login)
		
		if not account then outputChatBox ("Такого аккаунта не существует!", player, 255, 0, 0, true) return end
		

		local moneyRUB = exports["bank"]:getAccountBankMoney(account, "RUB")		
		local moneyUSD = exports["bank"]:getAccountBankMoney(account, "USD")		
		local moneyEUR = exports["bank"]:getAccountBankMoney(account, "EUR")
		
		exports["bank"]:takeAccountBankMoney(account, moneyRUB, "RUB")
		exports["bank"]:takeAccountBankMoney(account, moneyUSD, "USD")
		exports["bank"]:takeAccountBankMoney(account, moneyEUR, "EUR")
		
		outputChatBox ("Вы обнулили банк (RUB, USD, EUR) игрока "..login.."", player, 255, 255, 0, true)
		
		if isPlayerServer(login) ~= false then
			outputChatBox ("Ваш банк обнулили (RUB, USD, EUR)", isPlayerServer(login), 255, 255, 0, true)
				
			exports['Loger']:printToLog('[БАНК]', string.format('%s (%s) обнулил банк игрока (%s) acc (%s)', 
			
					removeHex(getPlayerName(player)), 
					
					getAccountName(getPlayerAccount(player)), 
					
					removeHex(getPlayerName(isPlayerServer(login))), 
					
					login

				) 
			)				
		else

			exports['Loger']:printToLog('[БАНК]', string.format('%s (%s) обнулил банк игрока acc (%s)', 
			
					removeHex(getPlayerName(player)), 
					
					getAccountName(getPlayerAccount(player)), 
					
					login

				) 
			)				
		end


		
	end
end)

function removeHex (s)
    if type (s) == "string" then
        while (s ~= s:gsub ("#%x%x%x%x%x%x", "")) do
            s = s:gsub ("#%x%x%x%x%x%x", "")
        end
    end
    return s or false
end

function isPlayerServer(login)
	for i, v in ipairs (getElementsByType("player")) do
		if getElementData(v, "accountName") == login then
			return v
		end
	end
	return false
end