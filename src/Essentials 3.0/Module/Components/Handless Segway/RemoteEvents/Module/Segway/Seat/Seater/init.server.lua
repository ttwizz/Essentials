-- Segway seating script

-- Variables
local Home = script.Parent.Parent
local Part = script.Parent
local HasWelded = Part:WaitForChild("HasWelded")
HasWelded.Value = false
-- Objects within the segway
local Lights = Home:WaitForChild("Lights")
local Notifiers = Home:WaitForChild("Notifiers")
local Left_Wing = Home:WaitForChild("Left Wing")
local Right_Wing = Home:WaitForChild("Right Wing")
local ColorableParts = {Left_Wing.Base,Left_Wing.Cover,Right_Wing.Base,Right_Wing.Cover}
local CreatorTag = Home:WaitForChild("Creator")
-- Welds
local Weld = nil
local LeftLegWeld = nil
local RightLegWeld = nil
local RightArmWeld = nil
local NeckWeld = nil
local LeftUpperWeld = nil
local RightUpperWeld = nil
-- Other
local Player = nil
local Character = nil
local Humanoid = nil
local RootPart = nil
local PlayersControlScript = nil
local ToolStatus = nil
local Proceed = false
local MyTool = Home:WaitForChild("MyTool")
local PatchMessage = script:WaitForChild("PatchMessage")
local IsR15 = false
local SecurityPatchLevel = 5

-- Functions
function ApplySettingsToScript(S)
	S.PlayersWeld.Value = Weld
	S.Thruster.Value = Home:WaitForChild("Wheels"):WaitForChild("Thruster")
	S.TiltMotor.Value = Home:WaitForChild("TiltMotor")
	S.SeaterScript.Value = script
	S.Segway.Value = Home
end

function Controller(Player)
	if MyTool.Value ~= nil and MyTool.Value.Parent then
	ToolStatus = MyTool.Value:WaitForChild("ToolStatus")
	ApplySettingsToScript(ToolStatus)
	end
end

function WeldLimb(Part1,OriginalMotor,C0Factor)
	-- Record the original CFrame for later use
	local CFValue = Instance.new("CFrameValue")
	CFValue.Name = "KeptCFrame"
	CFValue.Value = OriginalMotor.C0
	CFValue.Parent = OriginalMotor
	
	OriginalMotor.C0 = OriginalMotor.C0 * C0Factor
end

function EquipWelds(RootPart,Humanoid)
	-- Anchor and position character so segway won't achieve too high velocity?
	local px,py,pz,xx,xy,xz,yx,yy,yz,zx,zy,zz = RootPart.CFrame:components()
	RootPart.Anchored = true
	RootPart.CFrame = Part.CFrame * CFrame.Angles(0,math.rad(180),0) + (Vector3.new(xy,yy,zy)*3)
	
	--Applies main weld
	Weld = Instance.new("Motor6D")
	Weld.Parent = Part
	Weld.Part0 = RootPart
	Weld.Part1 = Part
	
	
	if IsR15 then
		Weld.C0 = (Weld.C0 - Vector3.new(0,Humanoid.HipHeight+(RootPart.Size.Y/2),0)) * CFrame.Angles(0,math.rad(-180),0)
		
		--Right leg weld
		if Character:FindFirstChild("RightUpperLeg") and Character:FindFirstChild("RightUpperLeg"):FindFirstChild("RightHip") then
			WeldLimb(Character:FindFirstChild("RightUpperLeg"),Character:FindFirstChild("RightUpperLeg"):FindFirstChild("RightHip"),CFrame.Angles(0,0,0.25) + Vector3.new(0,0.15,0))
		end
		
		--Neck weld weld
		if Character:FindFirstChild("Head") and Character:FindFirstChild("Head"):FindFirstChild("Neck") then
			WeldLimb(Character:FindFirstChild("Head"),Character:FindFirstChild("Head"):FindFirstChild("Neck"),CFrame.Angles(-0.11,0,0))
		end
		
		--Left leg weld
		if Character:FindFirstChild("LeftUpperLeg") and Character:FindFirstChild("LeftUpperLeg"):FindFirstChild("LeftHip") then
			WeldLimb(Character:FindFirstChild("LeftUpperLeg"),Character:FindFirstChild("LeftUpperLeg"):FindFirstChild("LeftHip"),CFrame.Angles(0,0,-0.25) + Vector3.new(0,0.15,0))
		end
		
		--Right arm weld
		if Character:FindFirstChild("RightUpperArm") and Character:FindFirstChild("RightUpperArm"):FindFirstChild("RightShoulder") then
			WeldLimb(Character:FindFirstChild("RightUpperArm"),Character:FindFirstChild("RightUpperArm"):FindFirstChild("RightShoulder"),CFrame.Angles(math.rad(-90),0,0))
		end
		
	elseif not IsR15 then
		Weld.C0 = (Weld.C0 - Vector3.new(0,2+(RootPart.Size.Y/2),0)) * CFrame.Angles(0,math.rad(-180),0)
		
		--Left leg weld
		if Character:FindFirstChild("Left Leg") and Character:FindFirstChild("Torso"):FindFirstChild("Left Hip") then
			WeldLimb(Character:FindFirstChild("Left Leg"),Character:FindFirstChild("Torso"):FindFirstChild("Left Hip"),CFrame.Angles(-0.25,0,0) + Vector3.new(0,0.15,0))
		end
			
		--Right leg weld
		if Character:FindFirstChild("Right Leg") and Character:FindFirstChild("Torso"):FindFirstChild("Right Hip") then
			WeldLimb(Character:FindFirstChild("Right Leg"),Character:FindFirstChild("Torso"):FindFirstChild("Right Hip"),CFrame.Angles(-0.25,0,0) + Vector3.new(0,0.15,0))
		end
			
		--Neck weld
		if Character:FindFirstChild("Head") and Character:FindFirstChild("Torso"):FindFirstChild("Neck") then
			WeldLimb(Character:FindFirstChild("Head"),Character:FindFirstChild("Torso"):FindFirstChild("Neck"),CFrame.Angles(0.11,0,0))
		end
		
		--Right arm weld
		if Character:FindFirstChild("Right Arm") and Character:FindFirstChild("Torso"):FindFirstChild("Right Shoulder") then
			WeldLimb(Character:FindFirstChild("Right Arm"),Character:FindFirstChild("Torso"):FindFirstChild("Right Shoulder"),CFrame.Angles(0,0,math.rad(-90)))
		end
	end
	RootPart.Anchored = false
end

Part.Touched:connect(function(TouchedPart)
	if TouchedPart.Parent:FindFirstChild("Humanoid") and TouchedPart.Parent:FindFirstChild("Humanoid").Sit == false and TouchedPart.Parent:FindFirstChild("Humanoid").PlatformStand == false and TouchedPart.Parent:FindFirstChild("Humanoid").Health >0 and game.Players:GetPlayerFromCharacter(TouchedPart.Parent) and HasWelded.Value == false and Home:FindFirstChild("TiltMotor") then
	--Define player
	Player = game.Players:GetPlayerFromCharacter(TouchedPart.Parent)
	
	-- Make sure the player that touched the segway is the creator
	if Player ~= CreatorTag.Value then return end
	
	--Define character
	Character = Player.Character
	
	--Check for desired parts
	if not Character:FindFirstChild("HumanoidRootPart") or not Character:FindFirstChild("Humanoid") then HasWelded.Value = false return end
	
	-- Mark if the segway is in use
	HasWelded.Value = true
	Proceed = false
	
	--Define humanoid and configure
	Humanoid = Character:FindFirstChild("Humanoid")
	Humanoid.PlatformStand = true
	Humanoid.AutoRotate = false
	
	-- Determine if R15
	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		IsR15 = true
	end
	
	--Define HumanoidRootPart
	RootPart = Character:FindFirstChild("HumanoidRootPart")
	
	--Welds
	EquipWelds(RootPart,Humanoid)
	
	--Plays the on sound and turns on lights
	if script.Parent:FindFirstChild("On") then -- if sound exists
	script.Parent.On:Play()
	script.Parent.Run.Volume = 0
	script.Parent.Run:Play()
	
	--Incase sound hasn't loaded or is deleted?!?!
	delay(0,function() wait(script.Parent.On.TimeLength+0.1) Proceed = true end)
	--Waits
	repeat wait() until Proceed == true
	end
	
	wait(0.3)
	--Adds/configures the controller script
	Controller(Player)
	
	--Checks if segway is out-of-date
	if not ToolStatus:FindFirstChild("SecurityPatchLevel") or ToolStatus:FindFirstChild("SecurityPatchLevel") and ToolStatus:FindFirstChild("SecurityPatchLevel").Value ~= SecurityPatchLevel then
		if PatchMessage.Parent == script then
			PatchMessage.Parent = Player.PlayerGui
			PatchMessage.LocalScript.Disabled = false
		end
	end
	
	end
end)