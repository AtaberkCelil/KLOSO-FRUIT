--[[
    Quests.lua — Quest/NPC/Island Database
    Kloso Hub - Blox Fruits (All 3 Seas)
]]

local Quests = {}

-- Format: {Level, QuestName, NPC, EnemyName, EnemyCFrame, NPCCFrame, Sea}

Quests.FirstSea = {
    {1, "BanditQuest1", "Bandit Quest", "Bandit", CFrame.new(-1602, 36, 153), CFrame.new(-1537, 50, 100), 1},
    {10, "MonkeyQuest1", "Monkey Quest", "Monkey", CFrame.new(-1446, 41, -50), CFrame.new(-1537, 50, 100), 1},
    {15, "GorillaQuest", "Gorilla Quest", "Gorilla", CFrame.new(-1098, 15, 132), CFrame.new(-1131, 15, 189), 1},
    {30, "PirateQuest", "Pirate Quest", "Pirate", CFrame.new(-1189, 5, 3837), CFrame.new(-1137, 5, 3826), 1},
    {60, "BruteQuest", "Brute Quest", "Brute", CFrame.new(935, 55, 1422), CFrame.new(1040, 50, 1547), 1},
    {75, "DesertBanditQuest", "Desert Bandit Quest", "Desert Bandit", CFrame.new(897, 6, 4389), CFrame.new(912, 6, 4474), 1},
    {90, "DesertOfficerQuest", "Desert Officer Quest", "Desert Officer", CFrame.new(1581, 7, 3891), CFrame.new(1549, 7, 3886), 1},
    {100, "SandBossQuest", "Sand Boss Quest", "Sand Boss", CFrame.new(1571, 11, 4376), CFrame.new(1549, 7, 3886), 1},
    {120, "ToggleQuest", "Toggle Quest", "Toggle", CFrame.new(-7866, 5608, -380), CFrame.new(-7894, 5607, -381), 1},
    {150, "BuggyQuest", "Buggy Quest", "Buggy Pirate", CFrame.new(-1027, 58, -503), CFrame.new(-1027, 50, -513), 1},
    {175, "CrabQuest", "Crab Quest", "Crab", CFrame.new(-1508, 4, -178), CFrame.new(-1537, 50, 100), 1},
    {190, "CrowQuest", "Crow Quest", "Crow", CFrame.new(-358, 73, 1937), CFrame.new(-382, 73, 1903), 1},
    {225, "IceSideQuest", "Ice Quest", "Ice Viking", CFrame.new(1262, 87, -1313), CFrame.new(1206, 91, -1497), 1},
    {250, "SkyIslandQuest", "Sky Quest", "Sky Bandit", CFrame.new(-4899, 717, -2783), CFrame.new(-4857, 717, -2812), 1},
    {275, "SkyIslandQuest2", "Sky Quest 2", "Dark Master", CFrame.new(-4998, 717, -2830), CFrame.new(-4857, 717, -2812), 1},
    {300, "PrisonQuest", "Prison Quest", "Prisoner", CFrame.new(-4602, 16, -2765), CFrame.new(-4618, 16, -2707), 1},
    {325, "PrisonQuest2", "Prison Quest 2", "Chief Warden", CFrame.new(-4602, 16, -2765), CFrame.new(-4618, 16, -2707), 1},
    {350, "ColosseumQuest", "Colosseum Quest", "Toga Warrior", CFrame.new(-1494, 7, -2942), CFrame.new(-1574, 7, -2891), 1},
    {375, "ColosseumQuest2", "Colosseum Quest 2", "Gladiator", CFrame.new(-1494, 7, -2942), CFrame.new(-1574, 7, -2891), 1},
    {400, "MagmaQuest", "Magma Quest", "Military Soldier", CFrame.new(-5313, 12, 8517), CFrame.new(-5257, 12, 8476), 1},
    {425, "MagmaQuest2", "Magma Quest 2", "Military Spy", CFrame.new(-5313, 12, 8517), CFrame.new(-5257, 12, 8476), 1},
    {450, "FishmanQuest", "Fishman Quest", "Fishman Warrior", CFrame.new(61093, 17, 1554), CFrame.new(61163, 14, 1515), 1},
    {475, "FishmanQuest2", "Fishman Quest 2", "Fishman Captain", CFrame.new(61093, 17, 1554), CFrame.new(61163, 14, 1515), 1},
    {500, "RobotQuest", "Robot Quest", "Cyborg", CFrame.new(633, 34, -244), CFrame.new(568, 34, -220), 1},
    {525, "RobotQuest2", "Robot Quest 2", "Cyborg Boss", CFrame.new(633, 34, -244), CFrame.new(568, 34, -220), 1},
    {550, "ZombieQuest", "Zombie Quest", "Zombie", CFrame.new(-5125, 76, -4852), CFrame.new(-5114, 76, -4736), 1},
    {575, "ZombieQuest2", "Zombie Quest 2", "Zombie Boss", CFrame.new(-5125, 76, -4852), CFrame.new(-5114, 76, -4736), 1},
    {625, "SwampQuest", "Swamp Quest", "Swamp Monster", CFrame.new(-94, 14, 3107), CFrame.new(-94, 14, 3107), 1},
    {650, "SwampQuest2", "Swamp Quest 2", "Swamp Boss", CFrame.new(-94, 14, 3107), CFrame.new(-94, 14, 3107), 1},
    {675, "FountainQuest", "Fountain Quest", "Galley Pirate", CFrame.new(5254, 38, 4054), CFrame.new(5254, 38, 4054), 1},
}

Quests.SecondSea = {
    {700, "AreaQuest1", "Area 1 Quest", "Raider", CFrame.new(-429, 73, 1836), CFrame.new(-382, 73, 1903), 2},
    {725, "KingdomQuest", "Kingdom Quest", "Kingdom Guard", CFrame.new(-2199, 73, -6715), CFrame.new(-2292, 73, -6663), 2},
    {750, "KingdomQuest2", "Kingdom Quest 2", "Kingdom Soldier", CFrame.new(-2199, 73, -6715), CFrame.new(-2292, 73, -6663), 2},
    {775, "GraveyardQuest", "Graveyard Quest", "Graveyard Zombie", CFrame.new(-5448, 48, -793), CFrame.new(-5428, 48, -863), 2},
    {800, "GraveyardQuest2", "Graveyard Quest 2", "Reborn Skeleton", CFrame.new(-5448, 48, -793), CFrame.new(-5428, 48, -863), 2},
    {850, "SnowQuest", "Snow Quest", "Snow Trooper", CFrame.new(1374, 87, -1302), CFrame.new(1206, 91, -1497), 2},
    {875, "SnowQuest2", "Snow Quest 2", "Arctic Warrior", CFrame.new(1374, 87, -1302), CFrame.new(1206, 91, -1497), 2},
    {900, "IceSideQuest2", "Ice Quest 2", "Ice Master", CFrame.new(5641, 25, -6055), CFrame.new(5625, 25, -6117), 2},
    {925, "ForgottenQuest", "Forgotten Quest", "Forgotten Island Fighter", CFrame.new(-3053, 237, -10163), CFrame.new(-3062, 237, -10101), 2},
    {950, "PirateVillageQuest", "Pirate Village Quest", "Pirate Millionaire", CFrame.new(-281, 44, 5382), CFrame.new(-248, 44, 5438), 2},
    {975, "PirateVillageQuest2", "Pirate Village Quest 2", "Pirate Raid Captain", CFrame.new(-281, 44, 5382), CFrame.new(-248, 44, 5438), 2},
    {1000, "MarineQuest", "Marine Quest", "Marine Captain", CFrame.new(-4675, 20, 4350), CFrame.new(-4675, 20, 4400), 2},
    {1050, "GreenZoneQuest", "Green Zone Quest", "Green Zone Fighter", CFrame.new(-2446, 73, -3218), CFrame.new(-2416, 73, -3148), 2},
    {1100, "GreenZoneQuest2", "Green Zone Quest 2", "Green Zone Boss", CFrame.new(-2446, 73, -3218), CFrame.new(-2416, 73, -3148), 2},
    {1125, "DarkAreaQuest", "Dark Area Quest", "Dark Master 2", CFrame.new(3850, 23, -1984), CFrame.new(3842, 23, -1918), 2},
    {1150, "DarkAreaQuest2", "Dark Area Quest 2", "Dark Lord", CFrame.new(3850, 23, -1984), CFrame.new(3842, 23, -1918), 2},
    {1175, "CursedShipQuest", "Cursed Ship Quest", "Cursed Captain", CFrame.new(916, 130, 33200), CFrame.new(940, 130, 33280), 2},
    {1200, "CursedShipQuest2", "Cursed Ship Quest 2", "Cursed Commander", CFrame.new(916, 130, 33200), CFrame.new(940, 130, 33280), 2},
    {1250, "IceCreamQuest", "Ice Cream Quest", "Ice Cream Officer", CFrame.new(-865, 119, -10690), CFrame.new(-885, 119, -10620), 2},
    {1300, "IceCreamQuest2", "Ice Cream Quest 2", "Ice Cream Commander", CFrame.new(-865, 119, -10690), CFrame.new(-885, 119, -10620), 2},
    {1325, "DeandraQuest", "Deandra Quest", "Deandra Fighter", CFrame.new(2215, 27, -6075), CFrame.new(2185, 27, -6005), 2},
    {1350, "FountainQuest2", "Fountain Quest 2", "Fountain Fighter", CFrame.new(5254, 38, 4054), CFrame.new(5254, 38, 4054), 2},
    {1375, "UsoappIslandQuest", "Usoapp Quest", "Usoapp Fighter", CFrame.new(4851, 7, -7509), CFrame.new(4895, 7, -7475), 2},
    {1400, "UsoappIslandQuest2", "Usoapp Quest 2", "Usoapp Captain", CFrame.new(4851, 7, -7509), CFrame.new(4895, 7, -7475), 2},
    {1425, "AmazonQuest", "Amazon Quest", "Amazon Warrior", CFrame.new(5668, 59, -6512), CFrame.new(5625, 25, -6117), 2},
    {1450, "AmazonQuest2", "Amazon Quest 2", "Amazon Champion", CFrame.new(5668, 59, -6512), CFrame.new(5625, 25, -6117), 2},
}

Quests.ThirdSea = {
    {1500, "PortTownQuest", "Port Town Quest", "Mercenary", CFrame.new(-290, 44, 5536), CFrame.new(-290, 44, 5536), 3},
    {1525, "PortTownQuest2", "Port Town Quest 2", "Mercenary Captain", CFrame.new(-290, 44, 5536), CFrame.new(-290, 44, 5536), 3},
    {1550, "HydraIslandQuest", "Hydra Island Quest", "Hydra Fighter", CFrame.new(-104, 30, -7150), CFrame.new(-106, 30, -7085), 3},
    {1575, "HydraIslandQuest2", "Hydra Island Quest 2", "Hydra Captain", CFrame.new(-104, 30, -7150), CFrame.new(-106, 30, -7085), 3},
    {1600, "GreatTreeQuest", "Great Tree Quest", "Tree Fighter", CFrame.new(-7877, 5547, -381), CFrame.new(-7894, 5607, -381), 3},
    {1625, "GreatTreeQuest2", "Great Tree Quest 2", "Tree Captain", CFrame.new(-7877, 5547, -381), CFrame.new(-7894, 5607, -381), 3},
    {1650, "FloatingTurtleQuest", "Floating Turtle Quest", "Turtle Fighter", CFrame.new(-13232, 332, -7626), CFrame.new(-13190, 332, -7560), 3},
    {1675, "FloatingTurtleQuest2", "Floating Turtle Quest 2", "Turtle Captain", CFrame.new(-13232, 332, -7626), CFrame.new(-13190, 332, -7560), 3},
    {1700, "MansionQuest", "Mansion Quest", "Mansion Guard", CFrame.new(-12472, 332, -7546), CFrame.new(-12472, 332, -7546), 3},
    {1725, "MansionQuest2", "Mansion Quest 2", "Mansion Captain", CFrame.new(-12472, 332, -7546), CFrame.new(-12472, 332, -7546), 3},
    {1775, "CastleQuest", "Castle Quest", "Castle Guard", CFrame.new(-5091, 297, -2901), CFrame.new(-5091, 297, -2901), 3},
    {1825, "CastleQuest2", "Castle Quest 2", "Castle Knight", CFrame.new(-5091, 297, -2901), CFrame.new(-5091, 297, -2901), 3},
    {1875, "HauntedCastleQuest", "Haunted Castle Quest", "Haunted Fighter", CFrame.new(-9515, 159, -180), CFrame.new(-9515, 159, -180), 3},
    {1925, "HauntedCastleQuest2", "Haunted Castle Quest 2", "Haunted Captain", CFrame.new(-9515, 159, -180), CFrame.new(-9515, 159, -180), 3},
    {1975, "PumpkinQuest", "Pumpkin Quest", "Pumpkin Fighter", CFrame.new(-8063, 115, -1162), CFrame.new(-8063, 115, -1162), 3},
    {2025, "TikiIslandQuest", "Tiki Island Quest", "Tiki Fighter", CFrame.new(2143, 27, -6218), CFrame.new(2185, 27, -6005), 3},
    {2075, "TikiIslandQuest2", "Tiki Island Quest 2", "Tiki Captain", CFrame.new(2143, 27, -6218), CFrame.new(2185, 27, -6005), 3},
    {2100, "VolcanoQuest", "Volcano Quest", "Volcano Fighter", CFrame.new(-5350, 400, 8480), CFrame.new(-5350, 400, 8480), 3},
    {2200, "KitsuneQuest", "Kitsune Quest", "Kitsune Fighter", CFrame.new(-8000, 100, -4000), CFrame.new(-8000, 100, -4000), 3},
    {2300, "LeviathanQuest", "Leviathan Quest", "Leviathan Minion", CFrame.new(0, 50, -15000), CFrame.new(0, 50, -15000), 3},
    {2400, "TyrantQuest", "Tyrant Quest", "Tyrant Fighter", CFrame.new(-9000, 200, -3000), CFrame.new(-9000, 200, -3000), 3},
    {2500, "FinalQuest", "Final Quest", "Final Boss Minion", CFrame.new(-10000, 300, -5000), CFrame.new(-10000, 300, -5000), 3},
}

-- Boss Locations
Quests.Bosses = {
    {Sea = 1, Name = "Saber Expert", CFrame = CFrame.new(-1446, 41, -50), Level = 200},
    {Sea = 1, Name = "Don Swan", CFrame = CFrame.new(916, 130, 33200), Level = 1000},
    {Sea = 2, Name = "Darkbeard", CFrame = CFrame.new(3850, 23, -1984), Level = 1000},
    {Sea = 2, Name = "Order", CFrame = CFrame.new(916, 130, 33200), Level = 1250},
    {Sea = 3, Name = "Rip_Indra", CFrame = CFrame.new(-5091, 297, -2901), Level = 1500},
    {Sea = 3, Name = "Leviathan", CFrame = CFrame.new(0, 50, -15000), Level = 2000},
    {Sea = 3, Name = "Tyrant", CFrame = CFrame.new(-9000, 200, -3000), Level = 2200},
}

-- Special Locations
Quests.Locations = {
    MirageIsland = CFrame.new(15000, 50, 15000),
    KitsuneIsland = CFrame.new(-8000, 100, -4000),
    VolcanoIsland = CFrame.new(-5350, 400, 8480),
    FrozenDimension = CFrame.new(-6000, 100, -6000),
    Dungeon = CFrame.new(-4605, 16, -2765),
    Temple = CFrame.new(-7894, 5607, -381),
    Mansion = CFrame.new(-12472, 332, -7546),
    CastleOnSea = CFrame.new(-5091, 297, -2901),
    Impeldown = CFrame.new(-4602, 16, -2765),
    TikiIsland = CFrame.new(2143, 27, -6218),
    FruitDealer1 = CFrame.new(-32, 15, -65),
    FruitDealer2 = CFrame.new(-2292, 73, -6663),
    FruitDealer3 = CFrame.new(-290, 44, 5536),
    TrainingDummy = CFrame.new(-7877, 5547, -500),
    Lever = CFrame.new(-7800, 5607, -350),
}

-- Race V2/V3/V4 Locations
Quests.RaceLocations = {
    GhoulRace = CFrame.new(-5125, 76, -4852),
    CyborgRace = CFrame.new(633, 34, -244),
    RaceV2_NPC = CFrame.new(-1574, 7, -2891),
    RaceV3_NPC = CFrame.new(-5091, 297, -2901),
    TrialV4 = {
        Rabbit = CFrame.new(-8000, 200, -3000),
        Angel = CFrame.new(-7500, 200, -3500),
        Human = CFrame.new(-7000, 200, -4000),
        Shark = CFrame.new(-6500, 200, -4500),
        Cyborg = CFrame.new(-6000, 200, -5000),
        Ghoul = CFrame.new(-5500, 200, -5500),
    },
}

-- Chalice/Item Locations
Quests.Items = {
    SweetChalice = CFrame.new(-2292, 73, -6663),
    GodChalice = CFrame.new(-5091, 297, -2901),
    FistOfDarkness = CFrame.new(3850, 23, -1984),
    FireFlower = CFrame.new(-5350, 400, 8480),
    VolcanicMagnet = CFrame.new(-5350, 400, 8480),
    AzureAmbers = CFrame.new(-8000, 100, -4000),
    BlazeEmbers = CFrame.new(-5350, 400, 8480),
    AncientOne = CFrame.new(-7894, 5607, -381),
}

-- Ship List
Quests.Ships = {"Dingy","Sloop","Caravel","Brigantine","Galleon","Guardian","PirateBrigade","Enforcer","Sentinel"}

-- Redeem Codes
Quests.Codes = {
    "SUB2GAMERROBOT_RESET1","FUDD10","BIGNEWS","THEGREATACE","SUB2OFFICIALNOOBIE",
    "ADMINGIVEAWAY","Enyu_is_Pro","JCWK","TantaiGaming","MAGICBUS",
    "Sub2UncleKizaru","Axiore","Bluxxy","SUB2NOOBMASTER123","StrawHatMaine",
    "Sub2Daigrock","DEVSCOOKING","UPDATE20","KITUPDATE","THIRDSEA",
}

-- Get quest for player level
function Quests.getQuestForLevel(level, sea)
    local questList
    if sea == 3 then questList = Quests.ThirdSea
    elseif sea == 2 then questList = Quests.SecondSea
    else questList = Quests.FirstSea end
    
    local best = questList[1]
    for _, q in ipairs(questList) do
        if q[1] <= level then
            best = q
        end
    end
    return best
end

function Quests.getAllQuests()
    local all = {}
    for _, q in ipairs(Quests.FirstSea) do table.insert(all, q) end
    for _, q in ipairs(Quests.SecondSea) do table.insert(all, q) end
    for _, q in ipairs(Quests.ThirdSea) do table.insert(all, q) end
    return all
end

return Quests
