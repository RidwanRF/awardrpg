
-- ==========     Преобразование формата хранения данных     ==========
if not get("databaseConverted") then
addEventHandler("onResourceStart", resourceRoot, function()
	enumerateAllElements("convertAccountsDatabase", getAccounts(), 100, 50, false,
		function(account)
			local accData = getAllAccountData(account)
		
			-- Удаление оружия
			local unJSONed = (accData.savedWeapons) and fromJSON(accData.savedWeapons)
			if (type(unJSONed) == "table") then
				local count = 0
				for i, weapon in pairs(unJSONed) do
					if (type(weapon) == "table") and tonumber(weapon.weap) and tonumber(weapon.ammo) and (weapon.weap > 0) and (weapon.ammo > 0) then
						count = count + 1
					end
				end
				if (count > 0) then
					outputDebugString(string.format("[SAVE_SYSTEM] Removed %i weapons from acc %s. Old data: %s", count, getAccountName(account), tostring(accData.savedWeapons)))
				end
			end
			setAccountData(account, "savedWeapons", "")
			setAccountData(account, "savedWeapons", false)
			setAccountData(account, "savedWeapons", false)
			
			-- Удаление устаревших данных
			local obsolete = {"Rank", "car-system.cannotFreezeCar", "license", "Group", "team", "Jailed"}
			for _, name in ipairs(obsolete) do
				if (accData[name]) then
					outputDebugString(string.format("[SAVE_SYSTEM] Removed %s from acc %s. Data: %s", name, getAccountName(account), inspect(accData[name])))
					setAccountData(account, name, "")
					setAccountData(account, name, false)
					setAccountData(account, name, false)
				end
			end
			
			-- Удаление пустых и некорректных строк savedSpawnPos
			if (accData.savedSpawnPos) then
				local tbl = fromJSON(accData.savedSpawnPos)
				if (type(tbl) ~= "table") or (not tbl.x) or (not tbl.y) or (not tbl.z) or (not tbl.rotZ) or (not tbl.int) or (not tbl.dim) then
					outputDebugString(string.format("[SAVE_SYSTEM] Removed wrong saved spawn for acc %s. Old data: %s", getAccountName(account), tostring(accData.savedSpawnPos) ))
					accData.savedSpawnPos = nil
					setAccountData(account, "savedSpawnPos", "")
					setAccountData(account, "savedSpawnPos", false)
					setAccountData(account, "savedSpawnPos", false)
				end
			end
			
			-- Удаление пустых и некорректных строк savedLastPos
			if (accData.savedLastPos) then
				local tbl = fromJSON(accData.savedLastPos)
				if (type(tbl) ~= "table") or (not tbl.x) or (not tbl.y) or (not tbl.z) or (not tbl.rotZ) or (not tbl.int) or (not tbl.dim) then
					outputDebugString(string.format("[SAVE_SYSTEM] Removed wrong saved last pos for acc %s. Old data: %s", getAccountName(account), tostring(accData.savedLastPos) ))
					accData.savedLastPos = nil
					setAccountData(account, "savedLastPos", "")
					setAccountData(account, "savedLastPos", false)
					setAccountData(account, "savedLastPos", false)
				end
			end
			
			-- Конвертация позиции сохраненного спавна
			if (accData["sspawn-dim"]) or (accData["sspawn-int"]) or (accData["sspawn-x"]) or (accData["sspawn-y"]) or (accData["sspawn-z"]) then
				if (not accData.savedSpawnPos) then
					local x = accData["sspawn-x"] or 0
					local y = accData["sspawn-y"] or 0
					local z = accData["sspawn-z"] or 0
					local int = accData["sspawn-int"] or 0
					local dim = accData["sspawn-dim"] or 0
					local rotZ = 0
					local spawnPos = toJSON({x=x, y=y, z=z, rotZ=rotZ, int=int, dim=dim}, true)
					setAccountData(account, "savedSpawnPos", spawnPos)
					outputDebugString(string.format("[SAVE_SYSTEM] Updated saved spawn pos for acc %s. Data: %s. Old data: %s", getAccountName(account), tostring(spawnPos),
						inspect({ accData["sspawn-x"], accData["sspawn-y"], accData["sspawn-z"], accData["sspawn-int"], accData["sspawn-dim"] })
					))
				else
					outputDebugString(string.format("[SAVE_SYSTEM] Removed old spawn pos for acc %s. Data: %s", getAccountName(account), 
						inspect({ accData["sspawn-x"], accData["sspawn-y"], accData["sspawn-z"], accData["sspawn-int"], accData["sspawn-dim"] })
					))
				end
				local obsolete = {"sspawn-x", "sspawn-y", "sspawn-z", "sspawn-int", "sspawn-dim"}
				for _, name in ipairs(obsolete) do
					if (accData[name]) then
						setAccountData(account, name, "")
						setAccountData(account, name, false)
						setAccountData(account, name, false)
					end
				end
			end
			
			-- Конвертация банковского баланса
			if (accData["bank.balance"]) then
				if (not accData.bank) then
					local balance = tonumber(accData["bank.balance"]) or 0
					balance = math.floor(balance)
					if (balance > 0) then
						balance = toJSON({RUB = balance}, true)
						setAccountData(account, "bank", balance)
						outputDebugString(string.format("[SAVE_SYSTEM] Converted bank.balance for acc %s. Data: %s. Old data: %s",
							getAccountName(account), tostring(balance), tostring(accData["bank.balance"])
						))
					else
						outputDebugString(string.format("[SAVE_SYSTEM] Removed bank.balance from acc %s. Old data: %s",
							getAccountName(account), tostring(accData["bank.balance"])
						))
					end
				else
					outputDebugString(string.format("[SAVE_SYSTEM] Removed old bank.balance for acc %s. Data: %s", getAccountName(account), tostring(accData["bank.balance"]) ))
				end
				setAccountData(account, "bank.balance", "")
				setAccountData(account, "bank.balance", false)
				setAccountData(account, "bank.balance", false)
			end
			
			-- Конвертация проездов через посты
			if (accData["toll.impulses"]) then
				if (not accData.tollTickets) then
					local tickets = tonumber(accData["toll.impulses"]) or 0
					tickets = math.floor(tickets)
					if (tickets > 0) then
						setAccountData(account, "tollTickets", tickets)
						outputDebugString(string.format("[SAVE_SYSTEM] Converted toll.impulses for acc %s. Data: %s. Old data: %s",
							getAccountName(account), tostring(tickets), tostring(accData["toll.impulses"])
						))
					else
						outputDebugString(string.format("[SAVE_SYSTEM] Removed toll.impulses from acc %s. Old data: %s",
							getAccountName(account), tostring(accData["toll.impulses"])
						))
					end
				else
					outputDebugString(string.format("[SAVE_SYSTEM] Removed old toll.impulses for acc %s. Data: %s", 
						getAccountName(account), tostring(accData["toll.impulses"])
					))
				end
				setAccountData(account, "toll.impulses", "")
				setAccountData(account, "toll.impulses", false)
				setAccountData(account, "toll.impulses", false)
			end
			
			-- Конвертация времени игры
			if (accData["Time Played"]) or (accData["Time Played-hours"]) or (accData["Time Played-min"]) or (accData["Time Played-sec"]) then
				if (not accData.timePlayed) then
					local hours = tonumber(accData["Time Played-hours"]) or 0
					local mins = tonumber(accData["Time Played-min"]) or 0
					local secs = tonumber(accData["Time Played-sec"]) or 0
					local newTime = hours*3600 + mins*60 + secs
					setAccountData(account, "timePlayed", newTime)
					outputDebugString(string.format("[SAVE_SYSTEM] Converted timePlayed for acc %s. Data: %s. Old data: %s", getAccountName(account), tostring(newTime),
						inspect({accData["Time Played"], accData["Time Played-hours"], accData["Time Played-min"], accData["Time Played-sec"]})
					))
				else
					outputDebugString(string.format("[SAVE_SYSTEM] Removed old timePlayed for acc %s. Data: %s",
						getAccountName(account), inspect({accData["Time Played"], accData["Time Played-hours"], accData["Time Played-min"], accData["Time Played-sec"]})
					))
				end
				local obsolete = {"Time Played", "Time Played-hours", "Time Played-min", "Time Played-sec"}
				for _, name in ipairs(obsolete) do
					if (accData[name]) then
						setAccountData(account, name, "")
						setAccountData(account, name, false)
						setAccountData(account, name, false)
					end
				end
			end
			
			-- Конвертация свойств игрока, таких как здоровье, броня, скин
			if (accData.savedArmor) or (accData.savedSkin) then
				if (not accData.playerProperties) then
					local playerProperties = {}
					accData.savedArmor = tonumber(accData.savedArmor)
					accData.savedSkin = tonumber(accData.savedSkin)
					playerProperties.armor = (accData.savedArmor and (accData.savedArmor > 0) and accData.savedArmor) or nil
					playerProperties.skin = (accData.savedSkin and (accData.savedSkin > 0) and accData.savedSkin) or nil
					if (playerProperties.armor) or (playerProperties.skin) then
						playerProperties = toJSON(playerProperties, true)
						setAccountData(account, "playerProperties", playerProperties)
						outputDebugString(string.format("[SAVE_SYSTEM] Converted savedArmor and savedSkin for acc %s. Data: %s. Old data: %s",
							getAccountName(account), playerProperties, inspect({accData.savedArmor, accData.savedSkin})
						))
					else
						outputDebugString(string.format("[SAVE_SYSTEM] Converted savedArmor and savedSkin to nothing for acc %s. Old data: %s",
							getAccountName(account), inspect({accData.savedArmor, accData.savedSkin})
						))
					end
				else
					outputDebugString(string.format("[SAVE_SYSTEM] Removed old savedArmor and savedSkin for acc %s. Old data: %s",
						getAccountName(account), inspect({accData.savedArmor, accData.savedSkin})
					))
				end
			end
			local obsolete = {"savedArmor", "savedSkin"}
			for _, name in ipairs(obsolete) do
				if (accData[name]) then
					setAccountData(account, name, "")
					setAccountData(account, name, false)
					setAccountData(account, name, false)
				end
			end
			
		
		end, 
		function(portionNumber, currentLoopTime, elapsedTime, currentPortionSize, enumName)
			outputDebugString(string.format("[SAVE_SYSTEM] Processed %i accs in %i ms. Speed: %.2f acc/s", currentPortionSize, currentLoopTime, (currentPortionSize/currentLoopTime)*1000))
		end,
		function(portions, elapsedTime, totalTimeWithPauses, processedCount)
			outputDebugString(string.format("[SAVE_SYSTEM] Fully processed %i accs in %.2f s (%.2f s total). Speed: %.2f acc/s",
				processedCount, elapsedTime/1000, totalTimeWithPauses/1000, (processedCount/elapsedTime)*1000
			))
			set("databaseConverted", true)
		end
	)
end)
end
