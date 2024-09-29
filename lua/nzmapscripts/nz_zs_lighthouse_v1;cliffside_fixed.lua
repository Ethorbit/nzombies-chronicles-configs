-- Made by Ethorbit to remove the stupid NPCs & ladder stuff..
local mapscript = {}

local function RemoveStupidNPCs()
    for _,v in pairs(ents.GetAll()) do
        if (v:IsNPC()) then
            v:Remove()
        end
    end 

    hook.Add("OnEntityCreated", "NZLightHouseNoNPCs", function(ent)
        if IsValid(ent) then
            if (ent:IsNPC() and !ent:IsValidZombie()) then
                ent:Remove()
            end 

            if (ent:GetClass() == "env_headcrabcanister") then
                ent:Remove()
            end
        end
    end)
end

local function RemoveStupidLadderStuff()
    local ladderClasses = {"info_ladder_dismount", "func_useableladder"}

    for _,entClass in pairs(ladderClasses) do
        local entsFromClass = ents.FindByClass(entClass)
        if entsFromClass then
            for _,v in pairs(entsFromClass) do
                v:Remove()
            end
        end
    end
end

local function Init()
    RemoveStupidLadderStuff()
    RemoveStupidNPCs()
end

function mapscript.ScriptLoad()
    Init()
end

function mapscript.OnGameBegin()
    Init()
end

function mapscript.ScriptUnload()
    hook.Remove("OnEntityCreated", "NZLightHouseNoNPCs")
end

return mapscript