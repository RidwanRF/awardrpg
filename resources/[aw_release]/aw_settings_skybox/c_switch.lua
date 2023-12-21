function ToggleSkybox( state )
	if state then
		startDynamicSky()
	else
		stop()
	end
end
addEvent( "ToggleSkybox" )
addEventHandler( "ToggleSkybox", root, ToggleSkybox )


function onSettingsChange_handler( changed, values )
	if changed.skybox then
		if values.skybox then
			startDynamicSky()
		else
			stop()
		end
	end
end
addEvent( "onSettingsChange" )
addEventHandler( "onSettingsChange", root, onSettingsChange_handler )

addEventHandler( "onClientResourceStop", getResourceRootElement( getThisResource()),stopDynamicSky)

