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


local font = dxCreateFont("Montserrat-Medium.ttf", 17*px)

local white = tocolor(255,255,255, 255)

local black = tocolor(0,0,0, 255)

local texts = {

	[resource] = {

		-- {text, pos = {x, y, z}, distance, fColor, bColor, bWidth, scale}		


		{text = "#f2ad4a/bonus#ffffff — получить стартовый бонус\nНаша группа ВКонтакте — vk.com/awardmta\nНаш сайт — #f2ad4aawardrpg.trademc.org",	pos = {x = 2839.8901367188, y = 1287.1960449219, z = 11.390625},	distance = 10, fColor = white, bColor = black, bWidth = 1, scale = 1},
		{text = "Список транспорта, который можно выбить из контейнеров\nFerrari SF90 Stradale  •  $ 7 000 000 000  •  0,01%\nMcLaren SpeedTail  •  $ 3 500 000 000  •  0,2%\nBMW E31 850 CSI  •  $ 950 000 000  •  0,7%\nFerrari 812 Superfast  •  $ 750 000 000  •  0,9%\nMercedes-Benz GLS63 Maybach  •  $ 830 000 000  •  1,3%\nBMW M2 Competition  •  $ 390 000 000  •  3,1%",	pos = {x = 2349.1428222656, y = 2739.7807617188, z = 10.8203125},	distance = 10, fColor = white, bColor = black, bWidth = 1, scale = 1},

	}

}

local screenW, screenH = guiGetScreenSize()

local globalScale = screenW / 1920 * 2




addEventHandler("onClientRender", root, function()

	local cX, cY, cZ = getCameraMatrix()

	for _, textTable in pairs(texts) do

		for _, text in ipairs(textTable) do

			local distance = getDistanceBetweenPoints3D(cX, cY, cZ, text.pos.x, text.pos.y, text.pos.z)

			if (distance < text.distance) then

				local scrX, scrY = getScreenFromWorldPosition(text.pos.x, text.pos.y, text.pos.z, 0.1, true)

				if (scrX) and isLineOfSightClear(cX, cY, cZ, text.pos.x, text.pos.y, text.pos.z, true, true, false, true, false, false, false) then

					local scale = globalScale

					scale = math.clamp(scale, text.scale, text.scale)

				
					dxDrawText(text.text, scrX, 			  scrY, 			  scrX, 			  scrY, 			  text.fColor, scale, font, "center", "center", false, false, false, true, false)

				end

			end

		end

	end

end)



-- ==========     Добавление и удаление записей сторонними ресурсами     ==========

-- text, pos = {x, y, z}, data = {distance, fColor, bColor, bWidth, scale}

function create3dText(text, pos, data)

	texts[sourceResource] = texts[sourceResource] or {}

	data.text = text

	data.pos = pos

	data.distance = data.distance or 20

	data.fColor = data.fColor or white

	data.bColor = data.bColor or black

	data.bWidth = data.bWidth or 1

	data.scale = data.scale or 0.2

	data.ID = generateString(8)

	table.insert(texts[sourceResource], data)

	return data.ID

end



function delete3dText(textID)

	local tableByRes = texts[sourceResource]

	if (tableByRes) then

		for index, data in ipairs(tableByRes) do

			if (data.ID == textID) then

				table.remove(tableByRes, index)

				return true

			end

		end

	end

	return false

end



addEventHandler("onClientResourceStop", root, function(stoppedResource)

	texts[stoppedResource] = nil

end)



-- ==========     Генерация строки символов     ==========

local symbols = {}

for _, range in ipairs({{48, 57}, {65, 90}, {97, 122}}) do -- numbers/lowercase chars/uppercase chars

	for i = range[1], range[2] do

		table.insert(symbols, i)

	end

end

function generateString(length)

	length = tonumber(length) or 8	

	local str, symbolCount = "", #symbols

	for i = 1, length do

		str = str..string.char(symbols[math.random(1, symbolCount)])

	end

	return str

end



-- ==========     Другое     ==========

function math.clamp(value, minValue, maxValue)

	return math.max(minValue, math.min(value, maxValue))

end



--[[

addEventHandler("onClientRender",root,function()

	draw(inspect(texts), 300, 0, 200, screenH, "left")

end)

]]



function draw(text, posX, posY, width, height, alignX)

	height = posY + height

	dxDrawText(text, posX, posY-1, posX+width-1, height, 0xFF000000, 1, "default", alignX)

	dxDrawText(text, posX, posY-1, posX+width+1, height, 0xFF000000, 1, "default", alignX)

	dxDrawText(text, posX, posY+1, posX+width-1, height, 0xFF000000, 1, "default", alignX)

	dxDrawText(text, posX, posY+1, posX+width+1, height, 0xFF000000, 1, "default", alignX)

	dxDrawText(text, posX, posY, posX+width, height, 0xFFFFFFFF, 1, "default", alignX)

end

