-- Стандартные спойлеры
local defaultSpoilers = {
    { name="SA spoiler 1",  price=15000 },
    { name="SA spoiler 2",  price=15000 },
    { name="SA spoiler 3",  price=15000 },
    { name="SA spoiler 4",  price=15000 },
    { name="SA spoiler 5",  price=15000 },
    { name="SA spoiler 6",  price=15000 },
    { name="SA spoiler 7",  price=15000 },
    { name="SA spoiler 8",  price=15000 },
    { name="SA spoiler 9",  price=15000 },
    { name="SA spoiler 10", price=15000 },
    { name="SA spoiler 11", price=15000 },
    { name="SA spoiler 12", price=15000 },
    { name="SA spoiler 13", price=15000 },
    { name="SA spoiler 14", price=15000 },
    { name="SA spoiler 15", price=15000 },
    { name="SA spoiler 16", price=15000 },
    { name="SA spoiler 17", price=15000 },
    { name="SA spoiler 18", price=15000 },
    { name="SA spoiler 19", price=15000 },
    { name="SA spoiler 20", price=15000 },
}

-- Стандартные колёса
local defaultWheels = {
    { name="Диск #1",   price=116000 },
    { name="Диск #2",   price=240000 },
    { name="Диск #3",   price=60000  },
    { name="Диск #4",   price=130000 },
    { name="Диск #5",   price=180000 },
    { name="Диск #6",   price=220000 },
    { name="Диск #7",   price=60000  },
    { name="Диск #8",   price=172000 },
    { name="Диск #9",   price=80000  },
    { name="Диск #10",   price=108000 },
    { name="Диск #11",   price=154000 },
    { name="Диск #12",   price=330000 },
    { name="Диск #13",   price=213000 },
    { name="Диск #14",   price=620000 },
    { name="Диск #15",   price=104000 },
    { name="Диск #16",   price=132000 },
    { name="Диск #17",   price=145000 },
    { name="Диск #18",   price=60000  },
    { name="Диск #19",   price=140000 },
    { name="Диск #20",   price=154000 },
    { name="Диск #21",   price=470000 },
    { name="Диск #22",   price=60000  },
    { name="Диск #23",   price=450000 },
    { name="Диск #24",   price=60000  },
    { name="Диск #25",   price=90000  },
    { name="Диск #26",   price=150000 },
    { name="Диск #27",   price=30000  },
    { name="Диск #28",   price=30000  },
    { name="Диск #29",   price=80000  },
    { name="Диск #30",   price=150000 },
    { name="Диск #31",   price=80000  },
    { name="Диск #32",   price=80000  },
    { name="Диск #33",   price=60000  },
    { name="Диск #34",   price=210000 },
    { name="Диск #35",   price=20000  },
    { name="Диск #36",   price=20000  },
    { name="Диск #37",   price=90000  },
    { name="Диск #38",   price=400000 },
    { name="Диск #39",   price=220000 },
    { name="Диск #40",   price=80000 },
    { name="Диск #41",  price=60000 },
    { name="Диск #42",   price=80000 },
    { name="Диск #43",   price=35000 },
    { name="Диск #44",   price=35000 },
    { name="Диск #45",   price=67500 },
    { name="Диск #46",   price=90000 },
    { name="Диск #47",   price=105800 },
    { name="Диск #48",   price=120000 },
    { name="Диск #49",   price=230000 },
    { name="Диск #50",   price=260000 },
    { name="Диск #51",   price=120000 },
    { name="Диск #52",   price=420000 },
    { name="Диск #53",   price=470000 },
    { name="Диск #54",   price=470000 },
}

-- Сменные рамки номеров
local licesneFrames = {
	{ name="Не прижимайся не в постели",					price=5000 }, --1
	{ name="M Perfomance",			        price=5000 }, --3
	{ name="Еду Как Хочу",	     		price=10000 }, --10
	{ name="Плачу налоги, где дороги?",	         	price=5000 }, --11
	{ name="СДИ",		     	price=5000 }, --12
	{ name="Smotra.Ru",		     	price=5000 }, --13
	{ name="AMG",	          	price=5000 }, --14
	{ name="Боевая Классика",	  			price=5000 }, --15
	{ name="Золотая рамка",		     	price=5000 }, --16
	{ name="Полосы M",				price=5000 }, --17
	{ name="хз",		     	price=5000 }, --18
	{ name="RDS",				price=5000 }, --19
	{ name="Управление РФ",				price=5000 }, --20
}

-- Резина колес
local wheelsTire = {
    { name="Покрышка #1",              price=150000 },
    { name="Покрышка #2",              price=150000 },
    { name="Покрышка #3",              price=150000 },
    { name="Покрышка #4",              price=150000 },
    { name="Покрышка #5",              price=150000 },
    { name="Покрышка #6",              price=150000 },
    { name="Покрышка #7",              price=150000 },
    { name="Покрышка #8",              price=150000 },
    { name="Покрышка #9",              price=150000 },
    { name="Покрышка #10",              price=150000 },
    { name="Покрышка #11",              price=150000 },
    { name="Покрышка #12",              price=150000 },
    { name="Покрышка #13",              price=150000 },
    { name="Покрышка #14",              price=150000 },
    { name="Покрышка #15",              price=150000 },
    { name="Покрышка #16",              price=150000 },
    { name="Покрышка #17",              price=150000 },
    { name="Покрышка #18",              price=150000 },
    { name="Покрышка #19",              price=150000 },
}

local wheelsBrake = {
    { name="Тормозные диски #1",              price=150000 },
    { name="Тормозные диски #2",              price=150000 },
    { name="Тормозные диски #3",              price=150000 },
    { name="Тормозные диски #4",              price=150000 },
    { name="Тормозные диски #5",              price=150000 },
    { name="Тормозные диски #6",              price=150000 },
    { name="Тормозные диски #7",              price=150000 },
    { name="Тормозные диски #8",              price=150000 },
    { name="Тормозные диски #9",              price=150000 },
    { name="Тормозные диски #10",              price=150000 },
    { name="Тормозные диски #11",              price=150000 },
    { name="Тормозные диски #12",              price=150000 },
}

-- Профиль резины
wheelsProf = {
    { name="Самый низкий профиль",             price=150000 },
    { name="Низкий профиль",            price=150000 },
    { name="Средний профиль",              price=150000 },
    { name="Высокий профиль",             price=150000 },
}


local shtorka = 
{   
    { name = "Шторка",      price = 10000000000 },
   -- { name = "Логотип",    	price = 4000000 }
}

local kitComponents = {}

for model, components in pairs(ComponentsTable) do
    if components.kit then
        kitComponents[model] = {}
        for name, list in pairs(components) do
            for id, component in pairs(list) do
                for kitId in pairs(components.kit) do
                    if component.kit and component.kit[kitId] then
                        if not kitComponents[model][kitId] then
                            kitComponents[model][kitId] = {}
                        end
                        kitComponents[model][kitId][name] = id
                    end
                end
            end
        end
    end
end

local function getStockComponent()
    return { name = "Stock", price = 0 }
end

function getComponentsTable(model)
    if type(model) ~= "number" then
        return
    end
    local components = table.copy(ComponentsTable[model])
    if not components then
        components = {}
    end

    -- Спойлеры
    if not components.spoiler then
        components.spoiler = {}
    end
    -- Сначала идут стандартные спойлеры
    local spoilersTable = table.copy(defaultSpoilers)
    -- Далее идут спойлеры автомобиля
    if components.spoiler then
        for i = 1, table.maxn(components.spoiler) do
            table.insert(spoilersTable, components.spoiler[i])
        end
        -- Добавить стоковый спойлер
        spoilersTable[0] = components.spoiler[0]
    end
    if not spoilersTable[0] then
        spoilersTable[0] = getStockComponent()
    end
    components.spoiler = spoilersTable

    -- Колёса
    components.wheels = table.copy(defaultWheels)
    components.wheels[0] = getStockComponent()

    -- Тормозные диски
    components.wheels_brakes = table.copy(wheelsBrake)
    components.wheels_brakes[0] = getStockComponent() 

    -- Резины
    components.wheels_tire = table.copy(wheelsTire)
    components.wheels_tire[0] = getStockComponent()

    components.wheels_prof = table.copy(wheelsProf)
    components.wheels_prof[0] = getStockComponent()
    
    -- Шторка
    components.shtorka = table.copy(shtorka)
    components.shtorka[0] = getStockComponent()

    if isResourceRunning("car_components") then
        -- Сменные рамки номеров
        components.licence_frame = table.copy(licesneFrames)
        components.licence_frame[0] = getStockComponent()

        -- Ксенон
        components.xenon = exports["car_components"]:getXenonColors()
        components.xenon[0] = getStockComponent()
	    end
    return components
end

function getComponentInfo(model, component, id)
    if not model or not component or not id then
        return
    end
    local components = getComponentsTable(model)
    if not components or not components[component] or not components[component][id] then
        return
    end

    return components[component][id]
end

-- Получает номер компонента в ките
function getKitComponentId(model, kit, name)
    if kitComponents[model] and kitComponents[model][kit] and kitComponents[model][kit][name] then
        local id = kitComponents[model][kit][name]
        -- Для спойлеров в таблице не учитываются стандартные спойлеры, поэтому id нужно смещать
        if name == "spoiler" then
            id = id + #defaultSpoilers
        end
        return id
    end
end
