local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

local InputService = game:GetService('UserInputService');

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    local Window = GuiRenderer:CreateWindow({
        Title = '                     $ Legacy.wip | v0.00094 $                     ',
        AutoShow = true,
        TabPadding = 15,
        MenuFadeTime = 0.2
    })

    ModuleManager:drawCategory(Window, ModuleLoader)
    --local Window = GuiRenderer.new("Legacy.wip", "Version : d0.00094", 4370345701)
    --
    --local UserInputService = game:GetService("UserInputService")
    --UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    --    if GameProcessed then return end
    --    if Input.KeyCode == Enum.KeyCode.RightShift then
    --        Window:Toggle()
    --    end
    --end)
    --
    --ModuleManager:drawCategory(Window, ModuleLoader)
end

return GuiInstance
