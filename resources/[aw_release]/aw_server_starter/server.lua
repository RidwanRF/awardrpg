addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
        if string.find(getResourceName(v), "aw_server_starter") then
            stopResource(v)
            outputDebugString('aw_server_starter starter | '..getResourceName(v)..' has stopped!')
	    end
    end
end)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
        if string.find(getResourceName(v), "aw_server_starter") then
            startResource(v)
            outputDebugString('aw_server_starter starter | '..getResourceName(v)..' has started!')
        end
    end
end)

addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
        if string.find(getResourceName(v), "aw") then
            stopResource(v)
            outputDebugString('aw_server_starter | '..getResourceName(v)..' has stopped!')
	    end
    end
end)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
        if string.find(getResourceName(v), "aw") then
            startResource(v)
            outputDebugString('aw_server_starter | '..getResourceName(v)..' has started!')
        end
    end
end)