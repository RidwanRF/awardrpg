sw, sh = guiGetScreenSize()

zoom = 1
local baseX = 1920
local minZoom = 2
if sw < baseX then
  zoom = math.min(minZoom, baseX/sw)
end

sx,sy = guiGetScreenSize();
local px, py = sx/1920, sy/1080
screenW,screenH = (sx/px), (sy/py);


BoldBig = dxCreateFont("assets/Montserrat-Bold.ttf", 38*px)
Bold = dxCreateFont("assets/Montserrat-Bold.ttf", 24*px)
BoldMini = dxCreateFont("assets/Montserrat-Bold.ttf", 14*px)
SemiBold = dxCreateFont("assets/Montserrat-SemiBold.ttf", 13*px)
SemiBold2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
SemiBoldBig = dxCreateFont("assets/Montserrat-SemiBold.ttf", 19*px)
SemiBoldBig2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 15*px)
SemiBoldMini = dxCreateFont("assets/Montserrat-SemiBold.ttf", 11*px)
SemiBoldMini2 = dxCreateFont("assets/Montserrat-SemiBold.ttf", 10*px)
MediumBig = dxCreateFont("assets/Montserrat-Medium.ttf", 19*px)
Medium = dxCreateFont("assets/Montserrat-Medium.ttf", 13*px)
MediumMini = dxCreateFont("assets/Montserrat-Medium.ttf", 11*px)
Regular = dxCreateFont("assets/Montserrat-Regular.ttf", 11*px)




function dxDrawButton(x, y, w, h, text)

    dxDrawImage(x, y, w, h, "assets/bt.png", 0,0,0, tocolor(50, 50, 50, 235))

    dxDrawText(text, x, y, w, h, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "center", "center")

    if cursorPosition(x, y, w, h) then

	dxDrawImage(x, y, w, h, "assets/bt.png", 0,0,0, tocolor(170, 50, 50, 255))

	dxDrawText(text, x, y, w, h, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "center", "center")

      -- dxDrawRectangle(x, y + h-2, w, 2, tocolor(30, 144, 255, 200))

    end

end



function dxDrawButton2(x, y, w, h, text)

    dxDrawRectangle(x, y, w, h, tocolor(50, 50, 50, 235))

    dxDrawText(text, x, y, w, h, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "center", "center")

    if cursorPosition(x, y, w, h) then

	dxDrawRectangle(x, y, w, h, tocolor(170, 50, 50, 255))

	dxDrawText(text, x, y, w, h, tocolor(255, 255, 255, 255), 1, SemiBoldMini, "center", "center")

      -- dxDrawRectangle(x, y + h-2, w, 2, tocolor(30, 144, 255, 200))

    end

end



function dxDrawShadowText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCode )

    dxDrawText ( text:gsub( "#%x%x%x%x%x%x", "" ), x + 1.5, y + 1.5, w, h, tocolor ( 0, 0, 0, 255 ), scale, font, alignX, alignY, clip, wordBreak, false, true)

    dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, true )

end



function convertNumber( number, symbol )  

    if not symbol then symbol = " " end

    local formatted = number  

    while true do      

        formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1'..symbol..'%2' )    

        if ( k==0 ) then      

            break   

        end  

    end  

    return formatted

end



edits = {

    selected = {},

    text = {},

    click = false,

}

function dxDrawEdit(x, y, w, h, text, ID)



    if not edits.text[ID] then

        edits.text[ID] = ""

    end

    local state = false

    for i,v in pairs(edits.selected) do

        if v == true then

            state = true

        end

        guiSetInputEnabled(state)

    end

    if edits.text[ID] ~= "" then
        dxDrawText(convertNumber(edits.text[ID]), sx/2-(1060/2)*px, sy/2+(2827/2)*py,  sx/2-(1600/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, alpha), 1, SemiBold2, "center", "center", false, false, false, false, false)
    else
        dxDrawText(text, sx/2-(1060/2)*px, sy/2+(2827/2)*py,  sx/2-(1600/2)*px,sy/2+(-1675/2)*py, tocolor(255, 255, 255, alpha), 1, SemiBold2, "center", "center", false, false, false, false, false)
    end

    local xs = dxGetTextWidth(convertNumber(edits.text[ID]), 1, SemiBoldMini)



    if edits.selected[ID] then
        if getKeyState ("backspace") then

            if getTickCount() - tickBackSpace > 50 then

                edits.text[ID] = utf8.sub(edits.text[ID], 1, utf8.len(edits.text[ID])-1)

                tickBackSpace = getTickCount()

            end

        end

    end



    if getKeyState("mouse1") then

        edits.click = true

        if cursorPosition(x, y, w, h) then

            edits.selected[ID] = true

        else

            edits.selected[ID] = false

        end

    else

        edits.click = false

    end

    return edits.text[ID]

end



function dxCreateText (text, x, y, w, h, color, size, font, left, top)

    dxDrawText (text, x, y, x + w, y + h, color, size, font, left, top)

end







function dxDrawWindow(x, y, w, h, text)

    dxDrawRectangle(x, y, w, h, tocolor(55, 55, 55, 200))

    dxDrawRectangle(x + 5, y + 5, w-10, 25, tocolor(30, 144, 255, 255))

    dxDrawText(text, x + 5, y + 5, w-10, 25, tocolor(55, 55, 55, 255), 1, font, "center", "center")



end



function outputPressedCharacter(character)

    for i,v in pairs(edits.selected) do

        if v == true and string.len(edits.text[i]) < 15 then

            if (character >= "0" and character <= "9") then

                edits.text[i] = edits.text[i]..character

            end

        end

    end

end

addEventHandler("onClientCharacter", root, outputPressedCharacter)



function outputPressedKey(button, press)

    if not press then return end

    if button == "backspace" then

        tickBackSpace = getTickCount() + 200

        for i,v in pairs(edits.selected) do

            if v == true then

                edits.text[i] = utf8.sub(edits.text[i], 1, utf8.len(edits.text[i])-1)

            end

        end

    end

end

addEventHandler("onClientKey", root, outputPressedKey)

function cursorPosition(x, y, w, h)

    if (not isCursorShowing()) then

        return false

    end

    local mx, my = getCursorPosition()

    local fullx, fully = guiGetScreenSize()

    cursorx, cursory = mx*fullx, my*fully

    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then

        return true

    else

        return false

    end

end



function dxDrawShadow(x,y,w,h,r,g,b,a,radius,fill)

    if(radius > 0)then

        dxDrawGradient(x, y-radius, w,radius,r,g,b,a,true,false)

        dxDrawGradient(x-radius, y, radius,h,r,g,b,a,false,false)

        dxDrawGradient(x+w, y, radius,h,r,g,b,a,false,true)

        dxDrawGradient(x, y+h, w,radius,r,g,b,a,true,true)



        dxDrawCircle(x, y, radius, 180, 270, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)

        dxDrawCircle(x+w, y+h, radius, 0, 90, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)

        dxDrawCircle(x+w, y, radius, 270, 360, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)

        dxDrawCircle(x, y+h, radius, 90, 180, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)

    end

    if(fill and fill == true)then

        dxDrawRectangle(x+1,y+1,w-1,h-1, tocolor(r,g,b,a))

    end

end





function dxDrawGradient(x,y,w,h,r,g,b,a,vertical,inverce)

    if(vertical == true)then

        for i=0,h do

            if inverce == false then

                dxDrawRectangle(x, y+i, w, 1,tocolor(r,g,b,i/h*a or 255));

            else

                dxDrawRectangle(x, y+h-i, w, 1,tocolor(r,g,b,i/h*a or 255)); 

            end

        end

    else

        for i=0,w do

            if inverce == false then

                dxDrawRectangle(x+i, y, 1, h,tocolor(r,g,b,i/w*a or 255));

            else

                dxDrawRectangle(x+w-i, y, 1, h,tocolor(r,g,b,i/w*a or 255)); 

            end

        end

    end

end





function isEventHandlerAdded( sEventName, pElementAttachedTo, func )

     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then

          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )

          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then

               for i, v in ipairs( aAttachedFunctions ) do

                    if v == func then

                     return true

                end

           end

      end

     end

     return false

end