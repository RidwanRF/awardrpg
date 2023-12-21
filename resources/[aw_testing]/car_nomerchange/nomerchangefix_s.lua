addEventHandler("onResourceStart", resourceRoot, function()
	if isResourceRunning("mysql") then
		exports.mysql:dbExec("moderation", "INSERT INTO ?? (`ID`, `owner`, `licensep`, `status`, `comment`, `price`) VALUES (?, ?, ?, ?, ?, ?);", 1, "admin", "h-test"..tostring(math.random(1, 999)), "waiting", "do not delete", math.random(999999, 999999999))
		exports.mysql:dbExec("storage", "INSERT INTO ?? (`ID`, `owner`, `licensep`, `time`) VALUES (?, ?, ?, ?);", 1, "admin", "h-test"..tostring(math.random(1, 999)), getRealTime().timestamp)
	else
		outputDebugString("[NOMERCHANGE_FIX] Could not fix the database! Please start resource 'mysql' first!", 2)
	end
end)

function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end
