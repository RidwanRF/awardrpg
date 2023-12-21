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
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 13*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 19*px)
SemiBoldMini = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
SemiBoldMini2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 19*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 13*px)
RegularMini = dxCreateFont("assets/Montserrat-Regular.ttf", 10*px)


local teams = {}

local menuVisible = false
local isButtonClick = false
local COLOR_STATE, COLOR_HOVER, tick, state, COLOR_STATECASE, COLOR_HOVERCASE
local alpha = 0
local milisecond = 0
local second = 0
local minuta = 0 

local posDist = 0
local posDistSound = 0
local posDistY = 0
local tickBackSpace = 0

local posDist2 = 0
local posDistSound2 = 0
local posDistY2 = 0

local posDist3 = 0
local posDistSound3 = 0
local posDistY3 = 0

local selectSection = 1
local selectionSetting = 1
local selectSection_info = 1
local selectSectionBonus = 1

local promoText = "Введите промокод"
local activePromoText = false

local scroll = 0
local scrollMax = 0

local scrollGPS = 0
local scrollMaxGPS = 0

local scrollText = 0
local scrollMaxText = 0

local ConverText = "Введите сумму"
local activeConverMoney = false
local RubleConverText = 0

local nameAccount = "N/A"

local tableSave = {}

local tableRoll = {}

local conf = {
	code = "",
	count = 0,
	money = 0,
	donate = 0,
}


local assets = {
 
    activate1 = dxCreateTexture ("assets/aw_ui_dashboard_button_activate1.png"),
    activate2 = dxCreateTexture ("assets/aw_ui_dashboard_button_activate2.png"),

    death1 = dxCreateTexture ("assets/aw_ui_dashboard_button_death1.png"),
    death2 = dxCreateTexture ("assets/aw_ui_dashboard_button_death2.png"),

    editbox1 = dxCreateTexture ("assets/aw_ui_dashboard_button_editbox1.png"),
    editbox2 = dxCreateTexture ("assets/aw_ui_dashboard_button_editbox2.png"),

    moto1 = dxCreateTexture ("assets/aw_ui_dashboard_button_moto1.png"),
    moto2 = dxCreateTexture ("assets/aw_ui_dashboard_button_moto2.png"),

    rating1 = dxCreateTexture ("assets/aw_ui_dashboard_button_rating1.png"),
    rating2 = dxCreateTexture ("assets/aw_ui_dashboard_button_rating2.png"),

    repair1 = dxCreateTexture ("assets/aw_ui_dashboard_button_repair1.png"),
    repair2 = dxCreateTexture ("assets/aw_ui_dashboard_button_repair2.png"),

    report1 = dxCreateTexture ("assets/aw_ui_dashboard_button_report1.png"),
    report2 = dxCreateTexture ("assets/aw_ui_dashboard_button_report2.png"),

	premium1d1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium1d1.png"),
    premium1d2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium1d2.png"),

	premium3d1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium3d1.png"),
    premium3d2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium3d2.png"),

	premium7d1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium7d1.png"),
    premium7d2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium7d2.png"),

	premium14d1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium14d1.png"),
    premium14d2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium14d2.png"),

	premium21d1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium21d1.png"),
    premium21d2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_premium21d2.png"),
	
	juniormoder1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_juniormoder1.png"),
    juniormoder2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_juniormoder2.png"),
		
	moder1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_moder1.png"),
    moder2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_moder2.png"),
		
	chiefmoder1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_chiefmoder1.png"),
    chiefmoder2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_chiefmoder2.png"),
		
	junioradmin1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_junioradmin1.png"),
    junioradmin2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_junioradmin2.png"),
		
	admin1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_admin1.png"),
    admin2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_admin2.png"),
		
	chiefadmin1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_chiefadmin1.png"),
    chiefadmin2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_chiefadmin2.png"),
		
	upgrade1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_upgrade1.png"),
    upgrade2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_upgrade2.png"),

	buy1 = dxCreateTexture ("assets/aw_ui_dashboard_shop_button_buy1.png"),
    buy2 = dxCreateTexture ("assets/aw_ui_dashboard_shop_button_buy2.png"),
		
	back1 = dxCreateTexture ("assets/aw_ui_dashboard_button_back1.png"),
    back2 = dxCreateTexture ("assets/aw_ui_dashboard_button_back2.png"),


}


function creatTextOrNothing ()
	renderTargets = {
		[1] = dxCreateRenderTarget (1766*px, 818*py, true),
	}
	
	imgRender = {
		bgCase = dxCreateTexture("images/case/bgCase.png"),
		HoveverCase = dxCreateTexture("images/case/HoveverCase.png"),
		bgMainCase = dxCreateTexture("images/case/bgMainCase.png"),
		bgPrize = dxCreateTexture("images/case/bgPrize.png"),
		ButtonCase = dxCreateTexture("images/case/button.png"),
		effect = dxCreateTexture("images/case/effect.png"),
		PrizeBgMain = dxCreateTexture("images/case/PrizeBgMain.png"),
		BgPrizeGive = dxCreateTexture("images/case/BgPrizeGive.png"),
	
		a_button = dxCreateTexture("images/referals/a_button.png"),
		a_button_alpha = dxCreateTexture("images/referals/a_button_alpha.png"),
		EditBox = dxCreateTexture("images/referals/EditBox.png"),
		EditRef = dxCreateTexture("images/referals/EditRef.png"),
		main = dxCreateTexture("images/referals/main.png"),
		progress = dxCreateTexture("images/referals/progress.png"),
		v_button = dxCreateTexture("images/referals/v_button.png"),
		v_button_alpha = dxCreateTexture("images/referals/v_button_alpha.png"),
	
		Box = dxCreateTexture("images/settings/Box.png"),
		CheksBoxes = dxCreateTexture("images/settings/CheksBoxes.png"),
		Rectengle = dxCreateTexture("images/settings/Rectengle.png"),
		SelectionSettings = dxCreateTexture("images/settings/SelectionSettings.png"),
		buttonSetting = dxCreateTexture("images/settings/buttonSetting.png"),
	
		ApplyPromo = dxCreateTexture("images/promo/ApplyPromo.png"),
		EditeBoxPromo = dxCreateTexture("images/promo/EditeBoxPromo.png"),
		PlusForApply = dxCreateTexture("images/promo/PlusForApply.png"),
		recteglePromo = dxCreateTexture("images/promo/recteglePromo.png"),
	
		Adm = dxCreateTexture("images/magazin/button/Adm.png"),
		Cars = dxCreateTexture("images/magazin/button/Cars.png"),
		Keysi = dxCreateTexture("images/magazin/button/Keysi.png"),
		Konvert = dxCreateTexture("images/magazin/button/Konvert.png"),
		Ocoboe = dxCreateTexture("images/magazin/button/Ocoboe.png"),
		VIP = dxCreateTexture("images/magazin/button/VIP.png"),
	
		bg2car = dxCreateTexture("images/magazin/bg2car.png"),
		bg3car = dxCreateTexture("images/magazin/bg3car.png"),
		bgcar = dxCreateTexture("images/magazin/bgcar.png "),
		bg4car = dxCreateTexture("images/magazin/bg4car.png"),
		bg5car = dxCreateTexture("images/magazin/bg5car.png "),
		bgpokypka = dxCreateTexture("images/magazin/bgpokypka.png "),
	
		bgvip = dxCreateTexture("images/magazin/bgvip.png "),
		bg1vip = dxCreateTexture("images/magazin/bg1vip.png "),
	
		bgkonv = dxCreateTexture("images/magazin/bgkonv.png "),
		bg1konv = dxCreateTexture("images/magazin/bg1konv.png "),
	}

	fonts = {

		[1] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 13*px);
		[2] = dxCreateFont("assets/Montserrat-Medium.ttf", 6*px);
		[3] = dxCreateFont("assets/Montserrat-Medium.ttf", 8*px);
		[4] = dxCreateFont("assets/Montserrat-Medium.ttf", 9*px);
		[5] = dxCreateFont("assets/Montserrat-Medium.ttf", 10*px);
		[6] = dxCreateFont("assets/Montserrat-Medium.ttf", 25*px);
		[7] = dxCreateFont("assets/Montserrat-Medium.ttf", 15*px);
		[8] = dxCreateFont("assets/Montserrat-Medium.ttf", 13*px);
		[9] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 21*px);
		[10] = dxCreateFont("assets/Montserrat-Medium.ttf", 13*px);
		[11] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 13*px);
		[12] = dxCreateFont("assets/Montserrat-Medium.ttf", 10*px);
		[13] = dxCreateFont("assets/Montserrat-Medium.ttf", 18*px);
		[14] = dxCreateFont("assets/Montserrat-SemiBold.ttf", 9*px);

		[25] = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px);
		[26] = dxCreateFont("assets/Montserrat-Medium.ttf", 10.5*px);

	}
end

function closingEveryThing()
	for i, img in pairs(imgRender) do
		destroyElement(img)
	end
	for i, font in ipairs(fonts) do
		destroyElement(font)
	end
	for i, rt in ipairs(renderTargets) do
		destroyElement(rt)
	end

	renderTargets = nil
	fonts = nil
	imgRender = nil
end

addEvent("startLoging", true)
addEventHandler("startLoging", resourceRoot, function (loginPerson)
	nameAccount = loginPerson
end)

local state2 = false;

local tick2 = nil;
local tickRefresh = nil;

local rotation2 = 0;
local alpha3 = 0;
local stateAnim = false

local tickstranica, stranica

function freeroam ()

	if state2 then
        if tick2 then
            rotation2 = interpolateBetween(
                rotation2, 0, 0,
                1440, 0, 0,
                ( getTickCount() - tick2 ) / 16000, "InOutQuad"
            );

            alpha3 = interpolateBetween(
                alpha3, 0, 0,
                255, 0, 0,
                ( getTickCount() - tick2 ) / 1000, "InOutQuad"
            );

            if rotation2 >= 1439 then
                if not tickRefresh then
                    tickRefresh = getTickCount();
                    state2 = false;
                end
            end
        end
    else
        if tickRefresh then
            alpha3 = interpolateBetween(
                alpha3, 0, 0,
                0, 0, 0,
                ( getTickCount() - tickRefresh ) / 700, "InOutQuad"
            );

            if alpha3 <= 1 then
                tick2 = nil;
                tickRefresh = nil;
                
                state2 = true;
                rotation2 = 0;
                stateAnim = false
            end
        end
    end

	if tick then
		if state then
			alpha, alpha2 = interpolateBetween(0,0,0,255,50,0, (getTickCount() - tick)/500, "OutQuad")
		else
			alpha, alpha2 = interpolateBetween(255,50,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")
		end
	end

	if tickstranica then
		if stranica then
			alpha4, alpha5 = interpolateBetween(0,0,0,255,50,0, (getTickCount() - tickstranica)/500, "OutQuad")
		else
			alpha4, alpha5 = interpolateBetween(255,50,0,0,0,0, (getTickCount() - tickstranica)/500, "OutQuad")
		end
	end

	COLOR_STATE = tocolor(255, 255, 255, alpha4)
	COLOR_HOVER = tocolor(255, 255, 255, alpha4)

	local Donate = (exports.bank:getPlayerBankMoney("DONATE") or 0) 

	local playerName = getPlayerName(localPlayer)

	local isVIP = isResourceRunning("vip") and exports.vip:getVIPsTable()
    local VIP = "Нет"

    if isVIP then 
		VIP = "Есть" -- yes
	else 
	 	VIP = "Нет" -- no
	end
    dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/aw_ui_dashboard_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

	
    dxDrawText("vk.com/awardmta", sx/2-(1720/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBold, "left", "center", false, false, false, false, false)
    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(805/2)*py, 1720*px, 1*py, tocolor(255, 255, 255, 67* (alpha/255)), false)
	
	dxDrawImage(sx/2-(-1690/2)*px, sy/2-(943/2)*py, 13*px, 17*py, "assets/aw_ui_dashboard_logotype.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
	local BankRUB = (exports.bank:getPlayerBankMoney("RUB") or 0) 
	
		
	local wDonate = dxGetTextWidth(convertNumber(Donate).." AW", 1, SemiBoldMini);
	dxDrawText(convertNumber(Donate).." AW", sx/2-(-1600/2)*px, sy/2+(-170/2)*py,  sx/2-(-1630/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini, "right", "center", false, false, false, false, false)
	dxDrawImage(sx/2-(-1560/2) - wDonate*px, sy/2-(950/2)*py, 26*px, 25*py, "assets/aw_ui_dashboard_awcoins1.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

	local wRub = dxGetTextWidth(convertNumber(BankRUB))
	dxDrawText(convertNumber(BankRUB), sx/2-(-1300/2)*px, sy/2+(-170/2)*py,  sx/2-(-1520/2) - wDonate*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini, "right", "center", false, false, false, false, false)
	dxDrawImage(sx/2-(-1405/2) - wRub - wDonate*px, sy/2-(950/2)*py, 26*px, 25*py, "assets/aw_ui_dashboard_money1.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)


	local x = 0
	for key, section in ipairs(sectionMenu) do -- сюда

	if isCursorOverRectangle(sx/2-(1347/2)*px, sy/2-(935/2)*py, 80*px, 15*py) then 
		if getKeyState("mouse1") and not isButtonClick and not active then
			selectSection = 1
		end
	end
	if isCursorOverRectangle(sx/2-(1100/2)*px, sy/2-(935/2)*py, 80*px, 15*py) then
		if getKeyState("mouse1") and not isButtonClick and not active then
			selectSection = 2
		end
	end
	if isCursorOverRectangle(sx/2-(850/2)*px, sy/2-(935/2)*py, 210*px, 15*py) then 
		if getKeyState("mouse1") and not isButtonClick and not active then
			selectSection = 3
		end
	end
	if isCursorOverRectangle(sx/2-(330/2)*px, sy/2-(935/2)*py, 90*px, 15*py) then 
		if getKeyState("mouse1") and not isButtonClick and not active then
			selectSection = 4
		end
	end
	if isCursorOverRectangle(sx/2-(40/2)*px, sy/2-(935/2)*py, 90*px, 15*py) then 
		if getKeyState("mouse1") and not isButtonClick and not active then
			selectSection = 5
		end
	end


	  	if isCursorOverRectangle(89990*px+x, 1099990*px+alpha2, 0*px, 0*py, section[2]) then
			if getKeyState("mouse1") and not isButtonClick then
				if key ~= selectSection then
					tickstranica = getTickCount()
					startTick = nil
					needY = x
					if alpha4 ~= 0 then
						stranica = nil
					end
					keys = key
				end
			end
		end
		if alpha4 == 0 then
			tickstranica = getTickCount()
			stranica = true
			selectSection = keys or 1
		end
		x = x + 210*px
	end

	if needY then
		if not startTick then startTick = getTickCount() newY = posDistY end
		local val2 = interpolateBetween (newY, 0, 0, needY, 0, 0, (getTickCount()-startTick)/500, "OutQuad")
		posDistY = val2

		if val2 == needY then
			startTick = nil
			needY = nil
		end
	end

	if selectSection == 1 then
		local money = convertNumber (getPlayerMoney())
		local BankRUB = (exports.bank:getPlayerBankMoney("RUB") or 0) 
	
		local text_clan = "Отсутствует"

		
		local deaths = getElementData(localPlayer, "T/D", tonumber("totalkillsdeaths.Deaths")) or 0;
		local kills = getElementData(localPlayer, "T/K", tonumber("totalkillsdeaths.Kills")) or 0;
		local stage = getElementData (localPlayer, "timePlayed") or 0;
		local timePlayedSession = getElementData (localPlayer, "timePlayedSession") or 0 
		local drift = getElementData(localPlayer, "bestDrift") or 0;
		local slots = getElementData(localPlayer, "customSlots") or 0;
		local name = getPlayerName(localPlayer)
		local nickName = removeHex(name,6)

	dxDrawRectangle(sx/2-(1347/2)*px, sy/2-(805/2)*py, 90*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)

	dxDrawImage(sx/2-(1720/2)*px, sy/2-(306/2)*py, 1720*px, 11*py, "assets/aw_ui_dashboard_other1.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
	dxDrawImage(sx/2-(1720/2)*px, sy/2-(-200/2)*py, 1720*px, 11*py, "assets/aw_ui_dashboard_other2.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
	dxDrawImage(sx/2-(1720/2)*px, sy/2-(-520/2)*py, 1720*px, 11*py, "assets/aw_ui_dashboard_other3.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
		
	dxDrawImage(sx/2-(1720/2)*px, sy/2-(700/2)*py, 40*px, 49*py, "assets/aw_ui_dashboard_character.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

    dxDrawText(nickName, sx/2-(1540/2)*px, sy/2+(415/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "left", "center", false, false, false, false, false)

    dxDrawText("Рейтинг Award", sx/2-(1540/2)*px, sy/2+(284/2)*py,  sx/2-(-1730/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "right", "center", false, false, false, false, false)
    dxDrawText(deaths+kills, sx/2-(1540/2)*px, sy/2+(410/2)*py,  sx/2-(-1648/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "right", "center", false, false, false, false, false)

    local w = dxGetTextWidth(nickName, 1, SemiBoldBig);
	dxDrawImage(sx/2-(1500/2) + w*px, sy/2-(640/2)*py, 17*px,17*py, "assets/aw_ui_dashboard_copy.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

    dxDrawText("Участники:", sx/2-(920/2)*px, sy/2+(2320/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "left", "center", false, false, false, false, false)
    dxDrawText("Будет доступно в клановом обновлении", sx/2-(735/2)*px, sy/2+(2320/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
    dxDrawText("Клановый рейтинг:", sx/2-(920/2)*px, sy/2+(2480/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "left", "center", false, false, false, false, false)
    dxDrawText("Будет доступно в клановом обновлении", sx/2-(610/2)*px, sy/2+(2480/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini, "left", "center", false, false, false, false, false)


	if getPlayerTeam( localPlayer ) then
		local team     = getPlayerTeam( localPlayer )
		local teamName = getTeamName( team )
		local r, g, b  = getTeamColor( team )
		local teamPlayers = getPlayersInTeam ( team ) 

		text_clan = teamName
	end

    dxDrawText(text_clan, sx/2-(1530/2)*px, sy/2+(2400/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "left", "center", false, false, false, true, false)
    dxDrawText(text_clan, sx/2-(1540/2)*px, sy/2+(284/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "left", "center", false, false, false, false, false)

	dxDrawButton(sx/2-(-1676/2)*px, sy/2-(648/2)*py, 22*px,22*py, assets.rating1, assets.rating2, 1) 

	dxDrawButton(sx/2-(1720/2)*px, sy/2-(504/2)*py, 158*px,50*py, assets.moto1, assets.moto2, 2) 

	dxDrawButton(sx/2-(1370/2)*px, sy/2-(504/2)*py, 202*px,50*py, assets.report1, assets.report2, 3)  

	dxDrawButton(sx/2-(924/2)*px, sy/2-(504/2)*py, 98*px,50*py, assets.death1, assets.death2, 4) 

	dxDrawButton(sx/2-(690/2)*px, sy/2-(504/2)*py, 200*px,50*py, assets.repair1, assets.repair2, 5)   

	dxDrawButton(sx/2-(1720/2)*px, sy/2-(-768/2)*py, 202*px,50*py, assets.editbox1, assets.editbox2, 6)   

	dxDrawButton(sx/2-(1274/2)*px, sy/2-(-768/2)*py, 50*px,49*py, assets.activate1, assets.activate2, 7)   

	dxDrawImage(sx/2-(1720/2)*px, sy/2-(-320/2)*py, 46*px,46*py, "assets/aw_ui_dashboard_noicon.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

    dxDrawText("Если у вас имеется бонус-код, то Введите его в поле ниже для активации", sx/2-(1720/2)*px, sy/2+(3000/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "left", "center", false, false, false, false, false)

    dxDrawText(promoText, sx/2-(1720/2)*px, sy/2+(3310/2)*py,  sx/2-(1310/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini2, "center", "center", false, false, false, false, false)

    dxDrawText("Главная", sx/2-(1320/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Магазин", sx/2-(1095/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Реферальная программа", sx/2-(850/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Навигация", sx/2-(325/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Настройки", sx/2-(40/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)

    dxDrawText("Всего отыграно часов", sx/2-(1720/2)*px, sy/2+(1305/2)*py,  sx/2-(1390/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(stage, sx/2-(1616/2)*px, sy/2+(1428/2)*py,  sx/2-(1490/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Игровой уровень", sx/2-(1220/2)*px, sy/2+(1305/2)*py,  sx/2-(1050/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText("1 lvl", sx/2-(1140/2)*px, sy/2+(1428/2)*py,  sx/2-(1150/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Кол-во убийств", sx/2-(800/2)*px, sy/2+(1305/2)*py,  sx/2-(700/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(kills, sx/2-(760/2)*px, sy/2+(1428/2)*py,  sx/2-(750/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Кол-во смертей", sx/2-(400/2)*px, sy/2+(1305/2)*py,  sx/2-(370/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(deaths, sx/2-(340/2)*px, sy/2+(1428/2)*py,  sx/2-(450/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Парковочных мест в гараже", sx/2-(400/2)*px, sy/2+(1305/2)*py,  sx/2-(-550/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(slots, sx/2-(340/2)*px, sy/2+(1428/2)*py,  sx/2-(-470/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Текущая сессия игры на сервере", sx/2-(400/2)*px, sy/2+(1305/2)*py,  sx/2-(-1730/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(timePlayedSession, sx/2-(340/2)*px, sy/2+(1428/2)*py,  sx/2-(-1650/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Состояние донат счета", sx/2-(1720/2)*px, sy/2+(1710/2)*py,  sx/2-(1390/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(convertNumber(Donate).." AW", sx/2-(1616/2)*px, sy/2+(1850/2)*py,  sx/2-(1490/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Состояние счета в банке", sx/2-(1720/2)*px, sy/2+(1710/2)*py,  sx/2-(290/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText("$ "..convertNumber(BankRUB), sx/2-(1616/2)*px, sy/2+(1850/2)*py,  sx/2-(400/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

    dxDrawText("Рекорд дрифта", sx/2-(1720/2)*px, sy/2+(1710/2)*py,  sx/2-(-900/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(convertNumber(drift), sx/2-(1616/2)*px, sy/2+(1850/2)*py,  sx/2-(-800/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

	dxDrawText("Логин аккаунта", sx/2-(1720/2)*px, sy/2+(1710/2)*py,  sx/2-(-2400/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Medium, "center", "center", false, false, false, false, false)
    dxDrawText(nameAccount, sx/2-(1616/2)*px, sy/2+(1850/2)*py,  sx/2-(-2300/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "center", "center", false, false, false, false, false)

	if isCursorOverRectangle(sx/2-(1500/2) + w*px, sy/2-(640/2)*py, 17*px,17*py) then
		if getKeyState("mouse1") and not isButtonClick and not active then
			setClipboard (nickName)
			exports.aw_interface_notify:showInfobox("info", "Главное меню", "Вы успешно скопировали свой никнейм", getTickCount(), 8000)
		end
	end


	if isCursorOverRectangle(sx/2-(-1676/2)*px, sy/2-(648/2)*py, 22*px,22*py) then

			dxDrawImage(sx/2-(-190/2)*px, sy/2-(500/2)*py, 769*px,43*py, "assets/aw_ui_dashboard_ratinginfo.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

		end


		if isCursorOverRectangle(sx/2-(924/2)*px, sy/2-(504/2)*py, 98*px,50*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				triggerServerEvent ("event", localPlayer, localPlayer, "kill")
				exports.aw_interface_notify:showInfobox("info", "Главное меню", "Вы погибли", getTickCount(), 8000)
			end
		end

		if isCursorOverRectangle(sx/2-(690/2)*px, sy/2-(504/2)*py, 200*px,50*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				if getPedOccupiedVehicle(localPlayer) ~= nil then
					triggerServerEvent ("event", localPlayer, getPedOccupiedVehicle(localPlayer), "fix")
					exports.aw_interface_notify:showInfobox("info", "Главное меню", "Вы успешно восстановили транспорт", getTickCount(), 8000)
				end
			end
		end

		if isCursorOverRectangle(sx/2-(690/2)*px, sy/2-(504/2)*py, 200*px,50*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				if getPedOccupiedVehicle(localPlayer) ~= nil then
					triggerServerEvent ("event", localPlayer, getPedOccupiedVehicle(localPlayer), "recover")
					exports.aw_interface_notify:showInfobox("info", "Главное меню", "Вы успешно восстановили транспорт", getTickCount(), 8000)
				end
			end
		end


		if isCursorOverRectangle(sx/2-(1720/2)*px, sy/2-(504/2)*py, 158*px,50*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
					if canPedBeKnockedOffBike ( localPlayer ) then
        		setPlayerCanBeKnockedOffBike ( localPlayer, false )
				exports.aw_interface_notify:showInfobox("info", "Главное меню", "Падение с мотоцикла успешно включено!", getTickCount(), 8000)
   			 else
        		setPlayerCanBeKnockedOffBike ( localPlayer, true )
				exports.aw_interface_notify:showInfobox("info", "Главное меню", "Падение с мотоцикла успешно выключено!", getTickCount(), 8000)
   			       end
		    end
		end

	
		if isCursorOverRectangle(sx/2-(1370/2)*px, sy/2-(504/2)*py, 202*px,50*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				executeCommandHandler("report")
			end
		end

		if isCursorOverRectangle(sx/2-(1274/2)*px, sy/2-(-768/2)*py, 50*px,49*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				if promoText ~= "Введите промокод" then
					triggerEvent("CheckPromoCode", root, promoText)
				end
			end
		end

		if activePromoText then
			local w = dxGetTextWidth (promoText, 1, fonts[1])
	
			if getKeyState ("backspace") then
				if getTickCount() - tickBackSpace > 100 then
					promoText = utf8.sub (promoText, 1, utf8.len(promoText) - 1)
					tickBackSpace = getTickCount()
				end
			end
		end

		if isCursorOverRectangle(sx/2-(1720/2)*px, sy/2-(-768/2)*py, 202*px,50*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				activePromoText = true
				guiSetInputMode ("no_binds")
				if promoText == "Введите промокод" then
					promoText = ""
				end
			end
		else
			if getKeyState("mouse1") and not isButtonClick and not active then
				activePromoText = nil
				if not activePromoText then guiSetInputMode ("allow_binds") end
				if promoText:gsub (" ", "") == "" then
					promoText = "Введите промокод"
				end
			end
		end


    end


    if selectSection == 2 then
			


		local BankRUB = (exports.bank:getPlayerBankMoney("RUB") or 0) 

	dxDrawRectangle(sx/2-(1115/2)*px, sy/2-(805/2)*py, 90*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)

    dxDrawText("Главная", sx/2-(1320/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Магазин", sx/2-(1095/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Реферальная программа", sx/2-(850/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Навигация", sx/2-(325/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText("Настройки", sx/2-(40/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)


    	if not selectionmagaz then
			selectionmagaz = 0
		end

		if not selectmagazinebat then
			selectmagazinebat = 1
		end

		if selectmagazinebat == 1 then

		dxDrawText("Лучшее", sx/2-(1625/2)*px, sy/2+(290/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Привилегии", sx/2-(1400/2)*px, sy/2+(290/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67	* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)

		dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(577/2)*py, 1720*px, 1*py, tocolor(255, 255, 255, 67* (alpha/255)), false)
			
		dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(577/2)*py, 170*px, 1*py, tocolor(114, 156, 86, 255* (alpha/255)), false)

		dxDrawImage(sx/2-(1720/2)*px, sy/2-(480/2)*py, 1702*px, 85*py, "assets/aw_ui_dashboard_shop_best_premiumtext.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

		dxDrawButton(sx/2-(1720/2)*px, sy/2-(200/2)*py, 279*px,279*py, assets.premium1d1, assets.premium1d2, 8)   
		dxDrawButton(sx/2-(1145/2)*px, sy/2-(200/2)*py, 279*px,279*py, assets.premium3d1, assets.premium3d2, 9)   
		dxDrawButton(sx/2-(567/2)*px, sy/2-(200/2)*py, 279*px,279*py, assets.premium7d1, assets.premium7d2, 10)   
		dxDrawButton(sx/2-(-8/2)*px, sy/2-(200/2)*py, 279*px,279*py, assets.premium14d1, assets.premium14d2, 11)   
		dxDrawButton(sx/2-(-585/2)*px, sy/2-(200/2)*py, 279*px,279*py, assets.premium21d1, assets.premium21d2, 12)  

								
        -- Премиум на 1 день
		if isCursorOverRectangle(sx/2-(1720/2)*px, sy/2-(200/2)*py, 279*px,279*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				triggerServerEvent("vip_1",localPlayer)
			end
		end						
		-- Премиум на 3 дня
		if isCursorOverRectangle(sx/2-(1145/2)*px, sy/2-(200/2)*py, 279*px,279*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				triggerServerEvent("vip_2",localPlayer)
			end
		end						
		-- Премиум на 7 дней
		if isCursorOverRectangle(sx/2-(567/2)*px, sy/2-(200/2)*py, 279*px,279*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				triggerServerEvent("vip_3",localPlayer)
			end
		end						
		-- Премиум на 14 дней
		if isCursorOverRectangle(sx/2-(-8/2)*px, sy/2-(200/2)*py, 279*px,279*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				triggerServerEvent("vip_4",localPlayer)
			end
		end						
		-- Премиум на 21 день
		if isCursorOverRectangle(sx/2-(-585/2)*px, sy/2-(200/2)*py, 279*px,279*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				triggerServerEvent("vip_5",localPlayer)
			end
		end		
		if isCursorOverRectangle(sx/2-(1700/2)*px, sy/2-(705/2)*py, 120*px, 16*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
					selectmagazinebat = 1
			end
		end
		if isCursorOverRectangle(sx/2-(1390/2)*px, sy/2-(705/2)*py, 120*px, 16*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
					selectmagazinebat = "Adminstat"
			end
		end

	end
	

		if selectmagazinebat == "Adminstat" then	

		if isCursorOverRectangle(sx/2-(1700/2)*px, sy/2-(705/2)*py, 120*px, 16*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
					selectmagazinebat = 1
			end
		end
		if isCursorOverRectangle(sx/2-(1390/2)*px, sy/2-(705/2)*py, 120*px, 16*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
					selectmagazinebat = "Adminstat"
			end
		end


				--    dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px, 1080*py, "assets/helper.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)


					dxDrawText("Лучшее", sx/2-(1625/2)*px, sy/2+(290/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67 * (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
					dxDrawText("Привилегии", sx/2-(1400/2)*px, sy/2+(290/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)

					dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(577/2)*py, 1720*px, 1*py, tocolor(255, 255, 255, 67* (alpha/255)), false)
					
					dxDrawRectangle(sx/2-(1465/2)*px, sy/2-(577/2)*py, 170*px, 1*py, tocolor(114, 156, 86, 255* (alpha/255)), false)

					dxDrawText("Обычные привилегии", sx/2-(1720/2)*px, sy/2+(750/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumBig, "left", "center", false, false, false, false, false)
			--		dxDrawText("Улучшенные привилегии", sx/2-(1720/2)*px, sy/2+(2350/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumBig, "left", "center", false, false, false, false, false)
			--		dxDrawText("*Функционал админки такой же как и у обычных привилегий", sx/2-(-680/2)*px, sy/2+(2350/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67 * (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
			
					
		dxDrawButton(sx/2-(1720/2)*px, sy/2-(340/2)*py, 279*px,279*py, assets.juniormoder1, assets.juniormoder2, 13)   
	--	dxDrawButton(sx/2-(1145/2)*px, sy/2-(340/2)*py, 279*px,279*py, assets.moder1, assets.moder2, 14)   
	--	dxDrawButton(sx/2-(567/2)*px, sy/2-(340/2)*py, 279*px,279*py, assets.chiefmoder1, assets.chiefmoder2, 15)   
	--	dxDrawButton(sx/2-(-8/2)*px, sy/2-(340/2)*py, 279*px,279*py, assets.junioradmin1, assets.junioradmin2, 16)   
	--	dxDrawButton(sx/2-(-585/2)*px, sy/2-(340/2)*py, 279*px,279*py, assets.admin1, assets.admin2, 17)  
	--	dxDrawButton(sx/2-(-1160/2)*px, sy/2-(340/2)*py, 279*px,279*py, assets.chiefadmin1, assets.chiefadmin2, 18)  

	--	dxDrawButton(sx/2-(1720/2)*px, sy/2-(-464/2)*py, 279*px,279*py, assets.upgrade1, assets.upgrade2, 19)  

					if isCursorOverRectangle(sx/2-(1720/2)*px, sy/2-(340/2)*py, 279*px,279*py)then
						if getKeyState("mouse1") and not isButtonClick and not active then
							case = k
							data = v
							selectmagazinebat = 5
						end
					end
					if isCursorOverRectangle(sx/2-(-1060/2)*px, sy/2-(-818/2)*py, 230*px, 58*py) then
						if getKeyState("mouse1") and not isButtonClick and not active then
							selectmagazinebat = 1
						end
					end
				end


			if selectmagazinebat == 5 then

				dxDrawImage(sx/2-(-955/2)*px, sy/2-(190/2)*py, 374*px, 372*py, "assets/aw_ui_dashboard_shop_1.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

				dxDrawButton(sx/2-(-1130/2)*px, sy/2-(340/2)*py, 198*px, 41*py, assets.back1, assets.back2, 20)  

				dxDrawButton(sx/2-(-1055/2)*px, sy/2-(-660/2)*py, 278*px, 52*py, assets.buy1, assets.buy2, 21)  
				dxDrawText("Приобрести привилегию за 200", sx/2-(-1100/2)*px, sy/2+(3095/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, SemiBoldMini2, "left", "center", false, false, false, false, false)
				dxDrawImage(sx/2-(-1550/2)*px, sy/2-(-700/2)*py, 13*px, 13*py, "assets/aw_ui_dashboard_awcoins2.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

				dxDrawText("Лучшее", sx/2-(1625/2)*px, sy/2+(290/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67 * (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
				dxDrawText("Привилегии", sx/2-(1400/2)*px, sy/2+(290/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)

				dxDrawText("Список предметов, которые вы получите после покупки привилегии", sx/2-(1720/2)*px, sy/2+(750/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumBig, "left", "center", false, false, false, false, false)

				dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(577/2)*py, 1720*px, 1*py, tocolor(255, 255, 255, 67* (alpha/255)), false)
				dxDrawRectangle(sx/2-(1465/2)*px, sy/2-(577/2)*py, 170*px, 1*py, tocolor(114, 156, 86, 255* (alpha/255)), false)

				-- 1 награда
				dxDrawRectangle(sx/2-(1600/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
				dxDrawText("Привилегия (Мл.Модер)", sx/2-(1660/2)*px, sy/2+(1800/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
				dxDrawText("Обычное", sx/2-(1660/2)*px, sy/2+(1910/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
				dxDrawImage(sx/2-(1720/2)*px, sy/2-(346/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
				dxDrawImage(sx/2-(1680/2)*px, sy/2-(260/2)*py, 187*px, 114*py, "assets/aw_ui_dashboard_shop_priv.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
				dxDrawImage(sx/2-(1720/2)*px, sy/2-(80/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)

				-- 2 награда
		        dxDrawRectangle(sx/2-(1110/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
				dxDrawText("$ 500 000 000", sx/2-(1170/2)*px, sy/2+(1800/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
				dxDrawText("Обычное", sx/2-(1170/2)*px, sy/2+(1910/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
				dxDrawImage(sx/2-(1226/2)*px, sy/2-(346/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
				dxDrawImage(sx/2-(1190/2)*px, sy/2-(260/2)*py, 187*px, 114*py, "assets/aw_ui_dashboard_shop_money.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
				dxDrawImage(sx/2-(1226/2)*px, sy/2-(80/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				
				-- 3 награда
			-----	dxDrawRectangle(sx/2-(692/2)*px, sy/2-(260/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		     -------   dxDrawRectangle(sx/2-(612/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
			----------	dxDrawText("1 Парковочное место", sx/2-(672/2)*px, sy/2+(1800/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			--------------------------	dxDrawText("Лимитированное", sx/2-(672/2)*px, sy/2+(1910/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			-------------------------	dxDrawImage(sx/2-(732/2)*px, sy/2-(346/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-----------------	dxDrawImage(sx/2-(732/2)*px, sy/2-(80/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				
				-- 4 награда
			----------	dxDrawRectangle(sx/2-(198/2)*px, sy/2-(260/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		    ---------    dxDrawRectangle(sx/2-(118/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-------------	dxDrawText("1 Парковочное место", sx/2-(178/2)*px, sy/2+(1800/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			-----------	dxDrawText("Лимитированное", sx/2-(178/2)*px, sy/2+(1910/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			----------	dxDrawImage(sx/2-(238/2)*px, sy/2-(346/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-------------	dxDrawImage(sx/2-(238/2)*px, sy/2-(80/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				
				-- 5 награда
			----------	dxDrawRectangle(sx/2-(-296/2)*px, sy/2-(260/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		     ---------   dxDrawRectangle(sx/2-(-376/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-----------	dxDrawText("1 Парковочное место", sx/2-(-316/2)*px, sy/2+(1800/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			---------	dxDrawText("Лимитированное", sx/2-(-316/2)*px, sy/2+(1910/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			---------	dxDrawImage(sx/2-(-256/2)*px, sy/2-(346/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-----------	dxDrawImage(sx/2-(-256/2)*px, sy/2-(80/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				
				-- 6 награда
			-----------	dxDrawRectangle(sx/2-(1680/2)*px, sy/2-(-320/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-------------	dxDrawRectangle(sx/2-(1600/2)*px, sy/2-(-770/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
			--------	dxDrawText("1 Парковочное место", sx/2-(1660/2)*px, sy/2+(2950/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			-----------------------	dxDrawText("Лимитированное", sx/2-(1660/2)*px, sy/2+(3070/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			--------------	dxDrawImage(sx/2-(1720/2)*px, sy/2-(-240/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
			--------------	dxDrawImage(sx/2-(1720/2)*px, sy/2-(-500/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)

				-- 7 награда
		  --------------      dxDrawRectangle(sx/2-(1190/2)*px, sy/2-(-320/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		    ------------    dxDrawRectangle(sx/2-(1110/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		----------------		dxDrawText("1 Парковочное место", sx/2-(1170/2)*px, sy/2+(2950/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			----------------------------	dxDrawText("Лимитированное", sx/2-(1170/2)*px, sy/2+(3070/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			---------	dxDrawImage(sx/2-(1226/2)*px, sy/2-(-240/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
			------	dxDrawImage(sx/2-(1226/2)*px, sy/2-(-500/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				
				-- 8 награда
			----------------	dxDrawRectangle(sx/2-(692/2)*px, sy/2-(-320/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		    ----------    dxDrawRectangle(sx/2-(612/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
			------------	dxDrawText("1 Парковочное место", sx/2-(672/2)*px, sy/2+(2950/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			-------	dxDrawText("Лимитированное", sx/2-(672/2)*px, sy/2+(3070/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			--------------	dxDrawImage(sx/2-(732/2)*px, sy/2-(-240/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-----------------	dxDrawImage(sx/2-(732/2)*px, sy/2-(-500/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				
				-- 9 награда
			--------------	dxDrawRectangle(sx/2-(198/2)*px, sy/2-(-320/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		    ------------    dxDrawRectangle(sx/2-(118/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
			--------------	dxDrawText("1 Парковочное место", sx/2-(178/2)*px, sy/2+(2950/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			--------------	dxDrawText("Лимитированное", sx/2-(178/2)*px, sy/2+(3070/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			----------------------------	dxDrawImage(sx/2-(238/2)*px, sy/2-(-240/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
				---------dxDrawImage(sx/2-(238/2)*px, sy/2-(-500/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				
				-- 10 награда
				----------dxDrawRectangle(sx/2-(-296/2)*px, sy/2-(-320/2)*py, 187*px, 114*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		      -------------  dxDrawRectangle(sx/2-(-376/2)*px, sy/2-(-192/2)*py, 110*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
				------------dxDrawText("1 Парковочное место", sx/2-(-316/2)*px, sy/2+(2950/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, MediumMini, "left", "center", false, false, false, false, false)
			------------	dxDrawText("Лимитированное", sx/2-(-316/2)*px, sy/2+(3070/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255 * (alpha/255)), 1, RegularMini, "left", "center", false, false, false, false, false)
			-----------	dxDrawImage(sx/2-(-256/2)*px, sy/2-(-240/2)*py, 229*px, 269*py, "assets/aw_ui_dashboard_shop_other.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
			-----------	dxDrawImage(sx/2-(-256/2)*px, sy/2-(-500/2)*py, 229*px, 138*py, "assets/aw_ui_dashboard_shop_light1.png", 0, 0, 0, tocolor(255, 255, 255, 30* (alpha/255)), false)
				

			if isCursorOverRectangle(sx/2-(-1130/2)*px, sy/2-(340/2)*py, 198*px, 41*py) then
				if getKeyState("mouse1") and not isButtonClick and not active then
					selectmagazinebat = "Adminstat"
				end
			end
				if isCursorOverRectangle(sx/2-(-1055/2)*px, sy/2-(-660/2)*py, 278*px, 52*py) then
					if getKeyState("mouse1") and not isButtonClick and not active then
						triggerServerEvent("priv_1",localPlayer)
					end
				end
			end
		end

	if selectSection == 3 then

		dxDrawRectangle(sx/2-(845/2)*px, sy/2-(805/2)*py, 210*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)

		dxDrawText("Главная", sx/2-(1320/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Магазин", sx/2-(1095/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Реферальная программа", sx/2-(850/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Навигация", sx/2-(325/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Настройки", sx/2-(40/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
	


		dxDrawImage(sx/2-(670/2)*px, sy/2-(400/2)*py+alpha5-50, 670*px, 60*py, imgRender.progress, 0, 0, 0, tocolor(255, 255, 255, alpha4), false)

		dxCreateText("НАГРАДЫ ДЛЯ ПРИГЛАШЕННЫХ", sx/2-(670/2)*px, sy/2-(700/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[1], "center", "center")

		-- / 2 ч
        dxCreateText("2", sx/2-(1170/2)*px, sy/2-(550/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        dxCreateText("Отыгранных\nчаса", sx/2-(1170/2)*px, sy/2-(490/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("Донат", sx/2-(1170/2)*px, sy/2-(320/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("< 20 AW >", sx/2-(1170/2)*px, sy/2-(270/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")

		-- / 10 ч
        dxCreateText("10", sx/2-(890/2)*px, sy/2-(550/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[4], "center", "center")
        dxCreateText("Отыгранных\nчасов", sx/2-(890/2)*px, sy/2-(490/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("Донат", sx/2-(890/2)*px, sy/2-(320/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("< 30 AW >", sx/2-(890/2)*px, sy/2-(270/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        
        -- / 15 ч
        dxCreateText("15", sx/2-(670/2)*px, sy/2-(550/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        dxCreateText("Отыгранных\nчасов", sx/2-(670/2)*px, sy/2-(490/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("Деньги", sx/2-(670/2)*px, sy/2-(320/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("< 500kk >", sx/2-(670/2)*px, sy/2-(270/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")

		-- / 30 ч
        dxCreateText("30", sx/2-(450/2)*px, sy/2-(550/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        dxCreateText("Отыгранных\nчасов", sx/2-(450/2)*px, sy/2-(490/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("Донат", sx/2-(450/2)*px, sy/2-(320/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("< 70 AW >", sx/2-(450/2)*px, sy/2-(270/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")

		-- / 50 ч
        dxCreateText("50", sx/2-(170/2)*px, sy/2-(550/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        dxCreateText("Отыгранных\nчасов", sx/2-(170/2)*px, sy/2-(490/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("Донат", sx/2-(170/2)*px, sy/2-(320/2*py)+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "center", "center")
		dxCreateText("< 130 AW >", sx/2-(170/2)*px, sy/2-(270/2)*py+alpha5-50, 670*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")

		dxDrawImage(sx/2-(700/2)*px, sy/2-(0/2)*py+alpha5-50, 700*px, 250*py, imgRender.main, 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
		dxCreateText("Информация", sx/2-(660/2)*px, sy/2+(40/2)*py+alpha5-50, 700*px, 250*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "left", "top")
		dxCreateText("За каждого приглашенного игрока, который отыграет 10ч,\nвы будете получать: < 150kk ₽ >", sx/2-(660/2)*px, sy/2+(80/2)+alpha5-50, 700*px, 250*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "left", "top")

        dxCreateText("У вас приглашенных:", sx/2-(660/2)*px, sy/2+(190/2)*py+alpha5-50, 700*px, 250*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "left", "top")
        dxCreateText(conf.count.." игроков", sx/2-(660/2)*px, sy/2+(230/2)*py+alpha5-50, 700*px, 250*py, tocolor(79, 70, 229, alpha4), 1, fonts[14], "left", "top")

        dxCreateText("Ваш баланс:", sx/2+(300/2)*px, sy/2+(160/2)*py+alpha5-50, 700*px, 250*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[14], "left", "top")
        dxCreateText(convertNumber(conf.money).." ₽", sx/2+(300/2)*px, sy/2+(200/2)*py+alpha5-50, 700*px, 250*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "left", "top")
        dxCreateText(convertNumber(conf.donate).." AW", sx/2+(300/2)*px, sy/2+(240/2)*py+alpha5-50, 700*px, 250*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "left", "top")

        dxDrawImage(sx/2-(670/2)*px, sy/2+(350/2)*py+alpha5-50, 170*px, 50*py, imgRender.EditRef, 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
        dxCreateText(conf.code, sx/2-(670/2)*px, sy/2+(350/2)*py+alpha5-50, 170*px, 50*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        if isCursorOverRectangle(sx/2-(670/2)*px, sy/2+(350/2)*py+alpha5-50, 170*px, 50*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				setClipboard (conf.code)
				exports.aw_interface_notify:showInfobox("info", "Партнерство", "Реферальный код скопирован "..(conf.code), getTickCount(), 8000)
			end
		end
        dxCreateText("- ваш промокод", sx/2-(320/2)*px, sy/2+(350/2)*py+alpha5-50, 170*px, 50*py, tocolor(255, 255, 255, 93*(alpha4/255)), 1, fonts[4], "left", "center")

        dxDrawButton(sx/2+(300/2)*px, sy/2+(320/2)*py+alpha5-50, 165*px, 75*py, imgRender.v_button, imgRender.v_button_alpha, 1)
        dxCreateText("Забрать", sx/2+(300/2)*px, sy/2+(320/2)*py+alpha5-50, 165*px, 75*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        if isCursorOverRectangle(sx/2+(300/2)*px, sy/2+(320/2)*py, 165*px, 75*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				if not stateAnim then
					stateAnim = true
					state2 = true;
                    tick2 = getTickCount();
                    setTimer(function()
                    if tonumber(conf.money) > 0 or tonumber(conf.donate) > 0 then
					aw_account_referals:takeMoney()
					setTimer (updateConfReferals, 200, 1)
					exports.aw_interface_notify:showInfobox("info", "Партнерство", "Вы успешно вывели все средства", getTickCount(), 8000)
				end
                    end, 3500, 1)
				end
			end
		end

        dxDrawImage(sx/2-(250/2)*px, sy/2+(650/2*py)*py+alpha5-50, 250*px, 60*py, imgRender.EditBox, 0, 0, 0, tocolor(255, 255, 255, alpha4), false)
        dxCreateText("Активировать", sx/2-(250/2)*px, sy/2+(650/2)*py+alpha5-50, 250*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[14], "center", "center")
        if isCursorOverRectangle(sx/2-(250/2)*px, sy/2+(650/2)*py, 250*px, 60*py) then
			if getKeyState("mouse1") and not isButtonClick and not active then
				executeCommandHandler("ref")
			end
		end

		dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 150* (alpha3/255)))
        dxDrawImage(sx/2-(135/2)*px, sy/2-(138/2)*py, 135*px, 138*py, "images/anim.png",  rotation2, 0, 0, tocolor(92, 166, 255, alpha3), false)

	end
	if selectSection == 4 then
		dxDrawRectangle(sx/2-(325/2)*px, sy/2-(805/2)*py, 90*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		
		dxDrawText("Главная", sx/2-(1320/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Магазин", sx/2-(1095/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Реферальная программа", sx/2-(850/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Навигация", sx/2-(325/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Настройки", sx/2-(40/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
	

		local y = 0
		local xpr = 0
		local ypr = 0
		dxSetRenderTarget (renderTargets[1], true)
		for k, v in ipairs(gps[1].name) do
			dxCreateText(v[1], 21*px, 29*py+y-scrollGPS, 146*px, 29*py, tocolor(255, 255, 255, alpha4), 1, fonts[9], "left", "top")
			y = y + 243*px
		end
		for k, v in ipairs(gps[1].seting) do
			xpr = math.fmod(k-1, 5)*340*px
			ypr = math.floor((k-1)/5)*241*py
			if k <= 4 then
				dxDrawButtonGPS(31*px+xpr, 76*py+ypr-scrollGPS, 325*px, 168*py, v[2], k, tocolor(255,255,255,alpha4), "ПОСТАВИТЬ МЕТКУ", v[3])
			else
				dxDrawButtonGPS(31*px+xpr, 76*py+ypr-scrollGPS, 325*px, 168*py, v[2], k, tocolor(255,255,255,alpha4), "ПОСТАВИТЬ МЕТКУ", {v[3][1], v[3][2], v[3][3]})
			end
			dxCreateText(v[1], 45*px+xpr, 215*py+ypr-scrollGPS , 82*px, 19*py, tocolor(255, 255, 255, alpha4), 1, fonts[11], "left", "top")
		end
		dxSetRenderTarget()	
		dxDrawImage(sx/2-(1816/2)*px, sy/2-(702/2)*py+alpha5-50, 1766*px, 818*py, renderTargets[1])

		if isElement(marker) then
			dxCreateText("Убрать маркер", sx/2-(-1500/2)*px, sy/2-(766/2)*py+alpha5-50, 108*px, 19*py, tocolor(67, 67, 67, alpha4), 1, fonts[10], "left", "top")
			if isCursorOverRectangle(sx/2-(-1500/2)*px, sy/2-(766/2)*py+alpha5-50, 108*px, 19*py) then
				dxCreateText("Убрать маркер", sx/2-(-1500/2)*px, sy/2-(766/2)*py+alpha5-50, 108*px, 19*py, tocolor(255, 255, 255, alpha4), 1, fonts[10], "left", "top")
				if getKeyState("mouse1") and not isButtonClick and not active then
					destroyElement(marker)
					destroyElement(blipes)
				end
			end
		end

		if ypr > 484*py then
			scrollMaxGPS = ypr - 484*py
		end

		if scrollMaxGPS > 0 then
			dxDrawRectangle(sx/2-(-1756/2)*px, sy/2-(538/2)*py+alpha5-50, 1*px, 659*py, tocolor(67, 67, 67, alpha4))
			local sizes = 659*py * ((659*py)/(scrollMaxGPS + 659*py))
			dxDrawRectangle(sx/2-(-1756/2)*px, (sy/2-(538/2)*py + scrollGPS/scrollMaxGPS*(659*px-sizes))+alpha5-50, 1*px, sizes, tocolor(255, 255, 255, alpha4))
		end
	end

	if selectSection == 5 then
		dxDrawRectangle(sx/2-(40/2)*px, sy/2-(805/2)*py, 90*px, 1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
		
		dxDrawText("Главная", sx/2-(1320/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Магазин", sx/2-(1095/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Реферальная программа", sx/2-(850/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Навигация", sx/2-(325/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
		dxDrawText("Настройки", sx/2-(40/2)*px, sy/2+(-170/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
	

		local x = 0
		for k, v in ipairs(setting) do
			dxDrawButtonInCase(sx/2-(602/2)*px + x, sy/2-(428/2)*py+alpha5-50, 189*px, 54*py, imgRender.SelectionSettings, imgRender.SelectionSettings, (k+4), {15, 15, 15,alpha4}, {79, 70, 229})
			dxCreateText(v[1], sx/2-(662/2)*px+ x, sy/2-(435/2)*py+alpha5-50, 250*px, 60*py, tocolor(255, 255, 255, alpha4), 1, fonts[8], "center", "center")
			if isCursorOverRectangle(sx/2-(602/2)*px + x, sy/2-(428/2)*py, 189*px, 54*py) then
				if getKeyState("mouse1") and not isButtonClick and not active then
					if k ~= selectionSetting then
						selectionSetting = k
					end
				end
			end
			x = x + 230*px
		end
		for k, v in ipairs(setting[selectionSetting].seting) do
			local xpr = math.fmod(k-1, 2)*450*px
			local ypr = math.floor((k-1)/2)*82*py
			dxDrawEdite(sx/2-(792/2)*px+xpr, sy/2-(-84/2)+alpha5-50+ypr, 75.66*px, 31.07*py, v[1], (k-1)+#setting[selectionSetting].seting, v[2])
		end

		if selectionSetting == 3 then
			dxDrawButtonInCase(sx/2-(336/2)*px, sy/2-(-250/2)+alpha5-50, 335*px, 65*py, imgRender.buttonSetting, imgRender.buttonSetting, 1, {15, 15, 15,alpha4}, {79, 70, 229})
			dxCreateText("Сменить пароль", sx/2-(170/2)*px, sy/2-(-295/2)+alpha5-50, 175*px, 16*py, tocolor(255, 255, 255, alpha4), 1, fonts[8], "center", "center")
			if isCursorOverRectangle(sx/2-(336/2)*px, sy/2-(-250/2)*py, 335*px, 65*py) then
				if getKeyState("mouse1") and not isButtonClick and not active then
				--	executeCommandHandler("changepassword")
				end
			end
		end
	end
	
	

	if alpha == 0 then
		closingEveryThing()
		removeEventHandler("onClientRender", root, freeroam)
		tick = nil
	end

	if getKeyState("mouse1") then isButtonClick = true else isButtonClick = false end

end

function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end

function dxCreateText (text, x, y, w, h, color, size, font, left, top)
	dxDrawText (text, x, y, x + w, y + h, color, size, font, left, top, false, false ,false, true)
end

local G_ALPHA_HOVER = {}

function dxDrawButton(X, Y, W, H, IMAGE_STATE, IMAGE_HOVER, INDEX)
    if G_ALPHA_HOVER[INDEX] == nil then
        G_ALPHA_HOVER[INDEX] = {}
        G_ALPHA_HOVER[INDEX] = 0
    end
    
    
    if isCursorOverRectangle(X, Y, W, H) then
        if G_ALPHA_HOVER[INDEX] <= 240 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] + 10
        end
        COLOR_HOVER = tocolor(255, 255, 255,  G_ALPHA_HOVER[INDEX])
    else
        if G_ALPHA_HOVER[INDEX] ~= 0 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] - 10
        end
        COLOR_HOVER = tocolor(255, 255, 255,  G_ALPHA_HOVER[INDEX])
    end

    dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, COLOR_STATE)
	dxDrawImage(X, Y, W, H, IMAGE_HOVER, 0,0,0, COLOR_HOVER)
end

local G_ALPHA_HOVER_BG = {}
local isButtonClickBG = {}
local GPSPOS = {}

function dxDrawButtonGPS(X, Y, W, H, IMAGE_STATE, INDEX, COLOR_STATE, TEXT, POSMARKER)
	local Xs = sx/2-(1816/2)*px + X
	local Ys = sy/2-(702/2)*py + Y

	if not GPSPOS[INDEX]  then
		GPSPOS[INDEX] = {}
    end

	GPSPOS[INDEX] = POSMARKER

    if G_ALPHA_HOVER_BG[INDEX] == nil then
        G_ALPHA_HOVER_BG[INDEX] = {}
        G_ALPHA_HOVER_BG[INDEX] = 0
    end
    
    if isCursorOverRectangle(Xs, Ys, W, H) then
		if getKeyState("mouse1") and not isButtonClickBG[INDEX] and not isButtonClickBG[INDEX] then
			if INDEX <= 4 then
				createMarkerGPSBlish(GPSPOS[INDEX])
			else
				local x, y, z = unpack(GPSPOS[INDEX])
				createMarkerGPS(x, y, z)
			end
		end
		if G_ALPHA_HOVER_BG[INDEX] <= 240 then
			G_ALPHA_HOVER_BG[INDEX] = G_ALPHA_HOVER_BG[INDEX] + 10
		end
		COLOR_HOVER = tocolor(0, 0, 0, 150 * G_ALPHA_HOVER_BG[INDEX]/240)
	else
		if G_ALPHA_HOVER_BG[INDEX] ~= 0 then
			G_ALPHA_HOVER_BG[INDEX] = G_ALPHA_HOVER_BG[INDEX] - 10
		end
		COLOR_HOVER = tocolor(0, 0, 0,  150 * G_ALPHA_HOVER_BG[INDEX]/240)
	end

    dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, COLOR_STATE)
	dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, COLOR_HOVER)
	dxCreateText(TEXT, X, Y, W, H, tocolor(255, 255, 255, G_ALPHA_HOVER_BG[INDEX]), 1, fonts[10], "center", "center")
	if getKeyState("mouse1") then isButtonClickBG[INDEX] = true else isButtonClickBG[INDEX] = false end
end

local G_ALPHA_HOVER_CASE = {}
local G_Y_HOVER_CASE = {}

function dxDrawButtonCase(X, Y, W, H, IMAGE_STATE, IMAGE_HOVER, INDEX, COLORr, COLORb, COLORg)

    if G_ALPHA_HOVER_CASE[INDEX] == nil then
        G_ALPHA_HOVER_CASE[INDEX] = {}
        G_ALPHA_HOVER_CASE[INDEX] = 0
    end

	if G_Y_HOVER_CASE[INDEX] == nil then
        G_Y_HOVER_CASE[INDEX] = {}
        G_Y_HOVER_CASE[INDEX] = 0
    end

    
    
    if isCursorOverRectangle(X, Y, W, H) then

        if G_ALPHA_HOVER_CASE[INDEX] <= 240 then
            G_ALPHA_HOVER_CASE[INDEX] = G_ALPHA_HOVER_CASE[INDEX] + 10
        end

		if G_Y_HOVER_CASE[INDEX] <= 15 then
            G_Y_HOVER_CASE[INDEX] = G_Y_HOVER_CASE[INDEX] + 1
        end

        COLOR_HOVERCASE = tocolor(COLORr, COLORb, COLORg,  G_ALPHA_HOVER_CASE[INDEX])
    else

        if G_ALPHA_HOVER_CASE[INDEX] ~= 0 then
            G_ALPHA_HOVER_CASE[INDEX] = G_ALPHA_HOVER_CASE[INDEX] - 10
        end

		if G_Y_HOVER_CASE[INDEX] ~= 0 then
            G_Y_HOVER_CASE[INDEX] = G_Y_HOVER_CASE[INDEX] - 1
        end

        COLOR_HOVERCASE = tocolor(COLORr, COLORb, COLORg,  G_ALPHA_HOVER_CASE[INDEX])
    end

    dxDrawImage(X, Y-G_Y_HOVER_CASE[INDEX], W, H, IMAGE_STATE, 0,0,0, COLOR_STATECASE)
	dxDrawImage(X, Y-G_Y_HOVER_CASE[INDEX], W, H, IMAGE_HOVER, 0,0,0, COLOR_HOVERCASE)
end

local G_ALPHA_HOVER_INCASE = {}

function dxDrawButtonInCase(X, Y, W, H, IMAGE_STATE, IMAGE_HOVER, INDEX, COLORSTOCK, COLORHOVER)

	local r, g, b = unpack(COLORHOVER)

    if G_ALPHA_HOVER_INCASE[INDEX] == nil then
        G_ALPHA_HOVER_INCASE[INDEX] = {}
        G_ALPHA_HOVER_INCASE[INDEX] = 0
    end 

    if isCursorOverRectangle(X, Y, W, H) then

        if G_ALPHA_HOVER_INCASE[INDEX] <= 240 then
            G_ALPHA_HOVER_INCASE[INDEX] = G_ALPHA_HOVER_INCASE[INDEX] + 10
        end

        COLOR_HOVERINCASE = tocolor(r, g, b, G_ALPHA_HOVER_INCASE[INDEX])
    else

        if G_ALPHA_HOVER_INCASE[INDEX] ~= 0 then
            G_ALPHA_HOVER_INCASE[INDEX] = G_ALPHA_HOVER_INCASE[INDEX] - 10
        end

		COLOR_HOVERINCASE = tocolor(r, g, b, G_ALPHA_HOVER_INCASE[INDEX])
    end

    dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, tocolor(unpack(COLORSTOCK)))
	dxDrawImage(X, Y, W, H, IMAGE_HOVER, 0,0,0, COLOR_HOVERINCASE)
end

local isButtonClickEdit = {}
local activeEdit = {}
local triggerEdit = {}
local xBox = {}

function dxDrawEdite(X, Y, W, H, TEXT, INDEX, TRIGGER)

	if not triggerEdit[INDEX] then
		triggerEdit[INDEX] = TRIGGER
	end
	if not xBox[INDEX] then
		xBox[INDEX] = 0
	end

	if not tableSave[triggerEdit[INDEX]] then
		tableSave[triggerEdit[INDEX]] = false
		xBox[INDEX] = 0
		colorBoxChek = tocolor(67,67,67, alpha4)
	else
		colorBoxChek = tocolor(255, 255 ,255, alpha4)
		xBox[INDEX] = 32
	end
    if isCursorOverRectangle(X+290*px, Y-19*py, 75.66*px, 31.07*py) then
		if getKeyState("mouse1") and not isButtonClickEdit[INDEX] and not activeEdit[INDEX] then
			if not tableSave[triggerEdit[INDEX]] then
				tableSave[triggerEdit[INDEX]] = true
				triggerEvent(triggerEdit[INDEX], root, tableSave[triggerEdit[INDEX]])
				xBox[INDEX] = 32
				colorBoxChek = tocolor(255, 255 ,255, alpha4)
			else
				tableSave[triggerEdit[INDEX]] = false
				triggerEvent(triggerEdit[INDEX], root, tableSave[triggerEdit[INDEX]])
				xBox[INDEX] = 0
				colorBoxChek = tocolor(67,67,67, alpha4)
			end
			saveSettings()
		end
    end

    dxDrawImage(X+290*px, Y-19*py, 75.66*px, 31.07*py, imgRender.CheksBoxes, 0,0,0, tocolor(255, 255, 255, alpha4))
	dxDrawImage(X+(290+xBox[INDEX])*px, Y-19*py, 43.23*px, 31.07*py, imgRender.Box, 0,0,0, colorBoxChek)
	dxDrawImage(X, Y+29*py, 374.27*px, 5.4*py, imgRender.Rectengle, 0,0,0, tocolor(255, 255, 255, alpha4))
	dxCreateText(TEXT, X, Y-19*py, W, H, tocolor(255, 255, 255, alpha4), 1, fonts[8], "left", "center")

	if getKeyState("mouse1") then isButtonClickEdit[INDEX] = true else isButtonClickEdit[INDEX] = false end
end



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

function isCursorOverRectangle(x,y,w,h)
    if isCursorShowing() then
        local mx,my = getCursorPosition()
        local cursorx,cursory = mx*sx,my*sy
        if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
            return true
        end
    end
return false
end

function updateConfReferals ()
	if isResourceRunning ("referals") then
		conf.code = aw_account_referals:getCode()
		conf.count = aw_account_referals:getCount()
		conf.money = aw_account_referals:getMoney()[1]
		conf.donate = aw_account_referals:getMoney()[2]
	end
end

function freeroamOpen()
	if menuVisible then
		showCursor(false)
		tickstranica = getTickCount()
		stranica = nil
		state = false
		tick = getTickCount()
		activePromoText = nil
		activeConverMoney = nil
		hud = exports.aw_interface_hud:anim_false()
		radar = exports.aw_interface_radar:anim_false()
		speedometer = exports.aw_interface_speedometer:anim_false()
		guiSetInputMode ("allow_binds")
		showChat(true)
		setElementData(localPlayer, "showHud", "on")
		if isResourceRunning ("referals") then
			conf.code = aw_account_referals:getCode()
			conf.count = aw_account_referals:getCount()
		end

	else
		creatTextOrNothing()
		if not isEventHandlerAdded("onClientRender", root, freeroam) then
			addEventHandler("onClientRender",root,freeroam)
		end
		tickstranica = getTickCount()
		stranica = true
		showCursor(true)
		showChat(false)
		hud = exports.aw_interface_hud:anim_true()
		radar = exports.aw_interface_radar:anim_true()
		speedometer = exports.aw_interface_speedometer:anim_true()
		setElementData(localPlayer, "showHud", "off")
		state = true
		tick = getTickCount()
		if isResourceRunning ("referals") then
			conf.code = aw_account_referals:getCode()
			conf.count = aw_account_referals:getCount()
			conf.money = aw_account_referals:getMoney()[1]
			conf.donate = aw_account_referals:getMoney()[2]
		end

	end

menuVisible = not menuVisible

end
bindKey("f1","down", freeroamOpen)


addCommandHandler("rp", function()
	triggerServerEvent ("event", localPlayer, getPedOccupiedVehicle(localPlayer), "fix")
end)

addCommandHandler("flip", function()
	triggerServerEvent ("event", localPlayer, getPedOccupiedVehicle(localPlayer), "recover")
end)

addCommandHandler("repair", function()
	triggerServerEvent ("event", localPlayer, getPedOccupiedVehicle(localPlayer), "fix")
end)

addCommandHandler("lights", function()
	triggerServerEvent ("event", localPlayer, getPedOccupiedVehicle(localPlayer), "lights")
end)

bindKey("l", "down", function()
	triggerServerEvent ("event", localPlayer, getPedOccupiedVehicle(localPlayer), "lights")
end)

addEventHandler ("onClientKey", root, function(key)
	if not selectSection then return end
	if key == "mouse_wheel_up" then
		if isCursorOverRectangle(sx/2-(1816/2)*px, sy/2-(702/2)*py, 1766*px, 818*py) then
			if scrollGPS - 30*py >= 0 then
				scrollGPS = scrollGPS - 30*py
			else
				scrollGPS = 0
			end
		end
	elseif key == "mouse_wheel_down" then
		if isCursorOverRectangle(sx/2-(1816/2)*px, sy/2-(702/2)*py, 1766*px, 818*py) then
			if scrollGPS + 30*py <= scrollMaxGPS then
				scrollGPS = scrollGPS + 30*py
			else
				scrollGPS = scrollGPS
			end
		end
	end
end)

function getnullroft(unit)
    if unit < 10 then
        unit = "0" .. unit
    end
    return unit
end

function math.percentChance(percent,repeatTime)
	local hits = 0
	for i = 1, repeatTime do
		local number = math.random(1,1000)/12
		if number <= percent then
			hits = hits + 1
		end
	end
	return hits
end

function generateSlots()
    local int = #selectionCases[selectregionEbashion][case].prize
    local blocks = 100
    tableRoll = {}
	for i = 1, blocks do
		for i = 1 ,int do
			local item = math.random(1, #selectionCases[selectregionEbashion][case].prize)
			for k, v in pairs(selectionCases[selectregionEbashion][case].prize) do
				if v[5] >= 50 then v[5] = 50 end
				if math.percentChance(v[5], 1) >= 1 then
					item = k
					break
				end
			end
			table.insert(tableRoll, {selectionCases[selectregionEbashion][case].prize[item][1], selectionCases[selectregionEbashion][case].prize[item][2], selectionCases[selectregionEbashion][case].prize[item][3], selectionCases[selectregionEbashion][case].prize[item][4], selectionCases[selectregionEbashion][case].prize[item][5]} )
		end
	end
end

--// Сохранение.
local settignsPath = "@sgraphics.json"

function loadFile(path, count)
    if not fileExists(path) then
        return false
    end
    local file = fileOpen(path)
    if not file then
        return false
    end
    if not count then
        count = fileGetSize(file)
    end
    local data = fileRead(file, count)
    fileClose(file)
    return data
end

function saveFile(path, data)
    if not path then
        return false
    end
    if fileExists(path) then
        fileDelete(path)
    end
    local file = fileCreate(path)
    fileWrite(file, data)
    fileClose(file)
    return true
end

function saveSettings()
	if not saveSetting then
        if fileExists(settignsPath) then
            fileDelete(settignsPath)
        end
        return
    end
	local table = {}
    for i,v in pairs(saveSetting) do
        table[v[1]] = tableSave[v[1]] or false
    end
    saveFile(settignsPath, toJSON(table))
end

function resetSettings()
    for k, v in pairs(saveSetting) do
		tableSave[v[1]] = false
    end
    saveSettings()
end

function loadSettings()
    local jsonData = loadFile(settignsPath)
    if not jsonData then
        resetSettings()
        return
    end
    local settings = fromJSON(jsonData)
    if not settings then
        resetSettings()
        return
    end
    for i,v in pairs(settings) do
        tableSave[i] = v
		triggerEvent(i, root, v)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, loadSettings)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
		 local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		 if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			  for i, v in ipairs( aAttachedFunctions ) do
				   if v == func then
					return true
			   end
		  end
	 end
	end
	return false
end

function createMarkerMapBlish(resourse)
	local markerRadom = nil
	if isElement(marker) then
		--outputChatBox( "Уберите маркер!", 255, 50, 50, true )
	else
		for i, markers in pairs(getElementsByType("marker", getResourceRootElement(getResourceFromName(resourse)))) do
			local x, y, z = getElementPosition(localPlayer)
			local x1, y2, z3 = getElementPosition(markers)
			if getDistanceBetweenPoints3D(x1, y2, z3, x, y, z) <= 500 then

				marker = createMarker(x1, y2, z3-1, "cylinder", 25, 0, 0, 0, 0 )

				if not isElement(blipes) then
					blipes = createBlip(x1, y2, z3, 41)
				end

				markerRadom = true
			--	outputChatBox( "Маркер установлен.", 255, 255, 255, true )
			end
		end
		if not markerRadom then
			--outputChatBox( "Извините, но рядом с вами ничего Нет", 255, 255, 255, true )
		end
	end
end

function createMarkerMap (x, y, z)
	if isElement(marker) then
		--outputChatBox( "Уберите маркер!", 255, 50, 50, true )
	else
		if not isElement(blipes) then
			blipes = createBlip(x, y, z, 41)
		end
		marker = createMarker(x, y, z-1, "cylinder", 25, 0, 0, 0, 0 )
	--	outputChatBox( "Маркер установлен.", 255, 255, 255, true )
	end
end

function dxDist()
	if isElement(marker) then
    local x, y, z = getElementPosition(localPlayer)
    local x1, y2, z3 = getElementPosition(marker)
    local dist = getDistanceBetweenPoints3D(x, y, z, x1, y2, z3)
    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x1, y2, z3 + 0.5, 0.07)
    if (WorldPositionX and WorldPositionY) then
        dxDrawText(math.floor(dist).." м", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY - 100, tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
    end
	else
		removeEventHandler("onClientRender", getRootElement(), dxDist)
	end
end

function createMarkerGPS(x, y, z)
	marker_gps = createMarkerMap(x, y, z)
	if not isEventHandlerAdded("onClientRender", getRootElement(), dxDist) then
    addEventHandler("onClientRender", getRootElement(), dxDist)
 	end
end

function createMarkerGPSBlish(resourse)
	marker_gps = createMarkerMapBlish(resourse)
	if not isEventHandlerAdded("onClientRender", getRootElement(), dxDist) then
    addEventHandler("onClientRender", getRootElement(), dxDist)
 	end
end

function hitMarker()
	if source == marker then
		if isElement(marker) then destroyElement(marker) end
		removeEventHandler("onClientRender", getRootElement(), dxDist)
		if isElement(blipes) then destroyElement(blipes) end
	--	outputChatBox( "Вы прибыли к месту назначения", 255, 255, 255, true )
	end
end
addEventHandler( "onClientMarkerHit", resourceRoot, hitMarker )

addEventHandler ("onClientCharacter", root, function(char)
	if activePromoText then
		local w = dxGetTextWidth (promoText..char, 1, fonts[1])
		if w > 225*px then return end
		promoText = promoText..char
	end
	if activeConverMoney then
		if numbers[char] then
			local w = dxGetTextWidth (ConverText..char, 1, fonts[1])
			if w > 300*px then return end
			ConverText = ConverText..char
		end
	end
end)


function setTimeCommand(cmd, hours, minutes)
	if not hours then
		return
	end
	local curHours, curMinutes = getTime()
	hours = tonumber(hours) or curHours
	minutes = minutes and tonumber(minutes) or curMinutes
	setTime(hours, minutes)
end
addCommandHandler('st', setTimeCommand)

function setWeatherCommand(cmd, weather)
	weather = weather and tonumber(weather)
	if weather then
		setWeather(weather)
	end
end
addCommandHandler('setweather', setWeatherCommand)
addCommandHandler('sw', setWeatherCommand)


function removeHex (s)
	if type (s) == "string" then
		while (s ~= s:gsub ("#%x%x%x%x%x%x", "")) do
			s = s:gsub ("#%x%x%x%x%x%x", "")
		end
	end
	return s or false
end