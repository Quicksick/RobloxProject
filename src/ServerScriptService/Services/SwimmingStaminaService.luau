local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SwimmingStaminaService = {}

local MAX_STAMINA = 100
local SWIM_DRAIN_PER_SECOND = 12
local LAND_RECOVER_PER_SECOND = 25
local DROWNING_DAMAGE_PER_SECOND = 18

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

local function isSwimming(humanoid: Humanoid)
	return humanoid:GetState() == Enum.HumanoidStateType.Swimming
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

			if isSwimming(humanoid) then
				stamina -= SWIM_DRAIN_PER_SECOND * deltaTime
				setStamina(player, stamina)

				if stamina <= 0 then
					humanoid:TakeDamage(DROWNING_DAMAGE_PER_SECOND * deltaTime)
				end
			else
				setStamina(player, stamina + (LAND_RECOVER_PER_SECOND * deltaTime))
			end
		end
	end)
end

return SwimmingStaminaService
