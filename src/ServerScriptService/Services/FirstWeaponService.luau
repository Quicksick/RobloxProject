local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local FirstWeaponService = {}

local WORLD_FOLDER_NAME = "PiratePrototypeWorld"
local NPC_NAME = "First Mate Finn"

local function makeWoodenSword()
	local tool = Instance.new("Tool")
	tool.Name = "Wooden Sword"
	tool.ToolTip = "A starter blade from First Mate Finn."
	tool.RequiresHandle = true

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.4, 4, 0.4)
	handle.Color = Color3.fromRGB(137, 92, 46)
	handle.Material = Enum.Material.Wood
	handle.Parent = tool

	return tool
end

local function getOrCreateWeaponTemplate()
	local existingTool = ServerStorage:FindFirstChild("Wooden Sword")

	if existingTool then
		return existingTool
	end

	local tool = makeWoodenSword()
	tool.Parent = ServerStorage

	return tool
end

local function playerHasWeapon(player: Player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	local character = player.Character

	return (backpack and backpack:FindFirstChild("Wooden Sword") ~= nil)
		or (character and character:FindFirstChild("Wooden Sword") ~= nil)
end

local function setWeaponStat(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats")

	if not leaderstats then
		return
	end

	local weapon = leaderstats:FindFirstChild("Weapon")

	if weapon and weapon:IsA("StringValue") then
		weapon.Value = "Wooden Sword"
	end
end

local function giveWoodenSword(player: Player)
	if player:GetAttribute("HasFirstWeapon") then
		return
	end

	local backpack = player:FindFirstChildOfClass("Backpack")

	if not backpack then
		return
	end

	if not playerHasWeapon(player) then
		local tool = getOrCreateWeaponTemplate():Clone()
		tool.Parent = backpack
	end

	player:SetAttribute("HasFirstWeapon", true)
	setWeaponStat(player)
	print(`First Mate Finn gave {player.Name} a Wooden Sword.`)
end

function FirstWeaponService.Start()
	local world = Workspace:WaitForChild(WORLD_FOLDER_NAME)
	local npc = world:WaitForChild(NPC_NAME)
	local head = npc:WaitForChild("Head")
	local prompt = head:WaitForChild("FirstWeaponPrompt")

	prompt.Triggered:Connect(giveWoodenSword)
	print("First Mate Finn is ready to give new pirates a Wooden Sword.")
end

return FirstWeaponService
