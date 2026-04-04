local UserInputService = game:GetService("UserInputService")

export type MouseState = {
	Delta: Vector2,
	Position: Vector2,
	ScrollDelta: number,

	IsLocked: boolean,
}

local Mouse = {}
Mouse.__index = Mouse

function Mouse.new()
	local self = setmetatable({}, Mouse)

	self._delta = Vector2.zero
	self._position = Vector2.zero
	self._scrollDelta = 0

	self._lastPosition = UserInputService:GetMouseLocation()

	self._isLocked = false

	-- accumulate scroll
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			self._scrollDelta += input.Position.Z
		end
	end)

	return self
end

-- * Public
function Mouse:GetState(): MouseState
	return {
		Delta = self._delta,
		Position = self._position,
		ScrollDelta = self._scrollDelta,

		IsLocked = self._isLocked,
	}
end

function Mouse:Update()
	local currentPos = UserInputService:GetMouseLocation()
	self._position = currentPos

	-- check lock state
	self._isLocked = (UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter)

	if self._isLocked then
		self._delta = UserInputService:GetMouseDelta()
	else
		self._delta = currentPos - self._lastPosition
	end

	self._lastPosition = currentPos
end

function Mouse:Flush()
	self._delta = Vector2.zero
	self._scrollDelta = 0
end

function Mouse:GetDelta(): Vector2
	return self._delta
end

function Mouse:GetPosition(): Vector2
	return self._position
end

function Mouse:GetScrollDelta(): number
	return self._scrollDelta
end

function Mouse:IsLocked(): boolean
	return self._isLocked
end

function Mouse:SetLocked(locked: boolean)
	if locked then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
	end
end

return Mouse
