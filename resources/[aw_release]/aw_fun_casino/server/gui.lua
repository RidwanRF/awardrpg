
----------------------------------------

	function openPlayerWindow( player, section, ... )
		triggerClientEvent( player, 'casino.openWindow', resourceRoot, section, ... )
	end
----------------------------------------

	function bind_openPlayerWindow( player, section, marker, ... )
		triggerClientEvent( player, 'casino.bind_openWindow', resourceRoot, section, marker, ... )
	end
----------------------------------------

	function closePlayerWindow( player, section )
		triggerClientEvent( player, 'casino.closeWindow', resourceRoot, section )
	end

----------------------------------------