local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.type = {}

desync_setback = Instance.new("Part")
desync_setback.Name = "Desync Setback"
desync_setback.Parent = workspace
desync_setback.Size = Vector3.new(2, 2, 1)
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1

function setDesyncMode(mode)
    desync.mode = mode
end

function resetCamera()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

function DesyncPosition:drawModule(Tabs)
    local playerGroup = Tabs.Character:AddLeftGroupbox('Position')

    playerGroup:AddToggle('desyncposition_toggle', {
        Text = 'Desync Position',
        Default = false,
        Callback = function(state)
            getgenv().desyncEnabled = state
            if state then
                workspace.CurrentCamera.CameraSubject = desync_setback
            else
                resetCamera()
            end
        end
    }):AddKeyPicker('desyncposition_toggle', {
        Default = 'T',
        Text = 'CDesync',
        Mode = 'Toggle',
        Callback = function(state)
            if game:GetService("UserInputService"):GetFocusedTextBox() then return end
            getgenv().cframeSpeedKeybindActive = state
        end,
    }):AddDropdown('DesyncMethodDropdown', {
        Values = {"Beta"},
        Default = "Beta",
        Multi = false,
        Text = 'Method',
        Callback = function(selected)
            setDesyncMode(selected)
        end
    })

    RunService.Heartbeat:Connect(function()
        if desync.enabled and LocalPlayer.Character then
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                desync.old_position = rootPart.CFrame

                if desync.mode == "Destroy Cheaters" then
                    desync.teleportPosition = Vector3.new(11223344556677889900, 1, 1)
                end
            end
        end
    end)

    return playerGroup
end

return DesyncPosition
