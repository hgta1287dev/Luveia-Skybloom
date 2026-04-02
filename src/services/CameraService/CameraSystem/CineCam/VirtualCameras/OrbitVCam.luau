local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CameraContext =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Context.CameraContext)
local CameraLookAtModule =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Pipe.Modules.Aim.CameraLookAtModule)
local CameraTargetObjectModule = require(
	ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Pipe.Modules.Extensions.CameraTargetObjectModule
)
local CameraOffsetModule =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Pipe.Modules.Noise.CameraOffsetModule)
local CameraOrbitModule = require(script.Parent.Parent.Pipe.Modules.Body.CameraOrbitModule)
local BaseVirtualCamera = require(script.Parent.Parent.VirtualCameras.BaseVCam)

type CameraContext = CameraContext.CameraContext

local OrbitVCam = {}
OrbitVCam.__index = OrbitVCam

local function GetTestPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.Size = Vector3.one * 2
	part.Parent = workspace
	return part
end

function OrbitVCam.new()
	local orbitModule = CameraOrbitModule.new()
	local lookAtModule = CameraLookAtModule.new()
	local offsetModule = CameraOffsetModule.new()
	local objectTargetModule = CameraTargetObjectModule.new(nil, GetTestPart())

	orbitModule.Distance.SmoothFactor = 6
	orbitModule.Yaw.SmoothFactor = 4
	orbitModule.Pitch.SmoothFactor = 5

	local self = setmetatable(
		BaseVirtualCamera.new({
			objectTargetModule,
			orbitModule,
			lookAtModule,
			offsetModule,
		}),
		OrbitVCam
	)

	function self:_updateOrbitInput(context: CameraContext)
		local input = context.InputState
		local mouseState = input.MouseState

		orbitModule.Distance:AdjustTarget(mouseState.ScrollDelta)
		if mouseState.ButtonsDown:Has(Enum.UserInputType.MouseButton2) then
			orbitModule.Yaw:AdjustTarget(mouseState.MoveDelta.X)
			orbitModule.Pitch:AdjustTarget(mouseState.MoveDelta.Y)
		end
	end

	return self
end

function OrbitVCam:Update(context: CameraContext, output)
	-- input
	self:_updateOrbitInput(context)

	-- ouput
	local result = BaseVirtualCamera.Update(self, context)
	output.Cframe = result.Body * result.Aim * result.Noise
	output.Fov = result.Fov
end

return OrbitVCam
