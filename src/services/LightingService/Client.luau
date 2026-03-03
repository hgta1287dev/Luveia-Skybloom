local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingManager = require(script.Parent.LightingManager)
local LightingPresets = require(script.Parent.LightingPresets)
local Knit = require(ReplicatedStorage.Packages.Knit)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local Logger = LoggerManager:CreateLogger("LightingController")
local LightingController = Knit.CreateController({
	Name = "LightingController",
})

-- * Pulbic API
function LightingController:SetPreset(name: string)
	local preset = LightingPresets[name]
	if not preset then
		Logger:Warn(`Preset "{name}" not found!`)
		return
	end
	LightingManager:Apply(preset)
end

-- * Knit API
function LightingController:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)
	Logger:Info(KnitMessageConfig.Initialized)
end

function LightingController:KnitStart()
	Logger:Info(KnitMessageConfig.Starting)
	LightingManager:Apply(LightingPresets.Default)
	Logger:Info(KnitMessageConfig.Started)
end

return LightingController
