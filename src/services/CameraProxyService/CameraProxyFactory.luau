local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraProxyContainer = require(script.Parent.CameraProxyContainer)
local CameraProxyFactory = {}

-- * Public
function CameraProxyFactory:Create(parent: Instance?): Model?
	local cameraProxyTemplate =
		ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Cameras"):WaitForChild("CameraProxy")

	ContentProvider:PreloadAsync({ cameraProxyTemplate })

	local cameraProxy = cameraProxyTemplate:Clone()
	cameraProxy.Parent = parent or CameraProxyContainer:GetContainer()

	return cameraProxy
end

return CameraProxyFactory
