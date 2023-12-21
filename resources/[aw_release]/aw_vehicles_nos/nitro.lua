g_Me = getLocalPlayer( );
g_Root = getRootElement( );
g_ResRoot = getResourceRootElement( );

addEventHandler( "onClientResourceStart", g_ResRoot,
	function( )
		bindKey( "vehicle_fire", "both", toggleNOS );
		bindKey( "vehicle_secondary_fire", "both", toggleNOS );
	end
)

function toggleNOS( key, state )
	local veh = getPedOccupiedVehicle( g_Me );
	if veh and not isEditingPosition then
		if state == "up" then
			removeVehicleUpgrade( veh, 1010 );
			setPedControlState(localPlayer, "vehicle_fire", false);
		else
			addVehicleUpgrade( veh, 1010 );
		end
	end
end
