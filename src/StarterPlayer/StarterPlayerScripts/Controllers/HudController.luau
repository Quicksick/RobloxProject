local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local HudController = {}

function HudController.Start()
	local player = Players.LocalPlayer

	print(`Ahoy {player.Name}! Welcome to {SharedConfig.GameName}.`)
	print("Goal: repair the raft, sail to resource islands, then upgrade it 3 times.")
	print("Controls: E opens inventory. F uses nearby prompts. Swimming drains stamina.")
end

return HudController
