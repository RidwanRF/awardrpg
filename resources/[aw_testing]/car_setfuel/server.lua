function set_fuel (source)
  local accName = getAccountName ( getPlayerAccount ( source ) )
  if isObjectInACLGroup ("user."..accName, aclGetGroup ( "GLAdmin" ) ) then
    currentVehicle = getPedOccupiedVehicle(source)
    if(currentVehicle) then
      setElementData(currentVehicle, "fuel", 50)
      outputChatBox ("#00e600Вы заправили данный автомобиль до #25500050#00e600 л.",source,225,225,0,true)
    else
      outputChatBox ("[X] #ff3333Вы должны быть находится в машине, которую хотите заправить!.",source,255,0,0,true)
    end
  end
end
addCommandHandler("setfuel",set_fuel)

