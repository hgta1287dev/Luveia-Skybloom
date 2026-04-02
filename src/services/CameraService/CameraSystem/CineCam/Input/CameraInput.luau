local CameraInputState = require(script.Parent.Parent.Context.CameraInputState)
local CameraGamepadInput = require(script.Parent.CameraGamepadInput)
local CameraKeyboardInput = require(script.Parent.CameraKeyboardInput)
local CameraMouseInput = require(script.Parent.CameraMouseInput)
local CameraTouchInput = require(script.Parent.CameraTouchInput)

local CameraInput = {}
CameraInput.__index = CameraInput

export type InputState = CameraInputState.InputState
export type CameraInputData = {
	InputState: InputState,
	MouseInput: CameraMouseInput.MouseInput,
	GamepadInput: CameraGamepadInput.GamepadInput,
	TouchInput: CameraTouchInput.TouchInput,
	KeyboardInput: CameraKeyboardInput.KeyboardInput,
}
export type CameraInput = typeof(setmetatable({} :: CameraInputData, CameraInput))

function CameraInput.new(inputState: InputState): CameraInput
	local self = setmetatable({
		InputState = inputState,
		MouseInput = CameraMouseInput.new(inputState.MouseState),
		GamepadInput = CameraGamepadInput.new(inputState.GamepadState),
		TouchInput = CameraTouchInput.new(inputState.TouchState),
		KeyboardInput = CameraKeyboardInput.new(inputState.KeyboardState), -- * Auto update
	}, CameraInput)

	return self
end

function CameraInput:Update(dt) end

function CameraInput:Flush()
	self.MouseInput:Flush()
	self.KeyboardInput:Flush()
end

function CameraInput:GetInputState(): InputState
	return self.InputState
end

return CameraInput
