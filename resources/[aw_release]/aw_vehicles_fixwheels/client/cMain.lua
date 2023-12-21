function awardFixWheels()
    setVehicleModelWheelSize(421, "all_wheels", 0.8) 
    setVehicleModelWheelSize(418, "all_wheels", 0.8) 
    setVehicleModelWheelSize(412, "all_wheels", 0.8) 
end
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), awardFixWheels)