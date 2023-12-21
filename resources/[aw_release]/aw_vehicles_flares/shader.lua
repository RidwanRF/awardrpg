function blik ()
	if not getElementData(localPlayer, "flares:toggle") then
		shader_4 = dxCreateShader('shader.fx')
		terrain_4 = dxCreateTexture('f.png')
		dxSetShaderValue(shader_4, 'gTexture', terrain_4)
		engineApplyShaderToWorldTexture(shader_4, 'coronastar')
		setElementData (localPlayer, "flares:toggle",true)
		print("true")
	else
		if isElement(shader_4) then
			destroyElement(shader_4)
		end
		if isElement(terrain_4) then
			destroyElement(terrain_4)
		end
		setElementData (localPlayer, "flares:toggle",false)
		print("false")
	end
end
addCommandHandler ("flares", blik)

addEvent ("flares:toogle",true)
addEventHandler ("flares:toogle", root, function(data)
	if data then
		shader_4 = dxCreateShader('shader.fx')
		terrain_4 = dxCreateTexture('f.png')
		dxSetShaderValue(shader_4, 'gTexture', terrain_4)
		engineApplyShaderToWorldTexture(shader_4, 'coronastar')
	else
		if isElement(shader_4) then
			destroyElement(shader_4)
		end
		if isElement(terrain_4) then
			destroyElement(terrain_4)
		end
	end
end)