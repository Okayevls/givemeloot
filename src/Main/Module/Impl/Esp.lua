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
    ShowBox = false
}

local espData = {}

local function hideOriginalNames(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end

local function createESP(character, name)
    hideOriginalNames(character)

    local highlight = Instance.new("Highlight")
    highlight.Name = name .. "_ESP"
    highlight.Adornee = character
    highlight.FillTransparency = 1
    highlight.OutlineColor = SETTINGS.Color
    highlight.OutlineTransparency = 1 -- скрыт
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = espFolder

    local billboard = Instance.new("BillboardGui")
    billboard.Name = name .. "_Info"
    billboard.Adornee = character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 120, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 1.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = espFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 0.4
    nameLabel.BackgroundColor3 = Color3.new(0,0,0)
    nameLabel.TextColor3 = SETTINGS.Color
    nameLabel.TextSize = 12
    nameLabel.Text = name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.BorderSizePixel = 0
    nameLabel.Visible = false -- скрыт по умолчанию
    nameLabel.Parent = billboard

    return {highlight, billboard, character, nameLabel}
end

local function updateESP(data)
    if not Esp.Enabled then return end

    local highlight, billboard, character, nameLabel = data[1], data[2], data[3], data[4]
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local vec, onScreen = Camera:WorldToViewportPoint(root.Position)

    highlight.OutlineTransparency = onScreen and (SETTINGS.ShowBox and 0 or 1) or 1
    billboard.Enabled = onScreen and SETTINGS.ShowName
    nameLabel.Visible = onScreen and SETTINGS.ShowName
end

local function setupESP(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
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

function Esp:Enable()
    if self.Enabled then return end
    self.Enabled = true
    for _, data in pairs(espData) do
        local highlight, _, _, nameLabel = data[1], data[2], data[3], data[4]
        highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1
        nameLabel.Visible = SETTINGS.ShowName
    end
end

function Esp:Disable()
    self.Enabled = false
    for _, data in pairs(espData) do
        local highlight, _, _, nameLabel = data[1], data[2], data[3], data[4]
        highlight.OutlineTransparency = 1
        nameLabel.Visible = false
        data[2].Enabled = false
    end
end

function Esp:drawModule(MainTab)
    local Folder = MainTab.Folder("ESP", "[Info] Shows player names and boxes")

    Folder.Switch("ESP Enabled", function(Status)
        if Status then self:Enable()
        else self:Disable() end
    end)

    Folder.Switch("Show Box", function(State)
        SETTINGS.ShowBox = State
        if not Esp.Enabled then return end
        for _, data in pairs(espData) do
            data[1].OutlineTransparency = State and 0 or 1
        end
    end)

    Folder.Switch("Show Name", function(State)
        SETTINGS.ShowName = State
        if not Esp.Enabled then return end
        for _, data in pairs(espData) do
            data[4].Visible = State
        end
    end)

    return self
end

return Esp
