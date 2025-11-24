local Esp = {}
Esp.__index = Esp

Esp.Enabled = false
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
    HideNames = false,
}

local espData = {}

local function updateOriginalNames()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if SETTINGS.HideNames then
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                else
                    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                end
            end
        end
    end
end

local function createESP(character, plrName)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return nil
    end

    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not root then return nil end

    local head = character:FindFirstChild("Head")
    if not head then
        head = Instance.new("Part")
        head.Name = "FakeHead"
        head.Size = Vector3.new(1,1,1)
        head.Transparency = 1
        head.CanCollide = false
        head.Anchored = false
        head.CFrame = root.CFrame + Vector3.new(0, humanoid.HipHeight + 1.6, 0)
        head.Parent = character

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = head
        weld.Part1 = root
        weld.Parent = head
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = plrName.."_ESP"
    highlight.Adornee = character
    highlight.FillTransparency = 1
    highlight.OutlineColor = SETTINGS.Color
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = espFolder

    local billboard = Instance.new("BillboardGui")
    billboard.Name = plrName.."_Info"
    billboard.Adornee = head
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    billboard.Size = UDim2.fromOffset(Esp.DistanceMaxSize, Esp.DistanceMaxSize * 0.2)
    billboard.Parent = espFolder

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

local function updateESP(data)
    if not Esp.Enabled then return end
    local highlight, billboard, character, nameLabel = data[1], data[2], data[3], data[4]

    if not character or not character.Parent then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    highlight.Enabled = SETTINGS.ShowBox
    highlight.OutlineTransparency = SETTINGS.ShowBox and 0 or 1

    billboard.Enabled = SETTINGS.ShowName
    nameLabel.Visible = SETTINGS.ShowName
    nameLabel.BackgroundTransparency = SETTINGS.ShowBackground and 0.5 or 1

    local distance = (Camera.CFrame.Position - root.Position).Magnitude
    local sizeX = math.clamp(distance * 0.6, Esp.DistanceMaxSize, Esp.DistanceMaxSize)
    local sizeY = sizeX * 0.2

    billboard.Size = UDim2.fromOffset(sizeX, sizeY)
    nameLabel.TextSize = math.clamp(SETTINGS.TextSize * (sizeX / 120), 8, 32)
end

local function setupESP(plr)
    if plr == LocalPlayer then return end

    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)

        if espData[plr] then
            for _, v in ipairs(espData[plr]) do
                if typeof(v) == "Instance" then
                    v:Destroy()
                end
            end
            espData[plr] = nil
        end

        espData[plr] = createESP(char, plr.Name)
    end)

    if plr.Character then
        espData[plr] = createESP(plr.Character, plr.Name)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    setupESP(plr)
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
        updateESP(data)
    end
end)

function Esp:Enable()
    if self.Enabled then return end
    self.Enabled = true
    updateOriginalNames()

    for _, data in pairs(espData) do
        if data[1] then data[1].Enabled = SETTINGS.ShowBox end
        if data[2] then data[2].Enabled = SETTINGS.ShowName end
        if data[4] then data[4].Visible = SETTINGS.ShowName end
    end
end

function Esp:Disable()
    self.Enabled = false
    updateOriginalNames()

    for _, data in pairs(espData) do
        if data[1] then data[1].Enabled = false end
        if data[2] then data[2].Enabled = false end
        if data[4] then data[4].Visible = false end
    end
end

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

    Folder.Switch("Hide Original Names", function(State)
        SETTINGS.HideNames = State
        updateOriginalNames()
    end)

    Folder.Slider("Distance Render Max Size", { Min = 50, Max = 500, Default = 85, Step = 5 }, function(value)
        self.DistanceMaxSize = value
    end)

    return self
end

return Esp