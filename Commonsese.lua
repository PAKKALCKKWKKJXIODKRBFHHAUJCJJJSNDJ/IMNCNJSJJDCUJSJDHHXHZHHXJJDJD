local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CurrentRooms = workspace:WaitForChild("CurrentRooms")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local CONFIG = {
	MODEL_ID = "https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/Common_Sense2.rbxm",
	MODEL_FILE = "Common_Sense2.rbxm",

	CRUCIFIX_ID = "https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/pentafix.rbxm?raw=true",
	CRUCIFIX_FILE = "fgvcf",

	NAME = "CommonSense",
	DEATH = "CommonSense"
}

local SPAWN_ROOM = "50"
local TRIGGER_ROOM = "51"
local STOP_ROOM = "52"

local HITBOX_RADIUS = 9
local MOVE_SPEED = 20
local HEIGHT_OFFSET = 3

local entities = {}
local cachedNodes = {}
local spawned = false

local MainConnection
local Room50Connection

-- ================= MODEL CACHE =================
local function LoadAsset(url, file)
	if not isfile(file) then
		local success, data = pcall(function()
			return game:HttpGet(url)
		end)

		if not success or not data then
			return nil
		end

		writefile(file, data)
	end

	local success, obj = pcall(function()
		return game:GetObjects(getcustomasset(file))
	end)

	if success and obj and obj[1] then
		return obj[1]
	end

	return nil
end

local function LoadModel()
	return LoadAsset(CONFIG.MODEL_ID, CONFIG.MODEL_FILE)
end

local function LoadCrucifixEffect()
	return LoadAsset(CONFIG.CRUCIFIX_ID, CONFIG.CRUCIFIX_FILE)
end

-- ================= UTIL =================
local function HasRoom(name)
	return CurrentRooms:FindFirstChild(name) ~= nil
end

-- ================= NODE CACHE =================
local function CacheNodes()
	cachedNodes = {}

	for _, obj in ipairs(workspace.CurrentRooms:GetDescendants()) do
		if obj:IsA("Folder") and obj.Name == "FigureNodes" then

			for _, v in ipairs(obj:GetChildren()) do
				if v:IsA("BasePart") then
					table.insert(cachedNodes, v)
				end
			end

			table.sort(cachedNodes, function(a, b)
				local na = tonumber(a.Name:match("%d+")) or 0
				local nb = tonumber(b.Name:match("%d+")) or 0
				return na < nb
			end)

			break
		end
	end
end

task.spawn(function()
	while not spawned do
		task.wait(2)

		CacheNodes()

		if #cachedNodes > 0 then
			break
		end
	end
end)

-- ================= CRUCIFIX EFFECT =================
local function CrucifixEffect(ent)
	if not ent or not ent.model or not ent.model.Parent then
		return
	end

	if ent.crucified then
		return
	end

	ent.crucified = true
	ent.moving = false
	
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

	-- Disconnect toàn bộ connection của entity
	for _, connection in pairs(ent.connections) do
		if connection and connection.Connected then
			connection:Disconnect()
		end
	end

	table.clear(ent.connections)

	-- Disconnect heartbeat chính
	if MainConnection and MainConnection.Connected then
		MainConnection:Disconnect()
	end

	-- Disconnect room connection
	if Room50Connection and Room50Connection.Connected then
		Room50Connection:Disconnect()
	end

	-- ================= CRUCIFIX =================
	local crucifix = Character:FindFirstChild("Crucifix")
	local handle = crucifix and crucifix:FindFirstChild("Handle")

	if not handle then
		return
	end

	local cruxy = handle:Clone()

	crucifix:Destroy()

	cruxy.Parent = workspace
	cruxy.Name = "cruxy"
	cruxy.Anchored = true
	cruxy.Color = Color3.fromRGB(255, 255, 255)
	cruxy.Material = Enum.Material.Neon

	TweenService:Create(
		cruxy,
		TweenInfo.new(5),
		{
			Transparency = 1
		}
	):Play()

	-- ================= STRESS MUSIC =================

	-- ================= CAMERA SHAKE =================
	local MainGame =
		require(LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)

	MainGame.camShaker:ShakeOnce(
		200,
		5,
		0.1,
		0.15
	)

	-- ================= PENTAFIX =================
	local Pentafix = LoadCrucifixEffect()

	if not Pentafix then
		cruxy:Destroy()
		return
	end

	Pentafix.Parent = workspace

	local entityModel = ent.model

	if not entityModel or not entityModel.Parent then
		Pentafix:Destroy()
		cruxy:Destroy()
		return
	end

	local commonSenseNew = entityModel:FindFirstChild("CommonSenseNew", true)

	if not commonSenseNew then
		Pentafix:Destroy()
		cruxy:Destroy()
		return
	end

	-- Đặt pentafix tại vị trí entity hiện tại
	Pentafix:MoveTo(
		commonSenseNew.Position
		- Vector3.new(0, HEIGHT_OFFSET, 0)
		- Vector3.new(0, 3, 0)
	)

	-- Clone entity để làm animation crucifix
	local entityClone = entityModel:Clone()

	entityClone.Parent = workspace
	entityClone.Name = "CommonSenseClone"

	local cloneCommonSenseNew =
		entityClone:FindFirstChild("CommonSenseNew", true)

	local pentafixEntity =
		Pentafix:FindFirstChild("Entity", true)

	if not cloneCommonSenseNew or not pentafixEntity then
		entityClone:Destroy()
		Pentafix:Destroy()
		cruxy:Destroy()
		return
	end

	pentafixEntity.CFrame = cloneCommonSenseNew.CFrame

	-- Entity thật biến mất khỏi scene
	entityModel:Destroy()

	-- ================= BEAM COLOR =================
	local whiteColor = ColorSequence.new({
		ColorSequenceKeypoint.new(
			0,
			Color3.new(1, 1, 1)
		),

		ColorSequenceKeypoint.new(
			1,
			Color3.new(1, 1, 1)
		)
	})

	for _, obj in ipairs(Pentafix:GetDescendants()) do
		if obj:IsA("Beam") then
			obj.Color = whiteColor
		end
	end

	local Circle = Pentafix:FindFirstChild("Circle")

	if Circle then
		local Lines = Circle:FindFirstChild("Lines")
		local Spark = Circle:FindFirstChild("Spark")

		if Lines and Lines:IsA("Beam") then
			Lines.Color = whiteColor
		end

		if Spark and Spark:IsA("Beam") then
			Spark.Color = whiteColor
		end
	end

	-- ================= RISE =================
	local risePosition =
		cloneCommonSenseNew.Position
		+ Vector3.new(0, 3, 0)

	local fallPosition =
		cloneCommonSenseNew.Position
		- Vector3.new(0, 18, 0)

	local RiseInfo = TweenInfo.new(2)

	local RiseEntity = TweenService:Create(
		cloneCommonSenseNew,
		RiseInfo,
		{
			Position = risePosition
		}
	)

	local RisePentafix = TweenService:Create(
		pentafixEntity,
		RiseInfo,
		{
			Position = risePosition
		}
	)

	RiseEntity:Play()
	RisePentafix:Play()

	task.wait(2)

	-- ================= FADE SOUNDS =================
	for _, obj in ipairs(cloneCommonSenseNew:GetDescendants()) do
		if obj:IsA("Sound") then
			TweenService:Create(
				obj,
				TweenInfo.new(3),
				{
					Volume = 0
				}
			):Play()
		end
	end

	-- ================= FALL =================
	local FallInfo = TweenInfo.new(3)

	local FallEntity = TweenService:Create(
		cloneCommonSenseNew,
		FallInfo,
		{
			Position = fallPosition
		}
	)

	local FallPentafix = TweenService:Create(
		pentafixEntity,
		FallInfo,
		{
			Position = fallPosition
		}
	)

	FallEntity:Play()
	FallPentafix:Play()

	task.wait(4)

	-- ================= CLEANUP =================
	if entityClone then
		entityClone:Destroy()
	end

	if cruxy then
		cruxy:Destroy()
	end

	if Pentafix then
		Pentafix:Destroy()
	end

	-- ================= ACHIEVEMENT =================
	pcall(function()
		local DoorsNotify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guestly-Alt/Scripts/refs/heads/main/AchievementHolder.lua"))()

DoorsNotify({
    Style = "UNLOCKED ACHIEVEMENT",
    Title = "Im just using my common sense",
    Description = "Let me find the books alone. ",
    Reason = "Used Crucifix on ''Common Sense''",
    Image = "rbxassetid://11937659780",
    Time = 5
})
	end)

	-- ================= MUSIC FADE =================
end

-- ================= CHECK CRUCIFIX =================
local function CheckCrucifix(ent)
	if ent.crucified then
		return true
	end

	local crucifix = Character:FindFirstChild("Crucifix")

	if crucifix then
		CrucifixEffect(ent)
		return true
	end

	return false
end

-- ================= SPAWN =================
task.spawn(function()
	while true do
		task.wait(0.5)

		if not spawned and HasRoom(TRIGGER_ROOM) then
			task.wait(7)

			while #cachedNodes == 0 do
				task.wait()
			end

			local model = LoadModel()

			if model then
				model.Name = CONFIG.NAME
				model.Parent = workspace

				local room = CurrentRooms:FindFirstChild(SPAWN_ROOM)
				local spawnPoint = room and room:FindFirstChild("RoomExit")

RemoveLights(room)

				if spawnPoint then
					model:PivotTo(
						spawnPoint.CFrame
						+ Vector3.new(0, HEIGHT_OFFSET, 0)
					)
				end

				table.insert(entities, {
					model = model,
					nodeIndex = #cachedNodes,
					forward = false,
					progress = 0,
					startCF = nil,
					endCF = nil,
					moving = false,
					crucified = false,
					connections = {}
				})
			end

			spawned = true
			break
		end
	end
end)

-- ================= MOVE =================
local function MoveEntity(ent, dt)
	if ent.crucified then
		return
	end

	if not ent.model or not ent.model.Parent then
		return
	end

	if ent.nodeIndex < 1 or ent.nodeIndex > #cachedNodes then
		return
	end

	local node = cachedNodes[ent.nodeIndex]

	if not node then
		return
	end

	if not ent.moving then
		ent.startCF = ent.model:GetPivot()

		ent.endCF = CFrame.new(
			node.Position
			+ Vector3.new(0, HEIGHT_OFFSET, 0)
		)

		ent.progress = 0
		ent.moving = true
	end

	local dist =
		(ent.endCF.Position - ent.startCF.Position).Magnitude

	local time = math.max(
		dist / MOVE_SPEED,
		0.05
	)

	ent.progress += dt / time

	if ent.progress >= 1 then
		ent.model:PivotTo(ent.endCF)

		ent.nodeIndex -= 1
		ent.moving = false
	else
		ent.model:PivotTo(
			ent.startCF:Lerp(
				ent.endCF,
				ent.progress
			)
		)
	end
end

-- ================= INSTANT KILL =================
local function HookKill(ent)
	if ent.crucified then
		return
	end

	if not ent.model or not ent.model.Parent then
		return
	end

	local pos =
		ent.model:GetPivot().Position

	local radius2 =
		HITBOX_RADIUS * HITBOX_RADIUS

	for _, plr in ipairs(Players:GetPlayers()) do
		local char = plr.Character
		local hum =
			char and char:FindFirstChildOfClass("Humanoid")
		local hrp =
			char and char:FindFirstChild("HumanoidRootPart")

		if hum and hrp and hum.Health > 0 then
			local diff =
				hrp.Position - pos

			if diff:Dot(diff) <= radius2 then
				hum.Health = 0
				game.ReplicatedStorage.GameStats['Player_' .. game.Players.LocalPlayer.Name].Total.DeathCause.Value = 'Common Sense'
			end
		end
	end
end

-- ================= HEARTBEAT =================
MainConnection = RunService.Heartbeat:Connect(function(dt)

	if HasRoom(STOP_ROOM) then
		for _, ent in ipairs(entities) do
			if ent.model then
				ent.model:Destroy()
			end
		end

		table.clear(entities)

		if MainConnection and MainConnection.Connected then
			MainConnection:Disconnect()
		end

		return
	end

	for _, ent in ipairs(entities) do

		if not ent.crucified then

			-- Check Crucifix trước movement + kill
			if CheckCrucifix(ent) then
				return
			end

			MoveEntity(ent, dt)

			if not ent.crucified then
				HookKill(ent)
			end
		end
	end
end)
