
------------------------------------------------------------------

	addEvent('onLoadingFinish', true)
	addEvent('onLoadingStart', true)

	local loadFromRAM = true

	local function saveFile(path, data)
	    if not path then
	        return false
	    end
	    if fileExists(path) then
	        fileDelete(path)
	    end
	    local file = fileCreate(path)
	    fileWrite(file, data)
	    fileClose(file)
	    return true
	end

------------------------------------------------------------------

	local modelsCount,modelsLoaded = 0,0
	local cachedTXD = {}

	local function loadModel(model, data)

		modelsLoaded = modelsLoaded + 1

		replaceModel( ':engine/assets/models/'..data.path, model, data )

		if modelsLoaded == modelsCount then
			triggerEvent('onLoadingFinish', root)
		end

	end

------------------------------------------------------------------

	function loadModels(models)

		if not models or getTableLength(models) == 0 then
			return
		end

		modelsLoaded = 0
		modelsCount = 0

		for name,data in pairs(models) do
			modelsCount = modelsCount + 1
		end

		local timeoffset = 50
		for model, data in pairs(models) do
			setTimer(loadModel, timeoffset, 1, model, data)
			timeoffset = timeoffset + 50
		end

		triggerEvent('onLoadingStart', root)

	end

	addEvent('startLoadModels', true)
	addEventHandler("startLoadModels", root, loadModels)

------------------------------------------------------------------

	function getLoadingState()
		return math.clamp(modelsLoaded/modelsCount, 0, 1)
	end

------------------------------------------------------------------


	addEventHandler('onClientResourceStart', resourceRoot, function()

		for blockName, blockData in pairs( Config.models ) do
			if blockData.default then
				loadModels( blockData.models )
			end
		end


	end)

------------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		addEvent('engine.restoreModel', true)
		addEventHandler('engine.restoreModel', resourceRoot, restoreModel)

		addEvent('engine.replaceModel', true)
		addEventHandler('engine.replaceModel', resourceRoot, replaceModel)
		
	end)


--------------------------------------------------

	function restoreModels( blockNameOrList )
		
		if type(blockNameOrList) == 'string' then

			if Config.models[blockNameOrList] and Config.models[blockNameOrList].models then

				for model, data in pairs( Config.models[blockNameOrList].models ) do

					restoreModel( model )

				end

			end

		elseif type(blockNameOrList) == 'table' then

			for model, data in pairs( blockNameOrList ) do

				restoreModel( model )

			end

		end

	end

	addEvent('engine.restoreModels', true)
	addEventHandler('engine.restoreModels', resourceRoot, restoreModels)

	function replaceModels( blockNameOrList )
		if type(blockNameOrList) == 'string' then

			if Config.models[blockNameOrList] and Config.models[blockNameOrList].models then

				for model, data in pairs( Config.models[blockNameOrList].models ) do

					replaceModel( ':engine/assets/models/'..data.path, model, data )

				end

			end

		elseif type(blockNameOrList) == 'table' then

			for model, data in pairs( blockNameOrList ) do

				replaceModel( data.path, model, data )

			end

		end
	end
	addEvent('engine.replaceModels', true)
	addEventHandler('engine.replaceModels', resourceRoot, replaceModels)

------------------------------------------------------------------
