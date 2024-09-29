local mapscript = {}

local function LetThereBeLight()
    ents.FindByName("power")[1]:Input("Open", Entity(0), Entity(0))
end

function mapscript.ScriptLoad()
    LetThereBeLight()
end

function mapscript.OnGameBegin()
    LetThereBeLight()
end

return mapscript