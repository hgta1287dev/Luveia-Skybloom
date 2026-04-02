local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CameraInput = require(script.CineCam.Input.CameraInput)
local OrbitVCam = require(script.CineCam.VirtualCameras.OrbitVCam)
local CameraBrain = require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Core.CameraBrain)
local CameraContext =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Context.CameraContext)

local CameraSystem = {}
CameraSystem.__index = CameraSystem

local MAX_DELTA_TIME = 1 / 30 -- 30 hz
local RENDER_NAME = "CameraSystemRender"
local RENDER_PRIORITY = Enum.RenderPriority.Camera.Value

function CameraSystem.new()
	local context = CameraContext.new()
	local self = setmetatable({
		brain = CameraBrain.new(),
		context = context,
		input = CameraInput.new(context.InputState),
	}, CameraSystem)

	return self
end

function CameraSystem:Update(dt: number)
	dt = math.min(dt, MAX_DELTA_TIME)
	self.context.DeltaTime = dt

	self.input:Update(dt)
	self.brain:Update(self.context)
	self.input:Flush()
end

function CameraSystem:Init()
	self.brain:SetActiveVCam(OrbitVCam.new())
	self:Start()
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
