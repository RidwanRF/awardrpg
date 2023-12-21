

--------------------------------------------------

	local function convertFilePath(path)
		if path:sub(1,1) == ':' then
			return path
		else
			return string.format('temp_models/%s', path)
		end
	end

--------------------------------------------------


	local cachedTXD = {}
	local cachedTXD_collections = {}

	function replaceModel(path, model, data)

		engineRestoreModel(model)

		data = data or {}

		local txd, dff, col

		if data.collection_txd then

			local c_txdPath = convertFilePath( data.collection_txd ) .. '.txd'
			if fileExists( c_txdPath ) then

				local c_txd = isElement(cachedTXD_collections[c_txdPath]) and cachedTXD_collections[c_txdPath] or engineLoadTXD(c_txdPath, false)
				if not cachedTXD_collections[c_txdPath] then cachedTXD_collections[c_txdPath] = c_txd end

				engineImportTXD(c_txd, model)

			end

		end


		local txdPath = convertFilePath( data.txd or path ) .. '.txd'
		if fileExists( txdPath ) then
			txd = isElement(cachedTXD[txdPath]) and cachedTXD[txdPath] or engineLoadTXD(txdPath, false)

			if not cachedTXD[txdPath] then cachedTXD[txdPath] = txd end

			engineImportTXD(txd, model)
		end

		local dffPath = convertFilePath( path ) .. '.dff'
		local dffcPath = dffPath .. 'c'

		local decodeDFF = fileExists(dffcPath)
		local dffPath = decodeDFF and dffcPath or dffPath
		if fileExists(dffPath) then
			if not decodeDFF then

				dff = engineLoadDFF( dffPath, model )
				engineReplaceModel(dff, model)

			else

				local file = fileOpen(dffPath, true)

				file.pos = Config.headerLength
				local dffData = file:read(file.size - Config.footerLength)

				dff = engineLoadDFF(dffData)

				if dff then
					engineReplaceModel(dff, model)
				end

				fileClose(file)
				
			end
		end

		local colPath = convertFilePath( data.col or path ) .. '.col'
		if fileExists( colPath ) then
			col = engineLoadCOL(colPath, model)
			engineReplaceCOL(col, model)
		end

		if data.lod then
			engineSetModelLODDistance(model, data.lod)
		end

	end

	addCommandHandler('std_loadmodel', function(_, path, model)
		replaceModel(path, model)
	end)

--------------------------------------------------
