local AimBot = {}
AimBot.__index = AimBot

AimBot.type = {}

function AimBot:drawModule(MainTab)
    local Folder = MainTab.Folder("AimBot", "[Info] Automatically finds the target and destroys it")

    Folder.SwitchAndBinding("Silent Aim", function(Status)

    end)
end

return AimBot
