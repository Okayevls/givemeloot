local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StaffList = {}
StaffList.__index = StaffList

StaffList.Enabled = false
StaffList.Gui = nil

-- Создание GUI
function StaffList:CreateGui()
    if self.Gui then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StaffListGUI"
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    self.Gui = screenGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 100) -- временная высота
    mainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.AnchorPoint = Vector2.new(0.5, 0)
    mainFrame.Parent = screenGui
    mainFrame.Name = "StaffList"

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 15)
    uiCorner.Parent = mainFrame

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Staff List"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = mainFrame
    self.Title = title

    -- Разделитель
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -20, 0, 2)
    separator.Position = UDim2.new(0, 10, 0, 45)
    separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    separator.BackgroundTransparency = 0.8
    separator.Parent = mainFrame
    self.Separator = separator

    -- Контейнер для списка
    local staffContainer = Instance.new("Frame")
    staffContainer.Size = UDim2.new(1, 0, 0, 0) -- динамическая высота
    staffContainer.Position = UDim2.new(0, 0, 0, 50)
    staffContainer.BackgroundTransparency = 1
    staffContainer.Parent = mainFrame
    self.StaffContainer = staffContainer

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.FillDirection = Enum.FillDirection.Vertical
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Parent = staffContainer
    self.ListLayout = uiListLayout

    -- Движение окна мышкой
    local dragging = false
    local dragInput, dragStart, startPos

    local function updatePosition(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updatePosition(input)
        end
    end)
end

-- Обновление списка на основе данных с сервера
function StaffList:UpdateListWithData(moderators)
    local staffContainer = self.StaffContainer
    staffContainer:ClearAllChildren()

    if #moderators == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "IsEmpty :)"
        emptyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        emptyLabel.Font = Enum.Font.GothamItalic
        emptyLabel.TextSize = 18
        emptyLabel.Parent = staffContainer
    else
        for _, name in ipairs(moderators) do
            local staffEntry = Instance.new("Frame")
            staffEntry.Size = UDim2.new(1, -20, 0, 30)
            staffEntry.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            staffEntry.BackgroundTransparency = 0.15
            staffEntry.BorderSizePixel = 0
            staffEntry.Parent = staffContainer

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 10, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextSize = 18
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = staffEntry

            local statusLabel = Instance.new("TextLabel")
            statusLabel.Size = UDim2.new(0.3, -10, 1, 0)
            statusLabel.Position = UDim2.new(0.7, 0, 0, 0)
            statusLabel.BackgroundTransparency = 1
            statusLabel.Text = "Online"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            statusLabel.Font = Enum.Font.GothamBold
            statusLabel.TextSize = 16
            statusLabel.TextXAlignment = Enum.TextXAlignment.Right
            statusLabel.Parent = staffEntry
        end
    end

    -- Обновляем высоту после RenderStepped, чтобы AbsoluteContentSize точно обновился
    RunService.RenderStepped:Wait()
    local totalHeight = 50 + self.ListLayout.AbsoluteContentSize.Y + 10
    self.Gui.StaffList.Size = UDim2.new(0, 300, 0, totalHeight)
end

function StaffList:Enable()
    if self.Enabled then return end
    self.Enabled = true
    self:CreateGui()

    -- Подписка на RemoteEvent с сервера
    local StaffEvent = ReplicatedStorage:WaitForChild("StaffListUpdate")
    if not self.RemoteConnection then
        self.RemoteConnection = StaffEvent.OnClientEvent:Connect(function(moderators)
            if self.Enabled then
                self:UpdateListWithData(moderators)
            end
        end)
    end
end

function StaffList:Disable()
    self.Enabled = false
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
    if self.RemoteConnection then
        self.RemoteConnection:Disconnect()
        self.RemoteConnection = nil
    end
end

function StaffList:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("StaffList", "[Info] moderator checker")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] StaffList - Enable!", 6)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] StaffList - Disable!", 6)
            self:Disable()
        end
    end)

    return self
end

return StaffList
