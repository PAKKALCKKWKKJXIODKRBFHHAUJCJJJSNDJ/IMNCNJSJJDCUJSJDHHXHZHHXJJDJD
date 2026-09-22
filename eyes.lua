-- ts file was generated at discord.gg/25ms

local u = true
local LatestRoom = game.ReplicatedStorage.GameData.LatestRoom

local CurrentRoom

    CurrentRoom = workspace.CurrentRooms:FindFirstChild(
        tostring(LatestRoom.Value)
    )

    if CurrentRoom then
        print(CurrentRoom)
    end
    
local v = CurrentRoom.Parts:FindFirstChild("Floor") 
local v1 = game:GetObjects('rbxassetid://11388969546')[1]

local v2 = math.floor(#v.Nodes:GetChildren() / 2)

v1.CFrame = v.CFrame + Vector3.new(0, 7, 0)
v1.Parent = workspace

v1.Ambience:Play()
task.wait(0.5)

v1.Attachment.Eyes.Enabled = true

local _Humanoid = game:GetService('Players').LocalPlayer.Character:FindFirstChildOfClass('Humanoid')

while u do
    local _, v3 = workspace.CurrentCamera:WorldToScreenPoint(v1.Position)

    if v3 then
        _Humanoid.Health = _Humanoid.Health - 0.25

        v1.Attack:Play()

        if _Humanoid.Health <= 0 then
            game:GetService('ReplicatedStorage').GameStats['Player_' .. game.Players.LocalPlayer.Name].Total.DeathCause.Value = 'Eyes'

            debug.setupvalue(getconnections(game:GetService('ReplicatedStorage').Bricks.DeathHint.OnClientEvent)[1].Function, 1, {
                'You died to the Eyes...',
                "They don't like to be stared at.",
            })
        end
    end

    task.wait(0.1)
  end
