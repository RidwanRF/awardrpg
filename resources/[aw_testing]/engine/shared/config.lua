
Config = {}

Config.headerLength = 402
Config.footerLength = 99


Config.models = {

	cars = {

		default = true,

		models = {
		
		},

	},
	
	wheels = {

		default = true,

		models = {
			
		},

	},
	
	objects = {

		default = true,

		models = {

		},

	},

	characters = {

		default = true,

		models = {

		},

	},

	weapons = {

		default = true,

		models = {

		},

	},

	casino = {

		default = true,

		models = {

			[3018] = { path = 'casino/slots' },
			[3019] = { path = 'casino/table' },

			[3020] = { path = 'casino/bones_cube' },

			[3025] = { path = 'casino/roulette_ball', txd = ':engine/assets/models/casino/roulette' },
			[3026] = { path = 'casino/roulette_base', txd = ':engine/assets/models/casino/roulette' },
			[1134] = { path = 'casino/roulette_wheel', txd = ':engine/assets/models/casino/roulette' },
			[3024] = { path = 'casino/roulette_chip', txd = ':engine/assets/models/casino/roulette' },
			[2188] = { path = 'casino/blackjack' },

			[3016] = { path = 'casino/fortune_base', txd = ':engine/assets/models/casino/fortune' },
			[3017] = { path = 'casino/fortune_wheel', txd = ':engine/assets/models/casino/fortune' },

			[60] = { path = 'casino/croupier_1' },
			[61] = { path = 'casino/croupier_2' },

		},

	},

}

function getConfigSetting(name)
	return Config[name]
end