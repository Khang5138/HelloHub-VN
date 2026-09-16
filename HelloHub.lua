--[[
    ╔══════════════════════════════════════════╗
    ║   HelloHub V6 FINAL - Blox Fruits        ║
    ║   Tác giả: Khang5138                     ║
    ║   Đầy đủ tính năng + Auto Mythical       ║
    ╚══════════════════════════════════════════╝
    
    Cách dùng:
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
local TweenService = game:GetService("TweenService")
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

print("[HelloHub V6] Loaded!")

-- ===== BIẾN TOÀN CỤC =====
local Toggles = {
    AutoFarm = false, AutoChest = false, AutoFruitDrop = false,
    AutoMastery = false, AutoQuest = false, AutoGacha = false,
    AutoStoreFruit = false, AutoRaid = false, AutoTribe = false,
    SpeedFarm = false, AuraKill = false, AutoStat = false,
    AutoNewQuest = false, AutoHopMythical = false,
}
local MasteryWeapon = "Nearest"
local StatChoice = "Melee"
local AuraRange = 100
local LastQuestLevel = 0

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

-- ===== TÌM TRÁI RƠI (BẤT KỲ) =====
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
            teleportTo(part.Position)
            task.wait(0.1)
            if firetouchinterest and getHRP() then
                firetouchinterest(getHRP(), part, 0)
                task.wait(0.05)
                firetouchinterest(getHRP(), part, 1)
            end
        end
    end)
end

-- ===== KIỂM TRA TRÁI MYTHICAL TRÊN MAP =====
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

-- ===== NPC QUEST =====
local function getQuestNPCFixed()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    local questNPCNames = {
        "Quest", "Master", "Captain", "Bartender", "Sword", "Blade", 
        "Citizen", "King", "Baratie", "Barto", "Gan Fall", "Usopp",
        "Nami", "Buggy", "Smoker", "Tashigi"
    }
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") 
               and obj:FindFirstChild("Head") then
                local n = obj.Name
                for _, validName in ipairs(questNPCNames) do
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

-- ===== GACHA =====
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
            if commE then
                pcall(function() commE:InvokeServer("BuyFruit") end)
            end
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
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in pairs(playerGui:GetChildren()) do
                pcall(function()
                    for _, obj in pairs(gui:GetDescendants()) do
                        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                            local txt = string.lower(obj.Text or "")
                            if txt:find("buy") or txt:find("purchase") or txt:find("mua") then
                                obj:Activate()
                            end
                        end
                    end
                end)
            end
        end
    end)
end

-- ===== LƯU TRÁI =====
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

-- ===== MASTERY =====
local function getEquippedWeapon()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Tool")
end

local function getMasteryWeapon()
    if MasteryWeapon == "Nearest" then
        return getEquippedWeapon()
    else
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
    end
    return nil
end

local function masteryAttack()
    pcall(function()
        local tool = getMasteryWeapon()
        if tool then
            tool:Activate()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
        end
    end)
end

-- ===== RAID =====
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

-- ===== TRIBE =====
local function getTribeNPC()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") 
               and obj:FindFirstChild("Head") then
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

-- ===== LAG REDUCER =====
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

-- ===== SPEED FARM =====
local function speedFarmLoop()
    task.spawn(function()
        while Toggles.SpeedFarm do
            local m = getMonster()
            if m and m:FindFirstChild("HumanoidRootPart") then
                local hrp = getHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(m.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                    for i = 1, 5 do attack() end
                end
            end
            task.wait(0.02)
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
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") 
               and obj:FindFirstChild("HumanoidRootPart") then
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
                for i = 1, 3 do attack() end
            end
            task.wait(0.05)
        end
        local hrp = getHRP()
        if hrp then
            local hb = hrp:FindFirstChild("HelloHub_AuraHitbox")
            if hb then hb:Destroy() end
        end
    end)
end

-- ===== AUTO STAT =====
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

-- ===== AUTO NEW QUEST =====
local function autoNewQuestLoop()
    task.spawn(function()
        while Toggles.AutoNewQuest do
            local level = getPlayerLevel()
            if level > LastQuestLevel then
                LastQuestLevel = level
                StarterGui:SetCore("SendNotification", {
                    Title = "HelloHub";
                    Text = "📜 Level " .. level .. "! Đang tìm quest mới...";
                    Duration = 3;
                })
            end
            doQuestFixed()
            task.wait(5)
        end
    end)
end

-- ===== CHECK SHOP =====
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
        StarterGui:SetCore("SendNotification", {
            Title = "HelloHub Shop"; 
            Text = "🛒 Shop có " .. #foundItems .. " item!"; 
            Duration = 5;
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "HelloHub"; Text = "🛒 Không thấy shop nào mở!"; Duration = 5;
        })
    end
end

-- ===== SERVER HOP =====
local function serverHop()
    pcall(function()
        local servers = {}
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId 
                  .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function() return game:HttpGet(url) end)
        if success and result then
            local data = HttpService:JSONDecode(result)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        end
        if #servers > 0 then
            local newServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, newServer, LocalPlayer)
        end
    end)
end

-- ===== AUTO HOP MYTHICAL =====
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

local function autoHopForMythical()
    local mythical = getMythicalFruitOnMap()
    
    if mythical then
        StarterGui:SetCore("SendNotification", {
            Title = "✨ HELLOHUB MYTHICAL ✨";
            Text = "Phát hiện " .. mythical.Name .. "! Không đổi server.";
            Duration = 5;
        })
        playMythicalSound()
        return
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = "HelloHub";
        Text = "🔄 Không có Mythical. Đang đổi server...";
        Duration = 3;
    })
    
    task.wait(1)
    serverHop()
end

-- ===== VÒNG LẶP CHÍNH =====
RunService.Heartbeat:Connect(function()
    if not getHRP() then return end

    if Toggles.AutoFarm then
        local m = getMonster()
        if m and m:FindFirstChild("HumanoidRootPart") then
            teleportTo(m.HumanoidRootPart.Position)
            attack()
        end
    end

    if Toggles.AutoChest then
        local c = getChest()
        if c then
            local p = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChildWhichIsA("BasePart")
            if p then teleportTo(p.Position) end
        end
    end

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
                if d > 15 then teleportTo(m.HumanoidRootPart.Position) end
                masteryAttack()
            end
        end
    end
end)

-- ===== LOOP RIÊNG =====
task.spawn(function()
    while true do
        task.wait(3)
        if Toggles.AutoQuest then doQuestFixed() end
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        if Toggles.AutoGacha then doGacha() end
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        if Toggles.AutoStoreFruit then storeFruits() end
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        if Toggles.AutoRaid then startRaid() end
    end
end)

task.spawn(function()
    while true do
        task.wait(3)
        if Toggles.AutoTribe then doTribe() end
    end
end)

-- ===== QUẢN LÝ LOOP =====
task.spawn(function()
    while true do
        task.wait(0.5)
        if Toggles.SpeedFarm and not _G._speedRun then
            _G._speedRun = true
            speedFarmLoop()
        elseif not Toggles.SpeedFarm then
            _G._speedRun = false
        end
        if Toggles.AuraKill and not _G._auraRun then
            _G._auraRun = true
            auraKillLoop()
        elseif not Toggles.AuraKill then
            _G._auraRun = false
        end
        if Toggles.AutoStat and not _G._statRun then
            _G._statRun = true
            autoStatLoop()
        elseif not Toggles.AutoStat then
            _G._statRun = false
        end
        if Toggles.AutoNewQuest and not _G._newQuestRun then
            _G._newQuestRun = true
            autoNewQuestLoop()
        elseif not Toggles.AutoNewQuest then
            _G._newQuestRun = false
        end
        if Toggles.AutoHopMythical and not _G._hopRun then
            _G._hopRun = true
            task.spawn(function()
                while Toggles.AutoHopMythical do
                    autoHopForMythical()
                    task.wait(30)
                end
            end)
        elseif not Toggles.AutoHopMythical then
            _G._hopRun = false
        end
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

-- Nút mở GUI (kéo thả)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -27)
ToggleBtn.BackgroundColor3 = Colors.Accent
ToggleBtn.Text = "🍎"
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ScreenGui
ToggleBtn.Active = true
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)

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

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 620, 0, 380)
Main.Position = UDim2.new(0.5, -310, 0.5, -190)
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
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Colors.Accent
Header.BorderSizePixel = 0
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("
