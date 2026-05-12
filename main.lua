--[[
    main.lua — Loader & Initialization
    Kloso Hub - Blox Fruits Script Hub
    Educational purposes only.
]]

-- Verify game
local placeIds = {
    [2753915549] = true, -- First Sea
    [4442272183] = true, -- Second Sea
    [7447423569] = true, -- Third Sea
    [10017331123969] = true, -- Pirate Sea / New Sea Instance
}

if not placeIds[game.PlaceId] then
    warn("Kloso Hub: Not in Blox Fruits! (PlaceId: " .. tostring(game.PlaceId) .. ")")
    return
end

-- Load modules from GitHub
local repo = "https://raw.githubusercontent.com/AtaberkCelil/KLOSO-FRUIT/main/"
local function fetch(name)
    local success, content = pcall(game.HttpGet, game, repo .. name)
    if not success or not content or content == "404: Not Found" then
        warn("Kloso Hub: Failed to download " .. name .. " (Error: " .. tostring(content) .. ")")
        return function() end
    end
    
    local func, err = loadstring(content)
    if not func then
        warn("Kloso Hub: Syntax error in " .. name .. ": " .. tostring(err))
        return function() end
    end
    
    local ok, res = pcall(func)
    if not ok then
        warn("Kloso Hub: Execution error in " .. name .. ": " .. tostring(res))
        return function() end
    end
    return res
end

local Module = fetch("Module.lua")
local Library = fetch("Library.lua")
local Quests = fetch("Quests.lua")
local GunModule = fetch("GunModule.lua")
local GuideModule = fetch("GuideModule.lua")
local GameModule = fetch("GameModule.lua")

-- ═══════════════════════════════════
-- INITIALIZE UI
-- ═══════════════════════════════════
Module.notify("Kloso Hub", "Loading... v" .. Module.Config.Version)

local Window = Library:CreateWindow({Title = "Kloso Hub v" .. Module.Config.Version})

-- ═══════ MAIN TAB ═══════
local MainTab = Window:AddTab({Name = "Main", Icon = "🏠"})
MainTab:AddSection("⚡ Guard System")
MainTab:AddToggle({Name = "Enable Guard (Anti-Kick)", Callback = function(v)
    if v then Module.enableGuard() else Module.disableGuard() end
end})
MainTab:AddSection("🎯 General")
MainTab:AddToggle({Name = "Disable Effects (Death/Spawn)", Callback = function(v)
    GameModule.State.DisableEffects = v
    if v then Module.disableEffects() end
end})
MainTab:AddToggle({Name = "Distance Indicator", Callback = function(v)
    GameModule.State.DistanceIndicator = v
    if v then Module.showDistanceIndicator("Quest", Quests.Locations.Temple.Position)
    else Module.hideDistanceIndicator() end
end})
MainTab:AddButton({Name = "Reset Character", Callback = function()
    GameModule.resetCharacter(Module)
end})
MainTab:AddButton({Name = "Redeem All Codes", Callback = function()
    GameModule.redeemAllCodes(Module, Quests)
end})

-- ═══════ FARM TAB ═══════
local FarmTab = Window:AddTab({Name = "Farm", Icon = "⚔️"})
FarmTab:AddSection("🌾 Auto Farm")
FarmTab:AddToggle({Name = "Auto Farm", Callback = function(v)
    GameModule.State.AutoFarm = v
    if v then GameModule.startAutoFarm(Module, Quests, GuideModule)
    else GameModule.stopAutoFarm(Module) end
end})
FarmTab:AddToggle({Name = "Dodge Farming", Callback = function(v)
    GameModule.State.DodgeFarm = v
end})
FarmTab:AddSlider({Name = "Dodge Offset", Min = 5, Max = 50, Default = 20, Callback = function(v)
    GameModule.State.DodgeOffset = v
end})
FarmTab:AddToggle({Name = "Use Skill Farming", Callback = function(v)
    GameModule.State.UseSkillFarm = v
end})
FarmTab:AddToggle({Name = "Fast Attack (Buddha Range)", Callback = function(v)
    GameModule.State.BuddhaRange = v
    Module.Config.AttackRange = v and Module.Config.BuddhaAttackRange or 60
end})
FarmTab:AddToggle({Name = "Mastery Grinding", Callback = function(v)
    GameModule.State.MasteryGrind = v
end})

FarmTab:AddDivider()
FarmTab:AddSection("🔫 Weapon")
FarmTab:AddDropdown({Name = "Select Weapon", Options = {"Melee", "Sword", "Fruit", "Gun"}, Default = "Melee", Callback = function(v)
    GameModule.State.SelectedWeapon = v
end})
FarmTab:AddToggle({Name = "Gun Rapid Fire", Callback = function(v)
    GameModule.State.GunRapidFire = v
    if v then GunModule.startRapidFire() else GunModule.stopRapidFire() end
end})
FarmTab:AddSlider({Name = "Rapid Fire Speed", Min = 1, Max = 20, Default = 10, Callback = function(v)
    GunModule.setRapidFireDelay(1 / (v * 5))
end})

FarmTab:AddDivider()
FarmTab:AddSection("🎯 Special Farm")
FarmTab:AddToggle({Name = "Meta Slasher (Fruit M1 Sea Beast)", Callback = function(v)
    GameModule.State.MetaSlasher = v
    if v then GameModule.metaSlasher(Module) else Module.stopLoop("MetaSlasher") end
end})
FarmTab:AddToggle({Name = "Auto Training Dummy", Callback = function(v)
    GameModule.State.AutoTrainingDummy = v
    if v then GameModule.autoTrainingDummy(Module, Quests) else Module.stopLoop("AutoTraining") end
end})
FarmTab:AddToggle({Name = "Overheater (Dragon Storm)", Callback = function(v)
    GameModule.State.Overheater = v
    if v then GameModule.overheater(Module) else Module.stopLoop("Overheater") end
end})

-- ═══════ SEA EVENTS TAB ═══════
local SeaTab = Window:AddTab({Name = "Sea Events", Icon = "🌊"})
SeaTab:AddSection("🏝️ Islands")
SeaTab:AddToggle({Name = "Auto Mirage Island", Callback = function(v)
    GameModule.State.AutoMirage = v
    if v then GameModule.startAutoMirage(Module, Quests) else Module.stopLoop("AutoMirage") end
end})
SeaTab:AddToggle({Name = "Auto Kitsune Island", Callback = function(v)
    GameModule.State.AutoKitsune = v
    if v then GameModule.startAutoKitsune(Module, Quests) else Module.stopLoop("AutoKitsune") end
end})
SeaTab:AddToggle({Name = "Auto Volcano Island", Callback = function(v)
    GameModule.State.AutoVolcano = v
    if v then GameModule.startAutoVolcano(Module, Quests) else Module.stopLoop("AutoVolcano") end
end})
SeaTab:AddToggle({Name = "Auto Frozen Dimension", Callback = function(v)
    GameModule.State.AutoFrozen = v
    if v then GameModule.startAutoFrozen(Module) else Module.stopLoop("AutoFrozen") end
end})
SeaTab:AddToggle({Name = "Use Volcanic Magnet", Callback = function(v) GameModule.State.AutoVolcanicMagnet = v end})

SeaTab:AddDivider()
SeaTab:AddSection("🐉 Sea Beasts")
SeaTab:AddToggle({Name = "Auto Attack Leviathan (BETA)", Callback = function(v)
    GameModule.State.AutoLeviathan = v
    if v then GameModule.startAutoLeviathan(Module) else Module.stopLoop("AutoLeviathan") end
end})
SeaTab:AddToggle({Name = "Sea Beast ESP", Callback = function(v)
    GameModule.State.SeaBeastESP = v
    if v then GameModule.startSeaBeastESP(Module) else Module.stopLoop("SeaBeastESP") GameModule.clearESP() end
end})

SeaTab:AddDivider()
SeaTab:AddSection("🚢 Boat")
SeaTab:AddDropdown({Name = "Select Ship", Options = Quests.Ships, Default = "Brigantine", Callback = function(v)
    GameModule.State.SelectedShip = v
end})
SeaTab:AddButton({Name = "Spawn Boat", Callback = function() Module.spawnBoat(GameModule.State.SelectedShip) end})
SeaTab:AddToggle({Name = "Boost Speed Boat", Callback = function(v)
    GameModule.State.BoostBoat = v
    if v then Module.boostSpeedBoat(3) end
end})
SeaTab:AddButton({Name = "Reset Character (Sea Events)", Callback = function() GameModule.resetCharacter(Module) end})

-- ═══════ DUNGEON TAB ═══════
local DungeonTab = Window:AddTab({Name = "Dungeon", Icon = "🏰"})
DungeonTab:AddSection("⚔️ Dungeon & Raid")
DungeonTab:AddToggle({Name = "Auto Dungeon", Callback = function(v)
    GameModule.State.AutoDungeon = v
    if v then GameModule.startAutoDungeon(Module) else Module.stopLoop("AutoDungeon") end
end})
DungeonTab:AddToggle({Name = "Auto Raid", Callback = function(v)
    GameModule.State.AutoRaid = v
    if v then GameModule.startAutoRaid(Module) else Module.stopLoop("AutoRaid") end
end})
DungeonTab:AddButton({Name = "Teleport to Dungeon", Callback = function()
    GameModule.teleportDungeon(Module, Quests)
end})

-- ═══════ BOSS TAB ═══════
local BossTab = Window:AddTab({Name = "Boss", Icon = "👹"})
BossTab:AddSection("🗡️ Auto Boss")
BossTab:AddToggle({Name = "Auto Rip Indra", Callback = function(v)
    GameModule.State.AutoIndra = v
    if v then GameModule.startAutoIndra(Module) else Module.stopLoop("Autorip_indra") end
end})
BossTab:AddToggle({Name = "Auto Tyrant Skies", Callback = function(v)
    GameModule.State.AutoTyrant = v
    if v then GameModule.startAutoTyrant(Module) else Module.stopLoop("AutoTyrant") end
end})
BossTab:AddToggle({Name = "Auto Darkbeard", Callback = function(v)
    GameModule.State.AutoDarkbeard = v
    if v then GameModule.startAutoDarkbeard(Module) else Module.stopLoop("AutoDarkbeard") end
end})

BossTab:AddDivider()
BossTab:AddSection("🏺 Items & Chalice")
BossTab:AddButton({Name = "Auto Sweet Chalice", Callback = function() GameModule.autoSweetChalice(Module, Quests) end})
BossTab:AddButton({Name = "Auto God Chalice", Callback = function() GameModule.autoGodChalice(Module, Quests) end})
BossTab:AddButton({Name = "Auto Fist of Darkness", Callback = function() GameModule.autoFistDarkness(Module, Quests) end})
BossTab:AddButton({Name = "Auto Fire Flower", Callback = function() GameModule.autoFireFlower(Module, Quests) end})
BossTab:AddButton({Name = "Auto Volcanic Magnet", Callback = function() GameModule.autoVolcanicMagnet(Module, Quests) end})
BossTab:AddButton({Name = "Auto Dragon Hunter (Blaze Embers)", Callback = function() GameModule.autoDragonHunter(Module, Quests) end})

-- ═══════ RACE TAB ═══════
local RaceTab = Window:AddTab({Name = "Race", Icon = "🏃"})
RaceTab:AddSection("🧬 Race Unlock")
RaceTab:AddToggle({Name = "Auto Ghoul Race", Callback = function(v)
    GameModule.State.AutoGhoul = v
    if v then GameModule.startAutoGhoul(Module, Quests) else Module.stopLoop("AutoGhoul") end
end})
RaceTab:AddToggle({Name = "Auto Cyborg Race", Callback = function(v)
    GameModule.State.AutoCyborg = v
    if v then GameModule.startAutoCyborg(Module, Quests) else Module.stopLoop("AutoCyborg") end
end})
RaceTab:AddToggle({Name = "Auto Race II", Callback = function(v)
    GameModule.State.AutoRace2 = v
    if v then GameModule.startAutoRace2(Module, Quests) else Module.stopLoop("AutoRace2") end
end})
RaceTab:AddToggle({Name = "Auto Race III", Callback = function(v)
    GameModule.State.AutoRace3 = v
    if v then GameModule.startAutoRace3(Module, Quests) else Module.stopLoop("AutoRace3") end
end})

RaceTab:AddDivider()
RaceTab:AddSection("⚡ Trial V4")
local raceSelection = "Human"
RaceTab:AddDropdown({Name = "Select Race", Options = {"Rabbit","Angel","Human","Shark","Cyborg","Ghoul"}, Default = "Human", Callback = function(v)
    raceSelection = v
end})
RaceTab:AddToggle({Name = "Auto Complete Trial V4", Callback = function(v)
    GameModule.State.AutoTrialV4 = v
    if v then GameModule.startAutoTrialV4(Module, Quests, raceSelection)
    else Module.stopLoop("AutoTrialV4") end
end})

-- ═══════ SKILLER TAB ═══════
local SkillerTab = Window:AddTab({Name = "Skiller", Icon = "✨"})
SkillerTab:AddSection("🎯 Collect & Utility")
SkillerTab:AddToggle({Name = "Auto Collect Fruit", Callback = function(v)
    GameModule.State.AutoCollectFruit = v
    if v then GameModule.startAutoCollectFruit(Module) else Module.stopLoop("AutoCollectFruit") end
end})
SkillerTab:AddToggle({Name = "Auto Collect Gear", Callback = function(v)
    GameModule.State.AutoCollectGear = v
    if v then GameModule.startAutoCollectGear(Module) else Module.stopLoop("AutoCollectGear") end
end})
SkillerTab:AddToggle({Name = "Gear ESP", Callback = function(v)
    GameModule.State.GearESP = v
    if v then GameModule.startGearESP(Module) else Module.stopLoop("GearESP") GameModule.clearESP() end
end})
SkillerTab:AddButton({Name = "Auto Trade Azure Ambers", Callback = function() GameModule.autoTradeAzure(Module, Quests) end})
SkillerTab:AddButton({Name = "Unstore Fruit", Callback = function() GameModule.unstoreFruit(Module) end})
SkillerTab:AddButton({Name = "Pull The Lever", Callback = function() GameModule.pullLever(Module, Quests) end})
SkillerTab:AddButton({Name = "Teleport to Temple", Callback = function() GameModule.teleportTemple(Module, Quests) end})

-- ═══════ SHOP TAB ═══════
local ShopTab = Window:AddTab({Name = "Shop", Icon = "🛒"})
local shopCategories = {"Melee", "Sword", "Gun", "Ability", "Other"}
for _, cat in ipairs(shopCategories) do
    ShopTab:AddSection("🛍️ " .. cat)
    local items = GameModule.Shop[cat] or {}
    for _, item in ipairs(items) do
        ShopTab:AddButton({Name = "Buy " .. item, Callback = function()
            GameModule.buyItem(Module, cat, item)
        end})
    end
    ShopTab:AddDivider()
end

-- ═══════ VISUAL TAB ═══════
local VisualTab = Window:AddTab({Name = "Visual", Icon = "🎨"})
VisualTab:AddSection("🎨 Visual Settings")
VisualTab:AddLabel("Customize visual effects in-game")
VisualTab:AddToggle({Name = "Disable Death Effect", Callback = function(v)
    if v then Module.disableEffects() end
end})
VisualTab:AddToggle({Name = "Disable Spawn Effect", Callback = function(v)
    if v then Module.disableEffects() end
end})
VisualTab:AddToggle({Name = "Remove Screen Blur", Callback = function(v)
    if v then Module.disableEffects() end
end})

-- ═══════ SETTINGS TAB ═══════
local SettingsTab = Window:AddTab({Name = "Settings", Icon = "⚙️"})
SettingsTab:AddSection("⚙️ Configuration")
SettingsTab:AddSlider({Name = "Tween Speed", Min = 50, Max = 500, Default = 250, Callback = function(v)
    Module.Config.TweenSpeed = v
end})
SettingsTab:AddSlider({Name = "Attack Range", Min = 20, Max = 200, Default = 60, Callback = function(v)
    Module.Config.AttackRange = v
end})
SettingsTab:AddSlider({Name = "Farm Height", Min = 5, Max = 50, Default = 20, Callback = function(v)
    Module.Config.FarmHeight = v
end})
SettingsTab:AddDivider()
SettingsTab:AddSection("📡 Info")
SettingsTab:AddLabel("Hub: Kloso Hub v" .. Module.Config.Version)
SettingsTab:AddLabel("Player: " .. tostring(plr.Name))
SettingsTab:AddLabel("Level: " .. tostring(Module.getPlayerLevel()))
SettingsTab:AddLabel("Sea: " .. tostring(Module.getPlayerSea()))
SettingsTab:AddDivider()
SettingsTab:AddButton({Name = "🔄 Unload Script", Callback = function()
    GameModule.cleanup(Module)
    GunModule.cleanup()
    Module.cleanup()
    Window:Destroy()
end})

-- ═══════════════════════════════════
-- DONE
-- ═══════════════════════════════════
Module.notify("Kloso Hub", "Loaded successfully! v" .. Module.Config.Version)
