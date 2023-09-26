local Functions = {}

-- General variables
local ThisTool = script.Parent.Parent
local MainScript = ThisTool:WaitForChild("Main")
local ToolStatus = ThisTool:WaitForChild("ToolStatus")
local Wings = {"Left Wing","Right Wing"}
local PlayerService = game:GetService("Players")

-- Create base segway to clone from
local Segway = require(11950334152)

local function configHumanoid(PlatformStand,Jump,AutoRotate)
	local Segway = ToolStatus.SpawnedSegway.Value
	local Player = (Segway and PlayerService:GetPlayerFromCharacter(Segway.Parent)) or PlayerService:GetPlayerFromCharacter(ThisTool.Parent)
	local Character = Player and Player.Character

	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if Humanoid then
		Humanoid.AutoRotate = AutoRotate
		Humanoid.PlatformStand = PlatformStand
		Humanoid.Jump = Jump

		for _,d in pairs(Character:GetDescendants()) do
			if d and d:IsA("CFrameValue") and d.Name == "KeptCFrame" then
				d.Parent.C0 = d.Value
				d:Destroy()
			end
		end
	end
end

local function colorSegway(Model,Color)
	for i=1, #Wings do
		for _,v in pairs(Model[Wings[i]]:GetChildren()) do
			if v.Name == "Base" or v.Name == "Cover" then
				v.BrickColor = Color
			end
		end
	end
end

Functions.UndoTags = function()
	-- Reset the user's humanoid state.
	configHumanoid(false,true,true)
	
	local SegwayObject = ToolStatus.Segway
	local PlayersWeld = ToolStatus.PlayersWeld
	local TiltMotor = ToolStatus.TiltMotor

	if SegwayObject then
		PlayersWeld.Value = nil
		TiltMotor.Value = nil
		SegwayObject.Value = nil
	end
end

Functions.UndoSeater = function()
	local SeaterScript = ToolStatus:FindFirstChild("SeaterScript")
	if SeaterScript.Value and SeaterScript.Value.Parent then
		SeaterScript.Value.Parent.HasWelded.Value = false
		SeaterScript.Value = nil
	end
end

Functions.DeleteWelds = function()
	local Segway = ToolStatus.SpawnedSegway.Value
	local Seat = Segway and Segway:FindFirstChild("Seat")
	
	if Seat then
		for _,v in pairs(Seat:GetChildren()) do
			if v:IsA("Motor6D") then
			v:Destroy()
			end
		end
		
		local Off = Seat:FindFirstChild("Off")
		local Run = Seat:FindFirstChild("Run")
		
		if Off and Run then
			Off:Play()
			Run:Stop()
		end
	end
end

Functions.ConfigLights = function(Transparency,Color,Bool,Material)
	local Segway = ToolStatus.SpawnedSegway.Value
	local Lights = Segway and Segway:FindFirstChild("Lights")
	local Notifiers = Segway and Segway:FindFirstChild("Notifiers")
	
	if Lights and Notifiers then
		for _,v in pairs(Lights:GetChildren()) do
			if v:IsA("BasePart") and v:FindFirstChild("SpotLight") then
			v.BrickColor = BrickColor.new(Color)
			v.Transparency = Transparency
			v:FindFirstChild("SpotLight").Enabled = Bool
			v.Material = Material
			end
		end
		
		for _,v in pairs(Notifiers:GetChildren()) do
			if v:IsA("BasePart") and v.Name == "Screen" and v:FindFirstChild("SurfaceGui") then
			v:FindFirstChild("SurfaceGui").ImageLabel.Visible = Bool
			end
		end
	end
end

Functions.DestroySegway = function()
	-- Reset the user's humanoid state.
	configHumanoid(false,false,true)
	
	local Segway = ToolStatus.SpawnedSegway.Value
	
	if Segway and Segway:FindFirstChild("SegPlatform") then
		ToolStatus.SpawnedSegway.Value:Destroy()
	end
end

Functions.SpawnSegway = function(Player,Color)
	local Character = Player.Character
	
	if Character and not Character:FindFirstChild(Segway.Name) and ThisTool.Parent == Character then
		local NewSegway = Segway:Clone()
		local Head = Character:WaitForChild("Head")
		
		-- Get the head's rotation matrix
		local p,xx,xy,xz,yx,yy,yz,zx,zy,zz = Head.CFrame:components()
		
		-- Get the position in front of player
		local SpawnPos = Head.Position + (Head.CFrame.lookVector*4)
		
		ToolStatus.Thruster.Value = NewSegway:WaitForChild("Wheels"):WaitForChild("Thruster")
		
		-- Apply the settings called from the client
		NewSegway:WaitForChild("Creator").Value = Player
		NewSegway:WaitForChild("MyTool").Value = ThisTool
		
		ToolStatus.SpawnedSegway.Value = NewSegway
		
		-- Colors the segway
		colorSegway(NewSegway,Color)
		
		-- Parent segway into the player's character
		NewSegway.Parent = Character
		NewSegway:MakeJoints()
			
		-- Position segway
		NewSegway:SetPrimaryPartCFrame(CFrame.new(0,0,0,xx,xy,xz,yx,yy,yz,zx,zy,zz)*CFrame.Angles(0,math.rad(180),0)) -- Rotate segway properly
		NewSegway:MoveTo(SpawnPos)
		
		NewSegway:WaitForChild("Seat"):SetNetworkOwner(Player)
	end
end

Functions.ConfigTool = function(Transparency,ShouldColor,Color)
	for _,v in pairs(ThisTool:GetChildren()) do
		if v:IsA("BasePart") and ShouldColor == false then
			v.Transparency = Transparency
		elseif ShouldColor == true and v:IsA("BasePart") and v.Name == "ColorablePart" then
			v.BrickColor = Color
		end
	end
end

return Functions