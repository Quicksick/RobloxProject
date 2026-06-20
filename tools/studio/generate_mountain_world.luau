-- Run this in Roblox Studio's Command Bar while NOT in Play mode.
-- It creates smooth terrain: deep ocean valleys with island plateaus rising from underwater mountains.

local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain

local CLEAR_EXISTING_TERRAIN = true
local CREATE_MARKER_FOLDER = true

local function ensureFolder(parent: Instance, name: string)
	local existing = parent:FindFirstChild(name)

	if existing then
		existing:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent

	return folder
end

local function makeMarker(parent: Instance, name: string, position: Vector3, color: Color3)
	local marker = Instance.new("Part")
	marker.Name = name
	marker.Anchored = true
	marker.CanCollide = false
	marker.Size = Vector3.new(8, 12, 8)
	marker.Position = position
	marker.Color = color
	marker.Material = Enum.Material.Neon
	marker.Transparency = 0.25
	marker.Parent = parent
end

local function fillCylinder(position: Vector3, height: number, radius: number, material: Enum.Material)
	Terrain:FillCylinder(CFrame.new(position), height, radius, material)
end

local function fillIsland(name: string, center: Vector3, baseRadius: number, topRadius: number, topHeight: number, markerFolder: Instance?)
	-- Broad underwater seamount. Rock stays below water so the visible island does not look like a rock pile.
	Terrain:FillBall(Vector3.new(center.X, -58, center.Z), baseRadius * 1.7, Enum.Material.Rock)
	Terrain:FillBall(Vector3.new(center.X, -34, center.Z), baseRadius * 1.3, Enum.Material.Rock)
	Terrain:FillBall(Vector3.new(center.X, -14, center.Z), baseRadius * 0.95, Enum.Material.Sand)

	-- Smooth shoreline and playable plateau.
	fillCylinder(Vector3.new(center.X, 1, center.Z), 8, topRadius * 1.35, Enum.Material.Sand)
	fillCylinder(Vector3.new(center.X, 6, center.Z), 8, topRadius * 1.02, Enum.Material.Ground)
	fillCylinder(Vector3.new(center.X, topHeight, center.Z), 8, topRadius, Enum.Material.Grass)

	-- Soft hills on the plateau, not sharp peaks.
	Terrain:FillBall(Vector3.new(center.X - topRadius * 0.28, topHeight + 5, center.Z + topRadius * 0.1), topRadius * 0.42, Enum.Material.Grass)
	Terrain:FillBall(Vector3.new(center.X + topRadius * 0.25, topHeight + 4, center.Z - topRadius * 0.18), topRadius * 0.34, Enum.Material.Ground)

	if markerFolder then
		makeMarker(markerFolder, `{name} Marker`, Vector3.new(center.X, topHeight + 20, center.Z), Color3.fromRGB(46, 180, 92))
	end
end

local function carveValley(center: Vector3, radius: number)
	-- Wider water cuts between seamounts create clear island separation.
	Terrain:FillBall(center, radius, Enum.Material.Water)
	Terrain:FillBall(center - Vector3.new(0, 20, 0), radius * 1.15, Enum.Material.Water)
end

if CLEAR_EXISTING_TERRAIN then
	Terrain:Clear()
end

Terrain.WaterColor = Color3.fromRGB(19, 90, 135)
Terrain.WaterTransparency = 0.28
Terrain.WaterReflectance = 0.18
Terrain.WaterWaveSize = 0.65
Terrain.WaterWaveSpeed = 12

local markerFolder = if CREATE_MARKER_FOLDER then ensureFolder(Workspace, "GeneratedWorldMarkers") else nil

-- Deep ocean and distant floor.
Terrain:FillBlock(CFrame.new(0, -45, 0), Vector3.new(1300, 100, 1300), Enum.Material.Water)
Terrain:FillBlock(CFrame.new(0, -108, 0), Vector3.new(1300, 16, 1300), Enum.Material.Rock)

-- Underwater ridge linking the islands, kept well below the water surface.
for index = -5, 5 do
	local x = index * 72
	local z = math.sin(index * 0.85) * 42
	Terrain:FillBall(Vector3.new(x, -60, z), 88, Enum.Material.Rock)
end

-- Main playable islands: flatter tops, sandy shorelines, hills for shape.
fillIsland("Old Harbor", Vector3.new(0, 0, 0), 92, 46, 10, markerFolder)
fillIsland("Coconut Cay", Vector3.new(155, 0, -72), 74, 34, 8, markerFolder)
fillIsland("Driftwood Atoll", Vector3.new(-170, 0, -128), 78, 38, 8, markerFolder)
fillIsland("Mangrove Isle", Vector3.new(225, 0, 160), 88, 42, 9, markerFolder)
fillIsland("Skull Peak", Vector3.new(-265, 0, 172), 98, 44, 14, markerFolder)

-- Clear valleys/channels between islands.
carveValley(Vector3.new(78, -12, 48), 58)
carveValley(Vector3.new(-90, -12, 62), 64)
carveValley(Vector3.new(15, -14, -120), 58)
carveValley(Vector3.new(160, -14, 48), 68)
carveValley(Vector3.new(-210, -14, 20), 70)

-- Landing beaches, still mostly rounded by surrounding terrain.
fillCylinder(Vector3.new(20, 5, -34), 6, 30, Enum.Material.Sand)
fillCylinder(Vector3.new(142, 5, -96), 6, 24, Enum.Material.Sand)
fillCylinder(Vector3.new(-174, 5, -100), 6, 26, Enum.Material.Sand)
fillCylinder(Vector3.new(214, 5, 130), 6, 28, Enum.Material.Sand)

print("Generated smoother plateau island terrain in edit mode. Save/publish the place if you like this template.")
