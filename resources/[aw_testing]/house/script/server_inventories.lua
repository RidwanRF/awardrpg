
local inventoryObjectsByIntID = {}
local intIDsByPlayer = {}

function createInventoryOnHouseEnter(player, intID, dimension, owner)
	removeInventory(player)
	intIDsByPlayer[player] = intID
	
	local intData = inventoryObjectsByIntID[intID]
	if (not intData) then
		inventoryObjectsByIntID[intID] = {
			object = createInventoryObject(intID, dimension, owner),
			players = {[player] = true}
		}
	else
		intData.players[player] = true
	end
end

function createInventoryObject(intID, dimension, owner)
	local interior = getInteriorData(intID)
	if (interior) then
		local cabinet = interior.cabinet
		local object = createObject(cabinet[1], cabinet[2], cabinet[3], cabinet[4], 0, 0, cabinet[5])
		setElementInterior(object, interior[8])
		setElementDimension(object, dimension)
		setElementData(object, "house_inventory_owner", owner)
		local account = getAccount(owner)
		setElementData(object, "house_inventory_player", account and getAccountPlayer(account))
		return object
	end
end

function removeInventory(player)
	local intID = intIDsByPlayer[player]
	if (intID) then
		local intData = inventoryObjectsByIntID[intID]
		if (intData) then
			intData.players[player] = nil
			local delete = true
			for _, _ in pairs(intData.players) do
				delete = false
				break
			end
			if (delete) then
				if isElement(intData.object) then destroyElement(intData.object) end
				inventoryObjectsByIntID[intID] = nil
			end
		end
		intIDsByPlayer[player] = nil
	end
end   

addEventHandler("onPlayerQuit", root, function()
	removeInventory(source)
end)
addEventHandler("onPlayerWasted", root, function()
	removeInventory(source)
end)
