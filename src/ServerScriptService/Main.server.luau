local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))
local PlayerDataService = require(script.Parent.Services.PlayerDataService)
local QuestService = require(script.Parent.Services.QuestService)
local ShipService = require(script.Parent.Services.ShipService)
local WorldBuilderService = require(script.Parent.Services.WorldBuilderService)
local FirstWeaponService = require(script.Parent.Services.FirstWeaponService)

print(`{SharedConfig.GameName} server started`)
print(`Theme: {SharedConfig.Theme}`)

PlayerDataService.Start()
QuestService.Start()
ShipService.Start()
WorldBuilderService.Start()
FirstWeaponService.Start()
