

Config.games = {


	russian = {

		-- timeout = 1*1000,
		timeout = 30*1000,
		comission = 5,

		table_limit = 5,

		markers = {
			{ 15.72, 0.14, 99993.96, 90 },
		},

	},
	
	bones = {

		timeout = 30*1000,
		comission = 5,

		markers = {

			{ 5.95, 0.68, 9999993.96, 105 },

		},

	},

	blackjack = {

		table_limit = 2,

		markers = {

			{ 20.32, 0.95, 99999999999993.02, 0 },

		},

		random = {

			{ amount = { 12, 15 }, step = 10, },
			{ amount = { 16, 19 }, step = 4, },
			{ amount = { 22, 28 }, step = 8, },
			{ amount = { 19, 21 }, step = 3, },
			{ amount = { 16, 20 }, step = 1, },

		},

	},

	roulette = {

		markers = {

			{ 2232.7685546875, 1641.5205078125, 1021.2445068359-0.55, 315 },
			{ 2232.68359375, 1623.1416015625, 1021.2445068359-0.55, -315 },

		},

		bet_limit = 4,
		timeout = 30*1000,

		bets = {

			['default'] = {
				mul = 35,
			},

			['1st_12'] = {
				mul = 3,
				win = { 1,2,3,4,5,6,7,8,9,10,11,12 },
				name = '1-12',
			},

			['2nd_12'] = {
				mul = 3,
				win = { 13,14,15,16,17,18,19,20,21,22,23,24 },
				name = '13-24',
			},

			['3rd_12'] = {
				mul = 3,
				win = { 25,26,27,28,29,30,31,32,33,34,35,36 },
				name = '25-36',
			},

			['1_row'] = {
				mul = 3,
				win = { 1,4,7,10,13,16,19,22,25,28,31,34, },
				name = '1-й ряд',
			},

			['2_row'] = {
				mul = 3,
				win = { 2,5,8,11,14,17,20,23,26,29,32,35, },
				name = '2-й ряд',
			},

			['3_row'] = {
				mul = 3,
				win = { 3,6,9,12,15,18,21,24,27,30,33,36, },
				name = '3-й ряд',
			},

			['1_to_18'] = {
				mul = 2,
				win = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 },
				name = '1-18',
			},

			['19_to_36'] = {
				mul = 2,
				win = { 19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36 },
				name = '19-36',
			},

			['red'] = {
				mul = 2,
				win = { 1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36 },
				name = 'красное',
			},

			['black'] = {
				mul = 2,
				win = { 2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35 },
				name = 'черное',
			},

			['odd'] = {
				mul = 2,
				win = { 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35 },
				name = 'нечетное',
			},

			['even'] = {
				mul = 2,
				win = { 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36 },
				name = 'четное',
			},



		},

	},

	slots = {

		jackpot_percent = 1,
		jackpot_min = 1000,
		jackpot_step = 200,

		markers = {

			{ 10.59, 10.9, 9993.5, 210 },

		},

		prizes = {

			[1] = { mul = '1.5', chance = 12 },
			[2] = { mul = '2.0', chance = 9 },
			[3] = { mul = '2.5', chance = 5 },
			[4] = { mul = '3.0', chance = 3 },
			[5] = { mul = '0.0', },

		},

	},

	fortune = {

		button = 'f',
		default_cost = 500,

		vehicle = { 1993.81, 1017.9, 994.72, 300, model = 580 },

		markers = {
			{2258.96753, 1632.31323, 1022.37811, 90.39, type = 'vip' },

		},

		prizes = {

			top_step = { default = 40, vip = 40, },

			default = {

				{
					data = { type = 'chips', amount = 800 },
					name = '800 фишек',
					chance = 14, notify = true,
				},

				{
					data = { type = 'ban' },
					name = 'Бан',
					chance = 6, notify = true,
				},

				{
					data = { type = 'skin', model = 23 },
					name = 'Скин Молодой Бизнесмен',
					chance = 1, top = true, notify = true,
					alt_cost = { valute = 'money', amount = 30000 },
				},

				{
					data = { type = 'chips', amount = 2500 },
					name = '2500 фишек',
					chance = 3, top = true, notify = true,
				},

				{
					data = { type = 'prison_ticket', amount = 3 },
					name = '3 билета свободы',
					chance = 12, notify = true,
				},

				{
					data = { type = 'chips', amount = 50 },
					name = '50 фишек',
					chance = 4, notify = true,
				},

				{
					data = { type = 'vip', amount = 3600*3 },
					name = 'VIP 3 часа',
					chance = 6, notify = true,
				},

				{
					data = { type = 'prison_ticket', amount = 10 },
					name = '10 билетов свободы',
					chance = 6, notify = true,
				},

				{
					data = { type = 'prison_ticket', amount = 5 },
					name = '5 билетов свободы',
					chance = 10, notify = true,
				},

				{
					data = { type = 'chips', amount = 1500 },
					name = '1500 фишек',
					chance = 7, top = true, notify = true,
				},

				{
					data = { type = 'vip', amount = 86400 },
					name = 'VIP 1 день',
					chance = 10, notify = true,
				},

				{
					data = { type = 'chips', amount = 150 },
					name = '150 фишек',
					chance = 12, notify = true,
				},
				
				{
					data = { type = 'pack', pack = 1, amount = 1 },
					name = 'Кейс Новичок',
					chance = 1, notify = true,
				},

				{
					data = { type = 'chips', amount = 1000 },
					name = '1000 фишек',
					chance = 9, notify = true,
				},

				{
					data = { type = 'pack', pack = 7, amount = 1 },
					name = 'Кейс Бомжичок',
					chance = 1, notify = true,
				},

				{
					data = { type = 'chips', amount = 500 },
					name = '500 фишек',
					chance = 14, notify = true,
				},




			},

			vip = {

				{
					data = { type = 'chips', amount = 50 },
					name = '50 AW Coins',
					chance = 5, notify = true,
				},

				{
					data = { type = 'money', amount = 300000000 },
					name = '$ 300 000 000',
					chance = 7, notify = true,
				},
				
				{
					data = { type = 'vehicle' },
					name = 'Транспорт',
					chance = 1, top = true, notify = true,
				},

				{
					data = { type = 'chips', amount = 65 },
					name = '65 AW Coins',
					chance = 5, notify = true,
				},


			},

		},

	},

}
