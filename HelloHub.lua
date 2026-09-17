--[[
    ╔══════════════════════════════════════════════╗
    ║   HelloHub - Blox Fruits                     ║
    ║   Toggle Switch + Kéo logo + Farm riêng biệt ║
    ╚══════════════════════════════════════════════╝
    
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

-- ===== CHECK BLOX FRUITS =====
if not game:IsLoaded() then game.Loaded:Wait() end
local validPlaces = {2753915549, 4442272183, 7449423635}
local isBF = false
for _, id in pairs(validPlaces) do
    if game.PlaceId == id then isBF = true break end
end
if not isBF then
    StarterGui:SetCore("SendNotification", {Title="HelloHub"; Text="❌ Chỉ Blox Fruits!"; Duration=5})
    return
end

print("[HelloHub V8] Loaded!")

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
    AutoNewQuest = false, MythicalHop = false,
    AntiBanEnabled = true, AntiBanRandomDelay = true,
    AntiBanHumanClick = true, AntiBanSafeTeleport = true,
    AntiBanAutoBreak = true, AntiBanFakeActivity = true,
}
local MasteryWeapon = "Nearest"
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

-- ===== TÌM RƯƠNG =====
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

local function pickUpFruit(fruit)
    if not fruit then return end
    pcall(function()
        local part = fruit:FindFirstChild("Handle") 
                  or fruit:FindFirstChildWhichIsA("BasePart")
        if part then
            safeTeleport(part.Position)
            task.wait(0.1)
            if firetouchinterest and getHRP() then
                firetouchinterest(getHRP(), part, 0)
                task.wait(0.05)
                firetouchinterest(getHRP(), part, 1)
            end
        end
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

-- ===== 3 LOOP FARM ĐỘC LẬP =====
-- Auto Farm: bay đến quái + đánh chậm
local function autoFarmLoop()
    task.spawn(function()
        while Toggles.AutoFarm do
            local m = getMonster()
            if m and m:FindFirstChild("HumanoidRootPart") then
                safeTeleport(m.HumanoidRootPart.Position)
                humanClick()
            end
            randomDelay(0.1, 0.2)
        end
    end)
end

-- Speed Farm: bay + đánh cực nhanh
local function speedFarmLoop()
    task.spawn(function()
        while Toggles.SpeedFarm do
            local m = getMonster()
            if m and m:FindFirstChild("HumanoidRootPart") then
                local hrp = getHRP()
                if hrp then
                    safeTeleport(m.HumanoidRootPart.Position)
                    for i = 1, 3 do
                        attack()
                        task.wait(math.random(20, 60) / 1000)
                    end
                end
            end
            randomDelay(0.03, 0.08)
        end
    end)
end

-- Chest Farm: chỉ bay đến rương, KHÔNG đánh quái
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

local function checkShop()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end
    local foundItems = {}
    for _, gui in pairs(playerGui:GetChildren()) do
        pcall(function()
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    local txt = string.lower(obj.Text or "")
                    if txt:find("buy") or txt:find("purchase") or txt:find("mua") then
                        table.insert(foundItems, obj.Text)
                    end
                end
            end
        end)
    end
    if #foundItems > 0 then
        StarterGui:SetCore("SendNotification", {Title="HelloHub Shop"; Text="🛒 Shop có " .. #foundItems .. " item!"; Duration=5})
    else
        StarterGui:SetCore("SendNotification", {Title="HelloHub"; Text="🛒 Không thấy shop!"; Duration=5})
    end
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
    while true do task.wait(5); if Toggles.AutoStoreFruit then storeFruits() end end
end)
task.spawn(function()
    while true do task.wait(5); if Toggles.AutoRaid then startRaid() end end
end)
task.spawn(function()
    while true do task.wait(3); if Toggles.AutoTribe then doTribe() end end
end)

-- ===== QUẢN LÝ LOOP =====
task.spawn(function()
    while true do
        task.wait(0.5)
        AntiBan.Enabled = Toggles.AntiBanEnabled ~= false
        AntiBan.RandomDelay = Toggles.AntiBanRandomDelay ~= false
        AntiBan.HumanLikeClick = Toggles.AntiBanHumanClick ~= false
        AntiBan.SafeTeleport = Toggles.AntiBanSafeTeleport ~= false
        AntiBan.AutoBreak = Toggles.AntiBanAutoBreak ~= false
        AntiBan.FakeActivity = Toggles.AntiBanFakeActivity ~= false

        if Toggles.AutoFarm and not _G._autoFarmRun then
            _G._autoFarmRun = true; autoFarmLoop()
        elseif not Toggles.AutoFarm then _G._autoFarmRun = false end

        if Toggles.SpeedFarm and not _G._speedRun then
            _G._speedRun = true; speedFarmLoop()
        elseif not Toggles.SpeedFarm then _G._speedRun = false end

        if Toggles.ChestFarm and not _G._chestRun then
            _G._chestRun = true; chestFarmLoop()
        elseif not Toggles.ChestFarm then _G._chestRun = false end

        if Toggles.AuraKill and not _G._auraRun then
            _G._auraRun = true; auraKillLoop()
        elseif not Toggles.AuraKill then _G._auraRun = false end

        if Toggles.AutoStat and not _G._statRun then
            _G._statRun = true; autoStatLoop()
        elseif not Toggles.AutoStat then _G._statRun = false end

        if Toggles.AutoNewQuest and not _G._newQuestRun then
            _G._newQuestRun = true; autoNewQuestLoop()
        elseif not Toggles.AutoNewQuest then _G._newQuestRun = false end

        if Toggles.MythicalHop and not _G._hopRun then
            _G._hopRun = true
            task.spawn(function()
                while Toggles.MythicalHop do
                    doMythicalHop()
                    task.wait(math.random(40, 60))
                end
            end)
        elseif not Toggles.MythicalHop then _G._hopRun = false end
    end
end)

-- ============================================================
-- ===== GUI =====
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HelloHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Nút toggle (kéo thả bằng giữ chuột)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
ToggleBtn.BackgroundColor3 = Colors.Accent
ToggleBtn.Text = "🍎"
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ScreenGui
ToggleBtn.Active = true
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 25)

-- Logic kéo thả
local dragging, dragStart, startPos, dragDistance = false, nil, nil, 0
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
        dragDistance = 0
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                ToggleBtn.BackgroundColor3 = Colors.Accent
            end
        end)
    end
end)
ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
       or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            dragDistance = math.abs(delta.X) + math.abs(delta.Y)
            ToggleBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            ToggleBtn.BackgroundColor3 = Colors.Accent:Lerp(Color3.new(1,1,1), 0.3)
        end
    end
end)
ToggleBtn.MouseButton1Click:Connect(function()
    if dragDistance < 10 then
        Main.Visible = true
        ToggleBtn.Visible = false
    end
end)

-- Main Frame (nhỏ hơn)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 560, 0, 340)
Main.Position = UDim2.new(0.5, -280, 0.5, -170)
Main.BackgroundColor3 = Colors.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Colors.Accent
stroke.Thickness = 2

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Colors.Accent
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍎 HelloHub V8"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -31, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinBtn.Text = "X"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- TabBar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 32)
TabBar.Position = UDim2.new(0, 10, 0, 44)
TabBar.BackgroundColor3 = Colors.Tab
TabBar.BorderSizePixel = 0
TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 3)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 4)
TabPadding.PaddingRight = UDim.new(0, 4)
TabPadding.Parent = TabBar

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -92)
Content.Position = UDim2.new(0, 10, 0, 82)
Content.BackgroundColor3 = Colors.Tab
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)

local Pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Colors.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = Content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingRight = UDim.new(0, 5)
    pad.PaddingTop = UDim.new(0, 5)
    pad.Parent = page
    Pages[name] = page
    return page
end

local TabButtons = {}
local function createTab(name, pageName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 72, 0, 25)
    btn.BackgroundColor3 = Colors.Tab
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Colors.Text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.BackgroundColor3 = Colors.Tab 
            b.TextColor3 = Colors.Text
        end
        if Pages[pageName] then Pages[pageName].Visible = true end
        btn.BackgroundColor3 = Colors.Accent
        btn.TextColor3 = Color3.new(1,1,1)
    end)
    TabButtons[name] = btn
    return btn
end

createPage("Main")
createPage("Farm")
createPage("Fruit")
createPage("Quest")
createPage("Mastery")
createPage("PVP")
createPage("AntiBan")

-- ===== TOGGLE SWITCH (kiểu QuantumHub) =====
local function makeToggle(parent, text, key, default)
    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -5, 0, 32)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    container.BorderSizePixel = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    
    -- Label (bên trái)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.Text
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Switch background (bên phải)
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.Position = UDim2.new(1, -54, 0.5, -11)
    switchBg.BackgroundColor3 = default and Colors.SwitchOn or Colors.SwitchOff
    switchBg.BorderSizePixel = 0
    switchBg.Parent = container
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    -- Switch knob (nút tròn)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.BorderSizePixel = 0
    knob.Parent = switchBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    -- Click vào container để toggle
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = container
    
    Toggles[key] = default or false
    
    clickBtn.MouseButton1Click:Connect(function()
        Toggles[key] = not Toggles[key]
        
        -- Animate knob
        local targetPos
        if Toggles[key] then
            targetPos = UDim2.new(1, -20, 0.5, -9)
            switchBg.BackgroundColor3 = Colors.SwitchOn
        else
            targetPos = UDim2.new(0, 2, 0.5, -9)
            switchBg.BackgroundColor3 = Colors.SwitchOff
        end
        
        knob:TweenPosition(targetPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    
    return container
end

-- ===== ACTION BUTTON =====
local function makeAction(parent, text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 32)
    btn.BackgroundColor3 = color or Colors.Accent
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Colors.Text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ===== TAB MAIN =====
makeAction(Pages.Main, "🚀 GIẢM LAG", Color3.fromRGB(0, 180, 90), reduceLag)
makeAction(Pages.Main, "🔄 RESET CHARACTER", Color3.fromRGB(200, 130, 40), function()
    local h = getHumanoid()
    if h then h.Health = 0 end
end)
makeToggle(Pages.Main, "📜 Auto Quest", "AutoQuest", false)
makeToggle(Pages.Main, "🎰 Auto Gacha", "AutoGacha", false)

-- ===== TAB FARM =====
makeToggle(Pages.Farm, "⚔️ Auto Farm", "AutoFarm", false)
makeToggle(Pages.Farm, "⚡ Speed Farm", "SpeedFarm", false)
makeToggle(Pages.Farm, "📦 Chest Farm", "ChestFarm", false)
makeToggle(Pages.Farm, "⚔️ Auto Raid", "AutoRaid", false)
makeToggle(Pages.Farm, "👤 Auto Tribe", "AutoTribe", false)

-- ===== TAB FRUIT =====
makeToggle(Pages.Fruit, "🍎 Auto Nhặt Trái", "AutoFruitDrop", false)
makeToggle(Pages.Fruit, "📥 Auto Lưu Trái", "AutoStoreFruit", false)
makeAction(Pages.Fruit, "🎰 GACHA 1 LẦN", Color3.fromRGB(180, 80, 200), function()
    for i = 1, 5 do doGacha() task.wait(0.5) end
end)
makeAction(Pages.Fruit, "📥 LƯU TRÁI 1 LẦN", Color3.fromRGB(40, 130, 200), storeFruits)
makeAction(Pages.Fruit, "✨ MYTHICAL HOP (1 LẦN)", Colors.Mythical, doMythicalHop)
makeToggle(Pages.Fruit, "✨ Mythical Hop", "MythicalHop", false)

-- ===== TAB QUEST =====
makeAction(Pages.Quest, "📜 NHẬN QUEST 1 LẦN", Color3.fromRGB(200, 130, 40), doQuestFixed)
makeAction(Pages.Quest, "👤 TRIBE QUEST 1 LẦN", Color3.fromRGB(40, 130, 200), doTribe)
makeAction(Pages.Quest, "⚔️ RAID 1 LẦN", Color3.fromRGB(200, 80, 40), startRaid)
makeToggle(Pages.Quest, "📜 Auto Quest Mới", "AutoNewQuest", false)

-- ===== TAB MASTERY =====
makeToggle(Pages.Mastery, "⚔️ Auto Mastery", "AutoMastery", false)

local weaponLabel = Instance.new("TextLabel")
weaponLabel.Size = UDim2.new(1, -5, 0, 20)
weaponLabel.BackgroundTransparency = 1
weaponLabel.Text = "Chọn vũ khí cần cày:"
weaponLabel.TextColor3 = Colors.Accent
weaponLabel.TextScaled = true
weaponLabel.Font = Enum.Font.GothamBold
weaponLabel.TextXAlignment = Enum.TextXAlignment.Left
weaponLabel.Parent = Pages.Mastery

local Dropdown = Instance.new("TextButton")
Dropdown.Size = UDim2.new(1, -5, 0, 32)
Dropdown.BackgroundColor3 = Colors.Bg
Dropdown.BorderSizePixel = 0
Dropdown.Text = ""
Dropdown.Parent = Pages.Mastery
Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)
local dstroke = Instance.new("UIStroke", Dropdown)
dstroke.Color = Colors.Accent
dstroke.Thickness = 1

local DropLabel = Instance.new("TextLabel")
DropLabel.Size = UDim2.new(1, -40, 1, 0)
DropLabel.Position = UDim2.new(0, 10, 0, 0)
DropLabel.BackgroundTransparency = 1
DropLabel.Text = "Nearest (Vũ khí đang cầm)"
DropLabel.TextColor3 = Colors.Text
DropLabel.TextScaled = true
DropLabel.Font = Enum.Font.Gotham
DropLabel.TextXAlignment = Enum.TextXAlignment.Left
DropLabel.Parent = Dropdown

local DropArrow = Instance.new("TextLabel")
DropArrow.Size = UDim2.new(0, 30, 1, 0)
DropArrow.Position = UDim2.new(1, -35, 0, 0)
DropArrow.BackgroundTransparency = 1
DropArrow.Text = "▼"
DropArrow.TextColor3 = Colors.Accent
DropArrow.TextScaled = true
DropArrow.Font = Enum.Font.GothamBold
DropArrow.Parent = Dropdown

local DropList = Instance.new("ScrollingFrame")
DropList.Size = UDim2.new(1, -5, 0, 0)
DropList.BackgroundColor3 = Colors.Bg
DropList.BorderSizePixel = 0
DropList.ScrollBarThickness = 3
DropList.Visible = false
DropList.Parent = Pages.Mastery
Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)
local lstroke = Instance.new("UIStroke", DropList)
lstroke.Color = Colors.Accent
lstroke.Thickness = 1

local dropLayout = Instance.new("UIListLayout")
dropLayout.Padding = UDim.new(0, 2)
dropLayout.Parent = DropList
local dropPad = Instance.new("UIPadding")
dropPad.PaddingTop = UDim.new(0, 4)
dropPad.PaddingBottom = UDim.new(0, 4)
dropPad.Parent = DropList

local function refreshWeaponList()
    for _, c in pairs(DropList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local items = {"Nearest (Vũ khí đang cầm)"}
    local seen = {}
    for _, src in pairs({LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack")}) do
        if src then
            for _, t in pairs(src:GetChildren()) do
                if t:IsA("Tool") and not seen[t.Name] then
                    table.insert(items, t.Name)
                    seen[t.Name] = true
                end
            end
        end
    end
    for i, name in ipairs(items) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(1, -8, 0, 28)
        item.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        item.BorderSizePixel = 0
        item.Text = (i == 1) and name or ("🗡️ " .. name)
        item.TextColor3 = Colors.Text
        item.TextScaled = true
        item.Font = Enum.Font.Gotham
        item.Parent = DropList
        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
        item.MouseButton1Click:Connect(function()
            MasteryWeapon = (i == 1) and "Nearest" or name
            DropLabel.Text = (i == 1) and "Nearest (Vũ khí đang cầm)" or ("🗡️ " .. name)
            DropList.Visible = false
        end)
    end
    local count = #items
    DropList.CanvasSize = UDim2.new(0, 0, 0, count * 30 + 8)
    DropList.Size = UDim2.new(1, -5, 0, math.min(count * 30 + 8, 160))
    DropList.Visible = true
end

Dropdown.MouseButton1Click:Connect(refreshWeaponList)
makeAction(Pages.Mastery, "🔄 LÀM MỚI DANH SÁCH", Color3.fromRGB(80, 80, 120), refreshWeaponList)

-- ===== TAB PVP =====
makeToggle(Pages.PVP, "⚔️ Aura Kill (100 studs)", "AuraKill", false)
makeToggle(Pages.PVP, "📊 Auto Nâng Chỉ Số", "AutoStat", false)

makeAction(Pages.PVP, "📊 Melee", Color3.fromRGB(80, 80, 120), function()
    StatChoice = "Melee"
    StarterGui:SetCore("SendNotification", {Title="📊"; Text="Melee"; Duration=2})
end)
makeAction(Pages.PVP, "📊 Defense", Color3.fromRGB(80, 80, 120), function()
    StatChoice = "Defense"
    StarterGui:SetCore("SendNotification", {Title="📊"; Text="Defense"; Duration=2})
end)
makeAction(Pages.PVP, "📊 Sword", Color3.fromRGB(80, 80, 120), function()
    StatChoice = "Sword"
    StarterGui:SetCore("SendNotification", {Title="📊"; Text="Sword"; Duration=2})
end)
makeAction(Pages.PVP, "📊 Fruit", Color3.fromRGB(80, 80, 120), function()
    StatChoice = "Fruit"
    StarterGui:SetCore("SendNotification", {Title="📊"; Text="Fruit"; Duration=2})
end)

makeAction(Pages.PVP, "🛒 CHECK SHOP", Color3.fromRGB(40, 130, 200), checkShop)

-- ===== TAB ANTI-BAN =====
makeToggle(Pages.AntiBan, "🛡️ Anti-Ban", "AntiBanEnabled", true)
makeToggle(Pages.AntiBan, "⏱️ Random Delay", "AntiBanRandomDelay", true)
makeToggle(Pages.AntiBan, "👤 Human-Like Click", "AntiBanHumanClick", true)
makeToggle(Pages.AntiBan, "📍 Safe Teleport", "AntiBanSafeTeleport", true)
makeToggle(Pages.AntiBan, "☕ Auto Break", "AntiBanAutoBreak", true)
makeToggle(Pages.AntiBan, "🚶 Fake Activity", "AntiBanFakeActivity", true)

-- ===== TẠO TAB =====
createTab("🏠 Main", "Main")
createTab("⚔️ Farm", "Farm")
createTab("🍎 Fruit", "Fruit")
createTab("📜 Quest", "Quest")
createTab("🗡️ Mastery", "Mastery")
createTab("⚔️ PVP", "PVP")
createTab("🛡️ AntiBan", "AntiBan")

Pages.Main.Visible = true
TabButtons["🏠 Main"].BackgroundColor3 = Colors.Accent
TabButtons["🏠 Main"].TextColor3 = Color3.new(1,1,1)

-- ===== MỞ/ĐÓNG =====
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    ToggleBtn.Visible = true
end)

-- ===== THÔNG BÁO =====
StarterGui:SetCore("SendNotification", {
    Title = "🍎 HelloHub";
    Text = "✅ Đã load! Toggle switch + Farm riêng.";
    Duration = 5;
})

print("[HelloHub] Ready!")
