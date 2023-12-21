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


local screenSize = Vector2(guiGetScreenSize())
local currentColor = tocolor(255, 255, 255)
local shadowColor = tocolor(0, 0, 0, 100)
local currentText = ""

local testDriveSeconds = 0
local testDriveTimer

local function updateTestDrive()
    testDriveSeconds = testDriveSeconds - 1
    if testDriveSeconds <= 0 then
        testDriveSeconds = 0
        if isTimer(testDriveTimer) then
            killTimer(testDriveTimer)
            triggerServerEvent("onPlayerStopTestDrive", resourceRoot)
            return
        end
    end

    local minutes = math.floor(testDriveSeconds / 60)
    local seconds = testDriveSeconds % 60

    if minutes > 0 then
        currentText = string.format("До конца тест-драйва осталось %d мин", minutes + 1)
    else
        currentText = string.format("До конца тест-драйва осталось %d сек", seconds)
    end
    currentText = currentText .. "\nНажмите F, чтобы выйти"
end

addEvent("onClientTestDriveStop", true)
addEventHandler("onClientTestDriveStop", resourceRoot, function ()
    if isTimer(testDriveTimer) then
        killTimer(testDriveTimer)
    end
end)

addEvent("onClientTestDriveStart", true)
addEventHandler("onClientTestDriveStart", resourceRoot, function ()
    -- localPlayer.dimension = 0
    -- localPlayer.vehicle.dimension = 0

    testDriveSeconds = Config.testDriveTime
    if isTimer(testDriveTimer) then
        killTimer(testDriveTimer)
    end
    testDriveTimer = setTimer(updateTestDrive, 1000, 0)
    currentText = ""
end)

addEventHandler("onClientRender", root, function ()
    if not isTimer(testDriveTimer) then
        return
    end
 --   dxDrawText(currentText, 3, 3, screenSize.x + 3, screenSize.y * 0.85 + 3, shadowColor, 2.5, "default-bold", "center", "bottom")
    dxDrawText(currentText, 0, 0, screenSize.x, screenSize.y * 0.85, currentColor, 1, Medium, "center", "bottom")
end)
