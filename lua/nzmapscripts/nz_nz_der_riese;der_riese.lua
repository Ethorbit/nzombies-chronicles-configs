local mapscript = {}

function mapscript.GetPaPMachine()
    local papMach = nil

    for _,v in pairs(ents.FindByClass("perk_machine")) do
        local perkData = nzPerks:Get(v:GetPerkID())
        if (perkData and perkData.name == "Pack-a-Punch") then
            papMach = v
        end
    end

    return papMach
end

function mapscript.ScriptLoad()
    hook.Add("AcceptInput", "DerRieseFixes", function(ent, input, activator, caller, val)
        -- Fix EE song not playing
        if (ent:GetName() == "eesong" and string.lower(input) == "playsound") then
            ent:Fire("StopSound") -- Just in case it actually DOES work, don't want it playing twice
            BroadcastLua("surface.PlaySound(\"nz_der_riese_waw/waw_mx_beauty.mp3\")")
        end

        -- Fix being able to PaP before the PaP door is opened
        if (ent:GetName() == "mainframedoorclip" and string.lower(input) == "kill") then
            local papMach = mapscript.GetPaPMachine()
            if (IsValid(papMach)) then
                papMach:TurnOn()
            end
        end
    end)

    hook.Add("ElectricityOn", "DerRiesePaPFix", function()
        local papMach = mapscript.GetPaPMachine()
        if (IsValid(papMach)) then
            papMach:TurnOff()
        end
    end)
end

function mapscript.ScriptUnload()
    hook.Remove("AcceptInput", "DerRieseFixes")
    hook.Remove("ElectricityOn", "DerRiesePaPFix")
end

return mapscript