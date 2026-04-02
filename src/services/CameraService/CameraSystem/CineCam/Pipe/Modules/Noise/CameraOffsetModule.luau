local CameraOffsetModule = {}
CameraOffsetModule.__index = CameraOffsetModule

function CameraOffsetModule.new()
	local self = setmetatable({}, CameraOffsetModule)
	return self
end

function CameraOffsetModule:Update(context, result)
	local offset = context.CameraState.CameraOffset
	result.Body *= CFrame.new(offset)
end

return CameraOffsetModule
