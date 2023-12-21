
local font22 = dxCreateFont("files/RoadNumbers2.0.ttf", 22)
local font21 = dxCreateFont("files/RoadNumbers2.0.ttf", 21)
local font17 = dxCreateFont("files/RoadNumbers2.0.ttf", 17)
local font15 = dxCreateFont("files/RoadNumbers2.0.ttf", 15)
local EuroFont = dxCreateFont("files/EuroFont.ttf", 19)
local EuroFont2 = dxCreateFont("files/EuroFont.ttf", 22)

local arial23 = dxCreateFont("files/arial.ttf", 23)
local arial231 = dxCreateFont("files/arial_bolditalicmt.ttf", 23)

local gost_bu31 = dxCreateFont("files/gost_bu.ttf", 31)
local gost_bu37 = dxCreateFont("files/gost_bu.ttf", 37)

delayedPlates = {}
gameScreenState = false


-- Типы номеров:
-- a-a123bc123, либо a-a123bc12		обычный номер
-- b-a1234123, либо b-a123412		полицейская машина
-- с-1234ab12						обычный мотоцикл
-- d-1234a12						полицейский мотоцикл
-- e-123abc12						казахский номер
-- f-ab1234cd						украинский номер
-- g-1234ab5						белорусский номер	
-- h-huinia							надпись	
-- i-ab12312						желтые номера (общ. транспорт)
-- j-a123bc							федеральные номера (с флагом вместо региона)
-- k-1234bc77						военные номера
-- l-1234b01277						депломатовские номера
-- m-00000					        арабские номера

function generatePlate(plateID)
	local plate
	if (string.sub(plateID, 1, 1) == "a") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local ch1, dig1, dig2, dig3, ch2, ch3, reg1, reg2, reg3 = explodePlateID(plateID)
		dxDrawImage(0, 0, 235, 50, "files/plate_a.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText(ch1, 11, 14, 41, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig1, 38, 14, 68, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig2, 64, 14, 94, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig3, 91, 14, 121, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(ch2, 118, 14, 148, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(ch3, 144, 14, 174, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		if (reg3 == "") then
			dxDrawText(reg1, 178, 1, 208, 31, tocolor(0, 0, 0, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 195, 1, 225, 31, tocolor(0, 0, 0, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		else
			dxDrawText(reg1, 176, 1, 193, 31, tocolor(0, 0, 0, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 193, 1, 210, 31, tocolor(0, 0, 0, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg3, 210, 1, 227, 31, tocolor(0, 0, 0, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		end	
		
	elseif (string.sub(plateID, 1, 1) == "b") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local ch1, dig1, dig2, dig3, dig4, reg1, reg2, reg3 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 50, "files/plate_b.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(ch1, 19, 15, 46, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig1, 54, 15, 81, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 81, 15, 108, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 109, 15, 136, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig4, 136, 15, 163, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		if (reg3 == "") then
			dxDrawText(reg1, 182, 2, 209, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 199, 2, 226, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		else
			dxDrawText(reg1, 172, 2, 199, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 187, 2, 214, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg3, 202, 2, 229, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		end	
		
	elseif (string.sub(plateID, 1, 1) == "c") then
		plate = dxCreateRenderTarget(110, 82, false)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local dig1, dig2, dig3, dig4, ch1, ch2, reg1, reg2 = explodePlateID(plateID)
        dxDrawImage(0, 0, 110, 82, "files/plate_c.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(dig1, 12, 17, 32, 37, tocolor(0, 0, 0, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 34, 17, 54, 37, tocolor(0, 0, 0, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 56, 17, 76, 37, tocolor(0, 0, 0, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig4, 78, 17, 98, 37, tocolor(0, 0, 0, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(ch1, 06, 57, 26, 77, tocolor(0, 0, 0, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
        dxDrawText(ch2, 30, 57, 50, 77, tocolor(0, 0, 0, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
		dxDrawText(reg1, 60, 57, 80, 77, tocolor(0, 0, 0, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
		dxDrawText(reg2, 82, 57, 102, 77, tocolor(0, 0, 0, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
		
	elseif (string.sub(plateID, 1, 1) == "d") then
		plate = dxCreateRenderTarget(110, 82, false)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local dig1, dig2, dig3, dig4, ch1, reg1, reg2 = explodePlateID(plateID)
        dxDrawImage(0, 0, 110, 82, "files/plate_d.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(dig1, 12, 17, 32, 37, tocolor(255, 255, 255, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 34, 17, 54, 37, tocolor(255, 255, 255, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 56, 17, 76, 37, tocolor(255, 255, 255, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig4, 78, 17, 98, 37, tocolor(255, 255, 255, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(ch1,  17, 57, 37, 77, tocolor(255, 255, 255, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
        dxDrawText(reg1, 60, 57, 80, 77, tocolor(255, 255, 255, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
        dxDrawText(reg2, 82, 57, 102, 77, tocolor(255, 255, 255, 255), 1.00, font17, "center", "bottom", false, false, false, false, false)
		
	elseif (string.sub(plateID, 1, 1) == "e") then
		plate = dxCreateRenderTarget(235, 49, false)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local dig1, dig2, dig3, ch1, ch2, ch3, reg1, reg2 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 49, "files/plate_e.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(dig1, 37, 23, 57, 43, tocolor(0, 0, 0, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 61, 23, 81, 43, tocolor(0, 0, 0, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 85, 23, 105, 43, tocolor(0, 0, 0, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
        dxDrawText(ch1, 110, 20, 130, 40, tocolor(0, 0, 0, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
        dxDrawText(ch2, 133, 20, 153, 40, tocolor(0, 0, 0, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
        dxDrawText(ch3, 156, 20, 176, 40, tocolor(0, 0, 0, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
        dxDrawText(reg1, 184, 23, 204, 43, tocolor(0, 0, 0, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
        dxDrawText(reg2, 208, 23, 228, 43, tocolor(0, 0, 0, 255), 1.00, font21, "center", "bottom", false, false, false, false, false)
		
	elseif (string.sub(plateID, 1, 1) == "v") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local dig1, dig2, dig3, dig4, ch1, ch2, reg1, reg2, reg3 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 50, "files/plate_v.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(dig1, 23, 24, 36, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 50, 24, 62, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 19, 24, 143, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig4, 63, 24, 153, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(ch1, 230, 24, 34, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(ch2, 250, 24, 62, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
      --  dxDrawText(reg1, 185, 11, 205, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
     --   dxDrawText(reg2, 202, 11, 222, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
	    if (reg3 == "") then
			dxDrawText(reg1, 178, 1, 208, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 195, 1, 225, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		else
			dxDrawText(reg1, 176, 1, 193, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 193, 1, 210, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg3, 210, 1, 227, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		end

	elseif (string.sub(plateID, 1, 1) == "f") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local ch1, ch2, dig1, dig2, dig3, dig4, ch3, ch4 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 50, "files/plate_f.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(ch1, 30, 15, 50, 35, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
        dxDrawText(ch2, 57, 15, 77, 35, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
        dxDrawText(dig1, 87, 15, 107, 35, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
        dxDrawText(dig2, 107, 15, 127, 35, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
        dxDrawText(dig3, 127, 15, 147, 35, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
        dxDrawText(dig4, 147, 15, 167, 35, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
        dxDrawText(ch3, 176, 15, 196, 35, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
        dxDrawText(ch4, 203, 16, 223, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu31, "center", "center", false, false, false, false, false)
		
	elseif (string.sub(plateID, 1, 1) == "g") then
		plate = dxCreateRenderTarget(234, 50, false)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local dig1, dig2, dig3, dig4, ch1, ch2, dig5 = explodePlateID(plateID)
        dxDrawImage(0, 0, 234, 50, "files/plate_g.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(dig1, 35, 16, 55, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu37, "center", "center", false, false, false, false, false)
        dxDrawText(dig2, 57, 16, 77, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu37, "center", "center", false, false, false, false, false)
        dxDrawText(dig3, 78, 16, 98, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu37, "center", "center", false, false, false, false, false)
        dxDrawText(dig4, 101, 16, 121, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu37, "center", "center", false, false, false, false, false)
        dxDrawText(ch1, 137, 16, 157, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu37, "center", "center", false, false, false, false, false)
        dxDrawText(ch2, 168, 16, 188, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu37, "center", "center", false, false, false, false, false)
        dxDrawText(dig5, 207, 16, 227, 36, tocolor(0, 0, 0, 255), 1.00, gost_bu37, "center", "center", false, false, false, false, false)
		
	elseif (string.sub(plateID, 1, 1) == "h") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local text = string.sub(plateID, 3, string.len(plateID))
        dxDrawImage(-0.75, -0.75, 235, 50, "files/plate_h.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(text, 0, 0, 235, 50, tocolor(0, 0, 0, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
	elseif (string.sub(plateID, 1, 1) == "o") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local text = string.sub(plateID, 3, string.len(plateID))
        dxDrawImage(-0.75, -0.75, 235, 50, "files/plate_hgold.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(text, 0, 0, 235, 50, tocolor(0, 0, 0, 255), 1.00, arial231, "center", "center", false, false, false, false, false)
	elseif (string.sub(plateID, 1, 1) == "r") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local text = string.sub(plateID, 3, string.len(plateID))
        dxDrawImage(-0.75, -0.75, 235, 50, "files/plate_hblack.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(text, 0, 0, 235, 50, tocolor(255, 255, 255, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
	elseif (string.sub(plateID, 1, 1) == "p") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local text = string.sub(plateID, 3, string.len(plateID))
		dxDrawImage(0, 0, 235, 50, "files/plate_ph.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		textmines = 3
		if (string.len(text) <= 5) then
			textmines = 1
		elseif(string.len(text) == 6) then
			textmines = 2
		elseif(string.len(text) >= 8) then
			textmines = 4
		end
		if not (string.len(text) > 8) then
			if (string.len(text) > 4) then
				if (string.len(text) > 7) then
					dxDrawText(string.sub(text,((string.len(text))-2), string.len(text)), 0, 0, 340, 50, tocolor(0, 0, 0, 255), 0.9, arial23, "center", "center", false, false, false, false, false)
					dxDrawText(string.sub(text, -(string.len(text)), -((string.len(text))-textmines)), 0, 0, 170, 50, tocolor(255, 255, 255, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
				else
					dxDrawText(string.sub(text, ((string.len(text))-2), string.len(text)), 0, 0, 340, 50, tocolor(0, 0, 0, 255), 0.9, arial23, "center", "center", false, false, false, false, false)
					dxDrawText(string.sub(text, -(string.len(text)), -((string.len(text))-textmines)), 0, 0, 190, 50, tocolor(255, 255, 255, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
				end
			else
				dxDrawText(text, 0, 0, 190, 50, tocolor(255, 255, 255, 255), 1.00, arial23, "center", "center", false, false, false, false, false)
			end	
		end
	elseif (string.sub(plateID, 1, 1) == "i") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local ch1, ch2, dig1, dig2, dig3, reg1, reg2 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 50, "files/plate_i.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(ch1, 26, 24, 46, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(ch2, 52, 24, 72, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig1, 85, 24, 105, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 111, 24, 131, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 137, 24, 157, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(reg1, 185, 11, 205, 31, tocolor(0, 0, 0, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
        dxDrawText(reg2, 202, 11, 222, 31, tocolor(0, 0, 0, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		
	elseif (string.sub(plateID, 1, 1) == "j") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local ch1, dig1, dig2, dig3, ch2, ch3 = explodePlateID(plateID)
		dxDrawImage(0, 0, 235, 50, "files/plate_j.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText(ch1, 11, 14, 41, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig1, 38, 14, 68, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig2, 64, 14, 94, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig3, 91, 14, 121, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(ch2, 118, 14, 148, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(ch3, 144, 14, 174, 44, tocolor(0, 0, 0, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		
	elseif (string.sub(plateID, 1, 1) == "k") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local dig1, dig2, dig3, dig4, ch1, ch2, reg1, reg2, reg3 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 50, "files/plate_k.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(dig1, 23, 24, 36, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 50, 24, 62, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 19, 24, 143, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig4, 63, 24, 153, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(ch1, 230, 24, 34, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(ch2, 250, 24, 62, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
      --  dxDrawText(reg1, 185, 11, 205, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
     --   dxDrawText(reg2, 202, 11, 222, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
	    if (reg3 == "") then
			dxDrawText(reg1, 178, 1, 208, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 195, 1, 225, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		else
			dxDrawText(reg1, 176, 1, 193, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg2, 193, 1, 210, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
			dxDrawText(reg3, 210, 1, 227, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		end	
		
	elseif (string.sub(plateID, 1, 1) == "l") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
	    local dig1, dig2, dig3, ch1, dig4, dig5, dig6, reg1, reg2 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 50, "files/plate_l.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(dig1, 23, 24, 30, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 50, 24, 56, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 19, 24, 141, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
	    dxDrawText(ch1, 195, 24, 20, 44, tocolor(255, 255, 255, 255), 1.00, font22, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig4, 120, 24, 141, 44, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig5, 155, 24, 141, 44, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig6, 190, 24, 141, 44, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
        dxDrawText(reg1, 185, 11, 205, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
        dxDrawText(reg2, 202, 11, 222, 31, tocolor(255, 255, 255, 255), 1.00, font15, "center", "bottom", false, false, false, false, false)
	    
	elseif (string.sub(plateID, 1, 1) == "m") then
		plate = dxCreateRenderTarget(235, 50, true)
		if not plate then return end
		dxSetRenderTarget(plate, true)
		dxSetBlendMode("modulate_add")
		local  reg1, dig1, dig2, dig3, dig4 = explodePlateID(plateID)
        dxDrawImage(0, 0, 235, 50, "files/plate_m.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText(reg1, 23, 24, 25, 43, tocolor(255, 255, 255, 255), 1.00, EuroFont, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig1, 195, 24, 46, 44, tocolor(0, 0, 0, 255), 1.00, EuroFont2, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig2, 245, 24, 46, 44, tocolor(0, 0, 0, 255), 1.00, EuroFont2, "center", "bottom", false, false, false, false, false)
        dxDrawText(dig3, 295, 24, 46, 44, tocolor(0, 0, 0, 255), 1.00, EuroFont2, "center", "bottom", false, false, false, false, false)
		dxDrawText(dig4, 345, 24, 46, 44, tocolor(0, 0, 0, 255), 1.00, EuroFont2, "center", "bottom", false, false, false, false, false)
	
	end
	dxSetBlendMode("blend")
	dxSetRenderTarget()
	dxSetBlendMode("add")
	local platePixels = dxGetTexturePixels(plate)
	textures[plateID] = dxCreateTexture(platePixels)
	dxSetBlendMode("blend")
	-- if (string.sub(plateID, 1, 1) ~= "h") then
		-- platePixels = dxConvertPixels(platePixels, 'png')
		--local plateFile = fileCreate("images/"..plateID..".png")
		--fileWrite(plateFile, platePixels)
		--fileClose(plateFile)
	-- end
	return textures[plateID], platePixels
end

function explodePlateID(plateID)
	return string.sub(plateID, 3, 3), string.sub(plateID, 4, 4), string.sub(plateID, 5, 5), string.sub(plateID, 6, 6), string.sub(plateID, 7, 7), string.sub(plateID, 8, 8), string.sub(plateID, 9, 9), string.sub(plateID, 10, 10), string.sub(plateID, 11, 11)
end

function initGameState()
	gameScreenState = true
	removeEventHandler("onClientCursorMove", root, initGameState)
	drawDelayedPlates()
end
addEventHandler("onClientCursorMove", root, initGameState)

addEventHandler("onClientRestore",root,
	function()
		gameScreenState = true
		drawDelayedPlates()
	end
)

addEventHandler("onClientMinimize",root,
	function()
		gameScreenState = false
		--setElementHealth( localPlayer, 0 )
	end
)

function drawDelayedPlates()
	for i, vehicle in pairs(delayedPlates) do
		applyPlateToVehicle(vehicle)
		delayedPlates[i] = nil
	end	
end