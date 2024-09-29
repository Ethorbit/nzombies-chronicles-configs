local mapscript = {}

-- Choose either CIA or CDC as the model pack
function mapscript.PickCIA_or_CDC()
    local rand = math.random(1, 2)
    if (rand == 1) then -- It's CDC
        nzMapping.Settings.modelpack = {
            [1] = {
                ["Bodygroups"] = "",
                ["Path"] = "models/player/cdc_soldier_player.mdl",
                ["Skin"] = 0
            }
        }

        print("CHOSE CDC")
    else -- It's CIA
        nzMapping.Settings.modelpack = {
            [1] = {
                ["Bodygroups"] = "",
                ["Path"] = "models/player/bo2/cia/nzc_cia_pm.mdl",
                ["Skin"] = 0
            }
        }

        print("CHOSE CIA")
    end
end

-- Choose CIA or CDC (This is OK since the model system applies at the START of a round):
function mapscript.ScriptLoad()
    mapscript.PickCIA_or_CDC()
end

function mapscript.OnRoundEnd()
    mapscript.PickCIA_or_CDC()
end

return mapscript 