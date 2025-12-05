local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local ModuleBase = {}
ModuleBase.__index = ModuleBase

function ModuleBase.new(name, description)
    return setmetatable({
        Name = name,
        Enabled = false,
        Description = description or "none description",
        Settings = {},
        Connections = {}
    }, ModuleBase)
end

function ModuleBase:LoadSettings()
    if not self.Settings then return end
    for key, data in pairs(self.Settings) do
        self[key] = data.Default
    end
end

function ModuleBase:AddConnection(conn)
    table.insert(self.Connections, conn)
end

function ModuleBase:DisconnectAll()
    for _, conn in ipairs(self.Connections) do
        if conn.Disconnect then conn:Disconnect() end
    end
    self.Connections = {}
end

function ModuleBase:Enable()
    if self.Enabled then return end
    self.Enabled = true
    --Notifier:Send("[Legacy.wip]"..self.name.." - Enable!", 6)
    self:AddConnection(RunService.RenderStepped:Connect(function(dt)
        if self.ERender then self:ERender(dt) end
    end))

    self:AddConnection(RunService.Heartbeat:Connect(function()
        if self.EUpdate then self:EUpdate() end
    end))

    self:AddConnection(Players.LocalPlayer.CharacterAdded:Connect(function()
        if self.ELocalPlayerSpawned then self:ELocalPlayerSpawned() end
    end))

    self:AddConnection(UserInputService.InputBegan:Connect(function(input, gp)
        if self.EKeyInput then self:EKeyInput(input, gp) end
    end))

    self:AddConnection(UserInputService.InputEnded:Connect(function(input, gp)
        if self.EKeyUnInput then self:EKeyUnInput(input, gp) end
    end))
end

function ModuleBase:Disable()
    self.Enabled = false
    --Notifier:Send("[Legacy.wip]"..self.name.." - Disable!", 6)
    self:DisconnectAll()
end

function ModuleBase:drawModule(MainTab)
    local Folder = MainTab.Folder(self.Name, "[Info] "..(self.Description or "No description"))
    self:BuildUI(Folder)
    return self
end

function ModuleBase:BuildUI(Folder)
    for name, data in pairs(self.Settings) do
        if data.Type == "SwitchA" then
            Folder.Switch(name, function(state)
                self[name] = state
            end)
        end
        if data.Type == "SwitchB" then
            Folder.SwitchAndBinding(name, function(state)
                self[name] = state
            end)
        end
        if data.Type == "Slider" then
            Folder.Slider(name, {
                Min = data.Min,
                Max = data.Max,
                Default = data.Default,
                Step = data.Step or 1,
            }, function(val)
                self[name] = val
            end)
        end
    end
end

return ModuleBase
