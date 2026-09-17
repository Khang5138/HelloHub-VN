--[[
    ╔══════════════════════════════════════════╗
    ║   HelloHub - Blox Fruits                 ║
    ║   Logo tròn + Không teleport Dealer      ║
    ╚══════════════════════════════════════════╝
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Khang5138/HelloHub-VN/main/HelloHub.lua"))()
--]]

-- ===== SERVICES =====
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

print("[HelloHub] Loaded!")

-- ============================================================
-- ===== ANTI-BAN MODULE =====
-- ============================================================
local AntiBan = {
    Enabled = true, RandomDelay = true, HumanLikeClick = true,
    SafeTeleport = true, AutoBreak = true, FakeActivity = true,
    BreakInterval = 900, BreakDuration = 60,
}

-- ===== BIẾN TOÀN CỤC =====
local Toggles = {
    AutoFarm = false, SpeedFarm = false, ChestFarm = false,
    AutoFruitDrop = false, AutoMastery = false, AutoQuest = false,
    AutoGacha = false, AutoStoreFruit = false, AutoRaid = false,
    AutoTribe = false, AuraKill = false, AutoStat = false,
    AutoNewQuest = false,
    AntiBanEnabled = true, AntiBanRandomDelay = true,
    AntiBanHumanClick = true, AntiBanSafeTeleport = true,
    AntiBanAutoBreak = true, AntiBanFakeActivity = true,
}
local MasteryWeapon = "Nearest"
local FarmWeapon = "Nearest"
local SpeedFarmWeapon = "Nearest"
local StatChoice = "Melee"
local AuraRange = 100
local LastQuestLevel = 0
local LastHopTime = 0

-- ===== DANH SÁCH TRÁI MYTHICAL =====
local MythicalFruits = {
    "Dragon", "Leopard", "Kitsune", "Dough", "Venom",
    "Control", "Spirit", "Mammoth", "T-Rex", "Gravity",
    "Shadow", "Portal", "Rumble", "Blizzard", "Pain",
    "Love", "Spider", "Sound", "Phoenix"
}

-- ===== MÀU =====
local Colors = {
    Bg = Color3.fromRGB(20, 20, 28),
    Tab = Color3.fromRGB(35, 35, 45),
    TabActive = Color3.fromRGB(0, 170, 255),
    BtnOff = Color3.fromRGB(60, 60, 75),
    BtnOn = Color3.fromRGB(0, 200, 100),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(0, 170, 255),
    Sub = Color3.fromRGB(150, 150, 170),
    Mythical = Color3.fromRGB(180, 80, 200),
    AntiBan = Color3.fromRGB(0, 200, 100),
    SwitchOff = Color3.fromRGB(70, 70, 85),
    SwitchOn = Color3.fromRGB(0, 200, 100),
    Sword = Color3.fromRGB(255, 150, 50),
}

-- ===== HÀM TIỆN ÍCH =====
local function getHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function teleportTo(pos)
    local hrp = getHRP()
    if hrp then hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end
end
local function attack()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
    end)
end

-- ===== ANTI-BAN HELPERS =====
local function randomDelay(min, max)
    if not AntiBan.RandomDelay then return end
    task.wait(math.random(min * 1000, max * 1000) / 1000)
end
local function humanClick()
    if not AntiBan.HumanLikeClick then attack() return end
    local clicks = math.random(1, 3)
    for i = 1, clicks do
        attack()
        task.wait(math.random(20, 80) / 1000)
    end
end
local function safeTeleport(targetPos)
    if not AntiBan.SafeTeleport then teleportTo(targetPos) return end
    local hrp = getHRP()
    if not hrp then return end
    local startPos = hrp.Position
    local distance = (targetPos - startPos).Magnitude
    if distance < 50 then teleportTo(targetPos) return end
    local steps = math.random(3, 5)
    for i = 1, steps do
        local alpha = i / steps
        local pos = startPos:Lerp(targetPos, alpha)
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        task.wait(math.random(30, 80) / 1000)
    end
end

-- ===== BAY CAO + ĐÁNH QUÁI =====
local function flyHighToMonster(monsterPos)
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(monsterPos.X, 100, monsterPos.Z)
    end
end

local function attackWithWeapon(weaponName)
    pcall(function()
        if weaponName == "Nearest" then
            humanClick()
        else
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local char = LocalPlayer.Character
            if char then
                local equipped = char:FindFirstChildOfClass("Tool")
                if not equipped or equipped.Name ~= weaponName then
                    if backpack then
                        local tool = backpack:FindFirstChild(weaponName)
                        if tool then
                            local humanoid = char:FindFirstChildOfClass("Humanoid")
                            if humanoid then humanoid:EquipTool(tool) end
                        end
                    end
                end
            end
            task.wait(0.05)
            humanClick()
        end
    end)
end

local function startFakeActivity()
    task.spawn(function()
        while AntiBan.Enabled do
            task.wait(math.random(30, 60))
            if AntiBan.FakeActivity then
                local hrp = getHRP()
                if hrp then
                    hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
                end
            end
        end
    end)
end
local function startAutoBreak()
    task.spawn(function()
        while AntiBan.Enabled do
            task.wait(AntiBan.BreakInterval)
            if AntiBan.AutoBreak then
                StarterGui:SetCore("SendNotification", {Title="🛡️"; Text="Nghỉ " .. AntiBan.BreakDuration .. "s..."; Duration=5})
                local saved = {}
                for k, v in pairs(Toggles) do
                    if not k:find("AntiBan") then saved[k] = v; Toggles[k] = false end
                end
                task.wait(AntiBan.BreakDuration)
                for k, v in pairs(saved) do Toggles[k] = v end
                StarterGui:SetCore("SendNotification", {Title="🛡️"; Text="Đã nghỉ xong!"; Duration=3})
            end
        end
    end)
end
startFakeActivity()
startAutoBreak()

-- ===== HÀM KHÁC =====
local function getPlayerLevel()
    local stats = LocalPlayer:FindFirstChild("Data")
    if stats then
        local lvl = stats:FindFirstChild("Level")
        if lvl then return lvl.Value end
    end
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, v in pairs(ls:GetChildren()) do
            if v.Name:find("Level") then return v.Value end
        end
    end
    return 0
end
local function getStatPoints()
    local stats = LocalPlayer:FindFirstChild("Data")
    if stats then
        local p = stats:FindFirstChild("Points") or stats:FindFirstChild("StatPoints")
        if p then return p.Value end
    end
    return 0
end

-- ===== TÌM QUÁI =====
local function getMonster()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") 
               and obj:FindFirstChild("HumanoidRootPart") then
                local hum = obj:FindFirstChild("Humanoid")
                if hum.Health > 0 and obj ~= LocalPlayer.Character then
                    local n = obj.Name
                    if not n:find("NPC") and not n:find("Barber") and not n:find("Shop")
                       and not n:find("Teller") and not n:find("Expert") 
                       and not n:find("Dealer") and not Players:GetPlayerFromCharacter(obj) then
                        local d = (obj.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < dist then nearest, dist = obj, d end
                    end
                end
            end
        end)
    end
    return nearest
end

local function getChest()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") and (obj.Name == "Chest" or obj.Name:find("Chest")) then
                local part = obj:FindFirstChild("HumanoidRootPart") 
                          or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end
        end)
    end
    return nearest
end

local function getFruitDrop()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if (obj:IsA("Tool") or obj:IsA("Model")) 
               and (obj.Name:find("Fruit") or obj.Name == "Fruit") then
                local part = obj:FindFirstChild("Handle") 
                          or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end
        end)
    end
    return nearest
end

-- ===== NHẶT TRÁI (KHÔNG FALLBACK DEALER) =====
local function pickUpFruit(fruit)
    if not fruit then return end
    pcall(function()
        local part = fruit:FindFirstChild("Handle") 
                  or fruit:FindFirstChild("HumanoidRootPart")
                  or fruit:FindFirstChildWhichIsA("BasePart")
        if not part then return end
        
        safeTeleport(part.Position)
        task.wait(0.2)
        
        if firetouchinterest and getHRP() then
            firetouchinterest(getHRP(), part, 0)
            task.wait(0.1)
            firetouchinterest(getHRP(), part, 1)
        end
        
        task.wait(0.1)
        attack()
    end)
end

local function getMythicalFruitOnMap()
    local foundFruit = nil
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if (obj:IsA("Tool") or obj:IsA("Model")) then
                local name = obj.Name
                local part = obj:FindFirstChild("Handle") 
                          or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    for _, fruitName in ipairs(MythicalFruits) do
                        if name:find(fruitName) then
                            foundFruit = obj
                            return
                        end
                    end
                end
            end
        end)
    end
    return foundFruit
end

local function getQuestNPCFixed()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    local names = {"Quest","Master","Captain","Bartender","Sword","Blade","Citizen","King","Baratie","Barto","Gan Fall","Usopp","Nami","Buggy","Smoker","Tashigi"}
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                local n = obj.Name
                for _, validName in ipairs(names) do
                    if n:find(validName) then
                        local d = (obj.Head.Position - hrp.Position).Magnitude
                        if d < dist then nearest, dist = obj, d end
                        break
                    end
                end
            end
        end)
    end
    return nearest
end

local function doQuestFixed()
    local npc = getQuestNPCFixed()
    if not npc or not npc:FindFirstChild("Head") then return false end
    local hrp = getHRP()
    if not hrp then return false end
    hrp.CFrame = CFrame.new(npc.Head.Position + Vector3.new(0, 0, 4))
    task.wait(0.5)
    local fired = false
    pcall(function()
        for _, obj in pairs(npc:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
                fireproximityprompt(obj)
                fired = true
                task.wait(0.2)
            end
        end
    end)
    if not fired then attack() end
    return true
end

local function doGacha()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local commF = remotes:FindFirstChild("CommF_")
            local commE = remotes:FindFirstChild("CommE_")
            if commF then
                pcall(function() commF:InvokeServer("BlackMarket", "BuyFruit") end)
                task.wait(0.2)
                pcall(function() commF:InvokeServer("Cousin", "BuyFruit") end)
                task.wait(0.2)
            end
            if commE then pcall(function() commE:InvokeServer("BuyFruit") end) end
        end
        local dealer
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") 
               and (obj.Name:find("Dealer") or obj.Name:find("Cousin")) then
                dealer = obj; break
            end
        end
        if dealer and dealer:FindFirstChild("HumanoidRootPart") then
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = CFrame.new(dealer.HumanoidRootPart.Position + Vector3.new(0, 0, 5))
                task.wait(0.3)
                for _, obj in pairs(dealer:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj.HoldDuration = 0
                        fireproximityprompt(obj)
                        task.wait(0.2)
                    end
                end
            end
        end
    end)
end

local function storeFruits()
    pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return end
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                local isFruit = tool.Name:find("Fruit") ~= nil
                for _, tag in pairs(tool:GetChildren()) do
                    if tag:IsA("StringValue") and tag.Name == "Fruit" then isFruit = true end
                end
                if isFruit then
                    local storage = Workspace:FindFirstChild("Fruit Storage") 
                                 or Workspace:FindFirstChild("Chest")
                    if storage then
                        local part = storage:FindFirstChildWhichIsA("BasePart") 
                                  or storage:FindFirstChild("HumanoidRootPart")
                        if part then
                            local hrp = getHRP()
                            if hrp then
                                hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 0, 5))
                                task.wait(0.3)
                                tool.Parent = storage
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function getEquippedWeapon()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Tool")
end

local function getMasteryWeapon()
    if MasteryWeapon == "Nearest" then return getEquippedWeapon() end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if char then
        for _, t in pairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name == MasteryWeapon then return t end
        end
    end
    if backpack then
        for _, t in pairs(backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name == MasteryWeapon then
                t.Parent = char
                return t
            end
        end
    end
    return nil
end

local function masteryAttack()
    pcall(function()
        local tool = getMasteryWeapon()
        if tool then tool:Activate(); humanClick() end
    end)
end

local function startRaid()
    pcall(function()
        local raidNPC
        for _, obj in pairs(Workspace:GetDescendants()) do
            if (obj.Name:find("Raid") or obj.Name:find("Awaken") 
                or obj.Name:find("Ancient")) and obj:FindFirstChild("Humanoid") then
                raidNPC = obj; break
            end
        end
        if raidNPC and raidNPC:FindFirstChild("Head") then
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = CFrame.new(raidNPC.Head.Position + Vector3.new(0, 0, 5))
                task.wait(0.5)
            end
            for _, obj in pairs(raidNPC:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                    fireproximityprompt(obj)
                    task.wait(0.3)
                end
            end
        end
    end)
end

local function getTribeNPC()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                local n = obj.Name
                if n:find("Trial") or n:find("Elder") or n:find("Sensei") 
                   or n:find("Cyborg") or n:find("Ghoul") or n:find("Mink") 
                   or n:find("Fishman") or n:find("Skypiea") then
                    local d = (obj.Head.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end
        end)
    end
    return nearest
end

local function doTribe()
    local npc = getTribeNPC()
    if not npc or not npc:FindFirstChild("Head") then return end
    local hrp = getHRP()
    if not hrp then return end
    hrp.CFrame = CFrame.new(npc.Head.Position + Vector3.new(0, 0, 4))
    task.wait(0.5)
    pcall(function()
        for _, obj in pairs(npc:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
                fireproximityprompt(obj)
                task.wait(0.3)
            end
        end
    end)
end

local function reduceLag()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, e in pairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Atmosphere") or e:IsA("Sky") then e:Destroy() end
        end
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false
        end
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") 
                   or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") 
                   or obj:IsA("PointLight") or obj:IsA("SpotLight") then
                    obj:Destroy()
                end
                if obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
            end)
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EffectsQuality = Enum.QualityLevel.Level01
    end)
    StarterGui:SetCore("SendNotification", {Title="HelloHub"; Text="✅ Đã giảm lag!"; Duration=3})
end

-- ===== AUTO FARM =====
local function autoFarmLoop()
    task.spawn(function()
        while Toggles.AutoFarm do
            local m = getMonster()
            if m and m:FindFirstChild("HumanoidRootPart") then
                flyHighToMonster(m.HumanoidRootPart.Position)
                task.wait(0.1)
                attackWithWeapon(FarmWeapon)
            end
            randomDelay(0.1, 0.2)
        end
    end)
end

-- ===== SPEED FARM =====
local function speedFarmLoop()
    task.spawn(function()
        while Toggles.SpeedFarm do
            local m = getMonster()
            if m and m:FindFirstChild("HumanoidRootPart") then
                flyHighToMonster(m.HumanoidRootPart.Position)
                task.wait(0.05)
                attackWithWeapon(SpeedFarmWeapon)
                attack()
                attack()
            end
            randomDelay(0.03, 0.08)
        end
    end)
end

-- ===== CHEST FARM =====
local function chestFarmLoop()
    task.spawn(function()
        while Toggles.ChestFarm do
            local c = getChest()
            if c then
                local p = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChildWhichIsA("BasePart")
                if p then
                    safeTeleport(p.Position)
                    task.wait(0.3)
                end
            end
            randomDelay(0.3, 0.6)
        end
    end)
end

-- ===== AURA KILL =====
local function createAuraHitbox()
    local hrp = getHRP()
    if not hrp then return end
    local old = hrp:FindFirstChild("HelloHub_AuraHitbox")
    if old then old:Destroy() end
    local hitbox = Instance.new("Part")
    hitbox.Name = "HelloHub_AuraHitbox"
    hitbox.Shape = Enum.PartType.Cylinder
    hitbox.Size = Vector3.new(1, AuraRange * 2, AuraRange * 2)
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Material = Enum.Material.ForceField
    hitbox.Color = Colors.Accent
    hitbox.Transparency = 0.85
    hitbox.Parent = hrp
    task.spawn(function()
        while Toggles.AuraKill and hitbox.Parent do
            local h = getHRP()
            if h then
                hitbox.CFrame = CFrame.new(h.Position) * CFrame.Angles(0, 0, math.rad(90))
            end
            task.wait(0.1)
        end
        if hitbox then hitbox:Destroy() end
    end)
end

local function getMonstersInRange(range)
    local monsters = {}
    local hrp = getHRP()
    if not hrp then return monsters end
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Humanoid.Health > 0 and obj ~= LocalPlayer.Character then
                    local n = obj.Name
                    if not n:find("NPC") and not n:find("Barber") and not n:find("Shop")
                       and not n:find("Dealer") and not Players:GetPlayerFromCharacter(obj) then
                        local d = (obj.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d <= range then table.insert(monsters, obj) end
                    end
                end
            end
        end)
    end
    return monsters
end

local function auraKillLoop()
    task.spawn(function()
        createAuraHitbox()
        while Toggles.AuraKill do
            local monsters = getMonstersInRange(AuraRange)
            for _, m in ipairs(monsters) do
                if not Toggles.AuraKill then break end
                for i = 1, 2 do
                    attack()
                    task.wait(math.random(50, 150) / 1000)
                end
            end
            randomDelay(0.1, 0.3)
        end
        local hrp = getHRP()
        if hrp then
            local hb = hrp:FindFirstChild("HelloHub_AuraHitbox")
            if hb then hb:Destroy() end
        end
    end)
end

local function addStat(statName)
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local commF = remotes:FindFirstChild("CommF_")
            if commF then commF:InvokeServer("AddPoint", statName) end
        end
    end)
end

local function autoStatLoop()
    task.spawn(function()
        while Toggles.AutoStat do
            if getStatPoints() > 0 then addStat(StatChoice) end
            task.wait(1)
        end
    end)
end

local function autoNewQuestLoop()
    task.spawn(function()
        while Toggles.AutoNewQuest do
            local level = getPlayerLevel()
            if level > LastQuestLevel then
                LastQuestLevel = level
                StarterGui:SetCore("SendNotification", {Title="HelloHub"; Text="📜 Level " .. level; Duration=3})
            end
            doQuestFixed()
            task.wait(5)
        end
    end)
end

-- ===== CHECK SHOP (KHÔNG TELEPORT DEALER) =====
local function checkShop()
    pcall(function()
        -- Bước 1: Remote mở shop
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local opened = false
        if remotes then
            local commF = remotes:FindFirstChild("CommF_")
            if commF then
                pcall(function() commF:InvokeServer("BlackMarket", "BuyFruit") end)
                pcall(function() commF:InvokeServer("Cousin", "BuyFruit") end)
                pcall(function() commF:InvokeServer("OpenShop") end)
                opened = true
            end
        end
        
        -- Bước 2: Fire ProximityPrompt shop trong tầm xa
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ProximityPrompt") then
                    local parent = obj.Parent
                    if parent then
                        local n = parent.Name or ""
                        if n:find("Shop") or n:find("Dealer") or n:find("Cousin")
                           or n:find("Barber") or n:find("Blacksmith") then
                            obj.HoldDuration = 0
                            obj.MaxActivationDistance = 999999
                            fireproximityprompt(obj)
                            opened = true
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
        
        -- Bước 3: Quét GUI
        task.wait(0.5)
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return end
        
        local foundItems = {}
        for _, gui in pairs(playerGui:GetChildren()) do
            pcall(function()
                if gui.Enabled then
                    for _, obj in pairs(gui:GetDescendants()) do
                        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                            local txt = string.lower(obj.Text or "")
                            if txt:find("buy") or txt:find("purchase") or txt:find("mua") 
                               or txt:find("%$") then
                                table.insert(foundItems, obj.Text)
                            end
                        end
                    end
                end
            end)
        end
        
        -- Bước 4: Thông báo (KHÔNG teleport)
        if #foundItems > 0 then
            StarterGui:SetCore("SendNotification", {
                Title = "🛒 Shop Check"; 
                Text = "Shop có " .. #foundItems .. " item!"; 
                Duration = 5;
            })
        elseif opened then
            StarterGui:SetCore("SendNotification", {
                Title = "🛒 HelloHub";
                Text = "Đã gửi lệnh mở shop (kiểm tra màn hình)";
                Duration = 5;
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "🛒 HelloHub";
                Text = "Không tìm thấy shop nào mở!";
                Duration = 5;
            })
        end
    end)
end

local function serverHop()
    local now = tick()
    if now - LastHopTime < 35 then
        local wait = math.ceil(35 - (now - LastHopTime))
        StarterGui:SetCore("SendNotification", {Title="🛡️"; Text="Đợi " .. wait .. "s..."; Duration=3})
        return
    end
    LastHopTime = now
    pcall(function()
        local servers = {}
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function() return game:HttpGet(url) end)
        if success and result then
            local data = HttpService:JSONDecode(result)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId and server.playing < 10 then
                    table.insert(servers, server.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        end
    end)
end

local function playMythicalSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://131961136"
        sound.Volume = 2
        sound.Parent = LocalPlayer:FindFirstChild("PlayerGui")
        sound:Play()
        task.wait(3)
        sound:Destroy()
    end)
end

local function doMythicalHop()
    local mythical = getMythicalFruitOnMap()
    if mythical then
        StarterGui:SetCore("SendNotification", {
            Title = "✨ MYTHICAL FOUND ✨";
            Text = "Phát hiện " .. mythical.Name .. "!";
            Duration = 5;
        })
        playMythicalSound()
        return
    end
    StarterGui:SetCore("SendNotification", {Title="HelloHub"; Text="🔄 Đang đổi server..."; Duration=3})
    task.wait(1)
    serverHop()
end

-- ===== VÒNG LẶP CHÍNH =====
RunService.Heartbeat:Connect(function()
    if not getHRP() then return end
    if Toggles.AutoFruitDrop then
        local f = getFruitDrop()
        if f then pickUpFruit(f) end
    end
    if Toggles.AutoMastery then
        local m = getMonster()
        if m and m:FindFirstChild("HumanoidRootPart") then
            local hrp = getHRP()
            if hrp then
                local d = (hrp.Position - m.HumanoidRootPart.Position).Magnitude
                if d > 15 then safeTeleport(m.HumanoidRootPart.Position) end
                masteryAttack()
            end
        end
    end
end)

task.spawn(function()
    while true do task.wait(3); if Toggles.AutoQuest then doQuestFixed() end end
end)
task.spawn(function()
    while true do task.wait(2); if Toggles.AutoGacha then doGacha() end end
end)
task.spawn(function()
    while true
