local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "Anomic - vBeta I", 4370345701)

    game:GetService("UserInputService").InputBegan:Connect(function(Input)
        if Input.KeyCode == Enum.KeyCode.M then
            Window:Toggle()
        end
    end)

    ModuleManager:drawCategory(Window, ModuleLoader)
end

return GuiInstance
