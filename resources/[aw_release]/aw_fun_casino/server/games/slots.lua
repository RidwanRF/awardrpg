

------------------------------------------------------------------------

	casinoSlots = {}
	slotCombinations = {}

	resourceRoot:setData('slots.jackpot', 0)

------------------------------------------------------------------------

	function generatePlayerCombination( player, bet )

		local chances = {}

		local loose = 100

		for index, config in pairs( Config.games.slots.prizes ) do

			if config.chance then

				for i = 1, config.chance do
					table.insert( chances, index )
				end

				loose = loose - config.chance

			end

		end

		for i = 1, loose do
			table.insert( chances, -1 )
		end


		for i = 1, 10 do
			math.randomseed( getTickCount(  ) + math.random(500) )
			chances = randomSort( chances )
		end

		local result = chances[1]

		if result == -1 then

			local cmb = { math.random(5), math.random(5), math.random(5) }

			while ( cmb[1] == cmb[2] and cmb[1] == cmb[3] ) do
				cmb = { math.random(5), math.random(5), math.random(5) }
			end

			return cmb

		else
			return { result, result, result }
		end

	end

------------------------------------------------------------------------

	function getRepeatingNumbers( combination )

		if (combination[1] == combination[2]) and (combination[1] == combination[3]) then
			return combination[1]
		end

		return false

	end

------------------------------------------------------------------------

	function rollSlots( bet )

		local chips = client:getData('casino.chips') or 0

		if chips < bet then
			return exports.hud_notify:notify( client, 'Ошибка', 'Недостаточно фишек' )
		end

		if bet > 3000 then
			return exports.hud_notify:notify( client, 'Ошибка', 'Слишком большая ставка' )
		end

		if slotCombinations[client] then return end

		increaseElementData( client, 'casino.chips', -bet )

		local jackpot_sum = resourceRoot:getData('slots.jackpot') or 0
		jackpot_sum = jackpot_sum + math.ceil(bet * Config.games.slots.jackpot_percent/100)
		resourceRoot:setData('slots.jackpot', jackpot_sum)

		if jackpot_sum >= Config.games.slots.jackpot_min and not jackpot_step then
			jackpot_step = Config.games.slots.jackpot_step
		end

		local combination

		if jackpot_step and jackpot_step <= 0 then

			jackpot_step = nil
			combination = { 5,5,5 }

		else

			if jackpot_step then
				jackpot_step = jackpot_step - 1
			end

		 	combination = generatePlayerCombination( client )

		end

		triggerClientEvent( client, 'casino.showSlotsCombination', resourceRoot, combination )

		slotCombinations[client] = { bet = bet, combination = combination }

		exports.logs:addLog(
			'[CASINO][SLOTS][COMB]',
			{
				data = {

					player = client.account.name,
					combination = combination,
					bet = bet,

				},	
			}
		)

	end
	addEvent('casino.rollSlots', true)
	addEventHandler('casino.rollSlots', resourceRoot, rollSlots)

------------------------------------------------------------------------

	function giveCombinationPrize( _player )

		local player = _player or client

		local combination = slotCombinations[player]
		if not combination then return end

		local repeating = getRepeatingNumbers( combination.combination )
		local win = 0

		if repeating then

			if repeating == 5 then

				local jackpot = resourceRoot:getData('slots.jackpot') or 0
				win = jackpot

				exports.hud_notify:notify(player, 'Джекпот!', ('Вы выиграли %s %s'):format(
					splitWithPoints( jackpot, '.' ), getWordCase( jackpot, 'фишку', 'фишки', 'фишек' )
				))

				resourceRoot:setData('slots.jackpot', 0)

			else

				local prize_data = Config.games.slots.prizes[ repeating ]
				local mul = tonumber( prize_data.mul ) or 1

				win = math.floor(combination.bet * mul)

				exports.hud_notify:notify(player, 'Слот-машина', ('Вы выиграли %s %s'):format(
					splitWithPoints( win, '.' ), getWordCase( win, 'фишку', 'фишки', 'фишек' )
				))

			end

		else

			exports.hud_notify:notify(player, 'Слот-машина', 'Вы ничего не выиграли')

		end

		if win > 0 then
			increaseElementData( player, 'casino.chips', win )
		end

		slotCombinations[player] = nil

		exports.logs:addLog(
			'[CASINO][SLOTS][PRIZE]',
			{
				data = {

					player = player.account.name,
					combination = combination.combination,
					bet = combination.bet,

					win = win,
					repeating = repeating,

				},	
			}
		)

	end
	addEvent('casino.slots_giveCombinationPrize', true)
	addEventHandler('casino.slots_giveCombinationPrize', resourceRoot, giveCombinationPrize)

	------------------------------------------

		addEventHandler('onPlayerQuit', root, function()

			if slotCombinations[source] then
				giveCombinationPrize( source )
			end

		end)

		addEventHandler('onPlayerWasted', root, function()

			if slotCombinations[source] then
				giveCombinationPrize( source )
			end

		end)

		addEventHandler('onResourceStop', resourceRoot, function()

			for player in pairs( slotCombinations ) do
				giveCombinationPrize( player )
			end

		end)

	------------------------------------------

------------------------------------------------------------------------

	function slots_isMarkerFree( marker )

		for player, b_marker in pairs( casinoSlots ) do

			if b_marker == marker then
				return false
			end

		end

		return true

	end

	function slots_busyPlayerMarker( player, marker )
		casinoSlots[ player ] = marker
	end

	function slots_freePlayerMarker( player )
		casinoSlots[ player ] = nil
	end

------------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, coords in pairs( Config.games.slots.markers ) do

			local x,y,z, rz = unpack( coords )
			-- z = z + 1

			local object = createObject( 3018, x,y,z, 0, 0, rz )
			local marker = createMarker( x,y,z, 'corona', 1.5, 0, 0, 0, 0 )

			object.dimension = Config.casinoInterior.dimension
			object.interior = Config.casinoInterior.interior

			marker.dimension = Config.casinoInterior.dimension
			marker.interior = Config.casinoInterior.interior

			marker.parent = object

			marker:setData('3dtext', '[Слот-машина]')

			addEventHandler('onMarkerHit', marker, function( player, mDim )

				if mDim and player.interior == source.interior and player.type == 'player' then

					if not slots_isMarkerFree( source ) then
						return exports.hud_notify:notify( player, 'Ошибка', 'Эта игра уже занята' )
					end

					if isElement( casinoSlots[ player ] ) and casinoSlots[ player ] ~= source then
						return
					end

					slots_busyPlayerMarker( player, source )
					bind_openPlayerWindow( player, 'slots', source,source, source.parent )

				end

			end)

			addEventHandler('onMarkerLeave', marker, function( player, mDim )

				if mDim and player.interior == source.interior and player.type == 'player' then

					if casinoSlots[ player ] == source then
						slots_freePlayerMarker( player )
						closePlayerWindow( player )
					end

				end

			end)

		end

	end)

------------------------------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()

		if casinoSlots[source] then
			slots_freePlayerMarker( source )
		end

	end)

------------------------------------------------------------------------
