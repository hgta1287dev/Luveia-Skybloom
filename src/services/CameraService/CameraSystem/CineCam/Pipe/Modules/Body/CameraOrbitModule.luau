local CameraContext = require(script.Parent.Parent.Parent.Parent.Context.CameraContext)
local CameraAxisState = require(script.Parent.Parent.Parent.Parent.Utilities.CameraAxisState)

local OrbitModule = {}
OrbitModule.__index = OrbitModule

type CameraContext = CameraContext.CameraContext
type AxisState = CameraAxisState.CameraAxisState

function OrbitModule.new()
	local self = setmetatable({}, OrbitModule)
	self.Yaw = CameraAxisState.new(nil, 1, 8)
	self.Pitch = CameraAxisState.new(Vector2.new(-69, 39), 1, 8)
	self.Distance = CameraAxisState.new(Vector2.new(5, 50), 1, 8)
	return self
end

function OrbitModule:Update(context: CameraContext, result)
	local dt = context.DeltaTime

	local yaw: AxisState = self.Yaw
	local pitch: AxisState = self.Pitch
	local distance: AxisState = self.Distance

	yaw:Update(dt)
	pitch:Update(dt)
	distance:Update(dt)

	local origin = context.CameraState.LookAtTarget + context.CameraState.PivotOffset

	local orbitCF = CFrame.new(origin)
		* CFrame.fromEulerAnglesXYZ(0, math.rad(yaw.Current), 0)
		* CFrame.fromEulerAnglesXYZ(math.rad(pitch.Current), 0, 0)
		* CFrame.new(0, 0, distance.Current)

	result.Body = CFrame.new(orbitCF.Position)
end

return OrbitModule
