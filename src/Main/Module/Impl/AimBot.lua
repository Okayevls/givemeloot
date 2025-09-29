local AimBot = {}
AimBot.__index = AimBot

AimBot.type = {}

-- Метод, который будет вызван из ModuleManager:drawCategory
function AimBot:drawModule(MainTab)
    -- Проверяем, что MainTab существует
    if not MainTab or not MainTab.Folder then
        warn("[AimBot] MainTab или метод Folder не найден")
        return
    end

    -- Создаём Folder
    local Folder = MainTab:Folder("AimBot", "[Info] Automatically finds the target and destroys it")
    if not Folder then
        warn("[AimBot] Folder не создан")
        return
    end

    -- Добавляем элементы GUI
    if Folder.SwitchAndBinding then
        Folder:SwitchAndBinding("Enable AimBot", function(Status)
            print("[AimBot] Enabled:", Status)
            self.Enabled = Status
        end)
    end

    if Folder.Slider then
        Folder:Slider("Aimbot FOV", 10, 360, 90, function(Value)
            print("[AimBot] FOV:", Value)
            self.FOV = Value
        end)
    end
end

return AimBot
