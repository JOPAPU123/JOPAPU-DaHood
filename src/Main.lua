-- // Title: Da Hood Main | By JOPAPU
-- // Credits: By JOPAPU

-- // Game: https://roblox.com/games/2788229376/

-- // Valiant ENV
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/ValiantENV.lua"))()

-- // Vars
local RenderStepped = RunService.RenderStepped
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded.Wait(LocalPlayer.CharacterAdded)
local Humanoid = Character.WaitForChild(Character, "Humanoid")
local HumnaoidRootPart = Character.WaitForChild(Character, "HumanoidRootPart")
local Backpack = LocalPlayer.Backpack
local CurrentCamera = Workspace.CurrentCamera
local Mouse = LocalPlayer.GetMouse(LocalPlayer)
local MainEvent = game:GetService("ReplicatedStorage"):WaitForChild("MainEvent")
getgenv().BypassFlyDaHood = false
local Controller = getgenv().JopapuController or {
    States = {
        AntiFlyBypass = false,
        Protections = false,
        CollectMoney = false,
        CollectShoes = false,
        CollectTools = false,
        CollectCashiers = false,
        SeatsDisabled = false,
    },
    Threads = {},
    Connections = {},
}
Controller.States = Controller.States or {}
Controller.Threads = Controller.Threads or {}
Controller.Connections = Controller.Connections or {}
getgenv().JopapuController = Controller

-- // Base MT Vars + Funs
local mt = getrawmetatable(game)
local backupnamecall = mt.__namecall
local backupnewindex = mt.__newindex
local backupindex = mt.__index 
setreadonly(mt, false)

-- // Silent Aim Vars
local AimHacks = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Universal/Experimental%20Silent%20Aim%20Module.lua"))()

-- // Da Hood Protections
local function removeRagdolls()
    for i,v in pairs(Character:WaitForChild("RagdollConstraints"):GetChildren()) do
        v.Enabled = false
    end
end

local function protections()
    -- // Anti Fall/Ragdoll
    Humanoid:SetStateEnabled(Enum.HumnaoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumnaoidStateType.Ragdoll, false)
    Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None -- Hide your name

    for i,v in pairs(Character:GetDescendants()) do
        if v:IsA("Accessory") or (v:IsA("Decal") and v.Name == 'face') then
            v:Destroy()
        elseif v:IsA("MeshPart") then
            v.Color = Color3.fromRGB(255, 255, 255)
        end
    end

    removeRagdolls()
    if Controller.Connections.Movement then
        Controller.Connections.Movement:Disconnect()
    end
    Controller.Connections.Movement = Character:WaitForChild("BodyEffects").Movement.DescendantAdded:Connect(function(descendant)
        wait()
        descendant:Destroy()
    end)
end

function toggleSeats(state)
    for i,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Seat") then
            v.Disabled = state
        end
    end
end

-- // Anti Fly Bypass
local function setAntiFlyBypass(state)
    Controller.States.AntiFlyBypass = state
    getgenv().BypassFlyDaHood = state
    if state and not Controller.Threads.AntiFlyBypass then
        Controller.Threads.AntiFlyBypass = task.spawn(function()
            while Controller.States.AntiFlyBypass do
                for i,v in ipairs(getgc()) do
                    if (debug.getinfo(v).name == 'crash') then
                        getfenv(v).script:Destroy()
                    end
                end
                task.wait(0.1)
            end
            Controller.Threads.AntiFlyBypass = nil
        end)
    elseif not state and Controller.Threads.AntiFlyBypass then
        task.cancel(Controller.Threads.AntiFlyBypass)
        Controller.Threads.AntiFlyBypass = nil
    end
end

-- // Teleport
function Teleport(_CFrame, Status)
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if Status then
        for i = 0, 1, 0.1 do
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:lerp(_CFrame, i)
            wait()
        end
    else
        HumanoidRootPart.CFrame = _CFrame
    end
end

-- // Metatable Stuff: Silent Aim + Bypass other protections
mt.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "FireServer" then
        local remoteName = tostring(args[1])
        if Controller.States.SystemHandler ~= false and remoteName == "MainEvent" then
            if args[2] == "TeleportDetect" or args[2] == 'TeleportDetect' or args[2] == 'CHECKER' or args[2] == 'OneMoreTime' then
                return nil
            end
            if Controller.States.AimAssist ~= false and args[2] == "MouseUpdatedPos" and typeof(args[3]) == "Vector3" and AimHacks.checkSilentAim() then
                return AimHacks["Selected"].Character.Head.Position
            end
        end
    end
    
    return backupnamecall(...)
end)

mt.__index = newcclosure(function(t, k)
    if Controller.States.AimAssist ~= false and t == Mouse and (k == "Target" or k == "Hit") and AimHacks.checkSilentAim() then
        local CPlayer = AimHacks["Selected"].Character.Head
        return (k == "Target" and CPlayer or CPlayer.Position)
    end
    return backupindex(t, k)
end)

-- // Script
local Cashiers = Workspace:WaitForChild("Cashiers")
local Drop = Workspace.Ignored:FindFirstChild("Drop")
local ItemDrops = Workspace.Ignored:FindFirstChild("ItemsDrop")

function collectMoney(Nearby, TPBack)
    local SavedCFrame = HumanoidRootPart.CFrame
    for i,v in pairs(Drop:GetDescendants()) do
        if v:IsA("ClickDetecter") and v.Parent.Name == "MoneyDrop" then
            if Nearby then
                if LocalPlayer:DistanceFromCharacter(v.Parent.Position) < 20 then
                    Teleport(v.Parent.CFrame, false)
                    wait(0.2)
                    fireclickdetector(v, 0)
                    wait(0.2)
                end
            else
                Teleport(v.Parent.CFrame, false)
                wait(1)
                fireclickdetector(v, 0)
                wait(2)
            end
        end
    end
    if TPBack then
        wait(1)
        Teleport(SavedCFrame, true)
    end
end

function collectShoes()
    local SavedCFrame = HumanoidRootPart.CFrame
    for i,v in pairs(Drop:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent.Name == "MeshPart" then
            Teleport(v.Parent.CFrame, false)
            wait(1)
            fireclickdetector(v, 0)
            wait(2)
        end
    end
    wait(1)
    Teleport(SavedCFrame, true)
end

function collectTools()
    local SavedCFrame = HumanoidRootPart.CFrame
    for i,v in pairs(ItemDrops:GetDescendants()) do
        if v:IsA("Tool") then
            for a,x in pairs(v:GetDescendants()) do
                if x:IsA("TouchTransmitter") then
                    Teleport(v.Parent.CFrame, false)
                end
            end
        end
    end
    wait(1)
    Teleport(SavedCFrame, true)
end

function collectCashiers()
    removeRagdolls()
    local SavedCFrame = HumanoidRootPart.CFrame
    for i,v in next, Workspace:WaitForChild("Cashiers"):GetChildren() do
        if v:FindFirstChildWhichIsA("Humanoid").Health > 0 then
            local targetCFrame = lootPositions[tostring(i)]
            Teleport(targetCFrame, false)
            if Backpack:FindFirstChild("Combat") then Humanoid:EquipTool(Backpack.Combat) end
            repeat VirtualUser:ClickButton1(Vector2.new()) wait() until v.Humanoid.Health <= 0
            for i = 1, 3 do
                collectMoney(true)
                HumanoidRootPart.CFrame = targetCFrame
                wait(1)
            end
        end
    end
    wait(1)
    Teleport(SavedCFrame, true)
end

protections()
Controller.Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
    Character = character
    Humanoid = Character.WaitForChild(Character, "Humanoid")
    HumanoidRootPart = Character.WaitForChild(Character, "HumanoidRootPart")
    protections()
end)

local function setLoop(name, state, callback)
    Controller.States[name] = state
    if state and not Controller.Threads[name] then
        Controller.Threads[name] = task.spawn(function()
            while Controller.States[name] do
                callback()
                task.wait()
            end
            Controller.Threads[name] = nil
        end)
    elseif not state and Controller.Threads[name] then
        task.cancel(Controller.Threads[name])
        Controller.Threads[name] = nil
    end
end

function Controller.SetProtections(state)
    Controller.States.Protections = state
    if state then
        protections()
    elseif Controller.Connections.Movement then
        Controller.Connections.Movement:Disconnect()
        Controller.Connections.Movement = nil
    end
end

function Controller.SetAntiFlyBypass(state)
    setAntiFlyBypass(state)
end

function Controller.SetTargetHighlight(state)
    Controller.States.TargetHighlight = state
end

function Controller.SetPlayerMarkers(state)
    Controller.States.PlayerMarkers = state
end

function Controller.SetSeatsDisabled(state)
    Controller.States.SeatsDisabled = state
    toggleSeats(state)
end

function Controller.SetCollectMoney(state, nearby, returnToPosition)
    setLoop("CollectMoney", state, function()
        collectMoney(nearby, returnToPosition)
    end)
end

function Controller.SetCollectShoes(state)
    setLoop("CollectShoes", state, collectShoes)
end

function Controller.SetCollectTools(state)
    setLoop("CollectTools", state, collectTools)
end

function Controller.SetCollectCashiers(state)
    setLoop("CollectCashiers", state, collectCashiers)
end

function Controller.StopAll()
    setAntiFlyBypass(false)
    for name in pairs(Controller.Threads) do
        if Controller.States[name] ~= nil then
            Controller.States[name] = false
        end
        if Controller.Threads[name] then
            task.cancel(Controller.Threads[name])
            Controller.Threads[name] = nil
        end
    end
    Controller.SetProtections(false)
end
