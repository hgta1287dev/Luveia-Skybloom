local RunService = game:GetService("RunService")

local CONTAINER_NAME = "Maps"

local MapContainer = {
	ContainerName = CONTAINER_NAME,
}

function MapContainer.CreateContainer(): Instance?
	if not RunService:IsServer() then
		return
	end
	local container = Instance.new("Folder")
	container.Name = CONTAINER_NAME
	container.Parent = workspace
	return container
end

function MapContainer.GetContainer(): Instance
	local container = workspace:FindFirstChild(CONTAINER_NAME)
	if not container and RunService:IsServer() then
		container = MapContainer.CreateContainer()
	end
	return container
end

return MapContainer
