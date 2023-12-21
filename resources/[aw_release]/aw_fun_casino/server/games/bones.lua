
----------------------------------------------------------------

	boneGames = {}

----------------------------------------------------------------

	function createBonesGame( bet, marker )

		local game = boneGames[marker]

		if game then
			return exports.hud_notify:notify(client, 'Ошибка', 'Стол уже занят')
		end

		if bet > ( client:getData('casino.chips') or 0 ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно фишек')
		end

		if bet < 10 then
			return exports.hud_notify:notify( client, 'Ошибка', 'Минимальная ставка - 10' )
		end

		if bet > 5000 then
			return exports.hud_notify:notify( client, 'Ошибка', 'Максимальная ставка - 5000' )
		end

		boneGames[marker] = {

			creator = client,
			bet = bet,

			marker = marker,

			timer = setTimer(function( marker )

				local game = boneGames[marker]

				if game then

					if isElement( game.creator ) then
						exports.hud_notify:notify(game.creator, 'Время вышло', 'Никто не присоединился')
					end

				end

				destroyMarkerBonesGame( marker )

			end, Config.games.bones.timeout, 1, marker),

			created = getRealTime().timestamp,

			throw_session = {},

		}

		exports.hud_notify:notify(client, 'Ставка одобрена', 'Ожидайте игрока')

		syncBonesGame( marker )
		marker:setData('3dtext', ('[Кости | Ставка - %s]'):format( splitWithPoints( bet, '.' ) ) )

	end
	addEvent('casino.createBonesGame', true)
	addEventHandler('casino.createBonesGame', resourceRoot, createBonesGame)

----------------------------------------------------------------

	function destroyBonesGame( _player )

		local player = _player or client

		for marker, game in pairs( boneGames ) do

			if game.creator == player or game.player == player then

				return destroyMarkerBonesGame( marker )
				
			end

		end

	end

	function destroyMarkerBonesGame( marker )

		local game = boneGames[ marker ]

		if game then

			if isElement( game.creator ) then
				closePlayerWindow( game.creator )
			end

			if isElement( game.player ) then
				closePlayerWindow( game.player )
			end

			game.creator = nil
			game.player = nil
			game.marker = nil

			clearTableElements( game )

		end

		marker:setData('3dtext', '[Кости]')
		boneGames[ marker ] = nil

	end

----------------------------------------------------------------

	function cancelBonesGame( _player )

		local player = _player or client

		for marker, game in pairs( boneGames ) do

			if game.creator == player or game.player == player then

				exports.hud_notify:notify({ game.creator, game.player }, 'Кости', 'Игра отменена')

				if game.started then
					finishBonesGame( marker, game.creator == player and game.player or game.creator )
				else
					destroyMarkerBonesGame( marker )
				end

				
			end

		end

	end
	addEvent('casino.cancelBonesGame', true)
	addEventHandler('casino.cancelBonesGame', resourceRoot, cancelBonesGame)

----------------------------------------------------------------

	function joinBonesGame( marker )

		local game = boneGames[marker]
		if not game then return closePlayerWindow( client ) end

		if game.started or isElement( game.player ) then
			closePlayerWindow( client )
			return exports.hud_notify:notify( client, 'Ошибка', 'За столом уже идет игра' )
		end

		if not isElement( game.creator ) then
			closePlayerWindow( client )
			return exports.hud_notify:notify( client, 'Ошибка', 'Игрок не найден' )
		end

		if game.bet > ( client:getData('casino.chips') or 0 ) then
			closePlayerWindow( client )
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно фишек')
		end

		game.player = client
		game.started = getRealTime().timestamp

		if isTimer( game.timer ) then
			killTimer( game.timer )
		end

		exports.hud_notify:notify( client, 'Игра начинается', ('Ставка - %s'):format( splitWithPoints( game.bet, '.' ) ) )

		increaseElementData( client, 'casino.chips', -game.bet )
		increaseElementData( game.creator, 'casino.chips', -game.bet )

		openPlayerWindow( game.creator, 'bones_game' )
		openPlayerWindow( game.player, 'bones_game' )

		syncBonesGame( marker )
		marker:setData('3dtext', '[Кости | Стол занят]')

		exports.logs:addLog(
			'[CASINO][BONES][START]',
			{
				data = {
					player = client.account.name,
					creator = game.creator.account.name,

					bet = game.bet,

				},	
			}
		)

	end
	addEvent('casino.joinBonesGame', true)
	addEventHandler('casino.joinBonesGame', resourceRoot, joinBonesGame)

----------------------------------------------------------------

	local bones_rotations = {
		[1] = { 0, -90 },
		[2] = { -90, 0 },
		[3] = { 180, 0 },
		[4] = { 0, 0 },
		[5] = { 90, 0 },
		[6] = { 0, 90 },
	}

	function getBonesCubeRotation( number )
		return bones_rotations[number]
	end

----------------------------------------------------------------

	function displayThrowAnimation( marker, player, amount )

		local game = boneGames[ marker ]
		if not game then return end

		game.throw_objects = game.throw_objects or {}

		local x,y,z = getElementPosition(player)
		local ox,oy,oz = getElementPosition(marker.parent)

		local x1,y1,z1 = getPositionFromElementOffset( marker.parent, 1, 0, 0 )
		local x2,y2,z2 = getPositionFromElementOffset( marker.parent, -1, 0, 0 )


		local object_1, object_2

		local add = 0.6
		z1,z2,oz = z1 + add, z2 + add,oz+add

		local r1,r2 = getBonesCubeRotation( amount[1] ), getBonesCubeRotation( amount[2] )

		if game.creator == player then

			object_1 = createObject( 3020, x1,y1-0.1,z1 )
			object_2 = createObject( 3020, x1+0.05,y1+0.05,z1 )


			moveObject( object_1, 1500, ox,oy-0.1,oz, 360*5 + r1[1], 360*5 + r1[2], 50, 'InOutQuad' )
			moveObject( object_2, 1500, ox+0.05,oy+0.05,oz, 360*5 + r2[1], 360*4 + r2[2], 100, 'InOutQuad' )

		else

			object_1 = createObject( 3020, x2,y2-0.1,z2 )
			object_2 = createObject( 3020, x2+0.05,y2+0.05,z2 )

			moveObject( object_1, 1500, ox,oy-0.1,oz, 360*5 + r1[1], 360*5 + r1[2], 50, 'InOutQuad' )
			moveObject( object_2, 1500, ox+0.05,oy+0.05,oz, 360*5 + r2[1], 360*4 + r2[2], 100, 'InOutQuad' )

		end

		game.throw_objects = { object_1, object_2 }

		for _, object in pairs( game.throw_objects ) do
			object.dimension = Config.casinoInterior.dimension
			object.interior = Config.casinoInterior.interior
		end

	end

	function throwBones( marker, _player )

		local player = _player or client

		local game = boneGames[ marker ]
		if not game then return end

		if #game.throw_session >= 6 or game.throwing then
			return
		end

		local last_throw = game.throw_session[ #game.throw_session ]
		local last_player = last_throw and last_throw.player or game.creator

		if last_player == player then
			return exports.hud_notify:notify( player, 'Ошибка', 'Сейчас не ваша очередь' )
		end

		game.throwing = true

		local amount = { math.random(6), math.random(6) }

		setTimer(function(marker, player, amount)

			local game = boneGames[ marker ]
			if not game then return end

			game.throwing = false

			table.insert( game.throw_session, { player = player, amount = amount } )

			if #game.throw_session >= 6 then

				game.finish_timer = setTimer(finishBonesGame, 2000, 1, marker)
				game.finished = true

			end

			clearTableElements( game.throw_objects )
			game.throw_objects = nil

			syncBonesGame( marker )

		end, 3000, 1, marker, player, amount)

		displayPedAnimation( player, 'grenade', 'weapon_throwu', 1000 )
		displayThrowAnimation( marker, player, amount )

		local px,py,pz = getElementPosition( player )
		local mx,my,mz = getElementPosition( marker )

		local r = findRotation( px,py, mx,my )
		setElementRotation( player, 0, 0, r )

		syncBonesGame( marker )

	end
	addEvent('casino.throwBones', true)
	addEventHandler('casino.throwBones', resourceRoot, throwBones)

----------------------------------------------------------------

	function getBonesSum( throw_session )

		local sum = {}

		for _, throw in pairs( throw_session ) do
			sum[throw.player] = (sum[throw.player] or 0) + (throw.amount[1] + throw.amount[2])
		end

		return sum

	end

----------------------------------------------------------------

	function finishBonesGame( marker, _winner, _deadheat )

		local game = boneGames[ marker ]
		if not game then return end

		local sum, winner, looser, deadheat
		deadheat = _deadheat

		local c_win_multiplier = ( 100 - Config.games.bones.comission ) / 100
		local game_bet = math.floor( game.bet * c_win_multiplier )

		if isElement(_winner) then

			winner = _winner
			looser = _winner == game.creator and game.player or game.creator

		else

			sum = getBonesSum( game.throw_session )

			if (sum[ game.creator ] or 0) > (sum[ game.player ] or 0) then

				winner, looser = game.creator, game.player

			elseif (sum[ game.creator ] or 0) < (sum[ game.player ] or 0) then

				winner, looser = game.player, game.creator

			else deadheat = true end

		end


		if deadheat then

			exports.hud_notify:notify( { game.creator, game.player }, 'Ничья', ('Ваша сумма - %s'):format(
				sum[ game.creator ] or 0
			) )

			if isElement(game.creator) then
				increaseElementData( game.creator, 'casino.chips', game_bet )
			end

			if isElement(game.player) then
				increaseElementData( game.player, 'casino.chips', game_bet )
			end

		else

			increaseElementData( winner, 'casino.chips', game_bet * 2 )

			if sum then
				exports.hud_notify:notify( winner, 'Победа', ('Сумма - %s, Выигрыш - %s'):format(
					sum[ winner ] or 0, splitWithPoints( game_bet * 2, '.' )
				) )

				exports.hud_notify:notify( looser, 'Поражение', ('Ваша сумма - %s'):format(
					sum[ looser ] or 0
				) )
			else
				exports.hud_notify:notify( winner, 'Победа', ('Выигрыш - %s'):format(
					splitWithPoints( game_bet * 2, '.' )
				) )

				exports.hud_notify:notify( looser, 'Поражение', 'Вы проиграли')
			end


		end

		exports.logs:addLog(
			'[CASINO][BONES][FINISH]',
			{
				data = {

					player = game.player.account.name,
					creator = game.creator.account.name,

					bet = game.bet,

					winner = isElement(winner) and winner.account.name or false,

				},	
			}
		)

		destroyMarkerBonesGame( marker )

	end

----------------------------------------------------------------

	function syncBonesGame( marker )

		local game = boneGames[marker]
		if not game then return end

		triggerClientEvent( { game.player, game.creator }, 'casino.syncBonesGame', resourceRoot, game )

	end

----------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, coords in pairs( Config.games.bones.markers ) do

			local x,y,z, rz = unpack( coords )

			local object = createObject( 3019, x,y,z, 0, 0, rz )
			local marker = createMarker( x,y,z, 'corona', 2, 0, 0, 0, 0 )

			object.dimension = Config.casinoInterior.dimension
			object.interior = Config.casinoInterior.interior

			marker.dimension = Config.casinoInterior.dimension
			marker.interior = Config.casinoInterior.interior

			marker.parent = object

			marker:setData('3dtext', '[Кости]')

			addEventHandler('onMarkerHit', marker, function( player, mDim )

				if mDim and player.interior == source.interior then

					if boneGames[ source ] and boneGames[ source ].started then
						return exports.hud_notify:notify( player, 'Ошибка', 'Этот стол уже занят' )
					end

					if boneGames[ source ] and boneGames[ source ].creator ~= player then

						bind_openPlayerWindow( player, 'bones_game', source, source, boneGames[ source ] )

					else

						bind_openPlayerWindow( player, 'bones_start', source, source, source.parent )

					end


				end

			end)

			addEventHandler('onMarkerLeave', marker, function( player, mDim )

				if mDim and player.interior == source.interior then

					if boneGames[ source ] and (
						boneGames[ source ].creator == player
						or
						boneGames[ source ].player == player
					) then

						cancelBonesGame( player )

					end

					closePlayerWindow( player )

				end

			end)

		end

	end)

----------------------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()
		cancelBonesGame( source )
	end)

	addEventHandler('onPlayerWasted', root, function()
		cancelBonesGame( source )
	end)

----------------------------------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()

		for marker, game in pairs( boneGames ) do
			finishBonesGame( marker, nil, true )
		end

	end)

----------------------------------------------------------------