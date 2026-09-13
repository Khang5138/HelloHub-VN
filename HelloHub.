--[[
    HelloHub - Blox Fruits Edition FINAL
    Tính năng:
    - Giảm lag
    - Auto Farm / Chest / Fruit / Mastery
    - Auto Quest
    - Auto Gacha / Store Fruit
    - Auto Nhặt Trái
    - Auto Raid
    - Auto Tribe
    Cách dùng: loadstring(game:HttpGet("LINK_RAW_CUA_BAN"))()
--]]

-- ===== SERVICES =====
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
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
    StarterGui:SetCore("SendNotification", {
        Title = "HelloHub";
        Text = "❌ Chỉ hoạt động trong Blox Fruits!";
        Duration = 5;
    })
    return
end

print("[HelloHub] Blox Fruits FULL loaded!")

-- ===== BIẾN TOÀN CỤC =====
local AutoFarm = false
local AutoChest = false
local AutoFruit = false
local AutoFruitDrop = false
local AutoMastery = false
local AutoQuest = false
local AutoGacha = false
local AutoStoreFruit = false
local AutoRaid = false
local AutoTribe = false
local MasteryMethod = "Click"

-- ===== TẠO GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HelloHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ToggleBtn.Text = "🍎"
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 25)
ToggleBtn.Visible = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 560)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Title.BorderSizePixel = 0
Title.Text = "🍎 HelloHub - Blox Fruits FULL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 2)
MinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinBtn.Text = "X"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 5
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Scroll

-- ===== HÀM TẠO UI =====
local function makeButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 180, 90)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function makeLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -5, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(0, 170, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = Scroll
    return lbl
end

-- ===== HÀM TIỆN ÍCH =====
local function getHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function teleportTo(pos)
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

local function attack()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
    end)
end

-- ===== GIẢM LAG =====
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

-- ===== TÌM QUÁI =====
local function getMonster()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetChildren()) do
        pcall(function()
            if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Humanoid.Health > 0 and obj ~= LocalPlayer.Character then
                    local n = obj.Name
                    if not n:find("NPC") and not n:find("Barber") and not n:find("Shop") 
                       and not Players:GetPlayerFromCharacter(obj) then
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
    for _, obj in pairs(Workspace:GetChildren()) do
        pcall(function()
            if obj.Name:find("Chest") then
                local part = obj:FindFirstChild("HumanoidRootPart") or (obj:IsA("BasePart") and obj)
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end
        end)
    end
    return nearest
end

-- ===== TÌM TRÁI RƠI =====
local function getFruitDrop()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end

    for _, obj in pairs(Workspace:GetChildren()) do
        pcall(function()
            if (obj:IsA("Tool") or obj:IsA("Model")) 
               and (obj.Name:find("Fruit") or obj.Name:find("fruit")) then
                local part = obj:FindFirstChild("Handle") 
                          or obj:FindFirstChild("HumanoidRootPart")
                          or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end
        end)
    end

    local fruitsFolder = Workspace:FindFirstChild("Fruits")
    if fruitsFolder then
        for _, obj in pairs(fruitsFolder:GetChildren()) do
            pcall(function()
                local part = obj:FindFirstChild("Handle") 
                          or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end)
        end
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
            task.wait(0.2)
            if firetouchinterest and getHRP() then
                firetouchinterest(getHRP(), part, 0)
                task.wait(0.1)
                firetouchinterest(getHRP(), part, 1)
            end
        end
    end)
end

-- ===== TÌM NPC QUEST =====
local function getQuestNPC()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetChildren()) do
        pcall(function()
            if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                local n = obj.Name
                if n:find("Quest") or n:find("Master") or n:find("Captain") 
                   or n:find("Bartender") or n:find("King") or n:find("Sword") 
                   or n:find("Blade") or n:find("Hat") or n:find("Citizen") then
                    local d = (obj.Head.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end
        end)
    end
    return nearest
end

local function doQuest()
    local npc = getQuestNPC()
    if not npc then return end
    local hrp = getHRP()
    if not hrp then return end
    hrp.CFrame = CFrame.new(npc.Head.Position + Vector3.new(0, 0, 3))
    task.wait(0.3)
    pcall(function()
        for _, obj in pairs(npc:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
                fireproximityprompt(obj)
            end
        end
    end)
    attack()
end

-- ===== GACHA =====
local function doGacha()
    pcall(function()
        local dealer = nil
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name:find("Dealer") then dealer = obj break end
        end
        if dealer and dealer:FindFirstChild("HumanoidRootPart") then
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = CFrame.new(dealer.HumanoidRootPart.Position + Vector3.new(0, 0, 5))
                task.wait(0.5)
            end
            for _, obj in pairs(dealer:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                    fireproximityprompt(obj)
                    task.wait(0.3)
                end
            end
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local comm = remotes:FindFirstChild("CommF_")
                if comm then comm:InvokeServer("BuyFruit") end
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
                local isFruit = false
                if tool:FindFirstChild("Fruit") or tool.Name:find("Fruit") then isFruit = true end
                for _, tag in pairs(tool:GetChildren()) do
                    if tag:IsA("StringValue") and (tag.Name == "Fruit" or tag.Name == "Type") then
                        isFruit = true
                    end
                end
                if isFruit then
                    local storage = Workspace:FindFirstChild("Fruit Storage") 
                                 or Workspace:FindFirstChild("Chest")
                    if storage then
                        local part = storage:FindFirstChild("HumanoidRootPart") 
                                    or (storage:IsA("BasePart") and storage)
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
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end

local function masteryAttack()
    pcall(function()
        if MasteryMethod == "Click" then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
        end
        if MasteryMethod == "Skill" then
            local tool = getEquippedWeapon()
            if tool then tool:Activate() end
        end
    end)
end

-- ===== RAID =====
local function startRaid()
    pcall(function()
        local raidNPC = nil
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name:find("Raid") or obj.Name:find("Awaken") 
               or obj.Name:find("Ancient") or obj.Name:find("Cursed") then
                if obj:FindFirstChild("Humanoid") then
                    raidNPC = obj
                    break
                end
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
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local comm = remotes:FindFirstChild("CommF_")
                if comm then
                    pcall(function() comm:InvokeServer("RequestRaid") end)
                    pcall(function() comm:InvokeServer("Raid", "Start") end)
                end
            end
        end
    end)
end

local function doRaid()
    if not AutoRaid then return end
    local hasChip = false
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item.Name:find("Chip") or item.Name:find("Raid") then
                hasChip = true
                break
            end
        end
    end
    if hasChip then
        startRaid()
        task.wait(3)
        for _ = 1, 600 do
            if not AutoRaid then break end
            local m = getMonster()
            if m and m:FindFirstChild("HumanoidRootPart") then
                teleportTo(m.HumanoidRootPart.Position)
                attack()
            end
            task.wait(0.1)
        end
    end
end

-- ===== TRIBE =====
local function getTribeNPC()
    local nearest, dist = nil, math.huge
    local hrp = getHRP()
    if not hrp then return nil end
    for _, obj in pairs(Workspace:GetChildren()) do
        pcall(function()
            if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                local n = obj.Name
                if n:find("Trial") or n:find("Master") or n:find("Elder") 
                   or n:find("Sensei") or n:find("Temple") or n:find("Fighter") 
                   or n:find("Cyborg") or n:find("Ghoul") or n:find("Mink") 
                   or n:find("Fishman") or n:find("Skypiea") or n:find("Human") then
                    local d = (obj.Head.Position - hrp.Position).Magnitude
                    if d < dist then nearest, dist = obj, d end
                end
            end
        end)
    end
    return nearest
end

local function doTribeQuest()
    local npc = getTribeNPC()
    if not npc then return end
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
    for _ = 1, 100 do
        if not AutoTribe then break end
        local m = getMonster()
        if m and m:FindFirstChild("HumanoidRootPart") then
            teleportTo(m.HumanoidRootPart.Position)
            attack()
        end
        task.wait(0.2)
    end
end

-- ===== VÒNG LẶP CHÍNH =====
RunService.Heartbeat:Connect(function()
    if AutoFarm then
        local m = getMonster()
        if m and m:FindFirstChild("HumanoidRootPart") then
            teleportTo(m.HumanoidRootPart.Position)
            attack()
        end
    end

    if AutoChest then
        local c = getChest()
        if c then
            local p = c:FindFirstChild("HumanoidRootPart") or (c:IsA("BasePart") and c)
            if p then teleportTo(p.Position) end
        end
    end

    if AutoFruit then
        local f = getFruitDrop()
        if f then teleportTo((f:FindFirstChild("Handle") or f:FindFirstChildWhichIsA("BasePart")).Position) end
    end

    if AutoFruitDrop then
        local f = getFruitDrop()
        if f then pickUpFruit(f) end
    end

    if AutoMastery then
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

-- ===== TẠO NÚT =====
makeLabel("=== TỐI ƯU ===")
makeButton("🚀 GIẢM LAG", Color3.fromRGB(40, 180, 90), reduceLag)

makeLabel("=== AUTO FARM ===")
local farmBtn = makeButton("⚔️ AUTO FARM: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoFarm = not AutoFarm
    farmBtn.Text = AutoFarm and "⚔️ AUTO FARM: ON" or "⚔️ AUTO FARM: OFF"
    farmBtn.BackgroundColor3 = AutoFarm and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
end)

local chestBtn = makeButton("📦 AUTO CHEST: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoChest = not AutoChest
    chestBtn.Text = AutoChest and "📦 AUTO CHEST: ON" or "📦 AUTO CHEST: OFF"
    chestBtn.BackgroundColor3 = AutoChest and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
end)

local masteryBtn = makeButton("⚔️ AUTO MASTERY: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoMastery = not AutoMastery
    masteryBtn.Text = AutoMastery and "⚔️ AUTO MASTERY: ON" or "⚔️ AUTO MASTERY: OFF"
    masteryBtn.BackgroundColor3 = AutoMastery and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
end)

makeLabel("=== TRÁI ===")
local fruitBtn = makeButton("🍎 AUTO FRUIT: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoFruit = not AutoFruit
    fruitBtn.Text = AutoFruit and "🍎 AUTO FRUIT: ON" or "🍎 AUTO FRUIT: OFF"
    fruitBtn.BackgroundColor3 = AutoFruit and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
end)

local fruitDropBtn = makeButton("🍎 AUTO NHẶT TRÁI: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoFruitDrop = not AutoFruitDrop
    fruitDropBtn.Text = AutoFruitDrop and "🍎 AUTO NHẶT TRÁI: ON" or "🍎 AUTO NHẶT TRÁI: OFF"
    fruitDropBtn.BackgroundColor3 = AutoFruitDrop and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
end)

makeButton("🎰 GACHA 1 LẦN", Color3.fromRGB(180, 80, 200), doGacha)

local gachaBtn = makeButton("🎰 AUTO GACHA: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoGacha = not AutoGacha
    gachaBtn.Text = AutoGacha and "🎰 AUTO GACHA: ON" or "🎰 AUTO GACHA: OFF"
    gachaBtn.BackgroundColor3 = AutoGacha and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
    if AutoGacha then
        task.spawn(function()
            while AutoGacha do
                doGacha()
                task.wait(2)
            end
        end)
    end
end)

makeButton("📥 LƯU TRÁI 1 LẦN", Color3.fromRGB(40, 130, 200), storeFruits)

local storeBtn = makeButton("📥 AUTO LƯU TRÁI: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoStoreFruit = not AutoStoreFruit
    storeBtn.Text = AutoStoreFruit and "📥 AUTO LƯU TRÁI: ON" or "📥 AUTO LƯU TRÁI: OFF"
    storeBtn.BackgroundColor3 = AutoStoreFruit and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
    if AutoStoreFruit then
        task.spawn(function()
            while AutoStoreFruit do
                storeFruits()
                task.wait(5)
            end
        end)
    end
end)

makeLabel("=== QUEST ===")
makeButton("📜 NHẬN QUEST 1 LẦN", Color3.fromRGB(200, 130, 40), doQuest)

local questBtn = makeButton("📜 AUTO QUEST: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoQuest = not AutoQuest
    questBtn.Text = AutoQuest and "📜 AUTO QUEST: ON" or "📜 AUTO QUEST: OFF"
    questBtn.BackgroundColor3 = AutoQuest and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
    if AutoQuest then
        task.spawn(function()
            while AutoQuest do
                doQuest()
                task.wait(3)
            end
        end)
    end
end)

makeLabel("=== RAID & TRIBE ===")
makeButton("⚔️ RAID 1 LẦN", Color3.fromRGB(200, 130, 40), startRaid)

local raidBtn = makeButton("⚔️ AUTO RAID: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoRaid = not AutoRaid
    raidBtn.Text = AutoRaid and "⚔️ AUTO RAID: ON" or "⚔️ AUTO RAID: OFF"
    raidBtn.BackgroundColor3 = AutoRaid and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
    if AutoRaid then
        task.spawn(function()
            while AutoRaid do
                doRaid()
                task.wait(5)
            end
        end)
    end
end)

makeButton("👤 TRIBE 1 LẦN", Color3.fromRGB(40, 130, 200), doTribeQuest)

local tribeBtn = makeButton("👤 AUTO TRIBE: OFF", Color3.fromRGB(150, 50, 50), function()
    AutoTribe = not AutoTribe
    tribeBtn.Text = AutoTribe and "👤 AUTO TRIBE: ON" or "👤 AUTO TRIBE: OFF"
    tribeBtn.BackgroundColor3 = AutoTribe and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(150, 50, 50)
    if AutoTribe then
        task.spawn(function()
            while AutoTribe do
                doTribeQuest()
                task.wait(3)
            end
        end)
    end
end)

makeLabel("=== KHÁC ===")
makeButton("🔄 RESET CHARACTER", Color3.fromRGB(200, 130, 40), function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
    end
end)

-- ===== ẨN/HIỆN GUI =====
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleBtn.Visible = true
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleBtn.Visible = false
end)

-- ===== THÔNG BÁO =====
StarterGui:SetCore("SendNotification", {
    Title = "HelloHub - Blox Fruits FULL";
    Text = "✅ Đã load! Tất cả tính năng sẵn sàng.";
    Duration = 5;
})

print("[HelloHub] Blox Fruits FULL loaded!")
