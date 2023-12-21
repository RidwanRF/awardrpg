
local sx,sy = guiGetScreenSize()

sx = sx * 0.7

setAnimData('action_notify', 0.04)
setAnimData('action_notify_blim', 0.02)

addEventHandler('onClientRender', root, function()

	--if not localPlayer:getData('unique.login') then return end
	--if localPlayer:getData('action_notify.hidden') then return end

	local anim = getAnimData('action_notify')
	local b_anim = getAnimData('action_notify_blim')

	local animData = getEasingValue( anim, 'InOutQuad' )

	if animData < 0.1 then return end

	local notifyData = currentActionNotifyData
	if not notifyData then return end

	local f_size = 40

	if utf8.len( notifyData.button ) > 1 then
		f_size = 25
	end

	local bFont, bScale = getFont('montserrat_bold', f_size, 'light', true), 0.5
	local font, scale = getFont('montserrat_bold', 23, 'light', true), 0.5
	local font2, scale2 = getFont('montserrat_medium', 21, 'light', true), 0.5

	local w,h = 325, 69
	local sw,sh = 348, 95

	local x,y = 500, sy - 200 - h

	local swx, swy = x+w/2-sw/2, y+h/2-sh/2+5

	local rw,rh = 120, 120
	local rx,ry = x-30, y+h/2-rh/2

	dxDrawImage(
		swx,swy,sw,sh, 'assets/images/ac3_shadow.png',
		0, 0, 0, tocolor( 255,255,255,255*animData )
	)

	dxDrawImage(
		x,y,w,h, 'assets/images/ac3.png',
		0, 0, 0, tocolor( 255,255,255,255*animData )
	)

	dxDrawImage(
		rx,ry,rw,rh, 'assets/images/ac1.png',
		0, 0, 0, tocolor( 200, 70, 70, 255*animData )
	)

	dxDrawImage(
		rx,ry,rw,rh, 'assets/images/ac2.png',
		0, 0, 0, tocolor( 200, 70, 70, 255*animData )
	)

	local rw2,rh2 = 120*(1+b_anim*0.2), 120*(1+b_anim*0.2)
	local rx2,ry2 = rx+rw/2-rw2/2, y+h/2-rh2/2

	dxDrawImage(
		rx2,ry2,rw2,rh2, 'assets/images/ac2.png',
		0, 0, 0, tocolor( 200, 70, 70, 255*animData*(1-b_anim) )
	)


	dxDrawText('Нажмите F',
		x + 0, y+h-80/2,
		x + 0, y+h-80/2,
		tocolor( 255,255,255,255*animData ),
		scale, scale, font,
		'left', 'bottom'
	)

	dxDrawText('Чтобы '.. utf8.lower(notifyData.text),
		x + 0, y+h/2,
		x + 0, y+h/2,
		tocolor( 255,255,255,67*animData ),
		scale2, scale2, font2,
		'left', 'top'
	)


end, true, 'low-4')

setTimer(function()

	setAnimData('action_notify_blim', 0.05)
	animate('action_notify_blim', 1)

end, 2000, 0)