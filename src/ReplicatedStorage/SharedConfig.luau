local SharedConfig = {
	GameName = "RobloxProject",
	Theme = "Pirates",
	StartingGold = 100,
	StartingShip = "Dinghy",
	FirstTool = "WoodenAxe",
	Map = {
		UseGeneratedPrototypeWorld = false,
		GeneratedWorldName = "PiratePrototypeWorld",
		StudioMapName = "Map",
		ClearTerrainWhenGenerating = false,
	},
	RaftRepairWoodCost = 5,
	RaftRepairPlantFibreCost = 3,
	RaftUpgradeCosts = {
		[1] = {
			Wood = 8,
			PlantFibres = 2,
		},
		[2] = {
			Wood = 14,
			PlantFibres = 4,
		},
		[3] = {
			Wood = 22,
			PlantFibres = 6,
		},
	},
}

return SharedConfig
