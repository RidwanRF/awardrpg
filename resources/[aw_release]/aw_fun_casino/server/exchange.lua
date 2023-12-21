

----------------------------------------------------------------------

	function handleExchange( valute, trade_mode, amount )

		local config = Config.exchange[valute]
		if not config then return end

		local trade_course = config[trade_mode]
		if not trade_course then return end

		local cost = (amount * trade_course)

		if trade_mode == 'buy' then

			if ( client:getData( config.valute ) or 0 ) < cost then
			--	return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно средств')
			end

		--	increaseElementData( client, config.valute, -cost )
			takePlayerMoney(client, config.valute, -cost)
			increaseElementData( client, 'casino.'..valute, amount )

		--	exports.logs:addLog('[CASINO][BUY]',{data = {player = client.account.name,valute = valute,amount = amount,cost = cost,},	})

		elseif trade_mode == 'sell' then

			if ( client:getData( 'casino.'..valute ) or 0 ) < amount then
		--		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно средств')
			end

			increaseElementData( client, 'casino.'..valute, -amount )
			increaseElementData( client, config.valute, cost )

		--	exports.logs:addLog('[CASINO][SELL]',{data = {player = client.account.name,valute = valute,amount = amount,cost = cost,},	})

		end

	--	exports.hud_notify:notify(client, 'Успешно', 'Вы совершили обмен')

	end
	addEvent('casino.exchange', true)
	addEventHandler('casino.exchange', resourceRoot, handleExchange)

----------------------------------------------------------------------