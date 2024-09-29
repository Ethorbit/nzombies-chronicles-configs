local mapscript = {}

local function AllowedMaxZombies()
    return (24 * (#player.GetAllPlaying()))
end

function mapscript.OnRoundStart(round)
	if (!nzRound:IsSpecial()) then
		-- Make sure the round is consistent just like in Shi no numa
		timer.Simple(0, function()
			if (nzCurves.GenerateMaxZombies(round) > AllowedMaxZombies()) then
				nzRound:SetZombiesMax(AllowedMaxZombies(round))
				net.Start("update_prog_bar_max")
				net.WriteUInt(nzRound:GetZombiesMax(), 32)
				net.Broadcast()
			end
		end)
	end
end

return mapscript