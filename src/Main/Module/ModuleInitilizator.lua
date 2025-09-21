local ModuleInitilizator = {}
ModuleInitilizator.__index = ModuleInitilizator

local EveryUpdaterModule = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Updater/EveryUpdater.lua'
))()

function ModuleInitilizator:new()
    local self = setmetatable({}, ModuleInitilizator)
    self.updater = EveryUpdaterModule:new()

    return self
end

return ModuleInitilizator
