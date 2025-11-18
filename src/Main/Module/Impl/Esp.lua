local Esp = {}
Esp.__index = Esp

Esp.Enabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Папка для ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = CoreGui

-- Настройки ESP
local SETTINGS = {
    BoxSize = Vector2.new(50, 50), -- размер кубика
    RainbowSpeed = 2,              -- скорость переливания
}

local espData = {}

-- Генератор переливающегося цвета (двухцветного)
local function rainbowColor(t)
    local r = math.sin(t) * 0.5 + 0.5
    local g = math.sin(t + 2) * 0.5 + 0.5
    local b = math.sin(t + 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

-- Создание 2D кубика ESP
local function createESP(character)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, SETTINGS.BoxSize.X, 0, SETTINGS.BoxSize.Y)
    box.BorderSizePixel = 2
    box.BackgroundTransparency = 0.5
    box.Position = UDim2.new(0, 0, 0, 0)
    box.Parent = espFolder

    return {box = box, character = character}
end

-- Обновление позиции и цвета кубика
local function updateESP(data, time)
    local char = data.character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        data.box.Visible = false
        return
    end

    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
    data.box.Position = UDim2.new(0, screenPos.X - SETTINGS.BoxSize.X/2, 0, screenPos.Y - SETTINGS.BoxSize.Y/2)
    data.box.Visible = onScreen

    -- Переливающийся двухцветный эффект
    local color1 = rainbowColor(time * SETTINGS.RainbowSpeed)
    local color2 = rainbowColor(time * SETTINGS.RainbowSpeed + math.pi)
    data.box.BackgroundColor3 = color1:Lerp(color2, 0.5)
end

-- Настройка ESP для всех игроков
local function setupESP(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        espData[plr] = createESP(char)
    end)

    if plr.Character then
        espData[plr] = createESP(plr.Character)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then setupESP(plr) end
end
Players.PlayerAdded:Connect(setupESP)
Players.PlayerRemoving:Connect(function(plr)
    if espData[plr] then
        espData[plr].box:Destroy()
        espData[plr] = nil
    end
end)

-- Главный цикл обновления
RunService.RenderStepped:Connect(function()
    if not Esp.Enabled then return end
    local time = tick()
    for _, data in pairs(espData) do
        if data.character and data.character.Parent then
            updateESP(data, time)
        end
    end
end)

-- Включение / выключение ESP
function Esp:Enable()
    self.Enabled = true
    for _, data in pairs(espData) do
        data.box.Visible = true
    end
end

function Esp:Disable()
    self.Enabled = false
    for _, data in pairs(espData) do
        data.box.Visible = false
    end
end

function Esp:drawModule(MainTab)
    local Folder = MainTab.Folder("ESP", "[Info] 2D Rainbow ESP Cubes")

    Folder.Switch("ESP Enabled", function(Status)
        if Status then
            self:Enable()
        else
            self:Disable()
        end
    end)

    return self
end

return Esp
