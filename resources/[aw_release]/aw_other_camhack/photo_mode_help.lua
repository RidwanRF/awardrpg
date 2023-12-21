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

PhotoModeHelp = {}

local helpLines = {
	nil,
	{keys = {"Q", "E"}, 														locale = "Поворот влево/вправо"},
	{keys = {"W", "A", "S", "D"}, 												locale = "Передвижение"},
	{keys = {"Alt", "Shift"}, 													locale = "Движение медленнее/быстрее"},
	{keys = {"Мышь"}, 															locale = "Вращение"},
	{keys = {"Колесо мыши"}, 													locale = "Приближение/отдаление"},
	{keys = {"Пробел", "Ctrl"}, 												locale = "Движение вверх/вниз"},
	{keys = {CONTROLS.TOGGLE_SMOOTH:upper()}, 									locale = "Включить/выключить плавное перемещение"},
	{keys = {CONTROLS.NEXT_TIME:upper(), CONTROLS.PREVIOUS_TIME:upper()},		locale = "Изменение времени"},
	{keys = {CONTROLS.NEXT_WEATHER:upper(), CONTROLS.PREVIOUS_WEATHER:upper()},	locale = "Изменение погоды"},
	{keys = {"SHIFT + O"},														locale = "Показать/скрыть интерфейс и помощь"},
	{keys = {PHOTO_MODE_KEY:upper()},											locale = "Выйти из фоторежима"}
}

local weatherLine = ""

local LINE_HEIGHT = 25
local LINE_OFFSET = 3
local HORIZONTAL_OFFSET = 2
local EDGE_OFFSET = 10

local screenSize = Vector2(guiGetScreenSize())
local font
local themeColor = {}
local targetAlpha = 0
local alpha = targetAlpha

function PhotoModeHelp.start()
	font = dxCreateFont("Roboto-Regular.ttf", 14)
	targetAlpha = 230
	alpha = 0

	local screenshotBoundKeys = getBoundKeys("screenshot")
	if screenshotBoundKeys then
		local screenshotKeys = {}
		for key, state in pairs(screenshotBoundKeys) do
			table.insert(screenshotKeys, key)
		end

		if #screenshotKeys > 0 then
			helpLines[1] = {keys = screenshotKeys, locale = "Сделать скриншот"}
		end
	end

	for i, line in ipairs(helpLines) do
		for j, key in ipairs(line.keys) do
			helpLines[i].keys[j] = key
		end
		line.text = line.locale
	end
end

function PhotoModeHelp.stop()
	if isElement(font) then
		destroyElement(font)
	end
end

local function drawHelp()
	local y = EDGE_OFFSET

	for i, line in ipairs(helpLines) do
		local x = EDGE_OFFSET

		for j, key in ipairs(line.keys) do
			local keyWidth = dxGetTextWidth(key, 1, font) + 10

			x = x + keyWidth + HORIZONTAL_OFFSET
		end

		local textWidth = dxGetTextWidth(line.text, 1, font) + 10

		y = y + LINE_HEIGHT + LINE_OFFSET
	end
end

local function drawParams()
	local parameters = {
		{
			name = "Время", value = ("%02d:%02d"):format(getTime())
		},
		{
			name = "Погода",
			lvalue = (currentWeather == 0) and "Неизвестная" or weatherList[currentWeather].name
		}
	}

	local y = screenSize.y - 10 - ((LINE_HEIGHT + LINE_OFFSET) * #parameters)

	for i, param in pairs(parameters) do
		local x = EDGE_OFFSET

		local name = param.name
		local nameWidth = dxGetTextWidth(name, 1, font) + 10

		dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px,1080*py, "assets/aw_ui_camhack.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)

		x = x + nameWidth + HORIZONTAL_OFFSET
		

		local value
		if param.lvalue then
			value = param.lvalue
		else
			value = param.value
		end
		local valueWidth = dxGetTextWidth(value, 1, font) + 10

		y = y + LINE_HEIGHT + LINE_OFFSET
	end
end

function PhotoModeHelp.draw()
	alpha = alpha + (targetAlpha - alpha) * 0.1

	drawHelp()
	drawParams()
	
end

function differenceBetweenAnglesRadians(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle
	if difference > math.pi then
		difference = difference - math.pi * 2
	elseif difference < -math.pi then
		difference = difference + math.pi * 2
	end
	return difference
end
