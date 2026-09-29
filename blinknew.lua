local Ritual = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonellocristian78-lab/Gradish-Mode/main/CrucifixRitual"))()
local RunService = game:GetService("RunService")
local stop = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
local GameData = ReplicatedStorage:WaitForChild("GameData")
local LatestRoom = GameData:WaitForChild("LatestRoom")

local Functions = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"
))()

--// LOAD ENTITY
local Entity = Functions.LoadCustomInstance(
	"https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/blinkymodel.rbxm?raw=true"
)

if typeof(Entity) ~= "Instance" or not Entity:IsA("Model") then
	return
end

--// ENTITY PRIMARY PART
local PrimaryPart = Entity.PrimaryPart
	or Entity:FindFirstChildWhichIsA("BasePart", true)

if not PrimaryPart then
	Entity:Destroy()
	return
end

Entity.PrimaryPart = PrimaryPart


--// CURRENT ROOM
local Room = Workspace:WaitForChild("CurrentRooms"):WaitForChild(
	tostring(LatestRoom.Value)
)

local Floor = Room:WaitForChild("Parts"):WaitForChild("Floor")

--// SPAWN ENTITY
PrimaryPart.Position = Floor.Position + Vector3.new(0, 5, 0)
PrimaryPart.Anchored = true

Entity.Parent = Workspace
Entity.Name = "blinky"


Entity:SetAttribute("IsCustomEntity", true)
Entity:SetAttribute("NoAI", false)

--// KEEP DIRECT REFERENCE
local Blink = Entity:WaitForChild("Blink")
local Lerping = false

--// BLINK DETECTION LIGHT
local LightAttachment = Instance.new("Attachment")
LightAttachment.Name = "DetectionLightAttachment"
LightAttachment.Position = Vector3.zero
LightAttachment.Parent = Blink

local Spotlight = Instance.new("SpotLight")
Spotlight.Name = "DetectionLight"
Spotlight.Color = Color3.fromRGB(221, 31, 255)
Spotlight.Brightness = 2
Spotlight.Range = 180
Spotlight.Angle = 90
Spotlight.Parent = LightAttachment

local RotateSpeed = Instance.new("NumberValue")
RotateSpeed.Value = 1

local Rotation = 0
local Detecting = false
local SpeedTween

task.spawn(function()
	while not stop and Entity.Parent and LightAttachment.Parent do
		local dt = RunService.Heartbeat:Wait()

		if stop or not Entity.Parent then
			break
		end

		local IsDetecting =
			Blink.OpenParticle.Enabled
			and Hum.MoveDirection.Magnitude > 0

		if IsDetecting and not Detecting then
			Detecting = true

			if SpeedTween then
				SpeedTween:Cancel()
			end

			RotateSpeed.Value = 2
			Spotlight.Brightness = 4

			SpeedTween = TweenService:Create(
				RotateSpeed,
				TweenInfo.new(
					0.45,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.Out
				),
				{
					Value = 1
				}
			)

			SpeedTween:Play()

			TweenService:Create(
				Spotlight,
				TweenInfo.new(
					0.45,
					Enum.EasingStyle.Sine,
					Enum.EasingDirection.Out
				),
				{
					Brightness = 2
				}
			):Play()
		elseif not IsDetecting then
			Detecting = false
		end

		if not Lerping then
	Rotation += (math.pi * 2 / 7) * RotateSpeed.Value * dt
	LightAttachment.CFrame = CFrame.Angles(0, Rotation, 0)
end
	end
end)

local function LookAtPlayer()
	if Lerping or not Entity.Parent or stop then
		return
	end

	Lerping = true

	local Start = LightAttachment.CFrame

	local TargetPosition = Vector3.new(
		HRP.Position.X,
		Blink.Position.Y,
		HRP.Position.Z
	)

	local TargetWorld = CFrame.lookAt(
		Blink.Position,
		TargetPosition
	)

	local Target = Blink.CFrame:ToObjectSpace(TargetWorld)

	local StartTime = os.clock()

	while not stop and Entity.Parent and LightAttachment.Parent do
		local Alpha = math.clamp(
			(os.clock() - StartTime) / 0.2,
			0,
			1
		)

		LightAttachment.CFrame = Start:Lerp(Target, Alpha)

		if Alpha >= 1 then
			break
		end

		RunService.Heartbeat:Wait()
	end

	Lerping = false
end

task.wait(0.1)

Blink.Spawn:Play()

--// BLINK LOOP
task.spawn(function()
	local function openEye()
		Blink.OpenParticle.Enabled = true
		Blink.ClosedParticle.Enabled = false

		Blink.Blink:Play()
		Blink.BlinkForeshadow:Play()
	end

	local function closeEye()
		Blink.OpenParticle.Enabled = false
		Blink.ClosedParticle.Enabled = true

		Blink.Blink:Play()
		Blink.BlinkForeshadow:Play()
	end

	local v = 0

	while not stop and Entity.Parent do
		task.wait(7)

		if stop or not Entity.Parent then
			break
		end

		v += 1

		if v == 1 then
			if Blink.OpenParticle.Enabled then
				closeEye()
			else
				openEye()
			end

			v = 0
		end
	end
end)

--// DAMAGE WHEN EYE IS OPEN
task.spawn(function()
	while not stop and Entity.Parent do
		if Blink.OpenParticle.Enabled
			and Hum.MoveDirection.Magnitude > 0 then

			local Crucifix = Char:FindFirstChild("Crucifix")

			if Crucifix then
				stop = true

				Blink.Whisper.Volume = 7
				Blink.Whisper.PlaybackSpeed = 0.3

				local TweenWhisper = TweenService:Create(
					Blink.Whisper,
					TweenInfo.new(2),
					{
						Volume = 0
					}
				)

				task.spawn(function()
					task.wait(4)

					if TweenWhisper and Blink.Whisper then
						TweenWhisper:Play()
					end
				end)

				task.spawn(function()
					task.wait(0.1)

					Ritual.Run({
						Model = Entity,
						Tool = Crucifix,
						Kind = "Guiding",
					})
				end)

				break
			end
			
			LookAtPlayer()

			Hum.Health -= 10

			local PlayerStats =
				ReplicatedStorage.GameStats:
				FindFirstChild("Player_" .. LocalPlayer.Name)

			if PlayerStats
				and PlayerStats:FindFirstChild("Total")
				and PlayerStats.Total:FindFirstChild("DeathCause") then

				PlayerStats.Total.DeathCause.Value = "Blink"
			end

			if Hum.Health <= 0 then
				Blink.Kill:Play()
			end

			task.wait(1)
		end

		task.wait()
	end
end)

--// ROOM CHANGED
LatestRoom.Changed:Wait()

stop = true

if Entity and Entity.Parent then
	Entity:Destroy()
end

