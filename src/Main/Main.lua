
local ClassLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/ClassLoader.lua"))()

local modules = {
    Chat    = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua",
    Render  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua",
    FontRender  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/UFontRenderer.lua",

    Updater = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Update/Updater.lua",
}

ClassLoader:Init(modules)

local Chat = ClassLoader:Get("Chat")
Chat.chat.sendMessage("Скрипт запущен!")

local Updater = ClassLoader:Get("Updater")
local updaterInstance = Updater:new()

local Render = ClassLoader:Get("Render")
local FontRender = ClassLoader:Get("FontRender")

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

Render:drawRoundedRectangle(screenGui, 100, 50, 200, 100, 5, Color3.fromRGB(255, 255, 255))
FontRender:renderText(screenGui, "Привет, Roblox!", 24, 100, 50, Color3.fromRGB(255, 255, 255))
