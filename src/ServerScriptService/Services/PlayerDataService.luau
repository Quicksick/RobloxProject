local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local PlayerDataService = {}

local function createLeaderstats(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local gold = Instance.new("IntValue")
	gold.Name = "Gold"
	gold.Value = SharedConfig.StartingGold
	gold.Parent = leaderstats
end

function PlayerDataService.Start()
	Players.PlayerAdded:Connect(function(player)
		createLeaderstats(player)
		print(`Created pirate profile for {player.Name}`)
	end)
end

return PlayerDataService
