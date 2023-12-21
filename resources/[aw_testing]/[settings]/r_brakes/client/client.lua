local names = {
	[1]='assets/textures/0.dds',
	[2]='assets/textures/1.dds',
	[3]='assets/textures/2.dds',
	[4]='assets/textures/3.dds',
	[5]='assets/textures/4.dds',
	[6]='assets/textures/5.dds',
	[7]='assets/textures/6.dds',
	[8]='assets/textures/7.dds',
	[9]='assets/textures/8.dds',
	[10]='assets/textures/9.dds',
	[11]='assets/textures/10.dds',
	[12]='assets/textures/11.dds',
	[13]='assets/textures/12.dds',
}

local textures = {}

for k,v in pairs(names) do
	textures[k] = dxCreateTexture(v)
end

local shaders = {}
for k in pairs(names) do
	shaders[k] = dxCreateShader('assets/shader/texreplace.fx', 1, 0, false)
	dxSetShaderValue(shaders[k], 'gTexture', textures[k])
end

function removeAllShaders(vehicle)
	local attached = getAttachedElements(vehicle)

	for k,v in pairs(attached) do
		for k1,v1 in pairs(shaders) do
			engineRemoveShaderFromWorldTexture(v1, 'brakedisc', v)
		end
	end
end

function applyShader(vehicle, shader)
	local attached = getAttachedElements(vehicle)

	for k,v in pairs(attached) do
		engineApplyShaderToWorldTexture(shader, 'brakedisc', v)
	end
end

addEventHandler('onClientElementDataChange', root, function(dataName)
	if not isElement(source) then return end
	if getElementType(source) ~= "vehicle" then
		return
	end
	if dataName ~= 'wheels*' then

		local value = source:getData('wheels_brakes') or -1

		removeAllShaders(source)
		if names[value] then
			applyShader(source, shaders[value])
		end
	end

end)


addEventHandler('onClientElementStreamIn', root, function(dataName)
	if not isElement(source) then return end
	if getElementType(source) ~= "vehicle" then
		return
	end
	local value = source:getData('wheels_brakes') or -1

	removeAllShaders(source)
	if names[value] then
		applyShader(source, shaders[value])
	end
end)


addEventHandler('onClientElementStreamOut', root, function(dataName)
	removeAllShaders(source)
end)

addEventHandler('onClientResourceStart', root, function(dataName)
	for k,v in pairs(getElementsByType('vehicle')) do
		local value = v:getData('wheels_brakes') or -1

		removeAllShaders(v)
		if names[value] then
			applyShader(v, shaders[value])
		end
	end
end)