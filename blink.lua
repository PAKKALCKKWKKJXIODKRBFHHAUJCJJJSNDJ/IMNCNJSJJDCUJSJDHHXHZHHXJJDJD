-- ts file was generated at discord.gg/25ms

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

    while true do
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
        wait(1e-6)
        ifopen()
    end
end)()
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
game:GetService('Workspace').blinky:Destroy()
