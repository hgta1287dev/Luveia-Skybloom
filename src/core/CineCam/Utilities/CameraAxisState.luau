local CameraAxisState = {}
CameraAxisState.__index = CameraAxisState

export type CameraAxisStateData = {
	Target: number,
	Current: number,
	Limit: Vector2?,
	Sensitivity: number,
	SmoothFactor: number,
}
export type CameraAxisState = typeof(setmetatable({} :: CameraAxisStateData, CameraAxisState))

function CameraAxisState.new(limit: Vector2?, sensitivity: number?, smooth: number?): CameraAxisState
	local data: CameraAxisStateData = {
		Target = 0,
		Current = 0,
		Limit = limit,
		Sensitivity = sensitivity or 1,
		SmoothFactor = smooth or 4,
	}
	local self: CameraAxisState = setmetatable(data, CameraAxisState)
	return self
end

-- Reset
function CameraAxisState:Reset()
	self.Target = self:ClampValue(0)
	self.Current = self:ClampValue(0)
end

-- Clamp
function CameraAxisState:ClampTarget()
	self.Target = self:ClampValue(self.Target)
end

function CameraAxisState:ClampCurrent()
	self.Current = self:ClampValue(self.Current)
end

function CameraAxisState:ClampValue(value: number): number
	if self.Limit then
		return math.clamp(value, self.Limit.X, self.Limit.Y)
	end
	return value
end

-- Alpha
function CameraAxisState:GetAlpha(dt: number)
	return 1 - math.exp(-self.SmoothFactor * dt)
end

-- Update
function CameraAxisState:AdjustTarget(value: number)
	self.Target += value * self.Sensitivity
end

function CameraAxisState:LerpCurrent(dt)
	self.Current = math.lerp(self.Current, self.Target, self.SmoothFactor * dt)
end

function CameraAxisState:Update(dt)
	self:ClampTarget()
	self:LerpCurrent(dt)
	self:ClampCurrent()
end

return CameraAxisState
