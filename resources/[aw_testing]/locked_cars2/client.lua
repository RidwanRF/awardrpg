

local models = {

        {"m5f90.txdrw","m5f90.dffrw",nil,421,"JdzFR2XLDaBtpGGD",ENCODE = {true,true,false}, verysafety = false},
         {"f-150.txdrw","f-150.dffrw",nil,591,"JdzFR2XLDaBtpGGD",ENCODE = {true,true,false}, verysafety = false},
           {"m4f83.txdrw","m4f83.dffrw",nil,527,"JdzFR2XLDaBtpGGD",ENCODE = {true,true,false}, verysafety = false},  
           {"rs7.txdrw","rs7.dffrw",nil,438,"JdzFR2XLDaBtpGGD",ENCODE = {true,true,false}, verysafety = false},  










}



addEventHandler("onClientResourceStart",resourceRoot,

function()

	for i = 1, #models do	

		-- замена txd

		if models[i][1] then

			if models[i].ENCODE[1] then

				if not fileExists(models[i][1]) then

					outputDebugString('Отсутствие файла в кореневом каталоге главного ресурса! (TXD)', 1)

					return false

				end

				local TxdFile = exports["DECODE21"]:fileDecode(":"..getResourceName(resource).."/"..models[i][1],models[i][5],models[i].verysafety)

				if not TxdFile then

					outputDebugString('Проблема с файлом. Невозможна дешифрация! (TXD)', 1)

					return false

				end

				engineImportTXD(engineLoadTXD(TxdFile),models[i][4]) 

				if not models[i].verysafety then

					exports["DECODE21"]:SafetyDelete(TxdFile)

				end

			else

				engineImportTXD(engineLoadTXD(models[i][1]),models[i][4])

			end

		end

		-- замена dff

		if models[i][2] then

			if models[i].ENCODE[2] then

				if not fileExists(models[i][2]) then

					outputDebugString('Отсутствие файла в кореневом каталоге главного ресурса! (DFF)', 1)

					return false

				end

				local DffFile = exports["DECODE21"]:fileDecode(":"..getResourceName(resource).."/"..models[i][2],models[i][5],models[i].verysafety)

				if not DffFile then

					outputDebugString('Проблема с файлом. Невозможна дешифрация! (DFF)', 1)

					return false

				end

				engineReplaceModel(engineLoadDFF(DffFile),models[i][4])

				if not models[i].verysafety then

					exports["DECODE21"]:SafetyDelete(DffFile)

				end

			else

				engineReplaceModel(engineLoadDFF(models[i][2]),models[i][4])

			end

		end

		-- замена col

		if models[i][3] then	

			if models[i].ENCODE[2] then

				if not fileExists(models[i][3]) then

					outputDebugString('Отсутствие файла в кореневом каталоге главного ресурса! (COL)', 1)

					return false

				end

				local ColFile = exports["DECODE21"]:fileDecode(":"..getResourceName(resource).."/"..models[i][3],models[i][5],models[i].verysafety)

				if not ColFile then

					outputDebugString('Проблема с файлом. Невозможна дешифрация! (COL)', 1)

					return false

				end

				engineReplaceCOL(engineLoadCOL(ColFile),models[i][4])

				if not models[i].verysafety then

					exports["DECODE21"]:SafetyDelete(ColFile)

				end

			else

				engineReplaceCOL(engineLoadCOL(models[i][3]),models[i][4])

			end

		end

	end

end)