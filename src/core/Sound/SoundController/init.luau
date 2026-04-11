local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenUtils = require(ReplicatedStorage.Shared.Utils.TweenUtils)
local MusicChannel = require(script.Channels.MusicChannel)
local SFXChannel = require(script.Channels.SFXChannel)
local SoundController = {}
SoundController.__index = SoundController

-- * Types
type TweenInfoOption = TweenUtils.TweenInfoOption
export type ChannelName = "Music" | "SFX"
export type SoundController = typeof(setmetatable(
	{} :: {
		masterVolume: number,
		channels: {
			Music: MusicChannel.MusicChannel,
			SFX: SFXChannel.SFXChannel,
		},
	},
	SoundController
))

-- * Constructor
function SoundController.new(): SoundController
	local self = setmetatable({
		masterVolume = 1,
		channels = {
			Music = MusicChannel.new(),
			SFX = SFXChannel.new(),
		},
	}, SoundController)
	return self
end

-- * Setters
function SoundController:SetVolume(volume: number, info: TweenInfoOption)
	self.masterVolume = volume

	self.channels.Music:SetChannelVolume(volume, info)
	self.channels.SFX:SetChannelVolume(volume, info)
end

-- * Main API
function SoundController:Play(channelName: string, soundName: string)
	local channel = self.channels[channelName]
	channel:Play(soundName)
end

function SoundController:Stop(channelName: string, soundName: string)
	local channel = self.channels[channelName]
	channel:Stop(soundName)
end

return SoundController.new()
