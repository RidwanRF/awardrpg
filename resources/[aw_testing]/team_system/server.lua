local db = dbConnect("sqlite", "teams.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS teams (ID, owner, name, colorR, colorG, colorB)")
dbExec(db, "CREATE TABLE IF NOT EXISTS members (ID, account, teamID)")

function refreshTeamsOnTab()
	clearTeams()
	local teamsData = dbPoll(dbQuery(db, "SELECT ID, name, colorR, colorG, colorB FROM teams"), -1)
	if (type(teamsData) ~= "table") or (#teamsData < 1) then return end
	for _, team in ipairs(teamsData) do
		local teamList = dbPoll(dbQuery(db, "SELECT account FROM members WHERE teamID = ?", team.ID), -1)
		local activeMembers = {}
		for _, member in ipairs(teamList) do
			local player = getAccountPlayer(getAccount(member.account))
			if player then table.insert(activeMembers, player) end
		end
		if #activeMembers > 0 then
			local tabTeam = createTeam(team.name, team.colorR, team.colorG, team.colorB)
			for _, player in ipairs(activeMembers) do
				setPlayerTeam(player, tabTeam)
			end
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, refreshTeamsOnTab)

function clearTeams()
	for _, team in ipairs(getElementsByType("team")) do
		destroyElement(team)
	end
end
addEventHandler("onResourceStop", resourceRoot, clearTeams)

function addPlayerToTeam(player)
	local account = getAccountName(getPlayerAccount(player))
	local membersData = dbPoll(dbQuery(db, "SELECT teamID FROM members WHERE account = ?", account), -1)
	if (type(membersData) == "table") and (#membersData > 0) then
		local teamData = dbPoll(dbQuery(db, "SELECT name, colorR, colorG, colorB FROM teams WHERE ID = ?", membersData[1].teamID), -1)
		local tabTeam
		for _, team in ipairs(getElementsByType("team")) do
			if getTeamName(team) == teamData[1].name then
				tabTeam = team
				break
			end
		end
		if not tabTeam then
			tabTeam = createTeam(teamData[1].name, teamData[1].colorR, teamData[1].colorG, teamData[1].colorB)
		end
		setPlayerTeam(player, tabTeam)
	end
end

addEventHandler("onPlayerLogin", root, function()
	--setTimer(addPlayerToTeam, 100, 1, source)
	addPlayerToTeam(source)
end)

function removePlayerFromTeam(player)
	local team = getPlayerTeam(player)
	setPlayerTeam(player, false)
	if (team) and (countPlayersInTeam(team) == 0) then
		destroyElement(team)
	end
end

addEventHandler("onPlayerQuit", root, function()
	removePlayerFromTeam(source)
end)

function openingPanel(playerSource)
	local allowance = playerIsAllowed(playerSource)
	local allowType = type(allowance)
	if (allowType == "boolean") and (allowance == true) then
		triggerClientEvent(playerSource, "togglePanel", resourceRoot, true)
	elseif ((allowType == "number") or (allowType == "string")) then
		triggerClientEvent(playerSource, "togglePanel", resourceRoot, false, allowance)
	end
end
addCommandHandler("teampanel", openingPanel, false, false)

function requestData()
	sendTeamData(client)
end
addEvent("requestTeams", true)
addEventHandler("requestTeams", resourceRoot, requestData)

function createGroup(name)
	if not playerIsAllowed(client) then return end
	local accName = getAccountName(getPlayerAccount(client))
	dbExec(db, "INSERT INTO teams VALUES(?, ?, ?, ?, ?, ?)", getFreeID("teams"), accName, name, 255, 255, 255)
	outputChatBox("Группа "..name.." создана, вы назначены главой.", client, 50, 255, 50)
	outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..accName..") created team "..name)
	sendTeamData(client)
end
addEvent("createGroup", true)
addEventHandler("createGroup", resourceRoot, createGroup)

function changeGroupName(id, name)
	if not playerIsAllowed(client) then return end
	local accName = getAccountName(getPlayerAccount(client))
	local data = dbPoll(dbQuery(db, "SELECT name FROM teams WHERE ID = ?", id), -1)
	if type(data) ~= "table" then return end
	local oldName = data[1].name
	dbExec(db, "UPDATE teams SET name = ? WHERE ID = ?", name, id)
	outputChatBox("Группа "..oldName.." переименована в "..name, client, 50, 255, 50)
	outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..accName..") renamed team "..oldName.." to "..name)
	sendTeamData(client)
	refreshTeamsOnTab()
end
addEvent("changeGroupName", true)
addEventHandler("changeGroupName", resourceRoot, changeGroupName)

function changeGroupOwner(id, acc)
	if not playerIsAllowed(client) then return end
	if not getAccount(acc) then
		outputChatBox("Аккаунт "..acc.." не найден!", client, 255, 50, 50)
		return
	end
	local accName = getAccountName(getPlayerAccount(client))
	local data = dbPoll(dbQuery(db, "SELECT owner, name FROM teams WHERE ID = ?", id), -1)
	if type(data) ~= "table" then return end
	local oldOwner = data[1].owner
	local name = data[1].name
	dbExec(db, "UPDATE teams SET owner = ? WHERE ID = ?", acc, id)
	outputChatBox("Новый владелец группы "..name.." - "..acc, client, 50, 255, 50)
	outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..accName..") changed owner from "..oldOwner.." to "..acc.." for team "..name)
	sendTeamData(client)
	local newOwner = getAccountPlayer(getAccount(acc))
	if newOwner then
		outputChatBox("Ты назначен новым владельцем группы "..name..". Удачи!", newOwner, 50, 255, 50)
	end
end
addEvent("changeGroupOwner", true)
addEventHandler("changeGroupOwner", resourceRoot, changeGroupOwner)

function changeGroupColor(id, r, g, b)
	if not playerIsAllowed(client) then return end
	local data = dbPoll(dbQuery(db, "SELECT name, colorR, colorG, colorB FROM teams WHERE ID = ?", id), -1)
	if type(data) ~= "table" then return end
	local name = data[1].name
	local oldColor = data[1].colorR..","..data[1].colorG..","..data[1].colorB
	dbExec(db, "UPDATE teams SET colorR = ?, colorG = ?, colorB = ? WHERE ID = ?", r, g, b, id)
	outputChatBox("Сменен цвет группы "..name.." на "..r..","..g..","..b, client, 50, 255, 50)
	outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..") change color for team "..name.." to "..r..","..g..","..b)
	sendTeamData(client)
	refreshTeamsOnTab()
end
addEvent("changeGroupColor", true)
addEventHandler("changeGroupColor", resourceRoot, changeGroupColor)

function deleteGroup(id)
	if not playerIsAllowed(client) then return end
	local data = dbPoll(dbQuery(db, "SELECT name FROM teams WHERE ID = ?", id), -1)
	if type(data) ~= "table" then return end
	local name = data[1].name
	dbExec(db, "DELETE FROM teams WHERE ID = ?", id)
	dbExec(db, "DELETE FROM members WHERE teamID = ?", id)
	outputChatBox("Удалена группа "..name..", участники распущены", client, 50, 255, 50)
	outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..") deleted team "..name)
	sendTeamData(client)
	refreshTeamsOnTab()
end
addEvent("deleteGroup", true)
addEventHandler("deleteGroup", resourceRoot, deleteGroup)

function addMemberByNick(teamID, nick)
	if not playerIsAllowed(client) then return end
	local player = getPlayerFromName(nick)
	if (not player) then
		outputChatBox("Игрок не найден!", client, 255, 50, 50)
		return
	end
	local newMemberAcc = getAccountName(getPlayerAccount(player))
	local members = dbPoll(dbQuery(db, "SELECT account FROM members WHERE account = ?", newMemberAcc), -1)
	if (type(members) == "table") and (#members > 0) then
		outputChatBox("Игрок уже состоит в группе!", client, 255, 50, 50)
		return
	end
	local data = dbPoll(dbQuery(db, "SELECT name FROM teams WHERE ID = ?", teamID), -1)
	if type(data) ~= "table" then return end
	local name = data[1].name
	dbExec(db, "INSERT INTO members VALUES(?, ?, ?)", getFreeID("members"), newMemberAcc, teamID, 255, 255, 255)
	outputChatBox(nick.." успешно добавлен в группу "..name, client, 50, 255, 50)
	outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..") added "..nick.." (acc "..newMemberAcc..") to team "..name)
	sendMemberData(client, teamID)
	outputChatBox("Ты был принят в группу "..name..". Удачи!", player, 50, 255, 50)
	addPlayerToTeam(player)
end
addEvent("addMemberByNick", true)
addEventHandler("addMemberByNick", resourceRoot, addMemberByNick)

function addMemberByAcc(teamID, accName)
	if not playerIsAllowed(client) then return end
	local account = getAccount(accName)
	if (not account) then
		outputChatBox("Аккаунт не найден!", client, 255, 50, 50)
		return
	end
	local members = dbPoll(dbQuery(db, "SELECT account FROM members WHERE account = ?", accName), -1)
	if (type(members) == "table") and (#members > 0) then
		outputChatBox("Игрок уже состоит в группе!", client, 255, 50, 50)
		return
	end
	local data = dbPoll(dbQuery(db, "SELECT name FROM teams WHERE ID = ?", teamID), -1)
	if type(data) ~= "table" then return end
	local name = data[1].name
	dbExec(db, "INSERT INTO members VALUES(?, ?, ?)", getFreeID("members"), accName, teamID, 255, 255, 255)
	outputChatBox(accName.." успешно добавлен в группу "..name, client, 50, 255, 50)
	sendMemberData(client, teamID)
	local player = getAccountPlayer(account)
	if player then
		outputChatBox("Ты был принят в группу "..name..". Удачи!", player, 50, 255, 50)
		outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..") added "..getPlayerName(player).." (acc "..accName..") to team "..name)
		addPlayerToTeam(player)
	else
		outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..") added acc "..accName.." to team "..name)
	end
end
addEvent("addMemberByAcc", true)
addEventHandler("addMemberByAcc", resourceRoot, addMemberByAcc)

function fireMember(teamID, memberID)
	if not playerIsAllowed(client) then return end
	local data = dbPoll(dbQuery(db, "SELECT name FROM teams WHERE ID = ?", teamID), -1)
	local members = dbPoll(dbQuery(db, "SELECT account FROM members WHERE ID = ?", memberID), -1)
	if (type(data) ~= "table") or (type(members) ~= "table") then return end
	local name = data[1].name
	local accName = members[1].account
	dbExec(db, "DELETE FROM members WHERE ID = ?", memberID)
	outputChatBox(accName.." был изгнан из группы "..name, client, 50, 255, 50)
	outputDebugString("[TEAMSYSTEM] "..getPlayerName(client).." (acc "..getAccountName(getPlayerAccount(client))..") fired "..accName.." from team "..name)
	sendMemberData(client, teamID)
	local player = getAccountPlayer(getAccount(accName))
	if player then
		removePlayerFromTeam(player)
		outputChatBox("Ты был изгнан из группы "..name..".", player, 255, 50, 50)
	end
end
addEvent("fireMember", true)
addEventHandler("fireMember", resourceRoot, fireMember)

function playerIsAllowed(player)
	local accName = getAccountName(getPlayerAccount(player))
	if hasObjectPermissionTo(player, "command.teamsystem", false) then
		return true
	else
		local teamsData = dbPoll(dbQuery(db, "SELECT ID FROM teams WHERE owner = ?", accName), -1)
		if (type(teamsData) == "table") and (#teamsData > 0) then
			return teamsData[1].ID
		else
			return false
		end
	end
end

function sendTeamData(player)
	local result = dbPoll(dbQuery(db, "SELECT * FROM teams"), -1)
	if type(result) == "table" then
		triggerClientEvent(player, "refreshTeamList", resourceRoot, result)
	end
end

function sendMemberData(player, teamID)
	--local result = dbPoll(dbQuery(db, "SELECT ID, account FROM members WHERE teamID = ?", tostring(teamID)), -1)
	local result = dbPoll(dbQuery(db, "SELECT ID, account FROM members WHERE teamID = ?", teamID), -1)
	if type(result) == "table" then
		for _, member in ipairs(result) do
			local accPlayer = getAccountPlayer(getAccount(member.account))
			if accPlayer then
				member.player = getPlayerName(accPlayer)
			else
				member.player = ""
			end
		end
		triggerClientEvent(player, "refreshMemberList", resourceRoot, result)
	end
end
addEvent("getTeamMembers", true)
addEventHandler("getTeamMembers", resourceRoot, sendMemberData)

function getFreeID(tableName)
	local result = dbPoll(dbQuery(db, "SELECT ID FROM ? ORDER BY ID ASC", tableName), -1)
	local newID = false
	for i, id in pairs (result) do
		if id.ID ~= i then
			newID = i
			break
		end
	end
	if newID then
		return newID
	else
		return #result + 1
	end
end


-- ==========     Связанное с удалением аккаунтов     ==========
function endOfWipe()
	setTimer(restartResource, 1000, 1, resource)
end

function wipeAccount(accName)
	local data = dbPoll(dbQuery(db, "SELECT m.ID, m.account, m.teamID, t.owner, t.name, t.colorR, t.colorG, t.colorB FROM members AS m LEFT JOIN teams AS t ON (m.teamID = t.ID) WHERE account = ?;", accName), -1)
	for _, member in ipairs(data) do
		dbExec(db, "DELETE FROM members WHERE ID = ?", member.ID)
		outputDebugString(string.format("[TEAMSYSTEM] Fired %s from team %s",
			member.account, member.name
		))
	end
	return 0, data
end
