--------------------------
-- Конфигурация ресурса --
--------------------------

Config = {}
-- Включить режим отладки, добавляющий окно редактора тюнинга
Config.debugEnabled = false
-- Хоткей для открытия окна редактора тюнинга
Config.debugHotkey  = "n"
-- Угол максимального открывания капота
Config.bonnetOpenAngle = 54
-- Угол максимального открывания багажника
Config.trunkOpenAngle = -54
-- Угол максимального открывания двери
Config.doorOpenAngle   = 72
-- Максимальное количество компонентов на автомобиле
Config.maxComponentsCount = 40
-- Минимальная скорость для открытия спойлера
Config.minSpoilerSpeed = 75

Config.overrideAngles = {
    [404] = {	-- ВАЗ 2107
        bonnetOpenAngle = -Config.bonnetOpenAngle
    },
    [534] = {	-- Dodge Viper
        bonnetOpenAngle = -Config.bonnetOpenAngle
    },
    [526] = {   -- McLaren SLR C199
        bonnetOpenAngle = -50
    },
    [429] = {   -- f150
        trunkOpenAngle  = 90,
        bonnetOpenAngle = 60,
    },
    [567] = {	-- Lexus LX570
        trunkOpenAngle = 85,
        spoilerOpenAngle = -54,
    },
    [602] = {	-- BMW M2 F87
        trunkOpenAngle = -80,
    },
}

-- Автомобили, на которых запрещено открывание спойлера вместе с багажником
-- Также указать таблицу, содержащую только те спойлеры, которые не должны открываться (см. пример)
Config.disableTrunkSpoiler = {
	[494] = {
		[2] = true,
		[3] = true,
	},
    [470] = true,
    [542] = true,
    [422] = true, 
}

-- Кастомные углы открытия дверей авто
Config.customDoorAngles = {
    -- McLaren SLR C199
    [526] = {70, -42, 64},
    -- Ford Transit
    [499] = {0, 0, 65},
}

-- Кастомные углы открытия багажника авто
Config.customTrunkAngle = {
    -- Mercedes-Benz G65 AMG
    [470] = {x=2, y=-0.4, z=-94},
    -- Mercedes-Benz G63 AMG
    [426] = {x=2, y=-0.4, z=-94},
}

Config.xenonColors = {
    { name="3200K", price=30000, color={255, 254, 205 }},
    { name="4000K", price=30000, color={229, 230, 255 }},
    { name="4300K", price=30000, color={183, 186, 255 }},
    { name="5000K", price=30000, color={145, 150, 255 }},
    { name="6000K", price=30000, color={105, 112, 255 }},
    { name="7500K", price=30000, color={63, 72, 255 }},
    { name="Красный #1", price=50000, color={150, 2, 2 }},
    { name="Красный #2", price=50000, color={190, 2, 2 }},
    { name="Красный #3", price=50000, color={230, 3, 3 }},
    { name="Фиолетовый #1", price=70000, color={128, 0, 128 }},
    { name="Фиолетовый #2", price=70000, color={168, 0, 128 }},
    { name="Фиолетовый #3", price=70000, color={208, 0, 128 }},
    { name="Зелёный #1", price=90000, color={0, 128, 0 }},
    { name="Зелёный #2", price=90000, color={0, 168, 0 }},
    { name="Зелёный #3", price=90000, color={0, 208, 0 }},
    { name="Розовый #1", price=110000, color={175, 0, 255 }},
    { name="Розовый #2", price=110000, color={215, 0, 255 }},
    { name="Розовый #3", price=110000, color={255, 0, 255 }},
    { name="Золотой #1", price=130000, color={158, 165, 32 }},
    { name="Золотой #2", price=130000, color={188, 165, 32 }},
    { name="Золотой #3", price=130000, color={218, 165, 32 }},
    { name="Бирюзовый #1", price=150000, color={0, 255, 175 }},
    { name="Бирюзовый #2", price=150000, color={0, 255, 215 }},
    { name="Бирюзовый #3", price=150000, color={0, 255, 255 }},
    { name="Лаймовый #1", price=170000, color={80, 255, 0 }},
    { name="Лаймовый #2", price=170000, color={40, 255, 0 }},
    { name="Лаймовый #3", price=170000, color={0, 255, 0 }},
    { name="Stock/White", price=500000, color={255, 255, 255 }},
	{ name="Red", price=500000, color={255, 0, 0 }},
	{ name="Green", price=500000, color={0, 255, 0 }},
	{ name="Blue", price=500000, color={0, 0, 255 }},
	{ name="DarkRed", price=500000, color={140, 0, 0 }},
	{ name="DarkGreen", price=500000, color={0, 140, 0 }},
	{ name="DarkBlue", price=500000, color={0, 0, 140 }},
	{ name="Purple", price=500000, color={128, 0, 128 }},
	{ name="Indigo", price=500000, color={75, 0, 130 }},
	{ name="Yellow", price=500000, color={255, 255, 0 }},
}

Config.defaultWindowBindings = {
  {
    key = "num_7",
    name = "Поднять левое стекло",
    window = "window_lf",
    direction = -1
  },
  {
    key = "num_1",
    name = "Опустить левое стекло",
    window = "window_lf",
    direction = 1
  },
  {
    key = "num_9",
    name = "Поднять правое стекло",
    window = "window_rf",
    direction = -1
  },
  {
    key = "num_3",
    name = "Опустить правое стекло",
    window = "window_rf",
    direction = 1
  }
}

Config.defaultWindowsOffset = {
  x = 0,
  y = 0.1,
  z = -0.46,
  rx = 0,
  ry = 15,
  rz = 0
}

Config.overrideWindowsOffets = {
  [400] = {
    up = {
      -0.963,
      1.053,
      0.117,
      0,
      0,
      0
    },
    down = {
      -1.036,
      1.187,
      -0.352,
      0,
      356,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [401] = {
    up = {
      -0.913,
      0.754,
      -0.094,
      0,
      0,
      0
    },
    down = {
      -0.913,
      0.759,
      -0.554,
      0,
      -5,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [587] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [402] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [410] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [422] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [526] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [542] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [600] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [413] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [414] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [416] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [431] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [437] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [440] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [403] = {
    up = {
      -1.195,
      3.615,
      0.11,
      0,
      0,
      0
    },
    down = {
      -1.195,
      3.615,
      -0.42,
      0,
      -2.5,
      1
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [404] = {
    up = {
      -0.883,
      1.009,
      -0.154,
      0,
      0,
      0
    },
    down = {
      -0.89,
      1.014,
      -0.562,
      0,
      353.001,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [405] = {
    up = {
      -0.936,
      1.014,
      0.189,
      0,
      0,
      0
    },
    down = {
      -0.991,
      1.137,
      -0.262,
      0,
      350,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [409] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [412] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [411] = {
    up = {
      -0.985,
      0.419,
      -0.091,
      0,
      0,
      0
    },
    down = {
      -0.925,
      0.589,
      -0.461,
      0,
      -22,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [415] = {
    up = {
      -0.98,
      0.829,
      -0.325,
      0,
      0,
      0
    },
    down = {
      -0.98,
      0.929,
      -0.725,
      0,
      -15,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [418] = {
    up = {
      -0.993,
      1.249,
      0.116,
      0,
      0,
      0
    },
	
    down = {
      -0.993,
      1.349,
      -0.328,
      0,
      -15,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [419] = {
    up = {
      -0.844,
      0.783,
      -0.124,
      0,
      0,
      0
    },
    down = {
      -0.734,
      0.808,
      -0.594,
      0,
      -25,
      0.85
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [420] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [421] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [426] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [436] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [442] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [429] = {
    up = {
      -0.929,
      1.059,
      -0.01,
      0,
      0,
      0
    },
    down = {
      -0.879,
      1.149,
      -0.53,
      0,
      -20,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [438] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [439] = {
    up = {
      -0.938,
      0.952,
      -0.113,
      0,
      0,
      0
    },
    down = {
      -0.999,
      1.032,
      -0.503,
      0,
      -8,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [503] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [504] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [445] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [459] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [482] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [456] = {
    up = {
      -0.993,
      -0.515,
      -0.032,
      0,
      0,
      0
    },
    down = {
      -1.013,
      -0.415,
      -0.452,
      0,
      -13,
      -1.5
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [458] = {
    up = {
      -0.981,
      1.004,
      -0.103,
      0,
      0,
      0
    },
    down = {
      -1.005,
      1.184,
      -0.573,
      0,
      -15,
      2
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [466] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [467] = {
    up = {
      -0.971,
      1.111,
      0.124,
      0,
      0,
      0
    },
    down = {
      -1.051,
      1.221,
      -0.306,
      0,
      -4,
      -1.1
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [470] = {
    up = {
      -0.945,
      0.869,
      -0.13,
      0,
      0,
      0
    },
    down = {
      -0.982,
      0.869,
      -0.682,
      0,
      0,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [474] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [475] = {
    up = {
      -0.855,
      0.863,
      -0.595,
      0,
      0,
      0
    },
    down = {
      -0.825,
      1.013,
      -1.11,
      0,
      -20,
      -1
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [477] = {
    up = {
      -0.921,
      0.557,
      0.001,
      0,
      0,
      0
    },
    down = {
      -1.018,
      0.634,
      -0.357,
      0,
      357.5,
      358.002
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [478] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [479] = {
    up = {
      -0.926,
      1,
      -0.201,
      0,
      0,
      0
    },
    down = {
      -0.926,
      1.16,
      -0.661,
      0,
      -15,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [480] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [489] = {
    up = {
      -0.997,
      1.109,
      0.059,
      0,
      0,
      0
    },
    down = {
      -0.977,
      1.089,
      -0.461,
      0,
      -15,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [490] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [491] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [492] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [494] = {
    up = {
      -0.977,
      0.777,
      0.401,
      0,
      0,
      0
    },
    down = {
      -0.977,
      0.877,
      -0.009,
      0,
      -15,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [496] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [499] = {
    up = {
      -1.044,
      1.554,
      0.079,
      0,
      0,
      0
    },
    down = {
      -1.04,
      1.635,
      -0.595,
      0,
      355,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [508] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [554] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [555] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [502] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [500] = {
    up = {
      -0.965,
      0.599,
      0.049,
      0,
      0,
      0
    },
    down = {
      -1.015,
      0.699,
      -0.351,
      0,
      -10,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [506] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [507] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [525] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [515] = {
    up = {
      -1.197,
      4.077,
      0.195,
      0,
      0,
      0
    },
    down = {
      -1.197,
      4.117,
      -0.585,
      0,
      0,
      -1.6
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [516] = {
    up = {
      -0.981,
      0.945,
      0.032,
      0,
      0,
      0
    },
    down = {
      -0.966,
      1.035,
      -0.506,
      0,
      340,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [517] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [518] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [527] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [529] = {
    up = {
      -0.892,
      1.08,
      0.117,
      0,
      0,
      0
    },
    down = {
      -0.927,
      1.191,
      -0.277,
      0,
      350.5,
      359.5
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [534] = {
    up = {
      -0.972,
      0.963,
      -0.151,
      0,
      0,
      0
    },
    down = {
      -0.992,
      1.063,
      -0.541,
      0,
      -15,
      0
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [535] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [536] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [540] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [541] = {
    up = {
      -0.96,
      0.801,
      -0.083,
      0,
      0,
      0
    },
    down = {
      -0.97,
      0.961,
      -0.493,
      0,
      -13,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [545] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [543] = {
    up = {
      -0.927,
      0.786,
      0.102,
      0,
      0,
      0
    },
    down = {
      -0.937,
      0.881,
      -0.298,
      0,
      -15,
      1
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [546] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [547] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [550] = {
    up = {
      -0.95,
      1.029,
      0.224,
      0,
      0,
      0
    },
    down = {
      -0.97,
      1.129,
      -0.236,
      0,
      -15,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [551] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [558] = {
    up = {
      -0.944,
      0.74,
      -0.119,
      0,
      0,
      0
    },
    down = {
      -0.975,
      0.664,
      -0.532,
      0,
      347,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [559] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [561] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [451] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [457] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [565] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [576] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [562] = {
    up = {
      -0.863,
      0.976,
      -0.137,
      0,
      0,
      0
    },
    down = {
      -0.873,
      1.066,
      -0.557,
      0,
      -15,
      0.5
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [566] = {
    up = {
      -0.824,
      0.977,
      -0.451,
      0,
      0,
      0
    },
    down = {
      -0.774,
      1.177,
      -0.911,
      0,
      -17,
      -2
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [567] = {
    up = {
      -0.98,
      1.071,
      0.164,
      0,
      0,
      0
    },
    down = {
      -0.98,
      1.171,
      -0.376,
      0,
      -12,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [579] = {
    up = {
      -1.004,
      0.941,
      0.211,
      0,
      0,
      0
    },
    down = {
      -1.096,
      1.071,
      -0.252,
      0,
      356,
      358.801
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  },
  [580] = {
    up = {
      -0.986,
      0.676,
      0.345,
      0,
      0,
      0
    },
    down = {
      -0.986,
      0.776,
      -0.205,
      0,
      -15,
      0
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [582] = {
    up = {
      -1.008,
      2.002,
      0.353,
      0,
      0,
      0
    },
    down = {
      -0.984,
      2.041,
      -0.346,
      0,
      353,
      1.601
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [585] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [589] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [596] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [597] = {
    up = {
      -0.95,
      1.045,
      -0.085,
      0,
      0,
      288
    },
    down = {
      -0.95,
      1.195,
      -0.585,
      0,
      -10,
      288
    },
    leftDoor = "door_lf",
    rightDoor = "door_rf"
  },
  [598] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [604] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [603] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [605] = {up = {0, 0, 0, 0, 0, 0}, down = {0, 0, 0, 0, 0, 0}, leftDoor = "false", rightDoor = "false"},
  [602] = {
    up = {
      -0.911,
      0.994,
      -0.201,
      0,
      0,
      0
    },
    down = {
      -0.851,
      1.154,
      -0.661,
      0,
      -15,
      -1
    },
    leftDoor = "door_dside_f0",
    rightDoor = "door_pside_f0"
  }
}

Config.windowsSyncInterval = 1000
Config.windowsOpeningSpeed = 0.75

function convertWindowOffsets(id)
  data = Config.overrideWindowsOffets[id]
  rewrite = {}
  for i = 1, 3 do
    rewrite[i] = data.down[i] - data.up[i]
  end
  for i = 4, 6 do
    if data.up[i] > 180 then
      data.up[i] = data.up[i] - 360
    end
    if data.down[i] > 180 then
      data.down[i] = data.down[i] - 360
    end
    rewrite[i] = data.up[i] - data.down[i]
  end
  Config.overrideWindowsOffets[id] = {
    down = data.down,
    up = data.up,
    x = rewrite[1],
    y = rewrite[2],
    z = rewrite[3],
    rx = rewrite[4],
    ry = rewrite[5],
    rz = rewrite[6],
    leftDoor = data.leftDoor,
    rightDoor = data.rightDoor
  }
end

for k, v in pairs(Config.overrideWindowsOffets) do
  convertWindowOffsets(k)
end