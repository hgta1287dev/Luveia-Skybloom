local CameraInputState = require(script.Parent.CameraInputState)
local CameraState = require(script.Parent.CameraState)

local CameraContext = {}
CameraContext.__index = CameraContext

-- * Types
export type CameraState = CameraState.CameraState
export type CameraInputState = CameraInputState.InputState
export type CameraContext = {
	DeltaTime: number,
	CameraState: CameraState,
	InputState: CameraInputState,
}

-- * Constructor
function CameraContext.new(state: CameraState?, inputState: CameraInputState?): CameraContext
	return {
		DeltaTime = 0,
		CameraState = state or CameraState.new(),
		InputState = inputState or CameraInputState.new(),
	}
end

return CameraContext
