local vipStatus
local tableVIPs = {}

function isPlayerVIP (pl)
if not pl then pl = localPlayer end
return tableVIPs[pl]
end

function getVIPsTable ()
return tableVIPs
end

function updateStatus (res)
vipStatus = res
end
addEvent ("updateVIP", true)
addEventHandler ("updateVIP", root, updateStatus)

function updateVIPs (pl, stat)
tableVIPs[pl] = stat
end
addEvent ("updateVIPs", true)
addEventHandler ("updateVIPs", root, updateVIPs)