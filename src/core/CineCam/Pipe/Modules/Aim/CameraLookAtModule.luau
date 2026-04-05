local LookAtModule = {}
LookAtModule.__index = LookAtModule

function LookAtModule.new()
	local self = setmetatable({}, LookAtModule)
	return self
end

function LookAtModule:Update(context, result)
	local camPos = result.Body.Position
	local object = context.CameraState.LookAtObject

	local objectPos = object and object:GetPivot().Position
	local lookAt = CFrame.lookAt(camPos, objectPos or context.CameraState.LookAtTarget)

	local angleCf = CFrame.fromEulerAnglesXYZ(lookAt:ToEulerAnglesXYZ())

	result.Aim = angleCf
end

return LookAtModule
