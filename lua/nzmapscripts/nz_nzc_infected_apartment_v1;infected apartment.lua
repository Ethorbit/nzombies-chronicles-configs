local mapscript = {}

local function removeOldTeleporter()
    -- Remove the TP trigger:
    local tp = ents.FindByClass("trigger_teleport")[1]
    if IsValid(tp) then 
        tp:Remove() 
    end

    -- Remove the silly "egg" thingies that were meant to be shot in order, to unlock the Teleporter
    for _,ent in pairs(ents.FindByClass("func_button")) do
        if string.find(ent:GetName(), "egg") then
            ent:Remove()
        end
    end
end

local function turnOnSprite(bool)
    -- Turn the sprite on so everyone knows it's already active:
    local sprite = ents.FindByName("teleporter_sprite_button")[1]
    if IsValid(sprite) then
        if bool then
            sprite:Fire("ShowSprite")
        else
            sprite:Fire("HideSprite")
        end
    end
end

function mapscript.ScriptLoad()
    removeOldTeleporter()
    turnOnSprite(false)
end

function mapscript.OnGameBegin()
    removeOldTeleporter()
    turnOnSprite(false)
end

function mapscript.ElectricityOn()
    turnOnSprite(true)

    local power
    for _,door in pairs(ents.FindByName("power")) do
        if door:GetClass() == "func_door" then
            power = door
            break 
        end
    end

    if IsValid(power) then
        power:Fire("Open")
    end
end

function mapscript.OnRoundEnd()
    turnOnSprite(false)
end

return mapscript