local Workspace = game:GetService("Workspace")

local WorldBuilderService = {}

local WORLD_FOLDER_NAME = "PiratePrototypeWorld"

local function makePart(parent: Instance, name: string, size: Vector3, position: Vector3, color: Color3, material: Enum.Material)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.Position = position
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent

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

local function makeStarterShip(parent: Instance)
	local ship = Instance.new("Model")
	ship.Name = "Dockside Dinghy Placeholder"
	ship.Parent = parent

	makePart(ship, "Hull", Vector3.new(18, 3, 8), Vector3.new(24, 3, -24), Color3.fromRGB(92, 55, 32), Enum.Material.Wood)
	makePart(ship, "Deck", Vector3.new(14, 1, 6), Vector3.new(24, 5, -24), Color3.fromRGB(145, 95, 55), Enum.Material.WoodPlanks)
	makePart(ship, "Mast", Vector3.new(1, 16, 1), Vector3.new(24, 13, -24), Color3.fromRGB(96, 57, 33), Enum.Material.Wood)
	makePart(ship, "Sail", Vector3.new(1, 9, 8), Vector3.new(24, 14, -20), Color3.fromRGB(240, 234, 211), Enum.Material.Fabric)
end

local function makeFirstMateNpc(parent: Instance)
	local npc = Instance.new("Model")
	npc.Name = "First Mate Finn"
	npc.Parent = parent

	local body = makePart(npc, "Body", Vector3.new(3, 5, 2), Vector3.new(-12, 8.5, 6), Color3.fromRGB(32, 84, 130), Enum.Material.SmoothPlastic)
	local head = makePart(npc, "Head", Vector3.new(2.5, 2.5, 2.5), Vector3.new(-12, 12.25, 6), Color3.fromRGB(226, 178, 121), Enum.Material.SmoothPlastic)
	makePart(npc, "Hat", Vector3.new(4, 0.6, 3), Vector3.new(-12, 13.8, 6), Color3.fromRGB(35, 29, 25), Enum.Material.SmoothPlastic)
	makePart(npc, "Wooden Sword", Vector3.new(0.5, 5, 0.5), Vector3.new(-9.5, 9, 6), Color3.fromRGB(137, 92, 46), Enum.Material.Wood)

	npc.PrimaryPart = body

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "FirstWeaponPrompt"
	prompt.ActionText = "Talk"
	prompt.ObjectText = "First Mate Finn"
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.Parent = head
end

function WorldBuilderService.Start()
	local existingWorld = Workspace:FindFirstChild(WORLD_FOLDER_NAME)

	if existingWorld then
		existingWorld:Destroy()
	end

	local world = Instance.new("Folder")
	world.Name = WORLD_FOLDER_NAME
	world.Parent = Workspace

	makePart(world, "Ocean Prototype", Vector3.new(240, 1, 240), Vector3.new(0, 0, 0), Color3.fromRGB(26, 116, 173), Enum.Material.SmoothPlastic)
	makePart(world, "Old Harbor Island", Vector3.new(54, 6, 46), Vector3.new(0, 3, 0), Color3.fromRGB(219, 194, 130), Enum.Material.Sand)
	makePart(world, "Old Harbor Dock", Vector3.new(10, 2, 36), Vector3.new(18, 4, -18), Color3.fromRGB(117, 76, 41), Enum.Material.WoodPlanks)
	makePart(world, "Coconut Cay", Vector3.new(42, 7, 34), Vector3.new(82, 3.5, -18), Color3.fromRGB(207, 184, 115), Enum.Material.Sand)
	makePart(world, "Sail Here Marker", Vector3.new(8, 10, 8), Vector3.new(82, 11, -18), Color3.fromRGB(42, 164, 92), Enum.Material.Neon)

	makeSpawn(world)
	makeTreasureChest(world)
	makeStarterShip(world)
	makeFirstMateNpc(world)

	print("Built visible pirate prototype world in Workspace.")
end

return WorldBuilderService
