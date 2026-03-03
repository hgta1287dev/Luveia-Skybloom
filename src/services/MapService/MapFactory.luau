local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local GameTypes = require(ReplicatedStorage.Shared.Types.GameTypes)
local Logger = require(ReplicatedStorage.Shared.Utils.Logger)
local MapContainer = require(script.Parent.MapContainer)

local MapFactory = {}

-- * Types
export type Mode = GameTypes.Mode

-- * ONLY SERVER * --
-- * Public
function MapFactory.GetMapTemplate(mode: Mode, mapName: string, timeout: number): (Instance?, string?)
	if not RunService:IsServer() then
		Logger.warn("MapFactory", "Cannot get map template on client")
		return nil, "Cannot get map template on client"
	end

	local assets = ServerStorage:WaitForChild("Assets", timeout)
	if not assets then
		return nil, "Assets folder not found!"
	end

	local mapsFolder = assets:WaitForChild("Maps", timeout)
	if not mapsFolder then
		return nil, "Maps folder not found!"
	end

	local modeFolder = mapsFolder and mapsFolder:WaitForChild(mode, timeout) :: Instance?
	if not modeFolder then
		return nil, `No maps found for mode "{mode}"`
	end

	local mapTemplate = modeFolder:WaitForChild(mapName, timeout) :: Instance?
	return mapTemplate, if mapTemplate then nil else `No map "{mapName}" in mode "{mode}"`
end

function MapFactory.ValidateMapTemplate(template: Instance): (boolean, string?)
	-- * Exists Validation
	if not template then
		return false, "Template is nil"
	end

	-- * Model Validation
	if not template:IsA("Model") then
		return false, `Map template "{template:GetFullName()}" must be a Model`
	end

	-- * Root Validation
	local root = template:FindFirstChild("Root")
	if not root then
		return false, `Map template "{template:GetFullName()}" must contain a BasePart named "Root"`
	end
	if not root:IsA("BasePart") then
		return false, `"Root" must be a BasePart`
	end
	if template.PrimaryPart ~= root then
		return false, `PrimaryPart of "{template:GetFullName()}" must be set to "Root"`
	end

	-- * CameraPivot Validation
	local cameraPivot = template:FindFirstChild("CameraPivot")
	if not cameraPivot then
		return false, `Map template "{template:GetFullName()}" must contain a BasePart named "CameraPivot"`
	elseif not cameraPivot:IsA("BasePart") then
		return false, `"CameraPivot" must be a BasePart: {template:GetFullName()}`
	end

	-- * Geometry Validation
	local geometry = template:FindFirstChild("Geometry")
	if not geometry then
		return false, `Map template "{template:GetFullName()}" must contain a Folder named "Geometry"`
	end
	for _, part in geometry:GetChildren() do
		if not part:IsA("BasePart") then
			return false, `Part "{part:GetFullName()}" must be a BasePart`
		end
	end

	-- * Props Validation
	local props = template:FindFirstChild("Props")
	if not props then
		return false, `Map template "{template:GetFullName()}" must contain a Folder named "Props"`
	end

	-- * Runtime Validation
	local runtime = template:FindFirstChild("Runtime")
	if not runtime then
		return false, `Map template "{template:GetFullName()}" must contain a Folder named "Runtime"`
	end

	-- * Interactables Validation
	local interactables = template:FindFirstChild("Interactables")
	if not interactables then
		return false, `Map template "{template:GetFullName()}" must contain a Folder named "Interactables"`
	end

	-- * Modules Validation
	local modules = template:FindFirstChild("Modules")
	if not modules then
		return false, `Map template "{template:GetFullName()}" must contain a Folder named "Modules"`
	end
	for _, moduleScript in modules:GetChildren() do
		if not moduleScript:IsA("ModuleScript") then
			return false, `Module "{moduleScript:GetFullName()}" must be a ModuleScript`
		end
	end
	return true
end

function MapFactory.CreateMap(mode: Mode, mapName: string, timeout: number): (Instance?, string?)
	if not RunService:IsServer() then
		Logger.warn("MapFactory", "Cannot create map on client")
		return nil, "Cannot create map on client"
	end

	-- Find map template
	local mapTemplate, err = MapFactory.GetMapTemplate(mode, mapName, timeout)
	if not mapTemplate then
		return nil, err
	end

	-- Validate map template
	local isMapValid, mapValidateErr = MapFactory.ValidateMapTemplate(mapTemplate)
	if not isMapValid then
		return nil, mapValidateErr
	end

	-- Create map
	local container = MapContainer.GetContainer()
	local map = mapTemplate:Clone()
	map.Parent = container

	return map
end

return MapFactory
