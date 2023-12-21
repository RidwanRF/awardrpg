
---------------------------------------------------------------------------

	local lastDriftData = {0, 0}

	setAnimData('drift', 0.2)
	setAnimData('drift.string', 0.1, 1)

---------------------------------------------------------------------------


---------------------------------------------------------------------------

	local renderTarget = dxCreateRenderTarget( 600, 100, true )

	local blendShader = dxCreateShader('assets/shaders/blend.fx')

	dxSetShaderValue( blendShader, 'sourceTexture', renderTarget )

	dxSetShaderValue( blendShader, 'blendAlpha', 1 )

---------------------------------------------------------------------------

	lastDriftTick = 0

	function renderDrift()


		if not localPlayer:getData('drift.hidden') then

			------------------------------------------------------------------------------------

				updateDrift()

				local driftScore, driftMul = getDriftData()

				if driftScore > 0 then
					lastDriftTick = getTickCount(  )
				end

				animate('drift', ( getTickCount() - lastDriftTick ) < 3000 and 1 or 0)

				local alpha = getEasingValue( getAnimData('drift'), 'InOutQuad' )

				if alpha < 0.05 then return end

				if driftScore > 0 then
					lastDriftData = {driftScore, driftMul}
				end

				whiteTexture = whiteTexture or exports.core:getTexture('white')

				driftScore, driftMul = unpack(lastDriftData)

			------------------------------------------------------------------------------------

				local w,h = 255,52
				local x,y = sx/2 - w/2, 100 + 50*(1-alpha)


				local mw,mh = 58,43
				local mx,my = x + 110, y - 3


				dxDrawText('x' .. driftMul,
					mx,my-2,mx+mw,my+mh-2,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_bold_italic', 25, 'light'),
					'center', 'center'
				)

				local tw,th = 80, 16
				local tx,ty = mx+45, my+mh/2-th/2

				dxDrawImage(
					tx,ty,tw,th, 'assets/images/time_progress.png',
					0, 0, 0, tocolor(255,255,255,25*alpha)
				)

				local time_progress = math.clamp( (1-curDriftTime/maxDriftTime), 0, 1 )

				if score <= 0 then
					time_progress = 0
				end

				drawImageSection(
					tx,ty,tw,th, 'assets/images/time_progress.png',
					{ y = 1, x = time_progress }, tocolor(255,255,255,255*alpha)
				)

				dxSetBlendMode('modulate_add')
				dxSetRenderTarget(renderTarget, true)

					mta_dxDrawText(('%03d'):format( driftScore ),
						0, 0, 600-5, 100,
						tocolor(255,255,255,255),
						0.5, 0.5, getFont('montserrat_bold_italic', 109, 'light', true),
						'right', 'center'
					)

				dxSetRenderTarget()
				dxSetBlendMode('blend')

				local vw,vh = 300,50
				local vx,vy = x - 180, y - 15

				dxDrawImage(
					vx+2,vy+2,vw,vh, renderTarget,
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				driftString = getDriftString()

				if driftString ~= prevDriftString then

					setAnimData('drift.string', 0.1)
					animate('drift.string', 1)
					d_prevDriftString = prevDriftString

				end

				local dritStringAnim = getEasingValue( getAnimData('drift.string'), 'InOutQuad' )
				local offset = 20*dritStringAnim

				dxDrawText(driftString,
					x+w-30, y+h-5, 
					x+w-30, y+h-5, 
					tocolor(255,255,255,255*alpha*dritStringAnim),
					0.5, 0.5, getFont('montserrat_bold_italic', 21, 'light'),
					'right', 'bottom'
				)

				if d_prevDriftString then
					dxDrawText(d_prevDriftString,
						x+w-30, y+h-5+offset,
						x+w-30, y+h-5+offset,
						tocolor(255,255,255,255*alpha*(1-dritStringAnim)),
						0.5, 0.5, getFont('montserrat_bold_italic', 21, 'light'),
						'right', 'bottom'
					)
				end

				prevDriftString = driftString

			------------------------------------------------------------------------------------

		end


	end
	
	addEventHandler('onClientRender', root, renderDrift)

---------------------------------------------------------------------------