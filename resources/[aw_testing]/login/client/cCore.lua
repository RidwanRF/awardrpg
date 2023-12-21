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
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 17*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 19*px)
SemiBoldMini = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 36*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 10*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 10*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px)

local assets = {
 
    editbox1 = dxCreateTexture ("assets/aw_ui_auth_button_editbox1.png"),
    editbox2 = dxCreateTexture ("assets/aw_ui_auth_button_editbox2.png"),

    enter1 = dxCreateTexture ("assets/aw_ui_auth_button_enter1.png"),
    enter2 = dxCreateTexture ("assets/aw_ui_auth_button_enter2.png"),

    create1 = dxCreateTexture ("assets/aw_ui_auth_button_create1.png"),
    create2 = dxCreateTexture ("assets/aw_ui_auth_button_create2.png"),

    remember1 = dxCreateTexture ("assets/aw_ui_auth_button_remember1.png"),
    remember2 = dxCreateTexture ("assets/aw_ui_auth_button_remember2.png"),

    visible1 = dxCreateTexture ("assets/aw_ui_auth_button_visible1.png"),
    visible2 = dxCreateTexture ("assets/aw_ui_auth_button_visible2.png"),

    ornew1 = dxCreateTexture ("assets/aw_ui_auth_button_ornew1.png"),
    ornew2 = dxCreateTexture ("assets/aw_ui_auth_button_ornew2.png"),

	orenter1 = dxCreateTexture ("assets/aw_ui_auth_button_orenter1.png"),
    orenter2 = dxCreateTexture ("assets/aw_ui_auth_button_orenter2.png"),


}

local yellow = tocolor(255, 0, 0, 255) 

GUI = { serverNomer = "", mainWindowMain = false, mainWindowOpened = false, rulesWindowOpened = false, registerWindowOpened = false, enteredLogin = "", enteredPass = "", regEnteredLogin = "",
	    regEnteredPass = "", regEnteredPass2 = "", rulesChecked = false, rulesTempCheck = false, 
	    button = {}, window = {}, edit = {}, label = {}, elem = {} }

function isDxRectangle(x,y,w,h)
	if isCursorShowing() then
		local mx,my = getCursorPosition() 
		local cursorx,cursory = mx*screenW,my*screenH
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		end
	end
    return false
end

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
        --// Авторизация // 	 сюда
	    local elem = GUI.elem.loginField 
	    GUI.edit.login = guiCreateEdit(9999*sx, (screenH-9999*sy)/2, 0*sx, 0*sy, "", false)
	    guiEditSetMaxLength(GUI.edit.login, 20)
	    guiSetVisible(GUI.edit.login, false)
	    guiSetAlpha(GUI.edit.login, 0)
	   ------------------------ guiSetFont ( GUI.edit.login, fonGuiEdit )
	
	    elem = GUI.elem.passField
	    GUI.edit.password = guiCreateEdit(9999*sx, (screenH-9999*sy)/2, 0*sx, 0*sy, "", false)
	    guiEditSetMaxLength(GUI.edit.password, 20) 
	    guiSetVisible(GUI.edit.password, false) 
	    guiSetAlpha(GUI.edit.password, 0)
--------	    guiSetFont (GUI.edit.password, fonGuiEdit )

	    --// Регистрация // --
	    elem = GUI.elem.regLoginField
	    GUI.edit.regLogin = guiCreateEdit(9999*sx, (screenH-9999*sy)/2, 0*sx, 0*sy, "", false)
	    guiEditSetMaxLength(GUI.edit.regLogin, 20)
	    guiSetAlpha(GUI.edit.regLogin, 0)
	    guiSetVisible(GUI.edit.regLogin, false)
	 ----------------------   guiSetFont ( GUI.edit.regLogin, fonGuiEdit )
	
	    elem = GUI.elem.regPassField
	    GUI.edit.regPass = guiCreateEdit(9999*sx, (screenH-9999*sy)/2, 0*sx, 0*sy, "", false)
	    guiEditSetMaxLength(GUI.edit.regPass, 20)
	    guiSetAlpha(GUI.edit.regPass, 0)
	    guiSetVisible(GUI.edit.regPass, false) 
	  ---------  guiSetFont ( GUI.edit.regPass, fonGuiEdit )
	
	    elem = GUI.elem.regPass2Field
	    GUI.edit.regPass2 = guiCreateEdit(9999*sx, (screenH-9999*sy)/2, 0*sx, 0*sy, "", false)
	    guiEditSetMaxLength(GUI.edit.regPass2, 20)
	    guiSetAlpha(GUI.edit.regPass2, 0) 
	    guiSetVisible(GUI.edit.regPass2, false) 
	  ---  guiSetFont ( GUI.edit.regPass2, fonGuiEdit )
    end 
)

function showMsgText ( tab, text )
	if tab == "Login" then 
		if (GUI.mainWindowMain) then
		-----	dxDrawText("Ошибка, проверьте верность вводимых вами данных", screenW-1500/zoom, 2035/zoom, 0/zoom, 0/zoom, tocolor(255, 255, 255, 255), 0.85, bold, "left", "center", true, true, true, true, true)
		-----	dxDrawText("либо обратитесь к администрации проекта vk.com/anybismtasa", screenW-1500/zoom, 2070/zoom, 0/zoom, 0/zoom, tocolor(255, 255, 255, 255), 0.85, roman, "left", "center", true, true, true, true, true)
		end
	elseif Tab == "Register" then
		if (GUI.registerWindowOpened) then
			guiSetText(login_tab_error_msg, tostring(text))
			setTimer( function() guiSetText(login_tab_error_msg, "") end, 3000, 1)
		end
	end
end
addEvent("showMsgText", true)
addEventHandler("showMsgText", getRootElement(), showMsgText)

local stateEdit_login = false
local stateEdit_pass = false

local stateEdit_logr = false
local stateEdit_passr = false
local stateEdit_pass2r = false

local editStat_l = 0
local editStat_p = 0

local accountState = 0 

function checkTextAccount ()
	accountState = 1 
end
addEvent ( "checkTextAccount", true )
addEventHandler ( "checkTextAccount", root, checkTextAccount )

listSlider = 1


setElementData(localPlayer, "timeSlide", 0)
addEventHandler("onClientRender", root, 
	function ()
		
		if (GUI.mainWindowOpened) then 
--сюда
			
	dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px,1080*py, "assets/aw_ui_auth_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

    dxDrawImage(sx/2-(30/2)*px, sy/2-(604/2)*py, 32*px,41*py, "assets/aw_ui_auth_logotype.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

	dxDrawText("Вход в игровой аккаунт", sx/2-(1820/2)*px, sy/2+(570/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldBig, "center", "center", false, false, false, false, false)
	dxDrawText("Пожалуйста, введите данные от вашего аккаунта", sx/2-(1820/2)*px, sy/2+(775/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 127), 1, Regular, "center", "center", false, false, false, false, false)
    dxDrawText("Логин от аккаунта", sx/2-(424/2)*px, sy/2+(1020/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 76), 1, MediumMini, "left", "center", false, false, false, false, false)

	dxDrawButton(sx/2-(424/2)*px, sy/2-(130/2)*py, 423*px,49*py, assets.editbox1, assets.editbox2, 3)
    dxDrawImage(sx/2-(362/2)*px, sy/2-(90/2)*py, 11*px,12*py, "assets/aw_ui_auth_login.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

    dxDrawText("Пароль от аккаунта", sx/2-(424/2)*px, sy/2+(1420/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 76), 1, MediumMini, "left", "center", false, false, false, false, false)
 
    dxDrawButton(sx/2-(424/2)*px, sy/2-(-69/2)*py, 423*px,49*py, assets.editbox1, assets.editbox2, 2)
    dxDrawImage(sx/2-(362/2)*px, sy/2-(-110/2)*py, 10*px,10*py, "assets/aw_ui_auth_pass.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

    dxDrawButton(sx/2-(424/2)*px, sy/2-(-264/2)*py, 423*px,49*py, assets.enter1, assets.enter2, 1)

	dxDrawButton(sx/2-(424/2)*px, sy/2-(-498/2)*py, 425*px,56*py, assets.ornew1, assets.ornew2, 4)

	dxDrawText("Автоматический вход в аккаунт", sx/2-(425/2)*px, sy/2+(2255/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 76), 1, Medium, "left", "center", false, false, false, false, false)

    
            dxDrawRemberMe(sx/2-(-348/2)*px, sy/2-(-420/2)*py, 37*px,16*py)

			local editLog = guiGetText(GUI.edit.login)
			local editPas = guiGetText(GUI.edit.password)

			local editLog = guiGetText(GUI.edit.login)
            local editPas = guiGetText(GUI.edit.password)

	        if editLog == "" and guiGetVisible(GUI.edit.login) == false then 
				dxDrawText("Введите в поле ваш логин", sx/2-(280/2)*px, sy/2+(1225/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
            else
        	    dxDrawText (editLog,  sx/2-(280/2)*px, sy/2+(1225/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
        	end
			
			if editPas == "" and guiGetVisible(GUI.edit.password) == false then 
				dxDrawText("Введите в поле ваш пароль",  sx/2-(280/2)*px, sy/2+(1625/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
            else
        	    dxDrawText (editPas,   sx/2-(280/2)*px, sy/2+(1625/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
        	end

		
        elseif (GUI.registerWindowOpened) then -- 2

				
			dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px,1080*py, "assets/aw_ui_auth_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

			dxDrawImage(sx/2-(30/2)*px, sy/2-(665/2)*py, 32*px,41*py, "assets/aw_ui_auth_logotype.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

			dxDrawText("Создание игрового аккаунта", sx/2-(1820/2)*px, sy/2+(453/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldBig, "center", "center", false, false, false, false, false)
			dxDrawText("Пожалуйста, заполните поля", sx/2-(1820/2)*px, sy/2+(665/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 127), 1, Regular, "center", "center", false, false, false, false, false)

			dxDrawText("Логин от аккаунта", sx/2-(424/2)*px, sy/2+(900/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 76), 1, MediumMini, "left", "center", false, false, false, false, false)
			dxDrawImage(sx/2-(362/2)*px, sy/2-(150/2)*py, 11*px,12*py, "assets/aw_ui_auth_login.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

			dxDrawText("Пароль от аккаунта", sx/2-(424/2)*px, sy/2+(1300/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 76), 1, MediumMini, "left", "center", false, false, false, false, false)
			dxDrawImage(sx/2-(362/2)*px, sy/2-(-50/2)*py, 10*px,10*py, "assets/aw_ui_auth_pass.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

			dxDrawText("Повторите пароль от аккаунта", sx/2-(424/2)*px, sy/2+(1700/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 76), 1, MediumMini, "left", "center", false, false, false, false, false)
			dxDrawImage(sx/2-(362/2)*px, sy/2-(-250/2)*py, 10*px,10*py, "assets/aw_ui_auth_pass.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)


		    local editRegLog = guiGetText(GUI.edit.regLogin)
		    local editRegPas = guiGetText(GUI.edit.regPass)
		    local editRegPas2 = guiGetText(GUI.edit.regPass2)

			
	        dxDrawButton(sx/2-(424/2)*px, sy/2-(190/2)*py, 423*px,49*py, assets.editbox1, assets.editbox2, 7)
			dxDrawButton(sx/2-(424/2)*px, sy/2-(-10/2)*py, 423*px,49*py, assets.editbox1, assets.editbox2, 8)
			dxDrawButton(sx/2-(424/2)*px, sy/2-(-210/2)*py, 423*px,49*py, assets.editbox1, assets.editbox2, 9)
		


			if editRegLog == "" and guiGetVisible(GUI.edit.regLogin) == false then 
				dxDrawText("Введите в поле ваш логин", sx/2-(280/2)*px, sy/2+(1109/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
            else
        	    dxDrawText (editRegLog,  sx/2-(280/2)*px, sy/2+(1109/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
        	end
	
			if editRegPas == "" and guiGetVisible(GUI.edit.regPass) == false then 
				dxDrawText("Введите в поле ваш пароль",  sx/2-(280/2)*px, sy/2+(1505/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
            else
        	    dxDrawText (editRegPas, sx/2-(280/2)*px, sy/2+(1505/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
        	end
		
			if editRegPas2 == "" and guiGetVisible(GUI.edit.regPass2) == false then 
				dxDrawText("Введите в поле ваш пароль",  sx/2-(280/2)*px, sy/2+(1900/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
            else
        	    dxDrawText (editRegPas2, sx/2-(280/2)*px, sy/2+(1900/2)*py,  sx/2-(-1820/2)*px,sy/2+(-1390/2)*py, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "left", "center", false, false, false, false, false)
        	end
		
		dxDrawButton(sx/2-(424/2)*px, sy/2-(-404/2)*py, 423*px,49*py, assets.create1, assets.create2, 6)

	    dxDrawButton(sx/2-(424/2)*px, sy/2-(-550/2)*py, 425*px,56*py, assets.orenter1, assets.orenter2, 5)

		
        elseif (GUI.mainWindowMain) then -- 3

		end
		
	end
)



local sm = {}
sm.moov = 0

local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end

local start
local animTime
local tempPos = {{},{}}
local tempPos2 = {{},{}}


local function camRender()
	local now = getTickCount()
	if (sm.moov == 1) then
		local x1, y1, z1 = interpolateBetween(tempPos[1][1], tempPos[1][2], tempPos[1][3], tempPos2[1][1], tempPos2[1][2], tempPos2[1][3], (now-start)/animTime, "InOutQuad")
		local x2,y2,z2 = interpolateBetween(tempPos[2][1], tempPos[2][2], tempPos[2][3], tempPos2[2][1], tempPos2[2][2], tempPos2[2][3], (now-start)/animTime, "InOutQuad")
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientRender",root,camRender)
		--fadeCamera(true)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1) then
		killTimer(timer1)
		killTimer(timer2)
		removeEventHandler("onClientRender",root,camRender)
		--fadeCamera(true)
	end
	--fadeCamera(true)
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	--timer2 = setTimer(fadeCamera, time-1000, 1, false) -- 
	start = getTickCount()
	animTime = time
	tempPos[1] = {x1,y1,z1}
	tempPos[2] = {x1t,y1t,z1t}
	tempPos2[1] = {x2,y2,z2}
	tempPos2[2] = {x2t,y2t,z2t}
	addEventHandler("onClientRender",root,camRender)
	
	return true
end


function registerYep ()
	openRegisterWindow()
	
end
addEvent ( "registerYep", true )
addEventHandler ( "registerYep", root, registerYep )

addEventHandler("onClientClick", root, function(button, state, x, y) -- сюда
	if (GUI.mainWindowOpened) and (button == "left") and (state == "up") then -- // Страница логина
		
		if isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(130/2)*py, 423*px,49*py) then	-- Поле ввода логина 		
			guiSetVisible(GUI.edit.login, true)
			guiBringToFront(GUI.edit.login)
			if stateEdit_pass == true then stateEdit_pass = false end 
			stateEdit_login = true
			editStat_l = 0
		elseif isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(-69/2)*py, 423*px,49*py) then		-- Поле ввода пароля
			guiSetVisible(GUI.edit.password, true)
			guiBringToFront(GUI.edit.password)
			if stateEdit_login == true then stateEdit_login = false end 
			stateEdit_pass = true
			editStat_p = 0
		elseif isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(-264/2)*py, 423*px,49*py) then		-- Кнопка "войти"
			local login = guiGetText(GUI.edit.login)
			local password = guiGetText(GUI.edit.password)
			loginMe(login, password)
			stateEdit_login = false
			stateEdit_pass = false
			setElementData(localPlayer, "timeSlide", 0)
		elseif isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(-498/2)*py, 425*px,56*py) then	-- Кнопка "регистрации"
			openRegisterWindow()
			setElementData(localPlayer, "timeSlide", 0)
		elseif isCursorOverRectangle(99999*sx, (screenH+9999999*sy)/2, 0*sx, 0*sy) then	-- Кнопка "забыли пароль?"
			openMainWindow()
		elseif dxDrawCursor(sx/2-(-348/2)*px, sy/2-(-420/2)*py, 37*px,16*py) then
			if getElementData(localPlayer, "passwordYep") == false then 
			    setElementData(localPlayer, "passwordYep", true)
			else
				setElementData(localPlayer, "passwordYep", false)
			end 
		end	
	elseif (GUI.registerWindowOpened) and (button == "left") and (state == "up") then -- // Страница Регистрации
		if isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(190/2)*py, 423*px,49*py) then			-- Поле ввода логина
			guiSetVisible(GUI.edit.regLogin, true)
			guiBringToFront(GUI.edit.regLogin)
			if stateEdit_passr == true then stateEdit_passr = false end 
			if stateEdit_pass2r == true then stateEdit_pass2r = false end 
			stateEdit_logr = true
		elseif isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(-10/2)*py, 423*px,49*py) then		-- Поле ввода пароля
			guiSetVisible(GUI.edit.regPass, true)
			guiBringToFront(GUI.edit.regPass)
			if stateEdit_logr == true then stateEdit_logr = false end 
			if stateEdit_pass2r == true then stateEdit_pass2r = false end 
			stateEdit_passr = true
		elseif isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(-210/2)*py, 423*px,49*py) then		-- Поле ввода подтверждения пароля
			guiSetVisible(GUI.edit.regPass2, true)
			guiBringToFront(GUI.edit.regPass2)
			if stateEdit_logr == true then stateEdit_logr = false end 
			if stateEdit_passr == true then stateEdit_passr = false end 
			stateEdit_pass2r = true
		elseif isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(-404/2)*py, 423*px,49*py) then			-- Кнопка регистрации
			local login = guiGetText(GUI.edit.regLogin)
			local pass = guiGetText(GUI.edit.regPass)
			local pass2 = guiGetText(GUI.edit.regPass2)
			registerMe(login, pass, pass2)
			stateEdit_logr = false
       		stateEdit_passr = false
        	stateEdit_pass2r = false
        	setElementData(localPlayer, "timeSlide", 0)
		elseif isCursorOverRectangle(sx/2-(424/2)*px, sy/2-(-550/2)*py, 425*px,56*py) then			-- Назад
			saveEditBox()
			guiSetText(GUI.edit.regLogin, "")
			guiSetText(GUI.edit.regPass, "")
			guiSetText(GUI.edit.regPass2, "")
			GUI.regEnteredLogin = ""
			GUI.regEnteredPass = ""
			GUI.regEnteredPass2 = ""
			openLoginWindow()
			stateEdit_logr = false
       		stateEdit_passr = false
        	stateEdit_pass2r = false
        	setElementData(localPlayer, "timeSlide", 0)
		end	
   elseif (GUI.mainWindowMain) and (button == "left") and (state == "up") then
   	    if isDxRectangle(screenW-99999/zoom, 0/zoom, 0/zoom, 0/zoom) then --- сюда
			openLoginWindow()
        	setElementData(localPlayer, "timeSlide", 0)
   	    end
	end
end)

function saveEditBox()
	if (source == GUI.edit.login) then
		GUI.enteredLogin = guiGetText(GUI.edit.login)
		guiSetVisible(GUI.edit.login, false)
		if (eventName == "onClientGUIAccepted") then
			guiSetVisible(GUI.edit.password, true)
			guiBringToFront(GUI.edit.password)
		end
	
	elseif (source == GUI.edit.password) then
		GUI.enteredPass = guiGetText(GUI.edit.password)
		guiSetVisible(GUI.edit.password, false)
		if (eventName == "onClientGUIAccepted") then
			local login = guiGetText(GUI.edit.login)
			local password = guiGetText(GUI.edit.password)
			loginMe(login, password)
		end
	
	elseif (source == GUI.edit.regLogin) then
		GUI.regEnteredLogin = guiGetText(GUI.edit.regLogin)
		guiSetVisible(GUI.edit.regLogin, false)
	
	elseif (source == GUI.edit.regPass) then
		GUI.regEnteredPass = guiGetText(GUI.edit.regPass)
		guiSetVisible(GUI.edit.regPass, false)
	
	elseif (source == GUI.edit.regPass2) then
		GUI.regEnteredPass2 = guiGetText(GUI.edit.regPass2)
		guiSetVisible(GUI.edit.regPass2, false)
	end
end
addEventHandler("onClientGUIBlur", resourceRoot, saveEditBox)
addEventHandler("onClientGUIAccepted", resourceRoot, saveEditBox)

function saveAllEdits()
	GUI.enteredLogin = guiGetText(GUI.edit.login)
	guiSetVisible(GUI.edit.login, false)
	GUI.enteredPass = guiGetText(GUI.edit.password)
	guiSetVisible(GUI.edit.password, false)
	GUI.regEnteredLogin = guiGetText(GUI.edit.regLogin)
	guiSetVisible(GUI.edit.regLogin, false)
	GUI.regEnteredPass = guiGetText(GUI.edit.regPass)
	guiSetVisible(GUI.edit.regPass, false)
	GUI.regEnteredPass2 = guiGetText(GUI.edit.regPass2)
	guiSetVisible(GUI.edit.regPass2, false)
end


function openMainWindow()
	showChat(false)
	hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()
	GUI.mainWindowMain = false
	GUI.mainWindowOpened = true
	GUI.registerWindowOpened = false
	guiSetInputMode("no_binds_when_editing")
	showCursor(true)

smoothMoveCamera(2075.0102539062,702.82647705078,42.582000732422,2074.1540527344,702.39556884766,42.297317504883,1996.9990234375,606.89630126953,32.880500793457,1996.1197509766,606.46350097656,32.6817703247074, 20000)


    hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()

end



function openLoginWindow()
	GUI.mainWindowOpened = true
	GUI.mainWindowMain = false
	GUI.registerWindowOpened = false
	guiSetInputMode("no_binds_when_editing")
	saveAllEdits()
	showCursor(true)
    showChat(false)
    hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()
end



function openRegisterWindow()
	GUI.mainWindowOpened = false
	GUI.mainWindowMain = false
	GUI.registerWindowOpened = true
	guiSetInputMode("no_binds_when_editing")
	saveAllEdits()
	showCursor(true)
	showChat(false)
    hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()

end

function closeAllWindows()
	GUI.mainWindowOpened = false
	GUI.mainWindowMain = false
	GUI.registerWindowOpened = false
	saveAllEdits()
	showCursor(false)
    showChat(true)
    hud = exports.aw_interface_hud:anim_false()
    radar = exports.aw_interface_radar:anim_false()
    speedometer = exports.aw_interface_speedometer:anim_false()
    setCameraTarget(localPlayer, localPlayer)
	fadeCamera(true)
	guiSetInputEnabled(false)
	removeEventHandler("onClientRender",root,camRender)
end


function dxDrawImageIcon(x, y, w, h, img)
	dxDrawImage(x, y, w, h, img, 0, 0, 0, tocolor(255, 255, 255, 255), false) 
	dxDrawImage(x, y+h-50, w, 71*sy, bShadow, 0, 0, 0, tocolor(255, 255, 255, 255), false) 
end

function dxDrawCenterText(text, x, y, w, h, color, font)
	dxDrawText ( text, x, y, x+w, y+h, color, 1, font, "center", "center", false, false, false, true );
end


function dxDrawRemberMe(x, y, w, h, imgX, imgY) --сюда
	if getElementData(localPlayer, "passwordYep") == false then 
	dxDrawImage(sx/2-(-348/2)*px, sy/2-(-420/2)*py, 37*px,16*py, "assets/aw_ui_auth_button_remember2.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	else
		dxDrawImage(sx/2-(-348/2)*px, sy/2-(-420/2)*py, 37*px,16*py, "assets/aw_ui_auth_button_remember1.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end 
end


function dxDrawCursor(x,y,w,h)
	if isCursorShowing() then
		local mx,my = getCursorPosition() 
		local cursorx,cursory = mx*screenW, my*screenH
		if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
			return true
		end
	end
    return false
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
