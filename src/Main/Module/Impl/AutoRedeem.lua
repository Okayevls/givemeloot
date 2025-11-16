local AutoRedeem = {}
AutoRedeem.__index = AutoRedeem

AutoRedeem.Enabled = false
AutoRedeem._Switch = nil

local CODES = {
    "20MVISITS",
    "20KLIKES"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RedeemRemote = nil
local isFunction = false

local redeemed = {}
for _, code in ipairs(CODES) do
    redeemed[code] = false
end

local function findRemote()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name == "RedeemCode" and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            RedeemRemote = obj
            isFunction = obj:IsA("RemoteFunction")
            return true
        end
    end

    RedeemRemote = ReplicatedStorage:WaitForChild("RedeemCode", 10)
    if RedeemRemote then
        isFunction = RedeemRemote:IsA("RemoteFunction")
        return true
    end

    warn("[AutoRedeem] Remote 'RedeemCode' не найден!")
    return false
end

local function redeem(code)
    if redeemed[code] then return end
    if not RedeemRemote then return end

    local success, result = pcall(function()
        if isFunction then
            return RedeemRemote:InvokeServer(code)
        else
            RedeemRemote:FireServer(code)
        end
    end)

    if success then
        redeemed[code] = true
        print("[AutoRedeem] Активирован код:", code)
    else
        warn("[AutoRedeem] Ошибка при вводе", code, ":", result)
    end
end

function AutoRedeem:Run()
    if not self.Enabled then return end

    if not RedeemRemote then
        if not findRemote() then
            warn("[AutoRedeem] Не найден Remote — остановка.")
            return
        end
    end

    for _, code in ipairs(CODES) do
        redeem(code)
        task.wait(1)
    end

    print("[AutoRedeem] Все коды введены.")
    self.Enabled = false

    if self._Switch then
        self._Switch.Value = false
    end

    print("[AutoRedeem] Модуль отключён автоматически.")
end

function AutoRedeem:Enable()
    if self.Enabled then return end
    self.Enabled = true

    task.spawn(function()
        self:Run()
    end)
end

function AutoRedeem:Disable()
    self.Enabled = false
end

function AutoRedeem:drawModule(MainTab)
    local Folder = MainTab.Folder("AutoRedeem", "[Info] Auto Redeem all game code")

    self._Switch = Folder.SwitchAndBinding("Toggle", function(Status)
        if Status then
            self:Enable()
        else
            self:Disable()
        end
    end)

    return self
end

return AutoRedeem
