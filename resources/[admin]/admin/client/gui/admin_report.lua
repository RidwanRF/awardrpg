--[[**********************************
*
*	Multi Theft Auto - Admin Panel
*
*	gui\admin_report.lua
*
*	Original File by lil_Toady
*
**************************************]]

aReportForm = nil

function aReport ( player )
	if ( aReportForm == nil ) then
		local x, y = guiGetScreenSize()
		aReportForm		= guiCreateWindow ( x / 2 - 150, y / 2 - 150, 300, 300, "Связь с администрацией", false )
					   guiCreateLabel ( 0.05, 0.11, 0.20, 0.09, "Категория:", true, aReportForm )
					   guiCreateLabel ( 0.05, 0.21, 0.20, 0.09, "Тема:", true, aReportForm )
					   guiCreateLabel ( 0.05, 0.30, 0.20, 0.07, "Сообщение:", true, aReportForm )
		aReportCategory	= guiCreateEdit ( 0.30, 0.10, 0.65, 0.09, "Вопрос", true, aReportForm )
					   guiEditSetReadOnly ( aReportCategory, true )
		aReportDropDown	= guiCreateStaticImage ( 0.86, 0.10, 0.09, 0.09, "client\\images\\dropdown.png", true, aReportForm )
					   guiBringToFront ( aReportDropDown )
		aReportCategories	= guiCreateGridList ( 0.30, 0.10, 0.65, 0.30, true, aReportForm )
					   guiGridListAddColumn( aReportCategories, "", 0.85 )
					   guiSetVisible ( aReportCategories, false )
					   guiGridListSetItemText ( aReportCategories, guiGridListAddRow ( aReportCategories ), 1, "Вопрос", false, false )
					   guiGridListSetItemText ( aReportCategories, guiGridListAddRow ( aReportCategories ), 1, "Предложение", false, false )
					   guiGridListSetItemText ( aReportCategories, guiGridListAddRow ( aReportCategories ), 1, "Читер", false, false )
					   guiGridListSetItemText ( aReportCategories, guiGridListAddRow ( aReportCategories ), 1, "Другое", false, false )
		aReportSubject		= guiCreateEdit ( 0.30, 0.20, 0.65, 0.09, "", true, aReportForm )
		aReportMessage	= guiCreateMemo ( 0.05, 0.38, 0.90, 0.45, "", true, aReportForm )
		aReportAccept		= guiCreateButton ( 0.40, 0.88, 0.25, 0.09, "Отправить", true, aReportForm )
		aReportCancel		= guiCreateButton ( 0.70, 0.88, 0.25, 0.09, "Отмена", true, aReportForm )

		addEventHandler ( "onClientGUIClick", aReportForm, aClientReportClick )
		addEventHandler ( "onClientGUIDoubleClick", aReportForm, aClientReportDoubleClick )
	end
	guiBringToFront ( aReportForm )
	showCursor ( true )
	guiSetInputMode("no_binds_when_editing")
end
addCommandHandler ( "report", aReport )

function aReportClose ( )
	if ( aReportForm ) then
		removeEventHandler ( "onClientGUIClick", aReportForm, aClientReportClick )
		removeEventHandler ( "onClientGUIDoubleClick", aReportForm, aClientReportDoubleClick )
		destroyElement ( aReportForm )
		aReportForm = nil
		showCursor ( false )
		guiSetInputMode("allow_binds")
	end
end

function aClientReportDoubleClick ( button )
	if ( button == "left" ) then
		if ( source == aReportCategories ) then
			if ( guiGridListGetSelectedItem ( aReportCategories ) ~= -1 ) then
				local cat = guiGridListGetItemText ( aReportCategories, guiGridListGetSelectedItem ( aReportCategories ), 1 )
				guiSetText ( aReportCategory, cat )
				guiSetVisible ( aReportCategories, false )
			end
		end
	end
end

function aClientReportClick ( button )
	if ( source == aReportCategory ) then
		guiBringToFront ( aReportDropDown )
	end
	if ( source ~= aReportCategories ) then
		guiSetVisible ( aReportCategories, false )
	end
	if ( button == "left" ) then
		if ( source == aReportAccept ) then
			if ( ( string.len ( guiGetText ( aReportSubject ) ) < 1 ) or ( string.len ( guiGetText ( aReportMessage ) ) < 5 ) ) then
				aMessageBox ( "error", "Пожалуйста, введите сообщение и тему." )
			else
				aMessageBox ( "info", "Ваше сообщение было отправлено. Мы рассмотрим его в ближайшее время." )
				setTimer ( aMessageBoxClose, 3000, 1, true )
				local tableOut = {}
				tableOut.category = guiGetText ( aReportCategory )
				tableOut.subject = guiGetText ( aReportSubject )
				tableOut.message = guiGetText ( aReportMessage )
				triggerServerEvent ( "aMessage", getLocalPlayer(), "new", tableOut )
				aReportClose ()
			end
		elseif ( source == aReportSubject ) then
			
		elseif ( source == aReportMessage ) then
			
		elseif ( source == aReportCancel ) then
			aReportClose ()
		elseif ( source == aReportDropDown ) then
			guiBringToFront ( aReportCategories )
			guiSetVisible ( aReportCategories, true )
		end
	end
end