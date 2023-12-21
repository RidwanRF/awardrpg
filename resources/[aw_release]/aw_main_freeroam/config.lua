

sectionMenu = {
	{1, "images/icon/home.png", "Главная"},
	{2, "images/icon/info.png", "Магазин"},
	{3, "images/icon/partnerka.png", "Партнерство"},
	{4, "images/icon/gps.png", "Навигация"},
	{5, "images/icon/setting.png", "Настройки"},
}

numbers = {
	["0"] = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
	["6"] = true,
	["7"] = true,
	["8"] = true,
	["9"] = true,
}


selectionmagaz = {
 
       ["vip"] = {
            {50,  "1 день",      86400,    "images/exclusive/vip1.png", "VIP"},
            {150, "3 дня",       259200,   "images/exclusive/vip1.png", "VIP"},
            {299, "7 дней",      604800,   "images/exclusive/vip2.png", "VIP"},
            {399, "14 дней",     1209600,  "images/exclusive/vip2.png", "VIP"},
            {599, "21 день",     1814400,  "images/exclusive/vip3.png", "VIP"},
            {899, "30 дней",     2592000,  "images/exclusive/vip3.png", "VIP"},
       },



       ["Adminstat"] = {
            {499,  "Модератор",         "images/admins/admin1.png", "images/exclusive/ran1.png", "350кк",        "В комплекте 500кк руб."},
            {599,  "Ст.Модератор",      "images/admins/admin2.png", "images/exclusive/ran1.png", "500кк",        "В комплекте 500кк руб."},
            {699,  "Администратор",     "images/admins/admin3.png", "images/exclusive/ran2.png", "700кк",        "В комплекте 700кк руб."}, 
            {1199, "Гл.Администратор",  "images/admins/admin4.png", "images/exclusive/ran2.png", "1.400ккк",     "В комплекте 1.400ккк руб."},
            {1899, "Спонсор",           "images/admins/admin5.png", "images/exclusive/ran3.png", "2.250ккк",     "В комплекте 2.250ккк руб."},
            {2599, "Зам.Основателя",    "images/admins/admin6.png", "images/exclusive/ran4.png", "4.5ккк", 	   "В комплекте 4.5кк руб."},
            {3999, "Основателя",   	"images/admins/admin7.png", "images/exclusive/ran4.png", "Выдача денег", "Бесконечная выдача"},
       },

  }


saveSetting = {
	{"onClientSwitchAO"},
	{"onClientSwitchDetail"},
	{"switchDoFBokeh"},
	{"ToggleSkybox"},
	{"switchContrast"},
	{"switchFxaa"},
	{"panel_sellingSgu"},
	{"toggleEngines"},
	{"CheckAudioZones"},
	{"autologinWrite"},
}

setting = {
	{"Графика", seting = {
		{"HD Тени", "onClientSwitchAO"},
		{"Детализация", "onClientSwitchDetail"},
		{"Размытия дальности", "switchDoFBokeh"},
		{"HD Небо", "ToggleSkybox"},
		{"Контрастность", "switchContrast"},
		{"Cглаживание", "switchFxaa"},
	}},
	{"Звуки", seting = {
		{"Звук СГУ", "panel_sellingSgu"},
		{"Звук авто", "toggleEngines"},
		{"Звук Окружения", "CheckAudioZones"},
	}},
	{"Прочее", seting = {
		{"Автологин", "autologinWrite"},
	}},
}

gps = {

	{name = {
		{"Основные"},


	}, seting = {
		{"Банк", "images/gps/1.png", "bank"},
		{"Покрасочная", "images/gps/2.png", "car_paint_garage"},
		{"Тюнинг", "images/gps/3.png", "car_tuning_garage"},
		{"Азс", "images/gps/4.png", "car_benzin"},
		{"Установка чип-тюнинга", "images/gps/5.png", {2883.6599121094,2224.6713867188,19.517248153687}},
		{"Контейнеры", "images/gps/6.png", {2360.1665039062,2766.9069824219,10.8203125}},
		{"Работа таксистом", "images/gps/9.png", {-241.76138305664,2607.8598632812,62.703125}},
		{"Автосалон среднего класса", "images/gps/8.png", {253.65565490723,-149.00198364258,1.4117403030396}},
		{"Автосалон высокого класса", "images/gps/7.png", {2029.1547851562, 1006.8853759766, 10.8203125}},

	}}

}
