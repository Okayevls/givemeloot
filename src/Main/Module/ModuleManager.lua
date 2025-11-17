
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

    -- animate show
    Frame:TweenPosition(UDim2.new(1, -280, 1, -120), "Out", "Quad", 0.35, true)
    Frame:TweenProperty({ BackgroundTransparency = 0 }, "Out", "Quad", 0.35, true)

    task.delay(duration, function()
        if Frame then
            -- animate hide
            Frame:TweenPosition(UDim2.new(1, -280, 1, 0), "In", "Quad", 0.35, true)
            Frame:TweenProperty({ BackgroundTransparency = 1 }, "In", "Quad", 0.35, true)
            task.wait(0.35)
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

    local SilentAim = loader:Get("SilentAim"):drawModule(CombatTab)
    Notifier:Send("SilentAim loaded")

    local Speed = loader:Get("Speed"):drawModule(CharacterTab)
    Notifier:Send("Speed loaded")

    local Fly = loader:Get("Fly"):drawModule(CharacterTab)
    Notifier:Send("Fly loaded")

    local Esp = loader:Get("Esp"):drawModule(VisualTab)
    Notifier:Send("ESP loaded")

    local ChatSpy = loader:Get("ChatSpy"):drawModule(OtherTab)
    Notifier:Send("ChatSpy loaded")

    local AutoRedeem = loader:Get("AutoRedeem"):drawModule(OtherTab)
    Notifier:Send("AutoRedeem loaded")

    print("Base ModuleManager Build | 0x000000000127")
end

return ModuleManager, Notifier
