local CameraResult = {}
CameraResult.__index = CameraResult

export type CameraResult = {
	Body: CFrame,
	Aim: CFrame,
	Noise: CFrame,
	Fov: number,

	Reset: (self: CameraResult) -> (),
}

function CameraResult.new(body: CFrame?, aim: CFrame?, noise: CFrame?): CameraResult
	local self = setmetatable({
		Body = body or CFrame.new(),
		Aim = aim or CFrame.new(),
		Noise = noise or CFrame.new(),
		Fov = 70,
	}, CameraResult)

	return self
end

function CameraResult:Reset()
	self.Body = CFrame.new()
	self.Aim = CFrame.new()
	self.Noise = CFrame.new()
	self.Fov = 70
end

return CameraResult
