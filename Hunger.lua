
local v = '0.02'
local u = {
'...',
}

local stop = false
local body

local function GetGitSound(GithubSnd, SoundName)
			local url = GithubSnd
			if not isfile(SoundName .. ".mp3") then
				writefile(SoundName .. ".mp3", game:HttpGet(url))
			end
			local sound = Instance.new("Sound")
			sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
			return sound
		end
		
		local gitSoundTemp2 = GetGitSound("https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/XRecorder_Edited_20260926_01.mp3?raw=true", "papkdjcjjdjdjc")

local blaSound = Instance.new("Sound") 
		blaSound.SoundId = gitSoundTemp2.SoundId
		blaSound.PlaybackSpeed = 1
		blaSound.Looped = false
		blaSound.TimePosition = 0
		blaSound.Volume = 1
		blaSound.RollOffMaxDistance = 150
		
		blaSound.Ended:Connect(function()
		blaSound:Destroy() 
		end) 

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
    body = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart
    spawn = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:FindFirstChildWhichIsA("BasePart").spawnsound  
    spawn.Parent = workspace  
    spawn.PlaybackSpeed = 1  
    spawn.RollOffMaxDistance = 1000000000000  
    spawn.Volume = 1.5  
    blaSound.Parent = body
         

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

    _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:FindFirstChildWhichIsA("BasePart").Attachment.ParticleEmitter.Rate = '50'  
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

task.spawn(function()

while not stop and body.Parent and body do
if game.Players.LocalPlayer.Character:FindFirstChild("Crucifix") then
local v6 = {
Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
}
stop = true
local v7 = v6.Functions.LoadCustomInstance("https://raw.githubusercontent.com/VoorPhale012/Crucifix/refs/heads/main/pentagam.rbxm?raw=true")
v7.Parent = game.Workspace
if typeof(v7) == "Instance" and v7.ClassName == "Model" then
local v8 = body.Position - Vector3.new(0, 4, 0)
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
blaSound:Play() 
local v14 = game:GetService("TweenService")
local v15 = body
local v16 = {
Position = v15.Position + Vector3.new(0, 3, 0)
}
local v17 = {
Position = v15.Position - Vector3.new(0, 8, 0)
}
local v18 = TweenInfo.new(2)
local v19 = {
Position = v7.Entity.Position,
Anchored = true
}
local v20 = v14:Create(v13, TweenInfo.new(9), v19)
local v21 = v14:Create(v15, v18, v16)

v21:Play()  
            v20:Play()  
            wait(2.5)  
            v14:Create(v15, v18, v17):Play()  
            v14:Create(v13, v18, {  
                Transparency = 1  
            }):Play()  
       
            wait(3)  
            _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:Destroy()  
            v7:Destroy()  
            v13:Destroy()  
        end  
          
    end  
    task.wait(0.1)  
    end  
    end)

touch = function()
if stop then return end

local _Humanoid = game.Players.LocalPlayer.Character.Humanoid  

if _Humanoid then  
    _Humanoid.Health = 0  

    local _LocalPlayer2 = game:GetService('Players').LocalPlayer  

    game.ReplicatedStorage.GameStats['Player_' .. _LocalPlayer2.Name].Total.DeathCause.Value = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.Name  
end

end

_httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:FindFirstChildWhichIsA("BasePart").Touched:Connect(touch)

while _Value == game:GetService('ReplicatedStorage').GameData.LatestRoom.Value and not stop do
wait(v)

local _, v3 = _WorldToViewportPoint(_CurrentCamera, _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.PrimaryPart.Position)  

if v3 or 0 >= game.Players.LocalPlayer.Character.Humanoid.Health then  
    _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:FindFirstChildWhichIsA("BasePart").crash:Stop()  
else  
    task.spawn(onNotLook)  

    local _LocalPlayer3 = game:GetService('Players').LocalPlayer  

    game.ReplicatedStorage.GameStats['Player_' .. _LocalPlayer3.Name].Total.DeathCause.Value = _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue.Name  


    _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:FindFirstChildWhichIsA("BasePart").crash.Volume = '10'  

    _httpsgithubcomPABMAXICHACdoorsmonstersmodelsblobmainhungerrbxmrawtrue:FindFirstChildWhichIsA("BasePart").crash:Play()  
end

end


if not stop then
game:GetService('Workspace').Hunger:Destroy()
end
