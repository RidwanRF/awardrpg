local screenSize = Vector2(guiGetScreenSize())
local ui = {}

local windowWidth = 280
local windowHeight = 380

local currentColor = { h=0, s=0, v=0 }
local colorCursorSize = 16
local valueCursorSize = 4

local isMouseOverWindow = false

function math.clamp(x, min, max)
    return math.min(max, math.max(min, x))
end

local function rgbToHsv(r, g, b, a)
    if not a then
        a = 1
    end
    r, g, b, a = r / 255, g / 255, b / 255, a / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max

    local d = max - min
    if max == 0 then s = 0 else s = d / max end

    if max == min then
        h = 0 -- achromatic
    else
        if max == r then
            h = (g - b) / d
            if g < b then h = h + 6 end
            elseif max == g then h = (b - r) / d + 2
            elseif max == b then h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v, a
end

local function hsvToRgb(h, s, v, a)
    if not a then
        a = 1
    end
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255, a * 255
end

local function rgbFromInt(c)
    local r = bitAnd(bitRShift(c, 16), 255)
    local g = bitAnd(bitRShift(c, 8), 255)
    local b = bitAnd(c, 255)
    return r, g, b
end

local function ARGBToHex(alpha, red, green, blue)
    return string.format("%.2X%.2X%.2X%.2X", alpha,red,green,blue)
end

local function updateEditText(edit, value)
    edit.text = tostring(value)
end

local function updateEditsText(keepRGB, keepHSV)
    local r, g, b = getColorpickerColor()
    removeEventHandler("onClientGUIChanged", resourceRoot, updateTextInput)
    if not keepRGB then
        updateEditText(ui.editR, math.floor(r))
        updateEditText(ui.editG, math.floor(g))
        updateEditText(ui.editB, math.floor(b))
    end
    if not keepHSV then
        updateEditText(ui.editH, math.floor(currentColor.h * 360))
        updateEditText(ui.editS, math.floor(currentColor.s * 100))
        updateEditText(ui.editV, math.floor(currentColor.v * 100))
    end
    addEventHandler("onClientGUIChanged", resourceRoot, updateTextInput)
end

local function updateValueBarColor()
    local r, g, b = hsvToRgb(currentColor.h, currentColor.s, 1)
    local hex = ARGBToHex(255, r, g, b)
    local propertyString = string.format("tl:%s tr:%s bl:%s br:%s", hex, hex, hex, hex)
    guiSetProperty(ui.valueBar, "ImageColours", propertyString)
end

local function draw()
    local x, y = ui.window:getPosition(false)
    local width, height = guiGetSize(ui.window, false)

    x = x + 10
    y = y + 25

    -- Размеры палитры
    local paletteSize = width - 20
    local paletteX = x
    local paletteY = y
    -- Курсор на палитре
    local cx = x + currentColor.h * paletteSize
    local cy = y + (1 - currentColor.s) * paletteSize
    dxDrawImage(cx - colorCursorSize/2, cy - colorCursorSize/2, colorCursorSize, colorCursorSize, "assets/images/cursor.png", 0, 0, 0, tocolor(0, 0, 0, 230), true)
    -- Яркость
    y = y + paletteSize + 10
    local valueBarX = x
    local valueBarY = y
    local valueBarWidth = paletteSize
    local valueBarHeight = 20
    updateValueBarColor()
    -- Курсор на яркости
    local valueCursorOffset = (1 - currentColor.v) * valueBarWidth
    dxDrawRectangle(x - valueCursorSize/2 + valueCursorOffset, y - valueCursorSize, valueCursorSize, valueBarHeight + valueCursorSize * 2, valueBarColor, true)
    dxDrawRectangle(x - valueCursorSize/2 + valueCursorOffset - 1, y - valueCursorSize - 1, valueCursorSize + 2, valueBarHeight + valueCursorSize * 2 + 2, tocolor(0, 0, 0, 230), true)

    -- Выбор цвета мышью
    local mx, my = getCursorPosition()
    if getKeyState("mouse1") and mx and isMouseOverWindow then
        mx, my = mx * screenSize.x, my * screenSize.y

        local isColorChanged = false
        if my > paletteY - 5 and my < paletteY + paletteSize + 3 then
            currentColor.h =     math.clamp((mx - paletteX)  / paletteSize,   0, 1)
            currentColor.s = 1 - math.clamp((my - paletteY)  / paletteSize,   0, 1)
            isColorChanged = true
        elseif my > valueBarY and my < valueBarY + valueBarHeight then
            currentColor.v = 1 - math.clamp((mx - valueBarX) / valueBarWidth, 0, 1)
            isColorChanged = true
        end

        if isColorChanged then
            updateEditsText()
            triggerEvent("onColorpickerChange", resourceRoot, getColorpickerColor())
        end
    end
end

function setColorpickerColor(r, g, b, keepEditsText)
    if not r then r = 0 end
    if not g then g = 0 end
    if not b then b = 0 end
    local h, s, v = rgbToHsv(r, g, b)
    currentColor.h = h
    currentColor.s = s
    currentColor.v = v

    if not keepEditsText then
        updateEditsText()
    end

    triggerEvent("onColorpickerChange", resourceRoot, getColorpickerColor())
end

function getColorpickerColor()
    local r, g, b = hsvToRgb(currentColor.h, currentColor.s, currentColor.v)
    return math.floor(r), math.floor(g), math.floor(b)
end

function getColorpickerSize()
    return windowWidth, windowHeight
end

function setColorpickerPosition(x, y)
    if ui.window then
        ui.window.x = x
        ui.window.y = y
    end
end

function setColorpickerTitle(text)
    ui.window.text = tostring(text)
end

function updateTextInput()
    if source == ui.editR or source == ui.editG or source == ui.editB then
        local r = tonumber(ui.editR.text) or 0
        local g = tonumber(ui.editG.text) or 0
        local b = tonumber(ui.editB.text) or 0
        if not r or not g or not b then
            return
        end
        setColorpickerColor(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255), true)
        updateEditsText(true, false)

        triggerEvent("onColorpickerChange", resourceRoot, getColorpickerColor())
    elseif source == ui.editH or source == ui.editS or source == ui.editV then
        local h = tonumber(ui.editH.text) or 0
        local s = tonumber(ui.editS.text) or 0
        local v = tonumber(ui.editV.text) or 0
        if not h or not s or not v then
            return
        end
        currentColor.h = math.clamp(h / 360, 0, 1)
        currentColor.s = math.clamp(s / 100, 0, 1)
        currentColor.v = math.clamp(v / 100, 0, 1)
        updateEditsText(false, true)

        triggerEvent("onColorpickerChange", resourceRoot, getColorpickerColor())
    end
end

function isColorpickerVisible()
    return ui.window.visible
end

function showColorpicker(visible)
    if ui.window.visible == not not visible then
        return
    end
    if visible then
        addEventHandler("onClientRender", root, draw)
        addEventHandler("onClientGUIChanged", resourceRoot, updateTextInput)
    else
        removeEventHandler("onClientRender", root, draw)
        removeEventHandler("onClientGUIChanged", resourceRoot, updateTextInput)
    end

    ui.window.visible = visible
end

local function createEditsRow(x, y, width, height, data)
    local itemWidth = width / #data
    local editWidth = itemWidth * 0.8
    local labelWidth = itemWidth - editWidth
    local cx = x
    for i, params in ipairs(data) do
        local label = GuiLabel(cx, y + 2, labelWidth, height, params.label, false, ui.window)
        guiLabelSetHorizontalAlign(label, "center")
        guiLabelSetVerticalAlign(label, "top")
        cx = cx + labelWidth
        ui[params.name] = GuiEdit(cx, y, editWidth, height, "0", false, ui.window)
        cx = cx + editWidth
    end
end

function createColorpicker(x, y)
    ui.window = GuiWindow(x, y, windowWidth, windowHeight, "Выбор цвета", false)
    ui.window.sizable = false

    addEventHandler("onClientMouseEnter", ui.window, function () isMouseOverWindow = true end)
    addEventHandler("onClientMouseLeave", ui.window, function () isMouseOverWindow = false end)

    local editHeight = 20
    local y = windowHeight - editHeight - 10
    createEditsRow(10, y, windowWidth - 20, editHeight, {
        { label = "R", name = "editR" },
        { label = "G", name = "editG" },
        { label = "B", name = "editB" },
    })
    y = y - editHeight - 5
    createEditsRow(10, y, windowWidth - 20, editHeight, {
        { label = "H", name = "editH" },
        { label = "S", name = "editS" },
        { label = "V", name = "editV" },
    })

    showColorpicker(false)

    local paletteSize = windowWidth - 20
    local paletteX = 10
    local paletteY = 25

    guiCreateStaticImage(paletteX, paletteY, paletteSize, paletteSize, "assets/images/palette.png", false, ui.window)

    -- Яркость
    y = y + paletteSize + 10
    local valueBarX = paletteX
    local valueBarY = paletteY + paletteSize + 10
    local valueBarWidth = paletteSize
    local valueBarHeight = 20
    ui.valueBar = guiCreateStaticImage(valueBarX, valueBarY, valueBarWidth, valueBarHeight, "assets/images/alpha.png", false, ui.window)
end
