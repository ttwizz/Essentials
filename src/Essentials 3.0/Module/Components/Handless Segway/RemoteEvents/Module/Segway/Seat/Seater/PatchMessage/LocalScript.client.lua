local MessageFrame = script.Parent:WaitForChild("MessageFrame")
local DisplayTimeout = 3

MessageFrame:TweenPosition(UDim2.new(),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,1,true,function()
	wait(DisplayTimeout)
	MessageFrame:TweenPosition(UDim2.new(0,0,-1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,3,true,function()
		script.Parent:Destroy()
	end)
end)