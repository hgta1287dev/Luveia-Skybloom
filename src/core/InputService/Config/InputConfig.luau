local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputMapperTypes = require(ReplicatedStorage.Shared.Core.InputService.Action.InputMapper.InputMapperTypes)

local InputConfig = {}

function InputConfig.new(): { [string]: InputMapperTypes.ContextConfig }
	local contextConfig: { [string]: InputMapperTypes.ContextConfig } = {
		Gameplay = {
			Actions = {
				Look = {
					Type = Enum.InputActionType.Direction2D,
					Bindings = {
						Keyboard = {
							Vector2Scale = Vector2.new(2, 2),
							Up = Enum.KeyCode.W,
							Down = Enum.KeyCode.S,
							Left = Enum.KeyCode.A,
							Right = Enum.KeyCode.D,
						},
					},
				},

				LookDelta = {
					Type = Enum.InputActionType.Direction2D,
					Bindings = {
						Mouse = {
							KeyCode = Enum.KeyCode.MouseDelta,
						},
					},
				},

				Move = {
					Type = Enum.InputActionType.Direction3D,
					Bindings = {
						Keyboard = {
							Up = Enum.KeyCode.E,
							Down = Enum.KeyCode.Q,
							Left = Enum.KeyCode.A,
							Right = Enum.KeyCode.D,
							Forward = Enum.KeyCode.W,
							Backward = Enum.KeyCode.S,
						},
					},
				},

				ZoomDistance = {
					Type = Enum.InputActionType.Direction1D,
					Bindings = {
						Keyboard = {
							Vector2Scale = Vector2.new(0.001, 0.001),
							Up = Enum.KeyCode.I,
							Down = Enum.KeyCode.O,
						},
					},
				},

				ZoomDistanceDelta = {
					Type = Enum.InputActionType.Direction1D,
					Bindings = {
						Mouse = {
							Scale = 0.05,
							KeyCode = Enum.KeyCode.MouseWheel,
						},
					},
				},
			},
		},
	}
	return contextConfig
end

return InputConfig
