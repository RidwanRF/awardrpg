
local Superman = {}

-- Resource events
addEvent("superman:start", true)
addEvent("superman:stop", true)

local data
--
-- Start/stop functions
--
function Superman.Start(player)
  local acc = getPlayerAccount (player)
  if isGuestAccount (acc) then return end
  local accname = getAccountName(acc)
  if isObjectInACLGroup ("user."..accname, aclGetGroup ( "Founder" ) ) then
    setElementData(player, "flyDostup", true)
  else 
    setElementData(player, "flyDostup", false)
    outputChatBox("У вас нету доступа к флаю!", player, 255, 255, 255, true)
  end
end
addEvent("Superman", true)
addEventHandler("Superman", root, Superman.Start)

function Superman.clientStart()
  setElementData(client, "superman:flying", true)
end

function Superman.clientStop()
  setElementData(client, "superman:flying", false)
end
