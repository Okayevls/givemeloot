local Esp = {}
Esp.__index = Esp

Esp.Enabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = CoreGui

local SETTINGS = {
    Color = Color3.fromRGB(255, 255, 255),
    ShowName = true,
    ShowBox = true,
    ShowTracer = true
}

local espData = {}

local function hideOriginalNames(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end

local function fadeInLabel(label)
    label.TextTransparency = 1
    label.Visible = true
    TweenService:Create(label, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        TextTransparency = 0
    }):Play()
end

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
    billboard.StudsOffset = Vector3.new(0, 1.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Parent = espFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 0.4
    nameLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    nameLabel.TextColor3 = SETTINGS.Color
    nameLabel.TextSize = 12
    nameLabel.Text = name
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.BorderSizePixel = 0
    nameLabel.Visible = false
    nameLabel.Parent = billboard

    local tracer = Instance.new("Frame")
    tracer.Name = name .. "_Tracer"
    tracer.BackgroundColor3 = SETTINGS.Color
    tracer.BorderSizePixel = 0
    tracer.Size = UDim2.new(0, 1, 0, 1)
    tracer.Visible = false
    tracer.Parent = espFolder

    return {highlight, billboard, tracer, character, nameLabel}
end

local function updateESP(data)
    if not Esp.Enabled then return end

    local highlight, billboard, tracer, character = data[1], data[2], data[3], data[4]
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local vec, onScreen = Camera:WorldToViewportPoint(root.Position)

    highlight.OutlineTransparency = onScreen and (SETTINGS.ShowBox and 0 or 1) or 1
    billboard.Enabled = onScreen and SETTINGS.ShowName or false

    tracer.Visible = onScreen and SETTINGS.ShowTracer or false
    if tracer.Visible then
        tracer.Position = UDim2.new(0, vec.X, 0, vec.Y)
        tracer.Size = UDim2.new(0, 100, 0, 1)
    end
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
        if data[4] and data[4].Parent then
            updateESP(data)
        end
    end
end)

function Esp:Enable()
    if self.Enabled then return end
    self.Enabled = true
    for _, data in pairs(espData) do
        local highlight, billboard = data[1], data[2]
        highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1
        billboard.Enabled = SETTINGS.ShowName
    end
end

function Esp:Disable()
    self.Enabled = false
    for _, data in pairs(espData) do
        local highlight, billboard, tracer = data[1], data[2], data[3]
        highlight.OutlineTransparency = 1
        billboard.Enabled = false
        tracer.Visible = false
    end
end

function Esp:drawModule(MainTab)
    local Folder = MainTab.Folder("Esp", "[Info] Shows all players")

    Folder.Switch("ESP Enabled", function(Status)
        if Status then self:Enable() else self:Disable() end
    end)

    Folder.Switch("Show Box", function(State)
        SETTINGS.ShowBox = State
        if not Esp.Enabled then return end
        for _, data in pairs(espData) do
            local highlight = data[1]
            highlight.OutlineTransparency = State and 0 or 1
        end
    end)

    Folder.Switch("Show Name", function(State)
        SETTINGS.ShowName = State
        if not Esp.Enabled then return end
        for _, data in pairs(espData) do
            local billboard = data[2]
            billboard.Enabled = State
        end
    end)

    return self
end

return Esp
