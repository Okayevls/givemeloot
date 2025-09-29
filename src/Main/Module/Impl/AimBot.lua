local AimBot = {}
AimBot.__index = AimBot

AimBot.type = {}

function AimBot:drawModule(MainTab)
    local Folder = MainTab.Folder("AimBot", "[Info] Automatically finds the target and destroys it")

    Folder.SwitchAndBinding("Enable AimBot", function(Status)
        print("[AimBot] Enabled:", Status)
        self.Enabled = Status
    end)

    Folder.Slider("Aimbot FOV", 10, 360, 90, function(Value)
        print("[AimBot] FOV:", Value)
        self.FOV = Value
    end)
end

return AimBot
