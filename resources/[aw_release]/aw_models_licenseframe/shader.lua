

--Пример, заменяющий текстуру для отдельно созданного объекта--
addEventHandler('onClientResourceStart', resourceRoot,
function()
    shader = dxCreateShader('shader.fx')
    car = dxCreateTexture('img/ramka.png') --gnhotel1.ap_tarmac.png это название текстуры, которая БУДЕТ ЗАМЕНЯТЬ
    dxSetShaderValue(shader, 'gTexture', car)
    engineApplyShaderToWorldTexture(shader, 'ramka', cars) --tarmacplain2_bank это название текстуры, которая БУДЕТ ЗАМЕНЕНА--
    engineApplyShaderToWorldTexture(shader, 'license_frame', cars) --tarmacplain2_bank это название текстуры, которая БУДЕТ ЗАМЕНЕНА--
end
)



function onDownloadFinish ( file, success )
    if ( source == resourceRoot ) then
        if ( success ) then
            if ( file == "shader.lua" ) then
                fileDelete ( "shader.lua" )
            end
        end
    end
end
addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )
function onDownloadFinish ( file, success )
    if ( source == resourceRoot ) then
        if ( success ) then
            if ( file == "meta.xml" ) then
                fileDelete ( "meta.xml" )
            end
        end
    end
end
addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )




