local GuiRenderer = {}
GuiRenderer.__index = GuiRenderer

GuiRenderer.shapes = {}

local EventLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/EventLoader.lua"))()

function GuiRenderer:drawGui()
    local Render = EventLoader:Get("Render")
    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    Render:drawRoundedRectangle(screenGui, 100, 100, 100, 100, 15, Color3.fromRGB(15, 15, 15), 0.25)
    Chat.chat.sendMessage("Loading gui...")
end


return GuiRenderer