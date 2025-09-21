local EveryUpdaterModule = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Updater/EveryUpdater.lua'
))()

local ModuleInitilizator = {}
ModuleInitilizator.__index = ModuleInitilizator

function ModuleInitilizator:new()
    local self = setmetatable({}, ModuleInitilizator)
    self.updater = EveryUpdaterModule:new()

    return self
end

return ModuleInitilizator
