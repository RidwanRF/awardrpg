
local sx,sy = guiGetScreenSize()

function drawPlayer(data)
	local player = data.player

	local x,y,z = getElementPosition(player)
	local px,py,pz = getElementPosition(localPlayer)

	local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
	if dist < 15 then

		-- local dScale = math.abs( math.sin( getTickCount()*0.0015 ) )
		local dScale = 1-(dist/15)
		dScale = math.clamp(dScale, 0.5, 1)

		local sx,sy = getScreenFromWorldPosition(x,y,z+1.10*dScale)
		if not sx then return end

		sy = math.floor(sy)

		local scale, font = 0.5*dScale, getFont('montserrat_medium', 40, 'light', true)

		local trw,trh = 63*dScale,41*dScale

		dxDrawImage(sx - trw/2, sy + 30*dScale,trw, trh, 'assets/images/triangle.png',0, 0, 0,tocolor(255,255,255,255))

		local rw,rh = 140*dScale, 3*dScale
		local rx,ry = sx - rw/2, sy + 24*dScale

		dxDrawRectangle(rx,ry,rw,rh, tocolor(255,255,255,67))
		dxDrawRectangle(rx,ry,rw*player.health/100,rh, tocolor(255,255,255,255))

		local name = clearColorCodes(player.name)

		local typingSymbols = ''

		if player:getData('chat.typing') then
			typingSymbols = 'пишет...'
		end

		if player:getData('chat.lastMessage') then

			typingSymbols = player:getData('chat.lastMessage')

			-- if utf8.len(typingSymbols) > 10 then
			-- 	typingSymbols = utf8.sub(typingSymbols, 0, 10)..'...'
			-- end

		end

		if #typingSymbols > 0 then

			name = name .. string.format(' - %s', typingSymbols)

		end

		if player:getData('isAFK') then
			name = '#ffcc22AFK#ffffff ' .. name
		end

		local r,g,b = hexToRGB( player:getData('character.nickname_color') or '#ffffff' )



		if player:getData('vip') then

			local textWidth = dxGetTextWidth(name, scale, font, true)
			local imgSize = 20*dScale
			local imgPadding = 2

			local startX = sx - (textWidth+imgSize+imgPadding)/2

			dxDrawTextShadow(name,startX,sy,startX,sy, tocolor(r,g,b,255),scale, font,'left', 'center', 1, tocolor(0, 0, 0, 67),clearColorCodes(name), dxDrawText)

			dxDrawImage(startX + textWidth + imgPadding, sy - imgSize/2 + 3*dScale,imgSize, imgSize, 'assets/images/vip.png',0, 0, 0, tocolor(255,255,255,255))

		else

			dxDrawTextShadow(name,sx,sy,sx,sy, tocolor(r,g,b,255),scale, font,'center', 'center', 1, tocolor(0, 0, 0, 67),clearColorCodes(name), dxDrawText)

		end

		local yadd = 0

		if player.team then

			local tr,tg,tb = getTeamColor( player.team )
			local t_name = ('|%s|'):format( player.team.name )

			dxDrawTextShadow(t_name,sx,sy-10,sx,sy-10, tocolor(tr,tg,tb,255),0.5, getFont('montserrat_medium', 26, 'light', true),'center', 'bottom', 1, tocolor(0, 0, 0, 67),clearColorCodes(t_name), dxDrawText)

			yadd = -15

		end

		local status = player:getData('status.current')
		if status then

			local stw,sth = 70*dScale,70*dScale

			local path = string.format(':main_freeroam/assets/images/status/%s.png', status)

			if fileExists(path) then

				dxDrawImage(sx - stw/2, sy - sth - 5 + yadd,stw,sth, path,0, 0, 0, tocolor(255,255,255,255))

			end

		end

	end

end

currentPlayers = {}

setTimer(function()
	currentPlayers = {}

	local players = getElementsByType('player', root, true)
	for _, player in pairs( players ) do
		if isElement(player) then
			setPlayerNametagShowing(player, false)
			if isElementOnScreen(player) and player ~= localPlayer and getDistanceBetween(player, localPlayer) < 15 then

				table.insert(currentPlayers,
					{
						player = player,
					}
				)

			end
		end
	end
end, 1000, 0)

addEventHandler('onClientRender', root, function()

	--if not localPlayer:getData('unique.login') then return end
	--if localPlayer:getData('players.hidden') then return end

	for _, data in pairs( currentPlayers ) do
		if isElement(data.player) and isElementOnScreen(data.player) then
			drawPlayer(data)
		end
	end


end)

