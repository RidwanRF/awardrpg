
--------------------------------------------------------

	local RAMModels = {}

	mta_engineReplaceModel = engineReplaceModel
	function engineReplaceModel(dff, model)

		RAMModels[model] = RAMModels[model] or {}
		RAMModels[model].dff = dff

		return mta_engineReplaceModel( dff, model )

	end

	mta_engineReplaceCOL = engineReplaceCOL
	function engineReplaceCOL(col, model)

		RAMModels[model] = RAMModels[model] or {}
		RAMModels[model].col = col

		return mta_engineReplaceCOL( col, model )

	end

	mta_engineImportTXD = engineImportTXD
	function engineImportTXD(txd, model)

		RAMModels[model] = RAMModels[model] or {}
		RAMModels[model].txd = txd

		return mta_engineImportTXD( txd, model )

	end

	mta_engineRestoreModel = engineRestoreModel
	function engineRestoreModel( model )

		mta_engineRestoreModel(model)

		local RAMModel = RAMModels[model]
		if RAMModel then
			clearTableElements(RAMModel)
		end

		RAMModels[model] = nil

	end
	restoreModel = engineRestoreModel

	addCommandHandler('engine_clearall', function()
		if exports.acl:isAdmin(localPlayer) then
			clearTableElements(RAMModels)
		end
	end)

	function getRAMModels()
		return RAMModels
	end

--------------------------------------------------------

	local RAMModelsCache = {}

	loaderFunctions = {

		main = function(element_type, path, ...)

			if isElement(RAMModelsCache[path]) then
				return RAMModelsCache[path]
			end

			local element = (loaderFunctions.mta[element_type])( path, ... )
			RAMModelsCache[path] = element
			return element

		end,

		mta = {
			dff = engineLoadDFF,
			txd = engineLoadTXD,
			col = engineLoadCOL,
		},

		dff = function(...) return loaderFunctions.main('dff', ...) end,
		txd = function(...) return loaderFunctions.main('txd', ...) end,
		col = function(...) return loaderFunctions.main('col', ...) end,

	}

	-- engineLoadDFF = loaderFunctions.dff
	engineLoadTXD = loaderFunctions.txd
	-- engineLoadCOL = loaderFunctions.col

--------------------------------------------------------
	
	addCommandHandler('checkmodel', function(_, model)

		outputChatBox(RAMModels[model] and 'replaced' or 'free')

	end)

--------------------------------------------------------
