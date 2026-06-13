local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Islands = require(ReplicatedStorage.Config:WaitForChild("Islands"))

local QuestService = {}

function QuestService.Start()
	print("Island route loaded:")

	for index, island in Islands do
		print(`{index}. {island.Name} - reward: {island.Rewards.Gold} gold`)
	end
end

return QuestService
