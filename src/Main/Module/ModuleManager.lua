--local TweenService = game:GetService("TweenService")
--
--local Notifications = {}
--Notifications.__index = Notifications
--
--function Notifications:Init()
--    self.queue = {}
--    self.margin = 6
--end
--
--function Notifications:RecalculatePositions()
--    for i, frame in ipairs(self.queue) do
--        local target = UDim2.new(
--                1, -10 - frame.AbsoluteSize.X,
--                0, 10 + (i - 1) * (frame.AbsoluteSize.Y + self.margin)
--        )
--
--        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
--            Position = target
--        }):Play()
--    end
--end
--
--function Notifications:Send(message, duration)
--    duration = duration or 3
--
--    -- GUI
--    local ScreenGui = game.CoreGui:FindFirstChild("NotificationsGUI")
--    if not ScreenGui then
--        ScreenGui = Instance.new("ScreenGui")
--        ScreenGui.Name = "NotificationsGUI"
--        ScreenGui.Parent = game.CoreGui
--    end
--
--    -- Frame
--    local Frame = Instance.new("Frame")
--    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
--    Frame.BorderSizePixel = 0
--    Frame.BackgroundTransparency = 1
--    Frame.Parent = ScreenGui
--    Frame.Position = UDim2.new(1, 0, 0, -50)
--    Frame.ClipsDescendants = true
--
--    -- Text
--    local Text = Instance.new("TextLabel")
--    Text.BackgroundTransparency = 1
--    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
--    Text.Font = Enum.Font.Gotham
--    Text.TextSize = 14
--    Text.TextWrapped = true
--    Text.Text = message
--    Text.Parent = Frame
--
--    -- временно даём TextLabel большое пространство
--    Text.Size = UDim2.new(0, 1000, 0, 1000)
--    task.wait()
--
--    -- вычисляем полный размер текста
--    local bounds = Text.TextBounds
--    local paddingX = 20
--    local paddingY = 12
--
--    local width = math.clamp(bounds.X + paddingX * 2, 150, 400)
--    local height = math.max(bounds.Y + paddingY, 30)
--
--    -- задаём правильные размеры
--    Frame.Size = UDim2.new(0, width, 0, height)
--    Text.Size = UDim2.new(1, -20, 1, -10)
--    Text.Position = UDim2.new(0, 10, 0, 5)
--
--    -- добавляем в очередь
--    table.insert(self.queue, Frame)
--    self:RecalculatePositions()
--
--    -- показ
--    TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
--        BackgroundTransparency = 0
--    }):Play()
--
--    -- скрытие
--    task.delay(duration, function()
--        if not Frame.Parent then return end
--
--        local hide = TweenService:Create(Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
--            Position = UDim2.new(1, width, 0, Frame.Position.Y.Offset),
--            BackgroundTransparency = 1
--        })
--
--        hide:Play()
--        hide.Completed:Wait()
--
--        if Frame.Parent then
--            Frame:Destroy()
--        end
--
--        -- удаляем из очереди
--        for i, f in ipairs(self.queue) do
--            if f == Frame then
--                table.remove(self.queue, i)
--                break
--            end
--        end
--
--        self:RecalculatePositions()
--    end)
--end
--
--local Notifier = setmetatable({}, Notifications)
--Notifier:Init()

local ModuleManager = {}
ModuleManager.__index = ModuleManager

function ModuleManager:drawCategory(Window, ModuleLoader)
    local loader = ModuleLoader

    loader:Init({
        SilentAim = "src/Main/Module/Impl/SilentAim.lua",
        Fly = "src/Main/Module/Impl/Fly.lua",
        ChatSpy = "src/Main/Module/Impl/ChatSpy.lua",
        RedeemCode = "src/Main/Module/Impl/RedeemCode.lua",
        Esp = "src/Main/Module/Impl/Esp.lua",
        AspectRatio = "src/Main/Module/Impl/AspectRatio.lua",
        NoClip = "src/Main/Module/Impl/NoClip.lua",
        FastInteract = "src/Main/Module/Impl/FastInteract.lua",
        Speed = "src/Main/Module/Impl/Speed.lua"
    })

    local CombatTab = Window:AddTab('Combat')
    local CharacterTab = Window:AddTab('Character')
    local VisualsTab = Window:AddTab('Visuals')
    local PlayersTab = Window:AddTab('Players')
    local MiscTab = Window:AddTab('Misc')
    local UISettingsTab = Window:AddTab('UI Settings')

    local SilentAim = loader:Get("SilentAim"):drawModule(CombatTab)

    local Speed = loader:Get("Speed"):drawModule(CharacterTab)
    local Fly = loader:Get("Fly"):drawModule(CharacterTab)

    local RedeemCode = loader:Get("RedeemCode"):drawModule(MiscTab)

    --local CombatTab = Window.Tab("Combat", 7485051733)
    --local CharacterTab = Window.Tab("Character", 16149111790)
    --local VisualTab = Window.Tab("Visuals", 16149111790)
    --local PlayerTab = Window.Tab("Player", 16149111790)
    --local OtherTab = Window.Tab("Other", 16149111790)
--
    --local SilentAim = loader:Get("SilentAim"):drawModule(CombatTab, Notifier)
--
    --local Esp = loader:Get("Esp"):drawModule(VisualTab, Notifier)
    --local AspectRatio = loader:Get("AspectRatio"):drawModule(VisualTab, Notifier)
--
    --local NoClip = loader:Get("NoClip"):drawModule(PlayerTab, Notifier)
    --local FastInteract = loader:Get("FastInteract"):drawModule(PlayerTab, Notifier)
--
    --local ChatSpy = loader:Get("ChatSpy"):drawModule(OtherTab, Notifier)
    --local AutoRedeem = loader:Get("RedeemCode"):drawModule(OtherTab, Notifier)
--
    print("Base ModuleManager Build | 0x000000000164")
    --Notifier:Send("Base ModuleManager Build | 0x000000000164", 6)
end

return ModuleManager, Notifier
