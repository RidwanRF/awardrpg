

------------------------------------------------------------
	
	local russianGame

------------------------------------------------------------

	function renderRussianGame()

		if not russianGame then return end

		local alpha = 1

		if localPlayer == getRussianActivePlayer( russianGame ) and not russianGame.shoot then

			local y = ( real_sy - px(50) ) * sx/real_sx

			dxDrawText('Нажмите #cd4949ЛКМ#ffffff, чтобы взять пистолет',
				0, y,
				sx, y,
				tocolor(255,255,255,255*alpha),
				0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
				'center', 'bottom', false, false, false, true
			)

		end

	end

------------------------------------------------------------

	addEvent('casino.syncRussianGame', true)
	addEventHandler('casino.syncRussianGame', resourceRoot, function( game )

		russianGame = game

		if game then
			addEventHandler('onClientRender', root, renderRussianGame)
		else
			removeEventHandler('onClientRender', root, renderRussianGame)
		end

	end)

------------------------------------------------------------

	addEventHandler('onClientKey', root, function( button, state )

		if russianGame then

			if (
				button == 'mouse1'
				and state
				and localPlayer == getRussianActivePlayer( russianGame )
			) then

				triggerServerEvent('casino.doRussianShoot', resourceRoot, russianGame.marker)

			else

				cancelEvent()

			end

		end


	end)

------------------------------------------------------------