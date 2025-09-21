local ModuleInitilizator = {}
ModuleInitilizator.__index = ModuleInitilizator

local EveryUpdaterModule = loadstring(game:HttpGet(
        'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Updater/EveryUpdater.lua'
))()

function ModuleInitilizator:new()
    print("111111")
end

return ModuleInitilizator
