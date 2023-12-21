
-- local fontsQuality = 'antialiased'

fonts = {}

function getFont(path, size, weight)
	-- local fontIndex = path..size
	-- if fonts[fontIndex] and fonts[fontIndex][weight] then
	-- 	return fonts[fontIndex][weight]
	-- end

	-- local fontPath = string.format('assets/fonts/%s.ttf', path)

	-- fonts[fontIndex] = fonts[fontIndex] or {}
	-- fonts[fontIndex][weight] = dxCreateFont(fontPath, size, weight == 'bold', fontsQuality)

	-- return fonts[fontIndex][weight]

	local fontPath = string.format('assets/fonts/%s.ttf', path)

	return dxCreateFont(fontPath, size, weight == 'bold', fontsQuality)
end

function getFonts()
	return fonts
end

addCommandHandler('getfontscount', function()
	local count = 0
	for _ in pairs(fonts) do
		count = count + 2
	end
	setClipboard(inspect(fonts))
	print(count, getTickCount(  ))
end)