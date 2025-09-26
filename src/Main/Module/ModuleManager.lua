local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

ModuleLoader.type = {}

local EventLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/ModuleLoader.lua"))()

local modules = {
    DesyncPosition = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Impl/DesyncPosition.lua",
}

function ModuleLoader:drawAllModule(Tabs)
    EventLoader:Init(modules)
    local desyncLoader = EventLoader:Get("DesyncPosition"):drawModule(Tabs)
end

return ModuleLoader
