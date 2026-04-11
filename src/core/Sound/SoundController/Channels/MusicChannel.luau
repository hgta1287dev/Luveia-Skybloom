local BaseSoundChannel = require(script.Parent.BaseSoundChannel)

local MusicChannel = setmetatable({}, BaseSoundChannel)

-- * Types
export type MusicChannel = typeof(setmetatable(
	{} :: {
		sounds: { [string]: Sound },
		group: SoundGroup,
	},
	MusicChannel
))

-- * Constructor
function MusicChannel.new(): MusicChannel
	local self = setmetatable(BaseSoundChannel.new(), MusicChannel)
	return self
end

return MusicChannel
