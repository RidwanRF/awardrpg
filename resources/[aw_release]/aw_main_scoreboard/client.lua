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

local textures = {

	["main"] = dxCreateTexture ("assets/main.png"),

	["line"] = dxCreateTexture ("assets/line.png"),

	["scroll"] = dxCreateTexture ("assets/scroll.png"),

	["team_bg"] = dxCreateTexture ("assets/team_bg.png"),

}



local fonts = {

	[1] = dxCreateFont ("assets/font2.ttf", 14*px),

	[2] = dxCreateFont ("assets/font.ttf", 10*px),

	[3] = dxCreateFont ("assets/font2.ttf", 12*px),

	[4] = dxCreateFont ("assets/font2.ttf", 10*px),

	[5] = dxCreateFont ("assets/font.ttf", 14*px),

}



local sizeTabY = 200*px

local online = {0, 0}

local startPos = {}

local scrollPos = {}

local scroll = 0

local scrollMax = 0



local teams = {}

local rt = nil

local allSizeRT = 0



local globalAlpha = 255

local openTick = 0

local speedOpen = 500

local useAnim = true



function drawTab ()

	-- if not showtab then return end

	if useAnim then

		if showtab then

			globalAlpha = 255 * math.min (getEasingValue ((getTickCount()-openTick)/speedOpen, "InQuad"), 1)

		else

			globalAlpha = 255 - 255 * math.min (getEasingValue ((getTickCount()-openTick)/speedOpen, "InQuad"), 1)

		end

		if globalAlpha < 2 then return end

	else

		if not showtab then return end

	end

	

	startPos.x = sx/2 - ((506*px)/2)

	startPos.y = sy/2 - sizeTabY/2

	scrollPos.y = startPos.y + 140*px + (sizeTabY - 140*px)/2

	scrollPos.size = (sizeTabY - 140*px - 200*px)/2

	

	dxDrawImage(sx/2-(1920/2)*px, sy/2-(1080/2)*py, 1920*px,1080*py, "assets/aw_ui_scoreboard_blackout.png", 0, 0, 0, tocolor(255, 255, 255, globalAlpha))
	dxDrawImage(startPos.x + 30*px, startPos.y + 10*px, 13*px,17*py, "assets/aw_ui_scoreboard_logotype.png", 0, 0, 0, tocolor(255, 255, 255, globalAlpha))
	dxDrawImage(startPos.x + 30*px, startPos.y + 105*px, 440*px,1*py, "assets/aw_ui_scoreboard_line.png", 0, 0, 0, tocolor(255, 255, 255, globalAlpha))
	

	dxCreateText (serverName, startPos.x + 60*px, startPos.y + 12*px, 100*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[1], "left", "center")
	
	dxCreateText (#getElementsByType("player").." / "..maxPlayers, startPos.x + 370*px, startPos.y + 12*px, 100*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[5], "right", "center")
	

	--dxCreateText ("Онлайн: "..#getElementsByType("player").." / "..maxPlayers, startPos.x + 190*px, startPos.y + 12*px, 135*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[1], "left", "center")



	dxCreateText ("ID", startPos.x + 30*px, startPos.y + 55*px, 100*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[2], "left", "center")

	dxCreateText ("Имя", startPos.x + 70*px, startPos.y + 55*px, 100*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[2], "left", "center")

	dxCreateText ("Стаж", startPos.x + 210*px, startPos.y + 55*px, 100*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[2], "left", "center")

	dxCreateText ("Время сессии", startPos.x + 300*px, startPos.y + 55*px, 100*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[2], "left", "center")

	dxCreateText ("Пинг", startPos.x + 430*px, startPos.y + 55*px, 100*px, 20*px, tocolor(255, 255, 255, globalAlpha), fonts[2], "left", "center")

	

	if scrollMax > 0 then

		--dxDrawRectangle (startPos.x + 486*px, startPos.y + 140*px + 30*px, 6*px, 558*px, tocolor(97, 97, 97, 100 * (globalAlpha/255)))

		

		local size = 558*px * ((648*px)/allSizeRT)

	--	dxDrawRectangle (startPos.x + 486*px, startPos.y + 140*px + 30*px + scroll/scrollMax*(558*px-size), 6*px, size, tocolor(unpack(colorServer), globalAlpha))

	end

	if rt then

		dxDrawImage (startPos.x + 30*px, startPos.y + 140*px, 440*px, math.min(sizeTabY, 648*px), rt, 0, 0, 0, tocolor(255, 255, 255, globalAlpha))

	end

end

addEventHandler ("onClientRender", root, drawTab)



function updateRT ()

	dxSetRenderTarget (rt, true)

		local y = 0

		for team, data in pairs (teams) do

			if team ~= "Обычные игроки" then 

			--	local wtext = dxGetTextWidth (team, 1, fonts[1]) + 40*px

				dxDrawImage (0*px, 0*px + y - scroll, 440*py, 40*px, textures["team_bg"], 0, 0, 0, tocolor(unpack(data.color)) - tocolor(0, 0, 0, alphaColorClan))

				dxCreateText (team, 0, 0*px + y - scroll, 440*py, 38*px, tocolor (255, 255, 255), fonts[4], "center", "center")

				y = y + 100*px

				for _, pl in ipairs (data.players) do

					local color = pl[6] and colorServer or data.color

					dxCreateText (tostring(pl[1]), 0*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(unpack(color)), fonts[3], "left", "center")

					dxCreateText (tostring(pl[2]), 40*px, 0*px + y - scroll  - 60, 135*px, 100*px, tocolor(unpack(color)), fonts[3], "left", "center", true)

					if pl[3] then

						dxCreateText (tostring(pl[3]), 180*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

						dxCreateText (tostring(pl[4]), 270*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

					else

						dxCreateText ("Грузится", 180*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

					end

					dxCreateText (tostring(pl[5]), 400*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

					y = y + 40*px

				end

			end

		end

		

		local data = teams["Обычные игроки"]

		if data then

			dxDrawImage (0*px, 0*px + y - scroll, 440*py, 40*px, textures["team_bg"], 0, 0, 0, tocolor(unpack(data.color)) - tocolor(0, 0, 0, alphaColorClan))

			dxCreateText ("Обычные игроки", 0, 0*px + y - scroll, 440*py, 38*px, tocolor (255, 255, 255), fonts[4], "center", "center")

			y = y + 100*px

			for i, pl in ipairs (teams["Обычные игроки"].players) do

				local color = pl[6] and colorServer or {255, 255, 255}

				dxCreateText (tostring(pl[1]), 0*px, 0*px + y - scroll - 60, 180*px, 100*px, tocolor(unpack(color)), fonts[3], "left", "center")

				dxCreateText (tostring(pl[2]), 40*px, 0*px + y - scroll  - 60, 135*px, 100*px, tocolor(unpack(color)), fonts[3], "left", "center", true)

				if pl[3] then

					dxCreateText (tostring(pl[3]), 180*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

					dxCreateText (tostring(pl[4]), 270*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

				else

					dxCreateText ("Грузится", 180*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

				end

				dxCreateText (tostring(pl[5]), 400*px, 0*px + y - scroll  - 60, 180*px, 100*px, tocolor(97, 97, 97), fonts[3], "left", "center")

				y = y + 40*px

			end

		end

	dxSetRenderTarget ()

end



function dxCreateText (text, x, y, w, h, color, font, ax, ay, maxlenght)

	dxDrawText (text, x, y, x + w, y + h, color, 1, font, ax, ay, maxlenght)

end



function drawFonImage ()

	dxDrawImageSection (

		sx/2-((506*px)/2), 

		startPos.y - 10*px, 

		506*px, 

		10*px, 

		0, 0, 

		506, 10, 

		textures["main"],

		0, 0, 0,

		tocolor(255, 255, 255, globalAlpha)

	)

	

	dxDrawImageSection (

		sx/2-((506*px)/2), 

		startPos.y, 

		506*px, 

		sizeTabY, 

		0, 10, 

		506, 1, 

		textures["main"],

		0, 0, 0,

		tocolor(255, 255, 255, globalAlpha)

	)

	

	dxDrawImageSection (

		sx/2-((506*px)/2), 

		startPos.y + sizeTabY, 

		506*px, 

		10*px, 

		0, 798, 

		506, 10, 

		textures["main"],

		0, 0, 0,

		tocolor(255, 255, 255, globalAlpha)

	)

end



function generateAllTeams ()

	teams = nil

	collectgarbage()

	teams = {}

	allSizeRT = 0

	for i, v in ipairs (getElementsByType("player")) do

		if v.team then

			if not teams[v.team.name] then

				teams[v.team.name] = {

					color = {v.team:getColor()},

					players = {},

				}

			end

			table.insert (teams[v.team.name].players, {

					getElementData (v, "player:ID") or "-", 

					v.name:gsub("#%x%x%x%x%x%x", ""),

					getElementData (v, "timePlayed"),

					getElementData (v, "timePlayedSession"),

					getPlayerPing(v),

					v == localPlayer,

				}

			)

		else

			if not teams["Обычные игроки"] then

				teams["Обычные игроки"] = {

					color = {153, 153, 153},

					players = {},

				}

			end

			table.insert (teams["Обычные игроки"].players, {

					getElementData (v, "player:ID") or "-", 

					v.name:gsub("#%x%x%x%x%x%x", ""),

					getElementData (v, "timePlayed"),

					getElementData (v, "timePlayedSession"),

					getPlayerPing(v),

					v == localPlayer,

				}

			)

		end

	end

	if teams["Обычные игроки"] and #teams["Обычные игроки"].players > 0 then

		table.sort (teams["Обычные игроки"].players, function (a, b)

			return a[3] and not b[3]

		end)

	end

	

	for team, data in pairs (teams) do

		allSizeRT = allSizeRT + 30*px

		for _, pl in ipairs (data.players) do

			allSizeRT = allSizeRT + 33*px

		end

	end

	

	sizeTabY = math.min(137*px + (788*px)*math.min(allSizeRT/(788*px), 1), 788*px)

	if isElement(rt) then destroyElement(rt) end

	rt = dxCreateRenderTarget (440*px, math.min(sizeTabY, 648*px), true)		

	

	updateRT()

	

	if allSizeRT > 648*px then

		scrollMax = allSizeRT - 648*px

	end

end



addEventHandler ("onClientKey", root, function(key)

	if key == "mouse_wheel_up" then

		if scroll - 30 >= 0 then

			scroll = scroll - 30

		else

			scroll = 0

		end

		updateRT ()

	elseif key == "mouse_wheel_down" then

		if scroll + 30 <= scrollMax then

			scroll = scroll + 30

		else

			scroll = scrollMax

		end

		updateRT ()

	end

end)



bindKey ("tab", "both", function(key, state)

	if state == "down" then

		generateAllTeams ()

		if getTickCount() - openTick > speedOpen then

			openTick = getTickCount()

		end

		showtab = true

	else

		showtab = false

		if getTickCount() - openTick > speedOpen then

			openTick = getTickCount()

		end

		-- destroyElement (rt)

	end

end)



addEvent ("tab:online", true)

addEventHandler ("tab:online", resourceRoot, function(count, all)

	online[1] = count

	online[2] = all

end)