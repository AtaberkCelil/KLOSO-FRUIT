--[[
    GuideModule.lua — Leveling Guide & Adaptive Farming
    Kloso Hub - Blox Fruits
]]

local GuideModule = {}

local Players = game:GetService("Players")
local plr = Players.LocalPlayer

GuideModule.Config = {
    WaitForEnemies = true,
    WaitTimeout = 10,
    AdaptiveLevel = true,
}

-- Determine optimal sea for level
function GuideModule.getOptimalSea(level)
    if level >= 1500 then return 3
    elseif level >= 700 then return 2
    else return 1 end
end

-- Get recommended quest info for current level
function GuideModule.getRecommendation(Quests, level)
    local sea = GuideModule.getOptimalSea(level)
    local quest = Quests.getQuestForLevel(level, sea)
    
    if not quest then return nil end
    
    return {
        Sea = sea,
        Level = quest[1],
        QuestName = quest[2],
        QuestTitle = quest[3],
        EnemyName = quest[4],
        EnemyCFrame = quest[5],
        NPCCFrame = quest[6],
    }
end

-- Check if player needs to switch seas
function GuideModule.shouldSwitchSea(Module, Quests)
    local level = Module.getPlayerLevel()
    local currentSea = Module.getPlayerSea()
    local optimalSea = GuideModule.getOptimalSea(level)
    return currentSea ~= optimalSea, optimalSea
end

-- Auto Second Sea transition
function GuideModule.autoSecondSea(Module)
    local level = Module.getPlayerLevel()
    if level < 700 then
        Module.notify("Guide", "Need level 700+ for Second Sea")
        return false
    end
    
    pcall(function()
        Module.invokeServer("TravelMain")
        task.wait(1)
        Module.invokeServer("TravelDressrosa")
    end)
    
    Module.notify("Guide", "Traveling to Second Sea...")
    return true
end

-- Auto Third Sea transition  
function GuideModule.autoThirdSea(Module)
    local level = Module.getPlayerLevel()
    if level < 1500 then
        Module.notify("Guide", "Need level 1500+ for Third Sea")
        return false
    end
    
    pcall(function()
        Module.invokeServer("TravelZou")
    end)
    
    Module.notify("Guide", "Traveling to Third Sea...")
    return true
end

-- Wait for enemies to spawn
function GuideModule.waitForEnemies(Module, enemyName, timeout)
    timeout = timeout or GuideModule.Config.WaitTimeout
    local startTime = tick()
    
    while tick() - startTime < timeout do
        local enemy = Module.getNearestEnemyByName(enemyName, 500)
        if enemy then return enemy end
        task.wait(0.5)
    end
    
    return nil
end

-- Adaptive level update - picks next best quest if stuck
function GuideModule.adaptiveUpdate(Module, Quests, currentQuestLevel)
    local level = Module.getPlayerLevel()
    local sea = Module.getPlayerSea()
    
    -- If player level is significantly above quest level, move up
    if level - currentQuestLevel > 25 then
        local newQuest = Quests.getQuestForLevel(level, sea)
        if newQuest and newQuest[1] > currentQuestLevel then
            return newQuest
        end
    end
    
    return nil
end

-- Mastery grinding logic
function GuideModule.getMasteryTarget(Module)
    local char = Module.getCharacter()
    if not char then return nil end
    
    -- Find equipped weapon/fruit and check mastery
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            return tool.Name
        end
    end
    
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                return tool.Name
            end
        end
    end
    
    return nil
end

function GuideModule.cleanup()
    -- Nothing persistent to clean
end

return GuideModule
