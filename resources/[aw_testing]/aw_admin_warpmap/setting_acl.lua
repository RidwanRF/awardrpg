--Автор : [CBAO]Fitil
--Группа источника : https://vk.com/every_taste_mta

function get_player_acl_tp ()
	for k,v in ipairs(getElementsByType( "player" )) do
		local accountname = ""
		if (isGuestAccount(getPlayerAccount(v)) == false) then
			accountname = getAccountName (getPlayerAccount(v))
			--setElementData(v,"mpPan",false)
			if isObjectInACLGroup("user." .. accountname,aclGetGroup("Founder")) then
				setElementData(v,"mpPan",true)
			end
			if isObjectInACLGroup("user." .. accountname,aclGetGroup("DeputyFounder")) then
				setElementData(v,"mpPan",true)
			end
			if isObjectInACLGroup("user." .. accountname,aclGetGroup("ZGA")) then
				setElementData(v,"mpPan",true)
			end
			if isObjectInACLGroup("user." .. accountname,aclGetGroup("GA")) then
				setElementData(v,"mpPan",true)
			end
			if isObjectInACLGroup("user." .. accountname,aclGetGroup("Admin")) then
				setElementData(v,"mpPan",true)
			end
			if isObjectInACLGroup("user." .. accountname,aclGetGroup("SuperModerator")) then
				setElementData(v,"mpPan",true)
			end
			if isObjectInACLGroup("user." .. accountname,aclGetGroup("Moderator")) then
				setElementData(v,"mpPan",true)
			end
		end
	end
end
addEvent("get_player_acl_tp",true)
addEventHandler("get_player_acl_tp",getRootElement(),get_player_acl_tp)
