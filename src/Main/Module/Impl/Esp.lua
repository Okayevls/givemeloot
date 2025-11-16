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
    Enabled = true,
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

local function animateTag(tag, color)
    tag.TextColor3 = color
    tag.BackgroundColor3 = Color3.new(0, 0, 0)
    tag.BackgroundTransparency = 1
    tag.TextTransparency = 1
    tag.Visible = true

    TweenService:Create(tag, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.4,
        TextTransparency = 0
    }):Play()

    task.wait(2)

    TweenService:Create(tag, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    }):Play()

    task.wait(1)
    tag.Visible = false
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
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = espFolder

    local billboard = Instance.new("BillboardGui")
    billboard.Name = name .. "_Info"
    billboard.Adornee = character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 120, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 1.8, 0)
    billboard.AlwaysOnTop = true
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
    nameLabel.Parent = billboard

    local statusTag = Instance.new("TextLabel")
    statusTag.Size = UDim2.new(1, 0, 1, 0)
    statusTag.BackgroundTransparency = 1
    statusTag.TextTransparency = 1
    statusTag.Font = Enum.Font.GothamBold
    statusTag.TextSize = 12
    statusTag.BorderSizePixel = 0
    statusTag.Visible = false
    statusTag.Parent = billboard

    local tracer = Instance.new("Frame")
    tracer.Name = name .. "_Tracer"
    tracer.BackgroundColor3 = SETTINGS.Color
    tracer.BorderSizePixel = 0
    tracer.Size = UDim2.new(0, 1, 0, 1)
    tracer.Visible = false
    tracer.Parent = espFolder

    task.spawn(function()
        nameLabel.Visible = false
        highlight.Enabled = false
        statusTag.Text = "Spawned"
        animateTag(statusTag, Color3.fromRGB(0, 200, 0))
        fadeInLabel(nameLabel)
        highlight.Enabled = SETTINGS.ShowBox
    end)

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            nameLabel.Visible = false
            highlight.Enabled = false
            statusTag.Text = "Died"
            animateTag(statusTag, Color3.fromRGB(200, 0, 0))
        end)
    end

    return {highlight, billboard, tracer, character}
end

local function updateESP(data)
    if not Esp.Enabled then return end

    local highlight, billboard, tracer, character = unpack(data)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not root or not localRoot then return end

    local vec, onScreen = Camera:WorldToViewportPoint(root.Position)

    highlight.Enabled = onScreen and SETTINGS.ShowBox
    billboard.Enabled = onScreen and SETTINGS.ShowName

    if onScreen and SETTINGS.ShowTracer then
        tracer.Visible = true
        tracer.Position = UDim2.new(0, vec.X, 0, vec.Y)
        tracer.Size = UDim2.new(0, 100, 0, 1)
    else
        tracer.Visible = false
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
        for _, obj in ipairs(espData[plr]) do
            if typeof(obj) == "Instance" then obj:Destroy() end
        end
        espData[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if not Esp.Enabled then return end

    for plr, data in pairs(espData) do
        if data[4] and data[4].Parent then
            updateESP(data)
        end
    end
end)

function Esp:Enable()
    self.Enabled = true
end

function Esp:Disable()
    self.Enabled = false

    for plr, data in pairs(espData) do
        for _, obj in ipairs(data) do
            if typeof(obj) == "Instance" then
                obj.Enabled = false
                obj.Visible = false
            end
        end
    end
end

function Esp:drawModule(MainTab)
    local Folder = MainTab.Folder("Esp", "[Info] Shows all players")

    Folder.Switch("Toggle", function(Status)
        if Status then self:Enable()
        else self:Disable() end
    end)

    return self
end

return Esp
