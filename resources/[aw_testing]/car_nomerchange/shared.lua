
storageTime = 86400*30 -- 1 месяц

savingPrices = {
	saveSetRandom = {amount = 350000, currency = "RUB", text = "350 000₽"},
	saveLoad = {amount = 700000, currency = "RUB", text = "700 000₽"},
	onlyLoad = {amount = 500000, currency = "RUB", text = "500 000₽"},
}


isBike = {
	[448] = true,
	[461] = true,
	[462] = true,
	[468] = true,
	[521] = true,
	[522] = true,
	[586] = true,
}




function nomerIsCorrect(nomer)
	local test = string.sub(nomer, 1, 1)
	if (test == "a") then
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9, 11)
		return checkNomerA(shNomer, region)
	elseif (test == "v" ) then 
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9, 11)
		return checkNomerVoennye(shNomer, region)

	elseif (test == "j") then 
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9, 10)
		return checkNomerJ(shNomer, region)
	elseif (test == "b") then
		return true
		
	elseif (test == "c") then
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9, 10)
		return checkNomerC(shNomer, region)
		
	elseif (test == "d") then
		return true
		
	elseif (test == "e") then
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9, 10)
		return checkNomerE(shNomer, region)
		
	elseif (test == "f") then
		local shNomer = string.sub(nomer, 3, 10)
		return checkNomerF(shNomer)
		
	elseif (test == "g") then
		local shNomer = string.sub(nomer, 3, 10)
		return checkNomerG(shNomer)
		
	elseif (test == "h") then
		local shNomer = string.sub(nomer, 3)
		return checkNomerH(shNomer)
		
	else
		return false
	end
end

local regOf3 = {
	[102] = true, [103] = true, [109] = true, [113] = true, [116] = true, [118] = true,
	[121] = true, [123] = true, [124] = true, [125] = true, [134] = true, [136] = true, [138] = true,
	[142] = true, [150] = true, [152] = true, [154] = true, [159] = true, [161] = true, [163] = true,
	[164] = true, [173] = true, [174] = true, [177] = true, [178] = true, [186] = true, [190] = true,
	[196] = true, [197] = true, [198] = true, [199] = true, [716] = true, [750] = true, [763] = true, [777] = true,
	[790] = true, [797] = true, [799] = true, 
}

local allowedBukv = {
	["a"] = true, ["b"] = true, ["e"] = true, ["k"] = true, ["m"] = true, ["h"] = true, ["o"] = true,
	["p"] = true, ["c"] = true, ["t"] = true, ["y"] = true, ["x"] = true
}

local allowedCifr = {
	["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true,
	["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true
}

local allowedUkrAndByel = {
	["A"] = true, ["B"] = true, ["E"] = true, ["I"] = true, ["K"] = true, ["M"] = true, ["H"] = true,
	["O"] = true, ["P"] = true, ["C"] = true, ["T"] = true, ["X"] = true
}

local allowedKazakh = {
	["A"] = true, ["B"] = true, ["C"] = true, ["D"] = true, ["E"] = true, ["F"] = true, ["G"] = true,
	["H"] = true, ["I"] = true, ["J"] = true, ["K"] = true, ["L"] = true, ["M"] = true, ["N"] = true,
	["O"] = true, ["P"] = true, ["Q"] = true, ["R"] = true, ["S"] = true, ["T"] = true, ["U"] = true,
	["V"] = true, ["W"] = true, ["X"] = true, ["Y"] = true, ["Z"] = true,
}

local allowedForH = {
	-- Цифры
	"1", "2", "3", "4", "5", "6", "7", "8", "9", "5", 
	-- Латинские буквы
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", 
	"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", 
	"U", "V", "W", "X", "Y", "Z", 
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", 
	"k", "l", "m", "n", "o", "p", "q", "r", "s", "t", 
	"u", "v", "w", "x", "y", "z", 
	-- Символы
	"!", "@", "#", "$", "%", "^", "&", "*", "(", ")", 
	"-", "_", "=", "+", "[", "]", "{", "}", "/", "|",
	";", ":", "'", "<", ">", ",", ".", "?", "\\", "\"",
	" ", "\t",
}
local tempArray = {}
for _, value in ipairs(allowedForH) do
	tempArray[string.byte(value)] = true
end
allowedForH = tempArray
tempArray = nil

function checkNomerA(nomer, region)		-- Российский номер
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 2, 4) )
	local nRegion = tonumber(region)
	local b1, b2, b3 = string.sub(nomer, 1, 1), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3 = string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	local r1, r2, r3 = string.sub(region, 1, 1), string.sub(region, 2, 2), string.sub(region, 3, 3)
	if (r3 == "") then r3 = "0" end
	
	if (nomerLength < 1) or (nomerLength > 6) then return false end
	if (regionLength < 2) or (regionLength > 3) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 99) and (not regOf3[nRegion]) then return false end
	if (nRegion < 100) and (string.len(region) > 2) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2] and allowedCifr[r3]) then return false end
	if not (allowedBukv[b1] and allowedBukv[b2] and allowedBukv[b3]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerJ(nomer, region)		-- Российский номер ~ ФЕДЕРАЛЬНЫЕ 
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 2, 4) )
	local nRegion = tonumber(region)
	local b1, b2, b3 = string.sub(nomer, 1, 1), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3 = string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	local r1, r2, r3 = string.sub(region, 1, 1), string.sub(region, 2, 2), string.sub(region, 3, 3)
	if (r3 == "") then r3 = "0" end
	
	if (nomerLength < 1) or (nomerLength > 6) then return false end
	if (regionLength < 2) or (regionLength > 3) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 99) and (not regOf3[nRegion]) then return false end
	if (nRegion < 100) and (string.len(region) > 2) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2] and allowedCifr[r3]) then return false end
	if not (allowedBukv[b1] and allowedBukv[b2] and allowedBukv[b3]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerVoennye(nomer, region)		-- Военные
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 2, 4) )
	local nRegion = tonumber(region)
	local b1, b2, b3 = string.sub(nomer, 1, 1), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3 = string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	local r1, r2, r3 = string.sub(region, 1, 1), string.sub(region, 2, 2), string.sub(region, 3, 3)
	if (r3 == "") then r3 = "0" end
	
	if (nomerLength < 1) or (nomerLength > 6) then return false end
	if (regionLength < 2) or (regionLength > 3) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 99) and (not regOf3[nRegion]) then return false end
	if (nRegion < 100) and (string.len(region) > 2) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2] and allowedCifr[r3]) then return false end
	if not (allowedBukv[b1] and allowedBukv[b2] and allowedBukv[b3]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerC(nomer, region)		-- Мотоциклетный номер
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 1, 4) )
	local nRegion = tonumber(region)
	local b1, b2 = string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3, c4 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	local r1, r2, r3 = string.sub(region, 1, 1), string.sub(region, 2, 2), string.sub(region, 3, 3)
	if (r3 == "") then r3 = "0" end
	
	if (nomerLength < 1) or (nomerLength > 6) then return false end
	if (regionLength ~= 2) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end	
	if (nRegion > 99) and (not regOf3[nRegion]) then return false end	
	if (nRegion < 100) and (string.len(region) > 2) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2] and allowedCifr[r3]) then return false end
	if not (allowedBukv[b1] and allowedBukv[b2]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3] and allowedCifr[c4]) then return false end
	return true	
end

function checkNomerE(nomer, region)		-- Номер Казахстана
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 1, 3) )
	local nRegion = tonumber(region)
	local b1, b2, b3 = string.sub(nomer, 4, 4), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3)
	local r1, r2 = string.sub(region, 1, 1), string.sub(region, 2, 2)
	
	if (nomerLength < 1) or (nomerLength > 6) then return false end
	if (regionLength ~= 2) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 16) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2]) then return false end
	if not (allowedKazakh[b1] and allowedKazakh[b2] and allowedKazakh[b3]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerF(nomer)		-- Украинский номер
	if (not nomer) then return false end
	local nomerLength = string.len(nomer)
	local nNomer = tonumber( string.sub(nomer, 3, 6) )
	local b1, b2, b3, b4 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 7, 7), string.sub(nomer, 8, 8)
	local c1, c2, c3, c4 = string.sub(nomer, 3, 3), string.sub(nomer, 4, 4), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	
	if (nomerLength < 1) or (nomerLength > 8) then return false end
	if (not nNomer) then return false end
	if (nNomer == 0) then return false end
	if not (allowedUkrAndByel[b1] and allowedUkrAndByel[b2] and allowedUkrAndByel[b3] and allowedUkrAndByel[b4]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3] and allowedCifr[c4]) then return false end
	return true	
end

function checkNomerG(nomer)		-- Белорусский
	if (not nomer) then return false end
	local nomerLength = string.len(nomer)
	local nNomer = tonumber( string.sub(nomer, 1, 4) )
	local nRegion = tonumber( string.sub(nomer, 7, 7) )
	local b1, b2 = string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3, c4 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	
	if (nomerLength < 1) or (nomerLength > 7) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 8) then return false end
	if not (allowedUkrAndByel[b1] and allowedUkrAndByel[b2]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3] and allowedCifr[c4]) then return false end
	return true	
end

function checkNomerH(nomer)		-- Надпись
	if (not nomer) then return false end
	
	local bytes = {string.byte(nomer, 1, -1)}
	iprint(bytes)
	for _, character in ipairs(bytes) do
		if (not allowedForH[character]) then
			return false
		end
	end
	return true	
end
