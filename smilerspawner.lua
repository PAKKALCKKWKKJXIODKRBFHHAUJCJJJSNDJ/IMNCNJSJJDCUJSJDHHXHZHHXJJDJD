local v1 = game:GetService("Players")
local vu2 = game:GetService("ReplicatedStorage")
local vu3 = game:GetService("RunService")
local vu4 = game:GetService("TweenService")
local vu5 = game:GetService("CoreGui")
local vu6 = v1.LocalPlayer
local vu7 = vu6.Character or vu6.CharacterAdded:Wait()
local v8 = vu7
local vu9 = vu7.WaitForChild(v8, "Humanoid")
local vu10 = workspace.CurrentCamera
local vu11 = 60
local vu12 = workspace.FindPartOnRayWithIgnoreList
local vu13 = vu10.WorldToViewportPoint
local vu14 = {
    DefaultConfig = loadstring(game:HttpGet("https://raw.githubusercontent.com/lelele78/ProtectSecurity.18/refs/heads/main/DefautConfig"))(),
       Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
}
local vu15 = {
    ModuleEvents = require(vu2.ModulesClient.Module_Events),
    MainGame = require(vu6.PlayerGui.MainUI.Initiator.Main_Game)
}
local vu166 = {}
local vu170 = {}
function getPlayerRoot()
    return vu7:FindFirstChild("HumanoidRootPart") or vu7:FindFirstChild("Head")
end
function dragEntity(pu18, pu19, pu20)
    local vu21 = vu166[pu18]
    if vu21.movementNode then
        vu21.movementNode:Disconnect()
    end
    vu21.movementNode = vu3.Stepped:Connect(function(_, p22)
        if pu18.Parent and not pu18:GetAttribute("NoAI") then
            local v23 = pu18.PrimaryPart.Position
            local v24 = Vector3.new(pu19.X, pu19.Y, pu19.Z) - v23
            if v24.Magnitude <= 0.1 then
                vu21.movementNode:Disconnect()
            else
                pu18:SetPrimaryPartCFrame(CFrame.new(v23 + v24.Unit * math.min(p22 * pu20, v24.Magnitude)))
            end
        end
    end)
    repeat
        task.wait()
    until not vu21.movementNode.Connected
end
function loadSound(p25)
    local v26 = Instance.new("Sound")
    local v27 = tostring(p25[1])
    local v28 = p25[2]
    local v29 = next
    local v30 = nil
    while true do
        local v31
        v30, v31 = v29(v28, v30)
        if v30 == nil then
            break
        end
        if v30 ~= "SoundId" and v30 ~= "Parent" then
            v26[v30] = v31
        end
    end
    if v27:find("rbxasset://") then
        v26.SoundId = v27
    else
        v26.SoundId = "rbxassetid://" .. v27:gsub("%D", "")
    end
    v26.Parent = workspace
    return v26
end
function vu170.createEntity(p32)
    local v33 = next
    local v34 = vu14.DefaultConfig
    local v35 = nil
    while true do
        local v36
        v35, v36 = v33(v34, v35)
        if v35 == nil then
            break
        end
        if p32[v35] == nil then
            p32[v35] = v36
        end
    end
    p32.Speed = vu11 / 100 * p32.Speed
    local v37 = LoadCustomInstance(p32.Model)
    if typeof(v37) == "Instance" and v37.ClassName == "Model" then
        v37.PrimaryPart = v37.PrimaryPart or v37:FindFirstChildWhichIsA("BasePart")
        if v37.PrimaryPart then
            v37.PrimaryPart.Anchored = true
            if p32.CustomName then
                v37.Name = p32.CustomName
            end
            v37:SetAttribute("IsCustomEntity", true)
            v37:SetAttribute("NoAI", false)
            return {
                Model = v37,
                Config = p32,
                Debug = {
                    OnEntitySpawned = function()
                    end,
                    OnEntityDespawned = function()
                    end,
                    OnEntityStartMoving = function()
                    end,
                    OnEntityFinishedRebound = function()
                    end,
                    OnEntityEnteredRoom = function()
                    end,
                    OnLookAtEntity = function()
                    end,
                    OnDeath = function()
                    end
                }
            }
        end
    end
end
function vu170.runEntity(pu38)
   
local v42 = {}

for _, Room in ipairs(workspace.CurrentRooms:GetChildren()) do
    local Entrance = Room:FindFirstChild("RoomEntrance")
    local PathfindNodes = Room:FindFirstChild("PathfindNodes")
    local Exit = Room:FindFirstChild("RoomExit")

    if Entrance then
        v42[#v42 + 1] = Entrance
    end

    if PathfindNodes then
        local NumberNodes = {}

        for _, Node in ipairs(PathfindNodes:GetChildren()) do
            local Number = tonumber(Node.Name)

            if Number then
                NumberNodes[#NumberNodes + 1] = {
                    Node = Node,
                    Number = Number
                }
            end
        end

        table.sort(NumberNodes, function(A, B)
            return A.Number < B.Number
        end)

        for _, Data in ipairs(NumberNodes) do
            v42[#v42 + 1] = Data.Node
        end
    end

    if Exit then
        v42[#v42 + 1] = Exit
    end
end

if #v42 == 0 then
    warn("No movement nodes found")
    return
end
    local vu51 = pu38.Model:Clone()
    local v52 = pu38.Config.BackwardsMovement and (# v42 or 1) or 1
    local v53 = pu38.Config.BackwardsMovement and - 50 or 50
    vu166[vu51] = {}
    local v54 = vu166[vu51]
    vu51:SetPrimaryPartCFrame(v42[v52].CFrame * CFrame.new(0, 0, v53) + Vector3.new(0, 3.5 + pu38.Config.HeightOffset, 0))
    vu51.Parent = workspace
    task.spawn(pu38.Debug.OnEntitySpawned)
    if vu5:FindFirstChild("JumpscareGui") or vu6.PlayerGui.MainUI.Death.HelpfulDialog.Visible and not vu6.PlayerGui.MainUI.DeathPanelDead.Visible then
        warn("on death screen, mute entity")
        local v55 = next
        local v56, v57 = vu51:GetDescendants()
        while true do
            local v58
            v57, v58 = v55(v56, v57)
            if v57 == nil then
                break
            end
            if v58.ClassName == "Sound" and v58.Playing then
                v58:Stop()
            end
        end
    end
    if pu38.Config.FlickerLights[1] then
        firesignal(game.ReplicatedStorage.RemotesFolder.UseEventModule.OnClientEvent, "flicker", vu2.GameData.LatestRoom.Value, pu38.Config.FlickerLights[2])
    end
    task.wait(pu38.Config.DelayTime)
    local vu59 = {}
    v54.movementTick = vu3.Stepped:Connect(function()
        if vu51.Parent and not vu51:GetAttribute("NoAI") then
            local v60 = vu51.PrimaryPart.Position
            local v61 = getPlayerRoot().Position
            local v62 = {
                vu51,
                vu7
            }
            local v63 = vu12(workspace, Ray.new(v60, Vector3.new(0, - 10, 0)), v62)
            local v64 = {
                vu51,
                vu7
            }
            local v65 = vu12(workspace, Ray.new(v60, v61 - v60), v64) == nil
            if v63 ~= nil and v63.Name == "Floor" then
                local v66 = next
                local v67, v68 = workspace.CurrentRooms:GetChildren()
                while true do
                    local v69
                    v68, v69 = v66(v67, v68)
                    if v68 == nil then
                        break
                    end
                    if v63:IsDescendantOf(v69) and not table.find(vu59, v69) then
                        vu59[# vu59 + 1] = v69
                        task.spawn(pu38.Debug.OnEntityEnteredRoom, v69)
                        if pu38.Config.BreakLights then
                            firesignal(game.ReplicatedStorage.RemotesFolder.UseEventModule.OnClientEvent, "shatter", v69)
                        end
                        break
                    end
                end
            end
            local v70 = pu38.Config.CamShake
            local v71 = (getPlayerRoot().Position - vu51.PrimaryPart.Position).Magnitude
            if v70[1] and v71 <= v70[3] then
                local v72 = next
                local v73 = v70[2]
                local v74 = nil
                local v75 = {}
                while true do
                    local v76
                    v74, v76 = v72(v73, v74)
                    if v74 == nil then
                        break
                    end
                    v75[v74] = v76
                end
                v75[1] = v70[2][1] / v70[3] * (v70[3] - v71)
                vu15.MainGame.camShaker.ShakeOnce(vu15.MainGame.camShaker, table.unpack(v75))
            end
            if v65 then
                if game.Players.LocalPlayer.Character:FindFirstChild("Crucifix") then
                    local v77 = game:GetService("TweenService")
                    vu51:SetAttribute("NoAI", true)
                    local v78 = game.Players.LocalPlayer.Character.Crucifix.Handle:Clone()
                    game.Players.LocalPlayer.Character.Crucifix:Destroy()
                    v78.Parent = game.Workspace
                    v78.Name = "cruxy"
                    v78.Anchored = true
                    v78.Color = Color3.fromRGB(255, 86, 86)
                    v78.Material = Enum.Material.Neon
                    v77:Create(v78, TweenInfo.new(5), {
                        Transparency = 1
                    }):Play()
                   function GitAud(soundgit,filename)
    SoundName=tostring(SoundName)
    local url=soundgit
    local FileName = filename
    writefile(FileName..".mp3", game:HttpGet(url))
    return (getcustomasset or getsynasset)(FileName..".mp3")
end

function CustomGitSound(soundlink, vol, filename)
    local sound = Instance.new("Sound")
    sound.SoundId = GitAud(soundlink, filename)
    sound.Parent = workspace
    sound.Volume = 2.6
sound.Looped = false
   sound:Play()
end

CustomGitSound("https://raw.githubusercontent.com/Voor-Pr00/Eye/refs/heads/main/DOORS-UNUSED-SOUNDTRACK-Stress%20(mp3cut.net).mp3", 1, "crucifix")
                    local v79 = {
    DefaultConfig = loadstring(game:HttpGet("https://raw.githubusercontent.com/lelele78/ProtectSecurity.18/refs/heads/main/DefautConfig"))(),                                               Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
                    }
                    local v80 = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game
                    require(v80).camShaker:ShakeOnce(200, 5, 0.1, 0.15)
                    local v81 = v79.Functions.LoadCustomInstance("https://raw.githubusercontent.com/VoorPhale012/Crucifix/refs/heads/main/pentagam.rbxm?raw=true")
                    v81.Parent = game.Workspace
                    local v82 = game.Workspace.Smiler
                    if typeof(v81) == "Instance" and v81.ClassName == "Model" then
                        v81:MoveTo(v82.SmilerNew.CFrame.Position - Vector3.new(0, pu38.Config.HeightOffset, 0) - Vector3.new(0, 3, 0))
                        local v83 = game.Workspace.Smiler:Clone()
                        v83.Parent = game.Workspace
                        v83.Name = "SmilerClone"
                        v81.Entity.CFrame = v83.SmilerNew.CFrame
                        vu51:Destroy()
                        v82:Destroy()
                        Color3.fromRGB()
                        local v84 = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(0.4549, 0, 0)),
                            ColorSequenceKeypoint.new(1, Color3.new(0.4549, 0, 0))
                        })
                        if true == true then
                            local v85 = next
                            local v86, v87 = v81:GetDescendants()
                            while true do
                                local v88
                                v87, v88 = v85(v86, v87)
                                if v87 == nil then
                                    break
                                end
                                if v88.ClassName == "Beam" then
                                    v88.Color = v84
                                end
                            end
                            v81.Circle.Lines.Color = v84
                            v81.Circle.Spark.Color = v84
                        end
                        local v89 = {
                            Position = v83.SmilerNew.CFrame.Position + Vector3.new(0, 3, 0)
                        }
                        local v90 = {
                            Position = v83.SmilerNew.CFrame.Position - Vector3.new(0, 18, 0)
                        }
                        local v91 = v77:Create(v83.SmilerNew, TweenInfo.new(2), v89)
                        local v92 = v77:Create(v81.Entity, TweenInfo.new(2), v89)
                        v91:Play()
                        v92:Play()
                        wait(2)
                        local v93 = next
                        local v94, v95 = v83.SmilerNew:GetDescendants()
                        while true do
                            local v96
                            v95, v96 = v93(v94, v95)
                            if v95 == nil then
                                break
                            end
                            if v96.ClassName == "Sound" then
                                v77:Create(v96, TweenInfo.new(3), {
                                    Volume = 0
                                }):Play()
                            end
                        end
                        local v97 = v77:Create(v83.SmilerNew, TweenInfo.new(3), v90)
                        local v98 = v77:Create(v81.Entity, TweenInfo.new(3), v90)
                        v97:Play()
                        v98:Play()
                        wait(4)
                        v83:Destroy()
                        v78:Destroy()
                        v81:Destroy()
                       local DoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guestly-Alt/Scripts/refs/heads/main/AchievementHolder.lua"))()

DoorsNotify({
    Style = "UNLOCKED ACHIEVEMENT",
    Title = "You put a smile on my face",
    Description = "You\'re annoying.",
    Reason = "Used Crucifix on \'\'Smiler\'\'",
    Image = "rbxassetid://11417375410",
    Time = 5
})
                       
                    end
                end
                local _, v99 = vu13(vu10, vu51.PrimaryPart.Position)
                if v99 then
                    task.spawn(pu38.Debug.OnLookAtEntity)
                end
                if pu38.Config.CanKill and (not vu7:GetAttribute("IsDead") and (not vu7:GetAttribute("Invincible") and (not vu7:GetAttribute("Hiding") and (getPlayerRoot().Position - vu51.PrimaryPart.Position).Magnitude <= pu38.Config.KillRange))) then
                    task.spawn(function()
                        vu7:SetAttribute("IsDead", true)
                        warn("mute entity")
                        local v100 = next
                        local v101, v102 = vu51:GetDescendants()
                        while true do
                            local v103
                            v102, v103 = v100(v101, v102)
                            if v102 == nil then
                                break
                            end
                            if v103.ClassName == "Sound" and v103.Playing then
                                v103:Stop()
                            end
                        end
                        if pu38.Config.Jumpscare[1] then
                            vu170.runJumpscare(pu38.Config.Jumpscare[2])
                        end
                        task.spawn(pu38.Debug.OnDeath)
                        vu9.Health = 0
                        vu2.GameStats["Player_" .. vu6.Name].Total.DeathCause.Value = vu51.Name
                        if # pu38.Config.CustomDialog > 0 then
                           
                        end
                        task.spawn(function()
                            repeat
                                task.wait()
                            until vu6.PlayerGui.MainUI.DeathPanelDead.Visible
                            warn("unmute entity:", vu51)
                            local v104 = next
                            local v105, v106 = vu51:GetDescendants()
                            while true do
                                local v107
                                v106, v107 = v104(v105, v106)
                                if v106 == nil then
                                    break
                                end
                                if v107.ClassName == "Sound" then
                                    local v108 = v107.Volume
                                    v107.Volume = 0
                                    v107:Play()
                                    vu4:Create(v107, TweenInfo.new(2), {
                                        Volume = v108
                                    }):Play()
                                end
                            end
                        end)
                    end)
                end
            end
        end
    end)
    task.spawn(pu38.Debug.OnEntityStartMoving)
    local v109 = pu38.Config.Cycles
    local v110
    if pu38.Config.BackwardsMovement then
        v110 = {}
        for v111 = # v42, 1, - 1 do
            v110[# v110 + 1] = v42[v111]
        end
    else
        v110 = v42
    end
    for v112 = 1, math.max(math.random(v109.Min, v109.Max), 1) do
        local _ = v112
        for v113 = 1, # v110 do
            dragEntity(vu51, v110[v113].Position + Vector3.new(0, 3.5 + pu38.Config.HeightOffset, 0), pu38.Config.Speed)
        end
        if v109.Max > 1 then
            for v114 = # v110, 1, - 1 do
                dragEntity(vu51, v110[v114].Position + Vector3.new(0, 3.5 + pu38.Config.HeightOffset, 0), pu38.Config.Speed)
            end
        end
        task.spawn(pu38.Debug.OnEntityFinishedRebound)
        if v112 < v109.Max then
            task.wait(v109.WaitTime)
        end
    end
    if not vu51:GetAttribute("NoAI") then
        local v115 = next
        local v116 = nil
        while true do
            local v117
            v116, v117 = v115(v54, v116)
            if v116 == nil then
                break
            end
            v117:Disconnect()
        end
        vu51:Destroy()
        task.spawn(pu38.Debug.OnEntityDespawned)
    end
end
function vu170.runJumpscare(pu118)
    local v119 = LoadCustomAsset(pu118.Image1)
    local v120 = LoadCustomAsset(pu118.Image2)
    local v121 = nil
    local v122
    if pu118.Sound1 then
        v122 = loadSound(pu118.Sound1)
    else
        v122 = nil
    end
    if pu118.Sound2 then
        v121 = loadSound(pu118.Sound2)
    end
    local vu123 = Instance.new("ScreenGui")
    local vu124 = Instance.new("Frame")
    local vu125 = Instance.new("ImageLabel")
    vu123.Name = "JumpscareGui"
    vu123.IgnoreGuiInset = true
    vu123.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    vu124.Name = "Background"
    vu124.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    vu124.BorderSizePixel = 0
    vu124.Size = UDim2.new(1, 0, 1, 0)
    vu124.ZIndex = 999
    vu125.Name = "Face"
    vu125.AnchorPoint = Vector2.new(0.5, 0.5)
    vu125.BackgroundTransparency = 1
    vu125.Position = UDim2.new(0.5, 0, 0.5, 0)
    vu125.ResampleMode = Enum.ResamplerMode.Pixelated
    vu125.Size = UDim2.new(0, 150, 0, 150)
    vu125.Image = v119
    vu125.Parent = vu124
    vu124.Parent = vu123
    vu123.Parent = vu5
    local v126 = pu118.Tease
    local v127 = vu123.AbsoluteSize.Y
    local v128 = v127 / 5
    local v129 = v127 / 2.5
    if v126[1] then
        local v130 = math.random(v126.Min, v126.Max)
        v122:Play()
        for _ = v126.Min, v130 do
            task.wait(math.random(100, 200) / 100)
            local v131 = (v129 - v128) / v130
            vu125.Size = UDim2.new(0, vu125.AbsoluteSize.X + v131, 0, vu125.AbsoluteSize.Y + v131)
        end
        task.wait(math.random(100, 200) / 100)
    end
    if pu118.Flashing[1] then
        task.spawn(function()
            while vu123.Parent do
                vu124.BackgroundColor3 = pu118.Flashing[2]
                task.wait(math.random(25, 100) / 1000)
                vu124.BackgroundColor3 = Color3.new(0, 0, 0)
                task.wait(math.random(25, 100) / 1000)
            end
        end)
    end
    if pu118.Shake then
        task.spawn(function()
            local v132 = vu125.Position
            while vu123.Parent do
                vu125.Position = v132 + UDim2.new(0, math.random(- 10, 10), 0, math.random(- 10, 10))
                vu125.Rotation = math.random(- 5, 5)
                task.wait()
            end
        end)
    end
    vu125.Image = v120
    vu125.Size = UDim2.new(0, v129, 0, v129)
    v121:Play()
    vu4:Create(vu125, TweenInfo.new(0.75), {
        Size = UDim2.new(0, v127 * 3, 0, v127 * 3),
        ImageTransparency = 0.5
    }):Play()
    task.wait(0.75)
    vu123:Destroy()
    if v122 then
        v122:Destroy()
    end
    if v121 then
        v121:Destroy()
    end
end
task.spawn(function()
    while true do
        local v133 = next
        local v134, v135 = workspace:GetChildren()
        local v136 = false
        while true do
            local v137
            v135, v137 = v133(v134, v135)
            if v135 == nil then
                break
            end
            if v137.Name == "RushMoving" or (v137.Name == "AmbushMoving" or v137:GetAttribute("IsCustomEntity")) then
                v136 = true
            end
        end
        vu2.GameData.ChaseInSession.Value = v136
        task.wait(0.5)
    end

end)
local vu138 = vu170.createEntity({
    CustomName = "Smiler",
    Model = "rbxassetid://17071491370",
    Speed = 850,
    DelayTime = 14,
    HeightOffset = 0,
    CanKill = false,
    KillRange = 60,
    BackwardsMovement = false,
    BreakLights = true,
    FlickerLights = {
        true,
        9.5
    },
    Cycles = {
        Min = 11,
        Max = 12,
        WaitTime = 0
    },
    CamShake = {
        true,
        {
            5,
            15,
            0.1,
            1
        },
        100
    },
    Jumpscare = {
        true,
        { 
            Image1 = "rbxassetid://11417375410",
            Image2 = "rbxassetid://11417375410",
            Shake = true,
            Sound1 = {
                5263560566,
                {
                    Volume = 2.1
                }
            },
            Sound2 = {
                5263560566,
                {
                    Volume = 2.1
                }
            },
            Flashing = {
                true,
                Color3.fromRGB(255, 0, 0)
            },
            Tease = {
                Min = 1,
                Max = 3,
                false
            }
        }
    },
    CustomDialog = {
        "I REMEMBER THAT SMILE ...",
        "It seems like u got access to an entity that isn\'t released yet.",
        "Please report to LSplash#1234 and Redibles#7070 if this happens again."
    }
})
function vu138.Debug.OnEntitySpawned()
    print("Entity has spawned:", vu138)
end
function vu138.Debug.OnEntityDespawned()
    print("Entity has despawned:", vu138)
end
function vu138.Debug.OnEntityStartMoving()
    print("Entity has started smiling:", vu138)
end
function vu138.Debug.OnEntityFinishedRebound()
    print("Entity has finished rebound:", vu138)
end
function vu138.Debug.OnEntityEnteredRoom(p139)
    print("Entity:", vu138, "has entered room:", p139)
end
function vu138.Debug.OnLookAtEntity()
    print("Player has looked at entity:", vu138)
end
function vu138.Debug.OnDeath()
    warn("smile more")
end
vu170.runEntity(vu138)
