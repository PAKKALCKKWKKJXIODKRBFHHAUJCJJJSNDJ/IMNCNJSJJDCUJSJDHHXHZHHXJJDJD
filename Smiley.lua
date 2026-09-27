local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
getgenv().Smiley = true
local function GetGitSound(GithubSnd, SoundName)
	local url = GithubSnd

	if not isfile(SoundName .. ".mp3") then
		writefile(SoundName .. ".mp3", game:HttpGet(url))
	end

	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")

	return sound
end

local gitSoundTemp2 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/E-200_Dissapear_and_RealDissapear_Origin.ogg_(1).mp3?raw=true",
	"lpogfdfcvcggg"
)

local gitSoundTemp3 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/YTDown.com_YouTube_Media_F2MkMM7-ZJA_Something-bad-will-happen-soon_001_360p.mp3?raw=true",
	"gfssdcvjinvvg"
)

local gitSoundTemp4 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/XRecorder_Edited_20260927_02.mp3?raw=true",
	"jbcfhhbcfg"
)

local CurrentRooms = workspace.CurrentRooms

local Module_Events = require(
	game.ReplicatedStorage.ModulesClient.Module_Events
)

for _, Room in ipairs(CurrentRooms:GetChildren()) do
	if Room:IsA("Model") then
		Module_Events.shatter(Room)
	end
end

local blaSound = Instance.new("Sound")
blaSound.SoundId = gitSoundTemp2.SoundId
blaSound.PlaybackSpeed = 1
blaSound.Parent = workspace
blaSound.Looped = false
blaSound.TimePosition = 0
blaSound.Volume = 1.5
blaSound.RollOffMaxDistance = 150
blaSound:Play()

local blaSound2 = Instance.new("Sound")
blaSound2.SoundId = gitSoundTemp3.SoundId
blaSound2.PlaybackSpeed = 1
blaSound2.Parent = workspace
blaSound2.Looped = false
blaSound2.TimePosition = 0
blaSound2.Volume = 1.5
blaSound2.RollOffMaxDistance = 150

local jumpscare = Instance.new("Sound")
jumpscare.SoundId = gitSoundTemp4.SoundId
jumpscare.PlaybackSpeed = 1
jumpscare.Parent = workspace
jumpscare.Looped = false
jumpscare.TimePosition = 0
jumpscare.Volume = 1.5
jumpscare.RollOffMaxDistance = 150

require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("Smiley is here.",true)

blaSound.Ended:Connect(function()
	blaSound:Destroy()

	task.wait(1)

	local LPlayer = Players.LocalPlayer
	local Char = LPlayer.Character or LPlayer.CharacterAdded:Wait()
	local Hum = Char:FindFirstChildOfClass("Humanoid")
	local HRP = Char:FindFirstChild("HumanoidRootPart")

	if not Hum or not HRP then
		return
	end

	--==================================================
	-- STATE
	--==================================================

	local StopAll = false

	--==================================================
	-- LOCK WALKSPEED
	--==================================================

	task.spawn(function()
		while not StopAll and Hum.Parent do
			Hum.WalkSpeed = 0
			task.wait()
		end
	end)

	--==================================================
	-- LOAD MODEL
	--==================================================

	local FileName = "Smiley.rbxm"
	local Url = "https://github.com/beanzjsjwj/doors-monsters-models/raw/refs/heads/main/Smiley.rbxm"

	if not isfile(FileName) then
		writefile(FileName, game:HttpGet(Url))
	end

	local Model = game:GetObjects(
		(getcustomasset or getsynasset)(FileName)
	)[1]

	if not Model then
		return
	end

	Model.Parent = workspace

	if Model:IsA("Model") then
		Model:PivotTo(
			HRP.CFrame * CFrame.new(0, 0, 25)
		)
	elseif Model:IsA("BasePart") then
		Model.CFrame =
			HRP.CFrame * CFrame.new(0, 0, 25)
	end

	--==================================================
	-- FIND BASEPART
	--==================================================

	local TargetPart

	if Model:IsA("BasePart") then
		TargetPart = Model
	else
		TargetPart = Model:FindFirstChildWhichIsA(
			"BasePart",
			true
		)
	end

	if not TargetPart then
		Model:Destroy()
		return
	end

	--==================================================
	-- GUI
	--==================================================

	local Camera = workspace.CurrentCamera

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "CensorBoxGui"
	Gui.IgnoreGuiInset = true
	Gui.ResetOnSpawn = false
	Gui.Parent = LPlayer:WaitForChild("PlayerGui")

	--==================================================
	-- MAIN CENSOR BOX
	--==================================================

	local CensorBox = Instance.new("Frame")
	CensorBox.Name = "CensorBox"
	CensorBox.AnchorPoint = Vector2.new(0.5, 0.5)
	CensorBox.BackgroundColor3 = Color3.new(0, 0, 0)
	CensorBox.BorderSizePixel = 0
	CensorBox.Visible = true
	CensorBox.Parent = Gui

	local BaseDistance = 25
	local BaseSize = 100

	--==================================================
	-- MAIN CENSOR LOOP
	--==================================================

	local CensorConnection

	CensorConnection = RunService.RenderStepped:Connect(function()
		if StopAll
			or not Model.Parent
			or not TargetPart.Parent
			or not Camera.Parent then

			CensorConnection:Disconnect()
			return
		end

		local ScreenPosition =
			Camera:WorldToViewportPoint(
				TargetPart.Position
			)

		if ScreenPosition.Z <= 0 then
			CensorBox.Visible = false
			return
		end

		CensorBox.Visible = true

		CensorBox.Position = UDim2.fromOffset(
			ScreenPosition.X,
			ScreenPosition.Y
		)

		local Distance =
			(Camera.CFrame.Position - TargetPart.Position).Magnitude

		local Scale =
			BaseDistance / math.max(Distance, 0.1)

		Scale = math.clamp(
			Scale,
			0.15,
			3
		)

		local Size = BaseSize * Scale

		CensorBox.Size = UDim2.fromOffset(
			Size,
			Size
		)
	end)

	--==================================================
	-- SECONDARY CENSOR BOX LOOP
	--==================================================

	task.spawn(function()
		while not StopAll
			and Model.Parent
			and TargetPart.Parent do

			task.wait(0.1)

			if StopAll
				or not Model.Parent
				or not TargetPart.Parent then
				break
			end

			local Offset = Vector3.new(
				math.random(-400, 400) / 100,
				math.random(-400, 400) / 100,
				math.random(-400, 400) / 100
			)

			if Offset.Magnitude > 4 then
				Offset = Offset.Unit * 4
			end

			local RandomWorldPosition =
				TargetPart.Position + Offset

			local ScreenPosition =
				Camera:WorldToViewportPoint(
					RandomWorldPosition
				)

			if ScreenPosition.Z > 0 then

				local Distance =
					(Camera.CFrame.Position - RandomWorldPosition).Magnitude

				local Scale =
					BaseDistance / math.max(Distance, 0.1)

				Scale = math.clamp(
					Scale,
					0.15,
					3
				)

				local MainSize =
					BaseSize * Scale

				local CensorClone =
					CensorBox:Clone()

				CensorClone.Name =
					"CensorBoxSecondary"

				CensorClone.Size =
					UDim2.fromOffset(
						MainSize / 1.5,
						MainSize / 1.5
					)

				CensorClone.Position =
					UDim2.fromOffset(
						ScreenPosition.X,
						ScreenPosition.Y
					)

				CensorClone.Visible = true
				CensorClone.Parent = Gui

				task.delay(0.3, function()
					if CensorClone
						and CensorClone.Parent then

						CensorClone:Destroy()
					end
				end)
			end
		end
	end)

	--==================================================
-- CAMERA LERP
--==================================================

task.wait(0.5)

if StopAll or not Model.Parent then
	return
end

Camera.CameraType = Enum.CameraType.Scriptable

local StartCFrame = Camera.CFrame
local CameraPosition = StartCFrame.Position

local TargetCFrame = CFrame.lookAt(
	CameraPosition,
	TargetPart.Position
)

local StartTime = tick()

while tick() - StartTime < 1 do
	if StopAll or not Model.Parent then
		return
	end

	local Alpha = math.clamp(
		(tick() - StartTime) / 1,
		0,
		1
	)

	local Rotation = StartCFrame.Rotation:Lerp(
		TargetCFrame.Rotation,
		Alpha
	)

	Camera.CFrame =
		CFrame.new(CameraPosition) * Rotation

	RunService.RenderStepped:Wait()
end

--==================================================
-- LERP ĐÃ HOÀN TẤT
--==================================================

Camera.CFrame = CFrame.lookAt(
	CameraPosition,
	TargetPart.Position
)

-- BẮT ĐẦU KHÓA CAMERA
local CameraLocked = true

task.spawn(function()
	while CameraLocked
		and not StopAll
		and Model.Parent
		and TargetPart.Parent do

		Camera.CameraType = Enum.CameraType.Scriptable

		Camera.CFrame = CFrame.lookAt(
			CameraPosition,
			TargetPart.Position
		)

		RunService.RenderStepped:Wait()
	end
end)

--==================================================
-- ĐỢI 2 GIÂY SAU KHI LERP XONG
--==================================================

task.wait(2)

--==================================================
-- KẾT THÚC
--==================================================

StopAll = true
CameraLocked = false

-- BlackFrame
local BlackFrame = Instance.new("Frame")
BlackFrame.Name = "BlackFrame"
BlackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
BlackFrame.BorderSizePixel = 0
BlackFrame.Position = UDim2.fromScale(0, 0)
BlackFrame.Size = UDim2.fromScale(1, 1)
BlackFrame.Parent = Gui

-- Ngừng censor
if CensorConnection then
	CensorConnection:Disconnect()
	CensorConnection = nil
end

-- Xóa toàn bộ censor box
for _, Obj in ipairs(Gui:GetChildren()) do
	if Obj ~= BlackFrame then
		Obj:Destroy()
	end
end

-- Xóa entity
if Model and Model.Parent then
	Model:Destroy()
end

-- Khôi phục camera
Camera.CameraType = Enum.CameraType.Custom
Camera.CameraSubject = Hum

	--==================================================
	-- NGỪNG WALK SPEED LOOP
	--==================================================

	StopAll = true
	
	task.wait(2)
Hum.WalkSpeed = 15
	BlackFrame:Destroy()

	--==================================================
	-- CHỜ 3 GIÂY SAU KHI BLACKFRAME BIẾN MẤT
	--==================================================

	task.wait(3)

	--==================================================
	-- RESET STATE CHO ENTITY THỨ 2
	--==================================================

	StopAll = false

	local Model2
	local TargetPart2
	local CensorBox2
	local CensorConnection2
	local Entity2Connections = {}
local Entity2Tweens = {}
local Entity2Stopped = false

	--==================================================
	-- CLONE ENTITY LẦN 2
	--==================================================

	local ModelSource = game:GetObjects(
		(getcustomasset or getsynasset)(FileName)
	)[1]

	if not ModelSource then
		Hum.WalkSpeed = 15
		return
	end

	Model2 = ModelSource
	Model2.Parent = workspace


	--==================================================
	-- FIND BASEPART ĐẦU TIÊN
	--==================================================

	if Model2:IsA("BasePart") then
		TargetPart2 = Model2
	else
		TargetPart2 = Model2:FindFirstChildWhichIsA(
			"BasePart",
			true
		)
	end

	if not TargetPart2 then
		Model2:Destroy()
		Hum.WalkSpeed = 15
		return
	end
	
	TargetPart2.CanCollide = false
	
		--==================================================
	-- ENTITY 2 CHẠM PLAYER
	--==================================================

	local function Entity2Hit()
		if Entity2Stopped or StopAll then
			return
		end

		Entity2Stopped = true
		StopAll = true
		bla = true

		-- Ngừng toàn bộ connection
		for _, Connection in ipairs(Entity2Connections) do
			if Connection and Connection.Connected then
				Connection:Disconnect()
			end
		end

		table.clear(Entity2Connections)

		-- Ngừng toàn bộ tween
		for _, Tween in ipairs(Entity2Tweens) do
			if Tween then
				pcall(function()
					Tween:Cancel()
				end)
			end
		end

		table.clear(Entity2Tweens)

		-- Ngừng censor
		if CensorConnection2 then
			CensorConnection2:Disconnect()
			CensorConnection2 = nil
		end

		-- Destroy entity
		if Model2 and Model2.Parent then
			Model2:Destroy()
		end

		-- Destroy toàn bộ sound script tạo
		if blaSound and blaSound.Parent then
			blaSound:Stop()
			blaSound:Destroy()
		end

		if blaSound2 and blaSound2.Parent then
			blaSound2:Stop()
			blaSound2:Destroy()
		end

		-- Xóa censor GUI
		if Gui and Gui.Parent then
			Gui:Destroy()
		end

		--==================================================
		-- JUMPSCARE
		--==================================================

		local JumpscareGui = Instance.new("ScreenGui")
JumpscareGui.Name = "SmileyJumpscare"
JumpscareGui.IgnoreGuiInset = true
JumpscareGui.ResetOnSpawn = false
JumpscareGui.DisplayOrder = 999999
JumpscareGui.Parent = LPlayer:WaitForChild("PlayerGui")

local BlackFrame = Instance.new("Frame")
BlackFrame.Name = "BlackFrame"
BlackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
BlackFrame.BorderSizePixel = 0
BlackFrame.Position = UDim2.fromScale(0, 0)
BlackFrame.Size = UDim2.fromScale(1, 1)
BlackFrame.ZIndex = 1
BlackFrame.Visible = true
BlackFrame.Parent = JumpscareGui

task.wait(3)

if not JumpscareGui.Parent then
	return
end

jumpscare:Play() 

local Image = Instance.new("ImageLabel")
Image.Name = "JumpscareImage"
Image.BackgroundTransparency = 1
Image.Image = "rbxassetid://117182787466371"
Image.AnchorPoint = Vector2.new(0.5, 0.5)
Image.Position = UDim2.fromScale(0.5, 0.5)

-- Cao bằng màn hình, tự giữ nguyên tỉ lệ ảnh
Image.Size = UDim2.fromScale(1, 1)
Image.SizeConstraint = Enum.SizeConstraint.RelativeXY
Image.ScaleType = Enum.ScaleType.Fit

Image.ZIndex = 2
Image.Visible = true
Image.Parent = JumpscareGui

-- ép render
Image.ImageTransparency = 0

task.wait(1)

if JumpscareGui and JumpscareGui.Parent then
	JumpscareGui:Destroy()
end

if Hum and Hum.Parent then
	Hum:TakeDamage(50)
	game.ReplicatedStorage.GameStats['Player_' .. game.Players.LocalPlayer.Name].Total.DeathCause.Value = 'Smiley'

end
	end

	-- Check tất cả BasePart của entity 2
	for _, Obj in ipairs(Model2:GetDescendants()) do
		if Obj:IsA("BasePart") then
			Obj.CanTouch = true

			local Connection = Obj.Touched:Connect(function(Hit)
				if Hit and Hit:IsDescendantOf(Char) then
					Entity2Hit()
				end
			end)

			table.insert(Entity2Connections, Connection)
		end
	end

	--==================================================
	-- TẠO LẠI CENSOR BOX
	--==================================================

	CensorBox2 = Instance.new("Frame")
	CensorBox2.Name = "CensorBox"
	CensorBox2.AnchorPoint = Vector2.new(0.5, 0.5)
	CensorBox2.BackgroundColor3 = Color3.new(0, 0, 0)
	CensorBox2.BorderSizePixel = 0
	CensorBox2.Visible = true
	CensorBox2.Parent = Gui

	--==================================================
	-- CENSOR BOX LOOP 2
	--==================================================

	CensorConnection2 = RunService.RenderStepped:Connect(function()
		if StopAll
			or not Model2
			or not Model2.Parent
			or not TargetPart2
			or not TargetPart2.Parent
			or not Camera.Parent then

			if CensorConnection2 then
				CensorConnection2:Disconnect()
				CensorConnection2 = nil
			end

			return
		end

		local ScreenPosition =
			Camera:WorldToViewportPoint(
				TargetPart2.Position
			)

		if ScreenPosition.Z <= 0 then
			CensorBox2.Visible = false
			return
		end

		CensorBox2.Visible = true

		CensorBox2.Position = UDim2.fromOffset(
			ScreenPosition.X,
			ScreenPosition.Y
		)

		local Distance =
			(Camera.CFrame.Position - TargetPart2.Position).Magnitude

		local Scale =
			BaseDistance / math.max(Distance, 0.1)

		Scale = math.clamp(
			Scale,
			0.15,
			3
		)

		local Size = BaseSize * Scale

		CensorBox2.Size = UDim2.fromOffset(
			Size,
			Size
		)
	end)

	--==================================================
	-- SECONDARY CENSOR LOOP 2
	--==================================================

	task.spawn(function()
		while not StopAll
			and Model2
			and Model2.Parent
			and TargetPart2
			and TargetPart2.Parent do

			task.wait(0.1)

			if StopAll
				or not Model2
				or not Model2.Parent
				or not TargetPart2
				or not TargetPart2.Parent then
				break
			end

			local Offset = Vector3.new(
				math.random(-400, 400) / 100,
				math.random(-400, 400) / 100,
				math.random(-400, 400) / 100
			)

			if Offset.Magnitude > 4 then
				Offset = Offset.Unit * 4
			end

			local RandomWorldPosition =
				TargetPart2.Position + Offset

			local ScreenPosition =
				Camera:WorldToViewportPoint(
					RandomWorldPosition
				)

			if ScreenPosition.Z > 0 then

				local Distance =
					(Camera.CFrame.Position - RandomWorldPosition).Magnitude

				local Scale =
					BaseDistance / math.max(Distance, 0.1)

				Scale = math.clamp(
					Scale,
					0.15,
					3
				)

				local MainSize =
					BaseSize * Scale

				local CensorClone =
					CensorBox2:Clone()

				CensorClone.Name =
					"CensorBoxSecondary"

				CensorClone.Size =
					UDim2.fromOffset(
						MainSize / 1.5,
						MainSize / 1.5
					)

				CensorClone.Position =
					UDim2.fromOffset(
						ScreenPosition.X,
						ScreenPosition.Y
					)

				CensorClone.Visible = true
				CensorClone.Parent = Gui

				task.delay(0.3, function()
					if CensorClone
						and CensorClone.Parent then

						CensorClone:Destroy()
					end
				end)
			end
		end
	end)

	--==================================================
	-- LOOP PIVOT ENTITY VỀ HRP
	--==================================================
local bla = false
	local TweenService = game:GetService("TweenService")

task.spawn(function()
	task.wait(1)

	while not StopAll
		and Model2
		and Model2.Parent do

		task.wait(math.random(2, 6))
		
		

		if StopAll
			or not Model2
			or not Model2.Parent
			or not HRP
			or not HRP.Parent then
			break
		end

		local StartCFrame

		if Model2:IsA("Model") then
			StartCFrame = Model2:GetPivot()
		elseif Model2:IsA("BasePart") then
			StartCFrame = Model2.CFrame
		else
			break
		end

		local CFrameValue = Instance.new("CFrameValue")
		CFrameValue.Value = StartCFrame

		local Connection = CFrameValue.Changed:Connect(function(Value)
			if Model2 and Model2.Parent then
				if Model2:IsA("Model") then
					Model2:PivotTo(Value)
				elseif Model2:IsA("BasePart") then
					Model2.CFrame = Value
				end
			end
		end)

		local Tween = TweenService:Create(
			CFrameValue,
			TweenInfo.new(
				1,
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.Out
			),
			{
				Value = HRP.CFrame
			}
		)

		table.insert(Entity2Tweens, Tween)

Tween:Play()
Tween.Completed:Wait()

if Entity2Stopped then
	break
end
		
		local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
local camera = workspace.CurrentCamera

local spawnShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end)

spawnShake:Start()

spawnShake:ShakeOnce(
	13,   -- Magnitude (mạnh)
	1,   -- Roughness
	0.05, -- FadeIn
	2, -- FadeOut
	0,    -- PositionInfluence
	0.8   -- RotationInfluence
)

		Connection:Disconnect()
		CFrameValue:Destroy()
	end
end)

	--==================================================
	-- PLAY BLASOUND2
	--==================================================

	blaSound2:Play()
	
	local CurrentRooms = workspace.CurrentRooms

local Module_Events = require(
	game.ReplicatedStorage.ModulesClient.Module_Events
)

-- Shatter tất cả room đang có sẵn
for _, Room in ipairs(CurrentRooms:GetChildren()) do
	if Room:IsA("Model") then
		Module_Events.shatter(Room)
	end
end

-- Shatter room mới spawn
CurrentRooms.ChildAdded:Connect(function(Room)
	if Room:IsA("Model") and not bla then
		Module_Events.shatter(Room)
	end
end)

	--==================================================
	-- KHI BLASOUND2 KẾT THÚC
	--==================================================

	blaSound2.Ended:Wait()

if Entity2Stopped then
	return
end

bla = true
StopAll = true

	-- Ngừng censor chính
	if CensorConnection2 then
		CensorConnection2:Disconnect()
		CensorConnection2 = nil
	end

	-- Xóa toàn bộ censor còn lại
	if Gui and Gui.Parent then
		for _, Obj in ipairs(Gui:GetChildren()) do
			Obj:Destroy()
		end

		Gui:Destroy()
	end

	-- Xóa entity thứ 2
	if Model2 and Model2.Parent then
		Model2:Destroy()
	end

	-- Xóa sound
	if blaSound2 and blaSound2.Parent then
		blaSound2:Destroy()
	end

		getgenv().Smiley = false

	-- Khôi phục WalkSpeed
	require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("Smiley will come back.",true)
end)
