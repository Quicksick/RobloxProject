local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local StaminaController = {}

local player = Players.LocalPlayer

local panel: Frame?
local fill: Frame?
local label: TextLabel?

local function updateBar()
	if not (panel and fill and label) then
		return
	end

	local maxStamina = player:GetAttribute("MaxSwimStamina") or 100
	local stamina = player:GetAttribute("SwimStamina") or maxStamina
	local isInOcean = player:GetAttribute("IsInOcean") == true
	local percent = math.clamp(stamina / maxStamina, 0, 1)

	fill.Size = UDim2.new(percent, 0, 1, 0)
	label.Text = if stamina <= 0 then "Drowning!" else `Swim Stamina {math.floor(stamina)} / {maxStamina}`
	panel.Visible = isInOcean or percent < 0.99

	if percent < 0.25 then
		fill.BackgroundColor3 = Color3.fromRGB(204, 57, 43)
	elseif percent < 0.5 then
		fill.BackgroundColor3 = Color3.fromRGB(224, 151, 45)
	else
		fill.BackgroundColor3 = Color3.fromRGB(57, 158, 219)
	end
end

local function blockOceanJump()
	if player:GetAttribute("IsInOcean") ~= true then
		return
	end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.Jump = false
	end
end

local function buildGui()
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SwimStaminaGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	panel = Instance.new("Frame")
	panel.Name = "StaminaPanel"
	panel.Size = UDim2.fromOffset(320, 44)
	panel.Position = UDim2.new(0.5, -160, 1, -92)
	panel.BackgroundColor3 = Color3.fromRGB(29, 36, 42)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = screenGui

	fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.fromScale(1, 1)
	fill.BackgroundColor3 = Color3.fromRGB(57, 158, 219)
	fill.BorderSizePixel = 0
	fill.Parent = panel

	label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.Text = "Swim Stamina"
	label.TextColor3 = Color3.fromRGB(246, 241, 226)
	label.TextSize = 16
	label.Parent = panel
end

function StaminaController.Start()
	buildGui()
	updateBar()

	player:GetAttributeChangedSignal("SwimStamina"):Connect(updateBar)
	player:GetAttributeChangedSignal("MaxSwimStamina"):Connect(updateBar)
	player:GetAttributeChangedSignal("IsInOcean"):Connect(updateBar)
	UserInputService.JumpRequest:Connect(blockOceanJump)
end

return StaminaController
