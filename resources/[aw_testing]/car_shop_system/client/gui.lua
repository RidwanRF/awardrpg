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
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 14*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 19*px)
SemiBoldMini = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px)
SemiBoldMini2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 15*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 14*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px)


local assets = {
 
    buy1 = dxCreateTexture ("assets/aw_ui_carshop_button_buy1.png"),
    buy2 = dxCreateTexture ("assets/aw_ui_carshop_button_buy2.png"),

    close1 = dxCreateTexture ("assets/aw_ui_carshop_button_close1.png"),
    close2 = dxCreateTexture ("assets/aw_ui_carshop_button_close2.png"),

    testdrive1 = dxCreateTexture ("assets/aw_ui_carshop_button_testdrive1.png"),
    testdrive2 = dxCreateTexture ("assets/aw_ui_carshop_button_testdrive2.png"),

}

local COLOR_STATE, COLOR_HOVER, tick, state
local alpha = 0

local stateDraw = false

local ui = {}
local screenSize = Vector2(guiGetScreenSize())
local currentRegion = "777"
local currentColor = "primary"

local scroll = 0
local scrollMax = 0

local testDriveParams

local stateBuyEnable = false 

-- Регионы, которые выдаются случайным образом по умолчанию
local initialRegions = {
    ["777"]  = true,
    ["77"] = true,
    ["197"]  = true,
    ["177"]  = true,
    ["97"]  = true,
    ["797"] = true
}

local function getSelectedRegion()
    local row, column = ui.regionList:getSelectedItem()
    if not row then
        return
    end
    return ui.regionList:getItemText(row, 1), ui.regionList:getItemText(row, 2)
end

local function getSelectedCar()
    local row, column = ui.carsList:getSelectedItem()
    if not row then
        return
    end
    local index = tonumber(ui.carsList:getItemData(row, 1))
    if not index then
        return
    end
    return getCarshopCars()[index], row
end

local function updateSelectedVehicle()
    local car = getSelectedCar()
    if not car then
        return
    end
    ui.mainWindow.text = "Цена: " .. getReadablePrice(car.price, car.currency)
    local bankMoney = 0
    if isResourceRunning("bank") then
        bankMoney = exports.bank:getPlayerBankMoney(car.currency) or 0
    end
    ui.buttonBuy.enabled = car.price <= bankMoney
    showPreviewCar(car.model)

    ui.buttonDrive.enabled  = not not getCurrentCarshop().testDriveAllowed
    local testDrivePrice = calculateTestDrivePrice(getCarModel())
    if not testDrivePrice or getPlayerMoney(localPlayer) < testDrivePrice then
        ui.buttonDrive.enabled = false
    end
    local priceText
    if testDrivePrice then
        priceText = tostring(testDrivePrice)
    else
        priceText = "недоступно"
    end
    ui.buttonDrive.text = "Тест-драйв\n"..tostring(priceText) .. " руб"
end

local function selectNextCar()
    local row, column = ui.carsList:getSelectedItem()
    if not row then
        row = 1
    end
    row = row + 1
    if row >= guiGridListGetRowCount(ui.carsList) then
        row = 0
    end
    selectedCar = row + 1
    guiGridListSetSelectedItem(ui.carsList, row, 1, true)
    updateSelectedVehicle()
end

local function selectPreviousCar()
    local row, column = ui.carsList:getSelectedItem()
    if not row then
        row = 1
    end
    row = row - 1
    if row < 0 then
        row = guiGridListGetRowCount(ui.carsList) - 1
    end
    selectedCar = row + 1
    guiGridListSetSelectedItem(ui.carsList, row, 1, true)
    updateSelectedVehicle()
end

local function updateSelectedRegion()
    local region, name = getSelectedRegion()
    if not region or region == "" then
        if utf8.len(ui.regionEdit.text) > 0 then
            return
        end
        local regions = {}
        for region, index in pairs(initialRegions) do
            table.insert(regions, index)
        end
        local rowIndex = regions[math.random(1, #regions)]
        guiGridListSetSelectedItem(ui.regionList, rowIndex, 1, true)
        updateSelectedRegion()
        return
    end
    ui.regionLabel.text = "Выбран регион: " .. tostring(region)
    currentRegion = tostring(region)

    setPreviewNumberplateRegion(currentRegion)
end

local function updateRegionsList()
    ui.regionList:clear()

    -- Отсеиваем регионы через поиск
    local sortedRegions = {}
    for number, name in pairs(NumberplateRegions) do
        if utf8.find(number, ui.regionEdit.text) or
           utf8.find(utf8.lower(name), utf8.lower(ui.regionEdit.text))
        then
            table.insert(sortedRegions, {
                number=number, name=name
            })
        end
    end
    -- Сортируем по возрастанию
    table.sort(sortedRegions, function (a, b)
        return tonumber(a.number) < tonumber(b.number)
    end)
    -- Добавляем в gridlist
    for i, region in ipairs(sortedRegions) do
        local index = ui.regionList:addRow(region.number, region.name)
        if initialRegions[region.number] then
            initialRegions[region.number] = index
        end
    end
end

function showCarshopUI(visible)
    if ui.mainWindow.visible == visible then
        return
    end
    
    showCursor(visible)
   
    showColorpicker(false)
    if stateBuyEnable == false then 
        stateBuyEnable = true 
    end 

    ui.carsListWindow.visible   = visible
    ui.regionListWindow.visible = false
    ui.mainWindow.visible       = visible

    ui.buttonRegion.enabled = not getCurrentCarshop().hideNumberplateSelection

    if visible then
        addEventHandler("onClientRender", root, stateWindowDraw)
        state = true
        tick = getTickCount()
        setColorpickerColor(255, 255, 255)

        bindKey("arrow_r", "down", selectNextCar)
        bindKey("arrow_l", "down", selectPreviousCar)

        ui.carsList:clear()
        for i, car in ipairs(getCarshopCars()) do
            local carName = getVehicleNameFromModel(car.model)
            if isResourceRunning("car_system") then
                carName = exports.car_system:getVehicleModName(car.model)
            end
            local rowIndex = ui.carsList:addRow(carName, getReadablePrice(car.price, car.currency))
            ui.carsList:setItemData(rowIndex, 1, i)
        end

        selectNextCar()

        if type(testDriveParams) == "table" then
            if testDriveParams.selectedCar then
                guiGridListSetSelectedItem(ui.carsList, testDriveParams.selectedCar, 1, true)
                updateSelectedVehicle()
            end
        end
        testDriveParams = nil

        ui.regionEdit.text = ""
        updateSelectedRegion()
        setPreviewNumberplateRegion(currentRegion)
    else
        state = nil
        tick = getTickCount()
        unbindKey("arrow_r", "down", selectNextCar)
        unbindKey("arrow_l", "down", selectPreviousCar)
    end
end

function updateColorpickerColor()
    if not isColorpickerVisible() then
        return
    end

    
    if currentColor == "primary" then
        setColorpickerColor(255, 255, 255)
    elseif currentColor == "secondary" then
        setColorpickerColor(r2, g2, b2)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
    local width, height, x, y
    width = 280
    height = 345
    x = 10
    y = 15

    -- Окно разделов
    ui.carsListWindow = GuiWindow(sx-0, sy-0, width, height, "Выбор автомобиля", false)
    ui.carsListWindow.sizable = false
    ui.carsListWindow.movable = false
    ui.carsList = GuiGridList(5, 25, width - 10, height - 30 - 45, false, ui.carsListWindow)
    ui.carsList:setSortingEnabled(false)
    ui.carsList:addColumn("Название", 0.62)
    ui.carsList:addColumn("Цена", 0.31)

    addEventHandler("onClientGUIClick", ui.carsList, updateSelectedVehicle, false)

    local w = width / 3 - 10
    ui.buttonColor1 = GuiButton(5, height - 40, w, 30, "Осн. цвет", false, ui.carsListWindow)
    addEventHandler("onClientGUIClick", ui.buttonColor1, function ()
        if currentColor == "primary" and isColorpickerVisible() then
            showColorpicker(false)
            return
        end
        currentColor = "primary"
        showColorpicker(true)
        ui.regionListWindow.visible = false
        setColorpickerTitle("Основной цвет")
        updateColorpickerColor()
    end, false)
    ui.buttonColor2 = GuiButton(15 + w, height - 40, w, 30, "Доп. цвет", false, ui.carsListWindow)
    addEventHandler("onClientGUIClick", ui.buttonColor2, function ()
        if currentColor == "secondary" and isColorpickerVisible() then
            showColorpicker(false)
            return
        end
        currentColor = "secondary"
        showColorpicker(true)
        ui.regionListWindow.visible = false
        setColorpickerTitle("Дополнительный цвет")
        updateColorpickerColor()
    end, false)
    ui.buttonRegion = GuiButton(20 + w * 2, height - 40, w, 30, "Номер", false, ui.carsListWindow)
    addEventHandler("onClientGUIClick", ui.buttonRegion, function ()
        ui.regionListWindow.visible = not ui.regionListWindow.visible
        showColorpicker(false)
    end, false)
    -- Окно цвета
    local windowsY = y + height + 10
    y = windowsY
    createColorpicker(x, y)
    showColorpicker(true)
    width, height = getColorpickerSize()

    -- Окно региона
    y = windowsY
    height = 240
    ui.regionListWindow = GuiWindow(x, y, width, height, "Выбор региона номерного знака", false)
    ui.regionListWindow.sizable = false
    ui.regionEdit = GuiEdit(5, 25, width - 10, 30, "Поиск", false, ui.regionListWindow)
    ui.regionList = GuiGridList(5, 25 + 30, width - 10, height - 30 - 70, false, ui.regionListWindow)
    ui.regionList:setSortingEnabled(false)
    ui.regionList:addColumn("Номер", 0.2)
    ui.regionList:addColumn("Название", 0.7)
    ui.regionLabel = GuiLabel(0, height - 40, width, 30, "Выбран регион: 000", false, ui.regionListWindow)
    ui.regionLabel.verticalAlign = "center"
    ui.regionLabel.horizontalAlign = "center"

    addEventHandler("onClientGUIChanged", ui.regionEdit, updateRegionsList)
    addEventHandler("onClientGUIClick", ui.regionList, updateSelectedRegion, false)

    -- Переключатель компонентов
    width = 440
    height = 90
    x = sx / 2 - width / 2
    y = sy - height - 20
    ui.mainWindow = GuiWindow(sx-0, sy-0, width, height, "Цена: 1231231 руб.", false)
    ui.mainWindow.movable = false
    ui.mainWindow.sizable = false

    local buttonWidth = (width - 10 - 30) / 5
    local buttonHeight = 60
    x = 1920
    y = 1080
    ui.buttonPrev = GuiButton(x, y, buttonWidth, buttonHeight, "<<", false, ui.mainWindow)
    x = x + buttonWidth + 10
    ui.buttonBuy = GuiButton(x, y, buttonWidth, buttonHeight, "Купить", false, ui.mainWindow)
    x = x + buttonWidth + 10
    ui.buttonDrive = GuiButton(x, y, buttonWidth, buttonHeight, "Тест-драйв", false, ui.mainWindow)
    x = x + buttonWidth + 10
    ui.buttonExit = GuiButton(x, y, buttonWidth, buttonHeight, "Выход", false, ui.mainWindow)
    x = x + buttonWidth + 10
    ui.buttonNext = GuiButton(x, y, buttonWidth, buttonHeight, ">>", false, ui.mainWindow)
    -- Нажатие кнопки выхода
    addEventHandler("onClientGUIClick", ui.buttonExit, function ()
        exitCarshop()
    end, false)
    addEventHandler("onClientGUIClick", ui.buttonNext, selectNextCar, false)
    addEventHandler("onClientGUIClick", ui.buttonPrev, selectPreviousCar, false)

    addEventHandler("onClientGUIClick", ui.buttonBuy, function ()
        ui.buttonBuy.enabled = false

        local model = getCarModel()
        
        local shopId = getCarshopId()

        triggerServerEvent("buyCarshopVehicle", resourceRoot, model, r1, g1, b1, r2, g2, b2, shopId, currentRegion)
    end, false)

    addEventHandler("onClientGUIClick", ui.buttonDrive, function ()
        local _, row = getSelectedCar()
        testDriveParams = {
            selectedCar = row
        }
        ui.buttonDrive.enabled = false
        fadeCamera(false, 0)
        
        triggerServerEvent("carshopStartTestDrive", resourceRoot, getCarModel(), r1, g1, b1, r2, g2, b2, getCarshopId())
    end, false)

    showCarshopUI(false)
end)

addEvent("onColorpickerChange")
addEventHandler("onColorpickerChange", resourceRoot, function ()
    local r, g, b = getColorpickerColor()
    setPreviewVehicleColor(currentColor == "primary", r, g, b)
end)

local rt = nil

local rt = dxCreateRenderTarget (362*px, 546*py, true)

local state2 = false;

local tick2 = nil;
local tickRefresh = nil;

local rotation2 = 0;
local alpha3 = 0;
local stateAnim = false
local isButtonClick = 0

local panel = {
    x = sx/2-(1800/2)*px,
    y = sy/2-(426/2)*py,
    w = 362*px,
    h = 546*py,
}
panel.xs = panel.x + 6*px
local isButtonClick = false
local progressbare = 0
function stateWindowDraw ()

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

    if state then
        if tick then
            alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount() - tick)/500, "OutQuad")

            alpha2 = interpolateBetween(0,0,0,25,0,0, (getTickCount() - tick)/500, "OutQuad")
        end
    else
        if tick then
            alpha = interpolateBetween(255,0,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")

            alpha2 = interpolateBetween(25,0,0,0,0,0, (getTickCount() - tick)/500, "OutQuad")
        end
    end
    local car = getSelectedCar()

    if not car then
        return
    end       
 
    COLOR_STATE = tocolor(255, 255, 255, alpha)
    COLOR_HOVER = tocolor(255, 255, 255, alpha)

    local bankMoneyRub = (exports.bank:getPlayerBankMoney("RUB") or 0) 
    local bankMoneyDon = (exports.bank:getPlayerBankMoney("DONATE") or 0) 

    local carMaxText = exports.car_system:getMaxText(car.model)

    local carBrakingText = exports.car_system:getBrakingText(car.model)
    local carBrakingLine = exports.car_system:getBrakingLine(car.model)

    local carFuelText = exports.car_system:getFuelText(car.model)
    local carFuelLine = exports.car_system:getFuelLine(car.model)

    local getNameText = exports.car_system:getNameText(car.model)

    local spicar = nil

    if progressbare then
        if getKeyState("q") then

                state = nil
                tick = getTickCount()
                exitCarshop()
        end
    end

    local maxSpeed = exports.car_system:getMaxText(car.model)
    local boost = exports.car_system:getCarBoost(car.model)
    local clutch = exports.car_system:getCarClutch(car.model)
    local brake = exports.car_system:getCarBrake(car.model)

    

    dxDrawButton(sx/2-(-1626/2)*px, sy/2-(880/2)*py, 46*px,46*py, assets.close1, assets.close2, 1)   
    dxDrawButton(sx/2-(-1126/2)*px, sy/2-(-436/2)*py, 297*px,49*py, assets.buy1, assets.buy2, 2)   
    dxDrawButton(sx/2-(-590/2)*px, sy/2-(-436/2)*py, 247*px,49*py, assets.testdrive1, assets.testdrive2, 3) 

    dxDrawImage(sx/2-(-1626/2)*px, sy/2-(337/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(25, 25, 25, 255* (alpha/255)), false)
    dxDrawImage(sx/2-(-1506/2)*px, sy/2-(337/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
    dxDrawImage(sx/2-(-1386/2)*px, sy/2-(337/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(60, 60, 70, 255* (alpha/255)), false)
    dxDrawImage(sx/2-(-1266/2)*px, sy/2-(337/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(255, 83, 83, 255* (alpha/255)), false)

    dxDrawImage(sx/2-(-1626/2)*px, sy/2-(214/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(83, 100, 255, 255* (alpha/255)), false)
    dxDrawImage(sx/2-(-1506/2)*px, sy/2-(214/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(30, 217, 26, 255* (alpha/255)), false)
    dxDrawImage(sx/2-(-1386/2)*px, sy/2-(214/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(220, 201, 30, 255* (alpha/255)), false)
    dxDrawImage(sx/2-(-1266/2)*px, sy/2-(214/2)*py, 42*px,43*py, "assets/aw_ui_carshop_circle.png", 0, 0, 0, tocolor(133, 69, 239, 255* (alpha/255)), false)

    dxDrawImage(sx/2-(-1190/2)*px, sy/2-(30/2)*py, 260*px,37*py, "assets/aw_ui_carshop_slots.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

    dxDrawImage(sx/2-(1720/2)*px, sy/2-(560/2)*py, 33*px,23*py, "assets/country/"..exports.car_system:getCarCountry(car.model)..".png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

    dxDrawImage(sx/2-(1720/2)*px, sy/2-(-818/2)*py, 1720*px,33*py, "assets/aw_ui_carshop_info.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)
    dxDrawImage(sx/2-(1714/2)*px, sy/2-(-280/2)*py, 570*px,84*py, "assets/aw_ui_carshop_info2.png", 0, 0, 0, tocolor(255, 255, 255, 255* (alpha/255)), false)

    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(255/2)*py, 358*px,1*py, tocolor(255, 255, 255, 76* (alpha/255)), false)
    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(110/2)*py, 358*px,1*py, tocolor(255, 255, 255, 76* (alpha/255)), false)
    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(-35/2)*py, 358*px,1*py, tocolor(255, 255, 255, 76* (alpha/255)), false)
    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(-177/2)*py, 358*px,1*py, tocolor(255, 255, 255, 76* (alpha/255)), false)

    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(255/2)*py, maxSpeed*px,1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(110/2)*py, boost*px,1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(-35/2)*py, clutch*px,1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)
    dxDrawRectangle(sx/2-(1720/2)*px, sy/2-(-177/2)*py, brake*px,1*py, tocolor(255, 255, 255, 255* (alpha/255)), false)


    dxDrawText(getNameText, sx/2-(1720/2)*px, sy/2+(-45/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "left", "center", false, false, false, false, false)
    dxDrawText("Здесь вы можете приобрести транспорт на любой вкус", sx/2-(1720/2)*px, sy/2+(155/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 127* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)

    dxDrawText(exports.car_system:getVehicleModName(car.model), sx/2-(1600/2)*px, sy/2+(590/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "left", "center", false, false, false, false, false)
    dxDrawText(exports.car_system:getCarYear(car.model).."  •  "..exports.car_system:getCountryName(car.model).."  •  "..exports.car_system:getCarClass(car.model), sx/2-(1720/2)*px, sy/2+(772/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)

    dxDrawText("Максимальная скорость", sx/2-(1720/2)*px, sy/2+(1022/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText(exports.car_system:getMaxText(car.model).." км/ч", sx/2-(1720/2)*px, sy/2+(1022/2)*py,  sx/2-(995/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumMini, "right", "center", false, false, false, false, false)

    dxDrawText("Ускорение", sx/2-(1720/2)*px, sy/2+(1312/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText(exports.car_system:getCarBoost(car.model), sx/2-(1720/2)*px, sy/2+(1312/2)*py,  sx/2-(995/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumMini, "right", "center", false, false, false, false, false)

    dxDrawText("Сцепление", sx/2-(1720/2)*px, sy/2+(1602/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText(exports.car_system:getCarClutch(car.model), sx/2-(1720/2)*px, sy/2+(1602/2)*py,  sx/2-(995/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumMini, "right", "center", false, false, false, false, false)

    dxDrawText("Торможение", sx/2-(1720/2)*px, sy/2+(1892/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, Regular, "left", "center", false, false, false, false, false)
    dxDrawText(exports.car_system:getCarBrake(car.model), sx/2-(1720/2)*px, sy/2+(1892/2)*py,  sx/2-(995/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumMini, "right", "center", false, false, false, false, false)

    dxDrawText(exports.car_system:getCarRecFuel(car.model), sx/2-(1720/2)*px, sy/2+(2710/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumBig, "left", "center", false, false, false, false, false)

    dxDrawText(exports.car_system:getCarTuning(car.model), sx/2-(1220/2)*px, sy/2+(2710/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumBig, "left", "center", false, false, false, false, false)

    dxDrawText(exports.car_system:getCountryName(car.model), sx/2-(860/2)*px, sy/2+(2710/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, MediumBig, "left", "center", false, false, false, false, false)

	dxDrawText("#999999$ #ffffff"..convertNumber(bankMoneyRub), sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1350/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBold, "right", "center", false, false, false, true, false)

	dxDrawText(convertNumber(bankMoneyDon).." #999999AW", sx/2-(-0/2)*px, sy/2+(-0/2)*py,  sx/2-(-1566/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBold, "right", "center", false, false, false, true, false)

    dxDrawText("Stage не установлен на транспорте ", sx/2-(-1190/2)*px, sy/2+(1690/2)*py,  sx/2-(-1717/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini2, "center", "center", false, false, false, false, false)

    dxDrawText(exports.car_system:getMaxCar(car.model), sx/2-(1600/2)*px, sy/2+(590/2)*py,  sx/2-(-1717/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldBig, "right", "center", false, false, false, false, false)
    dxDrawText("Выбор цвета транспорта", sx/2-(1600/2)*px, sy/2+(850/2)*py,  sx/2-(-1717/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "right", "center", false, false, false, false, false)

    dxDrawText("Государственная стоимость", sx/2-(1600/2)*px, sy/2+(1995/2)*py,  sx/2-(-1717/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "right", "center", false, false, false, false, false)
    dxDrawText("#999999$ #ffffff"..convertNumber(exports.car_system:getCarPrice(car.model)), sx/2-(-1056/2)*px, sy/2+(1995/2)*py,  sx/2-(-1270/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini, "right", "center", false, false, false, true, false)

    dxDrawText("Круиз и переключаемый привод", sx/2-(1600/2)*px, sy/2+(2155/2)*py,  sx/2-(-1717/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "right", "center", false, false, false, false, false)
    dxDrawText("-", sx/2-(-1170/2)*px, sy/2+(2155/2)*py,  sx/2-(-2155/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini, "left", "center", false, false, false, false, false)

    dxDrawText("Кол-во штук осталось на складе", sx/2-(1600/2)*px, sy/2+(2330/2)*py,  sx/2-(-1717/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 67* (alpha/255)), 1, Regular, "right", "center", false, false, false, false, false)
    dxDrawText("∞", sx/2-(-1180/2)*px, sy/2+(2330/2)*py,  sx/2-(-2155/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, 255* (alpha/255)), 1, SemiBoldMini, "left", "center", false, false, false, false, false)



    local y2 = 0
    dxSetRenderTarget (rt, true)
    dxSetBlendMode("modulate_add")
        for i, v in ipairs(getCarshopCars()) do
            if i == selectedCar then
       
            else

            end
            y2 = y2 + 46*py
        end
    dxSetBlendMode("blend")
    dxSetRenderTarget ()

    if y2 > 546*py then
        scrollMax = (y2 + 23)- 546*py
    end


    dxSetBlendMode("add")
    dxSetBlendMode("blend")


    if alpha <= 0 then
        removeEventHandler("onClientRender", root, stateWindowDraw)
    end
end

doorStatus = false
cursorPreview = false 

local carshopAttempts = 0
local slowCarShop
function nothingCar() end
addEventHandler("onClientClick", root, 
    function(button, states)
        if isEventHandlerAdded("onClientRender", root, stateWindowDraw) then
            local r1, g1, b1, r2, g2, b2 = getCarColor()
            if (button == "left") and (states == "up") then
                local y2s = 0
                for i, v in ipairs(getCarshopCars()) do
                    if dxDrawCursor(panel.xs, panel.y+y2s+alpha2-25- scroll, 362*px, 40*py) then 
                        selectedCar = i
                        showPreviewCar(v.model)
                    end
                    y2s = y2s + 46*py
                end

                
                if dxDrawCursor(sx/2-(-1626/2)*px, sy/2-(880/2)*py, 46*px,46*py) then 
                    if not stateAnim then
                    stateAnim = true
                    state2 = true;
                    tick2 = getTickCount();
                    setTimer(function()
                    state = nil
                    tick = getTickCount()
                    exitCarshop()
                    end, 1, 1)
                  end

                elseif dxDrawCursor(sx/2-(-1626/2)*px, sy/2-(337/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 0, 0, 0, r2, g2, b2)
                elseif dxDrawCursor(sx/2-(-1506/2)*px, sy/2-(337/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 255, 255, 255, r2, g2, b2)
                elseif dxDrawCursor(sx/2-(-1386/2)*px, sy/2-(337/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 60, 60, 70, r2, g2, b2)
                elseif dxDrawCursor(sx/2-(-1266/2)*px, sy/2-(337/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 255, 83, 83, r2, g2, b2)
                elseif dxDrawCursor(sx/2-(-1626/2)*px, sy/2-(214/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 83, 100, 255, r2, g2, b2)
                elseif dxDrawCursor(sx/2-(-1506/2)*px, sy/2-(214/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 30, 217, 26, r2, g2, b2)
                elseif dxDrawCursor(sx/2-(-1386/2)*px, sy/2-(214/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 220, 201, 30, r2, g2, b2)
                elseif dxDrawCursor(sx/2-(-1266/2)*px, sy/2-(214/2)*py, 42*px,43*py) then
                    setVehicleColor(previewVehicle, 133, 69, 239, r2, g2, b2)

                elseif dxDrawCursor(sx/2-(-590/2)*px, sy/2-(-436/2)*py, 247*px,49*py) then
                    if not stateAnim then
                    stateAnim = true
                    state2 = true;
                    tick2 = getTickCount();
                    setTimer(function()
                    state = nil
                    tick = getTickCount()
                    triggerServerEvent("carshopStartTestDrive", resourceRoot, getCarModel(), r1, g1, b1, r2, g2, b2, getCarshopId())
                    end, 0, 1)
                  end
                elseif dxDrawCursor(sx/2-(6787806/2)*px, sy/2-(-9487788/2)*py+alpha2-25, 0*px, 0*py) then
                    selectPreviousCar()
                elseif dxDrawCursor(sx/2-(4278786/2)*px, sy/2-(-9487788/2)*py+alpha2-25, 0*px, 0*py) then
                    selectNextCar() 
                elseif dxDrawCursor(sx/2-(-1126/2)*px, sy/2-(-436/2)*py, 297*px,49*py) then
                    if not stateAnim then
                    stateAnim = true
                    state2 = true;
                    tick2 = getTickCount();
                    setTimer(function()
                    state = nil
                    tick = getTickCount()
                    if not isTimer(slowCarShop) then
                        local model = getCarModel()
                        
                        local shopId = getCarshopId()
                        triggerServerEvent("buyCarshopVehicle", resourceRoot, model, r1, g1, b1, r2, g2, b2, shopId, currentRegion)
                        slowCarShop = setTimer(nothingCar, 0, 1)
                    end
                    end, 0, 1)
                  end
                end
            end
        end
    end
)

addEventHandler ("onClientKey", root, function(key)
	if isEventHandlerAdded("onClientRender", root, stateWindowDraw) then
        if key == "l" then
            if not stateAnim then
                stateAnim = true
                state2 = true;
                tick2 = getTickCount();
                setTimer(function()
                state = nil
                tick = getTickCount()
                
                triggerServerEvent("carshopStartTestDrive", resourceRoot, getCarModel(), r1, g1, b1, r2, g2, b2, getCarshopId())
                end, 0, 1)
              end
        end
        if key == "enter" then
            local r1, g1, b1, r2, g2, b2 = getCarColor()
            if not stateAnim then
                stateAnim = true
                state2 = true
                tick2 = getTickCount()
                setTimer(function()
                    state = nil
                    tick = getTickCount()
                    if not isTimer(slowCarShop) then
                        local model = getCarModel()
                        
                        local shopId = getCarshopId()
                        triggerServerEvent("buyCarshopVehicle", resourceRoot, model, r1, g1, b1, r2, g2, b2, shopId, currentRegion)
                        slowCarShop = setTimer(nothingCar, 0, 1)
                    end
                end, 0, 1)
            end
        end
        if dxDrawCursor(panel.xs, panel.y + alpha2-25, 362*px, 546*py) then 
            if key == "mouse_wheel_up" then
                if scroll - 35 >= 0 then
                    scroll = scroll - 35
                else
                    scroll = 0
                end
            elseif key == "mouse_wheel_down" then
                if scroll + 35 <= scrollMax then
                    scroll = scroll + 35
                else
                    scroll = scroll
                end
            end
        end
    end
end)

--// Полезные функции

function dxCreateText1 (text, x, y, w, h, color, font, ax, ay, maxlenght)

    dxDrawText (text, x, y, x + w, y + h, color, 1, font, ax, ay, maxlenght)

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

function dxDrawCursor(x,y,w,h)
	local sx, sy = guiGetScreenSize()
	if isCursorShowing() then
		local mx,my = getCursorPosition() 
		local cursorx,cursory = mx*sx, my*sy
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
    
    
    if dxDrawCursor(X, Y, W, H) then
        if G_ALPHA_HOVER[INDEX] <= 240 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] + 12
        end
        COLOR_HOVER = tocolor(255, 255, 255,  G_ALPHA_HOVER[INDEX])
    else
        if G_ALPHA_HOVER[INDEX] ~= 0 then
            G_ALPHA_HOVER[INDEX] = G_ALPHA_HOVER[INDEX] - 12
        end
        COLOR_HOVER = tocolor(255, 255, 255,  G_ALPHA_HOVER[INDEX])
    end
    dxDrawImage(X, Y, W, H, IMAGE_STATE, 0,0,0, COLOR_STATE)
    dxDrawImage(X, Y, W, H, IMAGE_HOVER, 0,0,0, COLOR_HOVER)
end

function dxCreateText (text, x, y, w, h, color, size, font, left, top)
    dxDrawText (text, x, y, x + w, y + h, color, size, font, left, top)
end

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

function convTextLen (text)
if text:len() > 20 then
    text = text:sub (1, 18).."..."
end
return text
end


function getCountSlot (allCar)
local slot = 3
while slot < allCar do
    slot = slot + 3
end
return slot
end

function getMarkCar (name)
local mark = ""
for s in string.gmatch (name, ".") do
    if s ~= " " then
        mark = mark..s
    else
        return mark
    end
end
end