local Xlib = loadstring(game:HttpGet('https://raw.githubusercontent.com/EnJirad/GUI/main/Xlib'))()

local Window = Xlib:MakeWindow({Name = "Legends Speed"})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local Tab1 = Xlib:MakeTab({
    Name = "Farm Gem, Ore",
    Parent = Window
})

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
game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)

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
                        wait(0.1)  -- Wait before teleporting to the next orb
                    end
                end
            end
        end
        wait(0.1)  -- Ensure the loop doesn't run too quickly
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
                        wait(0.1)  -- Wait before teleporting to the next gem
                    end
                end
            end
        end
        wait(0.1)  -- Ensure the loop doesn't run too quickly
    end
end

Xlib:MakeToggle({
    Name = "Tp Orb",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        teleportingOrbs = value
        if teleportingOrbs then
            coroutine.wrap(teleportToOrbs)()  -- Start teleporting in a coroutine
        else
            visitedOrbs = {}  -- Clear the visited orbs when stopping
        end
    end
})

Xlib:MakeToggle({
    Name = "Tp Gem",
    Parent = Tab1,
    Default = false,
    Callback = function(value)
        teleportingGems = value
        if teleportingGems then
            coroutine.wrap(teleportToGems)()  -- Start teleporting in a coroutine
        else
            visitedGems = {}  -- Clear the visited gems when stopping
        end
    end
})
