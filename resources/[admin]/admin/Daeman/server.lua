
local allowedVehicles = {}
addCommandHandler("cv", function(player, _, model)
	if not hasObjectPermissionTo(player, "command.givevehicle", false) then return end

	model = tonumber(model)
	if (not model) then
		outputChatBox("cv: - Syntax is 'cv <model>'", player, 255, 100, 70)
		return
	end
	if (not allowedVehicles[model]) then
		outputChatBox("cv: this model ID not allowed!", player, 255, 100, 70)
		return
	end
	triggerEvent("aPlayer", player, player, "givevehicle", model)
end, false, false)

for model = 400, 609 do
	local name = getVehicleNameFromModel(model)
	if (name) and (name ~= "") then
		allowedVehicles[model] = true
	end
end

addEvent("adminGiveItem", true)
addEventHandler("adminGiveItem", resourceRoot, function(player, itemName, count, temporary, checkForExistance)
	if not hasObjectPermissionTo(player, "command.giveweapon", false) then return end
	if not isElement(player) then return end
	if not isResourceRunning("inventory_system") then return end
	
	if (checkForExistance) and (exports.inventory_system:getPlayerInventoryItemCount(player, itemName, true) > 0) then
		return
	end
	
	exports.inventory_system:addPlayerItem(player, itemName, count, temporary, false)
	
	outputServerLog(string.format("ADMIN: %s (acc %s) has given %s '%s%s'",
		getPlayerName(client), getAccountName(getPlayerAccount(client)), getPlayerName(player), itemName, (temporary and " (temporary)" or "")
	))
	local itemClass = exports.inventory_system:getItemClass(itemName)
	if (client ~= player) then
		outputChatBox(string.format("%s has been given a %s'%s'%s", getPlayerName(player):gsub("#%x%x%x%x%x%x", ""), (temporary and "temporary " or ""),
			itemClass.readableName, (count > 1) and " ("..count..")" or ""),
		client, 0,0,255)
	end
	outputChatBox(string.format("You have been given a '%s'%s by %s.", itemClass.readableName, (count > 1) and " ("..count..")" or "", getPlayerName(client):gsub("#%x%x%x%x%x%x", "")), player, 0,0,255)
end)


--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end
