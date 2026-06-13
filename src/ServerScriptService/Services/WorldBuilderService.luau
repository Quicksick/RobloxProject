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

local function makeBrokenRaft(parent: Instance)
	local raft = Instance.new("Model")
	raft.Name = "Broken Starter Raft"
	raft:SetAttribute("Repaired", false)
	raft.Parent = parent

	local base = makePart(raft, "Raft Base", Vector3.new(18, 1, 8), Vector3.new(24, 3, -24), Color3.fromRGB(92, 55, 32), Enum.Material.Wood)
	makePart(raft, "Missing Plank Marker", Vector3.new(4, 1.2, 8.4), Vector3.new(24, 4, -24), Color3.fromRGB(160, 45, 35), Enum.Material.SmoothPlastic)
	makePart(raft, "Small Mast", Vector3.new(1, 9, 1), Vector3.new(24, 8, -24), Color3.fromRGB(96, 57, 33), Enum.Material.Wood)

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "RepairRaftPrompt"
	prompt.ActionText = "Repair"
	prompt.ObjectText = "Broken Raft"
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 12
	prompt.KeyboardKeyCode = Enum.KeyCode.E
	prompt.Parent = base
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
	prompt.Name = "FirstWeaponPrompt"
	prompt.ActionText = "Talk"
	prompt.ObjectText = "First Mate Finn"
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.KeyboardKeyCode = Enum.KeyCode.E
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
	makeBrokenRaft(world)
	makeFirstMateNpc(world)
	makeTree(world, "Palm Tree 1", Vector3.new(-20, 6, -8))
	makeTree(world, "Palm Tree 2", Vector3.new(-18, 6, 16))
	makeTree(world, "Palm Tree 3", Vector3.new(8, 6, 16))

	print("Built visible pirate prototype world in Workspace.")
end

return WorldBuilderService
