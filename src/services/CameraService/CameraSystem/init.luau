local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CameraContext = require(ReplicatedStorage.Shared.Core.CineCam.Context.CameraContext)
local CameraBrain = require(ReplicatedStorage.Shared.Core.CineCam.Core.CameraBrain)
local OrbitVCam = require(ReplicatedStorage.Shared.Core.CineCam.VirtualCameras.OrbitVCam)
local CameraSystem = {}
CameraSystem.__index = CameraSystem

local MAX_DELTA_TIME = 1 / 30 -- 30 hz
local RENDER_NAME = "CameraSystemRender"
local RENDER_PRIORITY = Enum.RenderPriority.Camera.Value

function CameraSystem.new()
	local context = CameraContext.new()
	local self = setmetatable({
		vcams = {
			Orbit = OrbitVCam.new(),
		},
		brain = CameraBrain.new(),
		context = context,
	}, CameraSystem)

	return self
end

function CameraSystem:Update(dt: number)
	dt = math.min(dt, MAX_DELTA_TIME)
	self.context.DeltaTime = dt
	self.brain:Update(self.context)
end

function CameraSystem:Init()
	self.brain:SetActiveVCam(self.vcams.Orbit)
	self:Start()
end

function CameraSystem:GetContext()
	return self.context
end

function CameraSystem:Start()
	if self.running then
		return
	end

	self.running = true

	RunService:BindToRenderStep(RENDER_NAME, RENDER_PRIORITY, function(delta: number)
		self:Update(delta)
	end)
end

function CameraSystem:Stop()
	if not self.running then
		return
	end
	self.running = false

	RunService:UnbindFromRenderStep(RENDER_NAME)
end

return CameraSystem.new()
