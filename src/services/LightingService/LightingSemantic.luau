local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingTypes = require(ReplicatedStorage.Shared.Services.LightingService.LightingTypes)

-- * Types
type Props = LightingTypes.LightingProps

-- * Constants
local Semantic: { [string]: { [string]: Props } } = {}

Semantic.TimeOfDay = {
	Morning = {
		ClockTime = 8,
		Brightness = 2.5,
	},

	Noon = {
		ClockTime = 12,
		Brightness = 3,
	},

	Night = {
		ClockTime = 22,
		Brightness = 1.5,
	},
}

Semantic.Fog = {
	Normal = {
		FogEnd = 150,
		AtmosphereDensity = 0.6,
	},

	Dense = {
		FogEnd = 100,
		AtmosphereDensity = 0.8,
	},
}

Semantic.Mood = {
	Warm = {
		ColorCorrection = true,
		ColorCorrectionTintColor = Color3.fromRGB(255, 220, 180),
	},

	Cold = {
		ColorCorrection = true,
		ColorCorrectionTintColor = Color3.fromRGB(180, 220, 255),
	},
}

Semantic.Effect = {
	Foggy = {
		FogEnd = 150,
		AtmosphereDensity = 0.6,
	},

	Dream = {
		Bloom = true,
		BloomIntensity = 2,
		Blur = true,
		BlurSize = 4,
	},

	Rain = {
		ExposureCompensation = -0.5,
		AtmosphereDensity = 0.5,
	},
}

return Semantic
