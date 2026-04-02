local UserInputService = game:GetService("UserInputService")

local GamepadInput = {}
GamepadInput.__index = GamepadInput

export type GamepadState = {
	LeftStick: Vector2,
	RightStick: Vector2,
	LeftTrigger: number,
	RightTrigger: number,
}

export type GamepadInput = typeof(setmetatable(
	{} :: {
		GamepadState: GamepadState,
	},
	GamepadInput
))

function GamepadInput.new(gamepadState: GamepadState): GamepadInput
	local self = setmetatable({
		GamepadState = gamepadState,
	}, GamepadInput)

	UserInputService.InputChanged:Connect(function(input)
		local state: GamepadState = self.GamepadState
		if input.UserInputType == Enum.UserInputType.Gamepad1 then
			if input.KeyCode == Enum.KeyCode.Thumbstick1 then
				state.RightStick.X = input.Position.X
				state.RightStick.Y = input.Position.Y
			elseif input.KeyCode == Enum.KeyCode.Thumbstick2 then
				state.LeftStick.X = input.Position.X
				state.LeftStick.Y = input.Position.Y
			elseif input.KeyCode == Enum.KeyCode.ButtonL2 then
				state.LeftTrigger = input.Position.Z
			elseif input.KeyCode == Enum.KeyCode.ButtonR2 then
				state.RightTrigger = input.Position.Z
			end
		end
	end)

	return self
end

return GamepadInput
