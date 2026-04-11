local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local TweenUtils = require(ReplicatedStorage.Shared.Utils.TweenUtils)

local SoundChannel = {}
SoundChannel.__index = SoundChannel

type TweenInfoOption = TweenUtils.TweenInfoOption

export type SoundChannel = typeof(setmetatable(
	{} :: {
		group: SoundGroup,
		sounds: { [string]: Sound },
		volume: number,
	},
	SoundChannel
))

function SoundChannel.new(): SoundChannel
	local self = setmetatable({
		group = Instance.new("SoundGroup"),
		sounds = {},
		volume = 1,
	}, SoundChannel) :: SoundChannel

	self:Init()
	return self
end

function SoundChannel:Init()
	self.group.Name = "SoundChannelGroup"
	self.group.Parent = SoundService
	self.group.Volume = 1
end

function SoundChannel:FindSound(name: string): Sound?
	return self.sounds[name]
end

function SoundChannel:GetSound(name: string): Sound?
	local sound = self:FindSound(name)
	if not sound then
		warn(`Sound {name} not found in channel`)
	end
	return sound
end

function SoundChannel:RequireSound(name: string): Sound
	local sound = self:FindSound(name)
	if not sound then
		error(`Sound {name} not found in channel`)
	end
	return sound
end

function SoundChannel:AddSound(name: string, sound: Sound)
	if self.sounds[name] then
		warn(`Sound {name} already exists in channel, overwriting`)
	end

	self.sounds[name] = sound
	sound.Parent = self.group
	sound.SoundGroup = self.group
	sound:SetAttribute("BaseVolume", sound.Volume)
end

function SoundChannel:AddSounds(sounds: { [string]: Sound })
	for name, sound in pairs(sounds) do
		self:AddSound(name, sound)
	end
end

function SoundChannel:AddSoundFromContainer(parent: Instance, defineFilter: ((Sound) -> string?)?)
	for _, instance in ipairs(parent:GetDescendants()) do
		if instance:IsA("Sound") then
			local sound = instance :: Sound
			if defineFilter then
				local newName = defineFilter(sound)
				if newName then
					self:AddSound(newName, sound)
				end
			else
				self:AddSound(sound.Name, sound)
			end
		end
	end
end

function SoundChannel:SetSoundVolume(name: string, volume: number, info: TweenInfoOption?): Tween
	local sound = self:RequireSound(name)
	local tweenInfo = TweenUtils.createInfo(info)
	local tween = TweenService:Create(sound, tweenInfo, { Volume = volume })
	tween:Play()
	return tween
end

function SoundChannel:SetChannelVolume(volume: number, info: TweenInfoOption?): Tween
	self.volume = volume
	local tweenInfo = TweenUtils.createInfo(info)
	local tween = TweenService:Create(self.group, tweenInfo, { Volume = volume })
	tween:Play()
	return tween
end

function SoundChannel:SetOutputVolume(volume: number, info: TweenInfoOption?): Tween
	local tweenInfo = TweenUtils.createInfo(info)
	local tween = TweenService:Create(self.group, tweenInfo, { Volume = volume })
	tween:Play()
	return tween
end

function SoundChannel:Play(name: string): Sound
	local sound = self:RequireSound(name)
	sound:Play()
	return sound
end

function SoundChannel:Stop(name: string)
	local sound = self:RequireSound(name)
	sound:Stop()
end

function SoundChannel:StopAll()
	for _, sound in pairs(self.sounds) do
		sound:Stop()
	end
end

function SoundChannel:Pause(name: string)
	local sound = self:RequireSound(name)
	sound:Pause()
end

function SoundChannel:Resume(name: string)
	local sound = self:RequireSound(name)
	sound:Resume()
end

return SoundChannel
