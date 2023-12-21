
---------------------------------------------

	blackjackMarkers = {}

---------------------------------------------

	function openCard( cards )

		local card_opened = false

		for index, card in pairs( cards ) do

			if not card.opened then

				card_opened = true
				card.opened = true
				break

			end

		end

		return card_opened

	end

---------------------------------------------

	blackjackDB = dbConnect('sqlite', ':databases/blackjack.db')

---------------------------------------------

	local function updateDatabase()

		dbExec(blackjackDB, 'CREATE TABLE IF NOT EXISTS steps(steps TEXT);')
		local result = dbPoll(dbQuery(blackjackDB, 'SELECT * FROM steps;'), -1)

		if not (result and result[1]) then
			dbExec(blackjackDB, 'INSERT INTO steps(steps) VALUES (\'[ [ ] ]\');')
		end 

	end
	addEventHandler('onResourceStart', resourceRoot, updateDatabase)

	function increaseBlackjackStep()

		local game_type = 'default'

		local query = dbPoll( dbQuery(blackjackDB, 'SELECT * FROM steps' ), -1)
		local array = fromJSON( query[1]['steps'], true )

		array[game_type] = ( array[game_type] or 1 ) + 1

		dbExec( blackjackDB, string.format('UPDATE steps SET steps=\'%s\';', toJSON(array)) )

	end

	function getBlackjackStep()

		local game_type = 'default'

		local query = dbPoll( dbQuery(blackjackDB, 'SELECT * FROM steps;'), -1 )
		local array = fromJSON(query[1]['steps'], true)

		return array[game_type] or 1

	end

---------------------------------------------

	function getBlackjackSetup()

		increaseBlackjackStep()

		local step = getBlackjackStep( wheel_type )
		local setups = {}

		for _, setup in pairs( Config.games.blackjack.random ) do

			if (step % setup.step) == 0 then
				table.insert( setups, setup )
			end

		end

		table.sort( setups, function( a,b )
			return a.step > b.step
		end )

		if #setups == 0 then
			outputDebugString( 'CASINO BLACKJACK SETUPS ERROR', 1, 255, 0, 0 )
			return false
		end

		local amount = math.random( unpack( setups[1].amount ) )
		return amount

	end

---------------------------------------------

	local card_weight = {
		[2] = { 'j', 2 },
		[3] = { 'q', 3 },
		[4] = { 'k', 4 },
		[5] = { 5 },
		[6] = { 6 },
		[7] = { 7 },
		[8] = { 8 },
		[9] = { 9 },
		[10] = { 10 },
		[11] = { 'a' },
	}

	function getCardByWeight( weight )

		local p_cards = card_weight[ weight ]
		local card = { card = p_cards[ math.random(#p_cards) ] }

		local suits = {'cluds', 'heats', 'diamonds', 'spades'}
		card.suit = suits[ math.random( #suits ) ]
		card.opened = true

		return card

	end

---------------------------------------------

	local card_combinations = {
		[4] = { { 2, 2 } },
		[5] = { { 2, 3 } },
		[6] = { { 3, 3 }, { 2, 4 }, { 2, 2, 2 } },
		[7] = { { 4, 3 }, { 2, 2, 3 }, },
		[8] = { { 2, 2, 2, 2 }, { 3, 3, 2, }, { 5, 3 }, { 4,4 } },
		[9] = { { 3, 3, 3 }, { 4, 5, }, { 6, 3 }, { 7, 2 } },
		[10] = { { 5, 5 }, { 3, 3, 4, }, { 4, 4, 2 }, { 5, 3, 2 } },
		[11] = { { 5, 6 }, { 3, 4, 4, }, { 4, 5, 2 }, { 6, 3, 2 } },
		[12] = { { 5, 7 }, { 4, 4, 4, }, { 5, 5, 2 }, { 7, 3, 2 } },
		[13] = { { 5, 8 }, { 5, 4, 4, }, { 6, 5, 2 }, { 8, 3, 2 }, { 3, 3, 3, 4 }, { 5, 2, 2, 2, 2 } },
		[14] = { { 5, 9 }, { 5, 5, 4, }, { 6, 6, 2 }, { 8, 4, 2 }, { 3, 3, 3, 5 }, { 5, 3, 2, 2, 2 } },
		[15] = { { 5, 10 }, { 6, 5, 4, }, { 6, 6, 3 }, { 9, 4, 2 }, { 4, 3, 3, 5 }, { 5, 3, 3, 2, 2 }, { 4, 11 } },
		[16] = { { 6, 10 }, { 7, 5, 4, }, { 7, 6, 3 }, { 10, 4, 2 }, { 4, 3, 3, 6 }, { 5, 3, 3, 3, 2 } },
		[17] = { { 6, 11 }, { 7, 6, 4, }, { 8, 6, 3 }, { 10, 5, 2 }, { 5, 3, 3, 6 }, { 5, 3, 3, 3, 3 } },
		[18] = { { 7, 11 }, { 8, 6, 4, }, { 9, 6, 3 }, { 10, 6, 2 }, { 5, 3, 3, 7 }, { 8, 2, 2, 3, 3 } },
		[19] = { { 8, 11 }, { 9, 6, 4, }, { 10, 6, 3 }, { 11, 6, 2 }, { 5, 4, 3, 7 }, { 10, 2, 2, 2, 3 } },
		[20] = { { 9, 11 }, { 9, 7, 4, }, { 10, 6, 4 }, { 11, 6, 3 }, { 6, 4, 3, 7 }, { 10, 3, 2, 2, 3 } },
		[21] = { { 10, 11 }, { 10, 7, 4, }, { 10, 6, 5 }, { 11, 6, 4 }, { 7, 4, 3, 7 }, { 10, 4, 2, 2, 3 } },
		[22] = { { 10, 9, 3 }, { 10, 8, 4, }, { 10, 7, 5 }, { 6, 6, 6, 4 }, { 8, 4, 3, 7 }, { 10, 5, 2, 2, 3 } },
		[23] = { { 10, 10, 3 }, { 10, 8, 5, }, { 10, 7, 6 }, { 6, 6, 6, 5 }, { 8, 5, 3, 7 }, { 10, 5, 3, 2, 3 } },
		[24] = { { 10, 10, 4 }, { 10, 8, 6, }, { 10, 7, 7 }, { 7, 6, 6, 5 }, { 9, 5, 3, 7 }, { 10, 5, 3, 3, 3 } },
		[25] = { { 10, 10, 5 }, { 10, 9, 6, }, { 10, 8, 7 }, { 7, 7, 6, 5 }, { 9, 5, 3, 8 }, { 10, 6, 3, 3, 3 } },
		[26] = { { 10, 10, 6 }, { 10, 9, 7, }, { 10, 8, 8 }, { 7, 7, 7, 5 }, { 9, 6, 3, 8 }, { 10, 6, 4, 3, 3 } },
		[27] = { { 10, 10, 7 }, { 10, 9, 8, }, { 10, 8, 5, 4 }, { 7, 7, 7, 6 }, { 10, 6, 3, 8 }, { 10, 6, 5, 3, 3 } },
		[28] = { { 10, 10, 8 }, { 10, 9, 9, }, { 10, 8, 5, 5 }, { 7, 7, 7, 7 }, { 10, 6, 4, 8 }, { 10, 7, 5, 3, 3 } },
	}

	function getCardsCombination( amount )

		local possible = card_combinations[ amount ]

		local combination = table.copy( possible[ math.random( #possible ) ] )

		combination = randomSort( combination )

		local used_cards = {}

		local cards = {}

		for _, weight in pairs( combination ) do

			local t_card = getCardByWeight( weight )
			while used_cards[ t_card.suit .. '_' .. t_card.card ] do
				t_card = getCardByWeight( weight )
			end

			table.insert( cards, t_card )
			used_cards[ t_card.suit .. '_' .. t_card.card ] = true

		end

		return cards


	end

---------------------------------------------

	function generateCards()

		local deck = {}

		local croupier_sum = getBlackjackSetup()
		local croupier_cards = getCardsCombination( croupier_sum )

		local k_croupier_cards = {}

		for _, card in pairs( croupier_cards ) do
			k_croupier_cards[ card.suit .. '_' .. card.card ] = true
		end

		for _, suit in pairs( {'cluds', 'heats', 'diamonds', 'spades'} ) do

			for _, card in pairs( { 2, 3, 4, 5, 6, 7, 8, 9, 10, 'j', 'q', 'k', 'a' } ) do

				if not k_croupier_cards[ suit .. '_' .. card ] then
					table.insert( deck, { suit = suit, card = card } )
				end

			end

		end

		for i = 1, 10 do
			math.randomseed( getTickCount(  ) ) 
			deck = randomSort( deck )
		end

		local cards = { player = {}, croupier = croupier_cards }

		for index = 1,5 do

			local card = deck[1]
			card.opened = ( index <= 2 )

			table.insert( cards.player, card )
			table.remove( deck, 1 )

		end

		for index = 1,5-#croupier_cards do

			local card = deck[1]
			card.opened = false

			table.insert( cards.croupier, card )
			table.remove( deck, 1 )

		end

		return cards

	end

---------------------------------------------

	function createBlackjackGame( marker, bet )

		if ( client:getData('casino.chips') or 0 ) < bet then
			return exports.hud_notify:notify( client, 'Ошибка', 'Недостаточно фишек' )
		end

		if bet < 10 then
			return exports.hud_notify:notify( client, 'Ошибка', 'Минимальная ставка - 10' )
		end

		if bet > 5000 then
			return exports.hud_notify:notify( client, 'Ошибка', 'Максимальная ставка - 5000' )
		end

		local blackjack = blackjackMarkers[ marker ]
		if not blackjack then return end

		local player_data = blackjack.players[client]
		if not player_data then return end

		player_data = {
			cards = generateCards(),
			bet = bet,
			marker = marker,
		}

		blackjack.players[client] = player_data

		increaseElementData( client, 'casino.chips', -bet )
		increaseElementData( client, 'casino.spent_chips', bet, false )

		exports.hud_notify:notify( client, 'Успешно', 'Ставка принята' )

		openPlayerWindow( client, 'blackjack_game' )
		triggerClientEvent( client, 'casino.receiveBlackjackGame', resourceRoot, player_data )

		exports.logs:addLog(
			'[CASINO][BLACKJACK][BET]',
			{
				data = {
					player = client.account.name,
					bet = bet,
				},	
			}
		)

	end
	addEvent('casino.createBlackjackGame', true)
	addEventHandler('casino.createBlackjackGame', resourceRoot, createBlackjackGame)

---------------------------------------------

	function openBlackjackCard( marker )

		local blackjack = blackjackMarkers[ marker ]
		if not blackjack then return end

		local player_data = blackjack.players[client]
		if not player_data then return end

		if not openCard( player_data.cards.player ) then return end

		triggerClientEvent( client, 'casino.receiveBlackjackGame', resourceRoot, player_data )

	end
	addEvent('casino.openBlackjackCard', true)
	addEventHandler('casino.openBlackjackCard', resourceRoot, openBlackjackCard)

---------------------------------------------

	function finishBlackjackGame( marker, _player )

		local player = isElement( _player ) and _player or client

		local blackjack = blackjackMarkers[ marker ]
		if not blackjack then return end

		local player_data = blackjack.players[player]
		if not player_data then return end

		if player_data.finished then return end
		player_data.finished = true

		triggerClientEvent( client, 'casino.receiveBlackjackGame', resourceRoot, player_data )

		local result = getBlackjackResult( player_data.cards )

		if result == 'win' then

			exports.hud_notify:notify( player, 'Блэкджек', ('Вы выиграли %s %s'):format(
				player_data.bet, getWordCase( player_data.bet, 'фишку', 'фишки', 'фишек' )
			) )

			increaseElementData( player, 'casino.chips', player_data.bet * 2 )

		elseif result == 'loose' then

			exports.hud_notify:notify( player, 'Блэкджек', ('Вы проиграли %s %s'):format(
				player_data.bet, getWordCase( player_data.bet, 'фишку', 'фишки', 'фишек' )
			) )

		elseif result == 'deadheat' then

			exports.hud_notify:notify( player, 'Ничья', 
				'Вы ничего не потеряли'
			)

			increaseElementData( player, 'casino.chips', player_data.bet )

		end

		setTimer(function( player, marker )

			if isElement(player) then
				openPlayerWindow( player, 'blackjack_bet', blackjackMarkers[marker] )
			end

		end, 6000, 1, client, marker)

		exports.logs:addLog(
			'[CASINO][BLACKJACK][RESULT]',
			{
				data = {

					player = client.account.name,
					bet = player_data.bet,

					result = result,

				},	
			}
		)


	end 
	addEvent('casino.finishBlackjackGame', true)
	addEventHandler('casino.finishBlackjackGame', resourceRoot, finishBlackjackGame)

---------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, coords in pairs( Config.games.blackjack.markers ) do

			local x,y,z, rz = unpack( coords )

			local marker_data = {}

			marker_data.object = createObject( 2188, x,y,z, 0, 0, rz )
			marker_data.marker = createMarker( x,y,z, 'corona', 1.7, 0, 0, 0, 0 )

			local px,py,pz = getPositionFromElementOffset( marker_data.object, -1, 0, 0 )
			local r = findRotation( px,py, x,y )

			marker_data.ped = exports.main_peds:createWorldPed({

				position = {
					coords = {px,py,pz,r},
					int = Config.casinoInterior.interior,
					dim = Config.casinoInterior.dimension,
				},

				model = math.random(60,61),

			})

			marker_data.players = {}

			for _, element in pairs( marker_data ) do

				if isElement( element ) then

					element.dimension = Config.casinoInterior.dimension
					element.interior = Config.casinoInterior.interior

				end

			end

			marker_data.marker:setData('3dtext', '[Блэкджек]')

			blackjackMarkers[marker_data.marker] = marker_data

			addEventHandler('onMarkerHit', marker_data.marker, function( player, mDim )

				if mDim and player.interior == source.interior and player.type == 'player' then

					local blackjack = blackjackMarkers[source]
					if not blackjack then return end

					if getTableLength( blackjack.players or {} ) >= Config.games.blackjack.table_limit then
						return exports.hud_notify:notify(player, 'Ошибка', 'Стол уже занят')
					end

					blackjack.players[player] = {}

					bind_openPlayerWindow( player, 'blackjack_bet', source, blackjack )


				end

			end)

			addEventHandler('onMarkerLeave', marker_data.marker, function( player, mDim )

				if mDim and player.interior == source.interior and player.type == 'player' then

					local blackjack = blackjackMarkers[source]
					if not blackjack then return end

					blackjack.players[player] = nil
					closePlayerWindow( player )

				end

			end)

		end

	end)


---------------------------------------------

	function handleBlackjackMarkerLeave()

		for marker, data in pairs( blackjackMarkers ) do

			if data.players and data.players[source] then
				data.players[source] = nil
			end

		end

	end

	addEventHandler('onPlayerQuit', root, handleBlackjackMarkerLeave)
	addEventHandler('onPlayerWasted', root, handleBlackjackMarkerLeave)

---------------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()

		for _, data in pairs( blackjackMarkers ) do

			for player, p_data in pairs( data.players or {} ) do
				if isElement(player) then
					increaseElementData( player, 'casino.chips', p_data.bet )
				end
			end

		end

	end)

---------------------------------------------

