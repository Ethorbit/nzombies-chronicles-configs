-- Recreation of the FFGS Moon Boss by: Ethorbit
-- I've decided to ditch logic_waves for more
-- control over the boss (I'm aware of GMMapScript)
local mapscript = {}
mapscript.BossTripped = false

function mapscript.StopSong()
    BroadcastLua("timer.Destroy('GilmanBossMusic')")
    BroadcastLua("EasterEggData.StopSong()")
end

function mapscript.BossSpawning()
    mapscript.BossHealth = 300000 + ((#player.GetAllPlaying() - 1) * 15000)

    hook.Add("Think", "FindGilmanAndFix", function() -- Identify boss
        local ent = ents.FindByName("nz_thefuckingmoon_relay_pt1_breakable")[1]
        if (IsValid(ent)) then
            ent:SetHealth(mapscript.BossHealth) 
            ent.dontbreak = true
            mapscript.Boss = ent
            hook.Remove("Think", "FindGilmanAndFix")

            -- Custom boss music
            BroadcastLua([[EasterEggData.StopSong() EasterEggData.PlaySong("http://chronzombies.site.nfoservers.com/server/songs/Extreme%20Music%20-%20Combat%20Ready%20(Epic%20Hybrid%20Action%20Rock).mp3")]])
            BroadcastLua([[timer.Create("GilmanBossMusic", 90, 0, function() EasterEggData.StopSong() EasterEggData.PlaySong("http://chronzombies.site.nfoservers.com/server/songs/Extreme%20Music%20-%20Combat%20Ready%20(Epic%20Hybrid%20Action%20Rock).mp3") end)]])

            timer.Create("GilmanBossWarning", 300, 0, function()
                local textEnt = ents.FindByName("nz_thefuckingmoon_relay_pt2_text")[1]
                local textEnt2 = ents.FindByName("nz_thefuckingmoon_relay_pt2_text")[2]
                if (IsValid(textEnt)) then
                    textEnt:Fire("Display")
                end

                if (IsValid(textEnt2)) then
                    textEnt2:Fire("Display")
                end
            end)
        end
    end)

    hook.Add("EntityTakeDamage", "NZGilmanBossDamage", function(target, dmginfo) -- Handle damage because apparently damage doesn't affect it
        -- Gilmancity uses (probably) trigger texture for its func_breakable, which projectiles don't register as hitting
        -- This workaround fixes that by forcing the target to it.
        if IsValid(target) and target:IsScripted() then
            for _,ent in pairs(ents.FindInSphere(target:GetPos(), 100)) do
                if ent:GetClass() == "func_breakable" then
                    target = ent
                end
            end
        end

        if (target == mapscript.Boss) then
            -- Some weapons can deal infinite damage, instantly killing the boss
            if (dmginfo:GetDamage() > 8000) then
                dmginfo:SetDamage(8000)
            end

            -- Server's Deathmachine does WAY more damage, set it to something that won't immediately destroy it
            local inflictor = dmginfo:GetInflictor()
            local wep
            if (IsValid(inflictor) and inflictor:IsPlayer()) then
                wep = inflictor:GetActiveWeapon()
            else
                wep = inflictor
            end

            if (IsValid(wep) and wep:GetClass() == "nz_death_machine") then
                dmginfo:SetDamage(8000)
            end

            -- Handle health here (because again, gmod is retarded)
            mapscript.BossHealth = mapscript.BossHealth - dmginfo:GetDamage()
            if (mapscript.BossHealth <= 0) then
                mapscript.Boss:Fire("Break")
                mapscript.BossTripped = false
                mapscript.StopSong()
                timer.Destroy("GilmanBossWarning")
            else
                PrintMessage(HUD_PRINTCONSOLE, "Moon's health: " .. mapscript.BossHealth)
            end
        end
    end)
end

function mapscript.RemoveHooks()
    timer.Destroy("GilmanBossWarning")
    mapscript.StopSong()
    hook.Remove("OnEntityCreated", "FindGilmanAndFix")
    hook.Remove("EntityTakeDamage", "NZGilmanBossDamage")
end

function mapscript.ScriptUnload()
    timer.Destroy("GilmanBossWarning")
    mapscript.RemoveHooks()
    mapscript.StopSong()
end

function mapscript.TriggerRelay(relay)
    if (IsValid(relay)) then
        relay:Fire("Trigger")
    end
end

function mapscript.GetBossRelay(num)
    mapscript.BossTripped = true
    return ents.FindByName("nz_thefuckingmoon_relay_pt" .. num)[1]
end

-- Handle boss spawns just like the logic_wave would
function mapscript.OnRoundPreparation(round)
    if (round == 28) then
        mapscript.TriggerRelay(mapscript.GetBossRelay(1))
        mapscript.BossSpawning()
    elseif (round == 29 and IsValid(mapscript.Boss) and mapscript.BossTripped) then
        mapscript.TriggerRelay(mapscript.GetBossRelay(2))
    elseif (round == 30 and IsValid(mapscript.Boss) and mapscript.BossTripped) then
        mapscript.TriggerRelay(mapscript.GetBossRelay(3))

        timer.Simple(25, function()
            if (nzRound:GetNumber() >= 30 and nzRound:InProgress()) then
                for _,v in pairs(player.GetAll()) do
                    if (v:Alive()) then
                        v:Kill()
                        mapscript.StopSong()
                    end
                end
            end
        end)
    end
end

-- Pick up any boss leftovers when the game ends
function mapscript.OnRoundEnd()
    if (mapscript.BossTripped) then
        mapscript.TriggerRelay(ents.FindByName("nz_thefuckingmoon_relay_win")[1])
        mapscript.BossTripped = false
    end

    mapscript.RemoveHooks()
    mapscript.StopSong()
end

return mapscript
