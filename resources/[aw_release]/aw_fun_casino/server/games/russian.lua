
----------------------------------------------------------------

	russianGames = {}

----------------------------------------------------------------

	function togglePlayerControls( player, state )

		local controls = {
			'forwards',
			'backwards',
			'left',
			'right',
			'jump',
			'crouch',
			'action',
			'walk',
			'enter_exit',
		}

		for _, control in pairs( controls ) do
			toggleControl( player, control, state )
		end

	end

----------------------------------------------------------------

	function createRussianGame( marker, bet )

		if russianGames[marker] then return end

		if ( client:getData('casino.chips') or 0 ) < bet then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно фишек')
		end

		local game = {
			players = {},
			created = getRealTime().timestamp,
			marker = marker,
			bet = bet,
		}

		game.start_timer = setTimer(startRussianGame, Config.games.russian.timeout, 1, marker)
		game.players[client] = {}

		russianGames[marker] = game

		exports.hud_notify:notify(client, 'Успешно', 'Ожидайте игроков')

		marker:setData('3dtext', ('[Русская рулетка | Ставка - %s]'):format( splitWithPoints( bet, '.' ) ))

		syncRussianGame( marker )

	end
	addEvent('casino.createRussianGame', true)
	addEventHandler('casino.createRussianGame', resourceRoot, createRussianGame)

----------------------------------------------------------------

	function joinRussianGame( marker )

		local game = russianGames[marker]
		if not game then return end

		if game.started then
			return exports.hud_notify:notify(client, 'Ошибка', 'Игра уже идет')
		end

		if ( client:getData('casino.chips') or 0 ) < game.bet then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно фишек')
		end

		local limit = Config.games.russian.table_limit

		if getTableLength( game.players ) >= limit then
			return exports.hud_notify:notify(client, 'Ошибка', 'Лимит игроков - ' .. limit)
		end

		closePlayerWindow( client )
		togglePlayerControls( client, false )

		game.players[client] = {}

		if getTableLength( game.players ) >= limit then
			startRussianGame( marker )
		end


	end
	addEvent('casino.joinRussianGame', true)
	addEventHandler('casino.joinRussianGame', resourceRoot, createRussianGame)

----------------------------------------------------------------

	function startRussianGame( marker )

		local game = russianGames[marker]
		if not game then return end

		if getTableLength( game.players ) < 2 then
			return finishRussianGame( marker )
		end

		game.started = true

		local x,y,z = getElementPosition( marker.parent )

		game.total_bet = 0

		local index = 1

		for player, data in pairs( game.players ) do

			increaseElementData( player, 'casino.chips', -game.bet )
			game.total_bet = game.total_bet + game.bet

			exports.logs:addLog(
				'[CASINO][RUSSIAN][WIN]',
				{
					data = {
						player = player.account.name,
						bet = game.bet,
					},	
				}
			)

			closePlayerWindow( player )
			togglePlayerControls( player, false )

			local px,py = getElementPosition( player )
			local r = findRotation( px,py, x,y )

			setElementRotation( player, 0, 0, r )

			data.index = index
			index = index + 1

		end

		if isTimer( game.start_timer ) then
			killTimer( game.start_timer )
		end

		resetRussianWeapon( marker )

		game.active_player = 1

		resetShootTimer( marker )
		syncRussianGame( marker )

	end

----------------------------------------------------------------

	function resetShootTimer( marker )

		local game = russianGames[marker]
		if not game then return end

		if isTimer( game.shoot_timer ) then
			killTimer( game.shoot_timer )
		end

		game.shoot_timer = setTimer( doRussianShoot, 5000, 1, marker )

		local a_player = getRussianActivePlayer( game )

		if isElement( a_player ) then
			exports.hud_notify:notify( a_player, 'Русская рулетка', 'Сейчас ваша очередь' )
			exports.hud_notify:notify( a_player, 'Нажмите ЛКМ', 'Чтобы взять пистолет' )
		end

	end

----------------------------------------------------------------

	function resetRussianWeapon( marker )

		local game = russianGames[marker]
		if not game then return end

		local x,y,z = getElementPosition( marker.parent )

		if isElement( game.weapon ) then
			destroyElement( game.weapon )
		end

		game.weapon = createObject( 348, x,y,z+0.48, 90, 0, 45 )

		game.weapon.dimension = Config.casinoInterior.dimension
		game.weapon.interior = Config.casinoInterior.interior

	end

----------------------------------------------------------------

	function resetPlayersIndex( marker )

		local game = russianGames[marker]
		if not game then return end

		local index = 1

		for player, data in pairs( game.players or {} ) do

			data.index = index
			index = index + 1

		end

		if not getRussianActivePlayer( game ) then
			game.active_player = 1
		end

		resetShootTimer( marker )
		syncRussianGame( marker )

	end

----------------------------------------------------------------

	function doRussianShoot( marker )

		local game = russianGames[marker]
		if not game then return end

		if game.shoot then return end
		game.shoot = true

		local player = client or getRussianActivePlayer( game )

		if getRussianActivePlayer( game ) ~= player then
			return
		end

		if isTimer( game.shoot_timer ) then
			killTimer( game.shoot_timer )
		end

		if isElement( game.weapon ) then
			destroyElement( game.weapon )
		end

		giveWeapon( player, 24, 1, true )

		setPedAnimation(player, 'ped', 'fucku', 3000, false, true, true, false)

		setTimer(function( marker, player )

			local game = russianGames[marker]
			if not game then return end

			local t_players = {}
			for p in pairs( game.players or {} ) do
				table.insert( t_players, p )
			end

			local kill = math.random( 1,6 ) == 3

			exports.main_sounds:playSound( t_players, kill and 'russian_kill' or 'russian_empty' )

			if kill then
				exports.hud_notify:notify( player, 'Русская рулетка', 'Вы проиграли' )
				leaveRussianGame( player, marker )
			else
				exports.hud_notify:notify( player, 'Русская рулетка', 'Вы выжили' )
			end

			takeAllWeapons( player )

			game.shoot = false

			game.active_player = cycle( (game.active_player or 0) + 1, 1, getTableLength( game.players ) )

			resetShootTimer( marker )
			syncRussianGame( marker )

			resetRussianWeapon( marker )

		end, 3000, 1, marker, player)

		syncRussianGame( marker )

	end
	addEvent('casino.doRussianShoot', true)
	addEventHandler('casino.doRussianShoot', resourceRoot, doRussianShoot)

----------------------------------------------------------------
	
	function finishRussianGame( marker )

		local game = russianGames[marker]
		if not game then return end

		game.finished = true

		if getTableLength( game.players ) > 1 then

			if game.total_bet then

				for player in pairs( game.players ) do
					exports.hud_notify:notify( player, 'Игра отменена', 'Вам вернули ставку' )
					increaseElementData( player, 'casino.chips', game.bet )
				end

			end

		else

			local player
			for p in pairs( game.players ) do player = p end

			if not isElement(player) then return end

			if game.total_bet and game.started then

				local comission = Config.games.russian.comission
				local win_sum = math.floor( game.total_bet )

				increaseElementData( player, 'casino.chips', win_sum )

				exports.hud_notify:notify( player, 'Вы выиграли', ('Сумма - %s %s'):format(
					splitWithPoints( win_sum, '.' ),
					getWordCase( win_sum, 'фишку', 'фишки', 'фишек' )
				) )

				exports.logs:addLog(
					'[CASINO][RUSSIAN][WIN]',
					{
						data = {
							player = player.account.name,
							amount = win_sum,
						},	
					}
				)

			else
				exports.hud_notify:notify( player, 'Русская рулетка', 'Игра отменена' )
			end

		end

		for player in pairs( game.players ) do
			leaveRussianGame( player, marker )
		end

		clearTableElements( game )
		russianGames[ marker ] = nil

	end

----------------------------------------------------------------

	function leaveRussianGame( _player, _marker )

		local player = isElement( _player ) and _player or source
		local game

		if isElement( _marker ) and _marker.type == 'marker' then

			game = russianGames[marker]

			if game and game.players and game.players[player] then

				clearTableElements( game.players[ player ] )
				game.players[ player ] = nil

			end

		else

			for marker, _game in pairs( russianGames ) do

				if _game.players and _game.players[player] then

					game = _game

					clearTableElements( game.players[ player ] )
					game.players[ player ] = nil

				end

			end

		end

		triggerClientEvent( player, 'casino.syncRussianGame', resourceRoot, nil )
		closePlayerWindow( player )
		togglePlayerControls( player, true )

		takeAllWeapons( player )

		resetPlayersIndex( marker )
		syncRussianGame( marker )

		if game and getTableLength( game.players ) <= 1 then
			finishRussianGame( marker )
		end


	end
	addEvent('casino.leaveRussianGame', true)
	addEventHandler('casino.leaveRussianGame', resourceRoot, leaveRussianGame)

----------------------------------------------------------------

	function syncRussianGame( marker )

		local game = russianGames[marker]
		if not game then return end

		local t_players = {}

		for player in pairs( game.players or {} ) do
			table.insert( t_players, player )
		end

		if #t_players > 0 then
			triggerClientEvent( t_players, 'casino.syncRussianGame', resourceRoot, game )
		end

	end

----------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, coords in pairs( Config.games.russian.markers ) do

			local x,y,z, rz = unpack( coords )

			local object = createObject( 3019, x,y,z, 0, 0, rz )
			local marker = createMarker( x,y,z, 'corona', 2, 0, 0, 0, 0 )

			object.dimension = Config.casinoInterior.dimension
			object.interior = Config.casinoInterior.interior

			marker.dimension = Config.casinoInterior.dimension
			marker.interior = Config.casinoInterior.interior

			marker.parent = object

			marker:setData('3dtext', '[Русская рулетка]')

			addEventHandler('onMarkerHit', marker, function( player, mDim )

				if mDim and player.interior == source.interior then

					if russianGames[ source ] and russianGames[ source ].started then
						return exports.hud_notify:notify( player, 'Ошибка', 'Этот стол уже занят' )
					end

					if russianGames[ source ] and russianGames[ source ].creator ~= player then

						bind_openPlayerWindow( player, 'russian_game', source, source, russianGames[ source ] )

					else

						bind_openPlayerWindow( player, 'russian_start', source, source, source.parent )

					end


				end

			end)

			addEventHandler('onMarkerLeave', marker, function( player, mDim )

				if mDim and player.interior == source.interior then

					if russianGames[ source ] and (
						russianGames[ source ].creator == player
						or
						russianGames[ source ].player == player
					) then

						leaveRussianGame( player )

					end

					closePlayerWindow( player )

				end

			end)

		end

	end)

----------------------------------------------------------------

	addEventHandler('onPlayerQuit', root, leaveRussianGame)
	addEventHandler('onPlayerWasted', root, leaveRussianGame)

----------------------------------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()

		for marker in pairs( russianGames ) do
			finishRussianGame( marker )
		end

	end)

----------------------------------------------------------------
