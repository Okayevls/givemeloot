local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

ModuleLoader.type = {}

local EventLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/ModuleLoader.lua"))()

local modules = {
    desyncLoader = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Impl/DesyncPosition.lua",
}

function ModuleLoader:drawAllModule(Tabs)
    EventLoader:Init(modules)
    local desyncLoader = EventLoader:Get("desyncLoader"):drawModule(Tabs)
end

return ModuleLoader
