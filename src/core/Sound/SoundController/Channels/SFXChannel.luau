local BaseSoundChannel = require(script.Parent.BaseSoundChannel)

local SFXChannel = setmetatable({}, BaseSoundChannel)

-- * Types
export type SFXChannel = typeof(setmetatable({} :: {}, SFXChannel))

-- * Constructor
function SFXChannel.new(): SFXChannel
	local self = setmetatable(BaseSoundChannel.new(), SFXChannel)
	return self
end

-- * Transition

return SFXChannel
