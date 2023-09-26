-- This script listens for RemoteEvents that will be called from the client ("Main" script)
local Home = script.Parent

-- ModuleScript that holds all the functions that are tied with the RemoteEvents
local Functions = require(script:WaitForChild("ServerFunctions"))

-- Folder that contains the RemoteEvents
local RemoteFolder = Home:WaitForChild("RemoteEvents")

-- Define each RemoteEvent individually
local SpawnSegway = RemoteFolder:WaitForChild("SpawnSegway")
local ConfigTool = RemoteFolder:WaitForChild("ConfigTool")
local DestroySegway = RemoteFolder:WaitForChild("DestroySegway")
local UndoTags = RemoteFolder:WaitForChild("UndoTags")
local UndoSeater = RemoteFolder:WaitForChild("UndoSeater")
local DeleteWelds = RemoteFolder:WaitForChild("DeleteWelds")
local ConfigLights = RemoteFolder:WaitForChild("ConfigLights")

-- Listeners
SpawnSegway.OnServerEvent:connect(function(Player,Color)
	Functions.SpawnSegway(Player,Color)
end)

ConfigTool.OnServerEvent:connect(function(Player,Transparency,ShouldColor,Color)
	Functions.ConfigTool(Transparency,ShouldColor,Color)
end)

DestroySegway.OnServerEvent:connect(function(Player)
	Functions.DestroySegway()
end)

UndoTags.OnServerEvent:connect(function(Player)
	Functions.UndoTags()
end)

UndoSeater.OnServerEvent:connect(function(Player)
	Functions.UndoSeater()
end)

function DeleteWelds.OnServerInvoke(Player)
	Functions.DeleteWelds()
	return true
end

ConfigLights.OnServerEvent:connect(function(Player,Transparency,Color,Bool,Material)
	Functions.ConfigLights(Transparency,Color,Bool,Material)
end)
