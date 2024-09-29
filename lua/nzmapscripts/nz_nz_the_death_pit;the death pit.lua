local mapscript = {} 

-- these are the only waves that logic_waves should care about when nz_forceround is used
local whitelisted_waves = {
    [3] = true,
    [5] = true,
    [7.5] = true,
    [17] = true,
}

function mapscript.ScriptLoad()
    hook.Add("OnForcedLogicWaves_onwavestart", "deathpit_fixAutoWaveStart", function(wave)
        if !whitelisted_waves[wave] then return false end
    end)

    hook.Add("OnForcedLogicWaves_onwaveend", "deathpit_fixAutoWaveEnd", function(wave)  
        if !whitelisted_waves[wave] then return false end
    end)
end

function mapscript.ScriptUnload()
    hook.Remove("OnForcedLogicWaves_onwavestart", "deathpit_fixAutoWaveStart")
    hook.Remove("OnForcedLogicWaves_onwaveend", "deathpit_fixAutoWaveEnd")
end

return mapscript
