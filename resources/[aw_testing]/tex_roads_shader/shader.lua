addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local texture = dxCreateTexture("img/vegasdirtyroad3_256.png", "dxt3")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vegasdirtyroad3_256")
		
		texture = dxCreateTexture("img/Tar_1line256HVblend2.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vegasdirtyroad3_256")
		engineApplyShaderToWorldTexture(shader, "Tar_1line256HVblend2")
		engineApplyShaderToWorldTexture(shader, "Tar_1line256HVblenddrt")
		engineApplyShaderToWorldTexture(shader, "Tar_1line256HVblenddrtdot")
		engineApplyShaderToWorldTexture(shader, "Tar_1line256HVgtravel")
		engineApplyShaderToWorldTexture(shader, "Tar_1line256HVlightsand")
		engineApplyShaderToWorldTexture(shader, "Tar_lineslipway")
		engineApplyShaderToWorldTexture(shader, "Tar_venturasjoin")
		engineApplyShaderToWorldTexture(shader, "conc_slabgrey_256128")
		
		texture = dxCreateTexture("img/snpedtest1BLND.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_freeway3blend")
		engineApplyShaderToWorldTexture(shader, "snpedtest1BLND")
		engineApplyShaderToWorldTexture(shader, "vegastriproad1_256")
		
		texture = dxCreateTexture("img/desert_1line256.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "desert_1line256")
		engineApplyShaderToWorldTexture(shader, "desert_1linetar")
		engineApplyShaderToWorldTexture(shader, "roaddgrassblnd")
		
		texture = dxCreateTexture("img/crossing2_law.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "crossing2_law")
		engineApplyShaderToWorldTexture(shader, "lasunion994")
		engineApplyShaderToWorldTexture(shader, "motocross_256")
		
		texture = dxCreateTexture("img/crossing_law.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "crossing_law")
		engineApplyShaderToWorldTexture(shader, "crossing_law2")
		engineApplyShaderToWorldTexture(shader, "crossing_law3")
		engineApplyShaderToWorldTexture(shader, "sf_junction5")
		engineApplyShaderToWorldTexture(shader, "crossing_law.bmp")
				
		texture = dxCreateTexture("img/dt_road_stoplinea.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "dt_road_stoplinea")
		
		texture = dxCreateTexture("img/Tar_freewyleft.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "Tar_freewyleft")
		
		texture = dxCreateTexture("img/Tar_freewyright.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "Tar_freewyright")
		
		texture = dxCreateTexture("img/Tar_1line256HV.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "Tar_1line256HV")
		engineApplyShaderToWorldTexture(shader, "Tar_1linefreewy")
		engineApplyShaderToWorldTexture(shader, "des_1line256")
		engineApplyShaderToWorldTexture(shader, "des_1lineend")
		engineApplyShaderToWorldTexture(shader, "des_1linetar")
		
		texture = dxCreateTexture("img/sf_junction2.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sf_junction2")
		
		texture = dxCreateTexture("img/vegastriproad1_256.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vegastriproad1_256")
		engineApplyShaderToWorldTexture(shader, "ws_freeway3")
		engineApplyShaderToWorldTexture(shader, "cuntroad01_law")
		engineApplyShaderToWorldTexture(shader, "roadnew4blend_256")
		engineApplyShaderToWorldTexture(shader, "sf_road5")
		engineApplyShaderToWorldTexture(shader, "sl_roadbutt1")
		engineApplyShaderToWorldTexture(shader, "snpedtest1")
		
		texture = dxCreateTexture("img/vegastriproad1_256.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vegastriproad1_256")
		engineApplyShaderToWorldTexture(shader, "ws_freeway3")
		engineApplyShaderToWorldTexture(shader, "cuntroad01_law")
		engineApplyShaderToWorldTexture(shader, "roadnew4blend_256")
		engineApplyShaderToWorldTexture(shader, "sf_road5")
		engineApplyShaderToWorldTexture(shader, "sl_roadbutt1")
		engineApplyShaderToWorldTexture(shader, "snpedtest1")
		
		texture = dxCreateTexture("img/sl_freew2road1.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sl_freew2road1")
		engineApplyShaderToWorldTexture(shader, "snpedtest1blend")
		engineApplyShaderToWorldTexture(shader, "ws_carpark3")
		
		texture = dxCreateTexture("img/cos_hiwaymid_256.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "cos_hiwaymid_256")
		engineApplyShaderToWorldTexture(shader, "sf_road5")
		
		texture = dxCreateTexture("img/hiwayend_256.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "hiwayend_256")
		engineApplyShaderToWorldTexture(shader, "hiwaymidlle_256")
		engineApplyShaderToWorldTexture(shader, "vegasroad2_256")
		
		texture = dxCreateTexture("img/roadnew4_256.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "roadnew4_256")
		engineApplyShaderToWorldTexture(shader, "roadnew4_512")
		engineApplyShaderToWorldTexture(shader, "vegasroad1_256")
		engineApplyShaderToWorldTexture(shader, "dt_road")
		engineApplyShaderToWorldTexture(shader, "vgsN_road2sand01")
		engineApplyShaderToWorldTexture(shader, "hiwayoutside_256")
		engineApplyShaderToWorldTexture(shader, "vegasdirtyroad1_256")
		engineApplyShaderToWorldTexture(shader, "vegasdirtyroad2_256")
		engineApplyShaderToWorldTexture(shader, "vegasroad3_256")
		
		texture = dxCreateTexture("img/sf_junction1.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sf_junction1")
		engineApplyShaderToWorldTexture(shader, "sf_junction3")
		
		texture = dxCreateTexture("img/des_oldrunway.png", "dxt3")
		shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "des_oldrunway")
		engineApplyShaderToWorldTexture(shader, "des_panelconc")
		engineApplyShaderToWorldTexture(shader, "plaintarmac1")
		
		
	end
)