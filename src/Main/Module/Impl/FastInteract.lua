local FastInteract = {}
FastInteract.__index = FastInteract

FastInteract.Enabled = false
FastInteract._connections = {}
FastInteract._original = {}

function FastInteract:Enable()
    if self.Enabled then return end
    self.Enabled = true

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            self:_makeInstant(v)
        end
    end

    table.insert(self._connections,
            workspace.DescendantAdded:Connect(function(descendant)
                if self.Enabled and descendant:IsA("ProximityPrompt") then
                    self:_makeInstant(descendant)
                end
            end)
    )
end

function FastInteract:Disable()
    if not self.Enabled then return end
    self.Enabled = false

    for prompt, dur in pairs(self._original) do
        if prompt and prompt.Parent then
            prompt.HoldDuration = dur
        end
    end

    self._original = {}

    for _, conn in ipairs(self._connections) do
        conn:Disconnect()
    end
    self._connections = {}
end

function FastInteract:_makeInstant(prompt)
    if not self._original[prompt] then
        self._original[prompt] = prompt.HoldDuration
    end
    prompt.HoldDuration = 0
end

function FastInteract:drawModule(MainTab, Notifier)
    local Folder = MainTab.Folder("FastInteract", "[Info] quick use of any buttons in the game")
    Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            Notifier:Send("[Legacy.wip] FastInteract - Enable!",6)
            self:Enable()
        else
            Notifier:Send("[Legacy.wip] FastInteract - Disable!",6)
            self:Disable()
        end
    end)

    return self
end

return FastInteract
