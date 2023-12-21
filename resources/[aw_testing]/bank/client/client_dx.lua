local x, y = guiGetScreenSize()

thisMenu = false
openAnimation = false
alpha = 0
local alphaL = 0
local alphaT = 255
local plus
local yPlus = 0
local windowTicket = false


allTicketsSum = localPlayer:getData("INF") or 0
allBankSum = 0

local typeList = {
"Пополнить",
"Вывести",
"Перевод"}

local selectedList = {}
for i = 1, 10 do
	selectedList[i] = false
end

selectedList[1] = true


--[[bindKey("F3", "down", function()
	if thisMenu == false then
		thisMenu = true
		addEventHandler("onClientRender", root, bankMenuRenderd)
		openAnimation = true
		showCursor(true)
		--showChat(false)
	else
		openAnimation = false
		showCursor(false)
		--showChat(true)
	end
end)]]


local leftAlpha = 255

function bankMenuRenderd()

	if openAnimation == true then
		alpha = alpha + 15
		if alpha >= 255 then
			alpha = 255
			thisMenu = true
		end
	else
		alpha = alpha - 15
		if alpha <= 0 then
			alpha = 0
			thisMenu = false
			removeEventHandler("onClientRender", root, bankMenuRenderd)
			windowTicket = false
			alphaT = 255
			EditTextSec = ""
			EditText = ""
		end
	end

	if selectedList[3] then
		alphaL = alphaL + 15
		if alphaL >= 255 then
			alphaL = 255
		end
	else
		alphaL = alphaL - 15
		if alphaL <= 0 then
			alphaL = 0
		end
	end

	if not windowTicket then
		alphaT = alphaT + 15
		if alphaT >= 255 then
			alphaT = 255
		end
	else
		alphaT = alphaT - 15
		if alphaT <= 0 then
			alphaT = 0
		end
	end
	plus = ((alpha-255)/10)/px


	local cx, cy = x/2-694/2/px, y/2-710/2/px+plus

	dxDrawImage (cx, cy, 694/px, 711/px, "file/fon.png", 0, 0, 0, tocolor(255, 255, 255, alpha) )
	--dxDrawImage (cx, cy, 694/px, 711/px, "file/fonSec.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(1-alphaT/255)) )
	dxDrawImage (cx+81/px, cy+260/px, 530/px, 78/px, "file/tickBack.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(1-alphaT/255)) )
	dxText(cx+47/px, cy+46/px, 300/px, 20/px, tocolor(255, 255, 255, alpha), bold, "left", "Банкомат")


	allBankSum = getPlayerBankMoney()

	dxText(cx+80/px, cy+160/px, 711/px, 25/px, tocolor(255, 255, 255, alpha), bold, "left", "Состояние счета")
	dxText(cx-110/px, cy+160/px, 711/px, 25/px, tocolor(255, 255, 255, alpha), bold, "right", "$ "..ConvertPrice(allBankSum))

	-- окно банка
	for i = 1, 3 do
		dxDrawTupeButton(cx+168/px+123/px*(i-1), cy+272/px, alpha*(alphaT/255), typeList[i], selectedList[i], i)
	end
	dxDrawEdit(cx+204/px, cy+363/px, 291/px, 55/px, 4, alpha*(alphaL/255)*(alphaT/255), "Введите логин")

	dxDrawEditSec(cx+204/px, cy+433/px, 291/px, 55/px, 5, alpha*(alphaT/255), "Введите сумму")

	dxDrawButton(cx+210/px, cy+501/px, alpha*(alphaT/255), "Очистить", 6)
	dxDrawButton(cx+355/px, cy+501/px, alpha*(alphaT/255), "Продолжить", 7)
	--------------


	------- штрафы

	allTicketsSum = localPlayer:getData("INF") or 0

	dxText(cx+117/px, cy+285/px, 711/px, 25/px, tocolor(255, 255, 255, alpha*(1-alphaT/255)), boldSmallSec, "left", "Состояние штрафов")
	dxText(cx-143/px, cy+285/px, 711/px, 25/px, tocolor(255, 255, 255, alpha*(1-alphaT/255)), boldSmallSec, "right", "$ "..ConvertPrice(allTicketsSum))

	dxDrawEditSec(cx+204/px, cy+433/px-65/px, 291/px, 55/px, 8, alpha*(1-alphaT/255), "Введите сумму")

	--dxDrawImage (cx+210/px, cy+438/px, 280/px, 44/px, "file/buttonSec.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(1-alphaT/255)) )
	--dxDrawImage (cx+210/px, cy+438/px+59/px, 280/px, 44/px, "file/buttonSec.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(1-alphaT/255)) )

	dxDrawSecButton(cx+210/px, cy+438/px, alpha*(1-alphaT/255), "Оплатить указанную сумму", 9)
	dxDrawSecButton(cx+210/px, cy+438/px+59/px, alpha*(1-alphaT/255), "Оплатить все", 10)
	-------------



	---- низ
	dxDrawImage (cx+318/px, cy+629/px, 18/px, 26/px, "file/bank.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(1-alphaT/255)) )
	dxDrawImage (cx+367/px, cy+629/px, 24/px, 26/px, "file/tick.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(alphaT/255)) )

	dxDrawImage (cx+318/px, cy+629/px, 18/px, 26/px, "file/bankSelected.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(alphaT/255)) )
	dxDrawImage (cx+367/px, cy+629/px, 24/px, 26/px, "file/tickSelected.png", 0, 0, 0, tocolor(255, 255, 255, alpha*(1-alphaT/255)) )
	--------



	--dxDrawRectangle(cx+80/px+119/px+29/px+yPlus+60/px+47/px, cy+175/px+120/px +245/px, 144/px, 41/px, tocolor(255, 0, 0, alpha*0.5))

end







function mestaTPs(button, state)
	if thisMenu == true then
		if button == "left" and state == "down" then
			local cx, cy = x/2-694/2/px+yPlus, y/2-710/2/px+plus
			if cursorPosition(cx+631/px-yPlus, cy+47/px, 22/px, 22/px) then -- закрыть
				openAnimation = false
				showCursor(false)
				--showChat(true)
			end

			if cursorPosition(cx+318/px, cy+629/px, 18/px, 26/px) then -- переключить на банкомат
				windowTicket = false
				EditTextSec = ""
				EditText = ""
			end
			if cursorPosition(cx+367/px, cy+629/px, 24/px, 26/px) then -- переключить на штрафы
				windowTicket = true
				EditTextSec = ""
				EditText = ""
			end

			if not windowTicket then
				if cursorPosition(cx+210/px, cy+501/px, 135/px, 44/px) then
					EditTextSec = ""
					EditText = ""
				end
				if cursorPosition(cx+355/px, cy+501/px, 135/px, 44/px) then
					if selectedList[1] then
						if EditTextSec ~= "" then
							if tonumber(EditTextSec)>0 then
								if getPlayerMoney(localPlayer) >= tonumber(EditTextSec) then
									triggerServerEvent("deposit", resourceRoot, tonumber(EditTextSec))
									--outputChatBox("Вы успешно пополнили счет на "..ConvertPrice(tonumber(EditTextSec)).."$",255,255,255)
								else
									outputChatBox("[Банк] У вас не хватает наличных для пополнения счета!",255,0,0)
								end
							else
								outputChatBox("[Банк] Введите корректные данные для пополнения!",255,0,0)
							end
						else
							outputChatBox("[Банк] Введите необходимую сумму для пополнения",255,255,255)
						end
					end
					if selectedList[2] then
						if EditTextSec ~= "" then
							if allBankSum > 0 then
								if tonumber(EditTextSec)>0 then
									if getPlayerMoney(localPlayer) + tonumber(EditTextSec) > 99999999 then
										outputChatBox("[Банк] Вы не можете иметь большое количество наличных!",255,255,255)
									else
										triggerServerEvent("withdraw", resourceRoot, tonumber(EditTextSec))
										--outputChatBox("Вы успешно сняли со счета "..ConvertPrice(tonumber(EditTextSec)).."$",255,255,255)
									end
								else
									outputChatBox("[Банк] Введите корректные данные для снятия средств!",255,0,0)
								end
							else
								outputChatBox("[Банк] У вас не хватает денег для снятия со счета!",255,0,0)
							end
						else
							outputChatBox("[Банк] Введите необходимую сумму для снятия наличных",255,255,255)
						end
					end
					if selectedList[3] then
						if EditTextSec ~= "" then
							if EditText ~="" then
								if tonumber(allBankSum) >= tonumber(EditTextSec) then
									if tonumber(EditTextSec)>0 then
										triggerServerEvent("transfer", resourceRoot, tonumber(EditTextSec), EditText)
										--outputChatBox("Вы успешно перевели "..ConvertPrice(tonumber(EditTextSec)).."$ игроку "..EditText,255,255,255)
									else
										outputChatBox("[Банк] Введите корректные данные для перевода средств!",255,0,0)
									end
								else
									outputChatBox("[Банк] У вас не хватает средств на банковском счету для перевода!",255,0,0)
								end
							else
								outputChatBox("[Банк] Введите логин получателя!",255,255,255)
							end
						else
							outputChatBox("[Банк] Введите необходимую сумму для перевода",255,255,255)
						end
					end
				end
				if cursorPosition(cx+168/px+123/px*(1-1), cy+272/px, 117/px, 40/px) then
					selectedList[1] = true
					selectedList[2] = false
					selectedList[3] = false
					EditTextSec = ""
				end
				if cursorPosition(cx+168/px+123/px*(2-1), cy+272/px, 117/px, 40/px) then
					selectedList[2] = true
					selectedList[1] = false
					selectedList[3] = false
					EditTextSec = ""
				end
				if cursorPosition(cx+168/px+123/px*(3-1), cy+272/px, 117/px, 40/px) then
					selectedList[3] = true
					selectedList[1] = false
					selectedList[2] = false
					EditTextSec = ""
					EditText = ""
				end
				if cursorPosition(cx+204/px, cy+363/px, 291/px, 55/px) then -- login
					if selectedList[3] == true then
						if EditSelected then return end
						EditSelected = true
						addEventHandler("onClientCharacter", root, forEditBoxes)
						addEventHandler("onClientKey", root, lockKeysEditBox)
						textTimer = setTimer(function() countL = getTickCount() end, 1000, 0)
					end
				else
					if isTimer (textTimer) then killTimer (textTimer) end
					EditSelected = false
					removeEventHandler("onClientCharacter", root, forEditBoxes)
					removeEventHandler("onClientKey", root, lockKeysEditBox)
				end
				if cursorPosition(cx+204/px, cy+433/px, 291/px, 55/px) then -- price bank
					if EditSelectedSec then return end
					EditSelectedSec = true
					addEventHandler("onClientCharacter", root, forEditBoxesSec)
					addEventHandler("onClientKey", root, lockKeysEditBoxSec)
					textTimerSec = setTimer(function() countL = getTickCount() end, 1000, 0)
				else
					if isTimer (textTimerSec) then killTimer (textTimerSec) end
					EditSelectedSec = false
					removeEventHandler("onClientCharacter", root, forEditBoxesSec)
					removeEventHandler("onClientKey", root, lockKeysEditBoxSec)
				end
			end
			if windowTicket then
				if cursorPosition(cx+210/px, cy+438/px, 280/px, 44/px) then
					if EditTextSec ~= "" then
						if tonumber(allBankSum) >= tonumber(EditTextSec) then
							if tonumber(EditTextSec)>0 then
								if allTicketsSum > 0 then
									triggerServerEvent("payFines", resourceRoot, tonumber(EditTextSec))
									--outputChatBox("Вы успешно оплатили штрафы на сумму: "..ConvertPrice(tonumber(EditTextSec)).."$",255,255,255)
								else
									outputChatBox("[Банк] У вас нет неоплаченных штрафов",255,255,255)
								end
							else
								outputChatBox("[Банк] Введите корректные данные для оплаты!",255,0,0)
							end
						else
							outputChatBox("[Банк] У вас не хватает средств на банковском счету для оплаты!",255,0,0)
						end
					else
						outputChatBox("[Банк] Введите необходимую сумму для оплаты", 255,255,255)
					end
				end
				if cursorPosition(cx+210/px, cy+438/px+59/px, 280/px, 44/px) then
					if tonumber(allBankSum) >= tonumber(allTicketsSum) then
						if allTicketsSum > 0 then
							triggerServerEvent("fines", resourceRoot)
							--outputChatBox("Вы успешно оплатили все штрафы!",255,255,255)
						else
							outputChatBox("[Банк] У вас нет неоплаченных штрафов",255,255,255)
						end
					else
						outputChatBox("[Банк] У вас не хватает средств на банковском счету для оплаты!",255,0,0)
					end
				end
				if cursorPosition(cx+204/px, cy+433/px-65/px, 291/px, 55/px) then -- price ticket
					EditSelectedSec = true
					removeEventHandler("onClientCharacter", root, forEditBoxesSec)
					removeEventHandler("onClientKey", root, lockKeysEditBoxSec)
					addEventHandler("onClientCharacter", root, forEditBoxesSec)
					addEventHandler("onClientKey", root, lockKeysEditBoxSec)
					textTimerSec = setTimer(function() countL = getTickCount() end, 1000, 0)
				else
					if isTimer (textTimerSec) then killTimer (textTimerSec) end
					EditSelectedSec = false
					removeEventHandler("onClientCharacter", root, forEditBoxesSec)
					removeEventHandler("onClientKey", root, lockKeysEditBoxSec)
				end
			end
		end
	end
end
addEventHandler("onClientClick", root, mestaTPs)


function setVisible(boolean)
	if boolean then
		thisMenu = true
		addEventHandler("onClientRender", root, bankMenuRenderd)
		openAnimation = true
		showCursor(true)
		--showChat(false)
	else
		openAnimation = false
		showCursor(false)
		--showChat(true)
	end
end

function ClearEditBox()
	EditTextSec = ""
	EditText = ""
end
addEvent("Bank : ClearEditBox", true)
addEventHandler("Bank : ClearEditBox", resourceRoot, ClearEditBox)