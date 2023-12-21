

cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f10'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
	['0'] = true,
	['j'] = true,
}

openHandler = function()
	localPlayer:setData('action_notify.hidden', true, false)
	showChat(false)
	hud = exports.aw_interface_hud:anim_true()
    radar = exports.aw_interface_radar:anim_true()
end

closeHandler = function()
	localPlayer:setData('action_notify.hidden', false, false)
	showChat(true)
	hud = exports.aw_interface_hud:anim_false()
    radar = exports.aw_interface_radar:anim_false()
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {
	
	exchange = {

		{'element',
			'center', 'center',
			648, 605,
			color = {255,255,255,255},

			elements = {

				{'image',
					'center', 'top',
					646, 95,
					'assets/images/exchange/bg1.png',
					color = {25,24,38,255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shw,shh = 672, 119
						local shx,shy = x+w/2-shw/2, y+h/2-shh/2

						dxDrawImage(
							shx, shy + 5, shw, shh, 'assets/images/exchange/bg1_shadow.png',
							0, 0, 0, tocolor(0, 0, 0, 255*alpha)
						)

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Обменник Казино',
							x,y,x+w,y+h,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
							'center', 'center'
						)

						local iw,ih = 56,56
						local ix,iy = x + 30, y+h/2-ih/2

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/exchange/icon_bg.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/exchange/icon.png',
							0, 0, 0, tocolor(0, 0, 0,150*alpha)
						)

					end,

					elements = {

						{'button',

							function(s,p) return p[4] - s[4] - 30 end, 'center', 26, 26,
							bg = 'assets/images/close.png',
							activeBg = 'assets/images/close_active.png',
							define_from = '',

							'',

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawImage(
									x,y,w,h, 'assets/images/close_icon.png',
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

							end,

							onClick = function(element)

								if not slotsWindow.active then
									closeWindow()
								end

							end,

						},

					},


				},

				{'exchange-window',

					[2] = 'left', [3] = 'bottom',

					name = 'Обмен фишек',
					title = 'Для игр в казино',
					button = 'Произвести обмен',
					counter = 'Ваши фишки',

					valute = 'chips',

				},

				{'exchange-window',

					[2] = 'right', [3] = 'bottom',

					name = 'Покупка жетонов',
					title = 'Для VIP-колеса фортуны',
					button = 'Приобрести жетоны',
					counter = 'Ваши жетоны',

					valute = 'vip_tickets',

				},

			},

		},

	},

	slots = {

		{'image',
			'center', ( real_sy - px( 250 ) ) * sx/real_sx,
			774, 192,

			color = {25,24,38,255},
			'assets/images/slots/bg.png',

			variable = 'slotsWindow',
			textures = {},

			columns = {
				{ 1 }, 
				{ 1 }, 
				{ 1 },
			},

			initSlots = function(element, object)

				element.textures.slots_rt = dxCreateRenderTarget(800, 600)
				element.textures.slots_roulette_rt = dxCreateRenderTarget(550, 90, true)

				dxSetRenderTarget( element.textures.slots_rt )

					dxDrawImage(	
						0, 0, 800, 600, 'assets/images/slots/slot_tex.png',
						0, 0, 0, tocolor( 255,255,255,255 )
					)

				dxSetRenderTarget(  )

				element.textures.shader = dxCreateShader( 'assets/shaders/texreplace.fx', 0, 0, true )

				dxSetShaderValue( element.textures.shader, 'gTexture', element.textures.slots_rt )
				engineApplyShaderToWorldTexture( element.textures.shader, 'img1136712', object )

				element.animations = { {}, {}, {} }

				element:resetAnimations()

				element.columns = {
					{ math.random(5) },
					{ math.random(5) },
					{ math.random(5) },
				}

			end,

			resetAnimations = function(element)

				local add = 0

				for _, anim in pairs( element.animations ) do
					timed_setAnimData( anim, 3000 + add )
					add = add + 1000
				end

			end,

			onRender = {

				slots = function(element)

					if not isElement(element.textures.slots_roulette_rt) then return end

					dxSetRenderTarget( element.textures.slots_roulette_rt, true )

						local w,h = 60, 60
						local paddingX = 105
						local paddingY = 0

						local startX = 112

						for i = 1,3 do

							local anim = getEasingValue( timed_getAnimData( element.animations[i] ), 'InOutQuad' )
							local offset = anim * (#element.columns[i]-1)*60

							local startY = 60/2 - offset

							for _, icon in pairs( element.columns[i] ) do

								if isBetween( startY, -h*2, 60*2 ) then

									mta_dxDrawImage(
										startX - w/2, startY - h/2,
										w,h, ( 'assets/images/slots/icons/%s.png' ):format( icon )
									)

								end

								startY = startY + h + paddingY

							end


							startX = startX + w + paddingX

						end


					dxSetRenderTarget( element.textures.slots_rt )

						mta_dxDrawImage(	
							0, 0, 800, 600, 'assets/images/slots/slot_tex.png',
							0, 0, 0, tocolor( 255,255,255,255 )
						)

						local lw,lh = 524, 90
						local lx,ly = 800/2-lw/2, 100


						mta_dxDrawImage(	
							lx,ly,lw,lh, 'assets/images/slots/slot_lights.png',
							0, 0, 0, tocolor( 155,120,0,255 )
						)

						if slotsWindow.active then

							local a_anim = getAnimData( slotsWindow.active_anim )

							mta_dxDrawImage(	
								lx,ly,lw,lh, 'assets/images/slots/slot_lights.png',
								0, 0, 0, tocolor( 255,220,0,255*a_anim*math.abs( math.sin( getTickCount(  ) * 0.0045 ) ) )
							)

						end

						local w,h = dxGetMaterialSize( element.textures.slots_roulette_rt )

						mta_dxDrawImage(
							800/2 - w/2, 600/2 - h/2 + 15,
							w,h, element.textures.slots_roulette_rt
						)

					dxSetRenderTarget(  )

					dxSetShaderValue( element.textures.shader, 'gTexture', element.textures.slots_rt )
					engineApplyShaderToWorldTexture( element.textures.shader, 'img1136712', object )

				end,



			},

			addEvent('casino.showSlotsCombination', true),
			addEventHandler('casino.showSlotsCombination', resourceRoot, function( combination )

				slotsWindow.active = true

				slotsWindow:showCombination( combination, function()

					setTimer(function()

						triggerServerEvent('casino.slots_giveCombinationPrize', resourceRoot)
						slotsWindow.active = false

					end, 1000, 1)

				end )
				
			end),

			showCombination = function(element, combination, callback)

				element:resetAnimations()

				for index = 1,3 do
					element.columns[index] = { element.columns[index][ #element.columns[index] ] }
				end

				for index = 1,3 do

					for i = 1, math.random( 20, 30 ) do

						local column = element.columns[index]
						local value = column[#column]

						table.insert( column, cycle(value + 1, 1, 5) )

					end

				end

				for index, value in pairs( combination ) do
					table.insert( element.columns[index], value )
				end

				for index, anim in pairs( element.animations ) do

					if index == #element.animations then
						timed_animate( anim, true, callback )
					else
						timed_animate( anim, true )
					end

				end


			end,

			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 798, 216
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/slots/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

				animate( element.active_anim, element.active and 1 or 0 )

			end,

			renderCamera = function()
				local anim = getAnimData( slotsWindow.camera_anim )
				setCameraMatrix( massInterpolate( slotsWindow.cameraEasing[1], slotsWindow.cameraEasing[2], anim, 'InOutQuad' ) )
			end,

			onInit = function(element)

				element.camera_anim = {}
				element.active_anim = {}

				setAnimData( element.active_anim, 0.1 )

				openHandlers.slots = function( _, marker, object )

					if currentWindowSection == 'slots' then

						local x,y,z = getElementPosition( object )
						local rx,ry,rz = getElementRotation( object )

						local fx,fy = getPointFromDistanceRotation( x,y, 1, -rz+180 )

						local cx,cy,cz, ex,ey,ez = getCameraMatrix()

						slotsWindow.cameraEasing = {
							{ cx,cy,cz, ex,ey,ez },
							{ fx,fy,z+0.5, x,y,z+0.2 },
						}

						addEventHandler('onClientRender', root, slotsWindow.renderCamera)

						localPlayer.alpha = 0

						setAnimData( slotsWindow.camera_anim, 0.03, 0 )
						animate( slotsWindow.camera_anim, 1 )

						hideBackground = true
						blurBackground = false

						slotsWindow:initSlots( object )

					end

					element.animationAlpha = {}
					setAnimData( element.animationAlpha, 0.1, 1 )


				end

				closeHandlers.slots = function( _, marker, object )

					if currentWindowSection == 'slots' then

						slotsWindow.cameraEasing = table.reverse( slotsWindow.cameraEasing )

						setAnimData( slotsWindow.camera_anim, 0.03, 0 )
						animate( slotsWindow.camera_anim, 1 )

						setTimer(function()

							removeEventHandler('onClientRender', root, slotsWindow.renderCamera)

							setCameraTarget( localPlayer, localPlayer )
							localPlayer.alpha = 255
							
						end, 1000, 1)

						clearTableElements( slotsWindow.textures )

					end

				end

			end,

			elements = {

				{'element',
					'center', 'top',
					'100%', 100,
					color = {255,255,255,255},

					onRender = function(element)

						local x,y,w,h = element.parent:abs()
						local alpha = element:alpha()

						drawImageSection(
							x,y,w,h, element.parent[6],
							{ x = 1, y = element[5]/h }, tocolor( 21, 21, 33, 255*alpha )
						)

					end,

					elements = {

						{'button',

							function(s,p) return p[4] - s[4] - 30 end, 'center',
							142, 42,

							bg = 'assets/images/slots/btn1_empty.png',
							activeBg = 'assets/images/slots/btn1.png',

							color = { 200,80,80,255 },
							'Выход',

							font = getFont('montserrat_bold', 18, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shadow = {
									['assets/images/slots/btn1_empty_shadow.png'] = (1-element.animData),
									['assets/images/slots/btn1_shadow.png'] = element.animData,
								}

								for path, anim in pairs( shadow ) do

									local texture = getDrawingTexture( path )

									local mw,mh = dxGetMaterialSize( texture )
									local mx,my = x+w/2-mw/2, y+h/2-mh/2

									dxDrawImage(
										mx,my,mw,mh, texture,
										0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
									)

								end

							end,

							onClick = function(element)

								if not slotsWindow.active then
									closeWindow()
								else
									return exports.hud_notify:notify( 'Ошибка', 'Дождитесь конца игры' )
								end

							end,

						},

						{'button',

							function(s,p) return p[4] - s[4]*2 - 50 end, 'center',
							142, 42,

							bg = 'assets/images/slots/btn1_empty.png',
							activeBg = 'assets/images/slots/btn1.png',

							color = { 200,80,80,255 },
							'Крутить',

							font = getFont('montserrat_bold', 18, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shadow = {
									['assets/images/slots/btn1_empty_shadow.png'] = (1-element.animData),
									['assets/images/slots/btn1_shadow.png'] = element.animData,
								}

								for path, anim in pairs( shadow ) do

									local texture = getDrawingTexture( path )

									local mw,mh = dxGetMaterialSize( texture )
									local mx,my = x+w/2-mw/2, y+h/2-mh/2

									dxDrawImage(
										mx,my,mw,mh, texture,
										0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
									)

								end

							end,

							onClick = function(element)

								if slotsWindow.active then return end

								local bet = tonumber( slots_betInput[6] ) or 0

								if bet <= 0 then
									return exports.hud_notify:notify('Ошибка', 'Введите ставку')
								end

								if bet < 10 then
									return exports.hud_notify:notify('Ошибка', 'Минимальная ставка - 10')
								end

								if bet > 3000 then
									return exports.hud_notify:notify('Ошибка', 'Максимальная ставка - 3000')
								end

								triggerServerEvent('casino.rollSlots', resourceRoot, bet)
								-- slots_betInput[6] = ''

							end,

						},

						{'rectangle',
							function(s,p) return p[4] - s[4] - 360 end, 'center',
							145, '100%',
							color = { 27,28,45, 255 },

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								drawSmartText(string.format('Ваш счёт <img>assets/images/chips.png</img>'),
									x, x + w, y + 35, 
									tocolor(255,255,255,255*alpha),
									tocolor(255,255,255,255*alpha),
									0.5, getFont('montserrat_bold', 24, 'light'),
									'center', 16, 0, 2
								)

								dxDrawText(('%s'):format( splitWithPoints( localPlayer:getData('casino.chips') or 0 ), '.' ),
									x, y + h - 25,
									x + w, y + h - 25,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_bold', 36, 'light'),
									'center', 'bottom'
								)

							end,

						},

						{'input',

							[2] = 30,
							[3] = 'center',
							[4]=213, [5]=54,
							[6] = '',

							type = 'number',

							placeholderColor = { 110, 110, 110, 255 },

							bg = 'assets/images/slots/input.png',

							color = { 27,28,45, 255 },

							font = getFont('montserrat_semibold', 24, 'light'),
							scale = 0.5,

							textPadding = 50,
							maxSymbols = 15,

							placeholder = 'Ваша ставка',

							variable = 'slots_betInput',

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local iw,ih = 30, 30
								local ix,iy = x + 20, y+h/2-ih/2

								dxDrawImage(
									ix,iy,iw,ih, 'assets/images/chips.png',
									0, 0, 0, tocolor(255,255,255,255*alpha)
								)

							end,

						}

					},

				},

				{'element',
					'center', 'bottom',
					'100%', function(s,p) return p[5] - 100 end,
					color = {255,255,255,255},

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawImage(
							x + 50, y + h/2 - 45/2,
							100, 45, 'assets/images/slots/jackpot.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawImage(
							x + 170, y + h/2 - 29/2,
							94, 29, 'assets/images/slots/hline2.png',
							0, 0, 0, tocolor(180,70,70,255*alpha)
						)

						drawSmartText(string.format('%s <img>assets/images/chips.png</img>',
							splitWithPoints( math.floor(
								resourceRoot:getData('slots.jackpot') or 0
							) , '.')
						),
							x + 290, x + 290, y+h/2 - 3, 
							tocolor(255,255,255,255*alpha),
							tocolor(255,255,255,255*alpha),
							0.5, getFont('montserrat_bold', 40, 'light'),
							'left', 23, 0, 1
						)

					end,

					elements = {

						{'button',

							function(s,p) return p[4] - s[4] - 50 end, 'center',
							274, 42,

							bg = 'assets/images/slots/btn2_empty.png',
							activeBg = 'assets/images/slots/btn2.png',

							color = { 200,80,80,255 },
							'Посмотреть комбинации',

							font = getFont('montserrat_semibold', 22, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shadow = {
									['assets/images/slots/btn2_empty_shadow.png'] = (1-element.animData),
									['assets/images/slots/btn2_shadow.png'] = element.animData,
								}

								for path, anim in pairs( shadow ) do

									local texture = getDrawingTexture( path )

									local mw,mh = dxGetMaterialSize( texture )
									local mx,my = x+w/2-mw/2, y+h/2-mh/2

									dxDrawImage(
										mx,my,mw,mh, texture,
										0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
									)

								end

							end,

							onClick = function(element)
								animate( combinationsWindow.animationAlpha, 1 )
								animate( slotsWindow.animationAlpha, 0 )
							end,

						},

					},

				},

			},


		},

		{'image',

			'center', 'center',
			495, 586, 
			color = { 25,24,38,255 },
			'assets/images/slots/cbg.png',

			variable = 'combinationsWindow',

			onInit = function(element)

				element.animationAlpha = {}
				setAnimData( element.animationAlpha, 0.1, 0 )

				openHandlers.combinations = function()
					combinationsWindow:updateTextures()
				end

			end,

			updateTextures = function(element)

				clearTableElements( element.textures or {} )
				element.textures = {}

				local w,h = 363, 59

				for index = 1,5 do

					element.textures[index] = dxCreateRenderTarget( w,h, true )

					dxSetBlendMode( 'modulate_add' )
					dxSetRenderTarget( element.textures[index] )

						local startX = 30

						local iw,ih = 35, 35
						local padding = 15

						mta_dxDrawImage(
							0, 0, w,h, 'assets/images/slots/crow.png',
							0, 0, 0, tocolor( 21,21,33,255 )
						)

						for i = 1,3 do

							mta_dxDrawImage(
								startX, h/2 - ih/2,
								iw,ih, ('assets/images/slots/icons/%s.png'):format( index )
							)

							startX = startX + iw + padding

						end

						if index == 5 then

							mta_dxDrawImage(
								startX , h/2 - 29/2,
								65, 29, 'assets/images/slots/hline.png',
								0, 0, 0, tocolor( 180,70,70,255 )
							)

							mta_dxDrawText(
								'Джекпот',
								w - 70, -5,
								w - 70, h,
								tocolor(255,255,255,255),
								0.5, 0.5, getFont('montserrat_bold', 25, 'light'),
								'center', 'center'
							)


						else

							mta_dxDrawImage(
								startX, h/2 - 29/2,
								65, 29, 'assets/images/slots/hline.png',
								0, 0, 0, tocolor( 180,70,70,255 )
							)

							mta_dxDrawText(
								('x%s'):format( Config.games.slots.prizes[index].mul ),
								w - 70, -5,
								w - 70, h,
								tocolor(255,255,255,255),
								0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
								'center', 'center'
							)

						end


					dxSetRenderTarget(  )
					dxSetBlendMode( 'blend' )

				end

			end,

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local shw,shh = 523, 614
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2

				dxDrawImage(
					shx, shy + 5, shw, shh, 'assets/images/slots/cbg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + 30, y + 30,
					82, 57, 'assets/images/slots/logo.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				dxDrawText('Выигрышные комбинации',
					x + 30 + 82, y + 30,
					x + 30 + 82, y + 30 + 57,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'left', 'center'
				)

				dxDrawText('1% от каждой ставки идет в общий банк джекпота',
					x, y + h - 39,
					x + w, y + h - 39,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 20, 'light'),
					'center', 'bottom'
				)


				dxDrawText('Джекпот достается одному игроку в случайный момент',
					x, y + h - 25,
					x + w, y + h - 25,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold', 20, 'light'),
					'center', 'bottom'
				)

				local startY = y + 120

				local iw,ih = 363, 59
				local padding = 20

				for _, texture in pairs( element.textures or {} ) do

					dxDrawImage(
						x+w/2-iw/2, startY,
						iw,ih, texture,
						0, 0, 0, tocolor(255,255,255,255*alpha)
					)

					startY = startY + ih + padding

				end

			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 35 end, 46,
					26, 26,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {255, 255, 255, 255},
					activeColor = {255, 255, 255, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function(element)
						animate( combinationsWindow.animationAlpha, 0 )
						animate( slotsWindow.animationAlpha, 1 )
					end,

				},


			},

		},

	},

	russian_start = {

		{'image',

			'center', ( real_sy - px( 180 ) ) * sx/real_sx,
			803, 130,
			color = { 25,24,38,255 },
			'assets/images/russian/bg.png',

			variable = 'russianWindow',

			onInit = function(element)

				element.camera_anim = {}

				openHandlers.russian_start = function( _, marker, game )

					if currentWindowSection:find('russian_') then

						hideBackground = true
						blurBackground = false

						russianWindow.marker = marker

					end

					if currentWindowSection == 'russian_game' then

						russianWindow.marker = game.marker
						dialog('Русская рулетка', {
							('Ставка - %s'):format( splitWithPoints( game.bet, '.' ) ),
							'Присоединиться?',
						}, function( result )

							if result then
								triggerServerEvent('casino.joinRussianGame', resourceRoot, russianWindow.marker)
							else
								closeWindow()
							end

						end)

					end

				end

				closeHandlers.russian_start = function( _, marker, object )

					if currentWindowSection:find('russian_') then

						setTimer(function()

							hideBackground = false
							blurBackground = true
							
						end, 1000, 1)

						russianWindow.game = nil

						removeBindHandler( russianWindow.marker )

					end

				end

			end,

			addEvent('russian.gameDialog', true),
			addEventHandler('russian.gameDialog', resourceRoot, function( game )

				russianWindow.marker = game.marker
				dialog('Русская рулетка', {
					('Ставка - %s'):format( splitWithPoints( game.bet, '.' ) ),
					'Присоединиться?',
				}, function( result )

					if result then
						triggerServerEvent('casino.joinRussianGame', resourceRoot, russianWindow.marker)
					else
						closeWindow()
					end

				end)

			end),

			addEvent('casino.syncRussianGame', true),
			addEventHandler('casino.syncRussianGame', resourceRoot, function( game )
				russianWindow.game = game
			end),

			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 827, 154
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/slots/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local gradient = getTextureGradient( getDrawingTexture( element[6] ), {

					alpha = alpha,
					angle = 180,
					color = {
						{ 0, 0, 0, 0 },
						{ 180, 70, 70, 100 },
					},

				} )

			--	dxDrawImage(x,y,w,h, gradient)

		--		dxDrawImage(x,y,w,h, 'assets/images/russian/bg1.png',0, 0, 0, tocolor(255, 255, 255, 50*alpha))

				if element.game then

					local timestamp = getServerTimestamp()
					local created = element.game.created

					local delta = (Config.games.russian.timeout/1000) - (timestamp.timestamp - created)

					local m = math.floor( delta/60 )
					local s = delta - m*60

					dxDrawText(('%02d:%02d'):format( m,s ),
						x + 90, y + h/2 + 15,
						x + 90, y + h/2 + 15,
						tocolor(194, 133, 40, 255*alpha),
						0.5, 0.5, getFont('montserrat_bold', 50, 'light'),
						'center', 'bottom'
					)

					dxDrawText('Ожидание',
						x + 90, y + h/2 + 7,
						x + 90, y + h/2 + 7,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
						'center', 'top'
					)

				end

				dxDrawText(('Комиссия на игру - %s%%'):format( Config.games.russian.comission ),
					x, y+h+10,
					x+w, y+h+10,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'center', 'top'
				)

			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 60 end, 'center',
					35, 35,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {255, 255, 255, 255},
					activeColor = {255, 255, 255, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function()

						if russianWindow.game then
							if russianWindow.game.created and not russianWindow.game.started then
								return exports.hud_notify:notify( 'Ошибка', 'Дождитесь ожидания' )
							elseif russianWindow.game.created then
								return exports.hud_notify:notify( 'Ошибка', 'Дождитесь конца игры' )
							end
						end
						
						closeWindow()

					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 150 end,
					'center',
					201, 60,

					bg = 'assets/images/russian/btn.png',

					color = { 255,255,255,255 },
					'Сделать ставку',

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/russian/btn_shadow.png'] = element.animData,
						}

						for path, anim in pairs( shadow ) do

							local texture = getDrawingTexture( path )

							local mw,mh = dxGetMaterialSize( texture )
							local mx,my = x+w/2-mw/2, y+h/2-mh/2

							dxDrawImage(
								mx,my,mw,mh, texture,
								0, 0, 0, tocolor(0,0,0, 0*alpha*anim)
							)

						end

					end,

					onClick = function(element)

						local bet = tonumber( russian_betInput[6] ) or 0

						if bet < 50 then
							return exports.hud_notify:notify('Ошибка', 'Минимальная ставка - 50')
						end

						triggerServerEvent('casino.createRussianGame', resourceRoot, russianWindow.marker, bet)
						russian_betInput[6] = ''

					end,


				},

				{'input',

					160,
					'center',
					267, 60,

					bg = 'assets/images/russian/input.png',

					color = { 27,27,44,255 },
					'',

					placeholderColor = { 255, 255, 255, 255 },
					placeholder = 'Сумма ставки',

					variable = 'russian_betInput',

					textPadding = 20,

					maxSymbols = 35,
					type = 'number',

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local iw,ih = 30, 30
						local ix,iy = x+w - iw - 20, y+h/2-ih/2

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/chips.png',
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

					end,

				},

			},

		},

	},

	bones_start = {

		{'image',

			'center', ( real_sy - px( 180 ) ) * sx/real_sx,
			803, 130,
			color = { 25,24,38,255 },
			'assets/images/bones/bg.png',

			variable = 'bonesWindow',

			renderCamera = function()

				local anim = getAnimData( bonesWindow.camera_anim )
				local x,y,z, tx,ty,tz = massInterpolate( bonesWindow.cameraEasing[1], bonesWindow.cameraEasing[2], anim, 'InOutQuad' )
				setCameraMatrix( x,y,z, tx,ty,tz )

			end,

			onInit = function(element)

				element.camera_anim = {}

				openHandlers.bones_start = function( _, marker, game )

					if currentWindowSection:find('bones_') then

						hideBackground = true
						blurBackground = false

						bonesWindow.marker = marker

						local x,y,z = getElementPosition(marker.parent)
						local cx,cy,cz, tx,ty,tz = getCameraMatrix()

						local ox,oy,oz = getPositionFromElementOffset( marker.parent, 0, 0.5, 0 )

						bonesWindow.cameraEasing = {
							{ cx,cy,cz, tx,ty,tz },
							{ ox,oy,oz+3, x,y,z },
						}

						setAnimData( bonesWindow.camera_anim, 0.03, 0 )
						animate( bonesWindow.camera_anim, 1 )

						addEventHandler('onClientRender', root, bonesWindow.renderCamera)

						localPlayer.alpha = 0

					end

					if currentWindowSection == 'bones_game' then

						bonesWindow.marker = game.marker
						dialog('Кости', {
							('Соперник - %s'):format( game.creator.name ),
							('Ставка - %s'):format( splitWithPoints( game.bet, '.' ) ),
							('Комиссия на игру - %s%%'):format( Config.games.bones.comission ),
						}, function( result )

							if result then
								triggerServerEvent('casino.joinBonesGame', resourceRoot, bonesWindow.marker)
							else
								closeWindow()
							end

						end)

					end

				end

				closeHandlers.bones_start = function( _, marker, object )

					if currentWindowSection:find('bones_') then

						bonesWindow.cameraEasing[1] = table.copy( bonesWindow.cameraEasing[2] )
						bonesWindow.cameraEasing[2] = table.copy( bonesWindow.cameraEasing[1] )
						bonesWindow.cameraEasing[2][3] = bonesWindow.cameraEasing[2][3] + 1

						setAnimData( bonesWindow.camera_anim, 0.03, 0 )
						animate( bonesWindow.camera_anim, 1 )

						setTimer(function()

							removeEventHandler('onClientRender', root, bonesWindow.renderCamera)

							setCameraTarget( localPlayer, localPlayer )
							localPlayer.alpha = 255

							hideBackground = false
							blurBackground = true
							
						end, 1000, 1)

						bonesWindow.game = nil

						triggerServerEvent('casino.cancelBonesGame', resourceRoot)
						removeBindHandler( bonesWindow.marker )

					end

				end

			end,

			addEvent('bones.gameDialog', true),
			addEventHandler('bones.gameDialog', resourceRoot, function( game )

				bonesWindow.marker = game.marker
				dialog('Кости', {
					('Соперник - %s'):format( game.creator.name ),
					('Ставка - %s'):format( splitWithPoints( game.bet, '.' ) ),
				}, function( result )

					if result then
						triggerServerEvent('casino.joinBonesGame', resourceRoot, bonesWindow.marker)
					else
						closeWindow()
					end

				end)

			end),

			addEvent('casino.syncBonesGame', true),
			addEventHandler('casino.syncBonesGame', resourceRoot, function( game )
				bonesWindow.game = game
			end),

			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 827, 154
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/slots/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local gradient = getTextureGradient( getDrawingTexture( element[6] ), {

					alpha = alpha,
					angle = 180,
					color = {
						{ 0, 0, 0, 0 },
						{ 180, 70, 70, 100 },
					},

				} )

			--	dxDrawImage(x,y,w,h, gradient)

		--		dxDrawImage(x,y,w,h, 'assets/images/bones/bg1.png',0, 0, 0, tocolor(255, 255, 255, 50*alpha))

				if element.game then

					local timestamp = getServerTimestamp()
					local created = element.game.created

					local delta = (Config.games.bones.timeout/1000) - (timestamp.timestamp - created)

					local m = math.floor( delta/60 )
					local s = delta - m*60

					dxDrawText(('%02d:%02d'):format( m,s ),
						x + 90, y + h/2 + 15,
						x + 90, y + h/2 + 15,
						tocolor(194, 133, 40, 255*alpha),
						0.5, 0.5, getFont('montserrat_bold', 50, 'light'),
						'center', 'bottom'
					)

					dxDrawText('Ожидание',
						x + 90, y + h/2 + 7,
						x + 90, y + h/2 + 7,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
						'center', 'top'
					)

				end

				dxDrawText(('Комиссия на игру - %s%%'):format( Config.games.bones.comission ),
					x, y+h+10,
					x+w, y+h+10,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'center', 'top'
				)

			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 60 end, 'center',
					35, 35,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {255, 255, 255, 255},
					activeColor = {255, 255, 255, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function()

						if bonesWindow.game then
							if bonesWindow.game.created and not bonesWindow.game.started then
								return exports.hud_notify:notify( 'Ошибка', 'Дождитесь ожидания' )
							elseif bonesWindow.game.created then
								return exports.hud_notify:notify( 'Ошибка', 'Дождитесь конца игры' )
							end
						end
						
						closeWindow()

					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 150 end,
					'center',
					201, 60,

					bg = 'assets/images/bones/btn.png',

					color = { 255,255,255,255 },
					'Сделать ставку',

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/bones/btn_shadow.png'] = element.animData,
						}

						for path, anim in pairs( shadow ) do

							local texture = getDrawingTexture( path )

							local mw,mh = dxGetMaterialSize( texture )
							local mx,my = x+w/2-mw/2, y+h/2-mh/2

						--	dxDrawImage(mx,my,mw,mh, texture,0, 0, 0, tocolor(200,90,90, 255*alpha*anim))

						end

					end,

					onClick = function(element)

						local bet = tonumber( bones_betInput[6] ) or 0

						if bet < 10 then
							return exports.hud_notify:notify('Ошибка', 'Минимальная ставка - 10')
						end

						triggerServerEvent('casino.createBonesGame', resourceRoot, bet, bonesWindow.marker)
						bones_betInput[6] = ''

					end,


				},

				{'input',

					160,
					'center',
					267, 60,

					bg = 'assets/images/bones/input.png',

					color = { 27,27,44,255 },
					'',

					placeholderColor = { 255, 255, 255, 255 },
					placeholder = 'Сумма ставки',

					variable = 'bones_betInput',

					textPadding = 20,

					maxSymbols = 15,
					type = 'number',

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local iw,ih = 30, 30
						local ix,iy = x+w - iw - 20, y+h/2-ih/2

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/chips.png',
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

					end,

				},

			},

		},

	},

	bones_game = {

		{'image',

			'center', 40,
			818, 158,
			'assets/images/bones/game_bg.png',
			color = { 25,24,38, 255 },

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				if bonesWindow.game and bonesWindow.game.started then

					local sum = getBonesSum( bonesWindow.game.throw_session or {} )

					dxDrawText(localPlayer.name,
						x + 90, y + 50,
						x + 90, y + 50,
						tocolor( 255,255,255,255*alpha ),
						0.5, 0.5, getFont('montserrat_semibold', 33, 'light'),
						'left', 'top'
					)

					dxDrawText('Очки: #cd4949' .. (sum[localPlayer] or 0),
						x + 90, y + 75,
						x + 90, y + 75,
						tocolor( 255,255,255,255*alpha ),
						0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
						'left', 'top', false, false, false, true
					)

					local op_player = bonesWindow.game.creator == localPlayer and bonesWindow.game.player or bonesWindow.game.creator

					if isElement(op_player) then

						dxDrawText(op_player.name,
							x + w - 90, y + 50,
							x + w - 90, y + 50,
							tocolor( 255,255,255,255*alpha ),
							0.5, 0.5, getFont('montserrat_semibold', 33, 'light'),
							'right', 'top'
						)

						dxDrawText('Очки: #cd4949' .. (sum[op_player] or 0),
							x + w - 90, y + 75,
							x + w - 90, y + 75,
							tocolor( 255,255,255,255*alpha ),
							0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
							'right', 'top', false, false, false, true
						)

					end

					local y_add = 0

					local last_throw = bonesWindow.game.throw_session[ #bonesWindow.game.throw_session ]
					local last_player = last_throw and last_throw.player or bonesWindow.game.creator

					if #bonesWindow.game.throw_session < 6 then

						if last_player ~= localPlayer and not bonesWindow.game.throwing then

							dxDrawText('#cd4949F#ffffff - бросить кубик',
								x, y + 30,
								x + w, y + 30,
								tocolor( 255, 255, 255, 255*alpha * ( math.abs( math.sin( getTickCount(  ) * 0.0015 ) ) ) ),
								0.5, 0.5, getFont('montserrat_semibold', 35, 'light'),
								'center', 'top', false, false, false, true
							)

							y_add = 15

						end

					else

						if isElement(op_player) then

							local winner, looser, deadheat

							if sum[ localPlayer ] > sum[ op_player ] then
								winner = localPlayer
							elseif sum[ localPlayer ] < sum[ op_player ] then
								winner = op_player
							else
								deadheat = true
							end

							local bw,bh = 201, 70

							local wx
							local wy = y - bh/2

							local r,g,b = 180, 70, 70

							if winner == localPlayer then

								wx = x + 30
								wy = wy + 15

								r,g,b = 0,180,60

							elseif winner == op_player then

								wx = x + w - 30 - bw

							else

								wx = x + w/2 - bw/2

							end

							dxDrawImage(
								wx, wy,
								bw, bh, 'assets/images/bones/winner.png',
								0, 0, 0, tocolor( r,g,b, 255*alpha )
							)

							dxDrawText(deadheat and 'Ничья!' or 'Победитель',
								wx, wy,
								wx + bw, wy + bh,
								tocolor( 255,255,255,255*alpha ),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'center', 'center'
							)

						end


					end

					dxDrawText('Общая ставка',
						x, y + 50 + y_add,
						x + w, y + 50 + y_add,
						tocolor( 255,255,255,255*alpha ),
						0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
						'center', 'top'
					)

					drawSmartText(string.format('%s <img>assets/images/chips.png</img>',
						splitWithPoints( math.floor(
							bonesWindow.game.bet * 2
						) , '.')
					),
						x, x+w, y + 90 + y_add, 
						tocolor(255,255,255,255*alpha),
						tocolor(255,255,255,255*alpha),
						0.5, getFont('montserrat_bold', 45, 'light'),
						'center', 23, 0, 2
					)

				end

			end,

			onKey = {

				f = function()
					triggerServerEvent('casino.throwBones', resourceRoot, bonesWindow.marker)
				end,

			},


		},

	},

	roulette = {

		{'element',
			50, 80, 
			300, 300,
			color = {255,255,255,255},

			variable = 'rouletteLog',

			log = {},

			log_rows = 30,

			addEvent('casino.rouletteLog', true),
			addEventHandler('casino.rouletteLog', resourceRoot, function( text, marker )

				if currentWindowSection == 'roulette' and windowOpened then
					rouletteLog:addRow( text )
				end

			end),

			onInit = function( element )

				openHandlers.roulette_log = function()

					rouletteLog:clear()

				end

			end,

			addRow = function(element, text)

				if #element.log >= element.log_rows then
					table.remove( element.log, 1 )
				end

				table.insert( element.log, text )

			end,

			clear = function(element)
				element.log = {}
			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local startY = y
				local padding = 18

				if #element.log > 0 then

					dxDrawText('Ваши действия',
						x, y - 5, x, y - 5,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
						'left', 'bottom'
					)

				end

				for _, row in pairs( element.log ) do

					dxDrawText(row,
						x, startY,
						x, startY,
						tocolor( 255,255,255,255*alpha ),
						0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
						'left', 'top'
					)

					startY = startY + padding

				end

			end,



		},

		{'image',

			'center', ( real_sy - px( 180 ) ) * sx/real_sx,
			833, 130,
			color = { 25,24,38,255 },
			'assets/images/bones/bg.png',

			variable = 'rouletteWindow',
			bet_objects = {},

			objects_pos = {

				[0] = { -0.02, -0.38, 0.45, 0 },
				[1] = { 0.12, -0.28, 0.45, 0 },
				[2] = { -0.02, -0.28, 0.45, 0 },
				[3] = { -0.17, -0.28, 0.45, 0 },
				[4] = { 0.12, -0.16, 0.45, 0 },
				[5] = { -0.02, -0.17, 0.45, 0 },
				[6] = { -0.17, -0.17, 0.45, 0 },
				[7] = { 0.12, -0.07, 0.45, 0 },
				[8] = { -0.02, -0.06, 0.45, 0 },
				[9] = { -0.17, -0.06, 0.45, 0 },
				[10] = { 0.12, 0.05, 0.45, 0 },
				[11] = { -0.02, 0.05, 0.45, 0 },
				[12] = { -0.17, 0.05, 0.45, 0 },
				[13] = { 0.12, 0.15, 0.45, 0 },
				[14] = { -0.03, 0.15, 0.45, 0 },
				[15] = { -0.17, 0.15, 0.45, 0 },
				[16] = { 0.12, 0.26, 0.45, 0 },
				[17] = { -0.03, 0.26, 0.45, 0 },
				[18] = { -0.17, 0.26, 0.45, 0 },
				[19] = { 0.12, 0.37, 0.45, 0 },
				[20] = { -0.02, 0.36, 0.45, 0 },
				[21] = { -0.16, 0.36, 0.45, 0 },
				[22] = { 0.11, 0.47, 0.45, 0 },
				[23] = { -0.03, 0.48, 0.45, 0 },
				[24] = { -0.17, 0.48, 0.45, 0 },
				[25] = { 0.12, 0.58, 0.45, 0 },
				[26] = { -0.02, 0.59, 0.45, 0 },
				[27] = { -0.17, 0.58, 0.45, 0 },
				[28] = { 0.12, 0.69, 0.45, 0 },
				[29] = { -0.02, 0.69, 0.45, 0 },
				[30] = { -0.17, 0.69, 0.45, 0 },
				[31] = { 0.12, 0.8, 0.45, 0 },
				[32] = { -0.02, 0.79, 0.45, 0 },
				[33] = { -0.16, 0.8, 0.45, 0 },
				[34] = { 0.13, 0.91, 0.45, 0 },
				[35] = { -0.01, 0.9, 0.45, 0 },
				[36] = { -0.16, 0.91, 0.45, 0 },
				['odd'] = { 0.33, 0.63, 0.45, 0 },
				['even'] = { 0.33, -0.01, 0.45, 0 },
				['1st_12'] = { 0.24, -0.12, 0.45, 0 },
				['2nd_12'] = { 0.24, 0.31, 0.45, 0 },
				['3rd_12'] = { 0.24, 0.74, 0.45, 0 },
				['1_row'] = { 0.12, 1.01, 0.45, 0 },
				['2_row'] = { -0.02, 1.01, 0.45, 0 },
				['3_row'] = { -0.16, 1.01, 0.45, 0 },
				['1_to_18'] = { 0.34, -0.23, 0.45, 0 },
				['19_to_36'] = { 0.34, 0.86, 0.45, 0 },
				['red'] = { 0.33, 0.2, 0.45, 0 },
				['black'] = { 0.34, 0.42, 0.45, 0 },

			},

			addEvent('casino.syncRoulette', true),
			addEventHandler('casino.syncRoulette', resourceRoot, function( data )
				rouletteWindow.roulette_data = data
			end),

			addEvent('casino.addRouletteBetObject', true),
			addEventHandler('casino.addRouletteBetObject', resourceRoot, function( base, bet )

				if not rouletteWindow.roulette_data then return end
				if rouletteWindow.roulette_data.base ~= base then return end

				local pos = rouletteWindow.objects_pos[ tonumber(bet) or bet ]
				local x,y,z = getPositionFromElementOffset( base, unpack( pos ) )

				local object = createObject( 3024, x,y,z )

				object.dimension = Config.casinoInterior.dimension
				object.interior = Config.casinoInterior.interior

				table.insert( rouletteWindow.bet_objects, object )

			end),

			addEvent('casino.clearRouletteBetObjects', true),
			addEventHandler('casino.clearRouletteBetObjects', resourceRoot, function( base)

				if not rouletteWindow.roulette_data then return end
				if rouletteWindow.roulette_data.base ~= base then return end

				clearTableElements( rouletteWindow.bet_objects or {} )
				rouletteWindow.bet_objects = {}

			end),

			getPlayerBetsCount = function(element)

				local player_bets = 0

				for _, bet in pairs( element.roulette_data.bets or {} ) do

					if bet.player == localPlayer then

						player_bets = player_bets + 1

					end

				end

				return player_bets

			end,

			canPlayerPlaceBet = function(element)
				return element:getPlayerBetsCount() < Config.games.roulette.bet_limit
			end,

			onRender = {

				function(element)

					if not element.selected_bet then
						element[2] = sx/2 - 500/2
						element[4] = 500
						element[6] = 'assets/images/roulette/bg1.png'
					else
						element[2] = sx/2 - 833/2
						element[4] = 833
						element[6] = 'assets/images/bones/bg.png'
					end

					element.elements.close[2] = element[4] - element.elements.close[4] - 40

				end,

				function(element)

					local alpha = element:alpha()
					local x,y,w,h = element:abs()

					local gradient = getTextureGradient( getDrawingTexture( element[6] ), {

						alpha = alpha,
						angle = 180,
						color = {
							{ 0, 0, 0, 255 },
							{ 0, 0, 0, 255 },
						},

					} )

					--dxDrawImage(x,y,w,h, gradient)

					local bets = element.roulette_data.bets
					local player_bets = element:getPlayerBetsCount()

					if player_bets > 0 then

						dxDrawText('Зажмите ALT, чтобы увидеть свои ставки',
							x, y + h + 10,
							x + w, y + h + 10,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
							'center', 'top', false, false, false, true
						)

					end

					local obj_alpha = getKeyState( 'lalt' ) and 255 or 0

					for _, object in pairs( element.bet_objects or {} ) do
						object.alpha = obj_alpha
					end


					if not element.selected_bet then

						if element:canPlayerPlaceBet() then

							dxDrawText('Сделайте ставку',
								x + 40, y+h/2-2,
								x + 40, y+h/2-2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 35, 'light'),
								'left', 'bottom'
							)

							dxDrawText('Наведитесь на любое поле',x + 40, y+h/2,x + 40, y+h/2,tocolor(255,255,255,67*alpha),0.5, 0.5, getFont('montserrat_medium', 21, 'light'),'left', 'top')

							dxDrawText('и нажмите ЛКМ',x + 40, y+h/2+15,
								x + 40, y+h/2+15,
								tocolor(255,255,255,67*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
								'left', 'top'
							)

						else

							dxDrawText('Вы сделали ставки',
								x + 40, y+h/2-2,
								x + 40, y+h/2-2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 35, 'light'),
								'left', 'bottom'
							)

							dxDrawText('Дождитесь окончания игры',
								x + 40, y+h/2,
								x + 40, y+h/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
								'left', 'top'
							)

							dxDrawText('и результата рулетки',
								x + 40, y+h/2+15,
								x + 40, y+h/2+15,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
								'left', 'top'
							)

						end


					end

					local bet_name 

					local bet = element.selected_bet or element.current_bet
					if not bet then return end

					local config = Config.games.roulette.bets

					local bet_name = config[bet] and config[bet].name or tostring(bet)
					local bet_mul = config[bet] and config[bet].mul or config.default.mul

					dxDrawText('Ваша ставка - '..bet_name,
						x + 20, y - 20,
						x + 20, y - 20,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 30, 'light'),
						'left', 'bottom'
					)

					dxDrawText('Множитель - x'..bet_mul,
						x + w - 20, y - 20,
						x + w - 20, y - 20,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 30, 'light'),
						'right', 'bottom'
					)


				end,

				timer = function(element)

					if element.roulette_data.timer_started and not element.roulette_data.active then

						local alpha = element:alpha()

						local server_timestamp = getServerTimestamp().timestamp

						local delta = ( math.floor( Config.games.roulette.timeout/1000 ) ) -
							(server_timestamp - element.roulette_data.timer_started)

						delta = math.max( delta, 0 )

						local m = math.floor( delta/60 )
						local s = delta - m*60

						dxDrawText(('%02d:%02d'):format( m,s ),
							0, 30, sx, 30,
							tocolor( 255,255,255,255*alpha ),
							0.5, 0.5, getFont('montserrat_bold', 40, 'light'),
							'center', 'top'
						)

					end

				end,

				bet = function(element)

					local nearest = {}

					local x,y = getCursorPosition()
					if not x then return end

					x,y = x*real_sx, y*real_sy

					local rx,ry,rz = getWorldFromScreenPosition( x,y, 1000 )
					local cx,cy,cz = getCameraMatrix()

					local hit, hx,hy,hz = processLineOfSight(
						cx,cy,cz, rx,ry,rz
					)

					for bet, pos in pairs( element.objects_pos ) do

						local nx,ny,nz = getPositionFromElementOffset( rouletteWindow.roulette_data.base, unpack( pos ) )

						if bet == element.selected_bet then
							nearest = { dist = 0, bet = bet, pos = {nx,ny,nz} }
							break
						end

						local dist = getDistanceBetweenPoints3D( hx,hy,hz, nx,ny,nz )

						if not nearest.dist or (dist < nearest.dist) then
							nearest = { dist = dist, bet = bet, pos = {nx,ny,nz} }
						end

					end

					if nearest.dist > 0.2 or ( not rouletteWindow:canPlayerPlaceBet() ) then

						element.object.dimension = 0
						element.current_bet = nil

					else

						local x,y,z = unpack( nearest.pos )

						local z_add = 0.1 * getEasingValue( math.abs( math.sin( getTickCount(  ) * 0.0005 ) ), 'InOutQuad' )

						setElementPosition( element.object, x,y,z + z_add )

						element.object.dimension = Config.casinoInterior.dimension
						element.current_bet = nearest.bet

					end

				end,

			},

			renderCamera = function()

				local anim = getAnimData( rouletteWindow.camera_anim )
				local x,y,z, tx,ty,tz = massInterpolate( rouletteWindow.cameraEasing[1], rouletteWindow.cameraEasing[2], anim, 'InOutQuad' )
				setCameraMatrix( x,y,z, tx,ty,tz )

			end,

			onInit = function(element)

				element.camera_anim = {}

				openHandlers.roulette = function( _, data )

					if currentWindowSection == 'roulette' then

						rouletteWindow.object = createObject( 3024, 0, 0, 0 )
						rouletteWindow.object.alpha = 150

						rouletteWindow.roulette_data = data
						rouletteWindow.selected_bet = nil

						rouletteWindow.object.interior = Config.casinoInterior.interior

						local x,y,z = getElementPosition(data.base)
						local cx,cy,cz, tx,ty,tz = getCameraMatrix()

						local ox,oy,oz = getPositionFromElementOffset( data.base, 0.5, 0, 0 )

						rouletteWindow.cameraEasing = {
							{ cx,cy,cz, tx,ty,tz },
							{ ox,oy,oz+3, x,y,z },
						}

						addEventHandler('onClientRender', root, rouletteWindow.renderCamera)

						localPlayer.alpha = 0

						setAnimData( rouletteWindow.camera_anim, 0.03, 0 )
						animate( rouletteWindow.camera_anim, 1 )

						hideBackground = true
						blurBackground = false

					end

				end

				closeHandlers.roulette = function( _, marker, object )

					if currentWindowSection == 'roulette' then

						rouletteWindow.cameraEasing[1] = table.copy( rouletteWindow.cameraEasing[2] )
						rouletteWindow.cameraEasing[2] = table.copy( rouletteWindow.cameraEasing[1] )
						rouletteWindow.cameraEasing[2][3] = rouletteWindow.cameraEasing[2][3] - 1

						setAnimData( rouletteWindow.camera_anim, 0.03, 0 )
						animate( rouletteWindow.camera_anim, 1 )

						clearTableElements( rouletteWindow.bet_objects )
						rouletteWindow.bet_objects = {}

						setTimer(function()

							removeEventHandler('onClientRender', root, rouletteWindow.renderCamera)

							setCameraTarget( localPlayer, localPlayer )
							localPlayer.alpha = 255

							hideBackground = false
							blurBackground = true
							
						end, 1000, 1)

						if isElement(rouletteWindow.object) then
							destroyElement(rouletteWindow.object)
						end

					end

				end

			end,

			addEventHandler('onClientClick', root, function( button, state )

				if state == 'down' and windowOpened and currentWindowSection == 'roulette' and rouletteWindow.current_bet then

					if button == 'left' then

						if rouletteWindow.current_bet then

							if not rouletteWindow:canPlayerPlaceBet() then
								return exports.hud_notify:notify(
									'Превышен лимит ставок', ('Максимум %s на стол'):format(Config.games.roulette.bet_limit)
								)
							end

							rouletteWindow.selected_bet = rouletteWindow.current_bet

						end

					end

				end

			end),

			elements = {

				close = {'button',

					function(s,p) return p[4] - s[4] - 40 end, 'center',
					35, 35,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {255, 255, 255, 35},
					activeColor = {255, 255, 255, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,


					onClick = function(element)

						if element.parent.roulette_data then

							for _, bet in pairs( element.parent.roulette_data.bets or {} ) do
								if bet.player == localPlayer then
									return exports.hud_notify:notify( 'Ошибка', 'Дождитесь конца игры' )
								end
							end

						end

						closeWindow()

					end,

				},

				{'input',

					50, 'center',
					247, 60,

					bg = 'assets/images/bones/input.png',

					color = { 255,255,255,255 },
					'',

					placeholderColor = { 255, 255, 255, 255 },
					placeholder = 'Сумма ставки',

					variable = 'roulette_betInput',

					textPadding = 20,

					maxSymbols = 15,
					type = 'number',

					noDraw = function(element)
						return not element.parent.selected_bet
					end,

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local iw,ih = 30, 30
						local ix,iy = x+w - iw - 20, y+h/2-ih/2

					--	dxDrawImage(ix,iy,iw,ih, 'assets/images/chips.png',0, 0, 0, tocolor( 255,255,255,255*alpha ))

					end,

				},

				{'button',

					310, 'center',
					201, 60,

					bg = 'assets/images/bones/btn.png',

					color = { 255,255,255,255 },
					'Сделать ставку',

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					noDraw = function(element)
						return not element.parent.selected_bet
					end,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/bones/btn_shadow.png'] = element.animData,
						}

						for path, anim in pairs( shadow ) do

							local texture = getDrawingTexture( path )

							local mw,mh = dxGetMaterialSize( texture )
							local mx,my = x+w/2-mw/2, y+h/2-mh/2

						--	dxDrawImage(mx,my,mw,mh, texture,0, 0, 0, tocolor(0,0,0, 0*alpha*anim))

						end

					end,

					onClick = function(element)

						if not element.parent.selected_bet then return end

						local bet = tonumber( roulette_betInput[6] ) or 0

						if bet <= 0 then
							return exports.hud_notify:notify('Ошибка', 'Введите ставку')
						end

						if bet < 10 then
							return exports.hud_notify:notify('Ошибка', 'Минимальная ставка - 10')
						end

						triggerServerEvent('casino.setRouletteBet', resourceRoot,
							rouletteWindow.roulette_data.marker, element.parent.selected_bet, bet
						)

						element.parent.selected_bet = nil
						roulette_betInput[6] = ''

					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 110 end, 'center',
					201, 60,

					bg = 'assets/images/bones/btn.png',

					color = { 255,255,255,255 },
					'Отменить выбор',

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/bones/btn_shadow.png'] = element.animData,
						}

						for path, anim in pairs( shadow ) do

							local texture = getDrawingTexture( path )

							local mw,mh = dxGetMaterialSize( texture )
							local mx,my = x+w/2-mw/2, y+h/2-mh/2

							--dxDrawImage(mx,my,mw,mh, texture,0, 0, 0, tocolor(0,0,0, 0*alpha*anim))

						end

					end,

					noDraw = function(element)
						return not element.parent.selected_bet
					end,

					onRender = function(element)

						element.onClick = (element.parent.selected_bet) and element._onClick or nil

					end,

					_onClick = function(element)
						element.parent.selected_bet = nil
					end,

				},

			},

		},

	},

	blackjack_bet = {

		{'image',

			'center', 'center',
			455, 415,
			'assets/images/blackjack/bet/bg.png',
			color = {25,24,38,255},

			variable = 'blackjackWindow',

			onInit = function(element)

				openHandlers.blackjack_bet = function( _, blackjack_data )

					if currentWindowSection:find('blackjack') then

						if blackjack_data then
							blackjackWindow.blackjack_data = blackjack_data
						end

					end

				end

			end,

			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 481, 441
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/blackjack/bet/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local lw,lh = 162, 72
				local lx,ly = x+w/2-lw/2, y + 60

				dxDrawImage(
					lx,ly,lw,lh, 'assets/images/blackjack/bet/logo.png',
					0, 0, 0, tocolor( 255,255,255,255*alpha )
				)

				dxDrawText('Суть игры - набрать больше очков,\nчем у противника, но не превысить 21',
					x, y + 155,
					x+w, y + 155,
					tocolor( 255,255,255,255*alpha ),
					0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
					'center', 'top'
				)

			end,

			elements = {

				{'input',

					'center',
					230,
					242,48,
					[6] = '',

					type = 'number',

					placeholderColor = { 110, 110, 110, 255 },

					bg = 'assets/images/blackjack/bet/input.png',

					color = { 21,21,33, 255 },

					font = getFont('montserrat_semibold', 24, 'light'),
					scale = 0.5,

					textPadding = 50,
					maxSymbols = 15,
					alignX = 'center',

					placeholder = 'Ваша ставка',

					variable = 'blackjack_betInput',

					-- onRender = function(element)

					-- 	local alpha = element:alpha()
					-- 	local x,y,w,h = element:abs()

					-- 	local iw,ih = 30, 30
					-- 	local ix,iy = x + 20, y+h/2-ih/2

					-- 	dxDrawImage(
					-- 		ix,iy,iw,ih, 'assets/images/chips.png',
					-- 		0, 0, 0, tocolor(255,255,255,255*alpha)
					-- 	)

					-- end,

				},

				{'button',

					'center',
					function(s,p) return p[5] - s[5] - 40 end,
					190, 46,

					bg = 'assets/images/blackjack/bet/btn_empty.png',
					activeBg = 'assets/images/blackjack/bet/btn.png',

					color = { 200,80,80,255 },
					'Начать игру',

					font = getFont('montserrat_semibold', 25, 'light'),
					scale = 0.5,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/blackjack/bet/btn_empty_shadow.png'] = (1-element.animData),
							['assets/images/blackjack/bet/btn_shadow.png'] = element.animData,
						}

						for path, anim in pairs( shadow ) do

							local texture = getDrawingTexture( path )

							local mw,mh = dxGetMaterialSize( texture )
							local mx,my = x+w/2-mw/2, y+h/2-mh/2

							dxDrawImage(
								mx,my,mw,mh, texture,
								0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
							)

						end

					end,

					onClick = function(element)

						local bet = tonumber( blackjack_betInput[6] ) or 0

						if bet < 10 then
							return exports.hud_notify:notify('Ошибка', 'Минимальная ставка - 10')
						end

						triggerServerEvent('casino.createBlackjackGame', resourceRoot,
							blackjackWindow.blackjack_data.marker, bet
						)

						blackjack_betInput[6] = ''

					end,

				},

				{'button',

					function(s,p) return p[4] - s[4] - 30 end, 30, 26, 26,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = function(element)
						closeWindow()
					end,

				},

			},

		},
		
	},

	blackjack_game = {

		{'image',

			'center', 'center',
			703, 606,
			'assets/images/blackjack/game/bg.png',
			color = {25,24,38,255},

			variable = 'blackjackGameWindow',

			addEvent('casino.receiveBlackjackGame', true),
			addEventHandler('casino.receiveBlackjackGame', resourceRoot, function( game )
				blackjackGameWindow.game = game
			end),

			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 729, 632
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/blackjack/game/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			elements = {

				{'blackjack-cards',

					[2]='center', [3]=100,
					cards_type = 'croupier',

					onPostRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local game = blackjackGameWindow.game
						if not game then return end

						if game.finished then

							local result = getBlackjackResult( game.cards )

							local result_data_t = {
								win = { text = 'Победа', color = { 90,230,90 } },
								loose = { text = 'Поражение', color = { 230,90,90, } },
								deadheat = { text = 'Ничья', color = { 255,255,255 } },
							}

							local result_data = result_data_t[result]
							local r,g,b = unpack( result_data.color )

							dxDrawText(result_data.text,
								x + w - 30, y - 10 - 51/2,
								x + w - 30, y - 10 - 51/2,
								tocolor( r,g,b, 255*alpha ),
								0.5, 0.5, getFont('montserrat_semibold', 29, 'light'),
								'right', 'center'
							)

						end


					end,

				},

				{'blackjack-cards',

					[2]='center', [3]=320,
					cards_type = 'player',

				},

				{'image',

					function(s,p) return p[4]/2 - 585/2 end, 40,
					274, 51,
					'assets/images/blackjack/game/bg2.png',
					color = {21,21,33,255},

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local iw,ih = 30,30
						local ix,iy = x + 30, y+h/2-ih/2

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/blackjack/game/croupier.png',
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

						dxDrawText('Крупье',
							ix + iw + 15, iy,
							ix + iw + 15, iy+ih,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
							'left', 'center'
						)

						local game = blackjackGameWindow.game
						if not game then return end

						if game.finished then

							dxDrawText('#606065Счёт  #ffffff' .. getBlackjackCardsSum( game.cards.croupier ),
								x + w - 35, y,
								x + w - 35, y+h,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'right', 'center', false, false, false, true
							)

						end

					end,

				},

				{'element',

					'center', function(s,p) return p[5] - s[5] - 30 end,
					585, 51,

					color = {255,255,255,255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()



					end,

					elements = {

						{'image',

							0, 'center',
							274, 51,
							'assets/images/blackjack/game/bg2.png',
							color = {21,21,33,255},

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								local iw,ih = 20,20
								local ix,iy = x + 35, y+h/2-ih/2

								local game = blackjackGameWindow.game
								if not game then return end

								dxDrawImage(
									ix,iy,iw,ih, 'assets/images/chips.png',
									0, 0, 0, tocolor( 255,255,255,255*alpha )
								)

								dxDrawText(splitWithPoints( game.bet, '.' ),
									ix + iw + 10, iy,
									ix + iw + 10, iy+ih,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'left', 'center'
								)

								dxDrawText('#606065Счёт  #ffffff' .. getBlackjackCardsSum( game.cards.player ),
									x + w - 35, y,
									x + w - 35, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'right', 'center', false, false, false, true
								)

							end,

						},

						{'button',

							'right', 'center',
							139, 36,

							bg = 'assets/images/blackjack/game/btn_empty.png',
							activeBg = 'assets/images/blackjack/game/btn.png',

							color = { 200,80,80,255 },
							'Хватит',

							font = getFont('montserrat_bold', 20, 'light'),
							scale = 0.5,

							noDraw = function(element)

								local game = blackjackGameWindow.game
								if not game then return end

								if game.finished then return true end

							end,

							onRender = function(element)

								local game = blackjackGameWindow.game
								if not game then return end

								local opened = 0

								for _, card in pairs( game.cards.player ) do
									if card.opened then opened = opened + 1 end
								end

								if opened >= 5 then
									element[6] = 'Завершить'
								else
									element[6] = 'Хватит'
								end

							end,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shadow = {
									['assets/images/blackjack/game/btn_empty_shadow.png'] = (1-element.animData),
									['assets/images/blackjack/game/btn_shadow.png'] = element.animData,
								}

								for path, anim in pairs( shadow ) do

									local texture = getDrawingTexture( path )

									local mw,mh = dxGetMaterialSize( texture )
									local mx,my = x+w/2-mw/2, y+h/2-mh/2

									dxDrawImage(
										mx,my,mw,mh, texture,
										0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
									)

								end

							end,

							onClick = function(element)

								local game = blackjackGameWindow.game
								if not game then return end

								triggerServerEvent('casino.finishBlackjackGame', resourceRoot, game.marker)

							end,

						},

						{'button',

							function(s,p) return p[4] - s[4]*2 - 15 end, 'center',
							139, 36,

							bg = 'assets/images/blackjack/game/btn_empty.png',
							activeBg = 'assets/images/blackjack/game/btn.png',

							color = { 200,80,80,255 },
							'Взять ещё',

							font = getFont('montserrat_bold', 20, 'light'),
							scale = 0.5,

							noDraw = function(element)

								local game = blackjackGameWindow.game
								if not game then return end

								if game.finished then return true end

								local opened = 0

								for _, card in pairs( game.cards.player ) do
									if card.opened then opened = opened + 1 end
								end

								return opened >= 5

							end,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shadow = {
									['assets/images/blackjack/game/btn_empty_shadow.png'] = (1-element.animData),
									['assets/images/blackjack/game/btn_shadow.png'] = element.animData,
								}

								for path, anim in pairs( shadow ) do

									local texture = getDrawingTexture( path )

									local mw,mh = dxGetMaterialSize( texture )
									local mx,my = x+w/2-mw/2, y+h/2-mh/2

									dxDrawImage(
										mx,my,mw,mh, texture,
										0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
									)

								end

							end,

							onClick = function(element)

								local game = blackjackGameWindow.game
								if not game then return end

								triggerServerEvent('casino.openBlackjackCard', resourceRoot, game.marker)

							end,

						},


					},

				},

			},

		},

	},

}

------------------------------------------------

	GUIDefine('blackjack-cards', {

		[4]=585, [5]=188,

		color = {21,21,33,255},

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			--dxDrawImage(x,y,w,h, 'assets/images/blackjack/game/bg1.png',0, 0, 0, tocolor( 21,21,33,255*alpha ))

			local game = element.parent.game
			if not game then return end

			local cards = game.cards[ element.cards_type ]
			if not cards then return end

			local cw,ch = 96, 144
			local padding = 13

			local sCount = 2.5

			local startX = x+w/2-cw*sCount - padding*(sCount-0.5)
			local startY = y+h/2-ch/2

			for _, card in pairs( cards ) do

				local image = card.opened and ('assets/images/blackjack/cards/%s/%s.png'):format(
					card.suit, card.card
				) or 'assets/images/blackjack/cards/empty.png'

				if not game.finished and element.cards_type == 'croupier' then
					image = 'assets/images/blackjack/cards/empty.png'
				end

				dxDrawImage(
					startX, startY,
					cw,ch, image,
					0, 0, 0, tocolor( 255,255,255,255*alpha )
				)

				startX = startX + cw + padding


			end

		end,



	})

------------------------------------------------

	GUIDefine('exchange-window', {

		[4] = 314,
		[5] = 497,

		color = {255,255,255,255},

		onRender = function(element)

			element[3] = element.y0 - 5 * element.animData

			local alpha = element:alpha()

			alpha = alpha*0.8 + alpha*0.2*element.animData

			local x,y,w,h = element:abs()

			local shw,shh = 338, 521
			local shx,shy = x+w/2-shw/2, y+h/2-shh/2

			dxDrawImage(
				shx, shy + 5, shw, shh, 'assets/images/exchange/bg2_shadow.png',
				0, 0, 0, tocolor(0, 0, 0, 255*alpha)
			)

			dxDrawImage(
				x,y,w,h, 'assets/images/exchange/bg2.png',
				0, 0, 0, tocolor(25,24,38,255*alpha)
			)

			dxDrawImage(
				x,y,w,h, 'assets/images/exchange/bg2a.png',
				0, 0, 0, tocolor(180,70,70,255*alpha)
			)

			dxDrawText(element.name,
				x,y + 30, x + w, y + 30,
				tocolor(255,255,255,255*alpha),
				0.5, 0.5, getFont('montserrat_bold', 26, 'light'),
				'center', 'top'
			)

			dxDrawText(element.title,
				x,y + 53, x + w, y + 53,
				tocolor(110, 110, 110, 255*alpha),
				0.5, 0.5, getFont('montserrat_semibold_italic', 23, 'light'),
				'center', 'top'
			)

			if not element.config.sell then

				dxDrawText('Только для покупки',
					x,y + 115, x + w, y + 115,
					tocolor(110, 110, 110, 255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
					'center', 'center'
				)

			end

			dxDrawText(element.counter,
				x, y + 160,
				x+w, y + 160,
				tocolor(110,110,110,255*alpha),
				0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
				'center', 'top'
			)

			local iw,ih = 131, 34
			local ix,iy = x+w/2-iw/2, y + 190

			dxDrawImage(
				ix,iy,iw,ih, 'assets/images/exchange/input2.png',
				0, 0, 0, tocolor(21,21,33,255*alpha)
			)

			drawSmartText(string.format('%s <img>assets/images/%s.png</img>',
				splitWithPoints( math.floor(
					localPlayer:getData('casino.' .. element.valute) or 0
				) , '.'),
				element.valute
			),
				ix, ix+iw, iy+ih/2, 
				tocolor(255,255,255,255*alpha),
				tocolor(255,255,255,255*alpha),
				0.5, getFont('montserrat_medium', 23, 'light'),
				'center', 20, 0
			)

		end,

		onInit = function(element)

			element.y0 = element[3]

			element:addElement(

				{'button',

					'center', function(s,p) return p[5] - s[5] - 40 end,
					173, 38,

					bg = 'assets/images/exchange/btn_empty.png',
					activeBg = 'assets/images/exchange/btn.png',

					color = { 200,80,80,255 },
					'',

					font = getFont('montserrat_bold', 18, 'light'),
					scale = 0.5,

					onInit = function(element)
						element[6] = element.parent.button
					end,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shadow = {
							['assets/images/exchange/btn_empty_shadow.png'] = (1-element.animData),
							['assets/images/exchange/btn_shadow.png'] = element.animData,
						}

						for path, anim in pairs( shadow ) do

							local texture = getDrawingTexture( path )

							local mw,mh = dxGetMaterialSize( texture )
							local mx,my = x+w/2-mw/2, y+h/2-mh/2

							dxDrawImage(
								mx,my,mw,mh, texture,
								0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
							)

						end

					end,

					last_click = getTickCount(  ),

					onClick = function(element)

						if ( getTickCount() - element.last_click ) < 1000 then
							return
						end

						element.last_click = getTickCount(  )

						local amount = tonumber(element.parent.take_input[6]) or 0

						if not amount then
							return exports.hud_notify:notify('Ошибка', 'Введите сумму')
						end

						triggerServerEvent('casino.exchange', resourceRoot,
							element.parent.valute, element.parent.tab.id, amount
						)

						element.parent.take_input[6] = '1'

					end,


				}

			)

			element.config = Config.exchange[ element.valute ]
			if not element.config then return end

			if element.config.sell then

				element:addElement(
					{'element',

						'center', 115-32/2,
						210, 32,
						color = {255,255,255,255},

						onPostInit = function(element)
							element.parent.tab = element.elements[1]
						end,

						elements = {

							{'button',
								[2] = 'left', [3] = 'center',
								[6] = 'Покупка', id = 'buy',
								define_from = 'tab',
							},

							{'button',
								[2] = 'right', [3] = 'center',
								[6] = 'Продажа', id = 'sell',
								define_from = 'tab',
							},

						},

					}
				)

			else

				element.tab = { id = 'buy', }

			end

			element.take_input = element:addElement(

				{'input',

					[3] = 270,
					define_from = 'sum_input',

					isSource = true,

					placeholder = 'Введите сумму',

				}

			)

			element.give_input = element:addElement(

				{'input',

					[3] = 345,
					define_from = 'sum_input',

					-- noEdit = true,

				}

			)

			element:updateInputs()

		end,

		updateInputs = function(element)

			element.take_input[6] = '1'

		end,

	})

------------------------------------------------

	GUIDefine('tab', {

		[4]=100, [5]=32,

		bg = 'assets/images/exchange/tab_empty.png',

		color = { 200,80,80,255 },

		font = getFont('montserrat_bold', 18, 'light'),
		scale = 0.5,

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shadow = {
				['assets/images/exchange/tab_shadow.png'] = element.animData,
			}

			for path, anim in pairs( shadow ) do

				local texture = getDrawingTexture( path )

				local mw,mh = dxGetMaterialSize( texture )
				local mx,my = x+w/2-mw/2, y+h/2-mh/2

				dxDrawImage(
					mx,my,mw,mh, texture,
					0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
				)

			end

			if element.parent.parent.tab == element then
				element.bg = 'assets/images/exchange/tab.png'
			else
				element.bg = 'assets/images/exchange/tab_empty.png'
			end

		end,

		onClick = function(element)
			element.parent.parent.tab = element
			element.parent.parent:updateInputs()
		end,

	})

------------------------------------------------

	GUIDefine('sum_input', {

		[2] = 'center',
		[4]=209, [5]=41,
		[6] = '',

		type = 'number',

		placeholderColor = { 110, 110, 110, 255 },

		bg = 'assets/images/exchange/input.png',

		color = { 21,21,33,255 },

		font = getFont('montserrat_medium', 21, 'light'),
		scale = 0.5,

		textPadding = 10,

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local icon

			if element.isSource then
				icon = element.parent.valute
			else
				icon = element.parent.config.valute
			end

			local iw,ih = 20,20
			local ix,iy = x + w - iw - 20, y+h/2-ih/2

			dxDrawImage(
				ix,iy,iw,ih, ('assets/images/%s.png'):format( icon ),
				0, 0, 0, tocolor(255,255,255,255*alpha)
			)

			local text

			if element.isSource then

				if element.parent.tab.id == 'sell' then
					text = 'Вы отдадите'
				else
					text = 'Вы получите'
				end

			else

				if element.parent.tab.id == 'sell' then
					text = 'Вы получите'
				else
					text = 'Вы отдадите'
				end

			end

			dxDrawText(text,
				x, y - 3, x + w, y - 3,
				tocolor(110,110,110,255*alpha),
				0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
				'center', 'bottom'
			)

			if not element.isSource then

				local config = Config.exchange[ element.parent.valute ]
				local trade_amount = config[ element.parent.tab.id ]

				element[6] = (tonumber(element.parent.take_input[6]) or 0) * trade_amount

			end

		end,

		onInit = function(element)

			if not element.isSource then

				element.onClick = function(element)
					return exports.hud_notify:notify('Ошибка', 'Редактируйте верхнее поле')
				end

			end

		end,

	})

------------------------------------------------

loadGuiModule()


end)

