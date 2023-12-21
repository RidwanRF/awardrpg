local main = {}

function getVehicle ( p )
    local vehicle = getPedOccupiedVehicle( p )
    if not vehicle then
        return false
    end
	if getPedOccupiedVehicleSeat( p ) ~= 0 then
	    return false
	end
	return vehicle
end

function onResourceStart ()
    for i, player in ipairs ( getElementsByType( "player" ) ) do
	    local account = getPlayerAccount( player )
		if account and not isGuestAccount( account ) then
		    setElementData( player, "accName", getAccountName( account ) )
		end
	end
end
addEventHandler( "onResourceStart", getResourceRootElement( getThisResource() ), onResourceStart )

function onPlayerLogin ( _, acc )
    setElementData( source, "accName", getAccountName( acc ) )
end
addEventHandler( "onPlayerLogin", getRootElement(), onPlayerLogin )

function main.playMusic ( volume, url )
    local vehicle = getVehicle ( source )
    if not vehicle then
        return false
    end

    setElementData( vehicle, "vehicle:url", url )
    setElementData( vehicle, "vehicle:volume", volume )
	setElementData( vehicle, "vehicle:isPaused", false )
end
addEvent( "radio_gui:onRequestMusic", true )
addEventHandler( "radio_gui:onRequestMusic", getRootElement(), main.playMusic )

function main.pauseMusic ()
    local vehicle = getVehicle ( source )
    if not vehicle then
        return false
    end
    setElementData( vehicle, "vehicle:isPaused", not ( getElementData( vehicle, "vehicle:isPaused" ) or false ) )
end
addEvent( "radio_gui:pauseMusic", true )
addEventHandler( "radio_gui:pauseMusic", getRootElement(), main.pauseMusic )

function main.volumeMusic ( volume )
    local vehicle = getVehicle ( source )
    if not vehicle then
        return false
    end
    setElementData( vehicle, "vehicle:volume", volume )
end
addEvent( "radio_gui:volumeMusic", true )
addEventHandler( "radio_gui:volumeMusic", getRootElement(), main.volumeMusic )