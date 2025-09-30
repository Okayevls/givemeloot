local GuiInstance = {}
GuiInstance.__index = GuiInstance

GuiInstance.type = {}

function GuiInstance:drawGuiCore(ModuleLoader, GuiRenderer, ModuleManager)
    local Window = GuiRenderer.new("Morphis", "Anomic - vBeta I", 4370345701)

    local UserInputService = game:GetService("UserInputService")
    local debounce = false

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightShift then
            if debounce then return end
            debounce = true
            Window:Toggle()
            delay(0.2, function() debounce = false end)
        end
    end)

    ModuleManager:drawCategory(Window, ModuleLoader)
end

return GuiInstance
