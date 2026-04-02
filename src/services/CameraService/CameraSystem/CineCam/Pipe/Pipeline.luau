local CameraPipeline = {}
CameraPipeline.__index = CameraPipeline

function CameraPipeline.new(modules, extensions)
	local self = setmetatable({}, CameraPipeline)
	self.Modules = modules or {}
	self.Extensions = extensions or {}
	return self
end

function CameraPipeline:Run(context, result)
	for _, module in ipairs(self.Modules) do
		module:Update(context, result)
	end
	for _, extension in ipairs(self.Extensions) do
		extension:Update(context, result)
	end
end

return CameraPipeline
