local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local StarterToolService = {}

local WORLD_FOLDER_NAME = SharedConfig.Map.GeneratedWorldName
local STUDIO_MAP_NAME = SharedConfig.Map.StudioMapName
local NPC_NAME = "First Mate Finn"
local TOOL_NAME = "Wooden Axe"
local RAFT_BASE_SPEED = 22
local RAFT_SPEED_PER_LEVEL = 8
local RAFT_TURN_SPEED = 70
local TREE_MAX_HITS = 4
local TREE_RESPAWN_SECONDS = 25
local LOG_PICKUP_DISTANCE = 9
local LOG_ATTRACTION_DISTANCE = 18
local LOG_ATTRACTION_SPEED = 24

local treeTemplatesByName = {}
local activeLogs = {}

local function makeWoodenAxe()
	local tool = Instance.new("Tool")
	tool.Name = TOOL_NAME
	tool.ToolTip = "Swing near trees to collect wood."
	tool.RequiresHandle = true

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.4, 4, 0.4)
	handle.Color = Color3.fromRGB(137, 92, 46)
	handle.Material = Enum.Material.Wood
	handle.Parent = tool

	local head = Instance.new("Part")
	head.Name = "AxeHead"
	head.Size = Vector3.new(1.8, 0.8, 0.4)
	head.Color = Color3.fromRGB(92, 70, 48)
	head.Material = Enum.Material.Wood
	head.CanCollide = false
	head.Parent = tool
	head.CFrame = handle.CFrame * CFrame.new(0, 1.8, 0)

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = handle
	weld.Part1 = head
	weld.Parent = handle

	return tool
end

local function getOrCreateToolTemplate()
	local existingTool = ServerStorage:FindFirstChild(TOOL_NAME)

	if existingTool then
		return existingTool
	end

	local tool = makeWoodenAxe()
	tool.Parent = ServerStorage

	return tool
end

local function getLeaderstat(player: Player, statName: string)
	local leaderstats = player:FindFirstChild("leaderstats")

	if not leaderstats then
		return nil
	end

	return leaderstats:FindFirstChild(statName)
end

local function playerHasTool(player: Player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	local character = player.Character

	return (backpack and backpack:FindFirstChild(TOOL_NAME) ~= nil)
		or (character and character:FindFirstChild(TOOL_NAME) ~= nil)
end

local function getWorld()
	return Workspace:FindFirstChild(STUDIO_MAP_NAME) or Workspace:FindFirstChild(WORLD_FOLDER_NAME)
end

local function findFirstBasePart(instance: Instance)
	if instance:IsA("BasePart") then
		return instance
	end

	for _, descendant in instance:GetDescendants() do
		if descendant:IsA("BasePart") then
			return descendant
		end
	end

	return nil
end

local function findNearestTree(position: Vector3)
	local world = getWorld()

	if not world then
		return nil
	end

	local nearestTree = nil
	local nearestDistance = 14

	for _, child in world:GetDescendants() do
		if child:IsA("Model") and child:GetAttribute("IsChoppableTree") then
			local primaryPart = child.PrimaryPart or findFirstBasePart(child)

			if primaryPart then
				child.PrimaryPart = primaryPart
				local distance = (primaryPart.Position - position).Magnitude

				if distance < nearestDistance then
					nearestTree = child
					nearestDistance = distance
				end
			end
		end
	end

	return nearestTree
end

local function rememberTreeTemplate(tree: Model)
	if treeTemplatesByName[tree.Name] then
		return
	end

	local clone = tree:Clone()
	clone.Parent = nil
	treeTemplatesByName[tree.Name] = clone
end

local function addWood(player: Player, amount: number)
	local wood = getLeaderstat(player, "Wood")

	if wood and wood:IsA("IntValue") then
		wood.Value += amount
	end
end

local function addPlantFibres(player: Player, amount: number)
	local plantFibres = getLeaderstat(player, "PlantFibres")

	if plantFibres and plantFibres:IsA("IntValue") then
		plantFibres.Value += amount
	end
end

local function setRaftLevelStat(player: Player, level: number)
	local raftLevel = getLeaderstat(player, "RaftLevel")

	if raftLevel and raftLevel:IsA("IntValue") then
		raftLevel.Value = level
	end
end

local function setAllRaftLevelStats(level: number)
	for _, player in Players:GetPlayers() do
		setRaftLevelStat(player, level)
	end
end

local function setTreePartsVisible(tree: Model, isVisible: boolean, canCollide: boolean)
	for _, descendant in tree:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Transparency = if isVisible then 0 else 1
			descendant.CanCollide = canCollide
			descendant.CanTouch = canCollide
			descendant.CanQuery = canCollide
		end
	end
end

local function shakeTree(tree: Model)
	local pivot = tree:GetPivot()

	task.spawn(function()
		for index = 1, 2 do
			local direction = if index == 1 then 1 else -1
			tree:PivotTo(pivot * CFrame.Angles(0, 0, math.rad(2.5 * direction)))
			task.wait(0.05)
		end

		if tree.Parent then
			tree:PivotTo(pivot)
		end
	end)
end

local function makeStump(parent: Instance, tree: Model)
	local primaryPart = tree.PrimaryPart or findFirstBasePart(tree)

	if not primaryPart then
		return nil
	end

	local stump = Instance.new("Part")
	stump.Name = `{tree.Name} Stump`
	stump.Anchored = true
	stump.Size = Vector3.new(3, 2, 3)
	stump.CFrame = CFrame.new(primaryPart.Position.X, primaryPart.Position.Y - 5, primaryPart.Position.Z)
	stump.Color = Color3.fromRGB(104, 68, 38)
	stump.Material = Enum.Material.Wood
	stump.Parent = parent

	return stump
end

local function spawnWoodLog(parent: Instance, position: Vector3, amount: number)
	local log = Instance.new("Part")
	log.Name = "Wood Log"
	log.Anchored = true
	log.Size = Vector3.new(2.4, 1, 1)
	log.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(math.random(0, 180)), math.rad(90))
	log.Color = Color3.fromRGB(126, 80, 43)
	log.Material = Enum.Material.Wood
	log:SetAttribute("WoodAmount", amount)
	log.Parent = parent

	table.insert(activeLogs, log)
end

local function removeActiveLog(log: BasePart)
	for index = #activeLogs, 1, -1 do
		if activeLogs[index] == log then
			table.remove(activeLogs, index)
			return
		end
	end
end

local function findNearestPlayerToLog(log: BasePart)
	local nearestPlayer = nil
	local nearestRoot = nil
	local nearestDistance = LOG_ATTRACTION_DISTANCE

	for _, player in Players:GetPlayers() do
		local character = player.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if rootPart and rootPart:IsA("BasePart") and humanoid and humanoid.Health > 0 then
			local distance = (rootPart.Position - log.Position).Magnitude

			if distance < nearestDistance then
				nearestPlayer = player
				nearestRoot = rootPart
				nearestDistance = distance
			end
		end
	end

	return nearestPlayer, nearestRoot, nearestDistance
end

local function updateWoodLogs(deltaTime: number)
	for index = #activeLogs, 1, -1 do
		local log = activeLogs[index]

		if not log.Parent then
			table.remove(activeLogs, index)
			continue
		end

		local player, rootPart, distance = findNearestPlayerToLog(log)

		if player and rootPart then
			if distance <= LOG_PICKUP_DISTANCE then
				addWood(player, log:GetAttribute("WoodAmount") or 1)
				removeActiveLog(log)
				log:Destroy()
			else
				local direction = (rootPart.Position - log.Position).Unit
				local step = math.min(LOG_ATTRACTION_SPEED * deltaTime, distance - LOG_PICKUP_DISTANCE)
				log.CFrame = log.CFrame + (direction * step)
			end
		end
	end
end

local function spawnWoodLogs(tree: Model, reward: number)
	local primaryPart = tree.PrimaryPart or findFirstBasePart(tree)
	local parent = tree.Parent

	if not (primaryPart and parent) then
		return
	end

	for index = 1, reward do
		local angle = (math.pi * 2 / math.max(reward, 1)) * index
		local offset = Vector3.new(math.cos(angle) * 4, 1.5, math.sin(angle) * 4)
		spawnWoodLog(parent, primaryPart.Position + offset, 1)
	end
end

local function regrowTree(parent: Instance, treeName: string, stump: Instance?)
	local template = treeTemplatesByName[treeName]

	task.delay(TREE_RESPAWN_SECONDS, function()
		if stump then
			stump:Destroy()
		end

		if template and parent.Parent then
			local newTree = template:Clone()
			newTree:SetAttribute("HitsRemaining", TREE_MAX_HITS)
			newTree:SetAttribute("IsFalling", false)
			setTreePartsVisible(newTree, true, true)
			newTree.Parent = parent
		end
	end)
end

local function toppleTree(tree: Model)
	if tree:GetAttribute("IsFalling") then
		return
	end

	tree:SetAttribute("IsFalling", true)
	rememberTreeTemplate(tree)

	local parent = tree.Parent
	local treeName = tree.Name
	local reward = tree:GetAttribute("WoodReward") or 1
	local stump = if parent then makeStump(parent, tree) else nil
	local startPivot = tree:GetPivot()
	local fallPivot = startPivot * CFrame.Angles(math.rad(78), 0, math.rad(math.random(-12, 12))) * CFrame.new(0, -3, -8)
	local pivotValue = Instance.new("CFrameValue")
	pivotValue.Value = startPivot

	local connection = pivotValue.Changed:Connect(function(value)
		if tree.Parent then
			tree:PivotTo(value)
		end
	end)

	local tween = TweenService:Create(pivotValue, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Value = fallPivot,
	})

	tween:Play()
	tween.Completed:Connect(function()
		connection:Disconnect()
		pivotValue:Destroy()
		spawnWoodLogs(tree, reward)
		setTreePartsVisible(tree, false, false)
		tree.Parent = nil

		if parent then
			regrowTree(parent, treeName, stump)
		end
	end)
end

local function chopTree(player: Player)
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")

	if not rootPart then
		return
	end

	local tree = findNearestTree(rootPart.Position)

	if not tree then
		print(`{player.Name} swung the axe, but no tree was close enough.`)
		return
	end

	if tree:GetAttribute("IsFalling") then
		return
	end

	rememberTreeTemplate(tree)

	local hitsRemaining = tree:GetAttribute("HitsRemaining") or TREE_MAX_HITS
	hitsRemaining -= 1
	tree:SetAttribute("HitsRemaining", hitsRemaining)
	shakeTree(tree)

	if hitsRemaining > 0 then
		print(`{player.Name} chopped {tree.Name}. {hitsRemaining} hits left.`)
		return
	end

	print(`{player.Name} chopped down {tree.Name}.`)
	toppleTree(tree)
end

local function connectAxe(tool: Tool, player: Player)
	tool.Activated:Connect(function()
		chopTree(player)
	end)
end

local function setToolStat(player: Player)
	local toolStat = getLeaderstat(player, "Tool")

	if toolStat and toolStat:IsA("StringValue") then
		toolStat.Value = TOOL_NAME
	end
end

local function giveWoodenAxe(player: Player)
	if player:GetAttribute("HasStarterTool") then
		return
	end

	local backpack = player:FindFirstChildOfClass("Backpack")

	if not backpack then
		return
	end

	if not playerHasTool(player) then
		local tool = getOrCreateToolTemplate():Clone()
		connectAxe(tool, player)
		tool.Parent = backpack
	end

	player:SetAttribute("HasStarterTool", true)
	setToolStat(player)
	print(`First Mate Finn gave {player.Name} a Wooden Axe.`)
end

local function setVisible(part: Instance?, isVisible: boolean, canCollide: boolean?)
	if not (part and part:IsA("BasePart")) then
		return
	end

	part.Transparency = if isVisible then 0 else 1
	part.CanCollide = canCollide == true
end

local function showRepairedRaft(raft: Model)
	for _, partName in {
		"Broken Plank Left",
		"Broken Plank Middle",
		"Broken Plank Right",
		"Snapped Plank",
		"Bent Mast",
		"Torn Sail Rag",
	} do
		setVisible(raft:FindFirstChild(partName), false, false)
	end

	setVisible(raft:FindFirstChild("Repair Spot"), false, false)

	local missingHullGap = raft:FindFirstChild("Missing Hull Gap")

	if missingHullGap and missingHullGap:IsA("BasePart") then
		missingHullGap.Name = "Repaired Hull Patch"
		missingHullGap.Color = Color3.fromRGB(128, 82, 45)
		missingHullGap.Material = Enum.Material.WoodPlanks
		setVisible(missingHullGap, true, true)
	end

	for _, child in raft:GetChildren() do
		if child:IsA("BasePart") and child.Name:match("^Repaired") then
			setVisible(child, true, true)
		end
	end

	local seat = raft:FindFirstChild("Raft Seat")

	if seat and seat:IsA("VehicleSeat") then
		seat.Disabled = false
		seat.Transparency = 0
		seat.CanCollide = true
	end

	local boardZone = raft:FindFirstChild("Board Click Zone")

	if boardZone and boardZone:IsA("BasePart") then
		boardZone.CanQuery = true
	end

	local boardPrompt = boardZone and boardZone:FindFirstChild("BoardRaftPrompt")
	local boardClickDetector = boardZone and boardZone:FindFirstChild("BoardRaftClickDetector")

	if boardPrompt and boardPrompt:IsA("ProximityPrompt") then
		boardPrompt.Enabled = true
	end

	if boardClickDetector and boardClickDetector:IsA("ClickDetector") then
		boardClickDetector.MaxActivationDistance = 24
	end

	local upgradeZone = raft:FindFirstChild("Upgrade Click Zone")

	if upgradeZone and upgradeZone:IsA("BasePart") then
		upgradeZone.CanQuery = true
	end

	for _, partName in { "Upgrade Post", "Upgrade Sign" } do
		setVisible(raft:FindFirstChild(partName), true, true)
	end

	local upgradePrompt = upgradeZone and upgradeZone:FindFirstChild("UpgradeRaftPrompt")
	local upgradeClickDetector = upgradeZone and upgradeZone:FindFirstChild("UpgradeRaftClickDetector")

	if upgradePrompt and upgradePrompt:IsA("ProximityPrompt") then
		upgradePrompt.Enabled = true
	end

	if upgradeClickDetector and upgradeClickDetector:IsA("ClickDetector") then
		upgradeClickDetector.MaxActivationDistance = 24
	end
end

local function updateUpgradePrompt(raft: Model)
	local upgradeZone = raft:FindFirstChild("Upgrade Click Zone")
	local upgradePrompt = upgradeZone and upgradeZone:FindFirstChild("UpgradeRaftPrompt")
	local level = raft:GetAttribute("UpgradeLevel") or 0
	local nextLevel = level + 1
	local cost = SharedConfig.RaftUpgradeCosts[nextLevel]

	if not (upgradePrompt and upgradePrompt:IsA("ProximityPrompt")) then
		return
	end

	if not cost then
		upgradePrompt.ActionText = "Fully Upgraded"
		upgradePrompt.ObjectText = "Raft Complete"
		upgradePrompt.Enabled = false
		return
	end

	upgradePrompt.ActionText = `Upgrade {nextLevel}/3`
	upgradePrompt.ObjectText = `{cost.Wood} wood + {cost.PlantFibres} fibres`
end

local function showRaftUpgradeLevel(raft: Model, level: number)
	for _, child in raft:GetChildren() do
		if child:IsA("BasePart") then
			local tier = child.Name:match("^Upgrade Tier (%d)")

			if tier and tonumber(tier) <= level then
				setVisible(child, true, true)
			end
		end
	end
end

local function repairRaft(player: Player)
	local wood = getLeaderstat(player, "Wood")
	local plantFibres = getLeaderstat(player, "PlantFibres")

	if not (wood and wood:IsA("IntValue") and plantFibres and plantFibres:IsA("IntValue")) then
		return
	end

	if wood.Value < SharedConfig.RaftRepairWoodCost then
		print(`{player.Name} needs {SharedConfig.RaftRepairWoodCost} wood to repair the raft.`)
		return
	end

	if plantFibres.Value < SharedConfig.RaftRepairPlantFibreCost then
		print(`{player.Name} needs {SharedConfig.RaftRepairPlantFibreCost} plant fibres to make the sail.`)
		return
	end

	local world = getWorld()
	local raft = world and world:FindFirstChild("Broken Starter Raft")

	if not raft or raft:GetAttribute("Repaired") then
		return
	end

	wood.Value -= SharedConfig.RaftRepairWoodCost
	plantFibres.Value -= SharedConfig.RaftRepairPlantFibreCost
	raft:SetAttribute("Repaired", true)

	showRepairedRaft(raft)
	updateUpgradePrompt(raft)

	local promptPart = raft:FindFirstChild("Repair Click Zone")
	local prompt = promptPart and promptPart:FindFirstChild("RepairRaftPrompt")
	local clickDetector = promptPart and promptPart:FindFirstChild("RepairRaftClickDetector")

	if prompt and prompt:IsA("ProximityPrompt") then
		prompt.ActionText = "Repaired"
		prompt.Enabled = false
	end

	if clickDetector and clickDetector:IsA("ClickDetector") then
		clickDetector.MaxActivationDistance = 0
	end

	print(`{player.Name} repaired the starter raft with wood and made a sail from plant fibres.`)
end

local function upgradeRaft(player: Player)
	local world = getWorld()
	local raft = world and world:FindFirstChild("Broken Starter Raft")

	if not raft or not raft:GetAttribute("Repaired") then
		print("Repair the raft before upgrading it.")
		return
	end

	local currentLevel = raft:GetAttribute("UpgradeLevel") or 0
	local nextLevel = currentLevel + 1
	local cost = SharedConfig.RaftUpgradeCosts[nextLevel]

	if not cost then
		print("The raft is fully upgraded.")
		return
	end

	local wood = getLeaderstat(player, "Wood")
	local plantFibres = getLeaderstat(player, "PlantFibres")

	if not (wood and wood:IsA("IntValue") and plantFibres and plantFibres:IsA("IntValue")) then
		return
	end

	if wood.Value < cost.Wood or plantFibres.Value < cost.PlantFibres then
		print(`Upgrade {nextLevel} needs {cost.Wood} wood and {cost.PlantFibres} plant fibres.`)
		return
	end

	wood.Value -= cost.Wood
	plantFibres.Value -= cost.PlantFibres
	raft:SetAttribute("UpgradeLevel", nextLevel)
	setAllRaftLevelStats(nextLevel)
	showRaftUpgradeLevel(raft, nextLevel)
	updateUpgradePrompt(raft)

	local upgradeZone = raft:FindFirstChild("Upgrade Click Zone")
	local upgradeClickDetector = upgradeZone and upgradeZone:FindFirstChild("UpgradeRaftClickDetector")

	if nextLevel >= 3 and upgradeClickDetector and upgradeClickDetector:IsA("ClickDetector") then
		upgradeClickDetector.MaxActivationDistance = 0
	end

	print(`{player.Name} upgraded the raft to level {nextLevel}.`)
end

local function boardRaft(player: Player, raft: Model)
	if not raft:GetAttribute("Repaired") then
		return
	end

	local seat = raft:FindFirstChild("Raft Seat")
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not (seat and seat:IsA("VehicleSeat") and humanoid) then
		return
	end

	seat:Sit(humanoid)
end

local function startRaftDriving(raft: Model)
	local seat = raft:WaitForChild("Raft Seat")

	if not seat:IsA("VehicleSeat") then
		return
	end

	RunService.Heartbeat:Connect(function(deltaTime)
		if not raft.Parent or not raft:GetAttribute("Repaired") or not seat.Occupant then
			return
		end

		local throttle = seat.Throttle
		local steer = seat.Steer

		if throttle == 0 and steer == 0 then
			return
		end

		local upgradeLevel = raft:GetAttribute("UpgradeLevel") or 0
		local currentSpeed = RAFT_BASE_SPEED + (upgradeLevel * RAFT_SPEED_PER_LEVEL)
		local currentPivot = raft:GetPivot()
		local turn = math.rad(-steer * RAFT_TURN_SPEED * deltaTime)
		local distance = -throttle * currentSpeed * deltaTime
		local nextPivot = currentPivot * CFrame.Angles(0, turn, 0) * CFrame.new(0, 0, distance)

		raft:PivotTo(nextPivot)
	end)
end

local function harvestShrub(player: Player, shrub: Model)
	if not shrub.Parent then
		return
	end

	if not shrub:GetAttribute("IsHarvestableShrub") then
		return
	end

	local reward = shrub:GetAttribute("PlantFibreReward") or 1
	addPlantFibres(player, reward)
	print(`{player.Name} gathered {reward} plant fibre from {shrub.Name}.`)
	shrub:Destroy()
end

local function connectShrub(shrub: Model)
	local primaryPart = shrub.PrimaryPart
	local harvestZone = shrub:FindFirstChild("Harvest Click Zone")
	local interactionPart = if harvestZone and harvestZone:IsA("BasePart") then harvestZone else primaryPart

	if not interactionPart then
		return
	end

	local shrubPrompt = interactionPart:FindFirstChild("HarvestShrubPrompt")
	local clickDetector = interactionPart:FindFirstChild("HarvestShrubClickDetector")

	if shrubPrompt and shrubPrompt:IsA("ProximityPrompt") then
		shrubPrompt.Triggered:Connect(function(player)
			harvestShrub(player, shrub)
		end)
	end

	if clickDetector and clickDetector:IsA("ClickDetector") then
		clickDetector.MouseClick:Connect(function(player)
			harvestShrub(player, shrub)
		end)
	end
end

function StarterToolService.Start()
	local world = getWorld()

	if not world then
		warn(`StarterToolService did not find Workspace.{STUDIO_MAP_NAME} or Workspace.{WORLD_FOLDER_NAME}. Map interactions are disabled until the map exists.`)
		return
	end

	RunService.Heartbeat:Connect(updateWoodLogs)

	local npc = world:FindFirstChild(NPC_NAME)

	if not npc then
		warn(`StarterToolService did not find {NPC_NAME}. Add the NPC model to your Studio map to enable the starter axe interaction.`)
	else
		local head = npc:WaitForChild("Head")
		local prompt = head:WaitForChild("StarterToolPrompt")

		prompt.ActionText = "Get Axe"
		prompt.Triggered:Connect(giveWoodenAxe)
	end

	local raft = world:FindFirstChild("Broken Starter Raft")

	if not raft then
		warn("StarterToolService did not find Broken Starter Raft. Raft repair, boarding, and upgrades are disabled until the raft model exists.")
	else
		local raftRepairZone = raft:WaitForChild("Repair Click Zone")
		local raftPrompt = raftRepairZone:WaitForChild("RepairRaftPrompt")
		local raftClickDetector = raftRepairZone:WaitForChild("RepairRaftClickDetector")
		local boardZone = raft:WaitForChild("Board Click Zone")
		local boardPrompt = boardZone:WaitForChild("BoardRaftPrompt")
		local boardClickDetector = boardZone:WaitForChild("BoardRaftClickDetector")
		local upgradeZone = raft:WaitForChild("Upgrade Click Zone")
		local upgradePrompt = upgradeZone:WaitForChild("UpgradeRaftPrompt")
		local upgradeClickDetector = upgradeZone:WaitForChild("UpgradeRaftClickDetector")

		raftPrompt.Triggered:Connect(repairRaft)
		raftClickDetector.MouseClick:Connect(repairRaft)
		boardPrompt.Triggered:Connect(function(player)
			boardRaft(player, raft)
		end)
		boardClickDetector.MouseClick:Connect(function(player)
			boardRaft(player, raft)
		end)
		upgradePrompt.Triggered:Connect(upgradeRaft)
		upgradeClickDetector.MouseClick:Connect(upgradeRaft)
		startRaftDriving(raft)
	end

	for _, child in world:GetChildren() do
		if child:IsA("Model") and child:GetAttribute("IsHarvestableShrub") then
			connectShrub(child)
		end
	end

	print("First Mate Finn is ready to give new pirates a Wooden Axe.")
end

return StarterToolService
