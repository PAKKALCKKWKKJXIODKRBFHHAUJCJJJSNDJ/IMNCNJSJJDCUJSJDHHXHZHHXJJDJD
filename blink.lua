-- ts file was generated at discord.gg/25ms
local stop = false
local _Value = game:GetService('ReplicatedStorage').GameData.LatestRoom.Value
local _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue = ({
    Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua'))(),
}).Functions.LoadCustomInstance('https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/blinkymodel.rbxm?raw=true')
local _LocalPlayer = game.Players.LocalPlayer;

(_LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid')

if typeof(_httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue) == 'Instance' and _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.ClassName == 'Model' then
    _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.PrimaryPart = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.PrimaryPart or _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue:FindFirstChildWhichIsA('BasePart')

    if _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.PrimaryPart then
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.PrimaryPart.Position = game:GetService('Workspace').CurrentRooms[_Value].Parts.Floor.Position
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.PrimaryPart.Position = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.PrimaryPart.Position + Vector3.new(0, 5, 0)
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.Parent = game.Workspace
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.PrimaryPart.Anchored = true

        if _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.Name then
            _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue.Name = 'blinky'
        end

        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue:SetAttribute('IsCustomEntity', true)
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainblinkymodelrbxmrawtrue:SetAttribute('NoAI', false)
    end
end

wait(0.1)
game:GetService('Workspace').blinky.Blink.Spawn:Play()
coroutine.wrap(function()
    openEye = function()
        game:GetService('Workspace').blinky.Blink.OpenParticle.Enabled = true
        game:GetService('Workspace').blinky.Blink.ClosedParticle.Enabled = false

        game:GetService('Workspace').blinky.Blink.Blink:Play()
        game:GetService('Workspace').blinky.Blink.BlinkForeshadow:Play()
    end
    closeEye = function()
        game:GetService('Workspace').blinky.Blink.OpenParticle.Enabled = false
        game:GetService('Workspace').blinky.Blink.ClosedParticle.Enabled = true

        game:GetService('Workspace').blinky.Blink.Blink:Play()
        game:GetService('Workspace').blinky.Blink.BlinkForeshadow:Play()
    end

    local v = 0

    while not stop do
        wait(7)

        v = v + 1

        if v == 1 then
            if game:GetService('Workspace').blinky.Blink.OpenParticle.Enabled ~= false then
                if game:GetService('Workspace').blinky.Blink.OpenParticle.Enabled == true then
                    closeEye()

                    v = 0
                end
            else
                openEye()

                v = 0
            end
        end
    end
end)()



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
                local v8 = game.workspace.blinky.Blink.CFrame.Position - Vector3.new(0, 4, 0)
                print(v8)
                v7:MoveTo(v8)
                game.Workspace.blinky.Blink.Whisper.Volume = 7
                game.Workspace.blinky.Blink.Whisper.PlaybackSpeed = 0.3
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
                local v15 = game.Workspace.blinky.Blink
                local v16 = {
                    Position = game.workspace.blinky.Blink.CFrame.Position + Vector3.new(0, 3, 0)
                }
                local v17 = {
                    Position = game.workspace.blinky.Blink.CFrame.Position - Vector3.new(0, 8, 0)
                }
                local v18 = TweenInfo.new(2)
                local v19 = {
                    Position = v7.Entity.Position,
                    Anchored = true
                }
                local v20 = v14:Create(v13, TweenInfo.new(9), v19)
                local v21 = v14:Create(v15, v18, v16)
                local v22 = v14:Create(v15.Whisper, v18, {
                    Volume = 0
                })
                v21:Play()
                v20:Play()
                wait(2.5)
                v14:Create(v15, v18, v17):Play()
                v14:Create(v13, v18, {
                    Transparency = 1
                }):Play()
                v22:Play()
                wait(3)
                game.Workspace.blinky:Destroy()
                v7:Destroy()
                v13:Destroy()
            end
            
        end
        task.wait(0.1)
        end
        end) 
        
        
coroutine.wrap(function()
    local _Humanoid = game.Players.LocalPlayer.Character:FindFirstChild('Humanoid')

    ifopen = function()
        if game:GetService('Workspace').blinky.Blink.OpenParticle.Enabled == true and _Humanoid.MoveDirection.Magnitude > 0 then
            game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.Health - 10

            local _LocalPlayer2 = game:GetService('Players').LocalPlayer

            game.ReplicatedStorage.GameStats['Player_' .. _LocalPlayer2.Name].Total.DeathCause.Value = 'Blink'

            if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
                wait()
                print(' ')
            else
                game:GetService('Workspace').blinky.Blink.Kill:Play()
            end

            wait(1)
        end
    end

    while true do
    if stop then
        break
    end

    ifopen()
    task.wait()
end
end)()
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
game:GetService('Workspace').blinky:Destroy()
