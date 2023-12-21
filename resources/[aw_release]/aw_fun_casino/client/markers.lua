
------------------------------------------------

	
	addEventHandler('onClientResourceStart', resourceRoot, function()

		local x,y,z = unpack( Config.casinoInterior.exchange )

		local marker = createMarker( x,y,z, 'corona', 5, 0, 0, 0, 0 )
		marker.dimension = Config.casinoInterior.dimension
		marker.interior = Config.casinoInterior.interior

		local ped = exports.main_peds:createWorldPed({

			position = {
				coords = {x,y,z,0},
				int = Config.casinoInterior.interior,
				dim = Config.casinoInterior.dimension,
			},

			attachToLocalPlayer = true,

			model = 61,

		})

		marker:setData('3dtext', '[Обменник]')

		createBindHandler( marker, 'f', 'Открыть обменник', function()
			openWindow('exchange')
		end )

	end)

------------------------------------------------