local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SwimmingStaminaService = {}

local MAX_STAMINA = 100
local SWIM_DRAIN_PER_SECOND = 12
local LAND_RECOVER_PER_SECOND = 25
local DROWNING_DAMAGE_PER_SECOND = 18
local OCEAN_SURFACE_Y = 3

local function setStamina(player: Player, value: number)
	player:SetAttribute("SwimStamina", math.clamp(value, 0, MAX_STAMINA))
end

local function getStamina(player: Player)
	local stamina = player:GetAttribute("SwimStamina")

	if typeof(stamina) == "number" then
		return stamina
	end

	return MAX_STAMINA
end

local function isInOcean(humanoid: Humanoid)
	local character = humanoid.Parent
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")

	if humanoid:GetState() == Enum.HumanoidStateType.Swimming then
		return true
	end

	if humanoid.FloorMaterial == Enum.Material.Water then
		return true
	end

	if rootPart and rootPart:IsA("BasePart") and rootPart.Position.Y < OCEAN_SURFACE_Y then
		return true
	end

	return false
end

local function setupPlayer(player: Player)
	player:SetAttribute("MaxSwimStamina", MAX_STAMINA)
	setStamina(player, MAX_STAMINA)

	player.CharacterAdded:Connect(function()
		setStamina(player, MAX_STAMINA)
	end)
end

function SwimmingStaminaService.Start()
	Players.PlayerAdded:Connect(setupPlayer)

	for _, player in Players:GetPlayers() do
		setupPlayer(player)
	end

	RunService.Heartbeat:Connect(function(deltaTime)
		for _, player in Players:GetPlayers() do
			local character = player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if not humanoid or humanoid.Health <= 0 then
				continue
			end

			local stamina = getStamina(player)

			if isInOcean(humanoid) then
				player:SetAttribute("IsInOcean", true)
				stamina -= SWIM_DRAIN_PER_SECOND * deltaTime
				setStamina(player, stamina)

				if stamina <= 0 then
					humanoid:TakeDamage(DROWNING_DAMAGE_PER_SECOND * deltaTime)
				end
			else
				player:SetAttribute("IsInOcean", false)
				setStamina(player, stamina + (LAND_RECOVER_PER_SECOND * deltaTime))
			end
		end
	end)
end

return SwimmingStaminaService
