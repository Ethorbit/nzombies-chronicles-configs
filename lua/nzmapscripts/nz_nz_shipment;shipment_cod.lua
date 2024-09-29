local mapscript = {}

function mapscript.OnGameBegin()
    for _,v in pairs(ents.FindByName("music")) do -- Shipment has built-in looping music, stop that
        v:Remove()
    end
end

return mapscript