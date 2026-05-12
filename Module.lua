--[[
    Module.lua — Core Utilities & Helpers
    Blox Fruits Script Hub
    Provides foundational functions used by all other modules.
]]

local Module = {}
Module.__index = Module

-- ═══════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

Module.Services = {
    Players = Players,
    RunService = RunService,
    TweenService = TweenService,
    ReplicatedStorage = ReplicatedStorage,
    Workspace = Workspace,
    VirtualInputManager = VirtualInputManager,
    HttpService = HttpService,
    StarterGui = StarterGui,
    UserInputService = UserInputService,
    Lighting = Lighting,
}

-- ═══════════════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════════════
Module.Config = {
    TweenSpeed = 250,
    AttackRange = 60,
    BuddhaAttackRange = 120,
    DodgeOffset = Vector3.new(0, 20, 0),
    FarmHeight = 20,
    Version = "1.0.0",
    HubName = "Kloso Hub",
    GameId = 2753915549,
}

-- ═══════════════════════════════════════════════
-- STATE MANAGEMENT
-- ═══════════════════════════════════════════════
Module.Toggles = {}
Module.Connections = {}
Module.Loops = {}
Module.TweenQueue = {}
Module._activeTween = nil
Module._guard = {
    enabled = false,
    antiKick = false,
    antiTeleport = false,
}

-- ═══════════════════════════════════════════════
-- PLAYER HELPERS
-- ═══════════════════════════════════════════════
function Module.getPlayer()
    return Players.LocalPlayer
end

function Module.getCharacter()
    local plr = Module.getPlayer()
    return plr and plr.Character
end

function Module.getHumanoid()
    local char = Module.getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Module.getHRP()
    local char = Module.getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Module.isAlive()
    local hum = Module.getHumanoid()
    local hrp = Module.getHRP()
    return hum and hrp and hum.Health > 0
end

function Module.getPlayerLevel()
    local plr = Module.getPlayer()
    if plr then
        local stats = plr:FindFirstChild("Data") or plr:FindFirstChild("leaderstats")
        if stats then
            local level = stats:FindFirstChild("Level")
            if level then
                return level.Value
            end
        end
    end
    -- Fallback: check data folder
    local data = plr and plr:FindFirstChild("Data")
    if data then
        local lvl = data:FindFirstChild("Level")
        if lvl then return lvl.Value end
    end
    return 0
end

function Module.getPlayerSea()
    local plr = Module.getPlayer()
    if not plr then return 1 end
    
    -- Check via game location
    local hrp = Module.getHRP()
    if not hrp then return 1 end
    
    local pos = hrp.Position
    
    -- Blox Fruits sea detection based on X position ranges
    if pos.X > 50000 then
        return 3 -- Third Sea
    elseif pos.X < -12000 then
        return 2 -- Second Sea
    else
        return 1 -- First Sea
    end
end

function Module.getPlayerFruit()
    local plr = Module.getPlayer()
    if not plr then return nil end
    local bp = plr:FindFirstChild("Backpack")
    local char = Module.getCharacter()
    
    local function checkTool(tool)
        if tool:IsA("Tool") and tool:FindFirstChild("FruitType") then
            return tool.Name
        end
    end
    
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            local fruit = checkTool(tool)
            if fruit then return fruit end
        end
    end
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            local fruit = checkTool(tool)
            if fruit then return fruit end
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════
-- TELEPORT / MOVEMENT SYSTEM
-- ═══════════════════════════════════════════════
function Module.tweenTo(targetCFrame, speedOverride, callback)
    local hrp = Module.getHRP()
    if not hrp then return end
    
    local speed = speedOverride or Module.Config.TweenSpeed
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local tweenTime = distance / speed
    
    -- Minimum tween time to avoid instant teleports
    tweenTime = math.max(tweenTime, 0.1)
    -- Max tween time cap to avoid absurdly long tweens
    tweenTime = math.min(tweenTime, 15)
    
    -- Cancel existing tween
    if Module._activeTween then
        Module._activeTween:Cancel()
        Module._activeTween = nil
    end
    
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    Module._activeTween = tween
    
    tween:Play()
    
    if callback then
        tween.Completed:Connect(function()
            Module._activeTween = nil
            callback()
        end)
    else
        tween.Completed:Wait()
        Module._activeTween = nil
    end
end

function Module.teleportTo(position)
    local hrp = Module.getHRP()
    if not hrp then return end
    
    if typeof(position) == "Vector3" then
        hrp.CFrame = CFrame.new(position)
    elseif typeof(position) == "CFrame" then
        hrp.CFrame = position
    end
end

function Module.tweenCancel()
    if Module._activeTween then
        Module._activeTween:Cancel()
        Module._activeTween = nil
    end
end

function Module.distanceTo(position)
    local hrp = Module.getHRP()
    if not hrp then return math.huge end
    if typeof(position) == "CFrame" then
        position = position.Position
    end
    return (hrp.Position - position).Magnitude
end

-- ═══════════════════════════════════════════════
-- COMBAT HELPERS
-- ═══════════════════════════════════════════════
function Module.getNearestEnemy(range, customFilter)
    local hrp = Module.getHRP()
    if not hrp then return nil end
    
    range = range or Module.Config.AttackRange
    local nearest = nil
    local nearestDist = range
    
    -- Check enemies folder
    local enemyFolders = {
        Workspace:FindFirstChild("Enemies"),
        Workspace:FindFirstChild("NPCs"),
    }
    
    for _, folder in ipairs(enemyFolders) do
        if folder then
            for _, enemy in ipairs(folder:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") then
                    local eHum = enemy:FindFirstChildOfClass("Humanoid")
                    local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                    
                    if eHum.Health > 0 then
                        local dist = (hrp.Position - eHrp.Position).Magnitude
                        if dist < nearestDist then
                            if customFilter then
                                if customFilter(enemy) then
                                    nearest = enemy
                                    nearestDist = dist
                                end
                            else
                                nearest = enemy
                                nearestDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearest, nearestDist
end

function Module.getNearestEnemyByName(name, range)
    return Module.getNearestEnemy(range, function(enemy)
        return enemy.Name == name
    end)
end

function Module.attackTarget(target)
    if not target then return end
    local hrp = Module.getHRP()
    if not hrp then return end
    
    local targetHRP = target:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    -- Position near target
    local offset = Module.Config.DodgeOffset
    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, offset.Y, 0)
    
    -- Simulate click for attack
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

function Module.useSkill(skillKey)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, skillKey, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, skillKey, false, game)
    end)
end

-- ═══════════════════════════════════════════════
-- BOAT MANAGEMENT
-- ═══════════════════════════════════════════════
Module.ShipList = {
    "Dingy",
    "Sloop",
    "Caravel",
    "Brigantine",
    "Galleon",
    "Guardian",
    "PirateBrigade",
    "Enforcer",
    "Sentinel",
}

function Module.spawnBoat(shipName)
    shipName = shipName or "Brigantine"
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            local spawnShip = remote:FindFirstChild("CommF_") or remote:FindFirstChild("SpawnBoat")
            if spawnShip then
                spawnShip:InvokeServer("SpawnBoat", shipName)
            end
        end
    end)
end

function Module.getPlayerBoat()
    local plr = Module.getPlayer()
    if not plr then return nil end
    
    for _, boat in ipairs(Workspace:GetChildren()) do
        if boat:FindFirstChild("Boat") or boat.Name:find("Boat") then
            local owner = boat:FindFirstChild("Owner")
            if owner and owner.Value == plr.Name then
                return boat
            end
        end
    end
    return nil
end

function Module.driveBoat(destination)
    local boat = Module.getPlayerBoat()
    if not boat then
        Module.spawnBoat()
        task.wait(2)
        boat = Module.getPlayerBoat()
    end
    if not boat then return false end
    
    local seat = boat:FindFirstChildOfClass("VehicleSeat") or boat:FindFirstChild("DriverSeat")
    if seat then
        local hrp = Module.getHRP()
        if hrp then
            hrp.CFrame = seat.CFrame
            task.wait(0.5)
            seat:Sit(Module.getHumanoid())
        end
    end
    
    if destination then
        -- Move boat toward destination
        local boatHRP = boat:FindFirstChild("HumanoidRootPart") or boat.PrimaryPart
        if boatHRP then
            Module.tweenTo(CFrame.new(destination))
        end
    end
    return true
end

function Module.boostSpeedBoat(multiplier)
    multiplier = multiplier or 2
    local boat = Module.getPlayerBoat()
    if not boat then return end
    
    local seat = boat:FindFirstChildOfClass("VehicleSeat")
    if seat then
        seat.MaxSpeed = seat.MaxSpeed * multiplier
        seat.Torque = seat.Torque * multiplier
    end
end

-- ═══════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════
function Module.notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or Module.Config.HubName,
            Text = text or "",
            Duration = duration,
        })
    end)
end

-- ═══════════════════════════════════════════════
-- REMOTE HELPERS
-- ═══════════════════════════════════════════════
function Module.fireRemote(remoteName, ...)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local remote = remotes:FindFirstChild(remoteName)
            if remote then
                if remote:IsA("RemoteEvent") then
                    remote:FireServer(...)
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(...)
                end
            end
        end
    end)
end

function Module.invokeServer(...)
    local result = nil
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local commF = remotes:FindFirstChild("CommF_")
            if commF then
                result = commF:InvokeServer(...)
            end
        end
    end)
    return result
end

-- ═══════════════════════════════════════════════
-- EFFECT DISABLING
-- ═══════════════════════════════════════════════
function Module.disableEffects()
    pcall(function()
        -- Disable death effect
        local deathEffect = Lighting:FindFirstChild("DeathEffect") or Lighting:FindFirstChild("ColorCorrection")
        if deathEffect then
            deathEffect.Enabled = false
        end
        
        -- Disable spawn effect
        local char = Module.getCharacter()
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end
        
        -- Disable screen effects
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
                v.Enabled = false
            end
        end
    end)
end

-- ═══════════════════════════════════════════════
-- GUARD SYSTEM (Anti-Detection)
-- ═══════════════════════════════════════════════
function Module.enableGuard()
    Module._guard.enabled = true
    
    -- Anti-kick
    if not Module._guard.antiKick then
        Module._guard.antiKick = true
        local mt = getrawmetatable(game)
        if mt and setreadonly then
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" and Module._guard.enabled then
                    return nil
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end
    end
    
    Module.notify("Guard", "Guard system enabled")
end

function Module.disableGuard()
    Module._guard.enabled = false
    Module.notify("Guard", "Guard system disabled")
end

-- ═══════════════════════════════════════════════
-- DISTANCE INDICATOR
-- ═══════════════════════════════════════════════
Module._distanceGui = nil

function Module.showDistanceIndicator(targetName, targetPosition)
    if Module._distanceGui then
        Module._distanceGui:Destroy()
    end
    
    local plr = Module.getPlayer()
    local gui = Instance.new("ScreenGui")
    gui.Name = "DistanceIndicator"
    gui.ResetOnSpawn = false
    gui.Parent = plr:FindFirstChild("PlayerGui")
    
    local label = Instance.new("TextLabel")
    label.Name = "DistLabel"
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0.5, -100, 0, 10)
    label.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    label.BackgroundTransparency = 0.3
    label.TextColor3 = Color3.fromRGB(180, 140, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Text = ""
    label.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = label
    
    Module._distanceGui = gui
    
    -- Update loop
    task.spawn(function()
        while gui and gui.Parent do
            local dist = Module.distanceTo(targetPosition)
            label.Text = string.format("📍 %s: %.0f studs", targetName or "Target", dist)
            task.wait(0.5)
        end
    end)
end

function Module.hideDistanceIndicator()
    if Module._distanceGui then
        Module._distanceGui:Destroy()
        Module._distanceGui = nil
    end
end

-- ═══════════════════════════════════════════════
-- CONNECTION MANAGEMENT
-- ═══════════════════════════════════════════════
function Module.connect(name, signal, callback)
    if Module.Connections[name] then
        Module.Connections[name]:Disconnect()
    end
    Module.Connections[name] = signal:Connect(callback)
end

function Module.disconnect(name)
    if Module.Connections[name] then
        Module.Connections[name]:Disconnect()
        Module.Connections[name] = nil
    end
end

function Module.disconnectAll()
    for name, conn in pairs(Module.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    Module.Connections = {}
end

-- ═══════════════════════════════════════════════
-- LOOP MANAGEMENT
-- ═══════════════════════════════════════════════
function Module.startLoop(name, interval, callback)
    Module.stopLoop(name)
    Module.Loops[name] = true
    task.spawn(function()
        while Module.Loops[name] do
            local success, err = pcall(callback)
            if not success then
                warn("[" .. Module.Config.HubName .. "] Loop error (" .. name .. "): " .. tostring(err))
            end
            task.wait(interval)
        end
    end)
end

function Module.stopLoop(name)
    Module.Loops[name] = nil
end

function Module.stopAllLoops()
    for name in pairs(Module.Loops) do
        Module.Loops[name] = nil
    end
end

-- ═══════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════
function Module.waitForChild(parent, childName, timeout)
    timeout = timeout or 10
    local child = parent:FindFirstChild(childName)
    if child then return child end
    
    local startTime = tick()
    while tick() - startTime < timeout do
        child = parent:FindFirstChild(childName)
        if child then return child end
        task.wait(0.1)
    end
    return nil
end

function Module.safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[" .. Module.Config.HubName .. "] Error: " .. tostring(result))
    end
    return success, result
end

function Module.equipTool(toolName)
    local plr = Module.getPlayer()
    local char = Module.getCharacter()
    if not plr or not char then return false end
    
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        local tool = bp:FindFirstChild(toolName)
        if tool then
            tool.Parent = char
            return true
        end
    end
    
    -- Check if already equipped
    if char:FindFirstChild(toolName) then
        return true
    end
    return false
end

function Module.unequipTools()
    local plr = Module.getPlayer()
    local char = Module.getCharacter()
    if not char then return end
    
    local hum = Module.getHumanoid()
    if hum then
        hum:UnequipTools()
    end
end

function Module.getToolInBackpack(toolName)
    local plr = Module.getPlayer()
    if not plr then return nil end
    
    local bp = plr:FindFirstChild("Backpack")
    local char = Module.getCharacter()
    
    if bp then
        local tool = bp:FindFirstChild(toolName)
        if tool then return tool end
    end
    if char then
        local tool = char:FindFirstChild(toolName)
        if tool then return tool end
    end
    return nil
end

-- ═══════════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════════
function Module.cleanup()
    Module.tweenCancel()
    Module.stopAllLoops()
    Module.disconnectAll()
    Module.hideDistanceIndicator()
    
    -- Remove any created GUIs
    local plr = Module.getPlayer()
    if plr and plr:FindFirstChild("PlayerGui") then
        local pg = plr.PlayerGui
        for _, gui in ipairs(pg:GetChildren()) do
            if gui.Name == "DistanceIndicator" or gui.Name == "KlosoHub" then
                gui:Destroy()
            end
        end
    end
    
    Module.notify(Module.Config.HubName, "Script unloaded. Goodbye!")
end

return Module
