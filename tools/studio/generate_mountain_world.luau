-- Run this in Roblox Studio's Command Bar while NOT in Play mode.
-- It creates smooth terrain: deep ocean valleys with mountain peaks forming islands.

local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain

local CLEAR_EXISTING_TERRAIN = true
local CREATE_MARKER_FOLDER = true
local SEA_LEVEL_Y = 0

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

	return marker
end

local function fillHill(center: Vector3, radius: number, heightLayers: number, material: Enum.Material)
	for layer = 1, heightLayers do
		local progress = layer / heightLayers
		local layerRadius = radius * (1 - (progress * 0.72))
		local y = center.Y + (progress * radius * 0.9)

		Terrain:FillBall(Vector3.new(center.X, y, center.Z), layerRadius, material)
	end
end

local function fillMountainIsland(name: string, center: Vector3, baseRadius: number, peakHeight: number, markerFolder: Instance?)
	local seabed = Vector3.new(center.X, -48, center.Z)

	Terrain:FillBall(seabed, baseRadius * 1.35, Enum.Material.Rock)
	fillHill(Vector3.new(center.X, -28, center.Z), baseRadius, 8, Enum.Material.Rock)
	fillHill(Vector3.new(center.X, -10, center.Z), baseRadius * 0.78, 7, Enum.Material.Sand)
	fillHill(Vector3.new(center.X, 2, center.Z), baseRadius * 0.56, 5, Enum.Material.Ground)
	fillHill(Vector3.new(center.X, 12, center.Z), baseRadius * 0.38, 4, Enum.Material.Grass)

	Terrain:FillBall(Vector3.new(center.X, peakHeight, center.Z), baseRadius * 0.2, Enum.Material.Rock)

	if markerFolder then
		makeMarker(markerFolder, `{name} Marker`, Vector3.new(center.X, peakHeight + 18, center.Z), Color3.fromRGB(46, 180, 92))
	end
end

local function carveValley(center: Vector3, radius: number)
	for depth = 0, 5 do
		Terrain:FillBall(center - Vector3.new(0, depth * 8, 0), radius * (1 - (depth * 0.08)), Enum.Material.Water)
	end
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

-- Broad deep ocean volume.
Terrain:FillBlock(CFrame.new(0, -42, 0), Vector3.new(1200, 96, 1200), Enum.Material.Water)

-- Underwater valley floor, far below the surface so players swim rather than stand.
Terrain:FillBlock(CFrame.new(0, -92, 0), Vector3.new(1200, 18, 1200), Enum.Material.Rock)

-- Long mountain ridge under the ocean. Island peaks rise from this ridge.
for index = -5, 5 do
	local x = index * 70
	local z = math.sin(index * 0.8) * 45
	Terrain:FillBall(Vector3.new(x, -48, z), 95, Enum.Material.Rock)
end

-- Main playable peaks/islands.
fillMountainIsland("Old Harbor", Vector3.new(0, 0, 0), 90, 38, markerFolder)
fillMountainIsland("Coconut Cay", Vector3.new(150, 0, -70), 70, 26, markerFolder)
fillMountainIsland("Driftwood Atoll", Vector3.new(-165, 0, -130), 75, 30, markerFolder)
fillMountainIsland("Mangrove Isle", Vector3.new(220, 0, 160), 85, 34, markerFolder)
fillMountainIsland("Skull Peak", Vector3.new(-260, 0, 170), 95, 54, markerFolder)

-- Water-filled valleys between island peaks.
carveValley(Vector3.new(80, -20, 60), 55)
carveValley(Vector3.new(-90, -22, 75), 60)
carveValley(Vector3.new(25, -24, -125), 50)

-- A few sandy beaches/landing shelves above water.
Terrain:FillBlock(CFrame.new(18, 3, -32), Vector3.new(68, 8, 28), Enum.Material.Sand)
Terrain:FillBlock(CFrame.new(142, 3, -92), Vector3.new(54, 8, 24), Enum.Material.Sand)
Terrain:FillBlock(CFrame.new(-172, 3, -102), Vector3.new(58, 8, 24), Enum.Material.Sand)
Terrain:FillBlock(CFrame.new(212, 3, 130), Vector3.new(62, 8, 28), Enum.Material.Sand)

print("Generated smooth mountain-peak island terrain. Save/publish the place if you like this template.")
