local CameraState = require(script.Parent.CameraState)

local CameraContext = {}
CameraContext.__index = CameraContext

-- * Types
export type CameraState = CameraState.CameraState
export type CameraContext = {
	DeltaTime: number,
	CameraState: CameraState,
}

-- * Constructor
function CameraContext.new(state: CameraState?): CameraContext
	return {
		DeltaTime = 0,
		CameraState = state or CameraState.new(),
	}
end

return CameraContext
