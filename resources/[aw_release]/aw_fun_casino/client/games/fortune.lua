
-------------------------------------------------------

	local fortune_wheel = {}
	local fortune_button = Config.games.fortune.button

	local fortune_wheel_anim = {}
	setAnimData( fortune_wheel_anim, 0.1 )


-------------------------------------------------------
	
	function bindFortuneWheel( wheel )

		fortune_wheel = wheel

		addEventHandler('onClientRender', root, renderFortuneWheel)
		animate( fortune_wheel_anim, 1 )

	end

-------------------------------------------------------

	function unbindFortuneWheel( wheel )

		if wheel and wheel.marker == fortune_wheel.marker then

			animate( fortune_wheel_anim, 0, function()
				removeEventHandler('onClientRender', root, renderFortuneWheel)
				wheel = nil
			end )

		end


	end

-------------------------------------------------------

	addEvent('casino.toggleFortuneWheel', true)
	addEventHandler('casino.toggleFortuneWheel', resourceRoot, function( wheel, state )

		if state then
			bindFortuneWheel( wheel )
		else
			unbindFortuneWheel( wheel )
		end

	end)

-------------------------------------------------------

	function renderFortuneWheel()

		if (
			fortune_wheel
			and isElement( fortune_wheel.wheel ) 
			and isObjectMoving( fortune_wheel.wheel )
		) then return end

		local alpha = getEasingValue( getAnimData( fortune_wheel_anim ), 'InOutQuad' )

		local default_cost = Config.games.fortune.default_cost

		local default_tickets = localPlayer:getData('casino.default_tickets') or 0

		local text = {('%s - крутить колесо'):format( fortune_button:upper() ),('Стоимость - %s'):format( fortune_wheel.type == 'default' and (default_tickets > 0 and 'бесплатно' or ('%s %s'):format(default_cost, getWordCase( default_cost, '$', '$', '$' ))) or ('50 AW Coins') ),}

		local _y = ( real_sy - px(200) ) * sx/real_sx

		for _, row in pairs( text ) do

			dxDrawTextShadow(row,
				0, _y, sx, _y,
				tocolor( 255,255,255,255*alpha ),
				0.5, getFont('montserrat_semibold', 25, 'light'),
				'center', 'center', 1, tocolor(0, 0, 0, 50*alpha), false, dxDrawText 
			)

			_y = _y + 20

		end


	end

-------------------------------------------------------

	function doPlayerRoll_callback()

		if not isElement(fortune_wheel.wheel) then return end

		local x,y,z = getElementPosition( fortune_wheel.wheel )
		local nx,ny,nz = getElementPosition( localPlayer )

		local r = findRotation( nx,ny, x,y )

		setElementRotation( localPlayer, 0, 0, r )

		setPedAnimation( localPlayer, 'custom_casino', 'roll', -1, false, false, false, false )

		setTimer(function()

			triggerServerEvent('casino.rollFortuneWheel', resourceRoot, fortune_wheel.marker)

		end, 1100, 1)



	end
	addEvent('casino.rollFortuneWheel_callback', true)
	addEventHandler('casino.rollFortuneWheel_callback', resourceRoot, doPlayerRoll_callback)

-------------------------------------------------------
	
	bindKey(fortune_button, 'down', function()

		if fortune_wheel then

			if not isElement(fortune_wheel.wheel) then return end

			if isElementWithinMarker( localPlayer, fortune_wheel.marker ) then
				triggerServerEvent('casino.rollFortuneWheel_check', resourceRoot, fortune_wheel.marker)
			end


		end

	end)

-------------------------------------------------------

	local customBlockName = "custom_casino"
	local IFP = engineLoadIFP( "assets/animations/roll.ifp", customBlockName )

-------------------------------------------------------

	fortuneShaders = {
		default = dxCreateShader('assets/shaders/texreplace.fx', 0, 0, true),
		vip = dxCreateShader('assets/shaders/texreplace.fx', 0, 0, true),
	}

	fortuneTextures = {}


	addEvent('casino.onInteriorEnter', true)
	addEventHandler('casino.onInteriorEnter', resourceRoot, function( data )

		fortuneTextures.default = dxCreateTexture( 'assets/images/fortune/default.png' )
		fortuneTextures.vip = dxCreateTexture( 'assets/images/fortune/vip.png' )

		for key, texture in pairs( fortuneTextures ) do
			dxSetShaderValue( fortuneShaders[key], 'gTexture', texture )
		end

		if data and data.fortune then

			for _, wheel_data in pairs( data.fortune ) do
				engineApplyShaderToWorldTexture( fortuneShaders[ wheel_data.type ], 'untitled', wheel_data.wheel )
			end

		end

	end)

----------------------------

	addEvent('casino.onInteriorExit', true)
	addEventHandler('casino.onInteriorExit', resourceRoot, function()

		clearTableElements( fortuneTextures or {} )
		fortuneTextures = {}

	end)

-------------------------------------------------------