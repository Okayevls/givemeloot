-- Notifications.lua
local TweenService = game:GetService("TweenService")

local Notifications = {}
Notifications.__index = Notifications

function Notifications:Init()
    self.queue = {} -- очередь уведомлений
    self.margin = 6 -- отступ между уведомлениями
    self.width = 200 -- ширина уведомления
    self.height = 30 -- высота уведомления
end

-- Обновление позиции всех уведомлений
function Notifications:UpdatePositions()
    local yOffset = 10
    for _, frame in ipairs(self.queue) do
        local targetPos = UDim2.new(1, -10 - self.width, 0, yOffset) -- справа сверху
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPos
        }):Play()
        yOffset = yOffset + self.height + self.margin
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
    Frame.Size = UDim2.new(0, self.width, 0, self.height)
    Frame.Position = UDim2.new(1, -10 - self.width, 0, -self.height) -- стартовая позиция скрыта сверху
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0,0)
    Frame.Parent = ScreenGui
    Frame.ClipsDescendants = true

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -10, 1, 0)
    Text.Position = UDim2.new(0,5,0,0)
    Text.BackgroundTransparency = 1
    Text.Text = message
    Text.TextColor3 = Color3.fromRGB(255,255,255)
    Text.TextSize = 14
    Text.Font = Enum.Font.Gotham
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Center
    Text.Parent = Frame

    table.insert(self.queue, Frame)
    self:UpdatePositions()

    -- Плавное появление
    TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -10 - self.width, 0, 10 + (#self.queue-1)*(self.height + self.margin))
    }):Play()

    -- Таймер на исчезновение
    task.delay(duration, function()
        if Frame and Frame.Parent then
            local hideTween = TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, -10 - self.width, 0, -self.height),
                BackgroundTransparency = 1
            })
            hideTween:Play()
            hideTween.Completed:Wait()

            if Frame.Parent then
                Frame:Destroy()
            end

            for i, f in ipairs(self.queue) do
                if f == Frame then
                    table.remove(self.queue, i)
                    break
                end
            end
            self:UpdatePositions()
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

    print("Base ModuleManager Build | 0x000000000134")
end

return ModuleManager, Notifier
