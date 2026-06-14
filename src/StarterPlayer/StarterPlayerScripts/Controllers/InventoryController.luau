local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local InventoryController = {}

local player = Players.LocalPlayer

local screenGui: ScreenGui?
local panel: Frame?
local rows = {}

local function makeText(parent: Instance, name: string, text: string, size: UDim2, position: UDim2)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = size
	label.Position = position
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.Text = text
	label.TextColor3 = Color3.fromRGB(246, 241, 226)
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent

	return label
end

local function makeResourceRow(parent: Instance, statName: string, displayName: string, order: number)
	local row = Instance.new("Frame")
	row.Name = `{statName}Row`
	row.Size = UDim2.fromOffset(260, 42)
	row.Position = UDim2.fromOffset(20, 58 + ((order - 1) * 48))
	row.BackgroundColor3 = Color3.fromRGB(82, 59, 38)
	row.BorderSizePixel = 0
	row.Parent = parent

	local nameLabel = makeText(row, "Name", displayName, UDim2.fromOffset(160, 42), UDim2.fromOffset(12, 0))
	nameLabel.TextSize = 16

	local amountLabel = makeText(row, "Amount", "0", UDim2.fromOffset(70, 42), UDim2.fromOffset(180, 0))
	amountLabel.Font = Enum.Font.GothamBold
	amountLabel.TextXAlignment = Enum.TextXAlignment.Right

	rows[statName] = amountLabel
end

local function updateResource(statName: string)
	local leaderstats = player:FindFirstChild("leaderstats")
	local stat = leaderstats and leaderstats:FindFirstChild(statName)
	local amountLabel = rows[statName]

	if amountLabel and stat and stat:IsA("IntValue") then
		if statName == "RaftLevel" then
			amountLabel.Text = `{stat.Value}/3`
		else
			amountLabel.Text = tostring(stat.Value)
		end
	end
end

local function connectResource(statName: string)
	local leaderstats = player:WaitForChild("leaderstats")
	local stat = leaderstats:WaitForChild(statName)

	if stat:IsA("IntValue") then
		stat.Changed:Connect(function()
			updateResource(statName)
		end)

		updateResource(statName)
	end
end

local function setOpen(isOpen: boolean)
	if panel then
		panel.Visible = isOpen
	end
end

local function toggle()
	if panel then
		setOpen(not panel.Visible)
	end
end

local function buildGui()
	local playerGui = player:WaitForChild("PlayerGui")

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PirateInventoryGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	panel = Instance.new("Frame")
	panel.Name = "InventoryPanel"
	panel.Size = UDim2.fromOffset(300, 270)
	panel.Position = UDim2.new(1, -320, 0, 80)
	panel.BackgroundColor3 = Color3.fromRGB(49, 35, 24)
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = screenGui

	local title = makeText(panel, "Title", "Inventory", UDim2.fromOffset(220, 42), UDim2.fromOffset(20, 10))
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22

	local hint = makeText(panel, "Hint", "Press E to open or close", UDim2.fromOffset(260, 28), UDim2.fromOffset(20, 228))
	hint.TextColor3 = Color3.fromRGB(204, 189, 160)
	hint.TextSize = 14

	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.fromOffset(34, 34)
	closeButton.Position = UDim2.fromOffset(246, 10)
	closeButton.BackgroundColor3 = Color3.fromRGB(112, 64, 42)
	closeButton.BorderSizePixel = 0
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 246, 226)
	closeButton.TextSize = 18
	closeButton.Parent = panel
	closeButton.Activated:Connect(function()
		setOpen(false)
	end)

	makeResourceRow(panel, "Wood", "Wood", 1)
	makeResourceRow(panel, "PlantFibres", "Plant Fibres", 2)
	makeResourceRow(panel, "RaftLevel", "Raft Level", 3)
end

function InventoryController.Start()
	buildGui()
	connectResource("Wood")
	connectResource("PlantFibres")
	connectResource("RaftLevel")

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.KeyCode == Enum.KeyCode.E then
			toggle()
		end
	end)
end

return InventoryController
