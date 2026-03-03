local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingTypes = require(script.Parent.LightingTypes)
local LightingPresets = require(ReplicatedStorage.Shared.Services.LightingService.LightingPresets)

local Composer = {}

-- * Types
export type Config = LightingTypes.LightingConfig
export type Props = LightingTypes.LightingProps

-- * Constants
local Defaults = LightingPresets.Default

-- * Private
local function MergeInto(target, source)
	for key, value in source do
		if target[key] ~= nil then
			target[key] = value
		else
			warn("Unknown lighting key:", key)
		end
	end
end

-- * Public
function Composer.Compose(...: Props): Config
	local result = table.clone(Defaults)

	for i = 1, select("#", ...) do
		local layer = select(i, ...)
		if layer then
			MergeInto(result, layer)
		end
	end

	return result
end

return Composer
