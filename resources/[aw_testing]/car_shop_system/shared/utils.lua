function isResourceRunning(resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end

local currencyTable = {
    RUB = "",
    USD = "",
    EUR = "",
}

function getReadablePrice(price, currency)
    if not currency then
        currency = "RUB"
    end
    if currency == "USD" then
        return currencyTable[currency] .. tostring(price)
    end
    return tostring(price) .. currencyTable[currency]
end

local isMotorcycle = {
    [448] = true, -- Мото
    [461] = true, -- Мото
    [462] = true, -- Мото
    [463] = true, -- Мото
    [468] = true, -- Мото
    [471] = true, -- Мото
    [521] = true, -- Мото
    [522] = true, -- Мото
    [523] = true, -- Мото
    [581] = true, -- Мото
    [586] = true  -- Мото
}

function isModelMotorcycle(model)
    if not model then
        return
    end
    return isMotorcycle[model]
end

-- Получить стоимость машины: local price, currency = exports.car_system:getCarPrice(model)
-- Сконвертить стоимость машины в рубли: local rubPrice = exports.bank:convertCurrency(price, currency, "RUB")
-- Использовать: testDriveCost:get(rubPrice)
local function getTestDriveCalculationFunc()
    -- Настраиваемые параметры
    local tbl = {
        minPrice =   3*1000,
        maxPrice = 200*1000,
        minCarPrice =       70*1000,
        maxCarPrice = 170*1000*1000,
        percent = 30,
    }

    -- Автовычисляемые параметры
    tbl.percent = tbl.percent / 100

    tbl.sqr = {}
    tbl.sqr.minValue = tbl.minCarPrice * tbl.minCarPrice
    tbl.sqr.diff = (tbl.maxCarPrice * tbl.maxCarPrice) - (tbl.minCarPrice * tbl.minCarPrice)
    tbl.sqr.multiplier = (tbl.maxPrice - tbl.minPrice) / tbl.sqr.diff

    tbl.ln = {}
    tbl.ln.minValue = math.log(tbl.minPrice)
    tbl.ln.diff = math.log(tbl.maxPrice) - math.log(tbl.minPrice)
    tbl.ln.multiplier = (tbl.maxPrice - tbl.minPrice) / tbl.ln.diff

    -- Функция расчета
    function tbl:get(carPrice)
        local sqr = ((carPrice*carPrice) - self.sqr.minValue) * self.sqr.multiplier + self.minPrice
        local ln1 = (math.log(sqr) - self.ln.minValue) * self.ln.multiplier + self.minPrice
        local ln2 = (math.log(ln1) - self.ln.minValue) * self.ln.multiplier + self.minPrice
        local ln3 = (math.log(ln2) - self.ln.minValue) * self.ln.multiplier + self.minPrice
        local percented = (ln3-ln2) * self.percent + ln2
        local result = math.max(math.min(percented, self.maxPrice), self.minPrice)
        return math.floor(result/1000)*1000
    end
    return tbl
end
TestDriveCost = getTestDriveCalculationFunc()

function calculateTestDrivePrice(model)
    if not model then
        return false
    end
    if not isResourceRunning("bank") or not isResourceRunning("car_system") then
        return 10000
    end
    local price, currency = exports.car_system:getCarPrice(model)
    local rubPrice = exports.bank:convertCurrency(price, currency, "RUB")
    return TestDriveCost:get(rubPrice)
end
