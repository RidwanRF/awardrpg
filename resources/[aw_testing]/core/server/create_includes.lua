
------------------------------

	function readFile(path)
		local content = ''
		local file = fileExists(path) and fileOpen(path) or false
		if file then
			content = fileRead( file, fileGetSize(file) )
			fileClose(file)
		end
		return content
	end

	function writeFile(path, content)
		if fileExists(path) then fileDelete(path) end

		local file = fileCreate( path )
		fileWrite(file, content)
		fileClose(file)

	end

------------------------------

	function createIncludes()

		local includes = {}

		for _, fileName in pairs( includeFiles ) do
			includes[fileName] = readFile( string.format('assets/opensources/%s.source', fileName) ):gsub('\r', '')
		end

		return includes

	end

	function createIncludesFileContent(includes)

		local content = [=[
includes = {}
		]=]

		for fileName, sourceCode in pairs(includes) do
			content = content .. string.format([=[
includes['%s'] = [===[--%s
%s]===]
			]=], fileName, fileName, sourceCode)
		end

		return content

	end

	function clearOps(str)
		-- str = str:gsub('\n', '')
		-- str = str:gsub('\r', '')
		-- str = str:gsub('\t', '')
		-- str = str:gsub(' ', '')
		return str
	end

------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		local filepath = 'shared/includes.lua'
		local current_content = readFile( filepath )

		local new_includes = createIncludes()
		local new_content = createIncludesFileContent(new_includes)

		if clearOps(current_content) ~= clearOps(new_content) then

			if fileExists( filepath ) then
				fileDelete( filepath )
			end

			local file = fileCreate( filepath )

			fileWrite(file, new_content)

			fileClose( file )

			print(getTickCount(  ), '[CORE] updating includes')

			restartResource( getThisResource() )

		end

	end)


------------------------------