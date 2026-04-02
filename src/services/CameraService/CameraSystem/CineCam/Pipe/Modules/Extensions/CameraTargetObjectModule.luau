local TargetModule = {}
TargetModule.__index = TargetModule

function TargetModule.new(trackingObj: Instance?, lookAtObj: Instance?)
	local self = setmetatable({}, TargetModule)
	self.TrackingObject = trackingObj
	self.LookAtObject = lookAtObj
	return self
end

function TargetModule:SetTargets(trackingObj, lookAtObj)
	self.TrackingObject = trackingObj
	self.LookAtObject = lookAtObj
end

function TargetModule:Update(context, result)
	local cameraState = context.CameraState

	cameraState.TrackingObject = self.TrackingObject or cameraState.TrackingObject
	cameraState.LookAtObject = self.LookAtObject or cameraState.LookAtObject

	cameraState.TrackingTarget = cameraState.TrackingObject and cameraState.TrackingObject.Position
		or cameraState.TrackingTarget
	cameraState.LookAtTarget = cameraState.LookAtObject and cameraState.LookAtObject.Position
		or cameraState.LookAtTarget
end

return TargetModule
