local UserInputService = game:GetService("UserInputService")

local TouchInput = {}
TouchInput.__index = TouchInput

export type TouchState = {
	Delta: Vector2,
	Pinch: number,
}
export type TouchInput = typeof(setmetatable(
	{} :: {
		TouchState: TouchState,
	},
	TouchInput
))

function TouchInput.new(touchState: TouchState): TouchInput
	local self = setmetatable({
		TouchState = touchState,
	}, TouchInput)

	return self
end

function TouchInput:Init()
	local state: TouchState = self.TouchState
	local lastPos = nil
	UserInputService.TouchMoved:Connect(function(touch)
		if lastPos then
			local delta = touch.Position - lastPos
			state.Delta.X = delta.X
			state.Delta.Y = delta.Y
		end
		lastPos = touch.Position
	end)

	UserInputService.TouchPinch:Connect(function(pinches)
		state.Pinch = pinches.Position.Z
	end)
end

return TouchInput
