local LookAtModule = {}
LookAtModule.__index = LookAtModule

function LookAtModule.new()
	local self = setmetatable({}, LookAtModule)
	return self
end

function LookAtModule:Update(context, result)
	local camPos = result.Body.Position
	result.Aim = CFrame.lookAt(camPos, context.CameraState.LookAtTarget)
end

return LookAtModule
