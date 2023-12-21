

local sx,sy = guiGetScreenSize()


local notifyWidth, notifyHeight = 292, 88
local padding = 0


function calculateNotifyY()

	local count = getTableLength(currentNotifyList)
end

currentNotifyList = {}

addEventHandler('onClientRender', root, function()

	--if not localPlayer:getData('unique.login') then return end
	--if localPlayer:getData('notify.hidden') then return end


	local notifyY = calculateNotifyY()
	animate('notify-y', notifyY)

	local animY = getAnimData('notify-y')

	for index, data in pairs( currentNotifyList ) do

		local anim, target = getAnimData( data.animName )

		local animData = getEasingValue( anim, 'InOutQuad' )

		local y = 50*(1-animData) * ( target == 0 and -1 or 1 )

		dxDrawImage(
			x, y+animY, notifyWidth, notifyHeight,
			'assets/images/bg.png', 0, 0, 0, tocolor(255,255,255,255*animData)
		)

		dxDrawText(data.title,
			x+65, y+animY + notifyHeight/2 + 3 - 2 - 1,
			x+65, y+animY + notifyHeight/2 + 3 - 2 - 1,
			tocolor(190, 70, 70, 255*animData),
			0.5, 0.5, getFont('montserrat_bold', 21, 'light', true),
			'left', 'bottom'
		)

		dxDrawText(data.text,
			x+65, y+animY + notifyHeight/2 - 2 + 1,
			x+65, y+animY + notifyHeight/2 - 2 + 1,
			tocolor(255, 255, 255, 255*animData),
			0.5, 0.5, getFont('montserrat_semibold', 21, 'light', true),
			'left', 'top'
		)

		animY = animY + notifyHeight + padding

	end
	

end, true, 'low-20')
