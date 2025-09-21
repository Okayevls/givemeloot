local ModuleInitilizator = {}
ModuleInitilizator.__index = ModuleInitilizator

ModuleInitilizator.get = {}

local EveryUpdaterModule = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Updater/EveryUpdater.lua'
))()

function ModuleInitilizator.get.new()
    local self = setmetatable({}, ModuleInitilizator)
    self.updater = EveryUpdaterModule:new()

    return self
end

return ModuleInitilizator
