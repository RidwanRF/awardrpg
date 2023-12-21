

------------------------------------------------------------

	addEventHandler('onElementDataChange', root, function( dn, old, new )

		if source.type == 'player' and dn == 'isAFK' and new then

			if casinoPlayers[ source ] then
				exitCasino( source )
			end
			
		end

	end)

------------------------------------------------------------