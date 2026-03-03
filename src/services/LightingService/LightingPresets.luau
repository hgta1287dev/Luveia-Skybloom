local LightingTypes = require(script.Parent.LightingTypes)

-- * Types
export type Props = LightingTypes.LightingProps
export type Config = LightingTypes.LightingConfig

-- * Presets
local Presets = {
	Default = {
		-- Lighting core
		Ambient = Color3.fromRGB(200, 160, 225),
		Brightness = 2.3,
		ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
		ColorShift_Top = Color3.fromRGB(240, 240, 130),
		EnvironmentDiffuseScale = 0.3,
		EnvironmentSpecularScale = 0.25,
		GlobalShadows = true,
		OutdoorAmbient = Color3.fromRGB(70, 70, 150),
		ShadowSoftness = 0.03,
		ClockTime = 11,
		GeographicLatitude = 50,
		ExposureCompensation = 0,

		FogColor = Color3.fromRGB(70, 70, 70),
		FogEnd = 1000,
		FogStart = 0,

		-- Atmosphere
		Atmosphere = true,
		AtmosphereDensity = 0.35,
		AtmosphereOffset = 1,
		AtmosphereColor = Color3.fromRGB(200, 200, 255),
		AtmosphereDecay = Color3.fromRGB(200, 200, 255),
		AtmosphereGlare = 1.5,
		AtmosphereHaze = 10,

		-- Sky
		Sky = true,
		SkyCelestialBodiesShown = true,
		SkyMoonAngularSize = 11,
		SkyMoonTextureId = "rbxassetid://6444320592",
		SkySkyboxBk = "http://www.roblox.com/asset/?ID=1361097",
		SkySkyboxDn = "http://www.roblox.com/asset/?ID=1361097",
		SkySkyboxFt = "http://www.roblox.com/asset/?ID=1361097",
		SkySkyboxLf = "http://www.roblox.com/asset/?ID=1361097",
		SkySkyboxRt = "http://www.roblox.com/asset/?ID=1361097",
		SkySkyboxUp = "http://www.roblox.com/asset/?ID=1361097",
		SkySkyboxOrientation = Vector3.new(0, 0, 0),
		SkyStarCount = 3000,
		SkySunAngularSize = 60,
		SkySunTextureId = "rbxasset://sky/sun.jpg",

		-- Bloom
		Bloom = true,
		BloomIntensity = 1,
		BloomSize = 50,
		BloomThreshold = 2,

		-- Blur
		Blur = true,
		BlurSize = 1,

		-- ColorCorrection
		ColorCorrection = true,
		ColorCorrectionBrightness = 0.05,
		ColorCorrectionContrast = 0.2,
		ColorCorrectionSaturation = 0.2,
		ColorCorrectionTintColor = Color3.fromRGB(232, 226, 255),

		-- ColorGrading (missing before)
		ColorGrading = false,
		ColorGradingTonemapperPreset = Enum.TonemapperPreset.Default,

		-- DepthOfField
		DepthOfField = true,
		DepthOfFieldFarIntensity = 1,
		DepthOfFieldFocusDistance = 20,
		DepthOfFieldInFocusRadius = 10,
		DepthOfFieldNearIntensity = 0.4,

		-- SunRays
		SunRays = true,
		SunRaysIntensity = 1,
		SunRaysSpread = 1,
	} :: LightingTypes.LightingConfig,
}

return Presets
