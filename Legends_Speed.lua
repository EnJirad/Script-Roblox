-- Load Xlib
local Xlib = loadstring(game:HttpGet('https://raw.githubusercontent.com/EnJirad/GUI/main/Xlib.lua'))()

-- Create main window
local Window = Xlib:MakeWindow({Name = "Legends Speed"})

-- Services and variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Tab 1: Farm Gem, Ore
local Tab1 = Xlib:MakeTab({Name = "Farm Gem, Ore", Parent = Window})

local InfJump = false
Xlib:MakeToggle({
    Name = "InfJump",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        InfJump = value
    end
})

local function onJumpRequest()
    if InfJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end
UserInputService.JumpRequest:Connect(onJumpRequest)

local AntiAFK
Xlib:MakeToggle({
    Name = "Anti AFK",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        AntiAFK = value
        if AntiAFK then
            wait(3)
            local VirtualUser=game:service'VirtualUser'
            game:service('Players').LocalPlayer.Idled:connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

local teleportingOrbs = false
local teleportingGems = false
local visitedOrbs = {}
local visitedGems = {}

local function teleportToOrbs()
    while teleportingOrbs do
        local cityFolder = Workspace:FindFirstChild("orbFolder"):FindFirstChild("City")
        if cityFolder then
            for _, orb in pairs(cityFolder:GetChildren()) do
                if not teleportingOrbs then break end
                if (orb.Name == "Blue Orb" or orb.Name == "Orange Orb" or orb.Name == "Red Orb" or orb.Name == "Yellow Orb") and not visitedOrbs[orb] then
                    local innerOrb = orb:FindFirstChild("innerOrb")
                    if innerOrb then
                        HumanoidRootPart.CFrame = innerOrb.CFrame
                        visitedOrbs[orb] = true
                        wait(0.1)
                    end
                end
            end
        end
        wait(0.1)
    end
end

local function teleportToGems()
    while teleportingGems do
        local cityFolder = Workspace:FindFirstChild("orbFolder"):FindFirstChild("City")
        if cityFolder then
            for _, gem in pairs(cityFolder:GetChildren()) do
                if not teleportingGems then break end
                if gem.Name == "Gem" and not visitedGems[gem] then
                    local innerGem = gem:FindFirstChild("innerGem")
                    if innerGem then
                        HumanoidRootPart.CFrame = innerGem.CFrame
                        visitedGems[gem] = true
                        wait(0.1)
                    end
                end
            end
        end
        wait(0.1)
    end
end

Xlib:MakeToggle({
    Name = "Tp Orb, Gem",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        teleportingOrbs = value
        teleportingGems = value
        if value then
            coroutine.wrap(teleportToOrbs)()
            coroutine.wrap(teleportToGems)()
        else
            visitedOrbs = {}
            visitedGems = {}
        end
    end
})

-- Tab 2: Pet
local Tab2 = Xlib:MakeTab({Name = "Pet", Parent = Window})

local Open_Crystal = false
local All_Crystal = {
    ["Red Crystal : 300"] = function()
        local rounds = 0
        spawn(function()
            while Open_Crystal do
                local args = {"openCrystal", "Red Crystal"}
                game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(unpack(args))
                rounds = rounds + 1
                StarterGui:SetCore("SendNotification", {
                    Title = "Check Open",
                    Text = "Open Red Crystal " .. rounds .. " Egg",
                    Duration = 5
                })
                wait(0.5)
            end
        end)
    end,
    
    ["Blue Crystal : 600"] = function()
        local rounds = 0
        spawn(function()
            while Open_Crystal do
                local args = {"openCrystal", "Blue Crystal"}
                game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(unpack(args))
                rounds = rounds + 1
                StarterGui:SetCore("SendNotification", {
                    Title = "Check Open",
                    Text = "Open Blue Crystal " .. rounds .. " Egg",
                    Duration = 5
                })
                wait(0.5)
            end
        end)
    end,
    
    ["Lightning Crystal : 2.5K"] = function()
        local rounds = 0
        spawn(function()
            while Open_Crystal do
                local args = {"openCrystal", "Lightning Crystal"}
                game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(unpack(args))
                rounds = rounds + 1
                StarterGui:SetCore("SendNotification", {
                    Title = "Check Open",
                    Text = "Open Lightning Crystal " .. rounds .. " Egg",
                    Duration = 5
                })
                wait(0.5)
            end
        end)
    end,
}

local Secret_Crystal
Xlib:MakeDropdown({
    Name = "Crystal World 1",
    Parent = Tab2,
    Options = {"Red Crystal : 300", "Blue Crystal : 600", "Lightning Crystal : 2.5K"},
    Callback = function(option)
        Secret_Crystal = All_Crystal[option]
    end
})

Xlib:MakeToggle({
    Name = "Open Crystal",
    Parent = Tab2,
    Default = false,
    Callback = function(value)
        Open_Crystal = value
        if value and Secret_Crystal then
            Secret_Crystal()
        end
    end
})

-- Tab 3: Teleport World
local Tab3 = Xlib:MakeTab({Name = "Teleport World", Parent = Window})

local All_World = {
    ["City"] = function()
        local city = Workspace:FindFirstChild("areaTeleportParts")
        if city then
            for _, v in pairs(city:GetChildren()) do
                if v.Name == "cityToFrostCourse" then
                    HumanoidRootPart.CFrame = v.CFrame
                    StarterGui:SetCore("SendNotification", {
                        Title = "Teleport",
                        Text = "TP to City Successfully",
                        Duration = 5
                    })
                end
            end
        end
    end,
    
    ["Snow City"] = function()
        local city = Workspace:FindFirstChild("areaTeleportParts")
        if city then
            for _, v in pairs(city:GetChildren()) do
                if v.Name == "infernoCaveToSnowCity" then
                    HumanoidRootPart.CFrame = v.CFrame
                    StarterGui:SetCore("SendNotification", {
                        Title = "Teleport",
                        Text = "TP to Snow City Successfully",
                        Duration = 5
                    })
                end
            end
        end
    end,
}

local Secret_World
Xlib:MakeDropdown({
    Name = "Select World",
    Parent = Tab3,
    Options = {"City", "Snow City"},
    Callback = function(option)
        Secret_World = All_World[option]
    end
})

Xlib:MakeButton({
    Name = "TP World",
    Parent = Tab3,
    Callback = function()
        if Secret_World then
            Secret_World()
        end
    end
})
