local Esp = {}
Esp.__index = Esp

Esp.Enabled = false

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
    ShowName = true,
    ShowBox = true,
    ShowBackground = true,
    BaseSize = 14, -- базовый размер текста
    MaxSize = 20   -- максимальный размер текста
}

local espData = {}

-- Скрываем оригинальные имена
local function hideOriginalNames(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end

-- Создание ESP для игрока
local function createESP(character, name)
    hideOriginalNames(character)

    local highlight = Instance.new("Highlight")
    highlight.Name = name .. "_ESP"
    highlight.Adornee = character
    highlight.FillTransparency = 1
    highlight.OutlineColor = SETTINGS.Color
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = espFolder

    local billboard = Instance.new("BillboardGui")
    billboard.Name = name .. "_Info"
    billboard.Adornee = character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 120, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = espFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Position = UDim2.new(0,0,0,0)
    nameLabel.BackgroundTransparency = SETTINGS.ShowBackground and 0.5 or 1
    nameLabel.BackgroundColor3 = Color3.new(0,0,0)
    nameLabel.TextColor3 = SETTINGS.Color
    nameLabel.TextSize = SETTINGS.BaseSize
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Text = name
    nameLabel.BorderSizePixel = 0
    nameLabel.Visible = SETTINGS.ShowName
    nameLabel.Parent = billboard

    return {highlight, billboard, character, nameLabel}
end

-- Обновление ESP
local function updateESP(data)
    if not Esp.Enabled then return end
    local highlight, billboard, character, nameLabel = data[1], data[2], data[3], data[4]
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then
        highlight.OutlineTransparency = 1
        billboard.Enabled = false
        return
    end

    -- Масштабируем текст в зависимости от расстояния
    local dist = (Camera.CFrame.Position - root.Position).Magnitude
    local scale = math.clamp(SETTINGS.BaseSize * (20 / dist), SETTINGS.BaseSize, SETTINGS.MaxSize)
    nameLabel.TextSize = scale
    nameLabel.BackgroundTransparency = SETTINGS.ShowBackground and 0.5 or 1

    highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1
    billboard.Enabled = SETTINGS.ShowName
    nameLabel.Visible = SETTINGS.ShowName
end

-- Настройка ESP для игрока
local function setupESP(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        espData[plr] = createESP(char, plr.Name)
    end)

    if plr.Character then
        espData[plr] = createESP(plr.Character, plr.Name)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then setupESP(plr) end
end
Players.PlayerAdded:Connect(setupESP)
Players.PlayerRemoving:Connect(function(plr)
    if espData[plr] then
        for _, v in ipairs(espData[plr]) do
            if typeof(v) == "Instance" then v:Destroy() end
        end
        espData[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if not Esp.Enabled then return end
    for _, data in pairs(espData) do
        if data[3] and data[3].Parent then
            updateESP(data)
        end
    end
end)

-- Включение / выключение
function Esp:Enable()
    if self.Enabled then return end
    self.Enabled = true
end

function Esp:Disable()
    self.Enabled = false
    for _, data in pairs(espData) do
        data[1].OutlineTransparency = 1
        data[2].Enabled = false
        data[4].Visible = false
    end
end

-- UI
function Esp:drawModule(MainTab)
    local Folder = MainTab.Folder("ESP", "[Info] Shows player names and boxes")

    Folder.Switch("ESP Enabled", function(Status)
        if Status then self:Enable() else self:Disable() end
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

    return self
end

return Esp
