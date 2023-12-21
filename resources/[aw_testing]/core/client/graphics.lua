

local graphics_elements = {}

graphics_elements.shader_blur = dxCreateShader('assets/graphics/shaders/blur.fx')
graphics_elements.shader_mask = dxCreateShader('assets/graphics/shaders/mask.fx')
graphics_elements.shader_round_mask = dxCreateShader('assets/graphics/shaders/round_mask.fx')
graphics_elements.shader_gradient = dxCreateShader('assets/graphics/shaders/gradient.fx')
graphics_elements.shader_gray = dxCreateShader('assets/graphics/shaders/gray.fx')

graphics_elements.screen_source = dxCreateScreenSource( guiGetScreenSize( ) )

addEventHandler('onClientRender', root, function()
	dxUpdateScreenSource(graphics_elements.screen_source)
end)

function getGraphicsElement(name)
	return graphics_elements[name]
end