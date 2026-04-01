--[[
    HK416 BABFT ELITE VOID KILLER v2.6 - Ultra Dirty 2026
    - Cleaned + Stronger Remote + Better Physics + Fixed Targeting
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local KILL_ZONE_Y = -2000  -- 진짜 지옥 깊이

-- ==================== REMOTES ====================
local damageRemotes = {}
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        local name = v.Name:lower()
        if name:find("damage") or name:find("hit") or name:find("kill") or name:find("weapon") or name:find("attack") or name:find("bullet") then
            table.insert(damageRemotes, v)
        end
    end
end

print("[HK416] Detected " .. #damageRemotes .. " damage-related remotes.")

-- ==================== STEALTH ====================
local function StealthMode()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    local oldNamecall = mt.__namecall

    setreadonly(mt, false)

    mt.__index = newcclosure(function(self, key)
        if not checkcaller() and self:IsA("Humanoid") then
            if key == "Health" then return 100 end
            if key == "WalkSpeed" then return 16 end
            if key == "JumpPower" then return 50 end
        end
        return oldIndex(self, key)
    end)

    mt.__namecall = newcclosure(function(self, ...)
        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
    print("[HK416] Stealth Mode ON")
end

-- ==================== TARGETING ====================
local function GetClosestTarget()
    local target = nil
    local minDist = math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < minDist and dist < 380 then
                    minDist = dist
                    target = plr.Character
                end
            end
        end
    end
    return target
end

-- ==================== EXECUTE VOID KILL ====================
local function ExecuteVoidKill()
    local targetChar = GetClosestTarget()
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        print("[HK416] No target in view.")
        return
    end

    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    local hum = targetChar:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Remote Attack (65회 정도로 조정, 너무 과하면 감지됨)
    for i = 1, 65 do
        for _, remote in ipairs(damageRemotes) do
            pcall(function()
                remote:FireServer(hum, 999999999999, "HK416_VoidEater", "Head", hrp.Position, "void_" .. i)
            end)
        end
        task.wait(math.random(7, 22) / 1000)
    end

    -- Joint Break
    for _, obj in pairs(targetChar:GetDescendants()) do
        if obj:IsA("Motor6D") or obj:IsA("Weld") or obj:IsA("WeldConstraint") or obj:IsA("BallSocketConstraint") then
            pcall(function() obj:Destroy() end)
        end
    end

    -- Mega Void
    hum.Health = 0
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    hum.PlatformStand = true

    hrp.AssemblyLinearVelocity = Vector3.new(math.random(-450,450), -5500, math.random(-450,450))
    hrp.AssemblyAngularVelocity = Vector3.new(math.random(1400,3000), math.random(1400,3000), math.random(1400,3000))

    hrp.CFrame = CFrame.new(hrp.Position.X, KILL_ZONE_Y, hrp.Position.Z)

    -- Explosions
    for i = 1, 4 do
        local exp = Instance.new("Explosion")
        exp.Position = hrp.Position + Vector3.new(math.random(-8,8), math.random(2,10), math.random(-8,8))
        exp.BlastRadius = 15
        exp.Parent = workspace
        Debris:AddItem(exp, 3)
        task.wait(0.07)
    end

    print("[VOID KILL] " .. targetChar.Name .. " dropped into the abyss.")
end

-- ==================== TOOL ====================
local function CreateHK416Tool()
    local tool = Instance.new("Tool")
    tool.Name = "☢️ HK416 VoidEater"
    tool.RequiresHandle = true
    tool.Grip = CFrame.new(0, -0.8, -2.1) * CFrame.Angles(math.rad(88), 0, 0)
    tool.Parent = LocalPlayer.Backpack

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.68, 1.55, 5.2)
    handle.Material = Enum.Material.Neon
    handle.Color = Color3.fromRGB(20, 20, 25)
    handle.CanCollide = false
    handle.Parent = tool

    local mesh = Instance.new("SpecialMesh", handle)
    mesh.MeshId = "rbxassetid://4701290654"
    mesh.Scale = Vector3.new(1.18, 1.18, 1.28)

    local light = Instance.new("PointLight", handle)
    light.Color = Color3.fromRGB(255, 35, 35)
    light.Brightness = 3.5
    light.Range = 12

    tool.Activated:Connect(ExecuteVoidKill)

    print("[HK416] Tool ready → Aim + Click to void kill")
end

-- ==================== MAIN ====================
local function Main()
    StealthMode()
    CreateHK416Tool()

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HK416 VOID EATER v2.6",
        Text = "Tool injected. Aim at player and left-click to delete.",
        Duration = 8
    })

    -- Anti-AFK
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(), Camera.CFrame)
        task.wait(math.random(0.8, 1.7))
        VirtualUser:Button2Up(Vector2.new(), Camera.CFrame)
    end)
end

pcall(Main)

print("HK416 BABFT Elite Void Killer v2.6 Loaded - 이제 마우스 조준하고 클릭해서 플레이어 지옥으로 보내자 이 병신새끼들아")
