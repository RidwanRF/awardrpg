-- Настройки радара --
br,bg,bb,ba = 140, 140, 140, 255 -- Цвет обводки радара
distFromLine = 5 -- Расстояние от краев радара

-- Настройки мигания радара --
chaseColorDelta = 20 -- Скорость смены цвета

function getColor ()
return {br,bg,bb,ba}
end
