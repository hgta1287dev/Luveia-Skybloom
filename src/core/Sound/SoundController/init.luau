local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenUtils = require(ReplicatedStorage.Shared.Utils.TweenUtils)

local MusicChannel = require(script.Channels.MusicChannel)
local SFXChannel = require(script.Channels.SFXChannel)

local SoundController = {}
SoundController.__index = SoundController

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

function SoundController:_refreshVolumes(info: TweenInfoOption?)
	self.channels.Music:SetOutputVolume(self.channels.Music.volume * self.masterVolume, info)
	self.channels.SFX:SetOutputVolume(self.channels.SFX.volume * self.masterVolume, info)
end

function SoundController:SetMasterVolume(volume: number, info: TweenInfoOption?)
	self.masterVolume = volume
	self:_refreshVolumes(info)
end

function SoundController:SetVolume(volume: number, info: TweenInfoOption?)
	self:SetMasterVolume(volume, info)
end

function SoundController:SetChannelVolume(channelName: ChannelName, volume: number, info: TweenInfoOption?)
	local channel = self.channels[channelName]
	channel:SetChannelVolume(volume, info)
	channel:SetOutputVolume(channel.volume * self.masterVolume, info)
end

function SoundController:Play(channelName: ChannelName, soundName: string, options)
	local channel = self.channels[channelName]
	return channel:Play(soundName, options)
end

function SoundController:Stop(channelName: ChannelName, soundName: string)
	local channel = self.channels[channelName]
	channel:Stop(soundName)
end

function SoundController:PlayMusic(trackName: string)
	return self.channels.Music:Play(trackName)
end

function SoundController:CrossfadeMusic(fromName: string?, toName: string, duration: number?)
	return self.channels.Music:Crossfade(fromName, toName, duration)
end

function SoundController:StopMusic(trackName: string?)
	if trackName then
		self.channels.Music:Stop(trackName)
	else
		self.channels.Music:StopCurrent()
	end
end

function SoundController:PlaySFX(soundName: string, options)
	return self.channels.SFX:Play(soundName, options)
end

return SoundController.new()
