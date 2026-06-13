local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local HudController = {}

function HudController.Start()
	local player = Players.LocalPlayer

	print(`Ahoy {player.Name}! Welcome to {SharedConfig.GameName}.`)
	print("First goal: get an axe, chop trees for wood, gather plant fibres from shrubs, and repair the raft.")
end

return HudController
