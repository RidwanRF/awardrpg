addEventHandler ( "onPlayerWasted", root, function( totalAmmo, killer, killerWeapon, bodypart, stealth )
    if killer then
        local account = getPlayerAccount ( killer )
        if killer ~= source then
            setAccountData( account,"totalkillsdeaths.Kills",tonumber( getAccountData( account,"totalkillsdeaths.Kills" ) or 0 ) +1 )
            setElementData( killer, "T/K", tonumber( getAccountData( account,"totalkillsdeaths.Kills" ) ) )
        end 
    else
        local accountSource = getPlayerAccount ( source )
        setAccountData( accountSource,"totalkillsdeaths.Deaths",tonumber( getAccountData(accountSource,"totalkillsdeaths.Deaths") or 0 ) +1 )
        setElementData( source, "T/D", tonumber( getAccountData( accountSource,"totalkillsdeaths.Deaths" ) ) )
    end
end)      
 
addEventHandler( "onPlayerLogin",root, function( thePreviousAccount, theCurrentAccount, autoLogin )
    local account = getPlayerAccount ( source )
    if not getAccountData( account,"totalkillsdeaths.Kills" ) and not getAccountData( account,"totalkillsdeaths.Deaths" ) then
        setAccountData( account,"totalkillsdeaths.Kills",0 )
        setAccountData( account,"totalkillsdeaths.Deaths",0 )
    end
    setElementData( source,"T/D",tonumber( getAccountData( account,"totalkillsdeaths.Deaths" ) or 0 ) )
    setElementData( source,"T/K",tonumber( getAccountData( account,"totalkillsdeaths.Kills" ) or 0 ) )
end)

local light = 0
function event (element, type)
if type == "kill" then
	killPed (element)
elseif type == "lights" then
	if not isElement (element) then return end
	if getElementType (element) ~= "vehicle" then return end
	local xenon = {255,255,255}
			local data = getElementData(element, "xenon")
			if (data) then
				data = split(data, ",")
				if (#data >= 3) then
					xenon = data
				end
			end
	if light == 0 then
		setVehicleOverrideLights( element, 2 )
		setVehicleHeadLightColor (element, 0, 0, 0)
		light = 1
	elseif light == 1 then
		setVehicleOverrideLights( element, 2 )
		setVehicleHeadLightColor (element, xenon[1], xenon[2], xenon[3])
		light = 2
	elseif light == 2 then
		setVehicleOverrideLights( element, 1 )
		light = 0
	end
elseif type == "recover" then
	if not isElement (element) then return end
	if getElementType (element) ~= "vehicle" then return end
	local _, _, rz = getElementRotation (element)
	local x, y, z = getElementPosition (element)
	setElementRotation (element, 0, 0, rz)
elseif type == "spawn" then
	setElementPosition(element, 1683 ,1448 ,11,false)
	outputChatBox("Вы успешно телепортировалиь на спавн!", client)

elseif type == "fix" then
	if not isElement (element) then return end
	if getElementType (element) ~= "vehicle" then return end
	for i = 0, 5 do
			setVehicleDoorOpenRatio(element, i, 0, 0.5)
			setVehicleDoorState(element, i, 0)
		end
		if getElementData(element, "hasIllegalItems") then
			outputChatBox("Невозможно починить машину - в ней находится нелегальный предмет.", client)
			return
		end
		for _, player in pairs(getVehicleOccupants(element)) do
			if isElement(player) then
				if getElementData(player, "isChased") then
					outputChatBox("Невозможно починить машину - в ней сидит игрок, находящийся в погоне.", client)
					return
				elseif getElementData(player, "isChasing") then
					outputChatBox("Невозможно починить машину - полицейский преследует нарушителя.", client)
					return
				end
			end
		end
		for _, elementE in ipairs(getAttachedElements(element)) do
			if (getElementType(elementE) == "player") and getElementData(elementE, "isChased") then
				outputChatBox("Невозможно починить машину - к ней приклеен игрок, находящийся в розыске.", client)
				return
			end
		end
	if getElementData (element, "vehMP") then outputChatBox("Невозможно починить машину МП.", client) return end
	fixVehicle (element)
end
end
addEvent ("event", true)
addEventHandler ("event", root, event)

addEventHandler ( 'onPlayerLogin', root,
    function ( _, theCurrentAccount )
    triggerClientEvent ( source, "startLoging", resourceRoot, getAccountName(theCurrentAccount))
end)

local get_weapon_name =
{
    [22] = {name = "weapon_colt45", ammo = "ammo_45acp", count = 90},
    [24] = {name = "weapon_deagle", ammo = "ammo_50ae", count = 90},
    [28] = {name = "weapon_uzi", ammo = "ammo_9mm", count = 90},
    [32] = {name = "weapon_tec9", ammo = "ammo_9mm", count = 90},
    [30] = {name = "weapon_ak47", ammo = "ammo_762mm", count = 90},
    [31] = {name = "weapon_m4", ammo = "ammo_556mm", count = 90},
    [35] = {name = "weapon_rpg7", ammo = "ammo_pg7v", count = 90},
    [16] = {name = "weapon_grenade", ammo = "weapon_grenade", count = 90},
}

function takeMoneyBank (ammmount, arg)
	local account = getPlayerAccount(source)
	exports.bank:takeAccountBankMoney(account, ammmount, arg)
end
addEvent ("takeMoneyBank", true)
addEventHandler ("takeMoneyBank", root, takeMoneyBank)


function func_get_weapon_item(id)
    if get_weapon_name[id] then
        return get_weapon_name[id]
    end
    return false
end


addEvent("takeBank",true)
addEventHandler("takeBank",root,function(amount)
local account = getPlayerAccount(source)
	exports.bank:takeAccountBankMoney(account,amount,"DONATE")
	outputChatBox("С вашего донат счета было успешно снято - "..amount.." AW Coins.",source,0,255,0)
end)

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

local db

function dbFunction ()
	db = dbConnect("sqlite", "database.db")
	dbExec(db, "CREATE TABLE IF NOT EXISTS privilege(serial TEXT, login TEXT, privilege TEXT, startTime INT, stopTime INT)")
end
setTimer (dbFunction, 200, 1)

function isExistPri (accName)
	local res = false
	local qh = dbQuery(db, "SELECT * FROM privilege WHERE login = ?", accName)
	local dbCall = dbPoll(qh, -1)
	if #dbCall > 0 then
		res = true
	end
	dbFree(qh)
	return res
end


function setPrivilege(acc, acl)
	local accName = getAccountName(acc)
	--if not isExistPri (accName) then
		local qh = dbExec(db, "INSERT INTO privilege VALUES (?, ?, ?, ?, ?)", getAccountSerial (acc), accName, acl, getRealTime().timestamp, getRealTime().timestamp+(86000 * 30) )
		aclGroupAddObject (aclGetGroup(acl), "user."..accName)
		outputChatBox ("Благодарим вас за покупку привилегии на 30 дней.", source)
		collectgarbage()
	--else
		--outputChatBox ("У вас уже есть привелегия", source)
	--end
end

function checkPrivilege(playerA)
	local acc = getPlayerAccount (playerA)
	if isGuestAccount (acc) then return end
	local accName = getAccountName(acc)
	local qh = dbQuery(db, "SELECT * FROM privilege WHERE login = ?", accName)
	local dbCall = dbPoll(qh, -1)
	for i, v in ipairs (dbCall) do
		if v["stopTime"] <= getRealTime().timestamp then
			local qh = dbExec(db, "DELETE FROM privilege WHERE login = ?", accName)
			aclGroupRemoveObject (aclGetGroup(v['privilege']), "user."..accName)
			outputChatBox ("Время действия ваше привелегии закончилось.", playerA)
		end
	end
end
addEvent('checkPrivilege', true)
addEventHandler('checkPrivilege', resourceRoot, checkPrivilege)

addEventHandler("onPlayerLogin", getRootElement(), function()
	checkPrivilege(source)
end)



addEvent( "vip_1", true )
addEventHandler( "vip_1", root,
	function( player, DonateNumber)
    local account = getPlayerAccount(source)
	local accountData = getAccountName(account)
	if exports.bank:getPlayerBankMoney(source, "DONATE") >= 20 then
	local donateInPlayer = exports.bank:getAccountBankMoney(account, "DONATE")
	if donateInPlayer >= 20 then
			exports.bank:takeAccountBankMoney(account, 20, "DONATE")
			exports.vip:givePlayerVIP(getAccountName(account), 86400)
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы успешно купили премиум за 20 AW Coins", getTickCount(), 8000)
			exports.aw_server_logs:log("SHOP-PREMIUM", "Ник: "..getPlayerName (source).." Получил: Премиум подписку. Потратив 20 AW Coins.")
		else
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы сейчас не можете это купить", getTickCount(), 8000)
		end
	else
		exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "У вас недостаточно AW Coins для покупки", getTickCount(), 8000)
	end
end
)



addEvent( "vip_2", true )
addEventHandler( "vip_2", root,
	function( player, DonateNumber)
    local account = getPlayerAccount(source)
	local accountData = getAccountName(account)
	if exports.bank:getPlayerBankMoney(source, "DONATE") >= 60 then
	local donateInPlayer = exports.bank:getAccountBankMoney(account, "DONATE")
	if donateInPlayer >= 60 then
			exports.bank:takeAccountBankMoney(account, 60, "DONATE")
			exports.vip:givePlayerVIP(getAccountName(account), 259200)
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы успешно купили премиум за 60 AW Coins", getTickCount(), 8000)
			exports.aw_server_logs:log("SHOP-PREMIUM", "Ник: "..getPlayerName (source).." Получил: Премиум подписку. Потратив 60 AW Coins.")
		else
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы сейчас не можете это купить", getTickCount(), 8000)
		end
	else
		exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "У вас недостаточно AW Coins для покупки", getTickCount(), 8000)
	end
end
)



addEvent( "vip_3", true )
addEventHandler( "vip_3", root,
	function( player, DonateNumber)
    local account = getPlayerAccount(source)
	local accountData = getAccountName(account)
	if exports.bank:getPlayerBankMoney(source, "DONATE") >= 140 then
	local donateInPlayer = exports.bank:getAccountBankMoney(account, "DONATE")
	if donateInPlayer >= 140 then
			exports.bank:takeAccountBankMoney(account, 140, "DONATE")
			exports.vip:givePlayerVIP(getAccountName(account), 604800)
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы успешно купили премиум за 140 AW Coins", getTickCount(), 8000)
			exports.aw_server_logs:log("SHOP-PREMIUM", "Ник: "..getPlayerName (source).." Получил: Премиум подписку. Потратив 140 AW Coins.")
		else
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы сейчас не можете это купить", getTickCount(), 8000)
		end
	else
		exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "У вас недостаточно AW Coins для покупки", getTickCount(), 8000)
	end
end)




addEvent( "vip_4", true )
addEventHandler( "vip_4", root,
	function( player, DonateNumber)
    local account = getPlayerAccount(source)
	local accountData = getAccountName(account)
	if exports.bank:getPlayerBankMoney(source, "DONATE") >= 280 then
	local donateInPlayer = exports.bank:getAccountBankMoney(account, "DONATE")
	if donateInPlayer >= 280 then
			exports.bank:takeAccountBankMoney(account, 280, "DONATE")
			exports.vip:givePlayerVIP(getAccountName(account), 1209600)
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы успешно купили премиум за 280 AW Coins", getTickCount(), 8000)
			exports.aw_server_logs:log("SHOP-PREMIUM", "Ник: "..getPlayerName (source).." Получил: Премиум подписку. Потратив 280 AW Coins.")
		else
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы сейчас не можете это купить", getTickCount(), 8000)
		end
	else
		exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "У вас недостаточно AW Coins для покупки", getTickCount(), 8000)
	end
end)



addEvent( "vip_5", true )
addEventHandler( "vip_5", root,
	function( player, DonateNumber)
    local account = getPlayerAccount(source)
	local accountData = getAccountName(account)
	if exports.bank:getPlayerBankMoney(source, "DONATE") >= 420 then
	local donateInPlayer = exports.bank:getAccountBankMoney(account, "DONATE")
	if donateInPlayer >= 420 then
			exports.bank:takeAccountBankMoney(account, 420, "DONATE")
			exports.vip:givePlayerVIP(getAccountName(account), 1814400)
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы успешно купили премиум за 420 AW Coins", getTickCount(), 8000)
			exports.aw_server_logs:log("SHOP-PREMIUM", "Ник: "..getPlayerName (source).." Получил: Премиум подписку. Потратив 420 AW Coins.")
		else
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы сейчас не можете это купить", getTickCount(), 8000)
		end
	else
		exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "У вас недостаточно AW Coins для покупки", getTickCount(), 8000)
	end
end)


addEvent( "priv_1", true )
addEventHandler( "priv_1", root,
	function( player, DonateNumber)
    local account = getPlayerAccount(source)
	local accountData = getAccountName(account)
	local donateInPlayer = exports.bank:getAccountBankMoney(account, "DONATE")
	if donateInPlayer >= 200 then
		if not isExistPri (accountData) then
			exports.bank:takeAccountBankMoney(account, 200, "DONATE")
			exports.bank:giveAccountBankMoney(account, 500000000, "RUB")
			setPrivilege(account, "Moderator");
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы успешно купили привилегию за 200 AW Coins", getTickCount(), 8000)
			exports.aw_server_logs:log("SHOP-PRIV", "Ник: "..getPlayerName (source).." Получил: Привилегию Модератора. Потратив 200 AW Coins.")
		else
			exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "Вы сейчас не можете это купить", getTickCount(), 8000)
		end
	else
		exports.aw_interface_notify:showInfobox(source, "info", "Донат магазин", "У вас недостаточно AW Coins для покупки", getTickCount(), 8000)
	end
end
)