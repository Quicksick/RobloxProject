local Workspace = game:GetService("Workspace")

local WorldBuilderService = {}

local WORLD_FOLDER_NAME = "PiratePrototypeWorld"

local function makePart(parent: Instance, name: string, size: Vector3, position: Vector3, color: Color3, material: Enum.Material, rotation: Vector3?)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = CFrame.new(position)
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent

	if rotation then
		part.CFrame *= CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
	end

	return part
end

local function makeSpawn(parent: Instance)
	local spawnLocation = Instance.new("SpawnLocation")
	spawnLocation.Name = "Old Harbor Spawn"
	spawnLocation.Anchored = true
	spawnLocation.Size = Vector3.new(8, 1, 8)
	spawnLocation.Position = Vector3.new(0, 7, 0)
	spawnLocation.Color = Color3.fromRGB(236, 213, 154)
	spawnLocation.Material = Enum.Material.WoodPlanks
	spawnLocation.Neutral = true
	spawnLocation.Parent = parent
end

local function makeTreasureChest(parent: Instance)
	local chest = Instance.new("Model")
	chest.Name = "Treasure Chest"
	chest.Parent = parent

	makePart(chest, "Chest Base", Vector3.new(6, 3, 4), Vector3.new(82, 7, -18), Color3.fromRGB(111, 68, 39), Enum.Material.Wood)
	makePart(chest, "Gold", Vector3.new(4, 1, 3), Vector3.new(82, 9.2, -18), Color3.fromRGB(255, 204, 51), Enum.Material.Metal)
end

local function makeOcean(parent: Instance)
	local terrain = Workspace.Terrain

	terrain:FillBlock(CFrame.new(0, -3, 0), Vector3.new(900, 8, 900), Enum.Material.Water)
	makePart(parent, "Seabed Prototype", Vector3.new(900, 1, 900), Vector3.new(0, -7.5, 0), Color3.fromRGB(37, 104, 132), Enum.Material.Sand)
end

local function makeBrokenRaft(parent: Instance)
	local raft = Instance.new("Model")
	raft.Name = "Broken Starter Raft"
	raft:SetAttribute("Repaired", false)
	raft.Parent = parent

	local base = makePart(raft, "Repair Spot", Vector3.new(6, 1, 6), Vector3.new(24, 4.2, -24), Color3.fromRGB(160, 45, 35), Enum.Material.SmoothPlastic)
	base.Transparency = 0.35
	local repairZone = makePart(raft, "Repair Click Zone", Vector3.new(24, 10, 16), Vector3.new(24, 7, -24), Color3.fromRGB(255, 255, 255), Enum.Material.SmoothPlastic)
	repairZone.Transparency = 1
	repairZone.CanCollide = false
	repairZone.CanTouch = false
	repairZone.CanQuery = true

	makePart(raft, "Broken Plank Left", Vector3.new(16, 0.8, 1.4), Vector3.new(23, 3, -28), Color3.fromRGB(92, 55, 32), Enum.Material.Wood, Vector3.new(0, 0, -8))
	makePart(raft, "Broken Plank Middle", Vector3.new(10, 0.8, 1.4), Vector3.new(21, 3.2, -24), Color3.fromRGB(110, 68, 38), Enum.Material.Wood, Vector3.new(0, 0, 13))
	makePart(raft, "Broken Plank Right", Vector3.new(14, 0.8, 1.4), Vector3.new(25, 3, -20), Color3.fromRGB(92, 55, 32), Enum.Material.Wood, Vector3.new(0, 0, 7))
	makePart(raft, "Snapped Plank", Vector3.new(6, 0.8, 1.2), Vector3.new(31, 3.6, -25), Color3.fromRGB(80, 47, 29), Enum.Material.Wood, Vector3.new(0, 28, 25))
	makePart(raft, "Missing Hull Gap", Vector3.new(4, 1.2, 8.4), Vector3.new(24, 4, -24), Color3.fromRGB(150, 35, 28), Enum.Material.SmoothPlastic)
	makePart(raft, "Bent Mast", Vector3.new(1, 9, 1), Vector3.new(24, 8, -24), Color3.fromRGB(96, 57, 33), Enum.Material.Wood, Vector3.new(0, 0, 12))
	makePart(raft, "Torn Sail Rag", Vector3.new(0.4, 3, 5), Vector3.new(25.5, 10, -21), Color3.fromRGB(199, 190, 164), Enum.Material.Fabric, Vector3.new(0, 0, 12))

	for index, zOffset in { -4.5, -2.5, -0.5, 1.5, 3.5 } do
		local plank = makePart(raft, `Repaired Deck Plank {index}`, Vector3.new(18, 0.9, 1.25), Vector3.new(24, 3.35, -24 + zOffset), Color3.fromRGB(128, 82, 45), Enum.Material.WoodPlanks)
		plank.Transparency = 1
		plank.CanCollide = false
	end

	local frontRail = makePart(raft, "Repaired Front Rail", Vector3.new(1, 2, 9), Vector3.new(15, 4.7, -24), Color3.fromRGB(92, 55, 32), Enum.Material.Wood)
	frontRail.Transparency = 1
	frontRail.CanCollide = false

	local backRail = makePart(raft, "Repaired Back Rail", Vector3.new(1, 2, 9), Vector3.new(33, 4.7, -24), Color3.fromRGB(92, 55, 32), Enum.Material.Wood)
	backRail.Transparency = 1
	backRail.CanCollide = false

	local mast = makePart(raft, "Repaired Mast", Vector3.new(1, 12, 1), Vector3.new(24, 9, -24), Color3.fromRGB(96, 57, 33), Enum.Material.Wood)
	mast.Transparency = 1
	mast.CanCollide = false

	local sail = makePart(raft, "Repaired Fibre Sail", Vector3.new(0.5, 9, 8), Vector3.new(25, 11, -20.5), Color3.fromRGB(235, 228, 198), Enum.Material.Fabric)
	sail.Transparency = 1
	sail.CanCollide = false

	local seat = Instance.new("VehicleSeat")
	seat.Name = "Raft Seat"
	seat.Anchored = true
	seat.Size = Vector3.new(3, 1, 3)
	seat.CFrame = CFrame.new(24, 4.4, -26)
	seat.Color = Color3.fromRGB(82, 52, 31)
	seat.Material = Enum.Material.Wood
	seat.Disabled = true
	seat.Transparency = 1
	seat.Parent = raft

	local boardZone = makePart(raft, "Board Click Zone", Vector3.new(22, 9, 16), Vector3.new(24, 7, -24), Color3.fromRGB(255, 255, 255), Enum.Material.SmoothPlastic)
	boardZone.Transparency = 1
	boardZone.CanCollide = false
	boardZone.CanTouch = false
	boardZone.CanQuery = false

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "RepairRaftPrompt"
	prompt.ActionText = "Repair"
	prompt.ObjectText = "Broken Raft: wood + plant fibres"
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 20
	prompt.KeyboardKeyCode = Enum.KeyCode.F
	prompt.Parent = repairZone

	local clickDetector = Instance.new("ClickDetector")
	clickDetector.Name = "RepairRaftClickDetector"
	clickDetector.MaxActivationDistance = 24
	clickDetector.Parent = repairZone

	local boardPrompt = Instance.new("ProximityPrompt")
	boardPrompt.Name = "BoardRaftPrompt"
	boardPrompt.ActionText = "Board"
	boardPrompt.ObjectText = "Repaired Raft"
	boardPrompt.Enabled = false
	boardPrompt.HoldDuration = 0
	boardPrompt.MaxActivationDistance = 18
	boardPrompt.KeyboardKeyCode = Enum.KeyCode.F
	boardPrompt.Parent = boardZone

	local boardClickDetector = Instance.new("ClickDetector")
	boardClickDetector.Name = "BoardRaftClickDetector"
	boardClickDetector.MaxActivationDistance = 0
	boardClickDetector.Parent = boardZone

	raft.PrimaryPart = seat
end

local function makeFirstMateNpc(parent: Instance)
	local npc = Instance.new("Model")
	npc.Name = "First Mate Finn"
	npc.Parent = parent

	local body = makePart(npc, "Body", Vector3.new(3, 5, 2), Vector3.new(-12, 8.5, 6), Color3.fromRGB(32, 84, 130), Enum.Material.SmoothPlastic)
	local head = makePart(npc, "Head", Vector3.new(2.5, 2.5, 2.5), Vector3.new(-12, 12.25, 6), Color3.fromRGB(226, 178, 121), Enum.Material.SmoothPlastic)
	makePart(npc, "Hat", Vector3.new(4, 0.6, 3), Vector3.new(-12, 13.8, 6), Color3.fromRGB(35, 29, 25), Enum.Material.SmoothPlastic)
	makePart(npc, "Wooden Axe Handle", Vector3.new(0.5, 5, 0.5), Vector3.new(-9.5, 9, 6), Color3.fromRGB(137, 92, 46), Enum.Material.Wood)
	makePart(npc, "Wooden Axe Head", Vector3.new(2, 1, 0.5), Vector3.new(-9.5, 11.4, 6), Color3.fromRGB(92, 70, 48), Enum.Material.Wood)

	npc.PrimaryPart = body

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "StarterToolPrompt"
	prompt.ActionText = "Talk"
	prompt.ObjectText = "First Mate Finn"
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.KeyboardKeyCode = Enum.KeyCode.F
	prompt.Parent = head
end

local function makeTree(parent: Instance, name: string, position: Vector3)
	local tree = Instance.new("Model")
	tree.Name = name
	tree:SetAttribute("IsChoppableTree", true)
	tree:SetAttribute("HitsRemaining", 3)
	tree:SetAttribute("WoodReward", 2)
	tree.Parent = parent

	local trunk = makePart(tree, "Trunk", Vector3.new(3, 12, 3), position + Vector3.new(0, 6, 0), Color3.fromRGB(103, 69, 37), Enum.Material.Wood)
	makePart(tree, "Leaves", Vector3.new(11, 9, 11), position + Vector3.new(0, 15, 0), Color3.fromRGB(50, 132, 65), Enum.Material.Grass)
	tree.PrimaryPart = trunk
end

local function makeShrub(parent: Instance, name: string, position: Vector3)
	local shrub = Instance.new("Model")
	shrub.Name = name
	shrub:SetAttribute("IsHarvestableShrub", true)
	shrub:SetAttribute("PlantFibreReward", 1)
	shrub.Parent = parent

	local leaves = makePart(shrub, "Leaves", Vector3.new(5, 3, 5), position + Vector3.new(0, 1.5, 0), Color3.fromRGB(62, 142, 70), Enum.Material.Grass)
	makePart(shrub, "Fibre Stems", Vector3.new(3, 2.5, 3), position + Vector3.new(0, 1, 0), Color3.fromRGB(151, 126, 66), Enum.Material.Grass)
	shrub.PrimaryPart = leaves

	local harvestZone = makePart(shrub, "Harvest Click Zone", Vector3.new(9, 7, 9), position + Vector3.new(0, 3, 0), Color3.fromRGB(255, 255, 255), Enum.Material.SmoothPlastic)
	harvestZone.Transparency = 1
	harvestZone.CanCollide = false
	harvestZone.CanTouch = false
	harvestZone.CanQuery = true

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "HarvestShrubPrompt"
	prompt.ActionText = "Gather Fibres"
	prompt.ObjectText = name
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 16
	prompt.KeyboardKeyCode = Enum.KeyCode.F
	prompt.Parent = harvestZone

	local clickDetector = Instance.new("ClickDetector")
	clickDetector.Name = "HarvestShrubClickDetector"
	clickDetector.MaxActivationDistance = 18
	clickDetector.Parent = harvestZone
end

function WorldBuilderService.Start()
	local existingWorld = Workspace:FindFirstChild(WORLD_FOLDER_NAME)

	if existingWorld then
		existingWorld:Destroy()
	end

	local world = Instance.new("Folder")
	world.Name = WORLD_FOLDER_NAME
	world.Parent = Workspace

	makeOcean(world)
	makePart(world, "Old Harbor Island", Vector3.new(54, 6, 46), Vector3.new(0, 3, 0), Color3.fromRGB(219, 194, 130), Enum.Material.Sand)
	makePart(world, "Old Harbor Dock", Vector3.new(10, 2, 36), Vector3.new(18, 4, -18), Color3.fromRGB(117, 76, 41), Enum.Material.WoodPlanks)
	makePart(world, "Coconut Cay", Vector3.new(42, 7, 34), Vector3.new(82, 3.5, -18), Color3.fromRGB(207, 184, 115), Enum.Material.Sand)
	makePart(world, "Sail Here Marker", Vector3.new(8, 10, 8), Vector3.new(82, 11, -18), Color3.fromRGB(42, 164, 92), Enum.Material.Neon)

	makeSpawn(world)
	makeTreasureChest(world)
	makeBrokenRaft(world)
	makeFirstMateNpc(world)
	makeTree(world, "Palm Tree 1", Vector3.new(-20, 6, -8))
	makeTree(world, "Palm Tree 2", Vector3.new(-18, 6, 16))
	makeTree(world, "Palm Tree 3", Vector3.new(8, 6, 16))
	makeShrub(world, "Beach Shrub 1", Vector3.new(-7, 6, -14))
	makeShrub(world, "Beach Shrub 2", Vector3.new(10, 6, 8))
	makeShrub(world, "Beach Shrub 3", Vector3.new(-4, 6, 18))

	print("Built visible pirate prototype world in Workspace.")
end

return WorldBuilderService
