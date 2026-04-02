local CameraState = {}

export type CameraState = {
	-- * Objects
	TrackingObject: Instance?,
	LookAtObject: Instance?,

	-- * Targets
	TrackingTarget: Vector3,
	LookAtTarget: Vector3,

	-- * Offsets
	PivotOffset: Vector3,
	CameraOffset: Vector3,
}

function CameraState.new(): CameraState
	local state: CameraState = {
		TrackingObject = nil,
		LookAtObject = nil,

		TrackingTarget = Vector3.zero, -- camera target
		LookAtTarget = Vector3.zero, -- lookAt target

		PivotOffset = Vector3.zero, -- offset from target
		CameraOffset = Vector3.zero, -- offset from pivot
	}
	return state
end

return CameraState
