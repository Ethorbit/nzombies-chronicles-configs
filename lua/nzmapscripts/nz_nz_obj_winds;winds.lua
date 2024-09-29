local mapscript = {}

local function remove_deleters()
    for _,v in pairs(ents.GetAll()) do 
        if string.find(v:GetName(), "nz_zombie_deleter") then 
            v:Remove()
        end
    end
end

function mapscript.ScriptLoad()
    remove_deleters()
end

function mapscript.OnGameBegin()
    remove_deleters()
end


return mapscript 
