local CameraUtils = {}

function CameraUtils.GetAlpha(dt, smooth)
	return 1 - math.exp(-smooth * dt)
end

return CameraUtils
