
local groupDistance = 13

function checkForInteriorIDs()
	local result = dbPoll(dbQuery(db, "PRAGMA table_info(house_data)"), -1)
	for _, row in ipairs(result) do
		if (row.name) == "intID" then
			return
		end
	end
	outputDebugString("[HOUSE] Column intID not found! Creating...")
	
	dbExec(db, "ALTER TABLE house_data ADD COLUMN intID INTEGER")
	local data = dbPoll(dbQuery(db, "SELECT ID, enterPointX, enterPointY, enterPointZ, int, dim, intID FROM house_data"), -1)
	local interiors = getInteriorsTable()
	for _, int in ipairs(interiors) do
		int.x = int[5]
		int.y = int[6]
		int.z = int[7]
		int.int = int[8]
	end
	for _, house in ipairs(data) do
		house.intID = tonumber(house.intID)
		if (not house.intID) or (house.intID == 0) then
			local found = false
			for _, interior in ipairs(interiors) do
				if (interior.int == house.int) and (getDistanceBetweenPoints3D(interior.x, interior.y, interior.z, house.enterPointX, house.enterPointY, house.enterPointZ) < groupDistance) then
					dbExec(db, "UPDATE house_data SET intID = ? WHERE ID = ?", interior.ID, house.ID)
					found = true
					break
				end
			end
			if (not found) then
				local minDistance, nearestInt = 6000
				for _, interior in ipairs(interiors) do
					local dist = getDistanceBetweenPoints3D(interior.x, interior.y, interior.z, house.enterPointX, house.enterPointY, house.enterPointZ)
					if (dist < minDistance) then
						nearestInt = interior
						minDistance = dist
					end
				end
				dbExec(db, "UPDATE house_data SET intID = 0 WHERE ID = ?", house.ID)
				if (nearestInt) then
					outputDebugString(string.format("[HOUSE] Not found intID for house ID %i (int %i). Nearest interior: %s (ID %i, int %i, %i m)",
						house.ID, house.int, nearestInt[1], nearestInt.ID, nearestInt.int, minDistance
					), 2)
				else
					outputDebugString("[HOUSE] Not found intID for house ID "..house.ID, 2)
				end
			end
		end
		if (house.dim > 65535) then
			local newDim = getFreeDimension(house.int)
			dbExec(db, "UPDATE house_data SET dim = ? WHERE ID = ?", newDim, house.ID)
			outputDebugString(string.format("[HOUSE] Fixed bugged dimension for house %i from %i to %i", house.ID, house.dim, newDim))
		end
	end
	outputDebugString("[HOUSE] Column intID created.")
end
