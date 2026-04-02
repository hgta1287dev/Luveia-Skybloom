local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraSystem = require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem)

local TestCamera = CameraSystem.new()
TestCamera:Init()

return TestCamera
