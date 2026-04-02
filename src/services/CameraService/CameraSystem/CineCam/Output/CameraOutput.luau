export type CameraOutput = {
	Cframe: CFrame,
	Fov: number,

	Reset: (self: CameraOutput) -> (),
}

local CameraOutput = {}

function CameraOutput.new(cframe: CFrame?, fov: number?): CameraOutput
	local self = setmetatable({
		Cframe = cframe or CFrame.new(),
		Fov = fov or 70,
	}, CameraOutput)
	return self
end

function CameraOutput:Reset()
	self.Cframe = CFrame.new()
	self.Fov = 70
end

return CameraOutput
