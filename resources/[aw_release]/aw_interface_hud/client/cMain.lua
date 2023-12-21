sw, sh = guiGetScreenSize()

zoom = 1
local baseX = 1920
local minZoom = 2
if sw < baseX then
  zoom = math.min(minZoom, baseX/sw)
end

sx,sy = guiGetScreenSize();
local px, py = sx/1920, sy/1080
screenW,screenH = (sx/px), (sy/py);


BoldBig = dxCreateFont("assets/Montserrat-Bold.ttf", 38*px)
Bold = dxCreateFont("assets/Montserrat-Bold.ttf", 24*px)
BoldMini = dxCreateFont("assets/Montserrat-Bold.ttf", 14*px)
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 19*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 36*px)
SemiBoldMini = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 36*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 14*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 10*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 10*px)

local Progress = 0
local moneyProgress = 0

local fps = 0
local nextTick = 0
function getCurrentFPS() 
    return math.floor(fps)
end

local function updateFPS(msSinceLastFrame)
    local now = getTickCount()
    if (now >= nextTick) then
        fps = (1 / msSinceLastFrame) * 1000
        nextTick = now + 1000
    end
end
addEventHandler("onClientPreRender", root, updateFPS)


local anim = false


setTimer( function()
--// Переменные
   -- if not getElementData(localPlayer, "login") then return end
    local health = math.floor(getElementHealth(localPlayer))
    local armor = math.floor(getPedArmor(localPlayer))

    local oxygen = math.floor(getPedOxygenLevel(localPlayer) / 10)
  
    local money = string.gsub(math.round(getPlayerMoney(localPlayer), 0), "^(-?%d+)(%d%d%d)", "%1 %2")
    local money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1 %2")
    local money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1 %2")
	local money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1 %2")
    local money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1 %2")
  
	local time = getRealTime()
	local year = time.year - 100
	local month = time.month + 1
	local day  =time.monthday
	if ( month < 10 ) then month = 0 .. month end
	if ( day < 10 ) then day = 0 .. day end
	local date = table.concat ( { year, month, day }, "-" )	
 
    local hours = time.hour
    local minutes = time.minute

	players = getElementsByType("player");

	name = getPlayerName(localPlayer)
    nickName = removeHex(name,6)
    local ammo = getPedTotalAmmo (localPlayer)
    local clip = getPedAmmoInClip (localPlayer)
    local weaponID = getPedWeapon(localPlayer)
    local weapName = getWeaponNameFromID(weaponID)

	local wantedLvl = getPlayerWantedLevel ( )
	
    vida = getElementHealth ( getLocalPlayer() ) + 0.60000152596

	local ID = getElementData(localPlayer,"ID") or 0

    if minutes <= 9 then
        minutes = "0"..minutes
    end
   
	if anim == true then
		Progress = Progress + 9
		if (Progress > 220) then
			Progress = 255 
		end
	elseif anim == false then
		Progress = Progress - 9
		if (Progress < 0) then
			Progress = 0
		end
	end

	local length = dxGetTextWidth(money, 1, SemiBold)
	local text_clan = "Отсутствует"

	if getPlayerTeam( localPlayer ) then
		local team     = getPlayerTeam( localPlayer )
		local teamName = getTeamName( team )
		local r, g, b  = getTeamColor( team )
		local teamPlayers = getPlayersInTeam ( team ) 

		text_clan = teamName
	end

	dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px,1080*py, "assets/aw_ui_hud_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)

	--dxDrawImage(sx/2-(-920/2)*px, sy/2-(530/2)*py, 450*px,47*py, "assets/aw_ui_hud_x2site.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)

	dxDrawImage(sx/2-(-1758/2)*px, sy/2-(980/2)*py, 28*px,34*py, "assets/aw_ui_hud_logotype.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)

	dxDrawText(getCurrentFPS().." fps / "..getPlayerPing(localPlayer).." ms. / "..nickName.." / "..text_clan, sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1720/2)*px,sy/2+(-1890/2)*py, tocolor(255, 255, 255, 255 - Progress), 1, MediumMini, "right", "center", false, false, false, true, false)

	dxDrawText(money, sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1685/2)*py, tocolor(255, 255, 255, 255 - Progress), 1, SemiBold, "right", "center", false, false, false, false, false)
	dxDrawImage(sx/2-(-1740/2) -length *px, sy/2-(870/2)*py, 31*px,31*py, "assets/aw_ui_hud_money.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)

	dxDrawText(clip.." / "..ammo, sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1750/2)*px,sy/2+(-1280/2)*py, tocolor(255, 255, 255, 255 - Progress), 1, SemiBoldMini, "right", "center", false, false, false, false, false)
	dxDrawText(weapName, sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1750/2)*px,sy/2+(-1200/2)*py, tocolor(200, 200, 200, 255 - Progress), 1, Regular, "right", "center", false, false, false, false, false)

	dxDrawImage(sx/2-(-1781/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	dxDrawImage(sx/2-(-1726/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	dxDrawImage(sx/2-(-1674/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	dxDrawImage(sx/2-(-1622/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	dxDrawImage(sx/2-(-1570/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	dxDrawImage(sx/2-(-1516/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star2.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)

	dxDrawImage(sx/2-(-1781/2)*px, sy/2-(640/2)*py, 19*px,19*py, "assets/aw_ui_hud_ammo.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)

	if wantedLvl == 1 then
		dxDrawImage(sx/2-(-1781/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	end
	if wantedLvl == 2 then
		dxDrawImage(sx/2-(-1781/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1726/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	end
	if wantedLvl == 3 then
		dxDrawImage(sx/2-(-1781/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1726/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1674/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	end
	if wantedLvl == 4 then
		dxDrawImage(sx/2-(-1781/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1726/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1674/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1622/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	end
	if wantedLvl == 5 then
		dxDrawImage(sx/2-(-1781/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1726/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1674/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1622/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1570/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	end
	if wantedLvl == 6 then
		dxDrawImage(sx/2-(-1781/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1726/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1674/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1622/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1570/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
		dxDrawImage(sx/2-(-1516/2)*px, sy/2-(748/2)*py, 17*px,16*py, "assets/aw_ui_hud_star1.png", 0, 0, 0, tocolor(255, 255, 255, 255 - Progress), false)
	
	end
end, 0, 0)

function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')   
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function ()
   	setPlayerHudComponentVisible ( "all", false )
   	setPlayerHudComponentVisible( "radar",false)
   	setPlayerHudComponentVisible ( "crosshair", true )
end)

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

function anim_true()
	anim = true
end
addEvent("anim_true", true)
addEventHandler("anim_true", root, anim_true)

function anim_false()
	anim = false
end
addEvent("anim_false", true)
addEventHandler("anim_false", root, anim_false)

function getPedMaxHealth(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ 'getPedMaxHealth' [Expected ped/player at argument 1, got " .. tostring(ped) .. "]")
    local stat = getPedStat(ped, 24)
    local maxhealth = 100 + (stat - 569) / 4.31
    return math.max(1, maxhealth)
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

function removeHex (s)
	if type (s) == "string" then
		while (s ~= s:gsub ("#%x%x%x%x%x%x", "")) do
			s = s:gsub ("#%x%x%x%x%x%x", "")
		end
	end
	return s or false
end

