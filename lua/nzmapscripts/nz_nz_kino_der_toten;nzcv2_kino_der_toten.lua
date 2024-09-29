-- Map has annoying music at the start of the game, time to remove it
local mapscript = {}

function mapscript.OnGameBegin()
    for _,v in pairs(ents.FindByName("ambient_music")) do -- Shipment has built-in looping music, stop that
        v:Remove()
    end
end

return mapscript 