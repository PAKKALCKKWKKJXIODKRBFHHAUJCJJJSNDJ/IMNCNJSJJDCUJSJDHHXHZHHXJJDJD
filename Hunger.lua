-- ts file was generated at discord.gg/25ms

local v = '0.02'
local u = {
    '...',
}

local v = game.ReplicatedStorage.GameData.LatestRoom.Changed:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid:TakeDamage(1000)

    game:GetService('ReplicatedStorage').GameStats['Player_' .. game.Players.LocalPlayer.Name].Total.DeathCause.Value = 'Hunger [Opened Door]'
end)

onNotLook = function()
    game.Players.LocalPlayer.Character.Humanoid.Health = game.Players.LocalPlayer.Character.Humanoid.Health - 2.5

    local v1 = tick()
    local v2 = 7

    while v1 + 1 / v2 > tick() do end

    wait()
    tick()
end
local DisabledEffects = {}
local spawn
local _Players = game:GetService('Players')
local _Value = game:GetService('ReplicatedStorage').GameData.LatestRoom.Value
local _LocalPlayer = _Players.LocalPlayer;

(_LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()):WaitForChild('Humanoid')

local _CurrentCamera = workspace.CurrentCamera
local _WorldToViewportPoint = _CurrentCamera.WorldToViewportPoint
local _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue = ({
    Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua'))(),
}).Functions.LoadCustomInstance('https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/hunger.rbxm?raw=true')

if typeof(_httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue) == 'Instance' and _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.ClassName == 'Model' then
    _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart or _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:FindFirstChildWhichIsA('BasePart')

    if _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart then
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart.Position = game:GetService('Workspace').CurrentRooms[_Value].Parts.Floor.Position
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart.Position = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart.Position + Vector3.new(0, 5, 0)
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.Parent = game.Workspace
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart.Anchored = true
        spawn = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.HungerNew.spawnsound
        spawn.Parent = workspace
        spawn.PlaybackSpeed = 1
        spawn.RollOffMaxDistance = 1000000000000
        spawn.Volume = 1.5
           

        for _, Obj in ipairs(
            _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:GetDescendants()
        ) do
            if Obj:IsA('ParticleEmitter') or Obj:IsA('PointLight') then
                if Obj.Enabled then
                    table.insert(DisabledEffects, Obj)
                    Obj.Enabled = false
                end
            end
        end
        
        spawn:Play() 
        
      


        if _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.Name then
            _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.Name = 'Hunger'
        end

        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:SetAttribute('IsCustomEntity', true)
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:SetAttribute('NoAI', false)

        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.HungerNew.Attachment.ParticleEmitter.Rate = '50'
    end
end

spawn.Ended:Wait()

task.wait(1)

v:Disconnect() 

for _, Obj in ipairs(DisabledEffects) do
            if Obj and Obj.Parent then
                Obj.Enabled = true
            end
        end

touch = function()
    local _Humanoid = game.Players.LocalPlayer.Character.Humanoid

    if _Humanoid then
        _Humanoid.Health = 0

        local _LocalPlayer2 = game:GetService('Players').LocalPlayer

        game.ReplicatedStorage.GameStats['Player_' .. _LocalPlayer2.Name].Total.DeathCause.Value = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.Name
    end
end

_httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.HungerNew.Touched:Connect(touch)

while _Value == game:GetService('ReplicatedStorage').GameData.LatestRoom.Value do
    wait(v)

    local _, v3 = _WorldToViewportPoint(_CurrentCamera, _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart.Position)

    if v3 or 0 >= game.Players.LocalPlayer.Character.Humanoid.Health then
        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.HungerNew.crash:Stop()
    else
        task.spawn(onNotLook)

        local _LocalPlayer3 = game:GetService('Players').LocalPlayer

        game.ReplicatedStorage.GameStats['Player_' .. _LocalPlayer3.Name].Total.DeathCause.Value = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.Name


        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.HungerNew.crash.Volume = '10'

        _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.HungerNew.crash:Play()
    end
end

game:GetService('Workspace').Hunger:Destroy()
