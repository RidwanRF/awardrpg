
--	==========     Проверка, что ресурс запущен     ==========
function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	return (res) and (getResourceState(res) == "running")
end

-- ==========     Обработка больших массивов с паузами     ===========
-- Запуск обработки. Прототипы функций:
-- funcOnPortionStart(originalTable, startID, endID, enumName)									-- Может использоваться как обработка всей группы сразу
-- funcOnEachElement(dataRow, enumName)															-- Обработка одного элемента/строки
-- funcOnPortionEnd(portionNumber, currentLoopTime, elapsedTime, currentPortionSize, enumName)	-- Вызывается по окончании обработки порции, может отображать частичную статистику
-- funcOnEnumerationEnd(portions, elapsedTime, totalTimeWithPauses, processedCount)				-- Вызывается при полном окончании обработки
local currentEnumerations = {}
function enumerateAllElements(enumerationName, tableToEnumerate, portionSize, portionDelay, funcOnPortionStart, funcOnEachElement, funcOnPortionEnd, funcOnEnumerationEnd)
	if (type(tableToEnumerate) ~= "table") then
		outputDebugString("Failed to enumerateAllElements: tableToEnumerate is wrong. ("..tostring(tableToEnumerate)..")", 1)
		return
	end
	if not tonumber(portionSize) then
		outputDebugString("Failed to enumerateAllElements: portionSize is not a number. ("..tostring(portionSize)..")", 1)
		return
	end
	if not tonumber(portionDelay) then
		outputDebugString("Failed to enumerateAllElements: portionDelay is not a number. ("..tostring(portionDelay)..")", 1)
		return
	end
	
	local enumID = #currentEnumerations + 1
	currentEnumerations[enumID] = {
		-- EnumFunc variables
		name = tostring(enumerationName),
		portionSize = math.floor(portionSize),
		delay = math.max(math.floor(portionDelay), 50),
		itemsCount = #tableToEnumerate,
		-- Data and processors
		Table = tableToEnumerate,
		onPortionStart = (type(funcOnPortionStart) == "function") and funcOnPortionStart,
		onEachElement = (type(funcOnEachElement) == "function") and funcOnEachElement,
		onPortionEnd = (type(funcOnPortionEnd) == "function") and funcOnPortionEnd,
		onEnumerationEnd = (type(funcOnEnumerationEnd) == "function") and funcOnEnumerationEnd,
		-- State data
		currentID = 0,
		startedAt = getTickCount(),
		elapsed = 0,
		portions = 0,
	}
	currentEnumerations[enumID].timer = setTimer(enumerationPortionFunction, portionDelay, 1, enumID)
	outputDebugString("Started enumeration \""..tostring(enumerationName).."\"")
	return enumID
end

function enumerationPortionFunction(enumID)
	local portionStart = getTickCount()
	local enumData = currentEnumerations[enumID]
	local startID = enumData.currentID + 1
	local endID = enumData.currentID + enumData.portionSize
	endID = math.min(endID, enumData.itemsCount)
	if (startID <= endID) then
		if (enumData.onPortionStart) then
			enumData.onPortionStart(enumData.Table, startID, endID, enumData.name)
		end
		for i = startID, endID do
			enumData.currentID = i
			if (enumData.onEachElement) then
				enumData.onEachElement(enumData.Table[i], enumData.name)
			end
		end
		enumData.portions = enumData.portions + 1
		local currentLoop = getTickCount() - portionStart
		enumData.elapsed = enumData.elapsed + currentLoop
		if (enumData.onPortionEnd) then
			enumData.onPortionEnd(enumData.portions, currentLoop, enumData.elapsed, (endID-startID)+1, enumData.name)
		end
	
		enumData.timer = setTimer(enumerationPortionFunction, enumData.delay, 1, enumID)
	else
		if (enumData.onEnumerationEnd) then
			local totalTime = getTickCount() - enumData.startedAt
			enumData.onEnumerationEnd(enumData.portions, enumData.elapsed, totalTime, enumData.itemsCount)
		end
		currentEnumerations[enumID] = nil
		outputDebugString("Enumeration \""..enumData.name.."\" was ended.")
	end
end

-- Прерывание обработки
function abortEnumeration(enumID)
	local data = currentEnumerations[enumID]
	if (data) then
		killTimer(data.timer)
		currentEnumerations[enumID] = nil
		outputDebugString("Enumeration "..tostring(enumID).." (name: "..data.name..") was aborted.")
		return true
	else
		outputDebugString("Failed to abortEnumeration: enumeration "..tostring(enumID).." does not exist.", 2)
		return false
	end
end
