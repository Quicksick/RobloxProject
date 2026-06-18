local SharedConfig = {
	GameName = "RobloxProject",
	Theme = "Pirates",
	StartingGold = 100,
	StartingShip = "Dinghy",
	FirstTool = "WoodenAxe",
	Map = {
		UseGeneratedPrototypeWorld = false,
		EnsureOceanWater = true,
		GeneratedWorldName = "PiratePrototypeWorld",
		StudioMapName = "Map",
		ClearTerrainWhenGenerating = false,
		OceanCenter = Vector3.new(0, -39, 0),
		OceanSize = Vector3.new(900, 84, 900),
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
