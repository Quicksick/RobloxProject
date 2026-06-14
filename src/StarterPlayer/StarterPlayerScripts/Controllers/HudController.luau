local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local HudController = {}

function HudController.Start()
	local player = Players.LocalPlayer

	print(`Ahoy {player.Name}! Welcome to {SharedConfig.GameName}.`)
	print("First goal: repair the raft, click it to board, then use WASD to sail.")
	print("Controls: E opens inventory. F uses nearby prompts.")
end

return HudController
