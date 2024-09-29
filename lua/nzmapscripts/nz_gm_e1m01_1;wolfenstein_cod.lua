-- Made by Ethorbit to remove the map doors 
-- and make dogs spawn with zombies all the time
local mapscript = {}

local function RemoveStupidDoors()
    for _,v in pairs(ents.FindByClass("func_button")) do
        if (string.find(v:GetName(), "door")) then
            v:Remove()
        end
    end

    for _,v in pairs(ents.FindByClass("func_movelinear")) do
        v:Remove()
    end
end

--local function DogSpawnForce() -- Usually this happens after round 20, but fuck everyone in this map you can suffer dog rape
    -- local amount = math.floor(nzRound:GetNumber() / 2)
    -- local specialSpawner = Spawner("nz_spawn_zombie_special", {["nz_zombie_special_dog"] = {chance = 100}}, amount, 2)
    -- nzRound:SetSpecialSpawner(specialSpawner)
    -- nzRound:SetZombiesMax(nzRound:GetZombiesMax() + amount)

    -- -- Update Cryo's zombie bar
    -- net.Start("update_prog_bar_max")
    -- net.WriteUInt(nzRound:GetZombiesMax(), 32)
    -- net.Broadcast()
--end

function mapscript.ScriptLoad()
    RemoveStupidDoors()
end

function mapscript.OnGameBegin()
    RemoveStupidDoors()
    
    -- timer.Simple(4, function()
    --     if (nzRound) then
    --         nzRound:SetBossType("None") -- Boss is too hard right now, wait later
    --     end
    -- end)
end

--function mapscript.OnRoundStart(num)
    -- if (!nzRound:IsSpecial() and nzRound:GetNumber() <= 20 and nzRound:GetNumber() > 10) then
    --     DogSpawnForce()
    -- end

    -- -- if (num > 18 and !nzRound:GetBossType()) then
    -- --     PrintMessage(HUD_PRINTTALK, "Panzer spawning is now enabled.")
    -- --     nzRound:SetBossType("Panzer")
    -- --     nzRound:SetNextBossRound(num + math.random(3,5))
    -- --     nzRound:SpawnBoss()
    -- -- end
--end

return mapscript 