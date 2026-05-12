--[[
    GameModule.lua — Main Game Automation Engine
    Kloso Hub - Blox Fruits
]]

local GameModule = {}
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

GameModule.State = {
    AutoFarm = false, DodgeFarm = false, DodgeOffset = 20,
    AutoQuest = false, MasteryGrind = false, UseSkillFarm = false,
    FastAttack = false, BuddhaRange = false, MetaSlasher = false,
    AutoMirage = false, AutoKitsune = false, AutoVolcano = false,
    AutoFrozen = false, AutoLeviathan = false, Overheater = false,
    AutoDungeon = false, AutoRaid = false,
    AutoGhoul = false, AutoCyborg = false, AutoRace2 = false,
    AutoRace3 = false, AutoTrialV4 = false,
    AutoIndra = false, AutoTyrant = false, AutoDarkbeard = false,
    AutoSweetChalice = false, AutoGodChalice = false,
    AutoFistDarkness = false, AutoFireFlower = false,
    AutoVolcanicMagnet = false, AutoDragonHunter = false,
    AutoCollectFruit = false, AutoCollectGear = false,
    AutoTradeAzure = false, AutoTrainingDummy = false,
    SeaBeastESP = false, GearESP = false,
    DisableEffects = false, DistanceIndicator = false,
    GunRapidFire = false, SkillLock = false,
    BoostBoat = false, DriveBoat = false,
    SelectedWeapon = "Melee", SelectedShip = "Brigantine",
    SelectedGun = nil,
}

-- ═══════════════════════════════════
-- FARMING SYSTEM
-- ═══════════════════════════════════
function GameModule.startAutoFarm(Module, Quests, Guide)
    Module.startLoop("AutoFarm", 0.1, function()
        if not GameModule.State.AutoFarm then return end
        if not Module.isAlive() then task.wait(2) return end
        
        local level = Module.getPlayerLevel()
        local sea = Module.getPlayerSea()
        local quest = Quests.getQuestForLevel(level, sea)
        if not quest then return end
        
        local enemyName = quest[4]
        local enemyCF = quest[5]
        local npcCF = quest[6]
        
        -- Check if we have quest, if not get it
        local hasQuest = false
        pcall(function()
            local questFolder = plr:FindFirstChild("PlayerGui")
            if questFolder then
                for _, v in ipairs(questFolder:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Text and v.Text:find(enemyName) then
                        hasQuest = true
                    end
                end
            end
        end)
        
        if not hasQuest then
            Module.tweenTo(npcCF * CFrame.new(0, 3, 0))
            task.wait(0.5)
            pcall(function() Module.invokeServer("StartQuest", quest[2], quest[1]) end)
            task.wait(0.5)
            return
        end
        
        -- Find and attack enemy
        local enemy = Module.getNearestEnemyByName(enemyName, 1000)
        if not enemy then
            Module.tweenTo(enemyCF * CFrame.new(0, Module.Config.FarmHeight, 0))
            task.wait(1)
            return
        end
        
        local eHRP = enemy:FindFirstChild("HumanoidRootPart")
        if not eHRP then return end
        
        local hrp = Module.getHRP()
        if not hrp then return end
        
        local offset = GameModule.State.DodgeFarm and Vector3.new(0, GameModule.State.DodgeOffset, 0) or Vector3.new(0, 5, 0)
        hrp.CFrame = eHRP.CFrame * CFrame.new(offset.X, offset.Y, offset.Z)
        
        -- Attack
        Module.attackTarget(enemy)
        
        -- Use skills if enabled
        if GameModule.State.UseSkillFarm then
            for _, key in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
                Module.useSkill(key)
                task.wait(0.05)
            end
        end
        
        -- Buddha extended range
        if GameModule.State.BuddhaRange then
            Module.Config.AttackRange = Module.Config.BuddhaAttackRange
        end
    end)
end

function GameModule.stopAutoFarm(Module)
    GameModule.State.AutoFarm = false
    Module.stopLoop("AutoFarm")
end

-- ═══════════════════════════════════
-- SEA EVENTS
-- ═══════════════════════════════════
function GameModule.startAutoMirage(Module, Quests)
    Module.startLoop("AutoMirage", 1, function()
        if not GameModule.State.AutoMirage then return end
        if not Module.isAlive() then task.wait(2) return end
        
        -- Search for Mirage Island
        local mirage = nil
        for _, v in ipairs(WS:GetChildren()) do
            if v.Name:find("Mirage") then mirage = v break end
        end
        
        if mirage then
            local target = mirage:FindFirstChild("HumanoidRootPart") or mirage.PrimaryPart or mirage:FindFirstChildOfClass("Part")
            if target then
                Module.tweenTo(target.CFrame * CFrame.new(0, 10, 0))
            end
        end
    end)
end

function GameModule.startAutoKitsune(Module, Quests)
    Module.startLoop("AutoKitsune", 1, function()
        if not GameModule.State.AutoKitsune then return end
        if not Module.isAlive() then task.wait(2) return end
        
        local kitsune = nil
        for _, v in ipairs(WS:GetChildren()) do
            if v.Name:find("Kitsune") or v.Name:find("kitsune") then kitsune = v break end
        end
        
        if kitsune then
            local target = kitsune:FindFirstChild("HumanoidRootPart") or kitsune.PrimaryPart
            if target then
                Module.tweenTo(target.CFrame * CFrame.new(0, 5, 0))
                task.wait(0.5)
                Module.attackTarget(kitsune)
            end
        else
            Module.tweenTo(Quests.Locations.KitsuneIsland)
            task.wait(3)
        end
    end)
end

function GameModule.startAutoVolcano(Module, Quests)
    Module.startLoop("AutoVolcano", 1, function()
        if not GameModule.State.AutoVolcano then return end
        if not Module.isAlive() then task.wait(2) return end
        
        Module.tweenTo(Quests.Locations.VolcanoIsland)
        task.wait(2)
        
        -- Use Volcanic Magnet if enabled
        if GameModule.State.AutoVolcanicMagnet then
            pcall(function() Module.invokeServer("UseVolcanicMagnet") end)
        end
        
        -- Farm enemies nearby
        local enemy = Module.getNearestEnemy(200)
        if enemy then Module.attackTarget(enemy) end
    end)
end

function GameModule.startAutoFrozen(Module)
    Module.startLoop("AutoFrozen", 1, function()
        if not GameModule.State.AutoFrozen then return end
        if not Module.isAlive() then task.wait(2) return end
        
        local frozen = nil
        for _, v in ipairs(WS:GetChildren()) do
            if v.Name:find("Frozen") or v.Name:find("frozen") then frozen = v break end
        end
        
        if frozen then
            local target = frozen.PrimaryPart or frozen:FindFirstChildOfClass("Part")
            if target then Module.tweenTo(target.CFrame * CFrame.new(0, 5, 0)) end
        end
    end)
end

function GameModule.startAutoLeviathan(Module)
    Module.startLoop("AutoLeviathan", 0.5, function()
        if not GameModule.State.AutoLeviathan then return end
        if not Module.isAlive() then task.wait(2) return end
        
        local leviathan = nil
        for _, v in ipairs(WS:GetChildren()) do
            if v.Name:find("Leviathan") then leviathan = v break end
        end
        
        if leviathan then
            local target = leviathan:FindFirstChild("HumanoidRootPart") or leviathan.PrimaryPart
            if target then
                Module.getHRP().CFrame = target.CFrame * CFrame.new(0, 30, 0)
                Module.attackTarget(leviathan)
                if GameModule.State.UseSkillFarm then
                    for _, k in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
                        Module.useSkill(k) task.wait(0.05)
                    end
                end
            end
        end
    end)
end

-- ═══════════════════════════════════
-- DUNGEON / RAID
-- ═══════════════════════════════════
function GameModule.startAutoDungeon(Module)
    Module.startLoop("AutoDungeon", 1, function()
        if not GameModule.State.AutoDungeon then return end
        if not Module.isAlive() then task.wait(2) return end
        
        local enemy = Module.getNearestEnemy(300)
        if enemy then
            Module.attackTarget(enemy)
            if GameModule.State.UseSkillFarm then
                for _, k in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C}) do
                    Module.useSkill(k) task.wait(0.05)
                end
            end
        end
    end)
end

function GameModule.startAutoRaid(Module)
    Module.startLoop("AutoRaid", 0.5, function()
        if not GameModule.State.AutoRaid then return end
        if not Module.isAlive() then task.wait(2) return end
        
        local enemy = Module.getNearestEnemy(500)
        if enemy then
            Module.attackTarget(enemy)
            if GameModule.State.UseSkillFarm then
                for _, k in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
                    Module.useSkill(k) task.wait(0.05)
                end
            end
        end
    end)
end

-- ═══════════════════════════════════
-- BOSSES
-- ═══════════════════════════════════
local function bossLoop(Module, bossName, stateName)
    Module.startLoop("Auto"..bossName, 0.5, function()
        if not GameModule.State[stateName] then return end
        if not Module.isAlive() then task.wait(3) return end
        
        local boss = nil
        for _, v in ipairs(WS:GetDescendants()) do
            if v.Name == bossName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") then
                if v:FindFirstChildOfClass("Humanoid").Health > 0 then boss = v break end
            end
        end
        
        if boss then
            Module.attackTarget(boss)
            if GameModule.State.UseSkillFarm then
                for _, k in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
                    Module.useSkill(k) task.wait(0.05)
                end
            end
        end
    end)
end

function GameModule.startAutoIndra(M) bossLoop(M, "rip_indra", "AutoIndra") end
function GameModule.startAutoTyrant(M) bossLoop(M, "Tyrant", "AutoTyrant") end
function GameModule.startAutoDarkbeard(M) bossLoop(M, "Darkbeard", "AutoDarkbeard") end

-- ═══════════════════════════════════
-- RACE SYSTEM
-- ═══════════════════════════════════
function GameModule.startAutoGhoul(Module, Quests)
    Module.startLoop("AutoGhoul", 2, function()
        if not GameModule.State.AutoGhoul then return end
        pcall(function()
            Module.tweenTo(Quests.RaceLocations.GhoulRace)
            task.wait(1)
            Module.invokeServer("BuyRace", "Ghoul")
        end)
    end)
end

function GameModule.startAutoCyborg(Module, Quests)
    Module.startLoop("AutoCyborg", 2, function()
        if not GameModule.State.AutoCyborg then return end
        pcall(function()
            Module.tweenTo(Quests.RaceLocations.CyborgRace)
            task.wait(1)
            Module.invokeServer("BuyRace", "Cyborg")
        end)
    end)
end

function GameModule.startAutoRace2(Module, Quests)
    Module.startLoop("AutoRace2", 2, function()
        if not GameModule.State.AutoRace2 then return end
        pcall(function()
            Module.tweenTo(Quests.RaceLocations.RaceV2_NPC)
            task.wait(1)
            Module.invokeServer("StartRaceQuest", "V2")
        end)
    end)
end

function GameModule.startAutoRace3(Module, Quests)
    Module.startLoop("AutoRace3", 2, function()
        if not GameModule.State.AutoRace3 then return end
        pcall(function()
            Module.tweenTo(Quests.RaceLocations.RaceV3_NPC)
            task.wait(1)
            Module.invokeServer("StartRaceQuest", "V3")
        end)
    end)
end

function GameModule.startAutoTrialV4(Module, Quests, race)
    race = race or "Human"
    Module.startLoop("AutoTrialV4", 2, function()
        if not GameModule.State.AutoTrialV4 then return end
        local loc = Quests.RaceLocations.TrialV4[race]
        if loc then
            pcall(function()
                Module.tweenTo(loc)
                task.wait(1)
                Module.invokeServer("StartTrialV4", race)
            end)
        end
    end)
end

-- ═══════════════════════════════════
-- ITEMS / CHALICE / COLLECT
-- ═══════════════════════════════════
function GameModule.autoSweetChalice(Module, Q)
    pcall(function() Module.tweenTo(Q.Items.SweetChalice) task.wait(1) Module.invokeServer("UseChalice", "Sweet") end)
end
function GameModule.autoGodChalice(Module, Q)
    pcall(function() Module.tweenTo(Q.Items.GodChalice) task.wait(1) Module.invokeServer("UseChalice", "God") end)
end
function GameModule.autoFistDarkness(Module, Q)
    pcall(function() Module.tweenTo(Q.Items.FistOfDarkness) task.wait(1) Module.invokeServer("UseFistOfDarkness") end)
end
function GameModule.autoFireFlower(Module, Q)
    pcall(function() Module.tweenTo(Q.Items.FireFlower) task.wait(1) Module.invokeServer("UseFireFlower") end)
end
function GameModule.autoVolcanicMagnet(Module, Q)
    pcall(function() Module.tweenTo(Q.Items.VolcanicMagnet) task.wait(1) Module.invokeServer("UseVolcanicMagnet") end)
end
function GameModule.autoDragonHunter(Module, Q)
    pcall(function() Module.tweenTo(Q.Items.BlazeEmbers) task.wait(1) Module.invokeServer("DragonHunter") end)
end

function GameModule.startAutoCollectFruit(Module)
    Module.startLoop("AutoCollectFruit", 2, function()
        if not GameModule.State.AutoCollectFruit then return end
        for _, v in ipairs(WS:GetDescendants()) do
            if v.Name:find("Fruit") and v:IsA("Tool") then
                pcall(function()
                    local hrp = Module.getHRP()
                    if hrp and v.Handle then
                        hrp.CFrame = v.Handle.CFrame
                        task.wait(0.3)
                        pcall(function() fireclickdetector(v.Handle:FindFirstChildOfClass("ClickDetector")) end)
                    end
                end)
            end
        end
    end)
end

function GameModule.startAutoCollectGear(Module)
    Module.startLoop("AutoCollectGear", 2, function()
        if not GameModule.State.AutoCollectGear then return end
        for _, v in ipairs(WS:GetDescendants()) do
            if (v.Name:find("Gear") or v.Name:find("Chest")) and v:IsA("Model") then
                pcall(function()
                    local part = v.PrimaryPart or v:FindFirstChildOfClass("Part")
                    if part then
                        Module.getHRP().CFrame = part.CFrame
                        task.wait(0.5)
                        pcall(function() fireclickdetector(part:FindFirstChildOfClass("ClickDetector")) end)
                    end
                end)
            end
        end
    end)
end

function GameModule.autoTradeAzure(Module, Q)
    pcall(function() Module.tweenTo(Q.Items.AzureAmbers) task.wait(1) Module.invokeServer("TradeAzureAmbers") end)
end

-- ═══════════════════════════════════
-- ESP SYSTEMS
-- ═══════════════════════════════════
GameModule._espParts = {}

function GameModule.createESP(target, color, label)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_" .. target.Name
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.AlwaysOnTop = true
    bb.Adornee = target:FindFirstChild("HumanoidRootPart")
    bb.Parent = target
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = color or Color3.fromRGB(255, 100, 100)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.Text = label or target.Name
    txt.Parent = bb
    
    local hl = Instance.new("Highlight")
    hl.Name = "ESP_HL"
    hl.FillColor = color or Color3.fromRGB(255, 100, 100)
    hl.FillTransparency = 0.7
    hl.OutlineTransparency = 0.3
    hl.Parent = target
    
    table.insert(GameModule._espParts, {bb, hl})
end

function GameModule.startSeaBeastESP(Module)
    Module.startLoop("SeaBeastESP", 3, function()
        if not GameModule.State.SeaBeastESP then return end
        for _, v in ipairs(WS:GetDescendants()) do
            if v.Name:find("SeaBeast") or v.Name:find("Sea Beast") then
                if not v:FindFirstChild("ESP_" .. v.Name) then
                    GameModule.createESP(v, Color3.fromRGB(255, 60, 60), "🔴 Sea Beast")
                end
            end
        end
    end)
end

function GameModule.startGearESP(Module)
    Module.startLoop("GearESP", 3, function()
        if not GameModule.State.GearESP then return end
        for _, v in ipairs(WS:GetDescendants()) do
            if v.Name:find("Gear") or v.Name:find("Chest") then
                if v:IsA("Model") and not v:FindFirstChild("ESP_" .. v.Name) then
                    GameModule.createESP(v, Color3.fromRGB(60, 200, 255), "📦 " .. v.Name)
                end
            end
        end
    end)
end

function GameModule.clearESP()
    for _, parts in ipairs(GameModule._espParts) do
        for _, p in ipairs(parts) do pcall(function() p:Destroy() end) end
    end
    GameModule._espParts = {}
end

-- ═══════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════
function GameModule.unstoreFruit(Module)
    pcall(function() Module.invokeServer("UnstoreFruit") end)
    Module.notify("Utility", "Fruit unstored!")
end

function GameModule.pullLever(Module, Q)
    pcall(function() Module.tweenTo(Q.Locations.Lever) task.wait(1) Module.invokeServer("PullLever") end)
end

function GameModule.teleportTemple(Module, Q)
    Module.teleportTo(Q.Locations.Temple)
    Module.notify("Teleport", "Teleported to Temple!")
end

function GameModule.teleportDungeon(Module, Q)
    Module.teleportTo(Q.Locations.Dungeon)
    Module.notify("Teleport", "Teleported to Dungeon!")
end

function GameModule.redeemAllCodes(Module, Q)
    Module.notify("Codes", "Redeeming all codes...")
    for _, code in ipairs(Q.Codes) do
        pcall(function() Module.invokeServer("RedeemCode", code) end)
        task.wait(0.5)
    end
    Module.notify("Codes", "All codes redeemed!")
end

function GameModule.resetCharacter(Module)
    pcall(function()
        local hum = Module.getHumanoid()
        if hum then hum.Health = 0 end
    end)
end

function GameModule.autoTrainingDummy(Module, Q)
    Module.startLoop("AutoTraining", 0.5, function()
        if not GameModule.State.AutoTrainingDummy then return end
        Module.teleportTo(Q.Locations.TrainingDummy)
        Module.attackTarget(nil)
        for _, k in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V}) do
            Module.useSkill(k) task.wait(0.1)
        end
    end)
end

function GameModule.overheater(Module)
    Module.startLoop("Overheater", 0.5, function()
        if not GameModule.State.Overheater then return end
        -- Use Dragon Storm skill on sea events
        Module.useSkill(Enum.KeyCode.V)
        task.wait(0.3)
        Module.useSkill(Enum.KeyCode.C)
    end)
end

function GameModule.metaSlasher(Module)
    Module.startLoop("MetaSlasher", 0.5, function()
        if not GameModule.State.MetaSlasher then return end
        -- Fruit M1 attack on Sea Beast
        for _, v in ipairs(WS:GetDescendants()) do
            if v.Name:find("SeaBeast") and v:FindFirstChild("HumanoidRootPart") then
                Module.attackTarget(v)
                Module.useSkill(Enum.KeyCode.Z)
                break
            end
        end
    end)
end

-- ═══════════════════════════════════
-- SHOP SYSTEM
-- ═══════════════════════════════════
GameModule.Shop = {
    Melee = {"Combat", "Superhuman", "DeathStep", "SharkmanKarate", "ElectricClaw", "DragonTalon", "GodHuman"},
    Sword = {"Katana", "Cutlass", "DualKatana", "IronMace", "Pipe", "TrippleKatana", "TrippleDarkBlade", "Saddi", "Wando", "Shisui", "YamaSword", "TrueTripleKatana", "CursedDualKatana", "Saber", "Bisento", "PoleV2", "DarkBlade", "BuddySword", "MidnightBlade", "Rengoku", "Sharksaw", "Swordfish", "Canvander", "GravityCane", "Hallow", "BuddySword2", "Tushita"},
    Gun = {"Slingshot", "Musket", "Flintlock", "RefinedSlingshot", "RefinedFlintlock", "Cannon", "Kabucha", "BizarreRifle", "SerpentBow", "SoulGuitar", "AcidumRifle"},
    Ability = {"Observation", "Enhancement", "Conqueror"},
    Other = {"Race", "StatRefund", "FruitRemove"},
}

function GameModule.buyItem(Module, category, itemName)
    pcall(function()
        Module.invokeServer("BuyItem", itemName)
    end)
    Module.notify("Shop", "Purchased: " .. tostring(itemName))
end

-- ═══════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════
function GameModule.cleanup(Module)
    for key in pairs(GameModule.State) do
        if type(GameModule.State[key]) == "boolean" then
            GameModule.State[key] = false
        end
    end
    GameModule.clearESP()
    Module.stopAllLoops()
end

return GameModule
