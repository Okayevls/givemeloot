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
    ShowName = false,
    ShowBox = false,
    ShowBackground = false,
    TextSize = 14,
}

local espData = {}

-- Скрываем оригинальные имена игроков
local function hideOriginalNames(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end

-- Создание ESP объектов
local function createESP(character, plrName)
    hideOriginalNames(character)

    -- Дожидаемся HRP
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not root then return end -- если персонаж кастомный и нет HRP

    -- На случай отсутствия головы
    local head = character:FindFirstChild("Head")
    if not head then
        -- создадим пустую точку, привязанную к HRP
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
    highlight.Name = plrName .. "_ESP"
    highlight.Adornee = character
    highlight.FillTransparency = 1
    highlight.OutlineColor = SETTINGS.Color
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false -- ❗ Полностью выключаем при создании
    highlight.Parent = espFolder


    -- BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = plrName .. "_Info"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 120, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = espFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = SETTINGS.Color
    nameLabel.TextSize = SETTINGS.TextSize
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Text = plrName
    nameLabel.BorderSizePixel = 0
    nameLabel.Visible = false
    nameLabel.Parent = billboard

    -- ВОЗВРАЩАЕМ датасет
    return {highlight, billboard, character, nameLabel}
end

-- Обновление ESP
local function updateESP(data)
    if not Esp.Enabled then return end

    local highlight, billboard, character, nameLabel = data[1], data[2], data[3], data[4]
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1
    billboard.Enabled = SETTINGS.ShowName
    nameLabel.Visible = SETTINGS.ShowName
    nameLabel.BackgroundTransparency = SETTINGS.ShowBackground and 0.5 or 1
end

-- Подключение ESP к игроку
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
            if typeof(v) == "Instance" then
                v:Destroy()
            end
        end
        espData[plr] = nil
    end
end)

-- Обновление каждый кадр
RunService.RenderStepped:Connect(function()
    if not Esp.Enabled then return end
    for _, data in pairs(espData) do
        if data[3] and data[3].Parent then
            updateESP(data)
        end
    end
end)

-- Включение
function Esp:Enable()
    if self.Enabled then return end
    self.Enabled = true

    for _, data in pairs(espData) do
        local highlight = data[1]
        local billboard = data[2]
        local nameLabel = data[4]

        highlight.Enabled = true
        highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1

        billboard.Enabled = SETTINGS.ShowName
        nameLabel.Visible = SETTINGS.ShowName
    end
end


-- Выключение
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
        if self.Enabled then
            for _, data in pairs(espData) do
                data[1].OutlineTransparency = State and 0 or 1
            end
        end
    end)

    Folder.Switch("Show Name", function(State)
        SETTINGS.ShowName = State
        if self.Enabled then
            for _, data in pairs(espData) do
                data[4].Visible = State
                data[2].Enabled = State
            end
        end
    end)

    Folder.Switch("Show Background", function(State)
        SETTINGS.ShowBackground = State
        if self.Enabled then
            for _, data in pairs(espData) do
                data[4].BackgroundTransparency = State and 0.5 or 1
            end
        end
    end)

    return self
end

return Esp
