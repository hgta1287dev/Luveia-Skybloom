local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ExternalCameraService = require(ReplicatedStorage.Shared.Services.CameraService.ExternalCameraService)

local CameraRemote = {}

function CameraRemote:Reset()
	ExternalCameraService:SetCameraView("Default")
end

function CameraRemote:SetHost(part)
	print(part:GetFullName())
	ExternalCameraService:SetCameraHost(part)
end

function CameraRemote:Watch(part)
	ExternalCameraService:SetCameraView("Orbital")
	self:SetHost(part)
end

return CameraRemote
