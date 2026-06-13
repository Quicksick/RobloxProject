local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Ships = require(ReplicatedStorage.Config:WaitForChild("Ships"))

local ShipService = {}

function ShipService.Start()
	local starterShip = Ships.Dinghy

	print(`Starter ship ready: {starterShip.DisplayName}`)
end

return ShipService
