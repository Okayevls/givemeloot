local DesyncPosition = {}
DesyncPosition.__index = DesyncPosition

DesyncPosition.Enabled = false
DesyncPosition.Interval = 0.3
local function getRandomOffset()
    return Vector3.new(
            math.random(-100000, 100000),
            math.random(-100000, 100000),
            math.random(-100000, 100000)
    )
end

function DesyncPosition:start()
    if self.Enabled then return end
    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local realPos = hrp.CFrame
                local fakePos = realPos + getRandomOffset()

                pcall(function()
                    hrp.CFrame = fakePos
                end)

                task.wait(0.05)
                pcall(function()
                    hrp.CFrame = realPos
                end)
            end

            task.wait(self.Interval)
        end
    end)
end

function DesyncPosition:stop()
    self.Enabled = false
    print("[DesyncPosition] ❌ Десинк остановлен")
end

function DesyncPosition:drawModule(MainTab)
    local Folder = MainTab:Folder("Position Player", "[Info] Server position desync")

    Folder:SwitchAndBinding("Position Desync", function(state)
        if state then
            print("[DesyncPosition] ✅ Десинк включён")
            self:start()
        else
            self:stop()
        end
    end)
end

return DesyncPosition


--local DesyncPosition = {}
--DesyncPosition.__index = DesyncPosition
--
--DesyncPosition.type = {}
--
--function DesyncPosition:drawModule(MainTab)
--    local Folder = MainTab.Folder("Position Player", "[Info] Controlling player server position")
--
--    Folder.SwitchAndBinding("Position Desync", function(Status)
--        print("Switch Triggered: " .. tostring(Status))
--    end)
--end
--
--return DesyncPosition
