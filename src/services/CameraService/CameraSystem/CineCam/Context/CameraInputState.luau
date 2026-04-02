local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OrderedCollections = require(ReplicatedStorage.Packages.OrderedCollections)
local CameraGamepadInput =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Input.CameraGamepadInput)
local CameraKeyboardInput =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Input.CameraKeyboardInput)
local CameraMouseInput =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Input.CameraMouseInput)
local CameraTouchInput =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Input.CameraTouchInput)

local InputState = {}
InputState.__index = InputState

export type MouseState = CameraMouseInput.MouseState
export type GamepadState = CameraGamepadInput.GamepadState
export type TouchState = CameraTouchInput.TouchState
export type KeyboardState = CameraKeyboardInput.KeyboardState
export type InputState = {
	MouseState: MouseState,
	TouchState: TouchState,
	GamepadState: GamepadState,
	KeyboardState: KeyboardState,
}

function InputState.new(): InputState
	return {
		MouseState = {
			MoveDelta = Vector2.zero,
			ScrollDelta = 0,
			ButtonsDown = OrderedCollections.Set.new(),
			ButtonsPressed = OrderedCollections.Set.new(),
			ButtonsReleased = OrderedCollections.Set.new(),
		},
		TouchState = {
			Delta = Vector2.zero,
			Pinch = 0,
		},
		GamepadState = {
			LeftStick = Vector2.zero,
			RightStick = Vector2.zero,
			LeftTrigger = 0,
			RightTrigger = 0,
		},
		KeyboardState = {
			KeysDown = OrderedCollections.Set.new(),
			KeysPressed = OrderedCollections.Set.new(),
			KeysReleased = OrderedCollections.Set.new(),
		},
	} :: InputState
end

return InputState
