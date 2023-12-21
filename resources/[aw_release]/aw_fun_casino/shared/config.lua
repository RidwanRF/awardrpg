Config = {}

Config.casinoInterior = {

	position = { 0, 0, 1000 },

	dimension = 1,
	interior = 0,

	exit = { 2017.95, 1017.92, 996.88 },
	exit_player = { 2026.47, 1007.68, 1000.82 },

	enter = { 2193.0712890625,1677.0485839844,9912.3671875 },
	enter_player = { 2008.65, 1017.63, 90094.47 },
	-- enter_player = { 0.04, -43.3, 1001.42 },

	exchange = { 0.34, 15.62, 3.47 },
	-- exchange = { -0.02, -35.85, 1001.01 },

}

Config.exchange = {
	
	chips = {

		buy = 100,
		sell = 90,

		valute = 'money',

	},

	vip_tickets = {
		buy = 99,
		valute = 'bank.donate',
	},

}

function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end
