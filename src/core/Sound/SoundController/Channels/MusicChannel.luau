local TweenService = game:GetService("TweenService")
local BaseSoundChannel = require(script.Parent.BaseSoundChannel)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenUtils = require(ReplicatedStorage.Shared.Utils.TweenUtils)

local MusicChannel = {}
MusicChannel.__index = MusicChannel

export type MusicChannel = typeof(setmetatable(
	{} :: {
		group: SoundGroup,
		sounds: { [string]: Sound },
		volume: number,
		currentName: string?,
		currentSound: Sound?,
	},
	MusicChannel
))

type TweenInfoOption = TweenUtils.TweenInfoOption

function MusicChannel.new(): MusicChannel
	local self = BaseSoundChannel.new()
	setmetatable(self, MusicChannel)

	self.currentName = nil
	self.currentSound = nil
	return self
end

function MusicChannel:GetCurrentName(): string?
	return self.currentName
end

function MusicChannel:GetCurrentSound(): Sound?
	return self.currentSound
end

function MusicChannel:Play(name: string): Sound
	local sound = self:RequireSound(name)

	if self.currentSound and self.currentSound ~= sound then
		self.currentSound:Stop()
	end

	self.currentName = name
	self.currentSound = sound
	sound:Play()
	return sound
end

function MusicChannel:StopCurrent()
	if self.currentSound then
		self.currentSound:Stop()
	end

	self.currentName = nil
	self.currentSound = nil
end

function MusicChannel:Crossfade(fromName: string?, toName: string, duration: number?, info: TweenInfoOption?): Sound
	local toSound = self:RequireSound(toName)
	local fromSound = fromName and self:GetSound(fromName) or self.currentSound

	if fromSound == toSound then
		self.currentName = toName
		self.currentSound = toSound
		return toSound
	end

	local tweenInfo = TweenUtils.createInfo(info or {
		Time = duration or 1,
	})

	local baseVolume = toSound:GetAttribute("BaseVolume")
	local targetVolume = if typeof(baseVolume) == "number" then baseVolume else toSound.Volume

	if fromSound and fromSound ~= toSound then
		TweenService:Create(fromSound, tweenInfo, { Volume = 0 }):Play()
	end

	toSound.Volume = 0
	toSound:Play()

	TweenService:Create(toSound, tweenInfo, { Volume = targetVolume }):Play()

	self.currentName = toName
	self.currentSound = toSound

	return toSound
end

return MusicChannel
