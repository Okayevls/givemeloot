local JumpCircle = {}
JumpCircle.__index = JumpCircle

JumpCircle.Enabled = false

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local RunService = game:GetService("RunService")

local IMAGE_ID = "rbxassetid://13585653697"
local START_RADIUS = 1
local END_RADIUS = 8
local HEIGHT = 0.05
local FADE_TIME = 0.52
local OFFSET_DOWN = 1.5

local function createCircle()
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false
    part.Size = Vector3.new(START_RADIUS*2, HEIGHT, START_RADIUS*2)
    part.CFrame = rootPart.CFrame - Vector3.new(0, rootPart.Size.Y/2 + HEIGHT/2 + OFFSET_DOWN, 0)
    part.Transparency = 1
    part.Material = Enum.Material.Neon
    part.Parent = workspace

    local mesh = Instance.new("CylinderMesh")
    mesh.Parent = part

    local gui = Instance.new("SurfaceGui")
    gui.Face = Enum.NormalId.Top
    gui.Adornee = part
    gui.Parent = part

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(1,0,1,0)
    image.BackgroundTransparency = 1
    image.Image = IMAGE_ID
    image.ImageColor3 = Color3.new(1,1,1)
    image.Parent = gui

    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= FADE_TIME then
            part:Destroy()
            connection:Disconnect()
        else
            local t = elapsed / FADE_TIME
            local radius = START_RADIUS + (END_RADIUS - START_RADIUS) * t
            part.Size = Vector3.new(radius*2, HEIGHT, radius*2)
            image.ImageTransparency = t
            print(t)
        end
    end)
end

function JumpCircle:Enable()
    if self.Enabled then return end
    self.Enabled = true
end

function JumpCircle:Disable()
    if not self.Enabled then return end
    self.Enabled = false
end

humanoid.Jumping:Connect(function(active)
    if active then
        if JumpCircle.Enabled then
            createCircle()
        end
    end
end)

function JumpCircle:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("JumpCircle", "[Info] jump visualization")

    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] JumpCircle - Enable!", 4)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] JumpCircle - Disable!", 4)
            self:Disable()
        end
    end)

    return self
end

return JumpCircle
