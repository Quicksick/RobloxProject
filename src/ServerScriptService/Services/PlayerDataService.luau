local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local PlayerDataService = {}

local function createLeaderstats(player: Player)
	if player:FindFirstChild("leaderstats") then
		return
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local gold = Instance.new("IntValue")
	gold.Name = "Gold"
	gold.Value = SharedConfig.StartingGold
	gold.Parent = leaderstats

	local weapon = Instance.new("StringValue")
	weapon.Name = "Weapon"
	weapon.Value = "None"
	weapon.Parent = leaderstats
end

function PlayerDataService.Start()
	local function setupPlayer(player: Player)
		createLeaderstats(player)
		print(`Created pirate profile for {player.Name}`)
	end

	Players.PlayerAdded:Connect(setupPlayer)

	for _, player in Players:GetPlayers() do
		setupPlayer(player)
	end
end

return PlayerDataService
