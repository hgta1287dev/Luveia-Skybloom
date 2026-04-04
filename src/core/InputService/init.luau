local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Signal = require(ReplicatedStorage.Packages.Signal)
local InputMapper = require(ReplicatedStorage.Shared.Core.InputService.Action.InputMapper)
local InputConfig = require(ReplicatedStorage.Shared.Core.InputService.Config.InputConfig)
local MouseDevice = require(ReplicatedStorage.Shared.Core.InputService.Devices.MouseDevice)
local MouseInput = require(ReplicatedStorage.Shared.Core.InputService.Raw.MouseInput)

local InputService = {}
InputService.__index = InputService

-- * Constants
local RENDER_NAME = "InputService"
local RENDER_PRIORITY = Enum.RenderPriority.Input.Value

-- * Helpers
local function getConfig()
	local config = {
		Parent = Players.LocalPlayer.PlayerScripts,
		ContainerName = "Inputs",
		Contexts = InputConfig.new(),
	}
	return config
end

-- * Constructor
function InputService.new()
	local mouseInput = MouseInput.new()

	local self = setmetatable({
		RenderName = RENDER_NAME,
		RenderPriority = RENDER_PRIORITY,

		mapper = InputMapper.new(getConfig()),

		mouseInput = mouseInput,
		mouseDevice = MouseDevice.new(mouseInput),
		MouseChanged = Signal.new(),
	}, InputService)

	self:Init()

	return self
end

-- * Getters
function InputService:GetActionMapper()
	return self.mapper
end

function InputService:GetMouseDevice()
	return self.mouseDevice
end

-- * Connectors
function InputService:ConnectMouseChanged(func: (delta: Vector2) -> nil)
	return self.MouseChanged:Connect(function(delta: Vector2)
		func(delta)
	end)
end

-- * Update
function InputService:Update(dt)
	self.mouseInput:Update(dt)
	self.mouseDevice:Update(dt)

	local delta = self.mouseDevice:GetMoveDelta()
	self.MouseChanged:Fire(delta)

	self.mouseInput:Flush()
end

-- * States
function InputService:Init()
	self.mapper:Build()
	self:Start()
end

function InputService:Start()
	RunService:BindToRenderStep(self.RenderName, self.RenderPriority, function(dt)
		self:Update(dt)
	end)
end

function InputService:Stop()
	RunService:UnbindFromRenderStep(self.RenderName)
end

return InputService.new()
