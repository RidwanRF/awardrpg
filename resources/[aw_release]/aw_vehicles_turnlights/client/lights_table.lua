LightsTable = {}

--[[ Chiron
LightsTable[506] = {
    specialAnimation = function (vehicle, deltaTime, lights)
        lights.time = lights.time + deltaTime

        local time1 = 1
        local timePause = 0.4
        local time2 = 0.4
        local timePause2 = 0.5
        local time3 = 2
        if lights.time < time1 then
            local progress = lights.time * 4 / time1
            local index = math.ceil(progress)
            progress = progress - index + 1
            local color = 0.3 * progress
            setVehicleCustomLightState(vehicle, "headlight"..index, true, {color, color, color})
        elseif lights.time > time1 + timePause and lights.time < time1 + timePause + time2 then
            local progress = (lights.time - time1 - timePause) * 4 / time2
            local index = math.ceil(progress)
            progress = progress - index + 1
            index = 5 - index
            local color = 0.3 + progress * 0.7
            setVehicleCustomLightState(vehicle, "headlight"..index, true, {color, color, color})
        elseif lights.time > time1 + timePause + time2 + timePause2 and lights.time < time1 + timePause + time2 + timePause2 + time3 then
            local progress = 1 - (lights.time - (time1 + timePause + time2 + timePause2)) / time3
            setVehicleCustomLightState(vehicle, "headlight1", true, {progress, progress, progress})
            setVehicleCustomLightState(vehicle, "headlight2", true, {progress, progress, progress})
            setVehicleCustomLightState(vehicle, "headlight3", true, {progress, progress, progress})
            setVehicleCustomLightState(vehicle, "headlight4", true, {progress, progress, progress})
        end
    end,

    lights = {
        {name = "headlight1", material = "chiron_headlight_1", color = {1, 1, 1}},
        {name = "headlight2", material = "chiron_headlight_2", color = {1, 1, 1}},
        {name = "headlight3", material = "chiron_headlight_3", color = {1, 1, 1}},
        {name = "headlight4", material = "chiron_headlight_4", color = {1, 1, 1}},
    }
}

LightsTable[422] = {
    turnLightsDelay = 0.5,

    update = function (vehicle, deltaTime, lights, turnLeftState, turnRightState)
        if not lights.state then
            return
        end
        local animationTime = 0.3
        local fadeTime = 0.38
        if lights.time < animationTime then
            local index = math.floor(lights.time / animationTime * 5)
            if turnLeftState then
                setVehicleCustomLightState(vehicle, "audi_turn_left_"..index, true, {1, 0.5, 0})
            end
            if turnRightState then
                setVehicleCustomLightState(vehicle, "audi_turn_right_"..index, true, {1, 0.5, 0})
            end
        elseif lights.time > fadeTime then
            local progress = 1 - (lights.time - fadeTime)/(0.5 - fadeTime)
            if turnLeftState then
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_left_"..i, true, {progress, progress * 0.5, 0})
                end
            end
            if turnRightState then
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_right_"..i, true, {progress, progress * 0.5, 0})
                end
            end
        end
    end,

    handleLightsState = function (vehicle, name, state)
        if not state then
            if name == "turn_left" then
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_left_"..i, false)
                end
            elseif name == "turn_right" then
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_right_"..i, false)
                end
            elseif name == "emergency_light" then
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_left_"..i, false)
                end
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_right_"..i, false)
                end
            end
        end
    end,

    update = function (vehicle, deltaTime, lights, turnLeftState, turnRightState)
        if not lights.state then
            return
        end
        local animationTime = 0.3
        local fadeTime = 0.38
        if lights.time < animationTime then
            local index = math.floor(lights.time / animationTime * 5)
            if turnLeftState then
                setVehicleCustomLightState(vehicle, "audi_turn_left_"..index, true, {1, 0.5, 0})
            end
            if turnRightState then
                setVehicleCustomLightState(vehicle, "audi_turn_right_"..index, true, {1, 0.5, 0})
            end
        elseif lights.time > fadeTime then
            local progress = 1 - (lights.time - fadeTime)/(0.5 - fadeTime)
            if turnLeftState then
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_left_"..i, true, {progress, progress * 0.5, 0})
                end
            end
            if turnRightState then
                for i = 0, 4 do
                    setVehicleCustomLightState(vehicle, "audi_turn_right_"..i, true, {progress, progress * 0.5, 0})
                end
            end
        end
    end,

    lights = {
        {name = "audi_turn_left_0", material = "audi_turn_left_0", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_1", material = "audi_turn_left_1", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_2", material = "audi_turn_left_2", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_3", material = "audi_turn_left_3", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_4", material = "audi_turn_left_4", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_right_0", material = "audi_turn_right_0", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_1", material = "audi_turn_right_1", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_2", material = "audi_turn_right_2", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_3", material = "audi_turn_right_3", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_right_4", material = "audi_turn_right_4", brightness = 0.7, color = {1, 0.5, 0}},
    }
}

LightsTable[517] = {

    update = function (vehicle, deltaTime, lights, turnLeftState, turnRightState, brakeState, reverseState)
        if turnLeftState then
            setVehicleCustomLightState(vehicle, "reverseturn_left", lights.state, {1, 0.5, 0})
        else
            setVehicleCustomLightState(vehicle, "reverseturn_left", reverseState, {1, 1, 1})
        end
        if turnRightState then
            setVehicleCustomLightState(vehicle, "reverseturn_right", lights.state, {1, 0.5, 0})
        else
            setVehicleCustomLightState(vehicle, "reverseturn_right", reverseState, {1, 1, 1})
        end
    end,

    handleLightsState = function (vehicle, name, state)
        if not state then
            if name == "turn_left" then
                setVehicleCustomLightState(vehicle, "reverseturn_left", state)
            elseif name == "turn_right" then
                setVehicleCustomLightState(vehicle, "reverseturn_right", state)
            elseif name == "rear" then
                setVehicleCustomLightState(vehicle, "reverseturn_left", state)
                setVehicleCustomLightState(vehicle, "reverseturn_right", state)
            end
        end
    end,

    lights = {
        {name = "reverseturn_left",  color = {1, 0.5, 0}},
        {name = "reverseturn_right", color = {1, 0.5, 0}},
    }
}]]
