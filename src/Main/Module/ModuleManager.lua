-- Notifications.lua
local TweenService = game:GetService("TweenService")

local Notifications = {}
Notifications.__index = Notifications

function Notifications:Init()
    self.queue = {} -- очередь уведомлений
    self.margin = 10 -- отступ между уведомлениями
end

-- функция для обновления позиции всех уведомлений
function Notifications:UpdatePositions()
    local yOffset = 10
    for _, frame in ipairs(self.queue) do
        local targetPos = UDim2.new(0, 10, 0, yOffset)
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPos
        }):Play()
        yOffset = yOffset + frame.Size.Y.Offset + self.margin
    end
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
    Frame.Size = UDim2.new(0, 250, 0, 40)
    Frame.Position = UDim2.new(0, 10, 0, -50) -- сначала скрыто сверху
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 0
    Frame.BackgroundTransparency = 0.05
    Frame.AnchorPoint = Vector2.new(0, 0)
    Frame.Parent = ScreenGui
    Frame.ClipsDescendants = true
    Frame.Rounded = 8

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -14, 1, 0)
    Text.Position = UDim2.new(0, 7, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = message
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextSize = 16
    Text.Font = Enum.Font.Gotham
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    table.insert(self.queue, Frame)
    self:UpdatePositions()

    -- плавное появление
    Frame.Position = UDim2.new(0, 10, 0, -50)
    TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = Frame.Position
    }):Play()

    -- скрытие после duration
    task.delay(duration, function()
        if Frame then
            TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 10, 0, -50),
                BackgroundTransparency = 1
            }):Play()

            task.delay(0.35, function()
                Frame:Destroy()
                for i, f in ipairs(self.queue) do
                    if f == Frame then
                        table.remove(self.queue, i)
                        break
                    end
                end
                self:UpdatePositions()
            end)
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

    print("Base ModuleManager Build | 0x000000000132")
end

return ModuleManager, Notifier
