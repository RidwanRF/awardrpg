-------------------------------------------------------------------

-- Название: custom_lights.lua

-- Описание: Описание дополнительных фар и кастомного поведения

-------------------------------------------------------------------



CustomLights = {}



-- CustomLights[модель] = {

--

--     Вызывается, когда фары создались. Здесь можно переопределить интервал поворотников и т.д.

--     init = function (anim, vehicle)

--         anim.turnLightsInterval = 0.25

--     end

--

--     Обработка обновления фар. Вызывается после стандартного updateVehicle в lights_anim.lua

--     update = function (anim, deltaTime, vehicle)

--

--         Через таблицу 'anim' можно управлять светом:

--         anim.setLightState("turn_left", true)

--         anim.getLightState("turn_left")

--         anim.setLightColor("rear", 1, 0, 0)

--         anim.getLightColor("rear")

--

--         Также можно получать состояние поворотников

--         anim.turnLightsTime      - время в текущем состоянии поворотников

--         anim.turnLightsState     - состояние поворотников

--         anim.turnLightsInterval  - интервал мигания поворотников

--

--         Таблица 'anim' создается в LightsAnim.addVehicle(vehicle)

--     end

--

--     Обработчики изменения состояния конкретных фар

--     Могут использоваться для дублирования стандартных поворотников кастомными

--     stateHandlers = {

--         ["turn_left"] = function (anim, state, vehicle)

--             Передается такая же таблица 'anim', состояние и элемент автомобиля

--         end

--     }

--

--     Обработчики включения/выключения поворотников и т. д.

--     dataHandlers = {

--         ["turn_left"] = function (anim, state, vehicle)

--             Передается такая же таблица 'anim', состояние и элемент автомобиля

--         end

--     }

--

--     Таблица кастомных фонарей

--     lights = {

--         {name = "название" [, color = {r, g, b}, brightness = <0-1>, material = "название материала"] },

--         {name = "custom_light_1",  color = {1, 0.5, 0}},

--     }

-- }



local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0

local FPSNornal = 50 -- Допустимый FPS

addEventHandler("onClientRender",root,

function()

    local currentTick = getTickCount()

    local elapsedTime = currentTick - lastTick

    if elapsedTime >= 1000 then

        FPS = framesRendered

        lastTick = currentTick

        framesRendered = 2

    else

        framesRendered = framesRendered + 1

    end

    

    if FPS > FPSLimit then

        FPS = FPSLimit

    end

end)



-- Создание поворотников, которые будут дублировать габариты

local function makeTurnMirrorFront(model, leftLight, rightLight, frontColor, turnColor)

    if not frontColor then

        frontColor = {1, 1, 1}

    end

    if not turnColor then

        turnColor = {1, 0.5, 0}

    end

    CustomLights[model] = {

        stateHandlers = {

            ["turn_left"] = function (anim, state)

                if state then

                    anim.setLightColor(leftLight.name, unpack(turnColor))

                end

                anim.setLightState(leftLight.name, state)

            end,

            ["turn_right"] = function (anim, state)

                if state then
                    anim.setLightColor(rightLight.name, unpack(turnColor))

                end

                anim.setLightState(rightLight.name, state)

            end,

            ["front"] = function (anim, state)

                -- Если включен поворотник, состояние не обновляется

                if not anim.getLightState("turn_left") then

                    if state then

                        anim.setLightColor(leftLight.name, unpack(frontColor))

                    end

                    anim.setLightState(leftLight.name, state)

                end

                if not anim.getLightState("turn_right") then

                    if state then

                        anim.setLightColor(rightLight.name, unpack(frontColor))

                    end

                    anim.setLightState(rightLight.name, state)

                end

            end

        },



        dataHandlers = {

            ["turn_left"] = function (anim, state)

                if not state and anim.getLightState("front") then

                    anim.setLightColor(leftLight.name, unpack(frontColor))

                    anim.setLightState(leftLight.name, true)

                end

            end,

            ["turn_right"] = function (anim, state)

                if not state and anim.getLightState("front") then

                    anim.setLightColor(rightLight.name, unpack(frontColor))

                    anim.setLightState(rightLight.name, true)

                end

            end,

            ["emergency_light"] = function (anim, state)

                if not state and anim.getLightState("front") then

                    anim.setLightColor(leftLight.name, unpack(frontColor))

                    anim.setLightState(leftLight.name, true)

                    anim.setLightColor(rightLight.name, unpack(frontColor))

                    anim.setLightState(rightLight.name, true)

                end

            end

        },



        lights = {

            leftLight,

            rightLight,

        }

    }

end


-- Porsche Taycan

makeTurnMirrorFront(546,
    {name = "taukan_turn_left",  material = "taukan_turn_left_*" },
    {name = "taukan_turn_right", material = "taukan_turn_right_*" }
)


-- Ferrari SF90 Stradale '20
makeTurnMirrorFront(429,
    {name = "fera_turn_left",  material = "fera_turn_left_*" },
    {name = "fera_turn_right", material = "fera_turn_right_*" }
)

makeTurnMirrorFront(471,

    {name = "gls_turn_left",  material = "gls_turn_left_*" },

    {name = "gls_turn_right", material = "gls_turn_right_*" }

)



-- EQS

makeTurnMirrorFront(555,

    {name = "gls_turn_left",  material = "gls_turn_left_*" },

    {name = "gls_turn_right", material = "gls_turn_right_*" }

)



-- фера

makeTurnMirrorFront(429,

    {name = "fera_turn_left",  material = "fera_turn_left_*" },

    {name = "fera_turn_right", material = "fera_turn_right_*" }

)



-- m2 cs

makeTurnMirrorFront(602,

    {name = "gls_turn_left",  material = "gls_turn_left_*" },

    {name = "gls_turn_right", material = "gls_turn_right_*" }

)




--авто
CustomLights[418] = {
    init = function (anim)
        anim.turnLightsInterval = 0.35
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_left_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_left_1", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_right_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_right_1", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_left_1", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_right_1", state)
            end
        end,
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end
    },

    lights = {
        {name = "shader_turn_left_1",  material = "shader_turn_left_1" , colorMul = 1.6 },
        {name = "shader_turn_right_1", material = "shader_turn_right_1", colorMul = 1.6 },
    }
}



-- lx600

makeTurnMirrorFront(466,

    {name = "f90_turn_left",  material = "f90_turn_left_*" },

    {name = "f90_turn_right", material = "f90_turn_right_*" }

)

-- Porsche 911 Carrera S '20
makeTurnMirrorFront(415,
    {name = "911_turn_left",  material = "911_turn_left_*" },
    {name = "911_turn_right", material = "911_turn_right_*" }
)

-- new_ford

makeTurnMirrorFront(401,

    {name = "gls_turn_left",  material = "gls_turn_left_*" },

    {name = "gls_turn_right", material = "gls_turn_right_*" }

)

-- f90 cs

makeTurnMirrorFront(560,

    {name = "gls_turn_left",  material = "gls_turn_left_*" },

    {name = "gls_turn_right", material = "gls_turn_right_*" }

)



-- octavia

makeTurnMirrorFront(496,

    {name = "vrs_turn_left",  material = "vrs_turn_left_*" },

    {name = "vrs_turn_right", material = "vrs_turn_right_*" }

)

-- Bentley GT
CustomLights[518] = {
    init = function (anim)
        anim.turnLightsInterval = 0.47
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("ben_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("ben_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("ben_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("ben_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("ben_turn_left", 1, 1, 1)
                end
                anim.setLightState("ben_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("ben_turn_right", 1, 1, 1)
                end
                anim.setLightState("ben_turn_right", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("ben_headlight", 1, 1, 1)
                end
                anim.setLightState("ben_headlight", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("ben_turn_left", 1,1,1)
                anim.setLightState("ben_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("ben_turn_right", 1,1,1)
                anim.setLightState("ben_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("ben_turn_left", 1,1,1)
                anim.setLightState("ben_turn_left", true)
                anim.setLightColor("ben_turn_right", 1,1,1)
                anim.setLightState("ben_turn_right", true)
                anim.setLightColor("ben_headlight", 1,1,1)
                anim.setLightState("ben_headlight", true)
            end
        end
    },

    lights = {
        {name = "ben_turn_left",  material = "ben_turn_left_*" , colorMul = 1.3 },
        {name = "ben_turn_right", material = "ben_turn_right_*", colorMul = 1.3 },
        {name = "ben_headlight", material = "ben_headlight_*", colorMul = 1.3 },
    }
}
--Huracan
CustomLights[600] = {
    init = function (anim)
        anim.turnLightsInterval = 0.35
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_left_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_left_1", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_right_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_right_1", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_left_1", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_right_1", state)
            end
        end,
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end
    },

    lights = {
        {name = "shader_turn_left_1",  material = "shader_turn_left_1" , colorMul = 1.6 },
        {name = "shader_turn_right_1", material = "shader_turn_right_1", colorMul = 1.6 },
    }
}



--Е60
CustomLights[550] = {
    init = function (anim)
        anim.turnLightsInterval = 0.35
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_left_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_left_1", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_right_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_right_1", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_left_1", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_right_1", state)
            end
        end,
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end
    },

    lights = {
        {name = "shader_turn_left_1",  material = "shader_turn_left_1" , colorMul = 1.6 },
        {name = "shader_turn_right_1", material = "shader_turn_right_1", colorMul = 1.6 },
    }
}
-- RS6 

CustomLights[551] = {   

    init = function (anim)

        anim.turnLightsInterval = 0.85

        -- Время, за которое загораются все блоки

    if FPS > FPSNornal then 

        anim.rearLightsTime = 0.35

    else 

        anim.rearLightsTime = 0.55

    end

        -- Время, после которого свет начинает плавно затухать

        anim.rearLightsFadeAfter = 0.35

    end,



    update = function (anim, deltaTime, vehicle)

        --print (anim.specialAnimActive)

        

        

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.turnLightsState then

            if anim.turnLightsTime < anim.rearLightsTime then

                -- Включение блоков по очереди

             --   local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0

                local index = math.floor(anim.turnLightsTime/ anim.rearLightsTime * 12)

                



                if anim.getLightState("turn_left") then

                   anim.setLightState("rs6r_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

                if anim.getLightState("turn_right") then

                   anim.setLightState("rs6r_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

            elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

               if anim.getLightState("turn_left") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

                if anim.getLightState("turn_right") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

            end

        end

        

        if anim.specialAnimActive then

            local currentTime = anim.specialAnimTime

            if anim.specialAnimData == "anim_on" or anim.specialAnimData == "enable" then

                 time0 = 0 -- Задержка старта анимации    

                 time2 = 0.5 -- Время прохождения "щелчка", после основной анимации на передних фарах

                 time4 = 1 -- ?             

                 timePause0 = 0.1

                 timePause01 = 0 -- Задержка старта анимации          

                 timePause = 0.03

                 timePause2 = 0.5



            if FPS > FPSNornal then 

                time1 = 0.2 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time0 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    local index = math.floor(currentTime/time0 * 12)

                    anim.setLightState("rs6f_turn_left_"..index, false)

                    anim.setLightColor("rs6f_turn_left_"..index, 1, 0.5, 0)

                    anim.setLightState("rs6f_turn_right_"..index, false)

                    anim.setLightColor("rs6f_turn_right_"..index, 1, 0.5, 0)

                elseif currentTime > time0 + timePause0 and currentTime < time0 + timePause0 + timePause01 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    for i = 0, 11 do

                        anim.setLightColor("rs6f_turn_left_"..i, 0, 0, 0)

                        anim.setLightColor("rs6f_turn_right_"..i, 0, 0, 0)

                    end

                elseif currentTime > time0 + timePause0 + timePause01 then

                    currentTime = currentTime - (time0 + timePause0 + timePause01)

                    for i = 0, 12 do

                        if currentTime > time1*i and currentTime < time1*(i+1) + timePause*i then

                            --local progress = (currentTime-time1*i-timePause*i) * 12 / time1

                            local progress = (currentTime-time1*i-timePause*i) / time1 * 13

                            local index = math.ceil(progress) - 1

                            local index2 = 12 + i - index

                            

                            anim.setLightState("rs6f_turn_left_"..index2, true)

                            anim.setLightColor("rs6f_turn_left_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_left_"..index2 + 1, false)

                            

                            anim.setLightState("rs6f_turn_right_"..index2, true)

                            anim.setLightColor("rs6f_turn_right_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_right_"..index2 + 1, false)

                        elseif currentTime > time1*12 + timePause*12 + timePause2 then

                            for i = 0, 12 do

                                local currentTime2 = currentTime - time1*12 - timePause*12 - timePause2

                                if currentTime2 > time2*i and currentTime2 < time2*(i+1) + timePause*i then

                                    local progress = (currentTime2-time2*i-timePause*i) * 12 / time2

                                    local index = math.ceil(progress)

                                    local index2 = index

                                    progress = progress - index

                                    anim.setLightColor("rs6f_turn_left_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_left_"..index2-1, 1, 1, 1)

                                    

                                    anim.setLightColor("rs6f_turn_right_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_right_"..index2 - 1, 1, 1, 1)

                                    if index2 >= 12 then

                                        for i = 0, 12 do

                                            anim.setLightState("rs6f_turn_left_"..i, true)

                                            anim.setLightState("rs6f_turn_right_"..i, true)

                                            anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                                            anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                                        end

                                        anim.stopSpecialAnimation()

                                    end

                                end

                            end

                        end

                    end

                    

                    for i = 0, 9 do

                        if currentTime > time3*i and currentTime < time3*(i+1) + timePause*i then

                            local progress = (currentTime-time3*i - timePause*i) / time3 * 8

                            local index = math.ceil(progress)

                            local index2 = 9 + i - index

                            --[[if i < 1 then

                                print (i, index, index2)

                            end]]

                            

                            if index2 >= 0 then

                                if index2 < 10 then

                                    anim.setLightState("rs6_brake_"..index2, true)

                                    anim.setLightColor("rs6_brake_"..index2, 1, 0, 0)

                                    if index2 + 1 ~= 10 then

                                        anim.setLightState("rs6_brake_"..index2 + 1, false)

                                    end

                                end

                            end

                        end

                    end

                    

                    local progress = getEasingValue (currentTime/(time3*10 + timePause*9), "InQuad")

                    if progress <= 1 then

                      --  print (currentTime, progress)

                        anim.setLightState("rs6_brake_10", true)

                        anim.setLightColor("rs6_brake_10", 1*progress, 0, 0)

                    end

                end

                elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

                local time2 = 0.9 -- ? 

                local timePause = 0.9



            if FPS > FPSNornal then 

                time1 = 0.6 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time1 then

                    local progress = currentTime * 12 / time1

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    local color = 0.1 * progress

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 and currentTime < time1 + time2 then

                    local progress = (currentTime - time1) * 12 / time2

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    index = 11 - index

                    local color = 1 - 0.65 * progress

                    --anim.setLightState("rs6f_turn_left_"..index, )

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 + time2 + timePause then

                    for i = 0, 11 do

                        anim.setLightState("rs6f_turn_left_"..i, false)

                        anim.setLightState("rs6f_turn_right_"..i, false)

                        anim.stopSpecialAnimation()

                    end  

                end

                

                if currentTime < time3 then

                    local progress = currentTime * 9 / time3

                    local index = math.ceil(progress)

                    progress = progress - index + 1

                    anim.setLightState("rs6_brake_"..(10 - index), false)

                end

                

                local progress = getEasingValue (currentTime/time3, "InQuad")

                --print (progress)

                if progress <= 1 then

                    anim.setLightState("rs6_brake_10", true)

                    anim.setLightColor("rs6_brake_10", 1 - 1*progress, 0, 0)

                end

            end

        end

    end,

    

   stateHandlers = {

        ["turn_left"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_left_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_left_" ..i, false)

          anim.setLightState("rs6f_turn_left_" ..i, false)

        end

            end

        end,

        ["turn_right"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_right_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_right_" ..i, false)

          anim.setLightState("rs6f_turn_right_" ..i, false)

        end

            end

        end,

        ["front"] = function (anim, state, veh)

            if state then

                anim.startSpecialAnimation(veh, "anim_on")

            else

                anim.startSpecialAnimation(veh, "anim_off")

            end

        end,

    },



    dataHandlers = {

        ["turn_left"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_left_" ..i, true)

        end

      end

    end,

    ["turn_right"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_right_" ..i, true)

        end

      end

    end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 12 do

                    anim.setLightState("rs6f_turn_left_"..i, true)

                    anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                    anim.setLightState("rs6f_turn_right_"..i, true)

                    anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                end

            end

        end

    },



    lights = {

        {name = "rs6f_turn_left_0",  material = "rs6f_turn_left_0" , colorMul = 1.6 },

        {name = "rs6f_turn_left_1",  material = "rs6f_turn_left_1" , colorMul = 1.6 },

        {name = "rs6f_turn_left_2",  material = "rs6f_turn_left_2" , colorMul = 1.6 },

        {name = "rs6f_turn_left_3",  material = "rs6f_turn_left_3" , colorMul = 1.6 },

        {name = "rs6f_turn_left_4",  material = "rs6f_turn_left_4" , colorMul = 1.6 },

        {name = "rs6f_turn_left_5",  material = "rs6f_turn_left_5" , colorMul = 1.6 },

        {name = "rs6f_turn_left_6",  material = "rs6f_turn_left_6" , colorMul = 1.6 },

        {name = "rs6f_turn_left_7",  material = "rs6f_turn_left_7" , colorMul = 1.6 },

        {name = "rs6f_turn_left_8",  material = "rs6f_turn_left_8" , colorMul = 1.6 },

        {name = "rs6f_turn_left_9",  material = "rs6f_turn_left_9" , colorMul = 1.6 },

        {name = "rs6f_turn_left_10",  material = "rs6f_turn_left_10" , colorMul = 1.6 },

        {name = "rs6f_turn_left_11",  material = "rs6f_turn_left_11" , colorMul = 1.6 },

        

        {name = "rs6f_turn_right_0", material = "rs6f_turn_right_0", colorMul = 1.6 },

        {name = "rs6f_turn_right_1",  material = "rs6f_turn_right_1" , colorMul = 1.6 },

        {name = "rs6f_turn_right_2",  material = "rs6f_turn_right_2" , colorMul = 1.6 },

        {name = "rs6f_turn_right_3",  material = "rs6f_turn_right_3" , colorMul = 1.6 },

        {name = "rs6f_turn_right_4",  material = "rs6f_turn_right_4" , colorMul = 1.6 },

        {name = "rs6f_turn_right_5",  material = "rs6f_turn_right_5" , colorMul = 1.6 },

        {name = "rs6f_turn_right_6",  material = "rs6f_turn_right_6" , colorMul = 1.6 },

        {name = "rs6f_turn_right_7",  material = "rs6f_turn_right_7" , colorMul = 1.6 },

        {name = "rs6f_turn_right_8",  material = "rs6f_turn_right_8" , colorMul = 1.6 },

        {name = "rs6f_turn_right_9",  material = "rs6f_turn_right_9" , colorMul = 1.6 },

        {name = "rs6f_turn_right_10",  material = "rs6f_turn_right_10" , colorMul = 1.6 },

        {name = "rs6f_turn_right_11",  material = "rs6f_turn_right_11" , colorMul = 1.6 },



        {name = "rs6r_turn_left_0", material = "rs6r_turn_left_0",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_1", material = "rs6r_turn_left_1",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_2", material = "rs6r_turn_left_2",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_3", material = "rs6r_turn_left_3",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_4", material = "rs6r_turn_left_4",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_0", material = "rs6r_turn_right_0", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_1", material = "rs6r_turn_right_1", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_2", material = "rs6r_turn_right_2", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_3", material = "rs6r_turn_right_3", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_4", material = "rs6r_turn_right_4", brightness = 0.5, color = {1, 0.1, 0}},        

        

        {name = "rs6_brake_1", material = "rs6_brake_0" },

        {name = "rs6_brake_2", material = "rs6_brake_1" },

        {name = "rs6_brake_3", material = "rs6_brake_2" },

        {name = "rs6_brake_4", material = "rs6_brake_3" },

        {name = "rs6_brake_5", material = "rs6_brake_4" },

        {name = "rs6_brake_6", material = "rs6_brake_5" },

        {name = "rs6_brake_7", material = "rs6_brake_6" },

        {name = "rs6_brake_8", material = "rs6_brake_7" },

        {name = "rs6_brake_9", material = "rs6_brake_8" },

        {name = "rs6_brake_10", material = "rs6_brake_9" },

    }

}

CustomLights[561] = {
    update = function (anim, deltaTime, vehicle)
        if not anim.specialAnimActive then
            return
        end
        local currentTime = anim.specialAnimTime
        if anim.specialAnimData == "anim_on" then
            local timeFront1 = 1.3
            local timeFront2 = 0.5
            if currentTime < timeFront1 then
                local progress = getEasingValue(currentTime / timeFront1, "InQuad")
                anim.setLightState("s650_turn_left", true)
                anim.setLightState("s650_turn_right", true)
                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)
                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)
            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then
                local progress = (currentTime - timeFront1) / timeFront2
                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)
                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)
            end
            local timeLine = 0.22
            local timePause = 0.1
            local timeBrightnessPause = 0.3
            local timeBrightness = 1
            local colorStart = 0.4
            if currentTime < timeLine then
                local progress = currentTime * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then
                local progress = (currentTime - timeLine - timePause) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 3
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then
                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 6
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness
                for i = 1, 9 do
                    anim.setLightState("s650_brake"..i, true)
                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)
                end
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then
            for i = 1, 9 do
                anim.setLightState("s650_brake"..i, false)
            end
            anim.stopSpecialAnimation()
        elseif anim.specialAnimData == "enable" then
            for i = 1, 9 do
                anim.setLightState("s650_brake"..i, true)
                anim.setLightColor("s650_brake"..i, 1, 0, 0)
            end
            anim.stopSpecialAnimation()
        end
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
               anim.setLightColor("s650_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("s650_turn_left", 1, 1, 1)
                end
                anim.setLightState("s650_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("s650_turn_right", 1, 1, 1)
                end
                anim.setLightState("s650_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    for i = 1, 9 do
                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            else
                if not anim.getLightState("brake") then
                    for i = 1, 9 do
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            end
        end,
        ["brake"] = function (anim, state)
            if anim.specialAnimActive then
                return
            end
            if not state and anim.getLightState("front") then
                for i = 1, 9 do
                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                end
            else
                for i = 1, 9 do
                    anim.setLightColor("s650_brake"..i, 1, 0.25, 0.25)
                    anim.setLightState("s650_brake"..i, state)
                end
            end
        end
    },
    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end
    },
    lights = {
        {name = "s650_turn_left",  material = "s650_turn_left_*"  },
        {name = "s650_turn_right", material = "s650_turn_right_*" },
        {name = "s650_brake1",     material = "s650_brake_0" },
        {name = "s650_brake2",     material = "s650_brake_1" },
        {name = "s650_brake3",     material = "s650_brake_2" },
        {name = "s650_brake4",     material = "s650_brake_3" },
        {name = "s650_brake5",     material = "s650_brake_4" },
        {name = "s650_brake6",     material = "s650_brake_5" },
        {name = "s650_brake7",     material = "s650_brake_6" },
        {name = "s650_brake8",     material = "s650_brake_7" },
    }
}

CustomLights[550] = {
	stateHandlers = {
        ["front"] = function (anim, state)
            if state then
                anim.setLightColor("light_bnw", 0,0,0)
            end
            anim.setLightState("light_bnw", state)
            if state then
                if not anim.getLightState("brake") then
                    anim.setLightColor("bnw_brake", 0.2, 0.02, 0)
                    anim.setLightState("bnw_brake", state)
                end
            else
                if not anim.getLightState("brake") then
                    anim.setLightState("bnw_brake", state)
                end
            end
        end,
    },
    lights = {
        {name = "light_bnw",  material = "bmw_front_0*", colorMul = 10,brightness = 0.05},
        {name = "bnw_brake",      material = "bmw_brake_0*" },
    }
}

CustomLights[467] = {
    update = function (anim, deltaTime, vehicle)
        if not anim.specialAnimActive then
            return
        end
        local currentTime = anim.specialAnimTime
        -- В anim.specialAnimData передаётся true/false
        -- true - включение фар
        -- false - выключение
        if anim.specialAnimData == "anim_on" then
            local timeFront1 = 1.3
            local timeFront2 = 0.5
            local maxColor = 1
            if currentTime < timeFront1 then
                local progress = getEasingValue(currentTime / timeFront1, "InQuad")
                anim.setLightState("s650_turn_left", true)
                anim.setLightState("s650_turn_right", true)
                anim.setLightColor("s650_turn_left", 0, 0, maxColor * progress)
                anim.setLightColor("s650_turn_right", 0, 0, maxColor * progress)
            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then
                local progress = (currentTime - timeFront1) / timeFront2
                anim.setLightColor("s650_turn_left", maxColor * progress, maxColor * progress, maxColor)
                anim.setLightColor("s650_turn_right", maxColor * progress, maxColor * progress, maxColor)
            end

            local timeLine = 0.22
            local timePause = 0.1
            local timeBrightnessPause = 0.3
            local timeBrightness = 1

            local colorStart = 0.4
            if currentTime < timeLine then
                local progress = currentTime * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then
                local progress = (currentTime - timeLine - timePause) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 3
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then
                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 6
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness
                for i = 0, 9 do
                    anim.setLightState("s650_brake"..i, true)
                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)
                end
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, false)
            end
            anim.setLightState("s650_turn_left", false)
            anim.setLightState("s650_turn_right", false)
            anim.stopSpecialAnimation()
        elseif anim.specialAnimData == "enable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, true)
                anim.setLightColor("s650_brake"..i, 1, 0, 0)
            end
            anim.stopSpecialAnimation()
        end
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("s650_turn_left", 1, 1, 1)
                end
                anim.setLightState("s650_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("s650_turn_right", 1, 1, 1)
                end
                anim.setLightState("s650_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            else
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            end
        end,
        ["brake"] = function (anim, state)
            if anim.specialAnimActive then
                return
            end
            if not state and anim.getLightState("front") then
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                end
            else
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 1, 0, 0)
                    anim.setLightState("s650_brake"..i, state)
                end
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end
    },

    lights = {
        {name = "s650_turn_left",  material = "s650_turn_left*"  },
        {name = "s650_turn_right", material = "s650_turn_right*" },
        {name = "s650_brake0",     material = "s650_brake_0" },     
    }
}


CustomLights[409] = {
    update = function (anim, deltaTime, vehicle)
        if not anim.specialAnimActive then
            return
        end
        local currentTime = anim.specialAnimTime
        -- В anim.specialAnimData передаётся true/false
        -- true - включение фар
        -- false - выключение
        if anim.specialAnimData == "anim_on" then
            local timeFront1 = 1.3
            local timeFront2 = 0.5
            local maxColor = 1
            if currentTime < timeFront1 then
                local progress = getEasingValue(currentTime / timeFront1, "InQuad")
                anim.setLightState("s650_turn_left", true)
                anim.setLightState("s650_turn_right", true)
                anim.setLightColor("s650_turn_left", 0, 0, maxColor * progress)
                anim.setLightColor("s650_turn_right", 0, 0, maxColor * progress)
            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then
                local progress = (currentTime - timeFront1) / timeFront2
                anim.setLightColor("s650_turn_left", maxColor * progress, maxColor * progress, maxColor)
                anim.setLightColor("s650_turn_right", maxColor * progress, maxColor * progress, maxColor)
            end

            local timeLine = 0.22
            local timePause = 0.1
            local timeBrightnessPause = 0.3
            local timeBrightness = 1

            local colorStart = 0.4
            if currentTime < timeLine then
                local progress = currentTime * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then
                local progress = (currentTime - timeLine - timePause) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 3
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then
                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 6
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness
                for i = 0, 9 do
                    anim.setLightState("s650_brake"..i, true)
                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)
                end
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, false)
            end
            anim.setLightState("s650_turn_left", false)
            anim.setLightState("s650_turn_right", false)
            anim.stopSpecialAnimation()
        elseif anim.specialAnimData == "enable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, true)
                anim.setLightColor("s650_brake"..i, 1, 0, 0)
            end
            anim.stopSpecialAnimation()
        end
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("s650_turn_left", 1, 1, 1)
                end
                anim.setLightState("s650_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("s650_turn_right", 1, 1, 1)
                end
                anim.setLightState("s650_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            else
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            end
        end,
        ["brake"] = function (anim, state)
            if anim.specialAnimActive then
                return
            end
            if not state and anim.getLightState("front") then
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                end
            else
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 1, 0, 0)
                    anim.setLightState("s650_brake"..i, state)
                end
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end
    },

    lights = {
        {name = "s650_turn_left",  material = "s650_turn_left*"  },
        {name = "s650_turn_right", material = "s650_turn_right*" },
        {name = "s650_brake0",     material = "s650_brake_0" },     
    }
}

CustomLights[507] = {
    update = function (anim, deltaTime, vehicle)
        if not anim.specialAnimActive then
            return
        end
        local currentTime = anim.specialAnimTime
        -- В anim.specialAnimData передаётся true/false
        -- true - включение фар
        -- false - выключение
        if anim.specialAnimData == "anim_on" then
            local timeFront1 = 1.3
            local timeFront2 = 0.5
            local maxColor = 1
            if currentTime < timeFront1 then
                local progress = getEasingValue(currentTime / timeFront1, "InQuad")
                anim.setLightState("s650_turn_left", true)
                anim.setLightState("s650_turn_right", true)
                anim.setLightColor("s650_turn_left", 0, 0, maxColor * progress)
                anim.setLightColor("s650_turn_right", 0, 0, maxColor * progress)
            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then
                local progress = (currentTime - timeFront1) / timeFront2
                anim.setLightColor("s650_turn_left", maxColor * progress, maxColor * progress, maxColor)
                anim.setLightColor("s650_turn_right", maxColor * progress, maxColor * progress, maxColor)
            end

            local timeLine = 0.22
            local timePause = 0.1
            local timeBrightnessPause = 0.3
            local timeBrightness = 1

            local colorStart = 0.4
            if currentTime < timeLine then
                local progress = currentTime * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then
                local progress = (currentTime - timeLine - timePause) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 3
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then
                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 6
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness
                for i = 0, 9 do
                    anim.setLightState("s650_brake"..i, true)
                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)
                end
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, false)
            end
            anim.setLightState("s650_turn_left", false)
            anim.setLightState("s650_turn_right", false)
            anim.stopSpecialAnimation()
        elseif anim.specialAnimData == "enable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, true)
                anim.setLightColor("s650_brake"..i, 1, 0, 0)
            end
            anim.stopSpecialAnimation()
        end
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("s650_turn_left", 1, 1, 1)
                end
                anim.setLightState("s650_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("s650_turn_right", 1, 1, 1)
                end
                anim.setLightState("s650_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            else
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            end
        end,
        ["brake"] = function (anim, state)
            if anim.specialAnimActive then
                return
            end
            if not state and anim.getLightState("front") then
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                end
            else
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 1, 0, 0)
                    anim.setLightState("s650_brake"..i, state)
                end
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end
    },

    lights = {
        {name = "s650_turn_left",  material = "s650_turn_left*"  },
        {name = "s650_turn_right", material = "s650_turn_right*" },
        {name = "s650_brake0",     material = "s650_brake_0" },     
    }
}
CustomLights[467] = {
    update = function (anim, deltaTime, vehicle)
        if not anim.specialAnimActive then
            return
        end
        local currentTime = anim.specialAnimTime
        -- В anim.specialAnimData передаётся true/false
        -- true - включение фар
        -- false - выключение
        if anim.specialAnimData == "anim_on" then
            local timeFront1 = 1.3
            local timeFront2 = 0.5
            local maxColor = 1
            if currentTime < timeFront1 then
                local progress = getEasingValue(currentTime / timeFront1, "InQuad")
                anim.setLightState("s650_turn_left", true)
                anim.setLightState("s650_turn_right", true)
                anim.setLightColor("s650_turn_left", 0, 0, maxColor * progress)
                anim.setLightColor("s650_turn_right", 0, 0, maxColor * progress)
            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then
                local progress = (currentTime - timeFront1) / timeFront2
                anim.setLightColor("s650_turn_left", maxColor * progress, maxColor * progress, maxColor)
                anim.setLightColor("s650_turn_right", maxColor * progress, maxColor * progress, maxColor)
            end

            local timeLine = 0.22
            local timePause = 0.1
            local timeBrightnessPause = 0.3
            local timeBrightness = 1

            local colorStart = 0.4
            if currentTime < timeLine then
                local progress = currentTime * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then
                local progress = (currentTime - timeLine - timePause) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 3
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then
                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 6
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness
                for i = 0, 9 do
                    anim.setLightState("s650_brake"..i, true)
                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)
                end
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, false)
            end
            anim.setLightState("s650_turn_left", false)
            anim.setLightState("s650_turn_right", false)
            anim.stopSpecialAnimation()
        elseif anim.specialAnimData == "enable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, true)
                anim.setLightColor("s650_brake"..i, 1, 0, 0)
            end
            anim.stopSpecialAnimation()
        end
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("s650_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("s650_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("s650_turn_left", 1, 1, 1)
                end
                anim.setLightState("s650_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("s650_turn_right", 1, 1, 1)
                end
                anim.setLightState("s650_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            else
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            end
        end,
        ["brake"] = function (anim, state)
            if anim.specialAnimActive then
                return
            end
            if not state and anim.getLightState("front") then
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                end
            else
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 1, 0, 0)
                    anim.setLightState("s650_brake"..i, state)
                end
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("s650_turn_left", 1, 1, 1)
                anim.setLightState("s650_turn_left", true)
                anim.setLightColor("s650_turn_right", 1, 1, 1)
                anim.setLightState("s650_turn_right", true)
            end
        end
    },

    lights = {
        {name = "s650_turn_left",  material = "s650_turn_left*"  },
        {name = "s650_turn_right", material = "s650_turn_right*" },
        {name = "s650_brake0",     material = "s650_brake_0" },     
    }
}

CustomLights[587] = {
    update = function (anim, deltaTime, vehicle)
        if not anim.specialAnimActive then
            return
        end
        local currentTime = anim.specialAnimTime
        -- В anim.specialAnimData передаётся true/false
        -- true - включение фар
        -- false - выключение
        if anim.specialAnimData == "anim_on" then
            local timeFront1 = 1.3
            local timeFront2 = 0.5
            local maxColor = 1
            if currentTime < timeFront1 then
                local progress = getEasingValue(currentTime / timeFront1, "InQuad")
                anim.setLightState("f90_turn_left", true)
                anim.setLightState("f90_turn_right", true)
                anim.setLightColor("f90_turn_left", 0, 0, maxColor * progress)
                anim.setLightColor("f90_turn_right", 0, 0, maxColor * progress)
            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then
                local progress = (currentTime - timeFront1) / timeFront2
                anim.setLightColor("f90_turn_left", maxColor * progress, maxColor * progress, maxColor)
                anim.setLightColor("f90_turn_right", maxColor * progress, maxColor * progress, maxColor)
            end

            local timeLine = 0.22
            local timePause = 0.1
            local timeBrightnessPause = 0.3
            local timeBrightness = 1

            local colorStart = 0.4
            if currentTime < timeLine then
                local progress = currentTime * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then
                local progress = (currentTime - timeLine - timePause) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 3
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then
                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine
                local index = math.ceil(progress)
                progress = progress - index + 1
                index = index + 6
                anim.setLightState("s650_brake"..index, true)
                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness
                for i = 0, 9 do
                    anim.setLightState("s650_brake"..i, true)
                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)
                end
            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then
                anim.stopSpecialAnimation()
            end
        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, false)
            end
            anim.setLightState("f90_turn_left", false)
            anim.setLightState("f90_turn_right", false)
            anim.stopSpecialAnimation()
        elseif anim.specialAnimData == "enable" then
            for i = 0, 9 do
                anim.setLightState("s650_brake"..i, true)
                anim.setLightColor("s650_brake"..i, 1, 0, 0)
            end
            anim.stopSpecialAnimation()
        end
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("f90_turn_left", 1, 0.5, 0)
            end
            anim.setLightState("f90_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("f90_turn_right", 1, 0.5, 0)
            end
            anim.setLightState("f90_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("f90_turn_left", 1, 1, 1)
                end
                anim.setLightState("f90_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("f90_turn_right", 1, 1, 1)
                end
                anim.setLightState("f90_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            else
                if not anim.getLightState("brake") then
                    for i = 0, 9 do
                        anim.setLightState("s650_brake"..i, state)
                    end
                end
            end
        end,
        ["brake"] = function (anim, state)
            if anim.specialAnimActive then
                return
            end
            if not state and anim.getLightState("front") then
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)
                end
            else
                for i = 0, 9 do
                    anim.setLightColor("s650_brake"..i, 1, 0, 0)
                    anim.setLightState("s650_brake"..i, state)
                end
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("f90_turn_left", 1, 1, 1)
                anim.setLightState("f90_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("f90_turn_right", 1, 1, 1)
                anim.setLightState("f90_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("f90_turn_left", 1, 1, 1)
                anim.setLightState("f90_turn_left", true)
                anim.setLightColor("f90_turn_right", 1, 1, 1)
                anim.setLightState("f90_turn_right", true)
            end
        end
    },

    lights = {
        {name = "f90_turn_left",  material = "f90_turn_left*"  },
        {name = "f90_turn_right", material = "f90_turn_right*" },
        {name = "s650_brake0",     material = "s650_brake_0" },
        {name = "s650_brake1",     material = "s650_brake_1" },  
        {name = "s650_brake2",     material = "s650_brake_2" },  
        {name = "s650_brake3",     material = "s650_brake_3" }, 
        {name = "s650_brake4",     material = "s650_brake_4" },         
    }
}

-- Lexus LX70
CustomLights[579] = {
    init = function (anim)
        anim.turnLightsInterval = 0.4
        -- Время, за которое загораются все блоки
        anim.rearLightsTime = 0.3
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.35
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if not state then
                for i = 0, 4 do
                    anim.setLightState("LX570_turn_left_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("LX570_turn_left_"..i, 1, 0.5, 0)
                end
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state then
                for i = 0, 4 do
                    anim.setLightState("LX570_turn_right_"..i, state)
                    -- Сброс цвета
                    anim.setLightColor("LX570_turn_right_"..i, 1, 0.5, 0)
                end
            end
        end
    },

    -- Задние поворотники
    update = function (anim)
        if not anim.turnLightsState then
            return
        end

        if anim.turnLightsTime < anim.rearLightsTime then
            -- Включение блоков по очереди
            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 5)

            if anim.getLightState("turn_left") then
                anim.setLightState("LX570_turn_left_"..index, true)
            end
            if anim.getLightState("turn_right") then
                anim.setLightState("LX570_turn_right_"..index, true)
            end
        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
            -- Плавное затухание всех блоков
            local progress = 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter)/(0.5 - anim.rearLightsFadeAfter)
            if anim.getLightState("turn_left") then
                for i = 0, 4 do
                    anim.setLightColor("LX570_turn_left_"..i, progress, progress * 0.5, 0)
                end
            end
            if anim.getLightState("turn_right") then
                for i = 0, 4 do
                    anim.setLightColor("LX570_turn_right_"..i, progress, progress * 0.5, 0)
                end
            end
        end
    end,

    lights = {
        {name = "LX570_turn_left_0", material = "LX570_turn_left_0",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_1", material = "LX570_turn_left_1",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_2", material = "LX570_turn_left_2",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_3", material = "LX570_turn_left_3",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_left_4", material = "LX570_turn_left_4",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "LX570_turn_right_0", material = "LX570_turn_right_0", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_1", material = "LX570_turn_right_1", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_2", material = "LX570_turn_right_2", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_3", material = "LX570_turn_right_3", brightness = 0.7, color = {1, 0.5, 0}},
        {name = "LX570_turn_right_4", material = "LX570_turn_right_4", brightness = 0.7, color = {1, 0.5, 0}},
    }
}
-- mclaren
makeTurnMirrorFront(415,
{name = "bmw_turn_left_0", material = "bmw_turn_left_0*" },
{name = "bmw_turn_right_0", material = "bmw_turn_right_0*" }
) 

-- f10

makeTurnMirrorFront(458,

{name = "bmw_turn_left_0", material = "bmw_turn_left_0*" },

{name = "bmw_turn_right_0", material = "bmw_turn_right_0*" }

) 


-- bentley exp100

makeTurnMirrorFront(491,

{name = "bmw_turn_left_0", material = "bmw_turn_left_0*" },

{name = "bmw_turn_right_0", material = "bmw_turn_right_0*" }

) 

-- divo
makeTurnMirrorFront(436,
{name = "bmw_turn_left_0", material = "bmw_turn_left_0*" },
{name = "bmw_turn_right_0", material = "bmw_turn_right_0*" }
) 

-- Porsche Panamera Turbo
makeTurnMirrorFront(529,
    {name = "porsche_turn_left",  material = "porsche_turn_left_*" },
    {name = "porsche_turn_right", material = "porsche_turn_right_*" }
)

CustomLights[567] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- Ð’ anim.specialAnimData Ð¿ÐµÑ€ÐµÐ´Ð°Ñ‘Ñ‚ÑÑ true/false

        -- true - Ð²ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¸Ðµ Ñ„Ð°Ñ€

        -- false - Ð²Ñ‹ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¸Ðµ

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 1.7

            local timeFront2 = 0.5

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

            end



            local timeLine = 0.22

            local timePause = 0.1

            local timeBrightnessPause = 0.3

            local timeBrightness = 1



            local colorStart = 0.4

            if currentTime < timeLine then

                local progress = currentTime * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then

                local progress = (currentTime - timeLine - timePause) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 3

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then

                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 6

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness

                for i = 1, 9 do

                    anim.setLightState("s650_brake"..i, true)

                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)

                end

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, false)

            end

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, true)

                anim.setLightColor("s650_brake"..i, 1, 0, 0)

            end

            anim.stopSpecialAnimation()

        end

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Ð•ÑÐ»Ð¸ Ð²ÐºÐ»ÑŽÑ‡ÐµÐ½ Ð¿Ð¾Ð²Ð¾Ñ€Ð¾Ñ‚Ð½Ð¸Ðº, ÑÐ¾ÑÑ‚Ð¾ÑÐ½Ð¸Ðµ Ð½Ðµ Ð¾Ð±Ð½Ð¾Ð²Ð»ÑÐµÑ‚ÑÑ

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("s650_turn_left", 1, 1, 1)

                end

                anim.setLightState("s650_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("s650_turn_right", 1, 1, 1)

                end

                anim.setLightState("s650_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            else

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            end

        end,

        ["brake"] = function (anim, state)

            if anim.specialAnimActive then

                return

            end

            if not state and anim.getLightState("front") then

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                end

            else

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 1, 0.25, 0.25)

                    anim.setLightState("s650_brake"..i, state)

                end

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end

    },



    lights = {

        {name = "s650_turn_left",  material = "s650_turn_left*"  },

        {name = "s650_turn_right", material = "s650_turn_right*" },

        {name = "s650_brake1",     material = "s650_brake_0" },

        {name = "s650_brake2",     material = "s650_brake_1" },

        {name = "s650_brake3",     material = "s650_brake_2" },

        {name = "s650_brake4",     material = "s650_brake_3" },

        {name = "s650_brake5",     material = "s650_brake_4" },

        {name = "s650_brake6",     material = "s650_brake_5" },

        {name = "s650_brake7",     material = "s650_brake_6" },

        {name = "s650_brake8",     material = "s650_brake_7" },

        {name = "s650_brake9",     material = "s650_brake_8" },

    }

}

CustomLights[999] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 1.3

            local timeFront2 = 0.5

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

            end

            local timeLine = 0.22

            local timePause = 0.1

            local timeBrightnessPause = 0.3

            local timeBrightness = 1

            local colorStart = 0.4

            if currentTime < timeLine then

                local progress = currentTime * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then

                local progress = (currentTime - timeLine - timePause) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 3

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then

                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 6

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness

                for i = 1, 9 do

                    anim.setLightState("s650_brake"..i, true)

                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)

                end

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, false)

            end

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, true)

                anim.setLightColor("s650_brake"..i, 1, 0, 0)

            end

            anim.stopSpecialAnimation()

        end

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

               anim.setLightColor("s650_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("s650_turn_left", 1, 1, 1)

                end

                anim.setLightState("s650_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("s650_turn_right", 1, 1, 1)

                end

                anim.setLightState("s650_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            else

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            end

        end,

        ["brake"] = function (anim, state)

            if anim.specialAnimActive then

                return

            end

            if not state and anim.getLightState("front") then

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                end

            else

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 1, 0.25, 0.25)

                    anim.setLightState("s650_brake"..i, state)

                end

            end

        end

    },

    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end

    },

    lights = {

        {name = "s650_turn_left",  material = "s650_turn_left_*"  },

        {name = "s650_turn_right", material = "s650_turn_right_*" },

        {name = "s650_brake1",     material = "s650_brake_0" },

        {name = "s650_brake2",     material = "s650_brake_1" },

        {name = "s650_brake3",     material = "s650_brake_2" },

        {name = "s650_brake4",     material = "s650_brake_3" },

        {name = "s650_brake5",     material = "s650_brake_4" },

        {name = "s650_brake6",     material = "s650_brake_5" },

        {name = "s650_brake7",     material = "s650_brake_6" },

        {name = "s650_brake8",     material = "s650_brake_7" },

    }

}
-- Bugatti Chiron

CustomLights[506] = {

    update = function (anim, deltaTime, vehicle)

		--print (anim.specialAnimActive)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.specialAnimData == "anim_on" then

            local time1 = 1

            local timePause = 0.4

            local time2 = 0.4

            if currentTime < time1 then

                local progress = currentTime * 4 / time1

                local index = math.ceil(progress)

                progress = progress - index + 1

                local color = 0.3 * progress

                anim.setLightState("headlight"..index, true)

                anim.setLightColor("headlight"..index, color, color, color)

            elseif currentTime > time1 + timePause and currentTime < time1 + timePause + time2 then

                local progress = (currentTime - time1 - timePause) * 4 / time2

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = 5 - index

                local color = 0.3 + progress * 0.7

                anim.setLightColor("headlight"..index, color, color, color)

            elseif currentTime > time1 + timePause + time2 then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" then

            local time1 = 1

            local time2 = 1

            local timePause = 0.2

            if currentTime < time1 then

                local progress = currentTime * 4 / time1

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = 5 - index

                local color = 1 - 0.7 * progress

                anim.setLightState("headlight"..index, true)

                anim.setLightColor("headlight"..index, color, color, color)

            elseif currentTime > time1 and currentTime < time1 + time2 then

                local progress = (currentTime - time1) * 4 / time2

                local index = math.ceil(progress)

                progress = progress - index + 1

                local color = 0.3 - progress * 0.3

                anim.setLightColor("headlight"..index, color, color, color)

            elseif currentTime > time1 + time2 + timePause then

                for i = 0, 4 do

                    anim.setLightState("headlight"..i, false)

                end

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "disable" then

            for i = 0, 4 do

                anim.setLightState("headlight"..i, false)

            end

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 0, 4 do

                anim.setLightState("headlight"..i, true)

                anim.setLightColor("headlight"..i, 1, 1, 1)

            end

            anim.stopSpecialAnimation()

        end

    end,

	

	stateHandlers = {

		["front"] = function (anim, state, veh)

			if state then

				anim.startSpecialAnimation(veh, "anim_on")

			else

				anim.startSpecialAnimation(veh, "anim_off")

			end

        end,

    },



    lights = {

        {name = "headlight1", material = "chiron_headlight_1", color = {1, 1, 1}},

        {name = "headlight2", material = "chiron_headlight_2", color = {1, 1, 1}},

        {name = "headlight3", material = "chiron_headlight_3", color = {1, 1, 1}},

        {name = "headlight4", material = "chiron_headlight_4", color = {1, 1, 1}},

    }

}



CustomLights[504] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

	 -- Â anim.specialAnimData ïåðåäà¸òñÿ true/false

        -- true\anim_on - âêëþ÷åíèå ôàð

        -- false\anim_off - âûêëþ÷åíèå

		--ïåðåäíèè ôàðû ñ àíèìàöèåé

    if anim.specialAnimData == "anim_on" then

      if anim.specialAnimTime < 1.3 then

        anim.setLightState("GLE_head_left", true)

        anim.setLightState("GLE_head_right", true)

		anim.setLightState("GLE_head", true)

        anim.setLightColor("GLE_head_left",  0, 0, 1 * getEasingValue(anim.specialAnimTime / 1.3, "InQuad"))

        anim.setLightColor("GLE_head_right",  0, 0, 1 * getEasingValue(anim.specialAnimTime / 1.3, "InQuad"))

		anim.setLightColor("GLE_head",  0, 0, 1 * getEasingValue(anim.specialAnimTime / 1.3, "InQuad"))

      elseif anim.specialAnimTime > 1.3 and anim.specialAnimTime < 1.3 + 0.5 then

        anim.setLightColor("GLE_head_left", 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1)

        anim.setLightColor("GLE_head_right", 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1)

		anim.setLightColor("GLE_head", 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1)

      end

	  --çàäíèå ãàáàðèòû

      if anim.specialAnimTime < 0.22 then

        anim.setLightState("GLE_tail1" .. math.ceil(anim.specialAnimTime * 3 / 0.22), true)

        anim.setLightColor("GLE_tail1" .. math.ceil(anim.specialAnimTime * 3 / 0.22), 0.4 * (anim.specialAnimTime * 3 / 0.22 - math.ceil(anim.specialAnimTime * 3 / 0.22) + 1), 0, (anim.specialAnimTime * 3 / 0.22 - math.ceil(anim.specialAnimTime * 3 / 0.22) + 1) * 0.2)

      elseif anim.specialAnimTime > 0.22 + 0.1 and anim.specialAnimTime < 0.22 * 2 + 0.1 then

        anim.setLightState("GLE_tail1" .. math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 3, true)

        anim.setLightColor("GLE_tail1" .. math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 3, 0.4 * ((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 1), 0, ((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 1) * 0.2)

      elseif anim.specialAnimTime > 0.22 * 2 + 0.1 * 2 and anim.specialAnimTime < 0.22 * 3 + 0.1 * 3 then

        anim.setLightState("GLE_tail1" .. math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 6, true)

        anim.setLightColor("GLE_tail1" .. math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 6, 0.4 * ((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 1), 0, ((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 1) * 0.2)

      elseif anim.specialAnimTime > 0.22 * 3 + 0.1 * 2 + 0.3 and anim.specialAnimTime < 0.22 * 3 + 0.1 * 2 + 0.3 + 1 then

		for i = 1, 9 do

          anim.setLightState("GLE_tail1" .. i, true)

          anim.setLightColor("GLE_tail1" .. i, 0.4 + (1 - 0.4) * ((anim.specialAnimTime - 0.22 * 3 - 0.1 * 2 - 0.3) / 1), 0, (1 - (anim.specialAnimTime - 0.22 * 3 - 0.1 * 2 - 0.3) / 1) * 0.2)

        end

      elseif anim.specialAnimTime > 0.22 * 3 + 0.1 * 2 + 0.3 + 1 then

        anim.stopSpecialAnimation()

      end

    elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

      anim.setLightState("GLE_head_left", false)

      anim.setLightState("GLE_head_right", false)

	  anim.setLightState("GLE_head", false)

      for i = 1, 9 do

        anim.setLightState("GLE_tail1" .. i, false)

      end

      anim.stopSpecialAnimation()

    elseif anim.specialAnimData == "enable" then

      anim.setLightState("GLE_head_left", true)

      anim.setLightState("GLE_head_right", true)

	  anim.setLightState("GLE_head", true)

      anim.setLightColor("GLE_head_left",  1, 1, 1)

      anim.setLightColor("GLE_head_right",  1, 1, 1)

	  anim.setLightColor("GLE_head",  1, 1, 1)

      for i = 1, 9 do

        anim.setLightState("GLE_tail1" .. i, true)

        anim.setLightColor("GLE_tail1" .. i, 1, 0, 0)

      end

      anim.stopSpecialAnimation()

    end

  end,

  

  stateHandlers = {

  ["turn_left"] = function(anim, state)

      if state then

        anim.setLightColor("GLE_head_left",  1, 0.5, 0)

      end

      anim.setLightState("GLE_head_left", state)

    end,

    ["turn_right"] = function(anim, state)

      if state then

        anim.setLightColor("GLE_head_right",  1, 0.5, 0)

      end

      anim.setLightState("GLE_head_right", state)

    end,

    ["front"] = function(anim, state)

	-- Åñëè âêëþ÷åí ïîâîðîòíèê, ñîñòîÿíèå íå îáíîâëÿåòñÿ

      if not anim.getLightState("turn_left") then

        if state then

          anim.setLightColor("GLE_head_left",  1, 1, 1)

        end

        anim.setLightState("GLE_head_left", state)

      end

      if not anim.getLightState("turn_right") then

        if state then

          anim.setLightColor("GLE_head_right",  1, 1, 1)

		  anim.setLightColor("GLE_head",  1, 1, 1)

        end

        anim.setLightState("GLE_head_right", state)

		anim.setLightState("GLE_head", state)

      end

    end

  },

  

  dataHandlers = {

    ["turn_left"] = function(anim, state)

      if not state and anim.getLightState("front") then

        anim.setLightColor("GLE_head_left",  1, 1, 1)

        anim.setLightState("GLE_head_left", true)

      end

    end,

    ["turn_right"] = function(anim, state)

      if not state and anim.getLightState("front") then

        anim.setLightColor("GLE_head_right",  1, 1, 1)

        anim.setLightState("GLE_head_right", true)

      end

    end,

    ["emergency_light"] = function(anim, state)

      if not state and anim.getLightState("front") then

        anim.setLightColor("GLE_head_left",  1, 1, 1)

        anim.setLightState("GLE_head_left", true)

        anim.setLightColor("GLE_head_right", 1, 1, 1)

        anim.setLightState("GLE_head_right", true)

		anim.setLightColor("GLE_head", 1, 1, 1)

        anim.setLightState("GLE_head", true)

      end

    end

  },



    lights = {

        {name = "GLE_head_left",  material = "GLE_head_left"  },

        {name = "GLE_head_right", material = "GLE_head_right" },

		{name = "GLE_head",       material = "GLE_head" },

        {name = "GLE_tail1",      material = "GLE_tail1" },



    }

}



CustomLights[477] = {

    

    init = function(anim)

        anim.turnLightsInterval = 0.42

        -- Время, за которое загораются все блоки

        anim.rearLightsTime = 0.27

        -- Время, после которого свет начинает плавно затухать

        anim.rearLightsFadeAfter = 0.3

    end,



    -- Задние поворотники

    update = function(anim)

        

        if not anim.turnLightsState then

          return

        end



        if anim.turnLightsTime < anim.rearLightsTime then

            -- Включение блоков по очереди

            if anim.getLightState("turn_left") then

                anim.setLightState("a_turn_left_"..math.floor(anim.turnLightsTime / anim.rearLightsTime * 5), true)

                anim.setLightState("z_turn_left_"..math.floor(anim.turnLightsTime / anim.rearLightsTime * 4), true)

            end

            if anim.getLightState("turn_right") then

                anim.setLightState("a_turn_right_"..math.floor(anim.turnLightsTime / anim.rearLightsTime * 5), true)

                anim.setLightState("z_turn_right_"..math.floor(anim.turnLightsTime / anim.rearLightsTime * 4), true)

            end

        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

            if anim.getLightState("turn_left") then

                for i = 0, 4 do

                    anim.setLightColor("a_turn_left_"..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    anim.setLightColor("z_turn_left_"..i-1, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                end

            end

            if anim.getLightState("turn_right") then

                for i = 0, 4 do

                    anim.setLightColor("a_turn_right_"..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    anim.setLightColor("z_turn_right_"..i-1, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                end

            end

        end

    end,





        -- Задний ход = задние поворотники

        stateHandlers = {

            ["turn_left"] = function (anim, state)

                for i = 0, 4 do

                        anim.setLightColor("a_turn_left_"..i, 1, 0.5, 0)

                        anim.setLightColor("z_turn_left_"..i-1, 1, 0.5, 0)

                    if not state then

                        anim.setLightState("a_turn_left_"..i, state)

                        anim.setLightState("z_turn_left_"..i-1, state)

                    end

                end

            end,

            ["turn_right"] = function (anim, state)

                for i = 0, 4 do

                        anim.setLightColor("a_turn_right_"..i, 1, 0.5, 0)

                        anim.setLightColor("z_turn_right_"..i-1, 1, 0.5, 0)

                    if not state then

                        anim.setLightState("a_turn_right_"..i, state)

                        anim.setLightState("z_turn_right_"..i-1, state)

                    end

                end

            end,

            ["front"] = function (anim, state)

                -- Если включен поворотник, состояние не обновляется

                if not anim.getLightState("turn_left") then

                    for i = 0, 4 do

                        if state then

                            anim.setLightColor("a_turn_left_"..i, 2, 2, 2)

                        end

                        anim.setLightState("a_turn_left_"..i, state)

                    end

                end

                if not anim.getLightState("turn_right") then

                    for i = 0, 4 do

                        if state then

                            anim.setLightColor("a_turn_right_"..i, 2, 2, 2)

                        end

                        anim.setLightState("a_turn_right_"..i, state)

                    end

                end

            end

        },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 4 do

                    anim.setLightColor("a_turn_left_"..i, 1, 1, 1)

                    anim.setLightState("a_turn_left_"..i, true)

                end

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 4 do

                    anim.setLightColor("a_turn_right_"..i, 1, 1, 1)

                    anim.setLightState("a_turn_right_"..i, true)

                end

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 4 do

                    anim.setLightColor("a_turn_left_"..i, 1, 1, 1)

                    anim.setLightState("a_turn_left_"..i, true)

                    anim.setLightColor("a_turn_right_"..i, 1, 1, 1)

                    anim.setLightState("a_turn_right_"..i, true)

                end

            end

        end

    },





    lights = {

        {name = "a_turn_left_0", material = "a_turn_left_0",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_left_1", material = "a_turn_left_1",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_left_2", material = "a_turn_left_2",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_left_3", material = "a_turn_left_3",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_left_4", material = "a_turn_left_4",   brightness = 0.7, color = {1, 0.5, 0}},



        {name = "z_turn_left_0", material = "z_turn_left_0",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "z_turn_left_1", material = "z_turn_left_1",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "z_turn_left_2", material = "z_turn_left_2",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "z_turn_left_3", material = "z_turn_left_3",   brightness = 0.7, color = {1, 0.5, 0}},



        {name = "z_turn_right_0", material = "z_turn_right_0",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "z_turn_right_1", material = "z_turn_right_1",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "z_turn_right_2", material = "z_turn_right_2",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "z_turn_right_3", material = "z_turn_right_3",   brightness = 0.7, color = {1, 0.5, 0}},



        {name = "a_turn_right_0", material = "a_turn_right_0", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_right_1", material = "a_turn_right_1", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_right_2", material = "a_turn_right_2", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_right_3", material = "a_turn_right_3", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "a_turn_right_4", material = "a_turn_right_4", brightness = 0.7, color = {1, 0.5, 0}}

    }



}



--huric
CustomLights[549] = {
    init = function (anim)
        anim.turnLightsInterval = 0.59
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("huracan_turn_left", 1, 0.35, 0)
            end
            anim.setLightState("huracan_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("huracan_turn_right", 1, 0.35, 0)
            end
            anim.setLightState("huracan_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("huracan_turn_left", 1, 1, 1)
                end
                anim.setLightState("huracan_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("huracan_turn_right", 1, 1, 1)
                end
                anim.setLightState("huracan_turn_right", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    anim.setLightColor("huracan_brake", 0.5, 0, 0)
                    anim.setLightState("huracan_brake", state)
                end
            else
                if not anim.getLightState("brake") then
                    anim.setLightState("huracan_brake", state)
                end
            end
        end,
        ["brake"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_brake", 0.5, 0, 0)
            else
                anim.setLightColor("huracan_brake", 1, 0.2, 0.2)
                anim.setLightState("huracan_brake", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_turn_left", 1, 1, 1)
                anim.setLightState("huracan_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_turn_right", 1, 1, 1)
                anim.setLightState("huracan_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("huracan_turn_left", 1, 1, 1)
                anim.setLightState("huracan_turn_left", true)
                anim.setLightColor("huracan_turn_right", 1, 1, 1)
                anim.setLightState("huracan_turn_right", true)
            end
        end
    },

    lights = {
        {name = "huracan_turn_left",  material = "huracan_turn_left" , colorMul = 1.5 },
        {name = "huracan_turn_right", material = "huracan_turn_right", colorMul = 1.5 },
        {name = "huracan_brake",      material = "huracan_brake" },
    }
}

-- a8 GT500

CustomLights[605] = {

    init = function (anim)

        anim.turnLightsInterval = 0.6

        -- Время, за которое загораются все блоки

        anim.rearLightsTime = 0.5

        -- Время, после которого свет начинает плавно затухать

        anim.rearLightsFadeAfter = 0.45

    end,



    -- Задние поворотники

    update = function (anim)

        if not anim.turnLightsState then

            return

        end



        if anim.turnLightsTime < anim.rearLightsTime then

            -- Включение блоков по очереди

            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 10)



            if anim.getLightState("turn_left") then

                anim.setLightState("a8_turn_left_"..index, true)

            end

            if anim.getLightState("turn_right") then

                anim.setLightState("a8_turn_right_"..index, true)

            end

        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

            if anim.getLightState("turn_left") then

                for i = 0, 9 do

                    anim.setLightState("a8_turn_left_"..i, false)

                end

            end

            if anim.getLightState("turn_right") then

                for i = 0, 9 do

                    anim.setLightState("a8_turn_right_"..i, false)

                end

            end

        end

    end,



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 9 do

                    anim.setLightColor("a8_turn_left_"..i, 1, 0.25, 0)

                    anim.setLightState("a8_turn_left_"..i, true)

                end

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 9 do

                    anim.setLightColor("a8_turn_right_"..i, 1, 0.25, 0)

                    anim.setLightState("a8_turn_right_"..i, true)

                end

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 9 do

                    anim.setLightColor("a8_turn_left_"..i, 1, 1, 1)

                    anim.setLightState("a8_turn_left_"..i, true)

                    anim.setLightColor("a8_turn_right_"..i, 1, 1, 1)

                    anim.setLightState("a8_turn_right_"..i, true)

                end

            end

        end

    },



    lights = {

        {name = "a8_turn_left_0", material = "a8_turn_left_0",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_1", material = "a8_turn_left_1",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_2", material = "a8_turn_left_2",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_3", material = "a8_turn_left_3",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_4", material = "a8_turn_left_4",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_5", material = "a8_turn_left_5",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_6", material = "a8_turn_left_6",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_7", material = "a8_turn_left_7",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_8", material = "a8_turn_left_8",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_left_9", material = "a8_turn_left_9",   brightness = 0.8, color = {1, 0.25, 0}},



        {name = "a8_turn_right_0", material = "a8_turn_right_0",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_1", material = "a8_turn_right_1",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_2", material = "a8_turn_right_2",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_3", material = "a8_turn_right_3",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_4", material = "a8_turn_right_4",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_5", material = "a8_turn_right_5",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_6", material = "a8_turn_right_6",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_7", material = "a8_turn_right_7",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_8", material = "a8_turn_right_8",   brightness = 0.8, color = {1, 0.25, 0}},

        {name = "a8_turn_right_9", material = "a8_turn_right_9",   brightness = 0.8, color = {1, 0.25, 0}},

    }

}

--veyron

CustomLights[474] = {

	stateHandlers = {

        ["front"] = function (anim, state)

            if state then

                anim.setLightColor("light_bnw", 0,0,0)

                anim.setLightColor("light_bnw2", 0,0,0)

            end

            anim.setLightState("light_bnw", state)

			anim.setLightState("light_bnw2", state)

            if state then

                if not anim.getLightState("brake") then

                    anim.setLightColor("bnw_brake", 1, 0.02, 0)

                    anim.setLightState("bnw_brake", state)

                end

            else

                if not anim.getLightState("brake") then

                    anim.setLightState("bnw_brake", state)

                end

            end

        end,

    },

    lights = {

        {name = "light_bnw",  material = "bugatti_turn_front_0", colorMul = 20,brightness = 0.01},

	{name = "light_bnw2",  material = "bmw_shader_3*", colorMul = 10,brightness = 0.01},

        {name = "bnw_brake",      material = "bugatti_turn_rear_0", color = {1, 0, 0}},

    }

}



--f40

CustomLights[410] = {

	stateHandlers = {

        ["front"] = function (anim, state)

            if state then

                anim.setLightColor("light_bnw", 0,0,0)

            end

            anim.setLightState("light_bnw", state)

			anim.setLightState("light_bnw2", state)

            if state then

                if not anim.getLightState("brake") then

                    anim.setLightColor("bnw_brake", 0.25, 0.01, 0)

                    anim.setLightState("bnw_brake", state)

                end

            else

                if not anim.getLightState("brake") then

                    anim.setLightState("bnw_brake", state)

                end

            end

        end,

    },

    lights = {

        {name = "light_bnw",  material = "123", colorMul = 10,brightness = 0.05},

	{name = "light_bnw2",  material = "vision6tail1*", colorMul = 20,brightness = 0.05},

        {name = "bnw_brake",      material = "1234*" },

    }

}







makeTurnMirrorFront(475,

    {name = "e63_head_left",  material = "e63_head_left*" },

    {name = "e63_head_right", material = "e63_head_right*" }

)



CustomLights[475] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

     -- В anim.specialAnimData передаётся true/false

        -- true\anim_on - включение фар

        -- false\anim_off - выключение

        --переднии фары с анимацией

    if anim.specialAnimData == "anim_on" then

      if anim.specialAnimTime < 1.3 then

        anim.setLightState("e63_head_left", true)

        anim.setLightState("e63_head_right", true)

        anim.setLightState("e63_head", true)

        anim.setLightColor("e63_head_left", 0, 0, 1 * getEasingValue(anim.specialAnimTime / 1.3, "InQuad"))

        anim.setLightColor("e63_head_right", 0, 0, 1 * getEasingValue(anim.specialAnimTime / 1.3, "InQuad"))

        anim.setLightColor("e63_head", 0, 0, 1 * getEasingValue(anim.specialAnimTime / 1.3, "InQuad"))

      elseif anim.specialAnimTime > 1.3 and anim.specialAnimTime < 1.3 + 0.5 then

        anim.setLightColor("e63_head_left", 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1)

        anim.setLightColor("e63_head_right", 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1)

        anim.setLightColor("e63_head", 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1 * ((anim.specialAnimTime - 1.3) / 0.5), 1)

      end

      --задние габариты

      if anim.specialAnimTime < 0.22 then

        anim.setLightState("e63_tail" .. math.ceil(anim.specialAnimTime * 3 / 0.22), true)

        anim.setLightColor("e63_tail" .. math.ceil(anim.specialAnimTime * 3 / 0.22), 0.4 * (anim.specialAnimTime * 3 / 0.22 - math.ceil(anim.specialAnimTime * 3 / 0.22) + 1), 0, (anim.specialAnimTime * 3 / 0.22 - math.ceil(anim.specialAnimTime * 3 / 0.22) + 1) * 0.2)

      elseif anim.specialAnimTime > 0.22 + 0.1 and anim.specialAnimTime < 0.22 * 2 + 0.1 then

        anim.setLightState("e63_tail" .. math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 3, true)

        anim.setLightColor("e63_tail" .. math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 3, 0.4 * ((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 1), 0, ((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 - 0.1) * 3 / 0.22) + 1) * 0.2)

      elseif anim.specialAnimTime > 0.22 * 2 + 0.1 * 2 and anim.specialAnimTime < 0.22 * 3 + 0.1 * 3 then

        anim.setLightState("e63_tail" .. math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 6, true)

        anim.setLightColor("e63_tail" .. math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 6, 0.4 * ((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 1), 0, ((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22 - math.ceil((anim.specialAnimTime - 0.22 * 2 - 0.1 * 2) * 3 / 0.22) + 1) * 0.2)

      elseif anim.specialAnimTime > 0.22 * 3 + 0.1 * 2 + 0.3 and anim.specialAnimTime < 0.22 * 3 + 0.1 * 2 + 0.3 + 1 then

        for i = 1, 9 do

          anim.setLightState("e63_tail" .. i, true)

          anim.setLightColor("e63_tail" .. i, 0.4 + (1 - 0.4) * ((anim.specialAnimTime - 0.22 * 3 - 0.1 * 2 - 0.3) / 1), 0, (1 - (anim.specialAnimTime - 0.22 * 3 - 0.1 * 2 - 0.3) / 1) * 0.2)

        end

      elseif anim.specialAnimTime > 0.22 * 3 + 0.1 * 2 + 0.3 + 1 then

        anim.stopSpecialAnimation()

      end

    elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

      anim.setLightState("e63_head_left", false)

      anim.setLightState("e63_head_right", false)

      anim.setLightState("e63_head", false)

      for i = 1, 9 do

        anim.setLightState("e63_tail" .. i, false)

      end

      anim.stopSpecialAnimation()

    elseif anim.specialAnimData == "enable" then

      anim.setLightState("e63_head_left", true)

      anim.setLightState("e63_head_right", true)

      anim.setLightState("e63_head", true)

      anim.setLightColor("e63_head_left", 1, 1, 1)

      anim.setLightColor("e63_head_right", 1, 1, 1)

      anim.setLightColor("e63_head", 1, 1, 1)

      for i = 1, 9 do

        anim.setLightState("e63_tail" .. i, true)

        anim.setLightColor("e63_tail" .. i, 1, 0, 0)

      end

      anim.stopSpecialAnimation()

    end

  end,

  

  stateHandlers = {

  ["turn_left"] = function(anim, state)

      if state then

        anim.setLightColor("e63_head_left", 1, 0.5, 0)

      end

      anim.setLightState("e63_head_left", state)

    end,

    ["turn_right"] = function(anim, state)

      if state then

        anim.setLightColor("e63_head_right", 1, 0.5, 0)

      end

      anim.setLightState("e63_head_right", state)

    end,

    ["front"] = function(anim, state)

    -- Если включен поворотник, состояние не обновляется

      if not anim.getLightState("turn_left") then

        if state then

          anim.setLightColor("e63_head_left", 1, 1, 1)

        end

        anim.setLightState("e63_head_left", state)

      end

      if not anim.getLightState("turn_right") then

        if state then

          anim.setLightColor("e63_head_right", 1, 1, 1)

          anim.setLightColor("e63_head", 1, 1, 1)

        end

        anim.setLightState("e63_head_right", state)

        anim.setLightState("e63_head", state)

      end

    end

  },

  

  dataHandlers = {

    ["turn_left"] = function(anim, state)

      if not state and anim.getLightState("front") then

        anim.setLightColor("e63_head_left", 1, 1, 1)

        anim.setLightState("e63_head_left", true)

      end

    end,

    ["turn_right"] = function(anim, state)

      if not state and anim.getLightState("front") then

        anim.setLightColor("e63_head_right", 1, 1, 1)

        anim.setLightState("e63_head_right", true)

      end

    end,

    ["emergency_light"] = function(anim, state)

      if not state and anim.getLightState("front") then

        anim.setLightColor("e63_head_left", 1, 1, 1)

        anim.setLightState("e63_head_left", true)

        anim.setLightColor("e63_head_right", 1, 1, 1)

        anim.setLightState("e63_head_right", true)

        anim.setLightColor("e63_head", 1, 1, 1)

        anim.setLightState("e63_head", true)

      end

    end

  },



    lights = {

        {name = "e63_head_left",  material = "e63_head_left"  },

        {name = "e63_head_right", material = "e63_head_right" },

        {name = "e63_head",       material = "e63_head" },

        {name = "e63_tail1",      material = "e63_tail" },



    }

}



-- RS7

-- RS6 

CustomLights[492] = {   

    init = function (anim)

        anim.turnLightsInterval = 0.85

        -- Время, за которое загораются все блоки

    if FPS > FPSNornal then 

        anim.rearLightsTime = 0.35

    else 

        anim.rearLightsTime = 0.55

    end

        -- Время, после которого свет начинает плавно затухать

        anim.rearLightsFadeAfter = 0.35

    end,



    update = function (anim, deltaTime, vehicle)

        --print (anim.specialAnimActive)

        

        

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.turnLightsState then

            if anim.turnLightsTime < anim.rearLightsTime then

                -- Включение блоков по очереди

             --   local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0

                local index = math.floor(anim.turnLightsTime/ anim.rearLightsTime * 12)

                



                if anim.getLightState("turn_left") then

                   anim.setLightState("rs6r_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

                if anim.getLightState("turn_right") then

                   anim.setLightState("rs6r_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

            elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

               if anim.getLightState("turn_left") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

                if anim.getLightState("turn_right") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

            end

        end

        

        if anim.specialAnimActive then

            local currentTime = anim.specialAnimTime

            if anim.specialAnimData == "anim_on" or anim.specialAnimData == "enable" then

                 time0 = 0 -- Задержка старта анимации    

                 time2 = 0.5 -- Время прохождения "щелчка", после основной анимации на передних фарах

                 time4 = 1 -- ?             

                 timePause0 = 0.1

                 timePause01 = 0 -- Задержка старта анимации          

                 timePause = 0.03

                 timePause2 = 0.5



            if FPS > FPSNornal then 

                time1 = 0.2 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time0 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    local index = math.floor(currentTime/time0 * 12)

                    anim.setLightState("rs6f_turn_left_"..index, false)

                    anim.setLightColor("rs6f_turn_left_"..index, 1, 0.5, 0)

                    anim.setLightState("rs6f_turn_right_"..index, false)

                    anim.setLightColor("rs6f_turn_right_"..index, 1, 0.5, 0)

                elseif currentTime > time0 + timePause0 and currentTime < time0 + timePause0 + timePause01 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    for i = 0, 11 do

                        anim.setLightColor("rs6f_turn_left_"..i, 0, 0, 0)

                        anim.setLightColor("rs6f_turn_right_"..i, 0, 0, 0)

                    end

                elseif currentTime > time0 + timePause0 + timePause01 then

                    currentTime = currentTime - (time0 + timePause0 + timePause01)

                    for i = 0, 12 do

                        if currentTime > time1*i and currentTime < time1*(i+1) + timePause*i then

                            --local progress = (currentTime-time1*i-timePause*i) * 12 / time1

                            local progress = (currentTime-time1*i-timePause*i) / time1 * 13

                            local index = math.ceil(progress) - 1

                            local index2 = 12 + i - index

                            

                            anim.setLightState("rs6f_turn_left_"..index2, true)

                            anim.setLightColor("rs6f_turn_left_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_left_"..index2 + 1, false)

                            

                            anim.setLightState("rs6f_turn_right_"..index2, true)

                            anim.setLightColor("rs6f_turn_right_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_right_"..index2 + 1, false)

                        elseif currentTime > time1*12 + timePause*12 + timePause2 then

                            for i = 0, 12 do

                                local currentTime2 = currentTime - time1*12 - timePause*12 - timePause2

                                if currentTime2 > time2*i and currentTime2 < time2*(i+1) + timePause*i then

                                    local progress = (currentTime2-time2*i-timePause*i) * 12 / time2

                                    local index = math.ceil(progress)

                                    local index2 = index

                                    progress = progress - index

                                    anim.setLightColor("rs6f_turn_left_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_left_"..index2-1, 1, 1, 1)

                                    

                                    anim.setLightColor("rs6f_turn_right_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_right_"..index2 - 1, 1, 1, 1)

                                    if index2 >= 12 then

                                        for i = 0, 12 do

                                            anim.setLightState("rs6f_turn_left_"..i, true)

                                            anim.setLightState("rs6f_turn_right_"..i, true)

                                            anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                                            anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                                        end

                                        anim.stopSpecialAnimation()

                                    end

                                end

                            end

                        end

                    end

                    

                    for i = 0, 9 do

                        if currentTime > time3*i and currentTime < time3*(i+1) + timePause*i then

                            local progress = (currentTime-time3*i - timePause*i) / time3 * 8

                            local index = math.ceil(progress)

                            local index2 = 9 + i - index

                            --[[if i < 1 then

                                print (i, index, index2)

                            end]]

                            

                            if index2 >= 0 then

                                if index2 < 10 then

                                    anim.setLightState("rs6_brake_"..index2, true)

                                    anim.setLightColor("rs6_brake_"..index2, 1, 0, 0)

                                    if index2 + 1 ~= 10 then

                                        anim.setLightState("rs6_brake_"..index2 + 1, false)

                                    end

                                end

                            end

                        end

                    end

                    

                    local progress = getEasingValue (currentTime/(time3*10 + timePause*9), "InQuad")

                    if progress <= 1 then

                      --  print (currentTime, progress)

                        anim.setLightState("rs6_brake_10", true)

                        anim.setLightColor("rs6_brake_10", 1*progress, 0, 0)

                    end

                end

                elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

                local time2 = 0.9 -- ? 

                local timePause = 0.9



            if FPS > FPSNornal then 

                time1 = 0.6 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time1 then

                    local progress = currentTime * 12 / time1

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    local color = 0.1 * progress

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 and currentTime < time1 + time2 then

                    local progress = (currentTime - time1) * 12 / time2

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    index = 11 - index

                    local color = 1 - 0.65 * progress

                    --anim.setLightState("rs6f_turn_left_"..index, )

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 + time2 + timePause then

                    for i = 0, 11 do

                        anim.setLightState("rs6f_turn_left_"..i, false)

                        anim.setLightState("rs6f_turn_right_"..i, false)

                        anim.stopSpecialAnimation()

                    end  

                end

                

                if currentTime < time3 then

                    local progress = currentTime * 9 / time3

                    local index = math.ceil(progress)

                    progress = progress - index + 1

                    anim.setLightState("rs6_brake_"..(10 - index), false)

                end

                

                local progress = getEasingValue (currentTime/time3, "InQuad")

                --print (progress)

                if progress <= 1 then

                    anim.setLightState("rs6_brake_10", true)

                    anim.setLightColor("rs6_brake_10", 1 - 1*progress, 0, 0)

                end

            end

        end

    end,

    

   stateHandlers = {

        ["turn_left"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_left_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_left_" ..i, false)

          anim.setLightState("rs6f_turn_left_" ..i, false)

        end

            end

        end,

        ["turn_right"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_right_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_right_" ..i, false)

          anim.setLightState("rs6f_turn_right_" ..i, false)

        end

            end

        end,

        ["front"] = function (anim, state, veh)

            if state then

                anim.startSpecialAnimation(veh, "anim_on")

            else

                anim.startSpecialAnimation(veh, "anim_off")

            end

        end,

    },



    dataHandlers = {

        ["turn_left"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_left_" ..i, true)

        end

      end

    end,

    ["turn_right"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_right_" ..i, true)

        end

      end

    end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 12 do

                    anim.setLightState("rs6f_turn_left_"..i, true)

                    anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                    anim.setLightState("rs6f_turn_right_"..i, true)

                    anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                end

            end

        end

    },



    lights = {

        {name = "rs6f_turn_left_0",  material = "rs6f_turn_left_0" , colorMul = 1.6 },

        {name = "rs6f_turn_left_1",  material = "rs6f_turn_left_1" , colorMul = 1.6 },

        {name = "rs6f_turn_left_2",  material = "rs6f_turn_left_2" , colorMul = 1.6 },

        {name = "rs6f_turn_left_3",  material = "rs6f_turn_left_3" , colorMul = 1.6 },

        {name = "rs6f_turn_left_4",  material = "rs6f_turn_left_4" , colorMul = 1.6 },

        {name = "rs6f_turn_left_5",  material = "rs6f_turn_left_5" , colorMul = 1.6 },

        {name = "rs6f_turn_left_6",  material = "rs6f_turn_left_6" , colorMul = 1.6 },

        {name = "rs6f_turn_left_7",  material = "rs6f_turn_left_7" , colorMul = 1.6 },

        {name = "rs6f_turn_left_8",  material = "rs6f_turn_left_8" , colorMul = 1.6 },

        {name = "rs6f_turn_left_9",  material = "rs6f_turn_left_9" , colorMul = 1.6 },

        {name = "rs6f_turn_left_10",  material = "rs6f_turn_left_10" , colorMul = 1.6 },

        {name = "rs6f_turn_left_11",  material = "rs6f_turn_left_11" , colorMul = 1.6 },

        

        {name = "rs6f_turn_right_0", material = "rs6f_turn_right_0", colorMul = 1.6 },

        {name = "rs6f_turn_right_1",  material = "rs6f_turn_right_1" , colorMul = 1.6 },

        {name = "rs6f_turn_right_2",  material = "rs6f_turn_right_2" , colorMul = 1.6 },

        {name = "rs6f_turn_right_3",  material = "rs6f_turn_right_3" , colorMul = 1.6 },

        {name = "rs6f_turn_right_4",  material = "rs6f_turn_right_4" , colorMul = 1.6 },

        {name = "rs6f_turn_right_5",  material = "rs6f_turn_right_5" , colorMul = 1.6 },

        {name = "rs6f_turn_right_6",  material = "rs6f_turn_right_6" , colorMul = 1.6 },

        {name = "rs6f_turn_right_7",  material = "rs6f_turn_right_7" , colorMul = 1.6 },

        {name = "rs6f_turn_right_8",  material = "rs6f_turn_right_8" , colorMul = 1.6 },

        {name = "rs6f_turn_right_9",  material = "rs6f_turn_right_9" , colorMul = 1.6 },

        {name = "rs6f_turn_right_10",  material = "rs6f_turn_right_10" , colorMul = 1.6 },

        {name = "rs6f_turn_right_11",  material = "rs6f_turn_right_11" , colorMul = 1.6 },



        {name = "rs6r_turn_left_0", material = "rs6r_turn_left_0",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_1", material = "rs6r_turn_left_1",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_2", material = "rs6r_turn_left_2",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_3", material = "rs6r_turn_left_3",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_4", material = "rs6r_turn_left_4",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_0", material = "rs6r_turn_right_0", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_1", material = "rs6r_turn_right_1", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_2", material = "rs6r_turn_right_2", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_3", material = "rs6r_turn_right_3", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_4", material = "rs6r_turn_right_4", brightness = 0.5, color = {1, 0.1, 0}},        

        

        {name = "rs6_brake_1", material = "rs6_brake_0" },

        {name = "rs6_brake_2", material = "rs6_brake_1" },

        {name = "rs6_brake_3", material = "rs6_brake_2" },

        {name = "rs6_brake_4", material = "rs6_brake_3" },

        {name = "rs6_brake_5", material = "rs6_brake_4" },

        {name = "rs6_brake_6", material = "rs6_brake_5" },

        {name = "rs6_brake_7", material = "rs6_brake_6" },

        {name = "rs6_brake_8", material = "rs6_brake_7" },

        {name = "rs6_brake_9", material = "rs6_brake_8" },

        {name = "rs6_brake_10", material = "rs6_brake_9" },

    }

}



-- RS6 

CustomLights[492] = {   

    init = function (anim)

        anim.turnLightsInterval = 0.85

        -- Время, за которое загораются все блоки

    if FPS > FPSNornal then 

        anim.rearLightsTime = 0.35

    else 

        anim.rearLightsTime = 0.55

    end

        -- Время, после которого свет начинает плавно затухать

        anim.rearLightsFadeAfter = 0.35

    end,



    update = function (anim, deltaTime, vehicle)

        --print (anim.specialAnimActive)

        

        

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.turnLightsState then

            if anim.turnLightsTime < anim.rearLightsTime then

                -- Включение блоков по очереди

             --   local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0

                local index = math.floor(anim.turnLightsTime/ anim.rearLightsTime * 12)

                



                if anim.getLightState("turn_left") then

                   anim.setLightState("rs6r_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

                if anim.getLightState("turn_right") then

                   anim.setLightState("rs6r_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

            elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

               if anim.getLightState("turn_left") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

                if anim.getLightState("turn_right") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

            end

        end

        

        if anim.specialAnimActive then

            local currentTime = anim.specialAnimTime

            if anim.specialAnimData == "anim_on" or anim.specialAnimData == "enable" then

                 time0 = 0 -- Задержка старта анимации    

                 time2 = 0.5 -- Время прохождения "щелчка", после основной анимации на передних фарах

                 time4 = 1 -- ?             

                 timePause0 = 0.1

                 timePause01 = 0 -- Задержка старта анимации          

                 timePause = 0.03

                 timePause2 = 0.5



            if FPS > FPSNornal then 

                time1 = 0.2 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time0 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    local index = math.floor(currentTime/time0 * 12)

                    anim.setLightState("rs6f_turn_left_"..index, false)

                    anim.setLightColor("rs6f_turn_left_"..index, 1, 0.5, 0)

                    anim.setLightState("rs6f_turn_right_"..index, false)

                    anim.setLightColor("rs6f_turn_right_"..index, 1, 0.5, 0)

                elseif currentTime > time0 + timePause0 and currentTime < time0 + timePause0 + timePause01 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    for i = 0, 11 do

                        anim.setLightColor("rs6f_turn_left_"..i, 0, 0, 0)

                        anim.setLightColor("rs6f_turn_right_"..i, 0, 0, 0)

                    end

                elseif currentTime > time0 + timePause0 + timePause01 then

                    currentTime = currentTime - (time0 + timePause0 + timePause01)

                    for i = 0, 12 do

                        if currentTime > time1*i and currentTime < time1*(i+1) + timePause*i then

                            --local progress = (currentTime-time1*i-timePause*i) * 12 / time1

                            local progress = (currentTime-time1*i-timePause*i) / time1 * 13

                            local index = math.ceil(progress) - 1

                            local index2 = 12 + i - index

                            

                            anim.setLightState("rs6f_turn_left_"..index2, true)

                            anim.setLightColor("rs6f_turn_left_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_left_"..index2 + 1, false)

                            

                            anim.setLightState("rs6f_turn_right_"..index2, true)

                            anim.setLightColor("rs6f_turn_right_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_right_"..index2 + 1, false)

                        elseif currentTime > time1*12 + timePause*12 + timePause2 then

                            for i = 0, 12 do

                                local currentTime2 = currentTime - time1*12 - timePause*12 - timePause2

                                if currentTime2 > time2*i and currentTime2 < time2*(i+1) + timePause*i then

                                    local progress = (currentTime2-time2*i-timePause*i) * 12 / time2

                                    local index = math.ceil(progress)

                                    local index2 = index

                                    progress = progress - index

                                    anim.setLightColor("rs6f_turn_left_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_left_"..index2-1, 1, 1, 1)

                                    

                                    anim.setLightColor("rs6f_turn_right_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_right_"..index2 - 1, 1, 1, 1)

                                    if index2 >= 12 then

                                        for i = 0, 12 do

                                            anim.setLightState("rs6f_turn_left_"..i, true)

                                            anim.setLightState("rs6f_turn_right_"..i, true)

                                            anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                                            anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                                        end

                                        anim.stopSpecialAnimation()

                                    end

                                end

                            end

                        end

                    end

                    

                    for i = 0, 9 do

                        if currentTime > time3*i and currentTime < time3*(i+1) + timePause*i then

                            local progress = (currentTime-time3*i - timePause*i) / time3 * 8

                            local index = math.ceil(progress)

                            local index2 = 9 + i - index

                            --[[if i < 1 then

                                print (i, index, index2)

                            end]]

                            

                            if index2 >= 0 then

                                if index2 < 10 then

                                    anim.setLightState("rs6_brake_"..index2, true)

                                    anim.setLightColor("rs6_brake_"..index2, 1, 0, 0)

                                    if index2 + 1 ~= 10 then

                                        anim.setLightState("rs6_brake_"..index2 + 1, false)

                                    end

                                end

                            end

                        end

                    end

                    

                    local progress = getEasingValue (currentTime/(time3*10 + timePause*9), "InQuad")

                    if progress <= 1 then

                      --  print (currentTime, progress)

                        anim.setLightState("rs6_brake_10", true)

                        anim.setLightColor("rs6_brake_10", 1*progress, 0, 0)

                    end

                end

                elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

                local time2 = 0.9 -- ? 

                local timePause = 0.9



            if FPS > FPSNornal then 

                time1 = 0.6 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time1 then

                    local progress = currentTime * 12 / time1

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    local color = 0.1 * progress

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 and currentTime < time1 + time2 then

                    local progress = (currentTime - time1) * 12 / time2

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    index = 11 - index

                    local color = 1 - 0.65 * progress

                    --anim.setLightState("rs6f_turn_left_"..index, )

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 + time2 + timePause then

                    for i = 0, 11 do

                        anim.setLightState("rs6f_turn_left_"..i, false)

                        anim.setLightState("rs6f_turn_right_"..i, false)

                        anim.stopSpecialAnimation()

                    end  

                end

                

                if currentTime < time3 then

                    local progress = currentTime * 9 / time3

                    local index = math.ceil(progress)

                    progress = progress - index + 1

                    anim.setLightState("rs6_brake_"..(10 - index), false)

                end

                

                local progress = getEasingValue (currentTime/time3, "InQuad")

                --print (progress)

                if progress <= 1 then

                    anim.setLightState("rs6_brake_10", true)

                    anim.setLightColor("rs6_brake_10", 1 - 1*progress, 0, 0)

                end

            end

        end

    end,

    

   stateHandlers = {

        ["turn_left"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_left_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_left_" ..i, false)

          anim.setLightState("rs6f_turn_left_" ..i, false)

        end

            end

        end,

        ["turn_right"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_right_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_right_" ..i, false)

          anim.setLightState("rs6f_turn_right_" ..i, false)

        end

            end

        end,

        ["front"] = function (anim, state, veh)

            if state then

                anim.startSpecialAnimation(veh, "anim_on")

            else

                anim.startSpecialAnimation(veh, "anim_off")

            end

        end,

    },



    dataHandlers = {

        ["turn_left"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_left_" ..i, true)

        end

      end

    end,

    ["turn_right"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_right_" ..i, true)

        end

      end

    end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 12 do

                    anim.setLightState("rs6f_turn_left_"..i, true)

                    anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                    anim.setLightState("rs6f_turn_right_"..i, true)

                    anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                end

            end

        end

    },



    lights = {

        {name = "rs6f_turn_left_0",  material = "rs6f_turn_left_0" , colorMul = 1.6 },

        {name = "rs6f_turn_left_1",  material = "rs6f_turn_left_1" , colorMul = 1.6 },

        {name = "rs6f_turn_left_2",  material = "rs6f_turn_left_2" , colorMul = 1.6 },

        {name = "rs6f_turn_left_3",  material = "rs6f_turn_left_3" , colorMul = 1.6 },

        {name = "rs6f_turn_left_4",  material = "rs6f_turn_left_4" , colorMul = 1.6 },

        {name = "rs6f_turn_left_5",  material = "rs6f_turn_left_5" , colorMul = 1.6 },

        {name = "rs6f_turn_left_6",  material = "rs6f_turn_left_6" , colorMul = 1.6 },

        {name = "rs6f_turn_left_7",  material = "rs6f_turn_left_7" , colorMul = 1.6 },

        {name = "rs6f_turn_left_8",  material = "rs6f_turn_left_8" , colorMul = 1.6 },

        {name = "rs6f_turn_left_9",  material = "rs6f_turn_left_9" , colorMul = 1.6 },

        {name = "rs6f_turn_left_10",  material = "rs6f_turn_left_10" , colorMul = 1.6 },

        {name = "rs6f_turn_left_11",  material = "rs6f_turn_left_11" , colorMul = 1.6 },

        

        {name = "rs6f_turn_right_0", material = "rs6f_turn_right_0", colorMul = 1.6 },

        {name = "rs6f_turn_right_1",  material = "rs6f_turn_right_1" , colorMul = 1.6 },

        {name = "rs6f_turn_right_2",  material = "rs6f_turn_right_2" , colorMul = 1.6 },

        {name = "rs6f_turn_right_3",  material = "rs6f_turn_right_3" , colorMul = 1.6 },

        {name = "rs6f_turn_right_4",  material = "rs6f_turn_right_4" , colorMul = 1.6 },

        {name = "rs6f_turn_right_5",  material = "rs6f_turn_right_5" , colorMul = 1.6 },

        {name = "rs6f_turn_right_6",  material = "rs6f_turn_right_6" , colorMul = 1.6 },

        {name = "rs6f_turn_right_7",  material = "rs6f_turn_right_7" , colorMul = 1.6 },

        {name = "rs6f_turn_right_8",  material = "rs6f_turn_right_8" , colorMul = 1.6 },

        {name = "rs6f_turn_right_9",  material = "rs6f_turn_right_9" , colorMul = 1.6 },

        {name = "rs6f_turn_right_10",  material = "rs6f_turn_right_10" , colorMul = 1.6 },

        {name = "rs6f_turn_right_11",  material = "rs6f_turn_right_11" , colorMul = 1.6 },



        {name = "rs6r_turn_left_0", material = "rs6r_turn_left_0",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_1", material = "rs6r_turn_left_1",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_2", material = "rs6r_turn_left_2",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_3", material = "rs6r_turn_left_3",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_4", material = "rs6r_turn_left_4",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_0", material = "rs6r_turn_right_0", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_1", material = "rs6r_turn_right_1", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_2", material = "rs6r_turn_right_2", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_3", material = "rs6r_turn_right_3", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_4", material = "rs6r_turn_right_4", brightness = 0.5, color = {1, 0.1, 0}},        

        

        {name = "rs6_brake_1", material = "rs6_brake_0" },

        {name = "rs6_brake_2", material = "rs6_brake_1" },

        {name = "rs6_brake_3", material = "rs6_brake_2" },

        {name = "rs6_brake_4", material = "rs6_brake_3" },

        {name = "rs6_brake_5", material = "rs6_brake_4" },

        {name = "rs6_brake_6", material = "rs6_brake_5" },

        {name = "rs6_brake_7", material = "rs6_brake_6" },

        {name = "rs6_brake_8", material = "rs6_brake_7" },

        {name = "rs6_brake_9", material = "rs6_brake_8" },

        {name = "rs6_brake_10", material = "rs6_brake_9" },

    }

}


CustomLights[445] = {
    init = function (anim)
        anim.turnLightsInterval = 0.35
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_left_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_left_1", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_right_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_right_1", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_left_1", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_right_1", state)
            end
        end,
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end
    },

    lights = {
        {name = "shader_turn_left_1",  material = "shader_turn_left_1" , colorMul = 1.6 },
        {name = "shader_turn_right_1", material = "shader_turn_right_1", colorMul = 1.6 },
    }
}


CustomLights[598] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 1.3

            local timeFront2 = 0.5

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("vrs_turn_left", true)

                anim.setLightState("vrs_turn_right", true)

                anim.setLightColor("vrs_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("vrs_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("vrs_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("vrs_turn_right", 1 * progress, 1 * progress, 1)

            end

            local timeLine = 0.22

            local timePause = 0.1

            local timeBrightnessPause = 0.3

            local timeBrightness = 1

            local colorStart = 0.4

            if currentTime < timeLine then

                local progress = currentTime * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then

                local progress = (currentTime - timeLine - timePause) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 3

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then

                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 6

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness

                for i = 1, 9 do

                    anim.setLightState("s650_brake"..i, true)

                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)

                end

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, false)

            end

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, true)

                anim.setLightColor("s650_brake"..i, 1, 0, 0)

            end

            anim.stopSpecialAnimation()

        end

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

               anim.setLightColor("vrs_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("vrs_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("vrs_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("vrs_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("vrs_turn_left", 1, 1, 1)

                end

                anim.setLightState("vrs_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("vrs_turn_right", 1, 1, 1)

                end

                anim.setLightState("vrs_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            else

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            end

        end,

        ["brake"] = function (anim, state)

            if anim.specialAnimActive then

                return

            end

            if not state and anim.getLightState("front") then

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                end

            else

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 1, 0.25, 0.25)

                    anim.setLightState("s650_brake"..i, state)

                end

            end

        end

    },

    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("vrs_turn_left", 1, 1, 1)

                anim.setLightState("vrs_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("vrs_turn_right", 1, 1, 1)

                anim.setLightState("vrs_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("vrs_turn_left", 1, 1, 1)

                anim.setLightState("vrs_turn_left", true)

                anim.setLightColor("vrs_turn_right", 1, 1, 1)

                anim.setLightState("vrs_turn_right", true)

            end

        end

    },

    lights = {

        {name = "vrs_turn_left",  material = "vrs_turn_left_*"  },

        {name = "vrs_turn_right", material = "vrs_turn_right_*" },

        {name = "s650_brake1",     material = "s650_brake_0" },

        {name = "s650_brake2",     material = "s650_brake_1" },

        {name = "s650_brake3",     material = "s650_brake_2" },

        {name = "s650_brake4",     material = "s650_brake_3" },

        {name = "s650_brake5",     material = "s650_brake_4" },

        {name = "s650_brake6",     material = "s650_brake_5" },

        {name = "s650_brake7",     material = "s650_brake_6" },

        {name = "s650_brake8",     material = "s650_brake_7" },

    }

}



CustomLights[508] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 1.3

            local timeFront2 = 0.5

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

            end

            local timeLine = 0.22

            local timePause = 0.1

            local timeBrightnessPause = 0.3

            local timeBrightness = 1

            local colorStart = 0.4

            if currentTime < timeLine then

                local progress = currentTime * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then

                local progress = (currentTime - timeLine - timePause) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 3

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then

                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 6

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness

                for i = 1, 9 do

                    anim.setLightState("s650_brake"..i, true)

                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)

                end

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, false)

            end

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, true)

                anim.setLightColor("s650_brake"..i, 1, 0, 0)

            end

            anim.stopSpecialAnimation()

        end

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

               anim.setLightColor("s650_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("s650_turn_left", 1, 1, 1)

                end

                anim.setLightState("s650_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("s650_turn_right", 1, 1, 1)

                end

                anim.setLightState("s650_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            else

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            end

        end,

        ["brake"] = function (anim, state)

            if anim.specialAnimActive then

                return

            end

            if not state and anim.getLightState("front") then

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                end

            else

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 1, 0.25, 0.25)

                    anim.setLightState("s650_brake"..i, state)

                end

            end

        end

    },

    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end

    },

    lights = {

        {name = "s650_turn_left",  material = "s650_turn_left_*"  },

        {name = "s650_turn_right", material = "s650_turn_right_*" },

        {name = "s650_brake1",     material = "s650_brake_0" },

        {name = "s650_brake2",     material = "s650_brake_1" },

        {name = "s650_brake3",     material = "s650_brake_2" },

        {name = "s650_brake4",     material = "s650_brake_3" },

        {name = "s650_brake5",     material = "s650_brake_4" },

        {name = "s650_brake6",     material = "s650_brake_5" },

        {name = "s650_brake7",     material = "s650_brake_6" },

        {name = "s650_brake8",     material = "s650_brake_7" },

    }

}



-- KIA K5

makeTurnMirrorFront(540,

{name = "gls_turn_left", material = "gls_turn_left_*" },

{name = "gls_turn_right", material = "gls_turn_right_*" }

) 



-- Audi R8

CustomLights[422] = {

    init = function (anim)

        anim.turnLightsInterval = 0.5

        -- Время, за которое загораются все блоки

        anim.rearLightsTime = 0.3

        -- Время, после которого свет начинает плавно затухать

        anim.rearLightsFadeAfter = 0.38

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if not state then

                for i = 0, 4 do

                    anim.setLightState("audi_turn_left_"..i, state)

                    -- Сброс цвета

                    anim.setLightColor("audi_turn_left_"..i, 1, 0.5, 0)

                end

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state then

                for i = 0, 4 do

                    anim.setLightState("audi_turn_right_"..i, state)

                    -- Сброс цвета

                    anim.setLightColor("audi_turn_right_"..i, 1, 0.5, 0)

                end

            end

        end

    },



    -- Задние поворотники

    update = function (anim)

        if not anim.turnLightsState then

            return

        end



        if anim.turnLightsTime < anim.rearLightsTime then

            -- Включение блоков по очереди

            local index = math.floor(anim.turnLightsTime / anim.rearLightsTime * 5)



            if anim.getLightState("turn_left") then

                anim.setLightState("audi_turn_left_"..index, true)

            end

            if anim.getLightState("turn_right") then

                anim.setLightState("audi_turn_right_"..index, true)

            end

        elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

            -- Плавное затухание всех блоков

            local progress = 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter)/(0.5 - anim.rearLightsFadeAfter)

            if anim.getLightState("turn_left") then

                for i = 0, 4 do

                    anim.setLightColor("audi_turn_left_"..i, progress, progress * 0.5, 0)

                end

            end

            if anim.getLightState("turn_right") then

                for i = 0, 4 do

                    anim.setLightColor("audi_turn_right_"..i, progress, progress * 0.5, 0)

                end

            end

        end

    end,



    lights = {

        {name = "audi_turn_left_0", material = "audi_turn_left_0",   brightness = 0.7, color = {1, 0.5, 0}},
        {name = "audi_turn_left_1", material = "audi_turn_left_1",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_left_2", material = "audi_turn_left_2",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_left_3", material = "audi_turn_left_3",   brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_left_4", material = "audi_turn_left_4",   brightness = 0.7, color = {1, 0.5, 0}},



        {name = "audi_turn_right_0", material = "audi_turn_right_0", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_right_1", material = "audi_turn_right_1", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_right_2", material = "audi_turn_right_2", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_right_3", material = "audi_turn_right_3", brightness = 0.7, color = {1, 0.5, 0}},

        {name = "audi_turn_right_4", material = "audi_turn_right_4", brightness = 0.7, color = {1, 0.5, 0}},

    }

}



-- Ferrari California

CustomLights[517] = {



    -- Задний ход = задние поворотники

    stateHandlers = {

        ["turn_left"] = function (anim, state)

            anim.setLightColor("reverseturn_left", 1, 0.5, 0)

            anim.setLightState("reverseturn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            anim.setLightColor("reverseturn_right", 1, 0.5, 0)

            anim.setLightState("reverseturn_right", state)

        end,

        ["rear"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("reverseturn_left", 1, 1, 1)

                end

                anim.setLightState("reverseturn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("reverseturn_right", 1, 1, 1)

                end

                anim.setLightState("reverseturn_right", state)

            end

        end

    },



    lights = {

        {name = "reverseturn_left"  },

        {name = "reverseturn_right" },

    }

}







-- BMW R1100 - Мот

CustomLights[521] = {

    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("bmw_turn_left_1", 0.5, 0.8, 0)

            end

            anim.setLightState("bmw_turn_left_1", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("bmw_turn_right_1", 0.5, 0.8, 0)

            end

            anim.setLightState("bmw_turn_right_1", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("bmw_turn_left_1", 0.3, 0.1, 0.1)

                end

                anim.setLightState("bmw_turn_left_1", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("bmw_turn_right_1", 0.3, 0.1, 0.1)

                end

                anim.setLightState("bmw_turn_right_1", state)

            end

            if state then

                anim.setLightColor("bmw_light", 1, 1, 1)

			else

				anim.setLightColor("bmw_light", 0.1, 0, 0)

            end

			anim.setLightState("bmw_light", state)

        end,

		["brake"] = function (anim, state)

			if state then

				anim.setLightColor("bmw_stop", 0.3, 0.1, 0.1)

			else

				anim.setLightColor("bmw_stop", 0.1, 0, 0)

			end

			anim.setLightState("bmw_stop", state)

		end

    },

	

	dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("bmw_turn_left_1", 0.3, 0.1, 0.1)

                anim.setLightState("bmw_turn_left_1", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("bmw_turn_right_1", 0.3, 0.1, 0.1)

                anim.setLightState("bmw_turn_right_1", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("bmw_turn_left_1", 0.3, 0.1, 0.1)

                anim.setLightState("bmw_turn_left_1", true)

                anim.setLightColor("bmw_turn_right_1", 0.3, 0.1, 0.1)

                anim.setLightState("bmw_turn_right_1", true)

            end

        end

    },



    lights = {

        {name = "bmw_turn_left_1",  material = "bmw_rl" , colorMul = 2 },

        {name = "bmw_turn_right_1", material = "bmw_rr", colorMul = 2 },

        {name = "bmw_light", material = "bmw_light", colorMul = 1 },

        {name = "bmw_stop", material = "bmw_stop", colorMul = 2 },

    }

}



-- ВАЗ 2170

CustomLights[547] = {



    -- Задний ход = задние поворотники

    stateHandlers = {

        ["front"] = function (anim, state)

            if not state then

                anim.setLightColor("priora_light1", 0.1, 0, 0)

                anim.setLightColor("priora_light2", 0.1, 0, 0)

                anim.setLightColor("priora_light3", 0.1, 0, 0)

                anim.setLightColor("priora_light4", 0.1, 0, 0)

            else

                anim.setLightColor("priora_light1", 1, 1, 1)

                anim.setLightColor("priora_light2", 1, 0.3, 0.3)

                anim.setLightColor("priora_light3", 1, 1, 1)

                anim.setLightColor("priora_light4", 1, 0.3, 0.3)

            end

			anim.setLightState("priora_light1", state)

			anim.setLightState("priora_light2", state)

			anim.setLightState("priora_light3", state)

			anim.setLightState("priora_light4", state)

        end

    },



    lights = {

        {name = "priora_light1",  material = "2170_head_0" , colorMul = 2 },

        {name = "priora_light2",  material = "2170_tail_0" , colorMul = 2 },

        {name = "priora_light3",  material = "2170_head_1" , colorMul = 2 },

        {name = "priora_light4",  material = "2170_tail_1" , colorMul = 2 },

    },

}



-- BMW X5M F85

makeTurnMirrorFront(580,

    {name = "bmw_turn_left",  material = "bmw_turn_left_*" },

    {name = "bmw_turn_right", material = "bmw_turn_right_*" }

)



makeTurnMirrorFront(479,



    {name = "rols_turn_left",  material = "rols_turn_left_*" },



    {name = "rols_turn_right", material = "rols_turn_right_*" }



)






-- Porsche Panamera Turbo

makeTurnMirrorFront(566,

    {name = "porsche_turn_left",  material = "porsche_turn_left_*" },

    {name = "porsche_turn_right", material = "porsche_turn_right_*" }

)



-- Shelby GT500

makeTurnMirrorFront(500,

    {name = "shelby_turn_left",  material = "shelby_turn_left_*" },

    {name = "shelby_turn_right", material = "shelby_turn_right_*" }

)

-- Yaguar F-PACE

-- demon_turn работает как стопы и повороты

CustomLights[505] = {
    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_left_r", 1, 0.3, 0)
                anim.setLightColor("demon_turn_left", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_left_r", state)
            anim.setLightState("demon_turn_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("demon_turn_right_r", 1, 0.3, 0)
                anim.setLightColor("demon_turn_right", 1, 0.3, 0)
            end
            anim.setLightState("demon_turn_right_r", state)
            anim.setLightState("demon_turn_right", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("demon_turn_left_r", 1, 0, 0)
                    anim.setLightColor("demon_turn_left", 1, 1, 1)
                end
                anim.setLightState("demon_turn_left_r", state)
                anim.setLightState("demon_turn_left", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("demon_turn_right_r", 1, 0, 0)
                    anim.setLightColor("demon_turn_right", 1, 1, 1)
                end
                anim.setLightState("demon_turn_right_r", state)
                anim.setLightState("demon_turn_right", state)
            end
        end
    },
    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_left_r", 1, 0, 0)
                anim.setLightState("demon_turn_left_r", true)
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("brake") then
                anim.setLightColor("demon_turn_right_r", 1, 0, 0)
                anim.setLightState("demon_turn_right_r", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("demon_turn_left_r", 1, 0, 0)
                anim.setLightState("demon_turn_left_r", true)
                anim.setLightColor("demon_turn_right_r", 1, 0, 0)
                anim.setLightState("demon_turn_right_r", true)
                anim.setLightColor("demon_turn_left", 1, 1, 1)
                anim.setLightState("demon_turn_left", true)
                anim.setLightColor("demon_turn_right", 1, 1, 1)
                anim.setLightState("demon_turn_right", true)
            end
        end
    },

    lights = {
        {name = "demon_turn_left",  material = "gls_turn_left_*",   brightness = 0.8, color = {1, 1, 1}},
        {name = "demon_turn_right", material = "gls_turn_right_*", brightness = 0.8, color = {1, 1, 1}},
        {name = "demon_turn_left_r",  material = "ez_cars_left_r_*",   brightness = 0.8, color = {1, 0.5, 0}},
        {name = "demon_turn_right_r", material = "ez_cars_right_r_*", brightness = 0.8, color = {1, 0.5, 0}},
    }
}


-- BMW M5 F90 Kaifuy Cars
CustomLights[421] = {
    init = function (anim)
        anim.turnLightsInterval = 0.4
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("cs_left", 1, 0.5, 0)
                anim.setLightColor("e63_left", 1, 0.5, 0)
            end
            anim.setLightState("cs_left", state)
            anim.setLightState("e63_left", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("cs_right", 1, 0.5, 0)
                anim.setLightColor("e63_right", 1, 0.5, 0)
            end
            anim.setLightState("cs_right", state)
            anim.setLightState("e63_right", state)
        end,
        ["front"] = function (anim, state)
            -- Ð•ÑÐ»Ð¸ Ð²ÐºÐ»ÑŽÑ‡ÐµÐ½ Ð¿Ð¾Ð²Ð¾Ñ€Ð¾Ñ‚Ð½Ð¸Ðº, ÑÐ¾ÑÑ‚Ð¾ÑÐ½Ð¸Ðµ Ð½Ðµ Ð¾Ð±Ð½Ð¾Ð²Ð»ÑÐµÑ‚ÑÑ
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("cs_left", 1, 1, 0)
                    anim.setLightColor("e63_left", 1, 1, 1)

                    anim.setLightColor("cs_head", 1, 1, 0)
                    anim.setLightColor("e63_head", 1, 1, 1)
                    anim.setLightColor("def_head", 1, 1, 1)
                end
                anim.setLightState("cs_left", state)
                anim.setLightState("e63_left", state)

                anim.setLightState("cs_head", state)
                anim.setLightState("def_head", state)
                anim.setLightState("e63_head", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("cs_right", 1, 1, 0)
                    anim.setLightColor("e63_right", 1, 1, 1)

                    anim.setLightColor("cs_head", 1, 1, 0)
                    anim.setLightColor("e63_head", 1, 1, 1)
                    anim.setLightColor("def_head", 1, 1, 1)
                end
                anim.setLightState("cs_right", state)
                anim.setLightState("e63_right", state)

                anim.setLightState("cs_head", state)
                anim.setLightState("def_head", state)
                anim.setLightState("e63_head", state)
            end
            if state then
                if not anim.getLightState("brake") then
                    anim.setLightColor("e63_tail", 0.35, 0, 0)
                    anim.setLightState("e63_tail", state)
                end
            else
                if not anim.getLightState("brake") then
                    anim.setLightState("e63_tail", state)
                end
            end
        end,
        ["brake"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("e63_tail", 0.35, 0, 0)
            else
                anim.setLightColor("e63_tail", 0.55, 0.15, 0)
                anim.setLightState("e63_tail", state)
            end
        end
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("cs_left", 1, 1, 0)
                anim.setLightState("cs_left", true)
                anim.setLightColor("e63_left", 1, 1, 1)
                anim.setLightState("e63_left", true)

                anim.setLightColor("cs_head", 1, 1, 0)
                anim.setLightState("cs_head", true)
                anim.setLightColor("def_head", 1, 1, 1)
                anim.setLightState("def_head", true)
                anim.setLightColor("e63_head", 1, 1, 1)
                anim.setLightState("e63_head", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("cs_right", 1, 1, 0)
                anim.setLightState("cs_right", true)
                anim.setLightColor("e63_right", 1, 1, 1)
                anim.setLightState("e63_right", true)

                anim.setLightColor("cs_head", 1, 1, 0)
                anim.setLightState("cs_head", true)
                anim.setLightColor("def_head", 1, 1, 1)
                anim.setLightState("def_head", true)
                anim.setLightColor("e63_head", 1, 1, 1)
                anim.setLightState("e63_head", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("cs_left", 1, 1, 0)
                anim.setLightState("cs_left", true)
                anim.setLightColor("cs_right", 1, 1, 0)
                anim.setLightState("cs_right", true)

                anim.setLightColor("e63_left", 1, 1, 1)
                anim.setLightState("e63_left", true)
                anim.setLightColor("e63_right", 1, 1, 1)
                anim.setLightState("e63_right", true)

                anim.setLightColor("cs_head", 1, 1, 0)
                anim.setLightState("cs_head", true)
                anim.setLightColor("def_head", 1, 1, 1)
                anim.setLightState("def_head", true)
                anim.setLightColor("e63_head", 1, 1, 1)
                anim.setLightState("e63_head", true)
            end
        end
    },

    lights = {

        {name = "e63_left",  material = "f90_turn_left_0" , colorMul = 1.5 },
        {name = "e63_right", material = "f90_turn_right_0", colorMul = 1.5 },


        {name = "e63_head",  material = "f90_head_lights_0" , colorMul = 1.5 },
        {name = "cs_head", material = "f90_head_lights_1", colorMul = 1.5 },
        {name = "def_head", material = "f90_head_lights_2", colorMul = 1.5 },



        {name = "cs_left",  material = "f90_turn_left_1" , colorMul = 1.5 },
        {name = "cs_right", material = "f90_turn_right_1", colorMul = 1.5 },
        {name = "e63_tail",      material = "e63_tail" },
    }
}


CustomLights[412] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 1.3

            local timeFront2 = 0.5

            local maxColor = 1

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, maxColor * progress)

                anim.setLightColor("s650_turn_right", 0, 0, maxColor * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s650_turn_left", maxColor * progress, maxColor * progress, maxColor)

                anim.setLightColor("s650_turn_right", maxColor * progress, maxColor * progress, maxColor)

            end



            local timeLine = 0.22

            local timePause = 0.1

            local timeBrightnessPause = 0.3

            local timeBrightness = 1



            local colorStart = 0.4

            if currentTime < timeLine then

                local progress = currentTime * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then

                local progress = (currentTime - timeLine - timePause) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 3

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then

                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 6

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness

                for i = 1, 9 do

                    anim.setLightState("s650_brake"..i, true)

                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)

                end

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, false)

            end

            anim.setLightState("s650_turn_left", false)

            anim.setLightState("s650_turn_right", false)

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, true)

                anim.setLightColor("s650_brake"..i, 1, 0, 0)

            end

            anim.stopSpecialAnimation()

        end

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("s650_turn_left", 1, 1, 1)

                end

                anim.setLightState("s650_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("s650_turn_right", 1, 1, 1)

                end

                anim.setLightState("s650_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            else

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            end

        end,

        ["brake"] = function (anim, state)

            if anim.specialAnimActive then

                return

            end

            if not state and anim.getLightState("front") then

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                end

            else

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 1, 0, 0)

                    anim.setLightState("s650_brake"..i, state)

                end

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end

    },



    lights = {

        {name = "s650_turn_left",  material = "c63_head_left*"  },

        {name = "s650_turn_right", material = "c63_head_right*" },

        {name = "s650_brake1",     material = "shader_c63_1" },

        {name = "s650_brake2",     material = "s650_brake_1" },

        {name = "s650_brake3",     material = "s650_brake_2" },

        {name = "s650_brake4",     material = "s650_brake_3" },

        {name = "s650_brake5",     material = "s650_brake_4" },

        {name = "s650_brake6",     material = "s650_brake_5" },

        {name = "s650_brake7",     material = "s650_brake_6" },

        {name = "s650_brake8",     material = "s650_brake_7" },

        {name = "s650_brake9",     material = "s650_brake_8" },

    }

}

--LC300
CustomLights[492] = {
    init = function (anim)
        anim.turnLightsInterval = 0.35
    end,

    stateHandlers = {
        ["turn_left"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_left_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_left_1", state)
        end,
        ["turn_right"] = function (anim, state)
            if state then
                anim.setLightColor("shader_turn_right_1", 1, 0.6, 0)
            end
            anim.setLightState("shader_turn_right_1", state)
        end,
        ["front"] = function (anim, state)
            -- Если включен поворотник, состояние не обновляется
            if not anim.getLightState("turn_left") then
                if state then
                    anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_left_1", state)
            end
            if not anim.getLightState("turn_right") then
                if state then
                    anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                end
                anim.setLightState("shader_turn_right_1", state)
            end
        end,
    },

    dataHandlers = {
        ["turn_left"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
            end
        end,
        ["turn_right"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                anim.setLightColor("shader_turn_left_1", 255, 255, 255)
                anim.setLightState("shader_turn_left_1", true)
                anim.setLightColor("shader_turn_right_1", 255, 255, 255)
                anim.setLightState("shader_turn_right_1", true)
            end
        end
    },

    lights = {
        {name = "shader_turn_left_1",  material = "shader_turn_left_1" , colorMul = 1.6 },
        {name = "shader_turn_right_1", material = "shader_turn_right_1", colorMul = 1.6 },
    }
}

CustomLights[559] = {
    stateHandlers = {
        ["front"] = function (anim, state)
            anim.setLightColor("lights_0", 1, 1, 1)
            anim.setLightColor("lights_1", 1, 1, 1)
            anim.setLightState("lights_0", state)
            anim.setLightState("lights_1", state)
        end,
    },

    lights = {
        {name = "lights_0",  material = "Supra_brake_1" , colorMul = 1 },
        {name = "lights_1",  material = "optik" , colorMul = 1 },
    }
}

CustomLights[508] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 2

            local timeFront2 = 2

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("gt63_turn_left", true)

                anim.setLightState("gt63_turn_right", true)

                anim.setLightColor("gt63_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("gt63_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("gt63_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("gt63_turn_right", 1 * progress, 1 * progress, 1)

            end



            local timeLine = 0.25

            local timePause = 0.15

            local timeBrightnessPause = 0.25

            local timeBrightness = 0.35



            local colorStart = 0.4

            if currentTime < timeLine then

                local progress = currentTime * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                anim.setLightState("gt63_anim"..index, true)

                anim.setLightColor("gt63_anim"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then

                local progress = (currentTime - timeLine - timePause) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 3

                anim.setLightState("gt63_anim"..index, true)

                anim.setLightColor("gt63_anim"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then

                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 6

                anim.setLightState("gt63_anim"..index, true)

                anim.setLightColor("gt63_anim"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness

                for i = 1, 7 do

                    anim.setLightState("gt63_anim"..i, true)

                    anim.setLightColor("gt63_anim"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)

                end

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

            for i = 1, 7 do

                anim.setLightState("gt63_anim"..i, false)

            end

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 1, 7 do

                anim.setLightState("gt63_anim"..i, true)

                anim.setLightColor("gt63_anim"..i, 1, 0, 0)

            end

            anim.stopSpecialAnimation()

        end

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("gt63_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("gt63_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("gt63_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("gt63_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("gt63_turn_left", 1, 1, 1)

                end

                anim.setLightState("gt63_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("gt63_turn_right", 1, 1, 1)

                end

                anim.setLightState("gt63_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    for i = 1, 7 do

                        anim.setLightColor("gt63_anim"..i, 0.55, 0, 0)

                        anim.setLightState("gt63_anim"..i, state)

                    end

                end

            else

                if not anim.getLightState("brake") then

                    for i = 1, 7 do

                        anim.setLightState("gt63_anim"..i, state)

                    end

                end

            end

        end,

        ["brake"] = function (anim, state)

            if anim.specialAnimActive then

                return

            end

            if not state and anim.getLightState("front") then

                for i = 1, 7 do

                    anim.setLightColor("gt63_anim"..i, 0.55, 0, 0)

                end

            else

                for i = 1, 7 do

                    anim.setLightColor("gt63_anim"..i, 1, 0.25, 0.25)

                    anim.setLightState("gt63_anim"..i, state)

                end

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("gt63_turn_left", 1, 1, 1)

                anim.setLightState("gt63_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("gt63_turn_right", 1, 1, 1)

                anim.setLightState("gt63_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("gt63_turn_left", 1, 1, 1)

                anim.setLightState("gt63_turn_left", true)

                anim.setLightColor("gt63_turn_right", 1, 1, 1)

                anim.setLightState("gt63_turn_right", true)

            end

        end

    },



    lights = {

        {name = "gt63_turn_left",  material = "gt63_turn_left_*"  },

        {name = "gt63_turn_right", material = "gt63_turn_right_*" },

        {name = "gt63_anim1",     material = "gt63_anim0" },

        {name = "gt63_anim2",     material = "gt63_anim1" },

        {name = "gt63_anim3",     material = "gt63_anim2" },

        {name = "gt63_anim4",     material = "gt63_anim3" },

        {name = "gt63_anim5",     material = "gt63_anim4" },

        {name = "gt63_anim6",     material = "gt63_anim5" },

        {name = "gt63_anim7",     material = "gt63_anim6" },

    }

}



-- Bugatti Divo

CustomLights[502] = {

    init = function (anim)

        anim.turnLightsInterval = 0.38

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("divo_turn_left_0", 1, 1, 0)

            end

            anim.setLightState("divo_turn_left_0", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("divo_turn_right_0", 1, 1, 0)

            end

            anim.setLightState("divo_turn_right_0", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("divo_turn_left_0", 1, 1, 1)

                end

                anim.setLightState("divo_turn_left_0", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("divo_turn_right_0", 1, 1, 1)

                end

                anim.setLightState("divo_turn_right_0", state)

            end

        end,

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("divo_turn_left_0", 1, 1, 1)

                anim.setLightState("divo_turn_left_0", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("divo_turn_right_0", 1, 1, 1)

                anim.setLightState("divo_turn_right_0", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("divo_turn_left_0", 1, 1, 1)

                anim.setLightState("divo_turn_left_0", true)

                anim.setLightColor("divo_turn_right_0", 1, 1, 1)

                anim.setLightState("divo_turn_right_0", true)

            end

        end

    },



    lights = {

        {name = "divo_turn_left_0",  material = "divo_turn_left_*" , colorMul = 1.3 },

        {name = "divo_turn_right_0", material = "divo_turn_right_*", colorMul = 1.3 },



    }

}



-- RS7 

CustomLights[438] = {   

    init = function (anim)

        anim.turnLightsInterval = 0.85

        -- Время, за которое загораются все блоки

    if FPS > FPSNornal then 

        anim.rearLightsTime = 0.35

    else 

        anim.rearLightsTime = 0.55

    end

        -- Время, после которого свет начинает плавно затухать

        anim.rearLightsFadeAfter = 0.35

    end,



    update = function (anim, deltaTime, vehicle)

        --print (anim.specialAnimActive)

        

        

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.turnLightsState then

            if anim.turnLightsTime < anim.rearLightsTime then

                -- Включение блоков по очереди

             --   local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0

                local index = math.floor(anim.turnLightsTime/ anim.rearLightsTime * 12)

                



                if anim.getLightState("turn_left") then

                   anim.setLightState("rs6r_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

                if anim.getLightState("turn_right") then

                   anim.setLightState("rs6r_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

                   anim.setLightState("rs6f_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 

      end

            elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

               if anim.getLightState("turn_left") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

                if anim.getLightState("turn_right") then

                    for i = 0, 12 do

                   anim.setLightColor("rs6r_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                   anim.setLightColor("rs6f_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

                    end

                end

            end

        end

        

        if anim.specialAnimActive then

            local currentTime = anim.specialAnimTime

            if anim.specialAnimData == "anim_on" or anim.specialAnimData == "enable" then

                 time0 = 0 -- Задержка старта анимации    

                 time2 = 0.5 -- Время прохождения "щелчка", после основной анимации на передних фарах

                 time4 = 1 -- ?             

                 timePause0 = 0.1

                 timePause01 = 0 -- Задержка старта анимации          

                 timePause = 0.03

                 timePause2 = 0.5



            if FPS > FPSNornal then 

                time1 = 0.2 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time0 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    local index = math.floor(currentTime/time0 * 12)

                    anim.setLightState("rs6f_turn_left_"..index, false)

                    anim.setLightColor("rs6f_turn_left_"..index, 1, 0.5, 0)

                    anim.setLightState("rs6f_turn_right_"..index, false)

                    anim.setLightColor("rs6f_turn_right_"..index, 1, 0.5, 0)

                elseif currentTime > time0 + timePause0 and currentTime < time0 + timePause0 + timePause01 then

                    anim.setLightState("turn_left", false)

                    anim.setLightState("turn_right", false)

                    

                    for i = 0, 11 do

                        anim.setLightColor("rs6f_turn_left_"..i, 0, 0, 0)

                        anim.setLightColor("rs6f_turn_right_"..i, 0, 0, 0)

                    end

                elseif currentTime > time0 + timePause0 + timePause01 then

                    currentTime = currentTime - (time0 + timePause0 + timePause01)

                    for i = 0, 12 do

                        if currentTime > time1*i and currentTime < time1*(i+1) + timePause*i then

                            --local progress = (currentTime-time1*i-timePause*i) * 12 / time1

                            local progress = (currentTime-time1*i-timePause*i) / time1 * 13

                            local index = math.ceil(progress) - 1

                            local index2 = 12 + i - index

                            

                            anim.setLightState("rs6f_turn_left_"..index2, true)

                            anim.setLightColor("rs6f_turn_left_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_left_"..index2 + 1, false)

                            

                            anim.setLightState("rs6f_turn_right_"..index2, true)

                            anim.setLightColor("rs6f_turn_right_"..index2, 1, 1, 1)

                            anim.setLightState("rs6f_turn_right_"..index2 + 1, false)

                        elseif currentTime > time1*12 + timePause*12 + timePause2 then

                            for i = 0, 12 do

                                local currentTime2 = currentTime - time1*12 - timePause*12 - timePause2

                                if currentTime2 > time2*i and currentTime2 < time2*(i+1) + timePause*i then

                                    local progress = (currentTime2-time2*i-timePause*i) * 12 / time2

                                    local index = math.ceil(progress)

                                    local index2 = index

                                    progress = progress - index

                                    anim.setLightColor("rs6f_turn_left_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_left_"..index2-1, 1, 1, 1)

                                    

                                    anim.setLightColor("rs6f_turn_right_"..index2, 0.2, 0.2, 0.2)

                                    anim.setLightColor("rs6f_turn_right_"..index2 - 1, 1, 1, 1)

                                    if index2 >= 12 then

                                        for i = 0, 12 do

                                            anim.setLightState("rs6f_turn_left_"..i, true)

                                            anim.setLightState("rs6f_turn_right_"..i, true)

                                            anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                                            anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                                        end

                                        anim.stopSpecialAnimation()

                                    end

                                end

                            end

                        end

                    end

                    

                    for i = 0, 9 do

                        if currentTime > time3*i and currentTime < time3*(i+1) + timePause*i then

                            local progress = (currentTime-time3*i - timePause*i) / time3 * 8

                            local index = math.ceil(progress)

                            local index2 = 9 + i - index

                            --[[if i < 1 then

                                print (i, index, index2)

                            end]]

                            

                            if index2 >= 0 then

                                if index2 < 10 then

                                    anim.setLightState("rs6_brake_"..index2, true)

                                    anim.setLightColor("rs6_brake_"..index2, 1, 0, 0)

                                    if index2 + 1 ~= 10 then

                                        anim.setLightState("rs6_brake_"..index2 + 1, false)

                                    end

                                end

                            end

                        end

                    end

                    

                    local progress = getEasingValue (currentTime/(time3*10 + timePause*9), "InQuad")

                    if progress <= 1 then

                      --  print (currentTime, progress)

                        anim.setLightState("rs6_brake_10", true)

                        anim.setLightColor("rs6_brake_10", 1*progress, 0, 0)

                    end

                end

                elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

                local time2 = 0.9 -- ? 

                local timePause = 0.9



            if FPS > FPSNornal then 

                time1 = 0.6 -- Скорость включения передней оптики при нормальном FPS

                time3 = 0.2 -- Скорость включения задней оптики при нормальном FPS

            else

                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")

                time1 = 0.6 -- Скорость включения передней оптики при низком FPS

                time3 = 0.6 -- Скорость включения задней оптики при низком FPS

            end

                

                if currentTime < time1 then

                    local progress = currentTime * 12 / time1

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    local color = 0.1 * progress

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 and currentTime < time1 + time2 then

                    local progress = (currentTime - time1) * 12 / time2

                    local index = math.ceil(progress) - 1

                    progress = progress - index + 1

                    index = 11 - index

                    local color = 1 - 0.65 * progress

                    --anim.setLightState("rs6f_turn_left_"..index, )

                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)

                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)

                elseif currentTime > time1 + time2 + timePause then

                    for i = 0, 11 do

                        anim.setLightState("rs6f_turn_left_"..i, false)

                        anim.setLightState("rs6f_turn_right_"..i, false)

                        anim.stopSpecialAnimation()

                    end  

                end

                

                if currentTime < time3 then

                    local progress = currentTime * 9 / time3

                    local index = math.ceil(progress)

                    progress = progress - index + 1

                    anim.setLightState("rs6_brake_"..(10 - index), false)

                end

                

                local progress = getEasingValue (currentTime/time3, "InQuad")

                --print (progress)

                if progress <= 1 then

                    anim.setLightState("rs6_brake_10", true)

                    anim.setLightColor("rs6_brake_10", 1 - 1*progress, 0, 0)

                end

            end

        end

    end,

    

   stateHandlers = {

        ["turn_left"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_left_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_left_" ..i, false)

          anim.setLightState("rs6f_turn_left_" ..i, false)

        end

            end

        end,

        ["turn_right"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("rs6r_turn_right_" ..i, 1, 0.3, 0)

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("rs6r_turn_right_" ..i, false)

          anim.setLightState("rs6f_turn_right_" ..i, false)

        end

            end

        end,

        ["front"] = function (anim, state, veh)

            if state then

                anim.startSpecialAnimation(veh, "anim_on")

            else

                anim.startSpecialAnimation(veh, "anim_off")

            end

        end,

    },



    dataHandlers = {

        ["turn_left"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_left_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_left_" ..i, true)

        end

      end

    end,

    ["turn_right"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("rs6f_turn_right_" ..i, 1, 1, 1)

          anim.setLightState("rs6f_turn_right_" ..i, true)

        end

      end

    end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                for i = 0, 12 do

                    anim.setLightState("rs6f_turn_left_"..i, true)

                    anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)

                    anim.setLightState("rs6f_turn_right_"..i, true)

                    anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)

                end

            end

        end

    },



    lights = {

        {name = "rs6f_turn_left_0",  material = "rs6f_turn_left_0" , colorMul = 1.6 },

        {name = "rs6f_turn_left_1",  material = "rs6f_turn_left_1" , colorMul = 1.6 },

        {name = "rs6f_turn_left_2",  material = "rs6f_turn_left_2" , colorMul = 1.6 },

        {name = "rs6f_turn_left_3",  material = "rs6f_turn_left_3" , colorMul = 1.6 },

        {name = "rs6f_turn_left_4",  material = "rs6f_turn_left_4" , colorMul = 1.6 },

        {name = "rs6f_turn_left_5",  material = "rs6f_turn_left_5" , colorMul = 1.6 },

        {name = "rs6f_turn_left_6",  material = "rs6f_turn_left_6" , colorMul = 1.6 },

        {name = "rs6f_turn_left_7",  material = "rs6f_turn_left_7" , colorMul = 1.6 },

        {name = "rs6f_turn_left_8",  material = "rs6f_turn_left_8" , colorMul = 1.6 },

        {name = "rs6f_turn_left_9",  material = "rs6f_turn_left_9" , colorMul = 1.6 },

        {name = "rs6f_turn_left_10",  material = "rs6f_turn_left_10" , colorMul = 1.6 },

        {name = "rs6f_turn_left_11",  material = "rs6f_turn_left_11" , colorMul = 1.6 },

        

        {name = "rs6f_turn_right_0", material = "rs6f_turn_right_0", colorMul = 1.6 },

        {name = "rs6f_turn_right_1",  material = "rs6f_turn_right_1" , colorMul = 1.6 },

        {name = "rs6f_turn_right_2",  material = "rs6f_turn_right_2" , colorMul = 1.6 },

        {name = "rs6f_turn_right_3",  material = "rs6f_turn_right_3" , colorMul = 1.6 },

        {name = "rs6f_turn_right_4",  material = "rs6f_turn_right_4" , colorMul = 1.6 },

        {name = "rs6f_turn_right_5",  material = "rs6f_turn_right_5" , colorMul = 1.6 },

        {name = "rs6f_turn_right_6",  material = "rs6f_turn_right_6" , colorMul = 1.6 },

        {name = "rs6f_turn_right_7",  material = "rs6f_turn_right_7" , colorMul = 1.6 },

        {name = "rs6f_turn_right_8",  material = "rs6f_turn_right_8" , colorMul = 1.6 },

        {name = "rs6f_turn_right_9",  material = "rs6f_turn_right_9" , colorMul = 1.6 },

        {name = "rs6f_turn_right_10",  material = "rs6f_turn_right_10" , colorMul = 1.6 },

        {name = "rs6f_turn_right_11",  material = "rs6f_turn_right_11" , colorMul = 1.6 },



        {name = "rs6r_turn_left_0", material = "rs6r_turn_left_0",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_1", material = "rs6r_turn_left_1",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_2", material = "rs6r_turn_left_2",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_3", material = "rs6r_turn_left_3",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_left_4", material = "rs6r_turn_left_4",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_0", material = "rs6r_turn_right_0", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_1", material = "rs6r_turn_right_1", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_2", material = "rs6r_turn_right_2", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_3", material = "rs6r_turn_right_3", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "rs6r_turn_right_4", material = "rs6r_turn_right_4", brightness = 0.5, color = {1, 0.1, 0}},        

        

        {name = "rs6_brake_1", material = "rs6_brake_0" },

        {name = "rs6_brake_2", material = "rs6_brake_1" },

        {name = "rs6_brake_3", material = "rs6_brake_2" },

        {name = "rs6_brake_4", material = "rs6_brake_3" },

        {name = "rs6_brake_5", material = "rs6_brake_4" },

        {name = "rs6_brake_6", material = "rs6_brake_5" },

        {name = "rs6_brake_7", material = "rs6_brake_6" },

        {name = "rs6_brake_8", material = "rs6_brake_7" },

        {name = "rs6_brake_9", material = "rs6_brake_8" },

        {name = "rs6_brake_10", material = "rs6_brake_9" },

    }

}



-- колян

CustomLights[400] = {

    init = function (anim)

        anim.turnLightsInterval = 0.5

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("rr_turn_left", 1, 0.35, 0)

            end

            anim.setLightState("rr_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("rr_turn_right", 1, 0.35, 0)

            end

            anim.setLightState("rr_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("rr_turn_left", 1, 1, 1)

                end

                anim.setLightState("rr_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("rr_turn_right", 1, 1, 1)

                end

                anim.setLightState("rr_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    anim.setLightColor("rr_brake", 0.67, 0, 0)

                    anim.setLightState("rr_brake", state)

                end

            else

                if not anim.getLightState("brake") then

                    anim.setLightState("rr_brake", state)

                end

            end

        end,

        ["brake"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_brake", 0.67, 0, 0)

            else

                anim.setLightColor("rr_brake", 1, 0.2, 0.2)

                anim.setLightState("rr_brake", state)

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_turn_left", 1, 1, 1)

                anim.setLightState("rr_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_turn_right", 1, 1, 1)

                anim.setLightState("rr_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_turn_left", 1, 1, 1)

                anim.setLightState("rr_turn_left", true)

                anim.setLightColor("rr_turn_right", 1, 1, 1)

                anim.setLightState("rr_turn_right", true)

            end

        end

    },



    lights = {

        {name = "rr_turn_left",  material = "rr_turn_left_*" , colorMul = 1.5 },

        {name = "rr_turn_right", material = "rr_turn_right_*", colorMul = 1.5 },

        {name = "rr_brake",      material = "rr_brake_*" },		

    }

}

-- Toyota Land Cruiser 100

CustomLights[666] = {

	    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 0.4

            local timeFront2 = 0.4

			local timeFront3 = 0.8

            local timeFront4 = 0.5

			

			if currentTime < timeFront1 then

				anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

				anim.setLightState("turn_left", true)

                anim.setLightState("turn_right", true)

				anim.setLightColor("s650_turn_left", 1, 0.5, 0)

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

			elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

				anim.setLightState("s650_turn_left", false)

                anim.setLightState("s650_turn_right", false)

				anim.setLightState("turn_left", false)

                anim.setLightState("turn_right", false)

				anim.setLightColor("s650_turn_left", 0, 0, 0)

                anim.setLightColor("s650_turn_right", 0, 0, 0)

			elseif currentTime > timeFront1 + timeFront2 and currentTime < timeFront1 + timeFront2 + timeFront3 then

				local progress = getEasingValue(currentTime / (timeFront1 + timeFront2 + timeFront3), "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

			elseif currentTime > timeFront1 + timeFront2 + timeFront3 and currentTime < timeFront1 + timeFront2 + timeFront3 + timeFront4 then

				local progress = (currentTime - timeFront1 - timeFront2 - timeFront3) / timeFront4

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

			elseif currentTime > timeFront1 + timeFront2 + timeFront3 + timeFront4 then

				anim.stopSpecialAnimation()

            end

			

            --[[if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

			elseif currentTime > timeFront1 + timeFront2 then

				anim.stopSpecialAnimation()

            end]]

        end

    end,

    stateHandlers = {

    		["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_left", 1, 0.5, 0)

               -- anim.setLightColor("nlightsf", 1, 1, 1)	

            end

            anim.setLightState("s650_turn_left", state)

           -- anim.setLightState("nlightsf", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

           -- 	anim.setLightColor("nlightsf", 1, 1, 1)	

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_right", state)

         --    anim.setLightState("nlightsf", state)

        end,	

        ["front"] = function (anim, state)

            if not anim.getLightState("turn_left") then

                if state then

                --	anim.setLightColor("nlightsf", 0, 0, 0)	

                	anim.setLightColor("s650_turn_left", 0, 0, 0)					

                end

                anim.setLightState("s650_turn_left", state)

          --      anim.setLightState("nlightsf", state)		

            end

            if state then

                if not anim.getLightState("brake") then

                    anim.setLightColor("shader_tail_0", 2.23, 0, 0)

                    anim.setLightState("shader_tail_0", state)

                end

            else

            	 if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("s650_turn_right", 0, 0, 0)

                    anim.setLightColor("nlightsf", 0, 0, 0)	

                end

				anim.setLightState("s650_turn_right", state)

				anim.setLightState("nlightsf", state)

            end

                if not anim.getLightState("brake") then

                    anim.setLightState("shader_tail_0", state)

                end

            end

        end,

        ["brake"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("shader_tail_0", 2.23, 0, 0)

            else

                anim.setLightColor("shader_tail_0", 3.65, 0, 0)

                anim.setLightState("shader_tail_0", state)

            end

        end

    },



    lights = {

    	{name = "s650_turn_left",  material = "f_led2"  },

        {name = "s650_turn_right", material = "f_led" },

        {name = "nlightsf",      material = "nlightsf" },

        {name = "shader_tail_0",      material = "r_led" },	

    }

}



CustomLights[554] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 0.4

            local timeFront2 = 0.4

			local timeFront3 = 0.8

            local timeFront4 = 0.5

			

			if currentTime < timeFront1 then

				anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

				anim.setLightState("turn_left", true)

                anim.setLightState("turn_right", true)

				anim.setLightColor("s650_turn_left", 1, 0.5, 0)

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

			elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

				anim.setLightState("s650_turn_left", false)

                anim.setLightState("s650_turn_right", false)

				anim.setLightState("turn_left", false)

                anim.setLightState("turn_right", false)

				anim.setLightColor("s650_turn_left", 0, 0, 0)

                anim.setLightColor("s650_turn_right", 0, 0, 0)

			elseif currentTime > timeFront1 + timeFront2 and currentTime < timeFront1 + timeFront2 + timeFront3 then

				local progress = getEasingValue(currentTime / (timeFront1 + timeFront2 + timeFront3), "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

			elseif currentTime > timeFront1 + timeFront2 + timeFront3 and currentTime < timeFront1 + timeFront2 + timeFront3 + timeFront4 then

				local progress = (currentTime - timeFront1 - timeFront2 - timeFront3) / timeFront4

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

			elseif currentTime > timeFront1 + timeFront2 + timeFront3 + timeFront4 then

				anim.stopSpecialAnimation()

            end

			

            --[[if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

			elseif currentTime > timeFront1 + timeFront2 then

				anim.stopSpecialAnimation()

            end]]

        end

    end,



    stateHandlers = {

		["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("s650_turn_left", 0, 0, 0)

                end

                anim.setLightState("s650_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("s650_turn_right", 0, 0, 0)

                end

				anim.setLightState("s650_turn_right", state)

            end

			if state then

				anim.startSpecialAnimation(veh, "anim_on")

			else

				anim.startSpecialAnimation(veh, "anim_off")

			end

        end,

    },

	

	dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end

    },





    lights = {

        {name = "s650_turn_left",  material = "f_led2"  },

        {name = "s650_turn_right", material = "f_led" },

    }

}

CustomLights[585] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- Ð’ anim.specialAnimData Ð¿ÐµÑ€ÐµÐ´Ð°Ñ‘Ñ‚ÑÑ true/false

        -- true - Ð²ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¸Ðµ Ñ„Ð°Ñ€

        -- false - Ð²Ñ‹ÐºÐ»ÑŽÑ‡ÐµÐ½Ð¸Ðµ

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 1.3

            local timeFront2 = 0.5

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s650_turn_left", true)

                anim.setLightState("s650_turn_right", true)

                anim.setLightColor("s650_turn_left", 0, 0, 1 * progress)

                anim.setLightColor("s650_turn_right", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s650_turn_left", 1 * progress, 1 * progress, 1)

                anim.setLightColor("s650_turn_right", 1 * progress, 1 * progress, 1)

            end



            local timeLine = 0.22

            local timePause = 0.1

            local timeBrightnessPause = 0.3

            local timeBrightness = 1



            local colorStart = 0.4

            if currentTime < timeLine then

                local progress = currentTime * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine + timePause and currentTime < timeLine*2 + timePause then

                local progress = (currentTime - timeLine - timePause) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 3

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*2 + timePause*2 and currentTime < timeLine*3 + timePause*3 then

                local progress = (currentTime - timeLine*2 - timePause*2) * 3 / timeLine

                local index = math.ceil(progress)

                progress = progress - index + 1

                index = index + 6

                anim.setLightState("s650_brake"..index, true)

                anim.setLightColor("s650_brake"..index, colorStart * progress, 0, progress * 0.2)

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause and currentTime < timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                local progress = (currentTime - timeLine*3 - timePause*2 - timeBrightnessPause) / timeBrightness

                for i = 1, 9 do

                    anim.setLightState("s650_brake"..i, true)

                    anim.setLightColor("s650_brake"..i, colorStart + (1-colorStart) * progress, 0, (1-progress) * 0.2)

                end

            elseif currentTime > timeLine*3 + timePause*2 + timeBrightnessPause + timeBrightness then

                anim.stopSpecialAnimation()

            end

        elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, false)

            end

            anim.stopSpecialAnimation()

        elseif anim.specialAnimData == "enable" then

            for i = 1, 9 do

                anim.setLightState("s650_brake"..i, true)

                anim.setLightColor("s650_brake"..i, 1, 0, 0)

            end

            anim.stopSpecialAnimation()

        end

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("s650_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("s650_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Ð•ÑÐ»Ð¸ Ð²ÐºÐ»ÑŽÑ‡ÐµÐ½ Ð¿Ð¾Ð²Ð¾Ñ€Ð¾Ñ‚Ð½Ð¸Ðº, ÑÐ¾ÑÑ‚Ð¾ÑÐ½Ð¸Ðµ Ð½Ðµ Ð¾Ð±Ð½Ð¾Ð²Ð»ÑÐµÑ‚ÑÑ

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("s650_turn_left", 1, 1, 1)

                end

                anim.setLightState("s650_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("s650_turn_right", 1, 1, 1)

                end

                anim.setLightState("s650_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            else

                if not anim.getLightState("brake") then

                    for i = 1, 9 do

                        anim.setLightState("s650_brake"..i, state)

                    end

                end

            end

        end,

        ["brake"] = function (anim, state)

            if anim.specialAnimActive then

                return

            end

            if not state and anim.getLightState("front") then

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 0.55, 0, 0)

                end

            else

                for i = 1, 9 do

                    anim.setLightColor("s650_brake"..i, 1, 0.25, 0.25)

                    anim.setLightState("s650_brake"..i, state)

                end

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("s650_turn_left", 1, 1, 1)

                anim.setLightState("s650_turn_left", true)

                anim.setLightColor("s650_turn_right", 1, 1, 1)

                anim.setLightState("s650_turn_right", true)

            end

        end

    },



    lights = {

        {name = "s650_turn_left",  material = "s650_turn_left_*"  },

        {name = "s650_turn_right", material = "s650_turn_right_*" },

        {name = "s650_brake1",     material = "s650_brake_0" },

        {name = "s650_brake2",     material = "s650_brake_1" },

        {name = "s650_brake3",     material = "s650_brake_2" },

        {name = "s650_brake4",     material = "s650_brake_3" },

        {name = "s650_brake5",     material = "s650_brake_4" },

        {name = "s650_brake6",     material = "s650_brake_5" },

        {name = "s650_brake7",     material = "s650_brake_6" },

        {name = "s650_brake8",     material = "s650_brake_7" },

        {name = "s650_brake9",     material = "s650_brake_8" },

    }

}




CustomLights[503] = {

    update = function (anim, deltaTime, vehicle)

        if not anim.specialAnimActive then

            return

        end

        local currentTime = anim.specialAnimTime

        -- В anim.specialAnimData передаётся true/false

        -- true - включение фар

        -- false - выключение

        if anim.specialAnimData == "anim_on" then

            local timeFront1 = 1

            local timeFront2 = 0.5

            if currentTime < timeFront1 then

                local progress = getEasingValue(currentTime / timeFront1, "InQuad")

                anim.setLightState("s63coupe_lights", true)

                anim.setLightColor("s63coupe_lights", 0, 0, 1 * progress)

            elseif currentTime > timeFront1 and currentTime < timeFront1 + timeFront2 then

                local progress = (currentTime - timeFront1) / timeFront2

                anim.setLightColor("s63coupe_lights", 1 * progress, 1 * progress, 1)

			elseif currentTime > timeFront1 + timeFront2 then

				anim.stopSpecialAnimation()

            end

		elseif anim.specialAnimData == "anim_off" then

			anim.setLightColor("s63coupe_lights", 0, 0, 0)

			anim.setLightState("s63coupe_lights", false)

        end

    end,



    stateHandlers = {

        ["front"] = function (anim, state)

			if state then

				anim.setLightColor("s63coupe_lights", 0, 0, 0)

				anim.startSpecialAnimation(veh, "anim_on")

			else

				anim.startSpecialAnimation(veh, "anim_off")

			end

        end,

    },





    lights = {

        {name = "s63coupe_lights",  material = "lights_0"},

    }

}



-- Supra

CustomLights[502] = {

  init = function(anim)

    anim.turnLightsInterval = 0.67

	-- Время, за которое загораются все блоки

    anim.rearLightsTime = 0.35

	-- Время, после которого свет начинает плавно затухать

    anim.rearLightsFadeAfter = 0.3

  end,

  -- Задние + Переднии поворотники

  update = function(anim)

    if not anim.turnLightsState then

      return

    end

    if anim.turnLightsTime < anim.rearLightsTime then

      if anim.getLightState("turn_left") then

        anim.setLightState("supra_turn_left_rear_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true)

        anim.setLightState("supra_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true)

      end

      if anim.getLightState("turn_right") then

        anim.setLightState("supra_turn_right_rear_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true)

        anim.setLightState("supra_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true)

      end

    elseif anim.turnLightsTime > anim.rearLightsFadeAfter then

      if anim.getLightState("turn_left") then

        for i = 0, 12 do

          anim.setLightColor("supra_turn_left_rear_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

          anim.setLightColor("supra_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

        end

      end

      if anim.getLightState("turn_right") then

        for i = 0, 12 do

          anim.setLightColor("supra_turn_right_rear_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

          anim.setLightColor("supra_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)

        end

      end

    end

  end,

  stateHandlers = {

    ["turn_left"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("supra_turn_left_rear_" ..i, 1, 0.3, 0)

          anim.setLightColor("supra_turn_left_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("supra_turn_left_rear_" ..i, false)

          anim.setLightState("supra_turn_left_" ..i, false)

		  -------------------------------------------------

		  anim.setLightState("rs6r_white_left_0", false)

          anim.setLightState("rs6r_white_left_0", false)

        end

      end

    end,

    ["turn_right"] = function(anim, state)

      for i = 0, 12 do

        if state then

          anim.setLightColor("supra_turn_right_rear_" ..i, 1, 0.3, 0)

          anim.setLightColor("supra_turn_right_" ..i, 1, 0.3, 0)

        else

          anim.setLightState("supra_turn_right_rear_" ..i, false)

          anim.setLightState("supra_turn_right_" ..i, false)

		  --------------------------------------------------

		  anim.setLightState("rs6r_white_right_0", false)

          anim.setLightState("rs6r_white_right_0", false)

        end

      end

    end,

	

	["rear"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("RS7_turn_left_0", 1, 1, 1)

					anim.setLightColor("RS7_turn_left_1", 1, 1, 1)

                end

                anim.setLightState("RS7_turn_left_0", state)

				anim.setLightState("RS7_turn_left_1", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("RS7_turn_right_0", 1, 1, 1)

					anim.setLightColor("RS7_turn_right_1", 1, 1, 1)

                end

                anim.setLightState("RS7_turn_right_0", state)

				anim.setLightState("RS7_turn_right_1", state)

            end

	   end,

	   

    ["front"] = function(anim, state)

      if not anim.getLightState("turn_left") then

        for i = 0, 12 do

          if state then

            anim.setLightColor("supra_turn_left_" ..i, 1, 1, 1)

		    anim.setLightColor("rs6r_white_left_0", 2, 2, 2)

		  end

          anim.setLightState("supra_turn_left_" ..i, state)

		  anim.setLightState("rs6r_white_left_0", state)

        end

      end

      if not anim.getLightState("turn_right") then

        for i = 0, 12 do

          if state then

            anim.setLightColor("supra_turn_right_" ..i, 1, 1, 1)

		    anim.setLightColor("rs6r_white_right_0", 2, 2, 2)

		  end

          anim.setLightState("supra_turn_right_" ..i, state)

		  anim.setLightState("rs6r_white_right_0", state)

        end

	end

      if state then

                if not anim.getLightState("brake") then

                    anim.setLightColor("brake_rs6", 0.55, 0, 0)

                    anim.setLightState("brake_rs6", state)

                end

            else

                if not anim.getLightState("brake") then

                    anim.setLightState("brake_rs6", state)

					

                end

            end

        end

  },

  dataHandlers = {

    ["turn_left"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("supra_turn_left_" ..i, 1, 1, 1)

          anim.setLightState("supra_turn_left_" ..i, true)

        end

      end

    end,

    ["turn_right"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("supra_turn_right_" ..i, 1, 1, 1)

          anim.setLightState("supra_turn_right_" ..i, true)

        end

      end

    end,

    ["emergency_light"] = function(anim, state)

      if not state and anim.getLightState("front") then

        for i = 0, 12 do

          anim.setLightColor("supra_turn_left_" ..i, 1, 1, 1)

          anim.setLightState("supra_turn_left_" ..i, true)

          anim.setLightColor("supra_turn_right_" ..i, 1, 1, 1)

          anim.setLightState("supra_turn_right_" ..i, true)

--------------------------------------------------------------------

		  anim.setLightColor("rs6r_white_left_0", 2, 2, 2)

		  anim.setLightState("rs6r_white_left_0", true)

		  anim.setLightColor("rs6r_white_right_0", 2, 2, 2)

		  anim.setLightState("rs6r_white_right_0", true)

        end

      end

    end

  },

    lights = {

		

	    {name = "supra_turn_left_0", material = "supra_turn_left_0",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_left_1", material = "supra_turn_left_1",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_left_2", material = "supra_turn_left_2",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_left_3", material = "supra_turn_left_3",   brightness = 0.5, color = {1, 0.1, 0}},

		{name = "supra_turn_left_4", material = "supra_turn_left_4",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_right_0", material = "supra_turn_right_0", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_right_1", material = "supra_turn_right_1", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_right_2", material = "supra_turn_right_2", brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_right_3", material = "supra_turn_right_3", brightness = 0.5, color = {1, 0.1, 0}},

		{name = "supra_turn_right_4", material = "supra_turn_right_4", brightness = 0.5, color = {1, 0.1, 0}},

		

        {name = "supra_turn_left_rear_0", material = "supra_turn_left_rear_0",   brightness = 0.5, color = {1, 0.1, 0}},

        {name = "supra_turn_right_rear_0", material = "supra_turn_right_rear_0", brightness = 0.5, color = {1, 0.1, 0}},

    }

}

-- M8

CustomLights[535] = {

    init = function (anim)

        anim.turnLightsInterval = 0.59 -- время интервала аварийки/поворотников

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("bmw_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("bmw_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("bmw_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("bmw_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("bmw_turn_left", 1, 1, 1)

                end

                anim.setLightState("bmw_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("bmw_turn_right", 1, 1, 1)

                end

                anim.setLightState("bmw_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    anim.setLightColor("bmw_brake", 0.67, 0, 0)

                    anim.setLightState("bmw_brake", state)

                end

            else

                if not anim.getLightState("brake") then

                    anim.setLightState("bmw_brake", state)

                end

            end

        end,

        ["brake"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("bmw_brake", 0.67, 0, 0)

            else

                anim.setLightColor("bmw_brake", 1, 0.2, 0.2)

                anim.setLightState("bmw_brake", state)

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("bmw_turn_left", 1, 1, 1)

                anim.setLightState("bmw_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("bmw_turn_right", 1, 1, 1)

                anim.setLightState("bmw_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("bmw_turn_left", 1, 1, 1)

                anim.setLightState("bmw_turn_left", true)

                anim.setLightColor("bmw_turn_right", 1, 1, 1)

                anim.setLightState("bmw_turn_right", true)

            end

        end

    },



    lights = {

        {name = "bmw_turn_left",  material = "bmw_turn_left_*" , colorMul = 1.45 },

        {name = "bmw_turn_right", material = "bmw_turn_right_*", colorMul = 1.45 },

        {name = "bmw_brake",      material = "m8_brake" },

    }

}





-- Dodge Demon

-- demon_turn работает как стопы и повороты

CustomLights[589] = {

    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("demon_turn_left", 1, 0.5, 0)

            end

            anim.setLightState("demon_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("demon_turn_right", 1, 0.5, 0)

            end

            anim.setLightState("demon_turn_right", state)

        end,

        ["brake"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("demon_turn_left", 1, 0, 0)

                end

                anim.setLightState("demon_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("demon_turn_right", 1, 0, 0)

                end

                anim.setLightState("demon_turn_right", state)

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("brake") then

                anim.setLightColor("demon_turn_left", 1, 0, 0)

                anim.setLightState("demon_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("brake") then

                anim.setLightColor("demon_turn_right", 1, 0, 0)

                anim.setLightState("demon_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("brake") then

                anim.setLightColor("demon_turn_left", 1, 0, 0)

                anim.setLightState("demon_turn_left", true)

                anim.setLightColor("demon_turn_right", 1, 0, 0)

                anim.setLightState("demon_turn_right", true)

            end

        end

    },



    lights = {

        {name = "demon_turn_left",  material = "demon_turn_left_*",   brightness = 0.8, color = {1, 0.5, 0}},

        {name = "demon_turn_right", material = "demon_turn_right_*", brightness = 0.8, color = {1, 0.5, 0}},

    }

}


            --[[ОПТИКА]]-- 
-- БНВ ИКОНЕК ЛАЙТС
CustomLights[527] = {   
    init = function (anim)
        anim.turnLightsInterval = 0.8
        -- Время, за которое загораются все блоки
    if FPS > FPSNornal then 
        anim.rearLightsTime = 0.25
    else 
        anim.rearLightsTime = 0.25
    end
        -- Время, после которого свет начинает плавно затухать
        anim.rearLightsFadeAfter = 0.35
    end,

    update = function (anim, deltaTime, vehicle)
        --print (anim.specialAnimActive)
        
        
        -- В anim.specialAnimData передаётся true/false
        -- true - включение фар
        -- false - выключение
        if anim.turnLightsState then
            if anim.turnLightsTime < anim.rearLightsTime then
                -- Включение блоков по очереди
               local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0
                local index = math.floor(anim.turnLightsTime/ anim.rearLightsTime * 12)
                

                if anim.getLightState("turn_left") then
                   anim.setLightState("rs6r_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 
                   anim.setLightState("rs6f_turn_left_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 
      end
                if anim.getLightState("turn_right") then
                   anim.setLightState("rs6r_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 
                   anim.setLightState("rs6f_turn_right_" .. math.floor(anim.turnLightsTime / anim.rearLightsTime * 12), true) -- отвечает за поворотники 
      end
            elseif anim.turnLightsTime > anim.rearLightsFadeAfter then
               if anim.getLightState("turn_left") then
                    for i = 0, 12 do
                   anim.setLightColor("rs6r_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)
                   anim.setLightColor("rs6f_turn_left_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)
                    end
                end
                if anim.getLightState("turn_right") then
                    for i = 0, 12 do
                   anim.setLightColor("rs6r_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)
                   anim.setLightColor("rs6f_turn_right_" ..i, 1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter), (1 - (anim.turnLightsTime - anim.rearLightsFadeAfter) / (anim.turnLightsInterval - anim.rearLightsFadeAfter)) * 0.5, 0)
                    end
                end
            end
        end
        
        if anim.specialAnimActive then
            local currentTime = anim.specialAnimTime
            if anim.specialAnimData == "anim_on" or anim.specialAnimData == "enable" then
                 time0 = 0 -- Задержка старта анимации    
                 time2 = 0.9 -- Время прохождения "щелчка", после основной анимации на передних фарах
                 time4 = 1 -- ?             
                 timePause0 = 0.1
                 timePause01 = 0 -- Задержка старта анимации          
                 timePause = 0.03
                 timePause2 = 0.1

            if FPS > FPSNornal then 
                time1 = 0.25 -- Скорость включения передней оптики при нормальном FPS
                time3 = 0.25 -- Скорость включения задней оптики при нормальном FPS
            else
                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")
                time1 = 0.25 -- Скорость включения передней оптики при низком FPS
                time3 = 0.25 -- Скорость включения задней оптики при низком FPS
            end
                
                if currentTime < time0 then
                    anim.setLightState("turn_left", false)
                    anim.setLightState("turn_right", false)
                    
                    local index = math.floor(currentTime/time0 * 12)
                    anim.setLightState("rs6f_turn_left_"..index, false)
                    anim.setLightColor("rs6f_turn_left_"..index, 1, 0.5, 0)
                    anim.setLightState("rs6f_turn_right_"..index, false)
                    anim.setLightColor("rs6f_turn_right_"..index, 1, 0.5, 0)
                elseif currentTime > time0 + timePause0 and currentTime < time0 + timePause0 + timePause01 then
                    anim.setLightState("turn_left", false)
                    anim.setLightState("turn_right", false)
                    
                    for i = 0, 11 do
                        anim.setLightColor("rs6f_turn_left_"..i, 0, 0, 0)
                        anim.setLightColor("rs6f_turn_right_"..i, 0, 0, 0)
                    end
                elseif currentTime > time0 + timePause0 + timePause01 then
                    currentTime = currentTime - (time0 + timePause0 + timePause01)
                    for i = 0, 12 do
                        if currentTime > time1*i and currentTime < time1*(i+1) + timePause*i then
                            --local progress = (currentTime-time1*i-timePause*i) * 12 / time1
                            local progress = (currentTime-time1*i-timePause*i) / time1 * 13
                            local index = math.ceil(progress) - 1
                            local index2 = 12 + i - index
                            
                            anim.setLightState("rs6f_turn_left_"..index2, true)
                            anim.setLightColor("rs6f_turn_left_"..index2, 1, 1, 1)
                            anim.setLightState("rs6f_turn_left_"..index2 + 1, false)
                            
                            anim.setLightState("rs6f_turn_right_"..index2, true)
                            anim.setLightColor("rs6f_turn_right_"..index2, 1, 1, 1)
                            anim.setLightState("rs6f_turn_right_"..index2 + 1, false)
                        elseif currentTime > time1*12 + timePause*12 + timePause2 then
                            for i = 0, 12 do
                                local currentTime2 = currentTime - time1*12 - timePause*12 - timePause2
                                if currentTime2 > time2*i and currentTime2 < time2*(i+1) + timePause*i then
                                    local progress = (currentTime2-time2*i-timePause*i) * 12 / time2
                                    local index = math.ceil(progress)
                                    local index2 = index
                                    progress = progress - index
                                    anim.setLightColor("rs6f_turn_left_"..index2, 0.2, 0.2, 0.2)
                                    anim.setLightColor("rs6f_turn_left_"..index2-1, 1, 1, 1)
                                    
                                    anim.setLightColor("rs6f_turn_right_"..index2, 0.2, 0.2, 0.2)
                                    anim.setLightColor("rs6f_turn_right_"..index2 - 1, 1, 1, 1)
                                    if index2 >= 12 then
                                        for i = 0, 12 do
                                            anim.setLightState("rs6f_turn_left_"..i, true)
                                            anim.setLightState("rs6f_turn_right_"..i, true)
                                            anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)
                                            anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)
                                        end
                                        anim.stopSpecialAnimation()
                                    end
                                end
                            end
                        end
                    end
                    
                    for i = 0, 16 do
                        if currentTime > time3*i and currentTime < time3*(i+1) + timePause*i then
                            local progress = (currentTime-time3*i - timePause*i) / time3 * 8
                            local index = math.ceil(progress)
                            local index2 = 9 + i - index
                            --[[if i < 1 then
                                print (i, index, index2)
                            end]]
                            
                            if index2 >= 0 then
                                if index2 < 16 then
                                    anim.setLightState("rs6_brake_"..index2, true)
                                    anim.setLightColor("rs6_brake_"..index2, 1, 0, 0)
                                    if index2 + 1 ~= 16 then
                                        anim.setLightState("rs6_brake_"..index2 + 1, false)
                                    end
                                end
                            end
                        end
                    end
                    
                    local progress = getEasingValue (currentTime/(time3*10 + timePause*9), "InQuad")
                    if progress <= 1 then
                      --  print (currentTime, progress)
                        anim.setLightState("rs6_brake_16", true)
                        anim.setLightColor("rs6_brake_16", 1*progress, 0, 1)
                    end
                end
                elseif anim.specialAnimData == "anim_off" or anim.specialAnimData == "disable" then
                local time2 = 0.7 -- ? 
                local timePause = 0.7

            if FPS > FPSNornal then 
                time1 = 0.3 -- Скорость включения передней оптики при нормальном FPS
                time3 = 0.3 -- Скорость включения задней оптики при нормальном FPS
            else
                print("Внимание! Низкий FPS! Скорость анимации уменьшена.")
                time1 = 0.3 -- Скорость включения передней оптики при низком FPS
                time3 = 0.3 -- Скорость включения задней оптики при низком FPS
            end
                
                if currentTime < time1 then
                    local progress = currentTime * 12 / time1
                    local index = math.ceil(progress) - 1
                    progress = progress - index + 1
                    local color = 0.1 * progress
                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)
                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)
                elseif currentTime > time1 and currentTime < time1 + time2 then
                    local progress = (currentTime - time1) * 12 / time2
                    local index = math.ceil(progress) - 1
                    progress = progress - index + 1
                    index = 16 - index
                    local color = 1 - 0.65 * progress
                    --anim.setLightState("rs6f_turn_left_"..index, )
                    anim.setLightColor("rs6f_turn_left_"..index, color, color, color)
                    anim.setLightColor("rs6f_turn_right_"..index, color, color, color)
                elseif currentTime > time1 + time2 + timePause then
                    for i = 0, 16 do
                        anim.setLightState("rs6f_turn_left_"..i, false)
                        anim.setLightState("rs6f_turn_right_"..i, false)
                        anim.stopSpecialAnimation()
                    end  
                end
                
                if currentTime < time3 then
                    local progress = currentTime * 16 / time3
                    local index = math.ceil(progress)
                    progress = progress - index + 1
                    anim.setLightState("rs6_brake_"..(16 - index), false)
                end
                
                local progress = getEasingValue (currentTime/time3, "InQuad")
                --print (progress)
                if progress <= 1 then
                    anim.setLightState("rs6_brake_16", true)
                    anim.setLightColor("rs6_brake_16", 1 - 1*progress, 0, 0)
                end
            end
        end
    end,
    
   stateHandlers = {
        ["turn_left"] = function(anim, state)
      for i = 0, 12 do
        if state then
          anim.setLightColor("rs6r_turn_left_" ..i, 1, 0.3, 0)
          anim.setLightColor("rs6f_turn_left_" ..i, 1, 0.3, 0)
        else
          anim.setLightState("rs6r_turn_left_" ..i, false)
          anim.setLightState("rs6f_turn_left_" ..i, false)
        end
            end
        end,
        ["turn_right"] = function(anim, state)
      for i = 0, 12 do
        if state then
          anim.setLightColor("rs6r_turn_right_" ..i, 1, 0.3, 0)
          anim.setLightColor("rs6f_turn_right_" ..i, 1, 0.3, 0)
        else
          anim.setLightState("rs6r_turn_right_" ..i, false)
          anim.setLightState("rs6f_turn_right_" ..i, false)
        end
            end
        end,
        ["front"] = function (anim, state, veh)
            if state then
                anim.startSpecialAnimation(veh, "anim_on")
            else
                anim.startSpecialAnimation(veh, "anim_off")
            end
        end,
    },

    dataHandlers = {
        ["turn_left"] = function(anim, state)
      if not state and anim.getLightState("front") then
        for i = 0, 12 do
          anim.setLightColor("rs6f_turn_left_" ..i, 1, 1, 1)
          anim.setLightState("rs6f_turn_left_" ..i, true)
        end
      end
    end,
    ["turn_right"] = function(anim, state)
      if not state and anim.getLightState("front") then
        for i = 0, 12 do
          anim.setLightColor("rs6f_turn_right_" ..i, 1, 1, 1)
          anim.setLightState("rs6f_turn_right_" ..i, true)
        end
      end
    end,
        ["emergency_light"] = function (anim, state)
            if not state and anim.getLightState("front") then
                for i = 0, 12 do
                    anim.setLightState("rs6f_turn_left_"..i, true)
                    anim.setLightColor("rs6f_turn_left_"..i, 1, 1, 1)
                    anim.setLightState("rs6f_turn_right_"..i, true)
                    anim.setLightColor("rs6f_turn_right_"..i, 1, 1, 1)
                end
            end
        end
    },

    lights = {
        {name = "rs6f_turn_left_0",  material = "rs6f_turn_left_0" , colorMul = 1 },
        {name = "rs6f_turn_left_1",  material = "rs6f_turn_left_1" , colorMul = 1 },
        {name = "rs6f_turn_left_2",  material = "rs6f_turn_left_2" , colorMul = 1 },
        {name = "rs6f_turn_left_3",  material = "rs6f_turn_left_3" , colorMul = 1 },
        {name = "rs6f_turn_left_4",  material = "rs6f_turn_left_4" , colorMul = 1 },
        {name = "rs6f_turn_left_5",  material = "rs6f_turn_left_5" , colorMul = 1 },
        {name = "rs6f_turn_left_6",  material = "rs6f_turn_left_6" , colorMul = 1 },
        {name = "rs6f_turn_left_7",  material = "rs6f_turn_left_7" , colorMul = 1 },
        {name = "rs6f_turn_left_8",  material = "rs6f_turn_left_8" , colorMul = 1 },
        {name = "rs6f_turn_left_9",  material = "rs6f_turn_left_9" , colorMul = 1 },
        {name = "rs6f_turn_left_10",  material = "rs6f_turn_left_10" , colorMul = 1 },
        {name = "rs6f_turn_left_11",  material = "rs6f_turn_left_11" , colorMul = 1 },
        
        {name = "rs6f_turn_right_0", material = "rs6f_turn_right_0", colorMul = 1 },
        {name = "rs6f_turn_right_1",  material = "rs6f_turn_right_1" , colorMul = 1 },
        {name = "rs6f_turn_right_2",  material = "rs6f_turn_right_2" , colorMul = 1 },
        {name = "rs6f_turn_right_3",  material = "rs6f_turn_right_3" , colorMul = 1 },
        {name = "rs6f_turn_right_4",  material = "rs6f_turn_right_4" , colorMul = 1 },
        {name = "rs6f_turn_right_5",  material = "rs6f_turn_right_5" , colorMul = 1 },
        {name = "rs6f_turn_right_6",  material = "rs6f_turn_right_6" , colorMul = 1 },
        {name = "rs6f_turn_right_7",  material = "rs6f_turn_right_7" , colorMul = 1 },
        {name = "rs6f_turn_right_8",  material = "rs6f_turn_right_8" , colorMul = 1 },
        {name = "rs6f_turn_right_9",  material = "rs6f_turn_right_9" , colorMul = 1 },
        {name = "rs6f_turn_right_10",  material = "rs6f_turn_right_10" , colorMul = 1 },
        {name = "rs6f_turn_right_11",  material = "rs6f_turn_right_11" , colorMul = 1 },

        {name = "rs6r_turn_left_0", material = "rs6r_turn_left_0",   brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_left_1", material = "rs6r_turn_left_1",   brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_left_2", material = "rs6r_turn_left_2",   brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_left_3", material = "rs6r_turn_left_3",   brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_left_4", material = "rs6r_turn_left_4",   brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_right_0", material = "rs6r_turn_right_0", brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_right_1", material = "rs6r_turn_right_1", brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_right_2", material = "rs6r_turn_right_2", brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_right_3", material = "rs6r_turn_right_3", brightness = 0.5, color = {1, 0.1, 0}},
        {name = "rs6r_turn_right_4", material = "rs6r_turn_right_4", brightness = 0.5, color = {1, 0.1, 0}},        
        
        {name = "rs6_brake_1", material = "bmw_iconic_0",   brightness = 0.5 },
        {name = "rs6_brake_2", material = "bmw_iconic_1",   brightness = 0.5 },
        {name = "rs6_brake_3", material = "bmw_iconic_2",   brightness = 0.5 },
        {name = "rs6_brake_4", material = "bmw_iconic_3",   brightness = 0.5 },
        {name = "rs6_brake_5", material = "bmw_iconic_4",   brightness = 0.5 },
        {name = "rs6_brake_6", material = "bmw_iconic_5",   brightness = 0.5 },
        {name = "rs6_brake_7", material = "bmw_iconic_6",   brightness = 0.5 },
        {name = "rs6_brake_8", material = "bmw_iconic_7",   brightness = 0.5 },
        {name = "rs6_brake_9", material = "bmw_iconic_8",   brightness = 0.5 },     
        {name = "rs6_brake_10", material = "bmw_iconic_9",   brightness = 0.5 },
        {name = "rs6_brake_11", material = "bmw_iconic_10",   brightness = 0.5 },
        {name = "rs6_brake_12", material = "bmw_iconic_11",   brightness = 0.5 },
        {name = "rs6_brake_13", material = "bmw_iconic_12",   brightness = 0.5 },
        {name = "rs6_brake_14", material = "bmw_iconic_13",   brightness = 0.5 },
        {name = "rs6_brake_15", material = "bmw_iconic_14",   brightness = 0.5 },       
    }
}   

-- колян

CustomLights[479] = {

    init = function (anim)

        anim.turnLightsInterval = 0.5

    end,



    stateHandlers = {

        ["turn_left"] = function (anim, state)

            if state then

                anim.setLightColor("rr_turn_left", 1, 0.35, 0)

            end

            anim.setLightState("rr_turn_left", state)

        end,

        ["turn_right"] = function (anim, state)

            if state then

                anim.setLightColor("rr_turn_right", 1, 0.35, 0)

            end

            anim.setLightState("rr_turn_right", state)

        end,

        ["front"] = function (anim, state)

            -- Если включен поворотник, состояние не обновляется

            if not anim.getLightState("turn_left") then

                if state then

                    anim.setLightColor("rr_turn_left", 1, 1, 1)

                end

                anim.setLightState("rr_turn_left", state)

            end

            if not anim.getLightState("turn_right") then

                if state then

                    anim.setLightColor("rr_turn_right", 1, 1, 1)

                end

                anim.setLightState("rr_turn_right", state)

            end

            if state then

                if not anim.getLightState("brake") then

                    anim.setLightColor("rr_brake", 0.67, 0, 0)

                    anim.setLightState("rr_brake", state)

                end

            else

                if not anim.getLightState("brake") then

                    anim.setLightState("rr_brake", state)

                end

            end

        end,

        ["brake"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_brake", 0.67, 0, 0)

            else

                anim.setLightColor("rr_brake", 1, 0.2, 0.2)

                anim.setLightState("rr_brake", state)

            end

        end

    },



    dataHandlers = {

        ["turn_left"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_turn_left", 1, 1, 1)

                anim.setLightState("rr_turn_left", true)

            end

        end,

        ["turn_right"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_turn_right", 1, 1, 1)

                anim.setLightState("rr_turn_right", true)

            end

        end,

        ["emergency_light"] = function (anim, state)

            if not state and anim.getLightState("front") then

                anim.setLightColor("rr_turn_left", 1, 1, 1)

                anim.setLightState("rr_turn_left", true)

                anim.setLightColor("rr_turn_right", 1, 1, 1)

                anim.setLightState("rr_turn_right", true)

            end

        end

    },



    lights = {

        {name = "rr_turn_left",  material = "rr_turn_left_*" , colorMul = 1.5 },

        {name = "rr_turn_right", material = "rr_turn_right_*", colorMul = 1.5 },

        {name = "rr_brake",      material = "rr_brake_*" },		

    }

}

-- BMW M5 F90

CustomLights[597] = {

  init = function(_ARG_0_)

    _ARG_0_.turnLightsInterval = 0.42

    _ARG_0_.rearLightsTime = 0.27

    _ARG_0_.rearLightsFadeAfter = 0.3

  end,

  update = function(_ARG_0_)

    if not _ARG_0_.turnLightsState then

      return

    end

    if _ARG_0_.turnLightsTime < _ARG_0_.rearLightsTime then

      if _ARG_0_.getLightState("turn_left") then

        _ARG_0_.setLightState("custom_turn_lr_" .. math.floor(_ARG_0_.turnLightsTime / _ARG_0_.rearLightsTime * 6), true)

        _ARG_0_.setLightState("custom_turn_lf_" .. math.floor(_ARG_0_.turnLightsTime / _ARG_0_.rearLightsTime * 6), true)

		_ARG_0_.setLightState("m5_turn_left_" .. math.floor(_ARG_0_.turnLightsTime / _ARG_0_.rearLightsTime * 6), true)

      end

      if _ARG_0_.getLightState("turn_right") then

        _ARG_0_.setLightState("custom_turn_rr_" .. math.floor(_ARG_0_.turnLightsTime / _ARG_0_.rearLightsTime * 6), true)

        _ARG_0_.setLightState("custom_turn_rf_" .. math.floor(_ARG_0_.turnLightsTime / _ARG_0_.rearLightsTime * 6), true)

		_ARG_0_.setLightState("m5_turn_right_" .. math.floor(_ARG_0_.turnLightsTime / _ARG_0_.rearLightsTime * 6), true)

      end

    elseif _ARG_0_.turnLightsTime > _ARG_0_.rearLightsFadeAfter then

      if _ARG_0_.getLightState("turn_left") then

        for _FORV_5_ = 0, 5 do

          _ARG_0_.setLightColor("custom_turn_lr_" .. _FORV_5_, 1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter), (1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter)) * 0.5, 0)

          _ARG_0_.setLightColor("custom_turn_lf_" .. _FORV_5_, 1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter), (1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter)) * 0.5, 0)

		   _ARG_0_.setLightColor("m5_turn_left_" .. _FORV_5_, 1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter), (1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter)) * 0.5, 0)

        end

      end

      if _ARG_0_.getLightState("turn_right") then

        for _FORV_5_ = 0, 5 do

          _ARG_0_.setLightColor("custom_turn_rr_" .. _FORV_5_, 1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter), (1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter)) * 0.5, 0)

          _ARG_0_.setLightColor("custom_turn_rf_" .. _FORV_5_, 1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter), (1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter)) * 0.5, 0)

          _ARG_0_.setLightColor("m5_turn_right_" .. _FORV_5_, 1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter), (1 - (_ARG_0_.turnLightsTime - _ARG_0_.rearLightsFadeAfter) / (_ARG_0_.turnLightsInterval - _ARG_0_.rearLightsFadeAfter)) * 0.5, 0)

		end

      end

    end

  end,

  stateHandlers = {

    turn_left = function(_ARG_0_, _ARG_1_)

      for _FORV_5_ = 0, 5 do

        if _ARG_1_ then

          _ARG_0_.setLightColor("custom_turn_lr_" .. _FORV_5_, 1, 0.5, 0)

          _ARG_0_.setLightColor("custom_turn_lf_" .. _FORV_5_, 1, 0.5, 0)

		  _ARG_0_.setLightColor("m5_turn_left_" .. _FORV_5_, 1, 0.5, 0)

        else

          _ARG_0_.setLightState("custom_turn_lr_" .. _FORV_5_, false)

          _ARG_0_.setLightState("custom_turn_lf_" .. _FORV_5_, false)

		  _ARG_0_.setLightState("m5_turn_left_" .. _FORV_5_, false)

        end

      end

    end,

    turn_right = function(_ARG_0_, _ARG_1_)

      for _FORV_5_ = 0, 5 do

        if _ARG_1_ then

          _ARG_0_.setLightColor("custom_turn_rr_" .. _FORV_5_, 1, 0.5, 0)

          _ARG_0_.setLightColor("custom_turn_rf_" .. _FORV_5_, 1, 0.5, 0)

		   _ARG_0_.setLightColor("m5_turn_right_" .. _FORV_5_, 1, 0.5, 0)

        else

          _ARG_0_.setLightState("custom_turn_rr_" .. _FORV_5_, false)

          _ARG_0_.setLightState("custom_turn_rf_" .. _FORV_5_, false)

		  _ARG_0_.setLightState("m5_turn_right_" .. _FORV_5_, false)

        end

      end

    end,

    front = function(_ARG_0_, _ARG_1_)

      if not _ARG_0_.getLightState("turn_left") then

        for _FORV_5_ = 0, 5 do

          if _ARG_1_ then

            _ARG_0_.setLightColor("custom_turn_lf_" .. _FORV_5_, 1, 1, 1)

			_ARG_0_.setLightColor("m5_turn_left_" .. _FORV_5_, 1, 1, 1)

          end

          _ARG_0_.setLightState("custom_turn_lf_" .. _FORV_5_, _ARG_1_)

		  _ARG_0_.setLightState("m5_turn_left_" .. _FORV_5_, _ARG_1_)

        end

      end

      if not _ARG_0_.getLightState("turn_right") then

        for _FORV_5_ = 0, 5 do

          if _ARG_1_ then

            _ARG_0_.setLightColor("custom_turn_rf_" .. _FORV_5_, 1, 1, 1)

			_ARG_0_.setLightColor("m5_turn_right_" .. _FORV_5_, 1, 1, 1)

          end

          _ARG_0_.setLightState("custom_turn_rf_" .. _FORV_5_, _ARG_1_)

		  _ARG_0_.setLightState("m5_turn_right_" .. _FORV_5_, _ARG_1_)

        end

      end

    end

  },

  dataHandlers = {

    turn_left = function(_ARG_0_, _ARG_1_)

      if not _ARG_1_ and _ARG_0_.getLightState("front") then

        for _FORV_5_ = 0, 5 do

          _ARG_0_.setLightColor("custom_turn_lf_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("custom_turn_lf_" .. _FORV_5_, true)

		  _ARG_0_.setLightColor("m5_turn_left_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("m5_turn_left_" .. _FORV_5_, true)

        end

      end

    end,

    turn_right = function(_ARG_0_, _ARG_1_)

      if not _ARG_1_ and _ARG_0_.getLightState("front") then

        for _FORV_5_ = 0, 5 do

          _ARG_0_.setLightColor("custom_turn_rf_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("custom_turn_rf_" .. _FORV_5_, true)

		  _ARG_0_.setLightColor("m5_turn_right_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("m5_turn_right_" .. _FORV_5_, true)

        end

      end

    end,

    emergency_light = function(_ARG_0_, _ARG_1_)

      if not _ARG_1_ and _ARG_0_.getLightState("front") then

        for _FORV_5_ = 0, 5 do

          _ARG_0_.setLightColor("custom_turn_lf_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("custom_turn_lf_" .. _FORV_5_, true)

          _ARG_0_.setLightColor("custom_turn_rf_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("custom_turn_rf_" .. _FORV_5_, true)

		  _ARG_0_.setLightColor("m5_turn_left_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("m5_turn_left_" .. _FORV_5_, true)

          _ARG_0_.setLightColor("m5_turn_right_" .. _FORV_5_, 1, 1, 1)

          _ARG_0_.setLightState("m5_turn_right_" .. _FORV_5_, true)

        end

      end

    end

  },

  lights = {

    {

      name = "custom_turn_lr_0",

      material = "bmw_turn_left_0",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lr_1",

      material = "bmw_turn_left_1",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lr_2",

      material = "bmw_turn_left_2",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lr_3",

      material = "bmw_turn_left_3",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lr_4",

      material = "bmw_turn_left_4",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rr_0",

      material = "bmw_turn_right_0",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rr_1",

      material = "bmw_turn_right_1",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rr_2",

      material = "bmw_turn_right_2",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rr_3",

      material = "bmw_turn_right_3",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rr_4",

      material = "bmw_turn_right_4",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lf_0",

      material = "bmw_turn_left_0",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lf_1",

      material = "bmw_turn_left_1",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lf_2",

      material = "bmw_turn_left_2",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lf_3",

      material = "bmw_turn_left_3",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_lf_4",

      material = "bmw_turn_left_4",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rf_0",

      material = "bmw_turn_right_0",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rf_1",

      material = "bmw_turn_right_1",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rf_2",

      material = "bmw_turn_right_2",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rf_3",

      material = "bmw_turn_right_3",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "custom_turn_rf_4",

      material = "bmw_turn_right_4",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

	{

      name = "m5_turn_left_0",

      material = "m5_turn_left_*",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    },

    {

      name = "m5_turn_right_0",

      material = "m5_turn_right_*",

      brightness = 0.8,

      color = {

        1,

        0.5,

        0

      }

    }

  }

}