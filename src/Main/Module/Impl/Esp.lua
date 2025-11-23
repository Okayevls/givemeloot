local Esp = {}
Esp.__index = Esp

Esp.Enabled = false
Esp.DistanceMinSize = 10
Esp.DistanceMaxSize = 150

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = CoreGui

local SETTINGS = {
    Color = Color3.fromRGB(255, 255, 255),
    ShowName = false,
    ShowBox = false,
    ShowBackground = false,
    TextSize = 14,
}

local espData = {}

-- Скрываем оригинальные имена
local function hideOriginalNames(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end

-- Создание ESP
local function createESP(character, plrName)
    hideOriginalNames(character)

    -- Дожидаемся HRP
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not root then return end

    -- Head (или FakeHead)
    local head = character:FindFirstChild("Head")
    if not head then
        head = Instance.new("Part")
        head.Name = "FakeHead"
        head.Size = Vector3.new(1,1,1)
        head.Transparency = 1
        head.CanCollide = false
        head.Anchored = false
        head.Parent = character

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = head
        weld.Part1 = root
        weld.Parent = head
    end

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = plrName.."_ESP"
    highlight.Adornee = character
    highlight.FillTransparency = 1
    highlight.OutlineColor = SETTINGS.Color
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = espFolder

    -- BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = plrName.."_Info"
    billboard.Adornee = head
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local headOffset = Vector3.new(0, humanoid and humanoid.HipHeight + 1.2 or 3, 0)
    billboard.StudsOffset = headOffset
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Size = UDim2.fromOffset(Esp.DistanceMaxSize, Esp.DistanceMaxSize*0.2)
    billboard.Parent = espFolder

    -- TextLabel
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = SETTINGS.ShowBackground and 0.5 or 1
    nameLabel.BackgroundColor3 = Color3.new(0,0,0)
    nameLabel.TextColor3 = SETTINGS.Color
    nameLabel.TextSize = SETTINGS.TextSize
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Text = plrName
    nameLabel.BorderSizePixel = 0
    nameLabel.Visible = false
    nameLabel.Parent = billboard

    return {highlight, billboard, character, nameLabel}
end

-- Обновление ESP каждый кадр
local function updateESP(data)
    if not Esp.Enabled then return end

    local highlight, billboard, character, nameLabel = data[1], data[2], data[3], data[4]
    if not character or not character.Parent then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Включение/выключение
    highlight.Enabled = SETTINGS.ShowBox
    highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1

    billboard.Enabled = SETTINGS.ShowName
    nameLabel.Visible = SETTINGS.ShowName
    nameLabel.BackgroundTransparency = SETTINGS.ShowBackground and 0.5 or 1

    -- Динамический размер по дистанции
    local distance = (Camera.CFrame.Position - root.Position).Magnitude
    local sizeX = math.clamp(distance * 0.6, Esp.DistanceMinSize, Esp.DistanceMaxSize)
    local sizeY = sizeX * 0.2
    billboard.Size = UDim2.fromOffset(sizeX, sizeY)
    nameLabel.TextSize = math.clamp(SETTINGS.TextSize * (sizeX / 120), 8, 32) -- масштаб текста
end

-- Настройка ESP на игрока
local function setupESP(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        espData[plr] = createESP(char, plr.Name)
    end)

    if plr.Character then
        espData[plr] = createESP(plr.Character, plr.Name)
    end
end

-- Первые игроки
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        setupESP(plr)
    end
end

-- Новые игроки
Players.PlayerAdded:Connect(setupESP)

-- Уходящие игроки
Players.PlayerRemoving:Connect(function(plr)
    if espData[plr] then
        for _, v in ipairs(espData[plr]) do
            if typeof(v) == "Instance" then v:Destroy() end
        end
        espData[plr] = nil
    end
end)

-- Обновление каждый кадр
RunService.RenderStepped:Connect(function()
    if not Esp.Enabled then return end
    for _, data in pairs(espData) do
        updateESP(data)
    end
end)

-- Включение/выключение ESP
function Esp:Enable()
    if self.Enabled then return end
    self.Enabled = true

    for _, data in pairs(espData) do
        local highlight = data[1]
        local billboard = data[2]
        local nameLabel = data[4]

        highlight.Enabled = SETTINGS.ShowBox
        highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1

        billboard.Enabled = SETTINGS.ShowName
        nameLabel.Visible = SETTINGS.ShowName
    end
end

function Esp:Disable()
    self.Enabled = false

    for _, data in pairs(espData) do
        local highlight = data[1]
        local billboard = data[2]
        local nameLabel = data[4]

        highlight.Enabled = false
        billboard.Enabled = false
        nameLabel.Visible = false
    end
end

-- UI модуль
function Esp:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("ESP", "[Info] Shows players with boxes")

    Folder.Switch("ESP Enabled", function(State)
        if State then
            self:Enable()
            Notifier:Send("ESP Enabled", 4)
        else
            self:Disable()
            Notifier:Send("ESP Disabled", 4)
        end
    end)

    Folder.Switch("Show Box", function(State)
        SETTINGS.ShowBox = State
    end)

    Folder.Switch("Show Name", function(State)
        SETTINGS.ShowName = State
    end)

    Folder.Switch("Show Background", function(State)
        SETTINGS.ShowBackground = State
    end)

    Folder.Slider("Distance Render Max Size", { Min = 50, Max = 500, Default = 150, Step = 5 }, function(value)
        self.DistanceMaxSize = value
    end)

    Folder.Slider("Distance Render Min Size", { Min = 5, Max = 50, Default = 10, Step = 1 }, function(value)
        self.DistanceMinSize = value
    end)

    return self
end

return Esp
