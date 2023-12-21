

----------------------------------------

	function getBonesSum( throw_session )

		local sum = {}

		for _, throw in pairs( throw_session ) do
			sum[throw.player] = (sum[throw.player] or 0) + (throw.amount[1] + throw.amount[2])
		end

		return sum

	end

----------------------------------------

	local card_values = { j = 2, q = 3, k = 4 }

	function getBlackjackCardsSum( cards )

		local sum = 0

		local aces = 0

		for _, card in pairs( cards ) do

			if card.opened then

				local card_value = tonumber(card.card) or card_values[card.card]

				if card_value then
					sum = sum + card_value
				elseif card.card == 'a' then
					aces = aces + 1
				end

			end

		end

		if aces > 0 then

			local variants = {}

			if aces == 1 then variants = { 1, 11 } end
			if aces == 2 then variants = { 2, 12 } end
			if aces == 3 then variants = { 3, 13 } end
			if aces == 4 then variants = { 4, 14 } end

			local sum_1 = sum + variants[1]
			local sum_2 = sum + variants[2]

			if sum_1 <= 21 then

				if sum_2 <= 21 then 

					sum = sum_2

				else

					sum = sum_1

				end

			else

				sum = sum_1

			end

		end

		return sum

	end

----------------------------------------

	function getBlackjackResult( cards )

		local player_sum, croupier_sum =
			getBlackjackCardsSum( cards.player ),
			getBlackjackCardsSum( cards.croupier )

		local result = player_sum == croupier_sum and 'deadheat' or ( player_sum > croupier_sum and 'win' or 'loose' )

		if player_sum > 21 then  result = 'loose'
			if croupier_sum > 21 then result = 'deadheat' end
		end

		if croupier_sum > 21 then  result = 'win'
			if player_sum > 21 then result = 'deadheat' end
		end

		return result

	end

----------------------------------------

	function getRussianActivePlayer( game )

		for player, data in pairs( game.players or {} ) do

			if data.index == game.active_player then
				return player
			end

		end

	end

----------------------------------------