
---------------------------------------------

	function replaceModel( player, ... )
		return triggerClientEvent(player, 'engine.replaceModel', resourceRoot, ...)
	end

	function restoreModel( player, ... )
		return triggerClientEvent(player, 'engine.restoreModel', resourceRoot, ...)
	end

	function replaceModels( player, ... )
		return triggerClientEvent(player, 'engine.replaceModels', resourceRoot, ...)
	end

	function restoreModels( player, ... )
		return triggerClientEvent(player, 'engine.restoreModels', resourceRoot, ...)
	end

---------------------------------------------
