local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local stop = false
local LatestRoom = ReplicatedStorage.GameData.LatestRoom
local Room = workspace.CurrentRooms:FindFirstChild(tostring(LatestRoom.Value))

if not Room then
    return
end

local Floor = Room.Parts:FindFirstChild("Floor")

if not Floor then
    return
end

local Module_Events = require(
    ReplicatedStorage.ModulesClient.Module_Events
)

local File = "Silence_v2.rbxm"

if not isfile(File) then
    writefile(File, game:HttpGet(
        "https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/Silence_v2.rbxm"
    ))
end

local Model = game:GetObjects(getcustomasset(File))[1]

local Part = Model:FindFirstChildWhichIsA("BasePart", true)

if not Part then
    return
end

local FloorTop = Floor.Position.Y + Floor.Size.Y / 2

local TargetCFrame = CFrame.new(
    Floor.Position.X,
    FloorTop + 12,
    Floor.Position.Z
)

local Offset = TargetCFrame * Part.CFrame:Inverse()

Model:PivotTo(Offset * Model:GetPivot())
Model.Parent = workspace
Model.Name = "Silence" 

Module_Events.shatter(Room)

-- State
local Destroyed = false
local DamageLoop = nil
local RoomConnection = nil

local function Cleanup()
    if Destroyed then
        return
    end

    Destroyed = true

    if RoomConnection then
        RoomConnection:Disconnect()
        RoomConnection = nil
    end

    if DamageLoop then
        task.cancel(DamageLoop)
        DamageLoop = nil
    end

    if Model then
        Model:Destroy()
    end
end

task.spawn(function() 
while not stop do
        if game.Players.LocalPlayer.Character:FindFirstChild("Crucifix") then
            local v6 = {
                Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
            }
            stop = true
            local v7 = v6.Functions.LoadCustomInstance("https://raw.githubusercontent.com/VoorPhale012/Crucifix/refs/heads/main/pentagam.rbxm?raw=true")
            v7.Parent = game.Workspace
            if typeof(v7) == "Instance" and v7.ClassName == "Model" then
                local v8 = workspace.Silence:FindFirstChildWhichIsA("BasePart").CFrame.Position - Vector3.new(0, 11, 0)
                print(v8)
                v7:MoveTo(v8)
             
                local v9 = next
                local v10, v11 = v7:GetDescendants()
                while true do
                    local v12
                    v11, v12 = v9(v10, v11)
                    if v11 == nil then
                        break
                    end
                    if v12.Name == "BeamChain" and v12.ClassName == "Beam" then
                        v12:Destroy()
                    end
                end
                local v13 = game.Players.LocalPlayer.Character.Crucifix.Handle:Clone()
                v13.Name = "cruxy1"
                v13.Parent = game.Workspace
                v13.Anchored = true
                v13.Material = Enum.Material.Neon
                v13.Color = Color3.fromRGB(119, 255, 238)
                game.Players.LocalPlayer.Character.Crucifix:Destroy()
                wait(1)
                local v14 = game:GetService("TweenService")
                local v15 = workspace.Silence:FindFirstChildWhichIsA("BasePart")
                local v17 = {
                    Position = workspace.Silence:FindFirstChildWhichIsA("BasePart").CFrame.Position - Vector3.new(0, 20, 0)
                }
                local v18 = TweenInfo.new(5)
                local v19 = {
                    Position = v7.Entity.Position,
                    Anchored = true
                }
                local v20 = v14:Create(v13, TweenInfo.new(9), v19)
                v20:Play()
                wait(2.5)
                v14:Create(v15, v18, v17):Play()
                v14:Create(v13, v18, {
                    Transparency = 1
                }):Play()
                wait(5)
                workspace.Silence:Destroy()
                v7:Destroy()
                v13:Destroy()
            end
            
        end
        task.wait(0.1)
        end
        end) 

-- Damage loop
DamageLoop = task.spawn(function()
while Model
    and Model.Parent
    and not Destroyed
    and Humanoid
    and Humanoid.Health > 0
    and not stop
    and Model:FindFirstChildWhichIsA("BasePart")
do
        if Character:GetAttribute("Crouching") ~= true then
            Humanoid:TakeDamage(6)
            game.ReplicatedStorage.GameStats['Player_' .. game.Players.LocalPlayer.Name].Total.DeathCause.Value = 'Silence'
require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("I must crouch.",true)

            local elapsed = 0
            while elapsed < 1
                and not Destroyed
                and Model.Parent
                and Character:GetAttribute("Crouching") ~= true
            do
                task.wait(0.1)
                elapsed += 0.1
            end
        else
            task.wait(0.1)
        end
    end
end)

-- Wait for LatestRoom to change
RoomConnection = LatestRoom.Changed:Connect(function()
if not stop then
    Cleanup()
    end
end)
