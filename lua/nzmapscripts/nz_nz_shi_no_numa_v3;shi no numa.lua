local mapscript = {}

local function ShinoNumaMaxZombies()
    return (24 * (#player.GetAllPlaying()))
end

function mapscript.ScriptLoad()
    -- Slow players in water
    hook.Add("OnEntityWaterLevelChanged", "ShiNoNumaWater", function(ent, oldLvl, newLvl)
        if (IsValid(ent) and ent:IsPlayer() and ent:Alive() and !ent:IsSpectating()) then
            if (newLvl >= 1) then
                ent:SetMaxRunSpeed(ent:GetRunSpeed("mud"))
                ent:SetRunSpeed(ent:GetRunSpeed("mud"))
                ent:SetWalkSpeed(ent:GetWalkSpeed("mud"))
            else
                ent:SetMaxRunSpeed(ent:GetDefaultRunSpeed())
                ent:SetRunSpeed(ent:GetDefaultRunSpeed())
                ent:SetWalkSpeed(ent:GetDefaultWalkSpeed())
            end
        end
    end)

    hook.Add("OnEntityCreated", "NoDogMidGame", function(ent)
        if (ent:GetClass() == "nz_zombie_special_dog" and !nzRound:IsSpecial()) then
            ent:Remove()
        end
    end)
end

function mapscript.OnRoundStart(round)
	if (!nzRound:IsSpecial()) then
		-- Make sure the round is consistent just like in Shi no numa
		timer.Simple(0, function()
			if (nzCurves.GenerateMaxZombies(round) > ShinoNumaMaxZombies()) then
				nzRound:SetZombiesMax(ShinoNumaMaxZombies())
				net.Start("update_prog_bar_max")
				net.WriteUInt(nzRound:GetZombiesMax(), 32)
				net.Broadcast()
			end
		end)
	end
end

function mapscript.ScriptUnload() 
    hook.Remove("OnEntityWaterLevelChanged", "ShiNoNumaWater")
    hook.Remove("OnEntityCreated", "NoDogMidGame")
end

return mapscript