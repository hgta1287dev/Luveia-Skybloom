local CameraOutput = require(script.Parent.Parent.Output.CameraOutput)

local CameraBrain = {}
CameraBrain.__index = CameraBrain

function CameraBrain.new()
	local self = setmetatable({}, CameraBrain)
	self.output = CameraOutput.new()
	self.ActiveVCam = nil
	return self
end

function CameraBrain:SetActiveVCam(vcam)
	self.ActiveVCam = vcam
end

function CameraBrain:Update(context)
	if not self.ActiveVCam then
		return
	end

	self.ActiveVCam:Update(context, self.output)

	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = self.output.Cframe
	camera.FieldOfView = self.output.Fov
end

return CameraBrain
