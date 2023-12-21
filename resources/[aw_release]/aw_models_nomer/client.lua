function nomer(vehicle)
shader = dxCreateShader(':car_components/shaders/texture_replace.fx')
texture = dxCreateTexture('nomer.png')
dxSetShaderValue(shader, 'gTexture', texture)
engineApplyShaderToWorldTexture(shader, 'nomer', vehicle) 
end
nomer()