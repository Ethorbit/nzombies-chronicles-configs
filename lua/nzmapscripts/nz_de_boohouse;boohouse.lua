local mapscript = {}

function mapscript.ScriptLoad()
    hook.Add("AcceptInput", "BoohouseDoorVisibility", function(ent, input, activator, caller, value)
        if (istable(mapscript.animatedDoors)) then
            if (input == "open" and table.HasValue(mapscript.animatedDoors, ent)) then -- It is moving, don't show it or people can see it travelling through the map
                ent:SetNoDraw(true)
                ent:SetRenderMode(RENDERMODE_NONE)
                ent.HandledVec0 = false
            end
        end
    end)

    hook.Add("Think", "BoohouseDoorMovement", function()
        if (istable(mapscript.animatedDoors)) then
            for _,v in pairs(mapscript.animatedDoors) do
                if (IsValid(v)) then
                    if (v:GetVelocity() == Vector(0, 0, 0) and !v.HandledVec0) then -- It stopped moving and is now in the place it's meant to show to people, so make it visible again
                        v.HandledVec0 = true
                        v:SetNoDraw(false)
                        v:SetRenderMode(RENDERMODE_NORMAL)
                    end
                end
            end
        end
    end)
end

function mapscript.OnRoundStart()   
    mapscript.animatedDoors = {}
    for _,v in pairs(ents.FindByClass("func_door")) do
        if (IsValid(v)) then
            v:SetNoDraw(false)
            v:SetRenderMode(RENDERMODE_NONE)
            local values = v:GetKeyValues()
            if (values.speed == 500) then -- Boohouse doors that move across the map all have 500 speed, and those are the ones we need to modify
                table.insert(mapscript.animatedDoors, v)
                --v:Fire("AddOutput", string.format("OnFullyClosed %s:FireUser4:none:0:-1", v:GetName())) -- We need to know when the door is fully closed, there seems to be no other way
                v:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- They are able to push players & zombies, so let's fix that
            end
        end
    end
end

-- Game ended, show all func_doors again so when we hide them things don't mess up
function mapscript.OnRoundEnd()
    for _,v in pairs(ents.FindByClass("func_door")) do
        v:SetNoDraw(false)
        v:SetRenderMode(RENDERMODE_NORMAL)
    end
end

function mapscript.ScriptUnload()
    hook.Remove("AcceptInput", "BoohouseDoorVisibility")
    hook.Remove("Think", "BoohouseDoorMovement")
end

return mapscript