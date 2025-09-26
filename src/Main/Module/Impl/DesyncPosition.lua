local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

getgenv().desyncEnabled = false
getgenv().desyncOffset = Vector3.new(0, 0, 0)
getgenv().cframeSpeedKeybindActive = false

local positionIndicator = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local positionLabel = Instance.new("TextLabel", positionIndicator)

positionLabel.Size = UDim2.new(0, 200, 0, 50)
positionLabel.Position = UDim2.new(0.5, -100, 0, 10)
positionLabel.BackgroundColor3 = Color3.new(0, 0, 0)
positionLabel.TextColor3 = Color3.new(1, 1, 1)
positionLabel.TextScaled = true
positionLabel.Text = "Current Position: (0, 0, 0)"

local function updatePositionIndicator()
    local position = HRP.Position + getgenv().desyncOffset
    positionLabel.Text = string.format("Current Position: (%.2f, %.2f, %.2f)", position.X, position.Y, position.Z)
end

local function startDesync()
    if getgenv()._desyncConnection then
        getgenv()._desyncConnection:Disconnect()
        getgenv()._desyncConnection = nil
    end

    getgenv()._desyncConnection = RunService.Heartbeat:Connect(function()
        if getgenv().desyncEnabled and getgenv().cframeSpeedKeybindActive then
            HRP.CFrame = HRP.CFrame * CFrame.new(getgenv().desyncOffset)
            updatePositionIndicator()
        end
    end)
end

function DesyncPosition:drawModule(Tabs)
    local playerGroup = Tabs.Character:AddLeftGroupbox('Position')

    playerGroup:AddToggle('desyncposition_toggle', {
        Text = 'Desync Position',
        Default = false,
        Callback = function(state)
            getgenv().desyncEnabled = state
            if state then
                print("Desync enabled")
                startDesync()
            else
                print("Desync disabled")
                if getgenv()._desyncConnection then
                    getgenv()._desyncConnection:Disconnect()
                    getgenv()._desyncConnection = nil
                end
            end
        end
    }):AddKeyPicker('DesyncPositionKeybind', {
        Default = 'T',
        Text = 'CDesync',
        Mode = 'Toggle',
        Callback = function(state)
            if game:GetService("UserInputService"):GetFocusedTextBox() then return end
            getgenv().cframeSpeedKeybindActive = state
        end,
    })

    playerGroup:AddSlider('desync_offset', {
        Text = 'Desync Offset',
        Default = 5,
        Min = -50,
        Max = 50,
        Rounding = 1,
        Compact = false,
        Callback = function(value)
            getgenv().desyncOffset = Vector3.new(0, 0, value)
        end
    })

    return playerGroup
end

return DesyncPosition
