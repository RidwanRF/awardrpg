
----------------------------------------------------------------------

	casinoPlayers = {}
	casinoMarkers = {}

----------------------------------------------------------------------

	function getCasinoPlayers()

		local players = {}

		for player in pairs( casinoPlayers ) do
			table.insert( players, player )
		end

		return players

	end

----------------------------------------------------------------------

	function getCasinoInteriorData()

		return {

			fortune = fortuneWheels,

		}

	end

----------------------------------------------------------------------

	function enterCasino( player )

		if not isElement( player ) then return end

		local x,y,z = unpack( Config.casinoInterior.enter_player )

		spawnPlayer(
			player, x,y,z, 0, player.model,
			Config.casinoInterior.interior,
			Config.casinoInterior.dimension,
			player.team
		)

		-- exports.engine:replaceModels( player, 'casino' )

	--	exports.hud_main:addPlayerHUDRow( player, 'chips', 'casino.chips', 1 )
	--	exports.hud_main:addPlayerHUDRow( player, 'vip_tickets', 'casino.vip_tickets' )

		player:setData('radar.hidden', true)
		toggleControl( player, 'fire', false )

		triggerClientEvent( player, 'casino.onInteriorEnter', resourceRoot, getCasinoInteriorData() )

		casinoPlayers[ player ] = true

	end

----------------------------------------------------------------------

	function exitCasino( player )

		if not isElement( player ) then return end

		local x,y,z = unpack( Config.casinoInterior.exit_player )
		spawnPlayer( player, x,y,z, 0, player.model, 0, 0, player.team )

		-- exports.engine:restoreModels( player, 'casino' )

		player:setData('radar.hidden', false)
		toggleControl( player, 'fire', true )

	--	exports.hud_main:removePlayerHUDRow( player, 'chips' )
		--exports.hud_main:removePlayerHUDRow( player, 'vip_tickets' )

		triggerClientEvent( player, 'casino.onInteriorExit', resourceRoot )

		casinoPlayers[ player ] = nil

	end

----------------------------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()

		if casinoPlayers[ source ] then
			exitCasino( source )
		end

	end, true, 'high+1000')

----------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()


		--------------------------------------------

			local x,y,z = unpack( Config.casinoInterior.enter )
			casinoMarkers.enter = createMarker( x,y,z, 'cylinder', 1.5, 255, 90, 90, 150 )
			casinoMarkers.enter:setData('3dtext', '[Вход в казино]')

			local blip = createBlipAttachedTo( casinoMarkers.enter, 0 )
			blip:setData('icon', 'casino')

			addEventHandler('onMarkerHit', casinoMarkers.enter, function( player, mDim )

				if isElement( source ) and mDim and player.interior == source.interior then
					enterCasino( player )
				end

			end)

		--------------------------------------------

			local x,y,z = unpack( Config.casinoInterior.exit )
			casinoMarkers.exit = createMarker( x,y,z, 'cylinder', 1.5, 255, 90, 90, 150 )
			casinoMarkers.exit:setData('3dtext', '[Выход]')

			casinoMarkers.exit.interior = Config.casinoInterior.interior
			casinoMarkers.exit.dimension = Config.casinoInterior.dimension

			addEventHandler('onMarkerHit', casinoMarkers.exit, function( player, mDim )

				if isElement( source ) and mDim and player.interior == source.interior then
					exitCasino( player )
				end

			end)

		--------------------------------------------

	end)


----------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		setTimer(function()

			local players = {}

			for _, player in pairs( getElementsByType('player') ) do

				if player.dimension == Config.casinoInterior.dimension
				and player.interior == Config.casinoInterior.interior
				then

					table.insert( players, player )

				end

			end

			triggerClientEvent(players, 'casino.onInteriorEnter', resourceRoot, getCasinoInteriorData())
			
			
		end, 3000, 1)


	end)

----------------------------------------------------------------------