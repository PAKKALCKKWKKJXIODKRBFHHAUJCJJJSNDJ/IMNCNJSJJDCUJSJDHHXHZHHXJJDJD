local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LPlayer = Players.LocalPlayer
local Char = LPlayer.Character or LPlayer.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local SpeedMultiplier = 60 / 100

local DefaultConfig = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/lelele78/ProtectSecurity.18/refs/heads/main/DefautConfig"
))()

local Functions = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"
))()

local ModuleEvents = require(ReplicatedStorage.ModulesClient.Module_Events)
local MainGame = require(LPlayer.PlayerGui.MainUI.Initiator.Main_Game)

local EntityConnections = {}
local EntityModule = {}

--------------------------------------------------
--// Character
--------------------------------------------------

LPlayer.CharacterAdded:Connect(function(NewChar)
	Char = NewChar
	Hum = Char:WaitForChild("Humanoid")
end)

local function GetPlayerRoot()
	if not Char or not Char.Parent then
		return nil
	end

	return Char:FindFirstChild("HumanoidRootPart")
		or Char:FindFirstChild("Head")
end

--------------------------------------------------
--// Model loader
--------------------------------------------------

local function LoadModel(ModelId)
	if typeof(ModelId) == "Instance" then
		if ModelId:IsA("Model") then
			return ModelId
		end

		return nil
	end

	if typeof(ModelId) ~= "string" then
		return nil
	end

	local Success, Result = pcall(function()
		return game:GetObjects(ModelId)
	end)

	if not Success or not Result then
		warn("Smiler: failed to load model:", Result)
		return nil
	end

	for _, Obj in ipairs(Result) do
		if Obj:IsA("Model") then
			return Obj
		end
	end

	return nil
end

--------------------------------------------------
--// Movement
--------------------------------------------------

local function DragEntity(Entity, TargetPosition, Speed)
	local Data = EntityConnections[Entity]

	if not Data then
		return
	end

	if Data.movementNode then
		Data.movementNode:Disconnect()
		Data.movementNode = nil
	end

	if not Entity.Parent or not Entity.PrimaryPart then
		return
	end

	local Finished = false

	Data.movementNode = RunService.Stepped:Connect(function(_, Delta)
		if not Entity.Parent
			or Entity:GetAttribute("NoAI")
			or not Entity.PrimaryPart then

			Finished = true

			if Data.movementNode then
				Data.movementNode:Disconnect()
				Data.movementNode = nil
			end

			return
		end

		local CurrentPosition = Entity.PrimaryPart.Position
		local Difference = TargetPosition - CurrentPosition

		if Difference.Magnitude <= 0.1 then
			Finished = true

			if Data.movementNode then
				Data.movementNode:Disconnect()
				Data.movementNode = nil
			end

			return
		end

		local Step = math.min(Delta * Speed, Difference.Magnitude)

		Entity:SetPrimaryPartCFrame(
			CFrame.new(CurrentPosition + Difference.Unit * Step)
		)
	end)

	repeat
		task.wait()
	until Finished
		or not Entity.Parent
		or not Data.movementNode
end

--------------------------------------------------
--// Sound
--------------------------------------------------

local function LoadSound(Config)
	if not Config then
		return nil
	end

	local Sound = Instance.new("Sound")

	local SoundId = tostring(Config[1])
	local Properties = Config[2] or {}

	for Property, Value in pairs(Properties) do
		if Property ~= "SoundId" and Property ~= "Parent" then
			pcall(function()
				Sound[Property] = Value
			end)
		end
	end

	if SoundId:find("rbxasset://") then
		Sound.SoundId = SoundId
	else
		Sound.SoundId = "rbxassetid://" .. SoundId:gsub("%D", "")
	end

	Sound.Parent = workspace

	return Sound
end

--------------------------------------------------
--// Entity creation
--------------------------------------------------

function EntityModule.createEntity(Config)
	for Name, Value in pairs(DefaultConfig) do
		if Config[Name] == nil then
			Config[Name] = Value
		end
	end

	Config.Speed = SpeedMultiplier * Config.Speed

	-- Load model directly from Roblox asset ID
	local Model = LoadModel(Config.Model)

	if not Model then
		warn("Smiler: unable to load entity model:", Config.Model)
		return nil
	end

	Model.PrimaryPart =
		Model.PrimaryPart
		or Model:FindFirstChildWhichIsA("BasePart", true)

	if not Model.PrimaryPart then
		warn("Smiler: entity model has no BasePart:", Config.CustomName)
		Model:Destroy()
		return nil
	end

	Model.PrimaryPart.Anchored = true

	if Config.CustomName then
		Model.Name = Config.CustomName
	end

	Model:SetAttribute("IsCustomEntity", true)
	Model:SetAttribute("NoAI", false)

	return {
		Model = Model,
		Config = Config,

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

--------------------------------------------------
--// Crucifix sound
--------------------------------------------------

local function GitAud(SoundUrl, FileName)
	FileName = tostring(FileName)

	local File = FileName .. ".mp3"

	if not isfile(File) then
		local Success, Data = pcall(function()
			return game:HttpGet(SoundUrl)
		end)

		if not Success then
			warn("Smiler: failed to download sound:", Data)
			return nil
		end

		writefile(File, Data)
	end

	local AssetFunction = getcustomasset or getsynasset

	if not AssetFunction then
		return nil
	end

	local Success, Asset = pcall(function()
		return AssetFunction(File)
	end)

	if not Success then
		warn("Smiler: failed to load sound asset:", Asset)
		return nil
	end

	return Asset
end

local function CustomGitSound(SoundUrl, Volume, FileName)
	local SoundId = GitAud(SoundUrl, FileName)

	if not SoundId then
		return
	end

	local Sound = Instance.new("Sound")
	Sound.SoundId = SoundId
	Sound.Volume = Volume or 1
	Sound.Looped = false
	Sound.Parent = workspace
	Sound:Play()

	Sound.Ended:Connect(function()
		Sound:Destroy()
	end)

	return Sound
end

--------------------------------------------------
--// Run entity
--------------------------------------------------

function EntityModule.runEntity(Entity)
    if not Entity or not Entity.Model then
        warn("Smiler: Entity is invalid")
        return
    end

    local CurrentRooms = workspace:FindFirstChild("CurrentRooms")
    if not CurrentRooms then
        warn("Smiler: workspace.CurrentRooms not found")
        return
    end

    local Nodes = {}

    local function AddPart(Part)
        if Part and Part:IsA("BasePart") then
            table.insert(Nodes, Part)
        end
    end

    local function GetNumber(Name)
        return tonumber(Name)
    end

    local Rooms = CurrentRooms:GetChildren()

    table.sort(Rooms, function(A, B)
        local ANumber = GetNumber(A.Name)
        local BNumber = GetNumber(B.Name)

        if ANumber and BNumber then
            return ANumber < BNumber
        elseif ANumber then
            return true
        elseif BNumber then
            return false
        end

        return A.Name < B.Name
    end)

    for _, Room in ipairs(Rooms) do
        if Room:IsA("Model") then

            local Entrance = Room:FindFirstChild("RoomEntrance")
            AddPart(Entrance)

            local NodeFolder =
                Room:FindFirstChild("PathfindNodes")
                or Room:FindFirstChild("Nodes")

            if NodeFolder then
                local RoomNodes = {}

                for _, Node in ipairs(NodeFolder:GetChildren()) do
                    if Node:IsA("BasePart") then
                        table.insert(RoomNodes, Node)
                    end
                end

                table.sort(RoomNodes, function(A, B)
                    local ANumber = GetNumber(A.Name)
                    local BNumber = GetNumber(B.Name)

                    if ANumber and BNumber then
                        return ANumber < BNumber
                    elseif ANumber then
                        return true
                    elseif BNumber then
                        return false
                    end

                    return A.Name < B.Name
                end)

                for _, Node in ipairs(RoomNodes) do
                    table.insert(Nodes, Node)
                end
            end

            local Exit = Room:FindFirstChild("RoomExit")
            AddPart(Exit)
        end
    end

    if #Nodes == 0 then
        warn("Smiler: no movement points found")
        return
    end

    local EntityModel = Entity.Model:Clone()

    EntityModel.PrimaryPart =
        EntityModel.PrimaryPart
        or EntityModel:FindFirstChildWhichIsA("BasePart", true)

    if not EntityModel.PrimaryPart then
        warn("Smiler: cloned model has no PrimaryPart")
        EntityModel:Destroy()
        return
    end

    EntityModel.PrimaryPart.Anchored = true
    EntityModel:SetAttribute("NoAI", false)

    EntityConnections[EntityModel] = {}
    local Data = EntityConnections[EntityModel]

    local function GetTargetCFrame(Part)
        return Part.CFrame
            + Vector3.new(
                0,
                3.5 + (Entity.Config.HeightOffset or 0),
                0
            )
    end

    local SpawnIndex

    if Entity.Config.BackwardsMovement then
        SpawnIndex = #Nodes
    else
        SpawnIndex = 1
    end

    local SpawnNode = Nodes[SpawnIndex]

    if not SpawnNode then
        warn("Smiler: SpawnNode is nil")
        EntityConnections[EntityModel] = nil
        EntityModel:Destroy()
        return
    end

    EntityModel:PivotTo(GetTargetCFrame(SpawnNode))
    EntityModel.Parent = workspace

    task.spawn(Entity.Debug.OnEntitySpawned)

    local MainUI = LPlayer.PlayerGui:FindFirstChild("MainUI")
    local Death = MainUI and MainUI:FindFirstChild("Death")
    local DeathPanelDead = MainUI and MainUI:FindFirstChild("DeathPanelDead")

    if CoreGui:FindFirstChild("JumpscareGui")
        or (
            Death
            and Death:FindFirstChild("HelpfulDialogue")
            and Death.HelpfulDialogue.Visible
            and DeathPanelDead
            and not DeathPanelDead.Visible
        ) then

        for _, Obj in ipairs(EntityModel:GetDescendants()) do
            if Obj:IsA("Sound") and Obj.Playing then
                Obj:Stop()
            end
        end
    end

    local FlickerConfig = Entity.Config.FlickerLights

    if FlickerConfig and FlickerConfig[1] then
        local RemotesFolder = ReplicatedStorage:FindFirstChild("RemotesFolder")
        local Event = RemotesFolder and RemotesFolder:FindFirstChild("UseEventModule")

        if Event then
            pcall(function()
                firesignal(
                    Event.OnClientEvent,
                    "flicker",
                    ReplicatedStorage.GameData.LatestRoom.Value,
                    FlickerConfig[2]
                )
            end)
        end
    end

    task.wait(Entity.Config.DelayTime or 0)

    local EnteredRooms = {}

    Data.movementTick = RunService.Stepped:Connect(function()
        if not EntityModel.Parent
            or EntityModel:GetAttribute("NoAI")
            or not EntityModel.PrimaryPart then
            return
        end

        local HRP = GetPlayerRoot()
        if not HRP then
            return
        end

        local EntityPosition = EntityModel.PrimaryPart.Position
        local PlayerPosition = HRP.Position

        local Ignore = {
            EntityModel,
            Char
        }

        local FloorHit = workspace:FindPartOnRayWithIgnoreList(
            Ray.new(
                EntityPosition,
                Vector3.new(0, -10, 0)
            ),
            Ignore
        )

        local PlayerRayHit = workspace:FindPartOnRayWithIgnoreList(
            Ray.new(
                EntityPosition,
                PlayerPosition - EntityPosition
            ),
            Ignore
        )

        local CanSeePlayer = PlayerRayHit == nil

        if FloorHit and FloorHit.Name == "Floor" then
            for _, Room in ipairs(CurrentRooms:GetChildren()) do
                if FloorHit:IsDescendantOf(Room)
                    and not table.find(EnteredRooms, Room) then

                    table.insert(EnteredRooms, Room)

                    task.spawn(
                        Entity.Debug.OnEntityEnteredRoom,
                        Room
                    )

                    if Entity.Config.BreakLights then
                        local RemotesFolder =
                            ReplicatedStorage:FindFirstChild("RemotesFolder")

                        local Event =
                            RemotesFolder
                            and RemotesFolder:FindFirstChild("UseEventModule")

                        if Event then
                            pcall(function()
                                firesignal(
                                    Event.OnClientEvent,
                                    "shatter",
                                    Room
                                )
                            end)
                        end
                    end

                    break
                end
            end
        end

        local CamShake = Entity.Config.CamShake

        if CamShake
            and CamShake[1]
            and EntityModel.PrimaryPart then

            local Distance =
                (PlayerPosition - EntityModel.PrimaryPart.Position).Magnitude

            if Distance <= CamShake[3] then
                local ShakeData = table.clone(CamShake[2])

                ShakeData[1] =
                    CamShake[2][1]
                    / CamShake[3]
                    * (CamShake[3] - Distance)

                pcall(function()
                    MainGame.camShaker:ShakeOnce(
                        table.unpack(ShakeData)
                    )
                end)
            end
        end

        if CanSeePlayer then
            local Crucifix = Char and Char:FindFirstChild("Crucifix")

            if Crucifix then
                EntityModel:SetAttribute("NoAI", true)

                local Handle = Crucifix:FindFirstChild("Handle")

                if Handle then
                    local CrucifixClone = Handle:Clone()

                    Crucifix:Destroy()

                    CrucifixClone.Parent = workspace
                    CrucifixClone.Name = "cruxy"
                    CrucifixClone.Anchored = true
                    CrucifixClone.Color = Color3.fromRGB(255, 86, 86)
                    CrucifixClone.Material = Enum.Material.Neon

                    TweenService:Create(
                        CrucifixClone,
                        TweenInfo.new(5),
                        {
                            Transparency = 1
                        }
                    ):Play()

                    CustomGitSound(
                        "https://raw.githubusercontent.com/Voor-Pr00/Eye/refs/heads/main/DOORS-UNUSED-SOUNDTRACK-Stress%20(mp3cut.net).mp3",
                        1,
                        "crucifix"
                    )

                    pcall(function()
                        MainGame.camShaker:ShakeOnce(
                            200,
                            5,
                            0.1,
                            0.15
                        )
                    end)

                    local CrucifixModel =
                        Functions.LoadCustomInstance(
                            "https://raw.githubusercontent.com/VoorPhale012/Crucifix/refs/heads/main/pentagam.rbxm?raw=true"
                        )

                    if CrucifixModel then
                        CrucifixModel.Parent = workspace

                        local Smiler =
                            workspace:FindFirstChild("Smiler")
                            or EntityModel

                        local SmilerNew =
                            Smiler
                            and Smiler:FindFirstChild(
                                "SmilerNew",
                                true
                            )

                        if CrucifixModel:IsA("Model")
                            and SmilerNew then

                            local CrucifixEntity =
                                CrucifixModel:FindFirstChild(
                                    "Entity",
                                    true
                                )

                            if CrucifixEntity
                                and CrucifixEntity:IsA("BasePart") then

                                CrucifixModel:PivotTo(
                                    SmilerNew.CFrame
                                    - Vector3.new(
                                        0,
                                        Entity.Config.HeightOffset or 0,
                                        0
                                    )
                                    - Vector3.new(0, 3, 0)
                                )

                                local SmilerClone =
                                    Smiler:Clone()

                                SmilerClone.Parent = workspace
                                SmilerClone.Name = "SmilerClone"

                                local CloneSmilerNew =
                                    SmilerClone:FindFirstChild(
                                        "SmilerNew",
                                        true
                                    )

                                if CloneSmilerNew then
                                    CrucifixEntity.CFrame =
                                        CloneSmilerNew.CFrame
                                end

                                EntityModel:Destroy()

                                if Smiler ~= EntityModel then
                                    Smiler:Destroy()
                                end

                                local BeamColor =
                                    ColorSequence.new({
                                        ColorSequenceKeypoint.new(
                                            0,
                                            Color3.new(
                                                0.4549,
                                                0,
                                                0
                                            )
                                        ),
                                        ColorSequenceKeypoint.new(
                                            1,
                                            Color3.new(
                                                0.4549,
                                                0,
                                                0
                                            )
                                        )
                                    })

                                for _, Obj in ipairs(
                                    CrucifixModel:GetDescendants()
                                ) do
                                    if Obj:IsA("Beam") then
                                        Obj.Color = BeamColor
                                    end
                                end

                                local Circle =
                                    CrucifixModel:FindFirstChild(
                                        "Circle",
                                        true
                                    )

                                if Circle then
                                    local Lines =
                                        Circle:FindFirstChild("Lines")

                                    local Spark =
                                        Circle:FindFirstChild("Spark")

                                    if Lines
                                        and Lines:IsA("Beam") then
                                        Lines.Color = BeamColor
                                    end

                                    if Spark
                                        and Spark:IsA("Beam") then
                                        Spark.Color = BeamColor
                                    end
                                end

                                local StartPosition =
                                    CloneSmilerNew.Position
                                    + Vector3.new(0, 3, 0)

                                local EndPosition =
                                    CloneSmilerNew.Position
                                    - Vector3.new(0, 18, 0)

                                TweenService:Create(
                                    CloneSmilerNew,
                                    TweenInfo.new(2),
                                    {
                                        Position = StartPosition
                                    }
                                ):Play()

                                TweenService:Create(
                                    CrucifixEntity,
                                    TweenInfo.new(2),
                                    {
                                        Position = StartPosition
                                    }
                                ):Play()

                                task.wait(2)

                                for _, Obj in ipairs(
                                    CloneSmilerNew:GetDescendants()
                                ) do
                                    if Obj:IsA("Sound") then
                                        TweenService:Create(
                                            Obj,
                                            TweenInfo.new(3),
                                            {
                                                Volume = 0
                                            }
                                        ):Play()
                                    end
                                end

                                TweenService:Create(
                                    CloneSmilerNew,
                                    TweenInfo.new(3),
                                    {
                                        Position = EndPosition
                                    }
                                ):Play()

                                TweenService:Create(
                                    CrucifixEntity,
                                    TweenInfo.new(3),
                                    {
                                        Position = EndPosition
                                    }
                                ):Play()

                                task.wait(4)

                                if SmilerClone then
                                    SmilerClone:Destroy()
                                end

                                if CrucifixClone then
                                    CrucifixClone:Destroy()
                                end

                                if CrucifixModel then
                                    CrucifixModel:Destroy()
                                end

                                pcall(function()
                                    local AchievementGiver =
                                        loadstring(
                                            game:HttpGet(
                                                "https://raw.githubusercontent.com/Voor-Pr00/Achivements/refs/heads/main/Voorpr0"
                                            )
                                        )()

                                    AchievementGiver({
                                        Title = "You put a smile on my face",
                                        Desc = "You're annoying.",
                                        Reason = "Used Crucifix on 'Smiler'",
                                        Image = "rbxassetid://11417375410"
                                    })
                                end)
                            end
                        end
                    end
                end
            end
        end

        if EntityModel.Parent
            and EntityModel.PrimaryPart then

            local _, OnScreen =
                Camera:WorldToViewportPoint(
                    EntityModel.PrimaryPart.Position
                )

            if OnScreen then
                task.spawn(Entity.Debug.OnLookAtEntity)
            end
        end

        if Entity.Config.CanKill
            and not Char:GetAttribute("IsDead")
            and not Char:GetAttribute("Invincible")
            and not Char:GetAttribute("Hiding")
            and EntityModel.Parent
            and EntityModel.PrimaryPart then

            local Distance =
                (
                    PlayerPosition
                    - EntityModel.PrimaryPart.Position
                ).Magnitude

            if Distance <= Entity.Config.KillRange then
                task.spawn(function()
                    if Char:GetAttribute("IsDead") then
                        return
                    end

                    Char:SetAttribute("IsDead", true)

                    for _, Obj in ipairs(
                        EntityModel:GetDescendants()
                    ) do
                        if Obj:IsA("Sound")
                            and Obj.Playing then
                            Obj:Stop()
                        end
                    end

                    if Entity.Config.Jumpscare
                        and Entity.Config.Jumpscare[1] then
                        EntityModule.runJumpscare(
                            Entity.Config.Jumpscare[2]
                        )
                    end

                    task.spawn(Entity.Debug.OnDeath)

                    if Hum then
                        Hum.Health = 0
                    end

                    pcall(function()
                        ReplicatedStorage.GameStats[
                            "Player_" .. LPlayer.Name
                        ].Total.DeathCause.Value =
                            EntityModel.Name
                    end)

                    task.spawn(function()
                        if not MainUI
                            or not MainUI:FindFirstChild(
                                "DeathPanelDead"
                            ) then
                            return
                        end

                        repeat
                            task.wait()
                        until MainUI.DeathPanelDead.Visible
                            or not EntityModel.Parent

                        if not EntityModel.Parent then
                            return
                        end

                        for _, Obj in ipairs(
                            EntityModel:GetDescendants()
                        ) do
                            if Obj:IsA("Sound") then
                                local OldVolume = Obj.Volume

                                Obj.Volume = 0
                                Obj:Play()

                                TweenService:Create(
                                    Obj,
                                    TweenInfo.new(2),
                                    {
                                        Volume = OldVolume
                                    }
                                ):Play()
                            end
                        end
                    end)
                end)
            end
        end
    end)

    task.spawn(Entity.Debug.OnEntityStartMoving)

    local Cycles = Entity.Config.Cycles or {
        Min = 1,
        Max = 1,
        WaitTime = 0
    }

    local CycleCount = math.max(
        math.random(
            Cycles.Min or 1,
            Cycles.Max or 1
        ),
        1
    )

    local MovementNodes = {}

    if Entity.Config.BackwardsMovement then
        for i = #Nodes, 1, -1 do
            table.insert(MovementNodes, Nodes[i])
        end
    else
        for i = 1, #Nodes do
            table.insert(MovementNodes, Nodes[i])
        end
    end

    for Cycle = 1, CycleCount do
        if not EntityModel.Parent
            or EntityModel:GetAttribute("NoAI") then
            break
        end

        for _, Node in ipairs(MovementNodes) do
            if not EntityModel.Parent
                or EntityModel:GetAttribute("NoAI") then
                break
            end

            if Node and Node:IsA("BasePart") then
                DragEntity(
                    EntityModel,
                    GetTargetCFrame(Node).Position,
                    Entity.Config.Speed
                )
            end
        end

        if (Cycles.Max or 1) > 1 then
            for i = #MovementNodes, 1, -1 do
                if not EntityModel.Parent
                    or EntityModel:GetAttribute("NoAI") then
                    break
                end

                local Node = MovementNodes[i]

                if Node and Node:IsA("BasePart") then
                    DragEntity(
                        EntityModel,
                        GetTargetCFrame(Node).Position,
                        Entity.Config.Speed
                    )
                end
            end
        end

        task.spawn(Entity.Debug.OnEntityFinishedRebound)

        if Cycle < CycleCount then
            task.wait(Cycles.WaitTime or 0)
        end
    end

    if Data.movementTick then
        Data.movementTick:Disconnect()
        Data.movementTick = nil
    end

    if Data.movementNode then
        Data.movementNode:Disconnect()
        Data.movementNode = nil
    end

    EntityConnections[EntityModel] = nil

    if EntityModel.Parent then
        EntityModel:Destroy()
    end

    task.spawn(Entity.Debug.OnEntityDespawned)
end

--------------------------------------------------
--// Jumpscare
--------------------------------------------------

function EntityModule.runJumpscare(Config)
	if not Config then
		return
	end

	local Image1

	local Success1, Result1 = pcall(function()
		return LoadCustomAsset(Config.Image1)
	end)

	if Success1 then
		Image1 = Result1
	end

	local Image2

	local Success2, Result2 = pcall(function()
		return LoadCustomAsset(Config.Image2)
	end)

	if Success2 then
		Image2 = Result2
	end

	local Sound1

	if Config.Sound1 then
		Sound1 = LoadSound(Config.Sound1)
	end

	local Sound2

	if Config.Sound2 then
		Sound2 = LoadSound(Config.Sound2)
	end

	local Gui = Instance.new("ScreenGui")
	local Background = Instance.new("Frame")
	local Face = Instance.new("ImageLabel")

	Gui.Name = "JumpscareGui"
	Gui.IgnoreGuiInset = true
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Background.Name = "Background"
	Background.BackgroundColor3 = Color3.new(0, 0, 0)
	Background.BorderSizePixel = 0
	Background.Size = UDim2.fromScale(1, 1)
	Background.ZIndex = 999

	Face.Name = "Face"
	Face.AnchorPoint = Vector2.new(0.5, 0.5)
	Face.BackgroundTransparency = 1
	Face.Position = UDim2.fromScale(0.5, 0.5)
	Face.ResampleMode = Enum.ResamplerMode.Pixelated
	Face.Size = UDim2.fromOffset(150, 150)

	if Image1 then
		Face.Image = Image1
	end

	Face.Parent = Background
	Background.Parent = Gui
	Gui.Parent = CoreGui

	local Tease = Config.Tease or {
		Min = 1,
		Max = 1,
		[1] = false
	}

	local ScreenHeight = Gui.AbsoluteSize.Y

	if ScreenHeight <= 0 then
		ScreenHeight = Camera.ViewportSize.Y
	end

	local SmallSize = ScreenHeight / 5
	local LargeSize = ScreenHeight / 2.5

	if Tease[1] and Sound1 then
		local TeaseAmount = math.random(
			Tease.Min or 1,
			Tease.Max or 1
		)

		Sound1:Play()

		for _ = 1, TeaseAmount do
			task.wait(
				math.random(100, 200) / 100
			)

			local Difference =
				(LargeSize - SmallSize)
				/ math.max(TeaseAmount, 1)

			Face.Size = UDim2.fromOffset(
				Face.AbsoluteSize.X + Difference,
				Face.AbsoluteSize.Y + Difference
			)
		end

		task.wait(
			math.random(100, 200) / 100
		)
	end

	--------------------------------------------------
	--// Flashing
	--------------------------------------------------

	if Config.Flashing and Config.Flashing[1] then
		task.spawn(function()
			while Gui.Parent do
				Background.BackgroundColor3 =
					Config.Flashing[2]

				task.wait(
					math.random(25, 100) / 1000
				)

				if not Gui.Parent then
					break
				end

				Background.BackgroundColor3 =
					Color3.new(0, 0, 0)

				task.wait(
					math.random(25, 100) / 1000
				)
			end
		end)
	end

	--------------------------------------------------
	--// Shake
	--------------------------------------------------

	if Config.Shake then
		task.spawn(function()
			local OriginalPosition = Face.Position

			while Gui.Parent do
				Face.Position =
					OriginalPosition
					+ UDim2.fromOffset(
						math.random(-10, 10),
						math.random(-10, 10)
					)

				Face.Rotation =
					math.random(-5, 5)

				task.wait()
			end
		end)
	end

	if Image2 then
		Face.Image = Image2
	end

	Face.Size = UDim2.fromOffset(
		LargeSize,
		LargeSize
	)

	if Sound2 then
		Sound2:Play()
	end

	TweenService:Create(
		Face,
		TweenInfo.new(0.75),
		{
			Size = UDim2.fromOffset(
				ScreenHeight * 3,
				ScreenHeight * 3
			),

			ImageTransparency = 0.5
		}
	):Play()

	task.wait(0.75)

	if Gui then
		Gui:Destroy()
	end

	if Sound1 then
		Sound1:Destroy()
	end

	if Sound2 then
		Sound2:Destroy()
	end
end

--------------------------------------------------
--// ChaseInSession
--------------------------------------------------

task.spawn(function()
	while true do
		local ChaseActive = false

		for _, Obj in ipairs(workspace:GetChildren()) do
			if Obj.Name == "RushMoving"
				or Obj.Name == "AmbushMoving"
				or Obj:GetAttribute("IsCustomEntity") then

				ChaseActive = true
				break
			end
		end

		pcall(function()
			ReplicatedStorage.GameData.ChaseInSession.Value =
				ChaseActive
		end)

		task.wait(0.5)
	end
end)

--------------------------------------------------
--// Smiler
--------------------------------------------------

local Smiler = EntityModule.createEntity({
	CustomName = "Smiler",

	--// Model ID loaded directly by game:GetObjects()
	Model = "rbxassetid://17071491370",

	Speed = 850,
	DelayTime = 14,
	HeightOffset = -2.5,

	CanKill = true,
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

		"It seems like u got access to an entity that isn't released yet.",

		"Please report to LSplash#1234 and Redibles#7070 if this happens again."
	}
})

if not Smiler then
	warn("Smiler: failed to create entity")
	return
end

function Smiler.Debug.OnEntitySpawned()
end

function Smiler.Debug.OnEntityDespawned()
end

function Smiler.Debug.OnEntityStartMoving()
end

function Smiler.Debug.OnEntityFinishedRebound()
end

function Smiler.Debug.OnEntityEnteredRoom(Room)
end

function Smiler.Debug.OnLookAtEntity()
end

function Smiler.Debug.OnDeath()
end

--------------------------------------------------
--// Run
--------------------------------------------------

EntityModule.runEntity(Smiler)
