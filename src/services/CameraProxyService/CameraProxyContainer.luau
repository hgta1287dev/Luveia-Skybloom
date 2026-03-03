local CameraProxyContainer = {
	ContainerName = "CameraProxies",
}

function CameraProxyContainer:CreateContainer(parent)
	local folder = Instance.new("Folder")
	folder.Name = self.ContainerName
	folder.Parent = parent or workspace
	return folder
end

function CameraProxyContainer:GetContainer()
	local container = workspace:FindFirstChild(self.ContainerName)
	if not container then
		container = self:CreateContainer(workspace)
	end
	return container
end

return CameraProxyContainer
