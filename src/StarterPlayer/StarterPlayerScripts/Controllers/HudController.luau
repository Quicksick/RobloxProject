local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local HudController = {}

function HudController.Start()
	local player = Players.LocalPlayer

	print(`Ahoy {player.Name}! Welcome to {SharedConfig.GameName}.`)
	print(`First goal: sail from Old Harbor to Coconut Cay and find treasure.`)
end

return HudController
