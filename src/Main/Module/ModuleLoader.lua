local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

ModuleLoader.type = {}

local desyncLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Impl/DesyncPosition.lua"))()

function ModuleLoader:drawAllModule(Tabs)
    desyncLoader:drawModule(Tabs)
end

return ModuleLoader
