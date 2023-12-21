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

local BoldBig = dxCreateFont("assets/Montserrat-Bold.ttf", 19*px) 
local Bold = dxCreateFont("assets/Montserrat-Bold.ttf", 15*px) 
local SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 14*px) 
local SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 14*px) 
local SemiBoldMini = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px) 
local BoldMini = dxCreateFont("assets/Montserrat-Bold.ttf", 10*px) 
local Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px) 
local MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 10*px) 
local Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px) 
local RegularMini = dxCreateFont("assets/Montserrat-Regular.ttf", 10*px) 

function isMouseInPosition(x, y, width, height)
	if (not isCursorShowing()) then
		return false
	end
  local cx, cy = getCursorPosition()
  local cx, cy = (cx*sx), (cy*sy)
  if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then
    return true
  else
    return false
  end
end


local loading = {
  speed = 0,
  current = 0,
  total = 1,
  lastUpdate = 0,
  lastDownloaded = 0,
}


guiSetInputMode("no_binds_when_editing")
guiData = {
  fonts = {},

  buttonColor = {
    ["gray"] = {67, 67, 67, 255},
    ["red"] = {107, 67, 67, 255},
    ["green"] = {67, 107, 67, 255},
  },

  loading = {
    bg = {
      [1] = dxCreateTexture("assets/aw_ui_loadingcache_bg1.png", "argb", true, "clamp"),
      [2] = dxCreateTexture("assets/aw_ui_loadingcache_bg2.png", "argb", true, "clamp"),
      [3] = dxCreateTexture("assets/aw_ui_loadingcache_bg3.png", "argb", true, "clamp"),
      [4] = dxCreateTexture("assets/aw_ui_loadingcache_bg4.png", "argb", true, "clamp"),
      [5] = dxCreateTexture("assets/aw_ui_loadingcache_bg5.png", "argb", true, "clamp"),
      [6] = dxCreateTexture("assets/aw_ui_loadingcache_bg6.png", "argb", true, "clamp"),
    },
    maxImg = 6,

    tips = {
      "Для быстрого пермещения по карте\nвы можете воспользоваться метро либо\nавтобусной остановкой",
      "Для быстрого пермещения по карте\nвы можете воспользоваться метро либо\nавтобусной остановкой",
    },
  },
  capsOn = false,
}

function setOpenGUI(state)
  guiData.open = state
  toggleControl("next_weapon", not state)
  toggleControl("previous_weapon", not state)
end

function canOpenGUI()
  if isResponseEnabled() then return false end
  return not guiData.open
end

function getFontSize(size)
  return math.max(math.min(math.floor(size/zoom), 150), 5)
end

function getFont(size, family)
  local font = guiData.fonts[string.format("size_%s_%d", family and family or "default", size)]
  if not font then font = createFont(size, family) end
  return font
end

function getBoldFont(size, family)
  local font = guiData.fonts[string.format("size_%s_%d_bold", family and family or "default", size)]
  if not font then font = createBoldFont(size, family) end
  return font
end

function createFont(size, family)
  guiData.fonts[string.format("size_%s_%d", family and family or "default", size)] = dxCreateFont(string.format("files/fonts/%s.ttf", family and family or "default"), size, false, family and "antialiased" or "cleartype_natural")
  return guiData.fonts[string.format("size_%s_%d", family and family or "default", size)]
end

function createBoldFont(size, family)
  guiData.fonts[string.format("size_%s_%d_bold", family and family or "default", size)] = dxCreateFont(string.format("files/fonts/%s.ttf", family and family or "default"), size, true, family and "antialiased" or "cleartype_natural")
  return guiData.fonts[string.format("size_%s_%d_bold", family and family or "default", size)]
end

function getButtonColor(color)
  return guiData.buttonColor[color] and guiData.buttonColor[color] or false
end

function cursorY()
  local _, cY = getCursorPosition()
  return cY * sy
end

function isEscapeOpen()
  return guiData.isEscapeOpen
end

function setEscapeOpen(state)
  guiData.isEscapeOpen = state
  return true
end

local createdLoadings = {}

Loading = {}
Loading.__index = Loading

function Loading:create(...)
  local instance = {}
  setmetatable(instance, Loading)
  if instance:constructor(...) then
    return instance
  end
  return false
end

function Loading:constructor(...)
  self.anim = "hidden"
  self.tick = getTickCount()
  self.alpha = 0
  self.visible = false
  self.rot = 0

  self.x = (sx - 300/zoom)/2
  self.y = (sy - 500/zoom)/2
  self.w = 300/zoom
  self.h = 300/zoom

  self.dots = {
    {progress = 0, time = 300},
    {progress = 0, time = 300},
    {progress = 0, time = 300},
  }
  return true
end

addEventHandler ("onClientTransferBoxProgressChange", root, function (downloadedSize, totalSize)
  if loading.downloading then
      loading.current = string.format("%.2f", downloadedSize / 1024 / 1024)
      loading.total = string.format("%.2f", totalSize / 1024 / 1024)

      local diff = (tonumber(loading.current)-tonumber(loading.lastDownloaded))/((getTickCount()-loading.lastUpdate)/1000)
      loading.speed = ("%.1f"):format(diff)
  end
end)

function Loading:draw()
  if not self.visible then return end
  local prg = tonumber(loading.current)/tonumber(loading.total)

  local downloadedSize = downloadedSize or 0
  local totalSize = totalSize or 0
  local percentage = percentage or 0
  load = math.lerp(1, 1619, downloadedSize/totalSize)
  dxDrawImage(0, 0, sx, sy, self.img, 0, 0, 0, tocolor(255, 255, 255, 255 * self.alpha), false)


	dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px,1080*py, "assets/aw_ui_loadingcache_blackout.png", 0, 0, 0, tocolor(255, 255, 255, 255))

  dxDrawImage(sx/2-(-1594/2)*px, sy/2-(-645/2)*py, 13*px,16*py, "assets/aw_ui_loadingcache_logotype.png", 0, 0, 0, tocolor(255, 255, 255, 255))


	dxDrawRectangle(sx/2-(1620/2)*px, sy/2-(-775/2)*py, 1619*px,1*py, tocolor(255, 255, 255, 76))
  dxDrawRectangle(sx/2-(1620/2)*px, sy/2-(-775/2)*py, percentage*px,1*py, tocolor(255, 255, 255, 255))
	dxDrawText("("..percentage.." / 100) %",  sx/2-(1620/2)*px, sy/2+(1150/2)*py,  sx/2-(-860/2)*px,sy/2+(170/2)*py, tocolor(255, 255, 255, 255), 1, SemiBold, "left", "center", false, false, false, true, false)

    resourceName = resourceName or "/resource/admin"
	dxDrawText("Загрузка игрового контента".."#999999 "..resourceName,  sx/2-(1620/2)*px, sy/2+(960/2)*py,  sx/2-(-860/2)*px,sy/2+(170/2)*py, tocolor(255, 255, 255, 255), 1, Regular, "left", "center", false, false, false, true, false)



  self:animate()
  self:animateLoader()
end


function math.lerp(a, b, k)
	local result = a * (1-k) + b * k
	if result >= b then
		result = b
	elseif result <= a then
		result = a
	end
	return result
end

addEventHandler("onClientResourceFileDownload", root,
    function(resource, fileName)
        resourceName = getResourceName(resource).."/"..fileName
    end
)

addEventHandler("onClientTransferBoxProgressChange", root, 
    function(downloadedSize, totalSize)
        downloadedSize = downloadedSize
        totalSize = totalSize
        percentage = math.floor(math.min ((downloadedSize / totalSize) * 100, 100))
    end
)


function Loading:animateLoader()
  for i, v in pairs(self.dots) do
    if self.dots[i].anim == "up" then
      local progress = (getTickCount() - self.dots[i].tick)/250
      self.dots[i].progress = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "OutQuad")
      if progress >= 1 then
        self.dots[i].anim = "down"
        self.dots[i].tick = getTickCount()
        self.dots[i].progress = 1
      end

    elseif self.dots[i].anim == "down" then
      local progress = (getTickCount() - self.dots[i].tick)/250
      self.dots[i].progress = interpolateBetween(1, 0, 0, 0, 0, 0, progress, "OutQuad")
      if progress >= 1 then
        self.dots[i].anim = "wait"
        self.dots[i].tick = getTickCount()
        self.dots[i].progress = 0
      end

    elseif self.dots[i].anim == "wait" then
      local progress = (getTickCount() - self.dots[i].tick)/500
      if progress >= 1 then
        self.dots[i].anim = "waited"
        self.dots[i].progress = 0
        if i == 3 then
          self:startDots()
        end
      end
    end

    local r, g, b = interpolateBetween(255, 255, 255, 247, 159, 27, self.dots[i].progress, "Linear")
 
  end
end

function Loading:startDots()
  for i, v in pairs(self.dots) do
    setTimer(function()
      self.dots[i].tick = getTickCount()
      self.dots[i].anim = "up"
      self.dots[i].progress = 0
    end, 100 * i, 1)
  end
end

function Loading:animate()
  if self.anim == "show" then
    local progress = (getTickCount() - self.tick)/200
    self.alpha = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "OutQuad")
    if progress >= 1 then
      self.anim = "showed"
      self.tick = getTickCount()
      self.alpha = 1
    end

  elseif self.anim == "showed" then
    local progress = (getTickCount() - self.tick)/self.time
    if progress >= 1 then
      self:hide()
    end

  elseif self.anim == "hide" then
    local progress = (getTickCount() - self.tick)/200
    self.alpha = interpolateBetween(1, 0, 0, 0, 0, 0, progress, "OutQuad")
    if progress >= 1 then
      self.anim = "hidden"
      self.tick = nil
      self.alpha = 0
      self.visible = false
    end
  end
end

function Loading:hide(...)
  if not self.visible then return end
  self.tick = getTickCount()
  self.anim = "hide"

  self.count = 0;
    setTimer(function()
      if self.count == 5 then
        --destroyElement(self.music)
      else
       -- setSoundVolume(self.music, (self.music and getSoundVolume(self.music) or 0) - 0.0)
      end
      self.count = self.count + 1
    end, 50, 6)

  return true
end

function Loading:show(...)
    if not self.visible then
      self.anim = "show"

      self.count = 0;
      setTimer(function()
        if self.count == 5 then
          --setSoundVolume(self.music, 0.3)
        else
        --  setSoundVolume(self.music, (self.music and getSoundVolume(self.music) or 0) + 0.1)
        end
        self.count = self.count + 1
      end, 50, 6)
  
      self:startDots()
  
      self.img = guiData.loading.bg[math.random(1, guiData.loading.maxImg)]
    end
  
    self.tick = getTickCount()
    self.time = arg[1] or 5000
    self.text = arg[2] or "Идет загрузка"
    self.visible = true
    return true
  end


function createLoading(...)
  return Loading:create(...)
end

function showLoading(...)
  createdLoading:show(...)
  return true
end

function hideLoading(...)
  createdLoading:hide(...)
  return true
end

function renderLoading()
  if createdLoading then
    createdLoading:draw()
  end
end
addEventHandler("onClientRender", root, renderLoading, false, "normal-1")
if isTransferBoxActive() and not loading.downloading then
  createdLoading:show(9999999, "Идет загрузка")
elseif loading.downloading and not isTransferBoxActive() then
  loading.stage = 2
  loading.downloading = false
end



SW, SH = guiGetScreenSize()

local baseX = 2048
zoom = 1 
local minZoom = 2.2
if SW < baseX then
	zoom = math.min(minZoom, baseX/SW)
end 

function getInterfaceZoom()
	return zoom
end

local screen = Vector2(guiGetScreenSize())
local loading = {
    textures = {},
}
createdLoading = createLoading()
loading.onLoad = function()
    loading.textures = {

    }
    showChat(false)
    hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
    speedometer = exports.aw_interface_speedometer:anim_true()
    showCursor(false)
    --music = playSound("files/sound/loading.mp3", true)
   -- setSoundVolume(music, 0.1)
    loading.downloading = downloading
    loading.lastUpdate = getTickCount()
    loading.lastDownloaded = 0
    setTransferBoxVisible(false)
    createdLoading:show(9999999, "Идет загрузка")
    loading.closeGUI = setTimer(function()
        if not isTransferBoxActive() then
            destroyElement(music)
            showCursor(false)
            loading.downloading = false
            showChat(true)
            hud = exports.aw_interface_hud:anim_false()
            radar = exports.aw_interface_radar:anim_false()
            speedometer = exports.aw_interface_speedometer:anim_false()
            killTimer(loading.closeGUI)
            removeEventHandler("onClientRender", root, renderLoading)
        end
    end, 5700, 0)
end
addEventHandler("onClientResourceStart", resourceRoot, loading.onLoad)

loading.onStop = function()
    for _, textures in pairs(loading.textures) do
        if isElement(textures) then
            destroyElement(textures)
        end
    end
    loading.textures = {}
end
addEventHandler("onClientResourceStop", resourceRoot, loading.onStop)
