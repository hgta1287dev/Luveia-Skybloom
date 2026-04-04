local MouseDevice = {}
MouseDevice.__index = MouseDevice

function MouseDevice.new(mouseInput: any)
	local self = setmetatable({}, MouseDevice)

	self._mouseInput = mouseInput
	self._mouseDelta = Vector2.zero

	self.SensitivityX = 1
	self.SensitivityY = 1

	self.InvertX = false
	self.InvertY = false

	self.SmoothFactorX = 0
	self.SmoothFactorY = 0

	return self
end

function MouseDevice:Update(dt)
	local raw = self._mouseInput:GetDelta()

	local delta = raw * Vector2.new(self.SensitivityX, self.SensitivityY)
	delta *= Vector2.new(self.InvertX and -1 or 1, self.InvertY and -1 or 1)

	local alphaX = 1 - math.exp(-self.SmoothFactorX * dt)
	local alphaY = 1 - math.exp(-self.SmoothFactorY * dt)

	if alphaX > 0 or alphaY > 0 then
		local prev = self._mouseDelta
		self._mouseDelta = Vector2.new(prev.X + (delta.X - prev.X) * alphaX, prev.Y + (delta.Y - prev.Y) * alphaY)
	else
		self._mouseDelta = delta
	end
end

function MouseDevice:GetMoveDelta(): Vector2
	return self._mouseDelta
end

function MouseDevice:GetScrollDelta(): number
	return self._mouseInput:GetScrollDelta()
end

return MouseDevice
