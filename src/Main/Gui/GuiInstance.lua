local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager, Notifier)
    local Window = GuiRenderer.new("Legacy.wip", "Version : d0.00095", 4370345701)

    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.KeyCode == Enum.KeyCode.RightShift then
            Window:Toggle()
        end
    end)

    ModuleManager:drawCategory(Window, ModuleLoader, Notifier)
end

return GuiInstance
