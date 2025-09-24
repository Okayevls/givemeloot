
local ModuleLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/ModuleLoader.lua"))()

local modules = {
    Chat    = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua",
    Render  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua",

    Updater = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Update/Updater.lua",
}

ModuleLoader:Init(modules)

local Chat = ModuleLoader:Get("Chat")
Chat.chat.sendMessage("Скрипт запущен!")

local Updater = ModuleLoader:Get("Updater")
local updaterInstance = Updater:new()

local Render = ModuleLoader:Get("Render")
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
Render:drawRoundedRectangle(
        screenGui,
        UDim2.new(0, 200, 0, 100),
        UDim2.new(0.5, 0, 0.5, 0),
        Color3.fromRGB(100, 200, 255),
        20
)
