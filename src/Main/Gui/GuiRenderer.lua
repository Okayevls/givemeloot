local GuiRenderer = {}
GuiRenderer.__index = GuiRenderer

GuiRenderer.shapes = {}

function GuiRenderer:drawGui(DrawLoader, ChatLoader)
    local Render = DrawLoader
    local Chat = ChatLoader
    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    Render:drawRoundedRectangle(screenGui, 100, 100, 100, 100, 15, Color3.fromRGB(15, 15, 15), 0.25)
    Chat:sendMessage("Loading gui...")
end


return GuiRenderer