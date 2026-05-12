--[[
    GunModule.lua — Gun Rapid Fire & Weapon System
    Kloso Hub - Blox Fruits
]]

local GunModule = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer

GunModule.Config = {
    RapidFireEnabled = false,
    RapidFireDelay = 0.02,
    SelectedGun = nil,
    SkillLockEnabled = false,
}

GunModule._loop = nil

-- Gun list
GunModule.Guns = {
    "Slingshot", "Musket", "Flintlock", "Refined Slingshot", "Refined Flintlock",
    "Cannon", "Kabucha", "Bizarre Rifle", "Serpent Bow", "Soul Guitar",
    "Acidum Rifle", "Bazooka", "Electric Claw Gun",
}

function GunModule.getEquippedGun()
    local char = plr.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, gun in ipairs(GunModule.Guns) do
                if tool.Name == gun then return tool end
            end
        end
    end
    return nil
end

function GunModule.equipGun(gunName)
    local bp = plr:FindFirstChild("Backpack")
    local char = plr.Character
    if not bp or not char then return false end
    
    local gun = bp:FindFirstChild(gunName)
    if gun then
        gun.Parent = char
        return true
    end
    if char:FindFirstChild(gunName) then return true end
    return false
end

function GunModule.startRapidFire()
    GunModule.Config.RapidFireEnabled = true
    
    if GunModule._loop then return end
    
    GunModule._loop = task.spawn(function()
        while GunModule.Config.RapidFireEnabled do
            local gun = GunModule.getEquippedGun()
            if gun then
                -- Simulate rapid mouse clicks for firing
                pcall(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end)
                
                -- Also try activating the tool directly
                pcall(function()
                    gun:Activate()
                end)
                
                -- Fire via remote if available
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        local shootRemote = remotes:FindFirstChild("CommF_")
                        if shootRemote then
                            -- Attempt rapid fire through remote
                            local char = plr.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local target = hrp.Position + hrp.CFrame.LookVector * 100
                                shootRemote:InvokeServer("ShootGun", target)
                            end
                        end
                    end
                end)
            end
            task.wait(GunModule.Config.RapidFireDelay)
        end
        GunModule._loop = nil
    end)
end

function GunModule.stopRapidFire()
    GunModule.Config.RapidFireEnabled = false
    GunModule._loop = nil
end

function GunModule.setRapidFireDelay(delay)
    GunModule.Config.RapidFireDelay = math.max(delay, 0.01)
end

-- Skill Lock Prevention
function GunModule.preventSkillLock()
    GunModule.Config.SkillLockEnabled = true
    task.spawn(function()
        while GunModule.Config.SkillLockEnabled do
            pcall(function()
                local char = plr.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        -- Unequip and re-equip to break skill lock
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            local name = tool.Name
                            hum:UnequipTools()
                            task.wait(0.1)
                            local bp = plr:FindFirstChild("Backpack")
                            if bp then
                                local t = bp:FindFirstChild(name)
                                if t then t.Parent = char end
                            end
                        end
                    end
                end
            end)
            task.wait(5)
        end
    end)
end

function GunModule.cleanup()
    GunModule.stopRapidFire()
    GunModule.Config.SkillLockEnabled = false
end

return GunModule
