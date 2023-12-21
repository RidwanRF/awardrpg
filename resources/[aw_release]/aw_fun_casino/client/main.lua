
----------------------------------------------------

	function openWindow(section, ...)

		currentWindowArgs = { ... }

		currentWindowSection = section
		setWindowOpened(true)
		
	end
	addEvent('casino.openWindow', true)
	addEventHandler('casino.openWindow', resourceRoot, openWindow)

----------------------------------------------------

	function closeWindow()
		setWindowOpened(false)
	end
	addEvent('casino.closeWindow', true)
	addEventHandler('casino.closeWindow', resourceRoot, closeWindow)

----------------------------------------------------

	function bind_openWindow(section, marker, ...)

		bind_openWindowData = { ... }

		createBindHandler(marker, 'f', 'Открыть окно', function(marker)
			if isElementWithinMarker( localPlayer, marker ) then
				
				openWindow( section, unpack( bind_openWindowData ) )
			end
		end)

		callBindHandler(marker)

	end
	addEvent('casino.bind_openWindow', true)
	addEventHandler('casino.bind_openWindow', resourceRoot, bind_openWindow)

