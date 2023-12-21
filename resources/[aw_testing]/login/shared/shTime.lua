function timeSegmentToNiceString(seconds, short)
	seconds = tonumber(seconds)
	if (not seconds) then return "" end
	local count, timeString, tempStr, tempNum = 2, ""
	
	local years = math.floor(seconds / 31536000)
	seconds = seconds - (years * 31536000)
	local months = math.floor(seconds / 2592000)
	seconds = seconds - (months * 2592000)
	local weeks = math.floor(seconds / 604800)
	seconds = seconds - (weeks * 604800)
	local days = math.floor(seconds / 86400)
	seconds = seconds - (days * 86400)
	local hours = math.floor(seconds / 3600)
	seconds = seconds - (hours * 3600)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - (minutes * 60)
	
	if (years > 0) then
		tempNum = getNameType(years)
		if tempNum == 1 then tempStr = " год"
		elseif tempNum == 2 then tempStr = " года"
		else tempStr = " лет" end
		timeString = years..tempStr
		count = count - 1
	end
	if (months > 0) then
		tempNum = getNameType(months)
		if tempNum == 1 then tempStr = " месяц"
		elseif tempNum == 2 then tempStr = " месяца"
		else tempStr = " месяцев" end
		if (timeString ~= "") then timeString = timeString..", " end
		timeString = timeString..months..tempStr
		count = count - 1
	end
	if (weeks > 0) and ((not short) or (count > 0)) then
		tempNum = getNameType(weeks)
		if tempNum == 1 then tempStr = " неделю"
		elseif tempNum == 2 then tempStr = " недели"
		else tempStr = " недель" end
		if (timeString ~= "") then timeString = timeString..", " end
		timeString = timeString..weeks..tempStr
		count = count - 1
	end
	if (days > 0) and ((not short) or (count > 0)) then
		tempNum = getNameType(days)
		if tempNum == 1 then tempStr = " день"
		elseif tempNum == 2 then tempStr = " дня"
		else tempStr = " дней" end
		if (timeString ~= "") then timeString = timeString..", " end
		timeString = timeString..days..tempStr
		count = count - 1
	end
	if (hours > 0) and ((not short) or (count > 0)) then
		tempNum = getNameType(hours)
		if tempNum == 1 then tempStr = " час"
		elseif tempNum == 2 then tempStr = " часа"
		else tempStr = " часов" end
		if (timeString ~= "") then timeString = timeString..", " end
		timeString = timeString..hours..tempStr
		count = count - 1
	end
	if (minutes > 0) and ((not short) or (count > 0)) then
		tempNum = getNameType(minutes)
		if tempNum == 1 then tempStr = " минуту"
		elseif tempNum == 2 then tempStr = " минуты"
		else tempStr = " минут" end
		if (timeString ~= "") then timeString = timeString..", " end
		timeString = timeString..minutes..tempStr
		count = count - 1
	end
	if (seconds > 0) and ((not short) or (count > 0)) then
		tempNum = getNameType(seconds)
		if tempNum == 1 then tempStr = " секунду"
		elseif tempNum == 2 then tempStr = " секунды"
		else tempStr = " секунд" end
		if (timeString ~= "") then timeString = timeString..", " end
		timeString = timeString..seconds..tempStr
		count = count - 1
	end
	
	if timeString == "" then timeString = "0 секунд" end
	return timeString
end

function getNameType(number)
	-- 1 = 1 год, 2 = 2,3,4 года, 3 = 5,6,... лет
	if (number > 9) and (number < 20) then return 3 end
	number = number - (math.floor(number/10)*10)
	if (number == 1) then return 1 end
	if (1 < number) and (number < 5) then return 2 end
	return 3
end

function dateTimeToString(unixTime, delimiter)
	unixTime = tonumber(unixTime)
	local time = getRealTime(unixTime, true)
	if (delimiter == ".") then
		return string.format('%02d.%02d.%04d %02d:%02d', time.monthday, time.month+1, time.year+1900, time.hour, time.minute)
	elseif (delimiter == "-") then
		return string.format('%04d-%02d-%02d %02d:%02d', time.year+1900, time.month+1, time.monthday, time.hour, time.minute)
	else
		return string.format('%04d-%02d-%02d %02d:%02d', time.year+1900, time.month+1, time.monthday, time.hour, time.minute)
	end
	
	-- if (not unixTime) or (unixTime < 0) then return "" end
	-- local tT = getRealTime(unixTime, true)
	-- tT.year = tT.year - 100
	-- tT.month = tT.month + 1
	-- if (tT.month < 10) then tT.month = "0"..tT.month end
	-- if (tT.monthday < 10) then tT.monthday = "0"..tT.monthday end
	-- if (tT.hour < 10) then tT.hour = "0"..tT.hour end
	-- if (tT.minute < 10) then tT.minute = "0"..tT.minute end
	-- return ((delimiter == ".") and (tT.monthday.."."..tT.month..".20"..tT.year.." "..tT.hour..":"..tT.minute))
		-- or (tT.year.."-"..tT.month.."-"..tT.monthday.." "..tT.hour..":"..tT.minute)
end

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = {2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400}
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
    return timestamp
end

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end












