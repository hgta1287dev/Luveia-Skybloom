local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraAxisState =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Utilities.CameraAxisState)
local FollowModule = {}
FollowModule.__index = FollowModule

function FollowModule.new(target)
	local self = setmetatable({}, FollowModule)
	self.Distance = CameraAxisState.new(Vector2.new(5, 50))
	return self
end

function FollowModule:Update(context, result)
	local dt = context.DeltaTime
	local input = context.InputState

	self.Distance:AddjustTarget(input.MouseState.Zoom)
	self.Distance:Update(dt)

	local pos = self.Target.Position - self.Target.CFrame.LookVector * self.Distance
	result.CFrame = CFrame.new(pos, self.Target.Position)
end

return FollowModule
