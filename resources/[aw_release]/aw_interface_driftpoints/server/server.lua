local money_mul = 1/200

function updateScore(player, drift)
	if not isElement(player) then return end

	local best = player:getData('drift.best') or 0

	if drift > best then
		player:setData('drift.best', drift)
	--	exports.hud_notify:notify(player, 'Рекорд', 'Вы побили дрифт-рекорд')
	end

	local best = player:getData('drift.best.rating') or 0
	if drift > best then
		player:setData('drift.best.rating', drift)
	end

	--increaseElementData(player, 'sessionDrift', drift)
	--increaseElementData(player, 'drift.total', drift)

	-- local money = math.floor(drift*money_mul)

	-- if money > 0 then
	-- 	exports.money:givePlayerMoney(player, money)
	-- end

end


addEvent('finishDrift', true)
addEventHandler('finishDrift', root, function(driftedCount)
	updateScore(source, driftedCount)
end)
