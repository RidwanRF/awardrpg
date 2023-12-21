----------------------------------------------

	fortuneWheels = {}

----------------------------------------------

	fortuneDB = dbConnect('sqlite', ':databases/fortune_wheel.db')

----------------------------------------------

	local function updateDatabase()

		dbExec(fortuneDB, 'CREATE TABLE IF NOT EXISTS steps(steps TEXT);')
		local result = dbPoll(dbQuery(fortuneDB, 'SELECT * FROM steps;'), -1)

		if not (result and result[1]) then
			dbExec(fortuneDB, 'INSERT INTO steps(steps) VALUES (\'[ [ ] ]\');')
		end 

	end
	addEventHandler('onResourceStart', resourceRoot, updateDatabase)

	function increasePackStep( wheel_type )

		local query = dbPoll( dbQuery(fortuneDB, 'SELECT * FROM steps' ), -1)
		local array = fromJSON( query[1]['steps'], true )

		array[wheel_type] = ( array[wheel_type] or 1 ) + 1

		dbExec( fortuneDB, string.format('UPDATE steps SET steps=\'%s\';', toJSON(array)) )

	end

	function getPackStep( wheel_type )

		local query = dbPoll( dbQuery(fortuneDB, 'SELECT * FROM steps;'), -1 )
		local array = fromJSON(query[1]['steps'], true)

		return array[wheel_type] or 1

	end

----------------------------------------------

	function getFortunePrize( player, wheel_type )

		increasePackStep( wheel_type )

		local step = getPackStep( wheel_type )

		local top_step = Config.games.fortune.prizes.top_step[wheel_type]
		local items = Config.games.fortune.prizes[ wheel_type ]

		local isTopPrize = (step % top_step) == 0

		local prizes = {}

		for index, item in pairs(items) do

			item.index = index

			if (item.top and isTopPrize) or (not item.top and not isTopPrize) then

				for i = 1, item.chance do
					table.insert(prizes, item)
				end

			end

		end

		prizes = randomSort(prizes)

		local item = prizes[math.random(#prizes)]
		local itemId = item.index

		return itemId, isTopPrize, step, item

	end

----------------------------------------------

	local prize_types = {

		vehicle = function( player, data )
			exports.car_system:addBase(player, 412)
		end,

		chips = function( player, data )
			exports.bank:givePlayerBankMoney(player, data.amount, "DONATE")
		end,

		skin = function( player, data )

			local wardrobe = player:getData('wardrobe') or {}

			if not wardrobe[ data.model ] then

				exports.main_clothes:addWardrobeClothes( localPlayer, data.model )

			elseif type(data.alt_cost) == 'table' then

				increaseElementData( client, data.alt_cost.valute, data.alt_cost.amount )

			end

		end,

		pack = function( player, data )
			exports.main_freeroam:givePlayerPack( player, data.pack, data.amount )
		end,

		money = function( player, data )
			exports.bank:givePlayerBankMoney(player, data.amount, "RUB")
		end,

		vip = function( player, data )
			exports.vip:givePlayerVIP(player, data.amount)
		end,

		prison_ticket = function( player, data )
			increaseElementData( player, 'prison.tickets', data.amount )
		end,

		ban = function( player, data )
			exports.chat_main:displayInfo(
				player, '[КАЗИНО] В этот раз мы не дадим вам бан, но в следующий раз будьте бдительны...', { 255,0,0 }
			 )
		end,

	}

	function giveFortunePrize( player, data )

		local func = prize_types[ data.type ]
		func( player, data )

	end

----------------------------------------------

	function rollFortuneWheel_check( marker )

		if not isElementWithinMarker( client, marker ) then
			return
		end

		for marker, f_wheel in pairs( fortuneWheels ) do

			if f_wheel and f_wheel.roll and f_wheel.roll.player == client then
				--return exports.hud_notify:notify(client, 'Ошибка', 'Вы уже крутите колесо')
				return 	exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Вы уже крутите колесо", getTickCount(), 8000)
			end

		end

		local wheel = fortuneWheels[marker]
		if not wheel then return end

		if wheel.roll then
			return exports.hud_notify:notify(client, 'Ошибка', 'Игра занята')
		end

		local cost, valute

		if wheel.type == 'vip' then
			cost, valute = 1, 'casino.vip_tickets'
		else

			cost, valute = Config.games.fortune.default_cost, 'casino.chips'

			if (client:getData('casino.default_tickets') or 0) > 0 then
				cost, valute = 1, 'casino.default_tickets'
			end 

		end
		if exports.bank:getPlayerBankMoney(client, "DONATE") <= 50 then
		--	return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно средств')
			return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "У вас недостаточно фишек", getTickCount(), 8000)
		end

		triggerClientEvent(client, 'casino.rollFortuneWheel_callback', resourceRoot)
		return true

	end
	addEvent('casino.rollFortuneWheel_check', true)
	addEventHandler('casino.rollFortuneWheel_check', resourceRoot, rollFortuneWheel_check)

	function rollFortuneWheel( marker )

		if not isElementWithinMarker( client, marker ) then
			return
		end

		for marker, f_wheel in pairs( fortuneWheels ) do

			if f_wheel and f_wheel.roll and f_wheel.roll.player == client then
			--	return exports.hud_notify:notify(client, 'Ошибка', 'Вы уже крутите колесо')
				return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Вы уже крутите колесо", getTickCount(), 8000)
			end

		end

		local wheel = fortuneWheels[marker]
		if not wheel then return end

		if wheel.roll then
		--	return exports.hud_notify:notify(client, 'Ошибка', 'Игра занята')
			return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "Игра занята!", getTickCount(), 8000)
		end

		local cost, valute

		if wheel.type == 'vip' then
			cost, valute = 1, 'casino.vip_tickets'
		else

			cost, valute = Config.games.fortune.default_cost, 'casino.chips'

			if (client:getData('casino.default_tickets') or 0) > 0 then
				cost, valute = 1, 'casino.default_tickets'
			end 

		end

		if exports.bank:getPlayerBankMoney(client, "DONATE") <= 50 then
		--	return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно средств')
		exports.aw_interface_notify:showInfobox(client, "info", "Казино", "У вас недостаточно фишек", getTickCount(), 8000)
			--return exports.aw_interface_notify:showInfobox(client, "info", "Казино", "У вас недостаточно фишек", getTickCount(), 8000)
		end

		--increaseElementData(client, valute, -cost)
		exports.bank:takePlayerBankMoney(client, 50, "DONATE")

		if valute == 'casino.chips' then
			increaseElementData(client, 'casino.spent_chips', cost, false)
		end

		local item_id, isTopPrize, step, prize_item = getFortunePrize( client, wheel.type )

		local roll = {
			player = client,
			prize = item_id,
		}

		roll.timer = setTimer(finishFortuneRoll, 15000, 1, marker)


		local rotation = wheel.rotation
		local step = 360/16

		local t_rotation = - ( (roll.prize - wheel.current_prize) * step + 360*3 )

		local x,y,z = getElementPosition( wheel.wheel )
		local rx,ry,rz = getElementRotation( wheel.wheel )

		roll.rotation = rotation + t_rotation
		moveObject( wheel.wheel, 15000, x,y,z, 0, t_rotation, 0, 'InOutQuad' )

		wheel.roll = roll

		--exports.logs:addLog('[CASINO][FORTUNE]',{data = {player = client.account.name,cost = cost,valute = valute,type = wheel.type,prize_id = roll.prize,prize = prize_item,step = step,is_top = isTopPrize,},	})
		exports.aw_server_logs:log("CASINO-FORTUNE", {data = {player = client.account.name,cost = cost,valute = valute,type = wheel.type,prize_id = roll.prize,prize = prize_item,step = step,is_top = isTopPrize,},})

	end
	addEvent('casino.rollFortuneWheel', true)
	addEventHandler('casino.rollFortuneWheel', resourceRoot, rollFortuneWheel)

----------------------------------------------

	function finishFortuneRoll( marker )

		local wheel = fortuneWheels[ marker ]

		if not wheel then return end
		if not wheel.roll then return end

		if isElement( wheel.roll.player ) then

			local prize_config = Config.games.fortune.prizes[ wheel.type ][ wheel.roll.prize ]

			giveFortunePrize( wheel.roll.player, prize_config.data )

			--exports.hud_notify:notify( wheel.roll.player, 'Колесо фортуны', 'Приз - ' .. prize_config.name )
			exports.aw_interface_notify:showInfobox(wheel.roll.player, "info", "Казино", "Поздравляем! ваш приз — " .. prize_config.name, getTickCount(), 8000)

		end

		wheel.rotation = wheel.roll.rotation
		wheel.current_prize = wheel.roll.prize

		clearTableElements( wheel.roll or {} )
		wheel.roll = nil

	end

----------------------------------------------

	function finishPlayerRoll( _player )

		local player = _player or source

		for marker, wheel in pairs( fortuneWheels ) do
			if wheel.roll and wheel.roll.player == player then
				return finishFortuneRoll( marker )
			end
		end

	end

----------------------------------------------

	addEventHandler('onPlayerQuit', root, finishPlayerRoll)
	addEventHandler('onPlayerWasted', root, finishPlayerRoll)

----------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, marker_data in pairs( Config.games.fortune.markers ) do

			local x,y,z,rz = unpack( marker_data )

			local marker = createMarker( x,y,z, 'corona', 4, 0, 0, 0, 0 )
			local wheel = {}

			wheel.base = createObject( 3016, 2260.1999511719, 1632.4000244141, 1023.299987793, 0, 0, 270.61218261719 )
			wheel.wheel = createObject( 3017, 2260.1999511719,1632.4000244141,1023.299987793, 0, 0, 270 )
			wheel.marker = marker

			wheel.rotation = 0
			wheel.current_prize = 1

			wheel.type = marker_data.type

			fortuneWheels[marker] = wheel

			for _, element in pairs( wheel ) do

				if isElement(element) then
					element.dimension = Config.casinoInterior.dimension
					element.interior = Config.casinoInterior.interior
				end

			end

			addEventHandler('onMarkerHit', marker, function( player, mDim )

				if mDim and player.interior == source.interior then
					triggerClientEvent(player, 'casino.toggleFortuneWheel', resourceRoot, wheel, true)
				end

			end)

			addEventHandler('onMarkerLeave', marker, function( player, mDim )

				if mDim and player.interior == source.interior then
					triggerClientEvent(player, 'casino.toggleFortuneWheel', resourceRoot, wheel, false)
				end

			end)

		end

	end)

----------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		local config = Config.games.fortune.vehicle
		local x,y,z, rz = unpack( config )

		local vehicle = createVehicle(412, 2205,1641.7998,1021.9, 0, 0, -22.352)
		setVehicleColor(vehicle, 255, 0, 0)
        setVehicleHandling(vehicle, "suspensionLowerLimit", -0.02)
		vehicle.dimension = Config.casinoInterior.dimension
		vehicle.interior = Config.casinoInterior.interior

		vehicle.frozen = true

		addEventHandler('onVehicleStartEnter', vehicle, function() cancelEvent() end)

	end)

----------------------------------------------