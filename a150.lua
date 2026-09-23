-- ts file was generated at discord.gg/25ms

coroutine.wrap(function()
    wait(0.01)

    local _A150 = game.Workspace:WaitForChild('A-150')

    while true do
        wait(0.01)

        local _Magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - _A150.A150New.Position).Magnitude

        if game.Players.LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 and _Magnitude <= 25 then
            local v = {
                'You died??',
                'Oh, that entity...',
                'Watch out your steps.',
            }
            local v1 = 'A-150'

            game.Players.LocalPlayer.Character.Humanoid.Health = 0


            game.ReplicatedStorage.GameStats['Player_' .. game.Players.LocalPlayer.Name].Total.DeathCause.Value = v1
        end
    end
end)()

local _Players = game:GetService('Players')
local _ReplicatedStorage = game:GetService('ReplicatedStorage')
local _RunService = game:GetService('RunService')
local _TweenService = game:GetService('TweenService')
local _CoreGui = game:GetService('CoreGui')
local _LocalPlayer = _Players.LocalPlayer
local u = _LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()
local v2 = u
local u1 = u.WaitForChild(v2, 'Humanoid')
local _CurrentCamera = workspace.CurrentCamera
local u2 = 60
local _FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList
local _WorldToViewportPoint = _CurrentCamera.WorldToViewportPoint
local u3 = {
    DefaultConfig = loadstring(game:HttpGet('https://raw.githubusercontent.com/lelele78/ProtectSecurity.18/refs/heads/main/DefautConfig'))(),
    Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua'))(),
}
local u4 = {
    ModuleEvents = require(_ReplicatedStorage.ModulesClient.Module_Events),
    MainGame = require(_LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game),
}
local u5 = {}
local u6 = {}

onCharacterAdded = function(p1)
    u1 = p1:WaitForChild('Humanoid')
    u = p1
end
getPlayerRoot = function()
    return u:FindFirstChild('HumanoidRootPart') or u:FindFirstChild('Head')
end
dragEntity = function(p2, p3, p4)
    local u7 = u5[p2]

    if u7.movementNode then
        u7.movementNode:Disconnect()
    end

    u7.movementNode = _RunService.Stepped:Connect(function(_, p5)
        if p2.Parent and not p2:GetAttribute('NoAI') then
            local _Position = p2.PrimaryPart.Position
            local v3 = Vector3.new(p3.X, p3.Y, p3.Z) - _Position

            if v3.Magnitude <= 0.1 then
                u7.movementNode:Disconnect()
            else
                p2:PivotTo(CFrame.new(_Position + v3.Unit * math.min(p5 * p4, v3.Magnitude)))
            end
        end
    end)

    repeat
        task.wait()
    until not u7.movementNode.Connected
end
loadSound = function(p6)
    local _Sound = Instance.new('Sound')
    local v4 = tostring(p6[1])
    local v5 = p6[2]

    for v6, v7 in next, v5 do
        if v6 ~= 'SoundId' then
            if v6 ~= 'Parent' then
                _Sound[v6] = v7
            end
        end
    end

    if v4:find('rbxasset://') then
        _Sound.SoundId = v4
    else
        _Sound.SoundId = 'rbxassetid://' .. v4:gsub('%D', '')
    end

    _Sound.Parent = workspace

    return _Sound
end
u6.createEntity = function(p7)
    for v8, v9 in next, u3.DefaultConfig do
        if p7[v8] == nil then
            p7[v8] = v9
        end
    end

    p7.Speed = u2 / 100 * p7.Speed

    local v10 = LoadCustomInstance(p7.Model)

    if typeof(v10) == 'Instance' and v10.ClassName == 'Model' then
        v10.PrimaryPart = v10.PrimaryPart or v10:FindFirstChildWhichIsA('BasePart')

        if v10.PrimaryPart then
            v10.PrimaryPart.Anchored = true

            if p7.CustomName then
                v10.Name = p7.CustomName
            end

            v10:SetAttribute('IsCustomEntity', true)
            v10:SetAttribute('NoAI', false)

            return {
                Model = v10,
                Config = p7,
                Debug = {
                    OnEntitySpawned = function() end,
                    OnEntityDespawned = function() end,
                    OnEntityStartMoving = function() end,
                    OnEntityFinishedRebound = function() end,
                    OnEntityEnteredRoom = function() end,
                    OnLookAtEntity = function() end,
                    OnDeath = function() end,
                },
            }
        end
    end
end
u6.runEntity = function(p8)
    local v11 = next
    local v12, v13 = workspace.CurrentRooms:GetChildren()
    local v14 = {}

    for _, v15 in v11, v12, v13 do
        local _PathfindNodes = v15:FindFirstChild('PathfindNodes')
        local v16

        if _PathfindNodes then
            v16 = _PathfindNodes:GetChildren()
        else
            local _Part = Instance.new('Part')

            _Part.Name = '1'
            _Part.CFrame = v15:WaitForChild('RoomExit').CFrame - Vector3.new(0, v15.RoomExit.Size.Y / 2, 0)
            v16 = {_Part}
        end

        table.sort(v16, function(p9, p10)
            return tonumber(p9.Name) < tonumber(p10.Name)
        end)

        for _, v17 in next, v16 do
            v14[#v14 + 1] = v17
        end
    end

    local u8 = p8.Model:Clone()
    local v18 = p8.Config.BackwardsMovement and (#v14 or 1) or 1
    local v19 = p8.Config.BackwardsMovement and -50 or 50

    u5[u8] = {}

    local v20 = u5[u8]

    u8:PivotTo(v14[v18].CFrame * CFrame.new(0, 0, v19) + Vector3.new(0, 3.5 + p8.Config.HeightOffset, 0))

    u8.Parent = workspace

    task.spawn(p8.Debug.OnEntitySpawned)

    if _CoreGui:FindFirstChild('JumpscareGui') or _LocalPlayer.PlayerGui.MainUI.Death.HelpfulDialog.Visible and not _LocalPlayer.PlayerGui.MainUI.DeathPanelDead.Visible then
        warn('on death screen, mute entity')

        local v21 = next
        local v22, v23 = u8:GetDescendants()

        for _, v24 in v21, v22, v23 do
            if v24.ClassName == 'Sound' then
                if v24.Playing then
                    v24:Stop()
                end
            end
        end
    end
    if p8.Config.FlickerLights[1] then
        u4.ModuleEvents.flicker(workspace.CurrentRooms[_ReplicatedStorage.GameData.LatestRoom.Value], p8.Config.FlickerLights[2])
    end

    task.wait(p8.Config.DelayTime)

    local u9 = {}

    v20.movementTick = _RunService.Stepped:Connect(function()
        if u8.Parent and not u8:GetAttribute('NoAI') then
            local _Position2 = u8.PrimaryPart.Position
            local _Position3 = getPlayerRoot().Position
            local v25 = {u8, u}
            local v26 = _FindPartOnRayWithIgnoreList(workspace, Ray.new(_Position2, Vector3.new(0, -10, 0)), v25)
            local v27 = {u8, u}
            local v28 = _FindPartOnRayWithIgnoreList(workspace, Ray.new(_Position2, _Position3 - _Position2), v27) == nil

            if v26 ~= nil and v26.Name == 'Floor' then
                local v29 = next
                local v30, v31 = workspace.CurrentRooms:GetChildren()
                local __continue_break_1 = false

                for _, v32 in v29, v30, v31 do
                    if v26:IsDescendantOf(v32) then
                        if table.find(u9, v32) then
                        else
                            u9[#u9 + 1] = v32

                            task.spawn(p8.Debug.OnEntityEnteredRoom, v32)

                            if p8.Config.BreakLights then
                                u4.ModuleEvents.shatter(v32)
                            end

                            break
                        end
                    end
                end
            end

            local _CamShake = p8.Config.CamShake
            local _Magnitude2 = (getPlayerRoot().Position - u8.PrimaryPart.Position).Magnitude

            if _CamShake[1] and _Magnitude2 <= _CamShake[3] then
                local v33 = {}

                for v34, v35 in next, _CamShake[2]do
                    v33[v34] = v35
                end

                v33[1] = _CamShake[2][1] / _CamShake[3] * (_CamShake[3] - _Magnitude2)

                u4.MainGame.camShaker.ShakeOnce(u4.MainGame.camShaker, table.unpack(v33))
            end
            if v28 then
                local _, v36 = _WorldToViewportPoint(_CurrentCamera, u8.PrimaryPart.Position)

                if v36 then
                    task.spawn(p8.Debug.OnLookAtEntity)
                end
                if p8.Config.CanKill and not u:GetAttribute('IsDead') and (not u:GetAttribute('Invincible') and (not u:GetAttribute('Hiding') and (getPlayerRoot().Position - u8.PrimaryPart.Position).Magnitude <= p8.Config.KillRange)) then
                    task.spawn(function()
                        u:SetAttribute('IsDead', true)
                        warn('mute entity')

                        local v37 = next
                        local v38, v39 = u8:GetDescendants()

                        for _, v40 in v37, v38, v39 do
                            if v40.ClassName == 'Sound' then
                                if v40.Playing then
                                    v40:Stop()
                                end
                            end
                        end

                        if p8.Config.Jumpscare[1] then
                            u6.runJumpscare(p8.Config.Jumpscare[2])
                        end

                        task.spawn(p8.Debug.OnDeath)

                        u1.Health = 0
                        _ReplicatedStorage.GameStats['Player_' .. _LocalPlayer.Name].Total.DeathCause.Value = u8.Name

                        if #p8.Config.CustomDialog > 0 then
                            firesignal(_ReplicatedStorage.Bricks.DeathHint.OnClientEvent, p8.Config.CustomDialog)
                        end

                        task.spawn(function()
                            repeat
                                task.wait()
                            until _LocalPlayer.PlayerGui.MainUI.DeathPanelDead.Visible

                            warn('unmute entity:', u8)

                            local v41 = next
                            local v42, v43 = u8:GetDescendants()

                            for _, v44 in v41, v42, v43 do
                                if v44.ClassName == 'Sound' then
                                    local _Volume = v44.Volume

                                    v44.Volume = 0

                                    v44:Play()
                                    _TweenService:Create(v44, TweenInfo.new(2), {Volume = _Volume}):Play()
                                end
                            end
                        end)
                    end)
                end
            end
        end
    end)

    task.spawn(p8.Debug.OnEntityStartMoving)

    local _Cycles = p8.Config.Cycles
    local v45

    if p8.Config.BackwardsMovement then
        v45 = {}

        for v46 = #v14, 1, -1 do
            v45[#v45 + 1] = v14[v46]
        end
    else
        v45 = v14
    end

    for v47 = 1, math.max(math.random(_Cycles.Min, _Cycles.Max), 1)do
        local _ = v47

        for v48 = 1, #v45 do
            dragEntity(u8, v45[v48].Position + Vector3.new(0, 3.5 + p8.Config.HeightOffset, 0), p8.Config.Speed)
        end

        if _Cycles.Max > 1 then
            for v49 = #v45, 1, -1 do
                dragEntity(u8, v45[v49].Position + Vector3.new(0, 3.5 + p8.Config.HeightOffset, 0), p8.Config.Speed)
            end
        end

        task.spawn(p8.Debug.OnEntityFinishedRebound)

        if v47 < _Cycles.Max then
            task.wait(_Cycles.WaitTime)
        end
    end

    if not u8:GetAttribute('NoAI') then
        for _, v50 in next, v20 do
            v50:Disconnect()
        end

        u8:Destroy()
        task.spawn(p8.Debug.OnEntityDespawned)
    end
end
u6.runJumpscare = function(p11)
    local v51 = LoadCustomAsset(p11.Image1)
    local v52 = LoadCustomAsset(p11.Image2)
    local v53 = nil
    local v54

    if p11.Sound1 then
        v54 = loadSound(p11.Sound1)
    else
        v54 = nil
    end
    if p11.Sound2 then
        v53 = loadSound(p11.Sound2)
    end

    local _ScreenGui = Instance.new('ScreenGui')
    local _Frame = Instance.new('Frame')
    local _ImageLabel = Instance.new('ImageLabel')

    _ScreenGui.Name = 'JumpscareGui'
    _ScreenGui.IgnoreGuiInset = true
    _ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _Frame.Name = 'Background'
    _Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _Frame.BorderSizePixel = 0
    _Frame.Size = UDim2.new(1, 0, 1, 0)
    _Frame.ZIndex = 999
    _ImageLabel.Name = 'Face'
    _ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    _ImageLabel.BackgroundTransparency = 1
    _ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    _ImageLabel.ResampleMode = Enum.ResamplerMode.Pixelated
    _ImageLabel.Size = UDim2.new(0, 150, 0, 150)
    _ImageLabel.Image = v51
    _ImageLabel.Parent = _Frame
    _Frame.Parent = _ScreenGui
    _ScreenGui.Parent = _CoreGui

    local _Tease = p11.Tease
    local _Y = _ScreenGui.AbsoluteSize.Y
    local v55 = _Y / 5
    local v56 = _Y / 2.5

    if _Tease[1] then
        local v57 = math.random(_Tease.Min, _Tease.Max)

        v54:Play()

        for _ = _Tease.Min, v57 do
            task.wait(math.random(100, 200) / 100)

            local v58 = (v56 - v55) / v57

            _ImageLabel.Size = UDim2.new(0, _ImageLabel.AbsoluteSize.X + v58, 0, _ImageLabel.AbsoluteSize.Y + v58)
        end

        task.wait(math.random(100, 200) / 100)
    end
    if p11.Flashing[1] then
        task.spawn(function()
            while _ScreenGui.Parent do
                _Frame.BackgroundColor3 = p11.Flashing[2]

                task.wait(math.random(25, 100) / 1000)

                _Frame.BackgroundColor3 = Color3.new(0, 0, 0)

                task.wait(math.random(25, 100) / 1000)
            end
        end)
    end
    if p11.Shake then
        task.spawn(function()
            local _Position4 = _ImageLabel.Position

            while _ScreenGui.Parent do
                _ImageLabel.Position = _Position4 + UDim2.new(0, math.random(-10, 10), 0, math.random(-10, 10))
                _ImageLabel.Rotation = math.random(-5, 5)

                task.wait()
            end
        end)
    end

    _ImageLabel.Image = v52
    _ImageLabel.Size = UDim2.new(0, v56, 0, v56)

    v53:Play()
    _TweenService:Create(_ImageLabel, TweenInfo.new(0.75), {
        Size = UDim2.new(0, _Y * 3, 0, _Y * 3),
        ImageTransparency = 0.5,
    }):Play()
    task.wait(0.75)
    _ScreenGui:Destroy()

    if v54 then
        v54:Destroy()
    end
    if v53 then
        v53:Destroy()
    end
end

_LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if not SpawnerSetup then
    getgenv().SpawnerSetup = true

    workspace.DescendantRemoving:Connect(function(p12)
        if p12.Name == 'PathfindNodes' then
            p12:Clone().Parent = p12.Parent
        end
    end)
end

local v59 = u6.createEntity({
    CustomName = 'A-150',
    Model = 'https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/A150.rbxm?raw=true',
    Speed = 50,
    DelayTime = 2,
    HeightOffset = 0,
    CanKill = false,
    KillRange = 40,
    BackwardsMovement = false,
    BreakLights = true,
    FlickerLights = {false, 1},
    Cycles = {
        Min = 1,
        Max = 2,
        WaitTime = 2,
    },
    CamShake = {
        true,
        {
            3.5,
            20,
            0.1,
            1,
        },
        100,
    },
    Jumpscare = {
        false,
        {
            Image1 = 'rbxassetid://10483855823',
            Image2 = 'rbxassetid://10483999903',
            Shake = true,
            Sound1 = {
                10483790459,
                {Volume = 0.5},
            },
            Sound2 = {
                10483837590,
                {Volume = 0.5},
            },
            Flashing = {
                true,
                Color3.fromRGB(255, 255, 255),
            },
            Tease = {
                Min = 1,
                Max = 3,
                false,
            },
        },
    },
    CustomDialog = {
        'uhh...',
    },
})

v59.Debug.OnEntitySpawned = function() end
v59.Debug.OnEntityDespawned = function() end
v59.Debug.OnEntityStartMoving = function() end
v59.Debug.OnEntityFinishedRebound = function() end
v59.Debug.OnEntityEnteredRoom = function(_) end
v59.Debug.OnLookAtEntity = function() end
v59.Debug.OnDeath = function() end

u6.runEntity(v59)
