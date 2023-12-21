



	roulettes = {}



	function createRouletteTimer( marker ) 

		local roulette = roulettes[marker]
		if not roulette then return end

		if isTimer( roulette.timer ) then
			killTimer( roulette.timer )
		end

		roulette.timer = setTimer(doRouletteRoll, Config.games.roulette.timeout, 1, marker)
		roulette.timer_started = getRealTime().timestamp

		roulette.marker:setData('3dtext', '[Рулетка | Скоро начнется]')

		syncRoulette( marker )

	end



	function setRouletteBet( marker, bet_str, amount )

		local roulette = roulettes[marker]
		if not roulette then return end

		if roulette.active then
			return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Ставки заблокированы", getTickCount(), 8000)
		end

		if exports.bank:getPlayerBankMoney(client, "RUB") <= amount then
			return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "У вас недостаточно денег в банке", getTickCount(), 8000)
		end

		if amount < 100000 then
			return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Минимальная ставка $ 100 000", getTickCount(), 8000)
		end

		if amount > 50000000000 then
			return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Максимальная ставка $ 50 000 000 000", getTickCount(), 8000)
		end

		if not isTimer(roulette.timer) then
			createRouletteTimer( marker )
		end

		roulette.bets = roulette.bets or {}

		local player_bets = 0

		for _, bet in pairs( roulette.bets ) do

			if bet.player == client then

				player_bets = player_bets + 1

				if bet.id == tostring(bet_str) then
					return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Вы уже сделали такую ставку", getTickCount(), 8000)
				end

			end

		end

		if player_bets >= Config.games.roulette.bet_limit then

			return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Превышен лимит ставок", getTickCount(), 8000)

		end

		--increaseElementData( client, 'casino.chips', -amount )
		exports.bank:takePlayerBankMoney(client, amount, "RUB")

		local bet = {
			player = client,
			amount = amount,
			id = tostring(bet_str),
		}

		table.insert( roulette.bets, bet )

		exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Вы успешно сделали ставку", getTickCount(), 8000)

		local config = Config.games.roulette.bets
		local bet_name = config[bet_str] and config[bet_str].name or bet_str

		local log = ('Вы поставили %s %s на %s'):format(
			amount, getWordCase( amount, '$', '$', '$' ), bet_name
		)

		addRouletteLog( client, log )

		triggerClientEvent( client, 'casino.addRouletteBetObject', resourceRoot, roulette.base, bet_str )

		syncRoulette( marker )

		exports.aw_server_logs:log("CASINO-ROULETTE", {data = {player = client.account.name,amount = amount,bet = bet_str,},})

	end
	addEvent('casino.setRouletteBet', true)
	addEventHandler('casino.setRouletteBet', resourceRoot, setRouletteBet)



	local numbers = {
		0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10,
		5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26
	}

	function getRouletteNumberIndex( num )

		for index, number in pairs( numbers ) do
			if number == num then
				return index-1
			end
		end

	end

	function doRouletteRoll( marker )

		local roulette = roulettes[marker]
		if not roulette then return end

		roulette.active = true

		local c_number = getRouletteNumberIndex( roulette.win_number )

		local count = 37
		local step = 360/count

		roulette.win_number = math.random( 0,count-1 )
		local n_number = getRouletteNumberIndex( roulette.win_number )

		local delta = (n_number - c_number) * step
		local random = math.random( 60, 360 )

		local time = 12000

		local x,y,z = getElementPosition( roulette.wheel )
		moveObject( roulette.wheel, time, x,y,z, 0, 0, 360*10 + delta + random, 'InOutQuad' )
		moveObject( roulette.ball, time, x,y,z, 0, 0, -360*10 + random, 'InOutQuad' )

		setTimer( finishRoulette, time + 3000, 1, marker )

		syncRoulette( marker )

	end



	function getBetWin( bet, number )

		local bets_config = Config.games.roulette.bets

		if not bets_config[bet.id] then

			if tostring(bet.id) == tostring(number) then
				return bet.amount * bets_config.default.mul
			end

		end

		local bet_config = bets_config[bet.id]
		if not bet_config then return end

		for _, win_number in pairs( bet_config.win ) do
			if win_number == number then
				return bet_config.mul * bet.amount
			end
		end

		return false

	end



	function finishRoulette( marker )

		local roulette = roulettes[marker]
		if not roulette then return end

		local players, k_players = {}, {}

		local bets_config = Config.games.roulette.bets

		for _, bet in pairs( roulette.bets ) do

			if isElement( bet.player ) then
				k_players[bet.player] = true
			end

		end

		for player in pairs ( k_players ) do
			table.insert( players, player )
		end

		addRouletteLog( players, 'Выпало число ' .. roulette.win_number )

		for _, bet in pairs( roulette.bets ) do

			if isElement( bet.player ) then

				local bet_name = bets_config[bet.id] and bets_config[bet.id].name or bet.id

				local win = getBetWin( bet, roulette.win_number )
				if win and win > 0 then

					addRouletteLog( bet.player, ('Ставка на %s зашла'):format( bet_name ) )
					addRouletteLog( bet.player, ('Вы выиграли %s %s'):format(
						win, getWordCase( win, '$', '$', '$' )
					) )

				--	increaseElementData( bet.player, 'casino.chips', win )
					exports.bank:givePlayerBankMoney(bet.player, win, "RUB")

					exports.logs:addLog(
						'[CASINO][ROULETTE][WIN]',
						{
							data = {
								player = bet.player.account.name,
								amount = win,
								bet = bet.amount,
							},	
						}
					)

				else

					addRouletteLog( bet.player, ('Ставка на %s не зашла'):format( bet_name ) )

					exports.aw_server_logs:log("CASINO-ROULETTE",{data = {player = bet.player.account.name,bet = bet.amount,},	})

				end

			end

		end

		clearTableElements( roulette.bets )
		roulette.bets = nil

		roulette.active = false

		if isTimer( roulette.timer ) then
			killTimer( roulette.timer )
		end

		roulette.timer = nil
		roulette.timer_started = nil

		roulette.marker:setData('3dtext', '[Рулетка]')

		triggerClientEvent( players, 'casino.syncRoulette', resourceRoot, roulette )
		triggerClientEvent( players, 'casino.clearRouletteBetObjects', resourceRoot, roulette.base )

	end



	function syncRoulette( marker, player )

		local roulette = roulettes[marker]
		if not roulette then return end

		local players = {}

		if isElement(player) then
			players = {}
		else

			for _, bet in pairs( roulette.bets or {} ) do
				if isElement( bet.player ) then
					table.insert( players, bet.player )
				end
			end

		end

		triggerClientEvent( players, 'casino.syncRoulette', resourceRoot, roulette )

	end



	addEventHandler('onResourceStart', resourceRoot, function()

		for _, coords in pairs( Config.games.roulette.markers ) do

			local x,y,z, rz = unpack( coords )
			local ox,oy,oz = -0.008585*1.5, -0.665631*1.5, 0.382634*1.5

			local dist = getDistanceBetweenPoints2D( x,y, x+ox,y+oy )
			local nx,ny = getPointFromDistanceRotation( x,y, dist, -rz+180 )
			local nz = z+oz

			local roulette = {}

			roulette.marker = createMarker( x,y,z, 'corona', 2, 0, 0, 0, 0 )

			roulette.base = createObject( 3026, x,y,z, 0, 0, rz )
			roulette.wheel = createObject( 1134, nx,ny,nz, 0, 0, rz )
			roulette.ball = createObject( 3025, nx,ny,nz, 0, 0, rz )
			roulette.win_number = 0

			setElementCollisionsEnabled( roulette.wheel, false )

			roulettes[roulette.marker] = roulette

			for _, element in pairs( roulette ) do

				if isElement( element ) then
					element.dimension = Config.casinoInterior.dimension
					element.interior = Config.casinoInterior.interior
				end

			end

			addEventHandler('onMarkerHit', roulette.marker, function( player, mDim )

				if mDim and player.interior == source.interior then
					bind_openPlayerWindow( player, 'roulette', source, roulettes[source] )
				end

			end)

			addEventHandler('onMarkerLeave', roulette.marker, function( player, mDim )

				if mDim and player.interior == source.interior then
					closePlayerWindow( player, 'roulette' )
				end

			end)

			roulette.marker:setData('3dtext', '[Рулетка]')

		end

	end)



	function addRouletteLog( player, text )
		triggerClientEvent( player, 'casino.rouletteLog', resourceRoot, text )
	end



	
	addEventHandler('onResourceStop', resourceRoot, function()

		for _, roulette in pairs( roulettes ) do

			for _, bet in pairs( roulette.bets or {} ) do

				if isElement(bet.player) then
					increaseElementData( bet.player, 'casino.chips', bet.amount )
				end

			end

		end

	end)

