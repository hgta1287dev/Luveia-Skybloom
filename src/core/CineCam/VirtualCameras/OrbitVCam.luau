local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputService = require(ReplicatedStorage.Shared.Core.InputService)
local CameraContext = require(script.Parent.Parent.Context.CameraContext)
local CameraLookAtModule = require(script.Parent.Parent.Pipe.Modules.Aim.CameraLookAtModule)
local CameraOffsetModule = require(script.Parent.Parent.Pipe.Modules.Noise.CameraOffsetModule)
local CameraOrbitModule = require(script.Parent.Parent.Pipe.Modules.Body.CameraOrbitModule)
local BaseVirtualCamera = require(script.Parent.Parent.VirtualCameras.BaseVCam)
local CameraTargetObjectModule = require(script.Parent.Parent.Pipe.Modules.Extensions.CameraTargetObjectModule)

-- * Orbit
local OrbitVCam = {}
OrbitVCam.__index = OrbitVCam

-- * Types
type CameraContext = CameraContext.CameraContext

-- * Constructor
function OrbitVCam.new()
	local orbitModule = CameraOrbitModule.new()
	local lookAtModule = CameraLookAtModule.new()
	local offsetModule = CameraOffsetModule.new()
	local objectTargetModule = CameraTargetObjectModule.new()

	orbitModule.Yaw.SmoothFactor = 4
	orbitModule.Pitch.SmoothFactor = 5
	orbitModule.Distance.SmoothFactor = 6

	local self = setmetatable(
		BaseVirtualCamera.new({
			objectTargetModule,
			orbitModule,
			lookAtModule,
			offsetModule,
		}),
		OrbitVCam
	)

	self.direction = Vector2.zero
	self.zoomDis = 0

	local mapper = InputService:GetActionMapper()
	local mouseDevice = InputService:GetMouseDevice()

	local look: InputAction = mapper:GetAction("Gameplay", "Look")
	local lookDelta: InputAction = mapper:GetAction("Gameplay", "LookDelta")
	local zoomDis: InputAction = mapper:GetAction("Gameplay", "ZoomDistance")
	local zoomDisDelta: InputAction = mapper:GetAction("Gameplay", "ZoomDistanceDelta")

	lookDelta.StateChanged:Connect(function(delta: Vector2)
		orbitModule.Yaw:AdjustTarget(delta.X)
		orbitModule.Pitch:AdjustTarget(delta.Y)
	end)

	zoomDisDelta.StateChanged:Connect(function(distance: number)
		orbitModule.Distance:AdjustTarget(-distance)
	end)

	look.StateChanged:Connect(function(direction: Vector2)
		self.direction = direction * Vector2.new(1, -1)
	end)

	zoomDis.StateChanged:Connect(function(distance: number)
		self.zoomDis = distance
	end)

	function self:_onUpdate()
		if mouseDevice:IsButtonDown(Enum.UserInputType.MouseButton2) then
			local delta = -mouseDevice:GetMoveDelta()
			orbitModule.Yaw:AdjustTarget(delta.X)
			orbitModule.Pitch:AdjustTarget(delta.Y)
		end

		orbitModule.Yaw:AdjustTarget(self.direction.X)
		orbitModule.Pitch:AdjustTarget(self.direction.Y)
		orbitModule.Distance:AdjustTarget(-self.zoomDis)
	end

	function self:GetObjectTargetModule()
		return objectTargetModule
	end

	function self:GetOrbitModule()
		return orbitModule
	end

	return self
end

-- * Methods
function OrbitVCam:Update(context: CameraContext, output)
	self:_onUpdate()

	-- ouput
	local result = BaseVirtualCamera.Update(self, context)
	output.Cframe = result.Body * result.Aim * result.Noise
	output.Fov = result.Fov
end

return OrbitVCam
