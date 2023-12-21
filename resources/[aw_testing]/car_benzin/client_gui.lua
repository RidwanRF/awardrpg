local screenSize = Vector2(guiGetScreenSize())
local ui = {}

local windowWidth = 300
local windowHeight = 350

local fuelVehicles = {
    car = {
        { label = "АИ-92",  price = fuels.AI92.price,       name = "AI92",      group = "petrol" },
        { label = "ДТ",     price = fuels.DT.price,         name = "DT",        group = "diesel" },
        { label = "АИ-95",  price = fuels.AI95.price,       name = "AI95",      group = "petrol" },
        { label = "ДТ+",    price = fuels.DTplus.price,     name = "DTplus",    group = "diesel" },
        { label = "АИ-98",  price = fuels.AI98.price,       name = "AI98",      group = "petrol" },
        { label = "Е85",    price = fuels.E85.price,        name = "E85",       group = "petrol" },
        { label = "АИ-98+", price = fuels.AI98plus.price,   name = "AI98plus",  group = "petrol" },
        { label = "А100",   price = fuels.A100.price,       name = "A100",      group = "electric"  }
    },
    heli = {
        { label = "TC-1",     price = fuels.TC1.price,      name = "TC1",       group = "other" }
    }
}

local fuelTypes = {}

local selectedFuelType = 1
local maxFuelAmount = 0
local currentPrice = 0
local currentAmount = 0

local skipInputEvent = false
local skipScrollEvent = false

local function updatePrice()
    ui.acceptButton.enabled = false
    local price = tonumber(ui.priceEdit.text)
    if not price or price <= 0 then
        ui.acceptButton.enabled = false
        return
    end
    ui.acceptButton.enabled = price <= getPlayerMoney(localPlayer)
end

local function handleScroll()
    if skipScrollEvent then
        skipScrollEvent = false
        return
    end
    local amount = math.floor(maxFuelAmount * guiScrollBarGetScrollPosition(ui.amountScroll) / 100)
    if (fuelTypes[selectedFuelType].group ~= "electric") then
        ui.amountLabel.text = "Количество: " .. tostring(amount) .. " л."
    else
        ui.amountLabel.text = "Количество: " .. tostring(amount) .. " кВтч"
    end
    currentAmount = amount
    local price = fuelTypes[selectedFuelType].price
    ui.priceEdit.text = tostring(math.floor(amount * price))
    updatePrice()
    skipInputEvent = true
end

local function handleInput()
    if skipInputEvent then
        skipInputEvent = false
        return
    end
    local price = tonumber(ui.priceEdit.text)
    if not price then
        return
    end
    local amount = math.max(0, math.min(price / fuelTypes[selectedFuelType].price, maxFuelAmount))
    skipScrollEvent = true
    local scrollPos = amount / maxFuelAmount * 100
    if scrollPos ~= scrollPos then
        return
    end
    guiScrollBarSetScrollPosition(ui.amountScroll, scrollPos)
    if (fuelTypes[selectedFuelType].group ~= "electric") then
        ui.amountLabel.text = "Количество: " .. tostring(math.floor(amount)) .. " л."
    else
        ui.amountLabel.text = "Количество: " .. tostring(math.floor(amount)) .. " кВтч"
    end
    currentAmount = amount
    updatePrice()
end

local function setSelectedFuel(index)
    selectedFuelType = index

    ui.amountTitle.text = "Выберите количество топлива \"" .. tostring(fuelTypes[index].label) .."\""
    handleScroll()
end

local function buyFuel()
    local amount = math.max(0, math.min(currentAmount, maxFuelAmount))
    local fuelType = fuelTypes[selectedFuelType].name
    if not fuelType then
        return
    end
    sendRefuelQuery(fuelType, amount)
end

local function createFuelButtons(group)
    local width, height = windowWidth, windowHeight
    local buttonWidth = 60
    local buttonHeight = 30
    local labelWidth = 70
    local y = 50
    ui.fuelButtons = {}
    selectedFuelType = nil
    for i, data in ipairs(fuelTypes) do
        local button, label
        local priceText = string.format("$ %.02f", data.price)
        if i % 2 ~= 0 then
            button = GuiButton(0, y, buttonWidth, buttonHeight, data.label, false, ui.window)
            label = GuiLabel(buttonWidth + 20, y + 6, labelWidth, buttonHeight, priceText, false, ui.window)
            label:setHorizontalAlign("left")
        else
            button = GuiButton(width - buttonWidth, y, buttonWidth, buttonHeight, data.label, false, ui.window)
            label = GuiLabel(width - buttonWidth - labelWidth - 10, y + 6, labelWidth, buttonHeight, priceText, false, ui.window)
            label:setHorizontalAlign("right")
            y = y + buttonHeight + 5
        end
        button.enabled = group == data.group
        if not selectedFuelType and button.enabled then
            setSelectedFuel(i)
        end

        table.insert(ui.fuelButtons, { button = button, label = label })
        button:setData("fuelTypeIndex", i)
    end
end

local function handleClick()
    local index = source:getData("fuelTypeIndex")
    if not index then
        return
    end

    setSelectedFuel(index)
end

function showPetrolUI(visible, maxAmount, group, showKO)
    if visible == ui.window.visible then
        return
    end
    if visible then
        if not showKO then
            fuelTypes = fuelVehicles.car
        else
            fuelTypes = fuelVehicles.heli
        end
        setSelectedFuel(1)
        createFuelButtons(group)
        maxFuelAmount = maxAmount or 0
        addEventHandler("onClientGUIClick", resourceRoot, handleClick)
        addEventHandler("onClientGUIChanged", ui.priceEdit, handleInput)
        updatePrice()
    else
        for i, b in ipairs(ui.fuelButtons) do
            destroyElement(b.button)
            destroyElement(b.label)
        end

        removeEventHandler("onClientGUIClick", resourceRoot, handleClick)
        removeEventHandler("onClientGUIChanged", ui.priceEdit, handleInput)
    end

    ui.window.visible = visible
    showCursor(visible)
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local width, height = windowWidth, windowHeight
    ui.window = GuiWindow((screenSize.x-width)/2, (screenSize.y-height)/2, width, height, "Заправка", false)
    ui.window.sizable = false
    ui.window.visible = false

    local label = GuiLabel(0, 0, width, 40, "Выберите вид топлива", false, ui.window)
    label:setHorizontalAlign("center")
    label:setVerticalAlign("bottom")

    local y = 190
    y = y + 10
    ui.amountTitle = GuiLabel(0, y, width, 40, "Выберите количество топлива", false, ui.window)
    ui.amountTitle:setHorizontalAlign("center")
    ui.amountTitle:setVerticalAlign("top")
    y = y + 25
    ui.amountScroll = GuiScrollBar(10, y, width - 20, 20, true, false, ui.window)
    addEventHandler("onClientGUIScroll", ui.amountScroll, handleScroll)
    y = y + 25
    ui.amountLabel = GuiLabel(10, y, width, 20, "Количество: 0 л.", false, ui.window)

    y = y + 20
    GuiLabel(10, y + 3, width, 20, "Цена:", false, ui.window)
    ui.priceEdit = GuiEdit(50, y, 60, 25, "0", false, ui.window)
    GuiLabel(115, y + 3, width, 20, "$", false, ui.window)

    y = y + 40
    local buttonWidth = (width - 20) / 2 - 5
    local buttonHeight = 30
    local x = 10
    ui.acceptButton = GuiButton(x, y, buttonWidth, buttonHeight, "Заправить", false, ui.window)
    addEventHandler("onClientGUIClick", ui.acceptButton, buyFuel, false)
    x = x + buttonWidth + 10
    ui.cancelButton = GuiButton(x, y, buttonWidth, buttonHeight, "Отмена", false, ui.window)
    addEventHandler("onClientGUIClick", ui.cancelButton, function ()
        showPetrolUI(false)
    end, false)

    --showPetrolUI(true, 50, "diesel")
end)