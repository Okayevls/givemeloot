
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

Render:drawRoundedRectangle(screenGui, 100, 50, 200, 100, 5, Color3.fromRGB(255, 255, 255))