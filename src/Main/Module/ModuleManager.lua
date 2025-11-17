-- Notifications Module (separate)
local TweenService = game:GetService("TweenService")

local Notifications = {}
Notifications.__index = Notifications

function Notifications:Init()
    self.queue = {}
end

function Notifications:Send(message, duration)
    duration = duration or 3

    local ScreenGui = game.CoreGui:FindFirstChild("NotificationsGUI")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "NotificationsGUI"
        ScreenGui.Parent = game.CoreGui
    end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 260, 0, 42)
    Frame.Position = UDim2.new(1, -280, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScreenGui

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -14, 1, 0)
    Text.Position = UDim2.new(0, 7, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = message
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextSize = 18
    Text.Font = Enum.Font.GothamMedium
    Text.Parent = Frame

    -- Tween configs
    local showTween = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -280, 1, -120),
        BackgroundTransparency = 0
    })

    local hideTween = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, -280, 1, 0),
        BackgroundTransparency = 1
    })

    showTween:Play()

    task.delay(duration, function()
        if Frame then
            hideTween:Play()
            hideTween.Completed:Wait()
            Frame:Destroy()
        end
    end)
end

local Notifier = setmetatable({}, Notifications)
Notifier:Init()

local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader)
    local loader = ModuleLoader

    loader:Init({
        SilentAim = "src/Main/Module/Impl/SilentAim.lua",
        Fly = "src/Main/Module/Impl/Fly.lua",
        ChatSpy = "src/Main/Module/Impl/ChatSpy.lua",
        AutoRedeem = "src/Main/Module/Impl/AutoRedeem.lua",
        Esp = "src/Main/Module/Impl/Esp.lua",
        Speed = "src/Main/Module/Impl/Speed.lua"
    })

    local CombatTab = Window.Tab("Combat", 7485051733)
    local CharacterTab = Window.Tab("Character", 16149111790)
    local VisualTab = Window.Tab("Visuals", 16149111790)
    local OtherTab = Window.Tab("Other", 16149111790)

    local SilentAim = loader:Get("SilentAim"):drawModule(CombatTab, Notifier)

    local Speed = loader:Get("Speed"):drawModule(CharacterTab)
    local Fly = loader:Get("Fly"):drawModule(CharacterTab)

    local Esp = loader:Get("Esp"):drawModule(VisualTab)

    local ChatSpy = loader:Get("ChatSpy"):drawModule(OtherTab)
    local AutoRedeem = loader:Get("AutoRedeem"):drawModule(OtherTab)

    print("Base ModuleManager Build | 0x000000000130")
end

return ModuleManager, Notifier
