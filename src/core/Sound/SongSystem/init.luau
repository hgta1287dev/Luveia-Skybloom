local SoundController = require(script.Parent.SoundController)

local SongSystem = {}
SongSystem.__index = SongSystem

function SongSystem.new()
	local self = setmetatable({}, SongSystem)

	self.sound = SoundController
	self.current = nil
	self.next = nil

	return self
end

function SongSystem:Play(trackName)
	if self.current then
		self.sound.channels.Music:SetVolume(trackName, 0)
	end

	self.sound:Play("Music", trackName)
	self.current = trackName
end

return SongSystem.new()
