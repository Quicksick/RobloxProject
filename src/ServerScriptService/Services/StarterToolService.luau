local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local SharedConfig = require(ReplicatedStorage:WaitForChild("SharedConfig"))

local StarterToolService = {}

local WORLD_FOLDER_NAME = "PiratePrototypeWorld"
local NPC_NAME = "First Mate Finn"
local TOOL_NAME = "Wooden Axe"

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

local function findNearestTree(position: Vector3)
	local world = Workspace:FindFirstChild(WORLD_FOLDER_NAME)

	if not world then
		return nil
	end

	local nearestTree = nil
	local nearestDistance = 14

	for _, child in world:GetChildren() do
		if child:IsA("Model") and child:GetAttribute("IsChoppableTree") then
			local primaryPart = child.PrimaryPart

			if primaryPart then
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

local function addWood(player: Player, amount: number)
	local wood = getLeaderstat(player, "Wood")

	if wood and wood:IsA("IntValue") then
		wood.Value += amount
	end
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

	local hitsRemaining = tree:GetAttribute("HitsRemaining") or 1
	hitsRemaining -= 1
	tree:SetAttribute("HitsRemaining", hitsRemaining)

	if hitsRemaining > 0 then
		print(`{player.Name} chopped {tree.Name}. {hitsRemaining} hits left.`)
		return
	end

	local reward = tree:GetAttribute("WoodReward") or 1
	addWood(player, reward)
	print(`{player.Name} chopped down {tree.Name} and collected {reward} wood.`)
	tree:Destroy()
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

local function repairRaft(player: Player)
	local wood = getLeaderstat(player, "Wood")

	if not (wood and wood:IsA("IntValue")) then
		return
	end

	if wood.Value < SharedConfig.RaftRepairWoodCost then
		print(`{player.Name} needs {SharedConfig.RaftRepairWoodCost} wood to repair the raft.`)
		return
	end

	local world = Workspace:FindFirstChild(WORLD_FOLDER_NAME)
	local raft = world and world:FindFirstChild("Broken Starter Raft")

	if not raft or raft:GetAttribute("Repaired") then
		return
	end

	wood.Value -= SharedConfig.RaftRepairWoodCost
	raft:SetAttribute("Repaired", true)

	local marker = raft:FindFirstChild("Missing Plank Marker")

	if marker and marker:IsA("BasePart") then
		marker.Color = Color3.fromRGB(145, 95, 55)
		marker.Material = Enum.Material.WoodPlanks
		marker.Name = "Repaired Planks"
	end

	local promptPart = raft:FindFirstChild("Raft Base")
	local prompt = promptPart and promptPart:FindFirstChild("RepairRaftPrompt")

	if prompt and prompt:IsA("ProximityPrompt") then
		prompt.ActionText = "Repaired"
		prompt.Enabled = false
	end

	print(`{player.Name} repaired the starter raft.`)
end

function StarterToolService.Start()
	local world = Workspace:WaitForChild(WORLD_FOLDER_NAME)
	local npc = world:WaitForChild(NPC_NAME)
	local head = npc:WaitForChild("Head")
	local prompt = head:WaitForChild("FirstWeaponPrompt")
	local raft = world:WaitForChild("Broken Starter Raft")
	local raftBase = raft:WaitForChild("Raft Base")
	local raftPrompt = raftBase:WaitForChild("RepairRaftPrompt")

	prompt.ActionText = "Get Axe"
	prompt.Triggered:Connect(giveWoodenAxe)
	raftPrompt.Triggered:Connect(repairRaft)

	print("First Mate Finn is ready to give new pirates a Wooden Axe.")
end

return StarterToolService
