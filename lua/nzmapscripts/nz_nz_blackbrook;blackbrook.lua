-- The zombies spawn so fast that they
-- overwhelm players in no time

-- This script aims to fix that

local mapscript = {}

function mapscript.OptimizeMap() -- Removes the super laggy entities from the map so people can get more than 25 fps
    for _,entTbl in pairs({ents.FindByClass("func_dustcloud"), ents.FindByClass("func_illusionary")}) do
        for _,ent in pairs(entTbl) do
            if IsValid(ent) then
                ent:Remove()
            end
        end
    end
end

function mapscript.ScriptLoad()
    mapscript.OptimizeMap()

    hook.Add("NormalZombieSpawnDelay", "BlackBrook_LongerSpawnTimes", function()
        local round = nzRound:GetNumber()
        local extra_players = #player.GetAllPlayingAndAlive() - 1
        return math.Clamp(4 - (0.3 * extra_players), 1.1, 4) -- Slightly decrease spawn time based on player count (The more players, the more people camping top of stairs)
    end)
end

function mapscript.OnGameBegin()
    mapscript.OptimizeMap()
end

function mapscript.ScriptUnload()
    hook.Remove("NormalZombieSpawnDelay", "BlackBrook_LongerSpawnTimes")
end

return mapscript 