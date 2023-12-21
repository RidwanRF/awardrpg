------------------------------------
--//          Skynet            //--
--//   vk.com/studioskynet     //--
-----------------------------------
saveFile = function (path, data)
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
addEvent("saveFileComponents", true)
addEventHandler("saveFileComponents", resourceRoot, saveFile)
------------------------------------
--//          Skynet            //--
--//   vk.com/studioskynet     //--
-----------------------------------