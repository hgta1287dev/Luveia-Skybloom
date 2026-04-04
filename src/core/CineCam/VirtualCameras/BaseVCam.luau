local CameraResult = require(script.Parent.Parent.Output.CameraResult)
local CameraPipeline = require(script.Parent.Parent.Pipe.Pipeline)

local BaseVirtualCamera = {}
BaseVirtualCamera.__index = BaseVirtualCamera

function BaseVirtualCamera.new(modules)
	local self = setmetatable({}, BaseVirtualCamera)
	self.Pipeline = CameraPipeline.new(modules or {})
	self.Result = CameraResult.new()
	return self
end

function BaseVirtualCamera:Update(context)
	self.Pipeline:Run(context, self.Result)
	return self.Result
end

return BaseVirtualCamera
