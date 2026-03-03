local Lighting = game:GetService("Lighting")
local LightingTypes = require(script.Parent.LightingTypes)

-- * Types
export type LightingConfig = LightingTypes.LightingConfig
export type LightingProps = LightingTypes.LightingProps

-- * Constants
local DEFAULTCONFIG: LightingConfig = {
	Ambient = Color3.fromRGB(70, 70, 70),
	Brightness = 3,
	ColorShift_Bottom = Color3.fromRGB(0, 0, 0),
	ColorShift_Top = Color3.fromRGB(0, 0, 0),
	EnvironmentDiffuseScale = 1,
	EnvironmentSpecularScale = 1,
	GlobalShadows = false,
	OutdoorAmbient = Color3.fromRGB(70, 70, 70),
	ShadowSoftness = 0.03,
	ClockTime = 12,
	GeographicLatitude = 0,
	ExposureCompensation = 0,
	FogColor = Color3.fromRGB(70, 70, 70),
	FogEnd = 1000,
	FogStart = 0,

	Atmosphere = true,
	AtmosphereDensity = 0.3,
	AtmosphereOffset = 0.25,
	AtmosphereColor = Color3.fromRGB(70, 70, 70),
	AtmosphereDecay = Color3.fromRGB(70, 70, 70),
	AtmosphereGlare = 0,
	AtmosphereHaze = 0,

	Sky = true,
	SkyCelestialBodiesShown = true,
	SkyMoonAngularSize = 11,
	SkyMoonTextureId = "rbxassetid://6444320592",
	SkySkyboxBk = "rbxassetid://6444884337",
	SkySkyboxDn = "rbxassetid://6444884785",
	SkySkyboxFt = "rbxassetid://6444884337",
	SkySkyboxLf = "rbxassetid://6444884337",
	SkySkyboxRt = "rbxassetid://6444884337",
	SkySkyboxUp = "rbxassetid://6412503613",
	SkySkyboxOrientation = Vector3.new(0, 0, 0),
	SkyStarCount = 3000,
	SkySunAngularSize = 11,
	SkySunTextureId = "rbxassetid://6196665106",

	Bloom = true,
	BloomIntensity = 1,
	BloomSize = 24,
	BloomThreshold = 2,

	Blur = false,
	BlurSize = 2,

	ColorCorrection = false,
	ColorCorrectionBrightness = 0,
	ColorCorrectionContrast = 0,
	ColorCorrectionSaturation = 0,
	ColorCorrectionTintColor = Color3.fromRGB(255, 255, 255),

	ColorGrading = false,
	ColorGradingTonemapperPreset = Enum.TonemapperPreset.Default,

	DepthOfField = false,
	DepthOfFieldFarIntensity = 0.1,
	DepthOfFieldFocusDistance = 0.05,
	DepthOfFieldInFocusRadius = 30,
	DepthOfFieldNearIntensity = 0.75,

	SunRays = false,
	SunRaysIntensity = 0.01,
	SunRaysSpread = 0.1,
}

local Lightings = {}
Lightings.__index = Lightings

function Lightings.new()
	local self = setmetatable({
		atmosphere = nil :: Atmosphere?,
		sky = nil :: Sky?,
		bloom = nil :: BloomEffect?,
		colorCorrection = nil :: ColorCorrectionEffect?,
		colorGrading = nil :: ColorGradingEffect?,
		blur = nil :: BlurEffect?,
		depthOfField = nil :: DepthOfFieldEffect?,
		sunRays = nil :: SunRaysEffect?,
	}, Lightings)

	self:Apply(DEFAULTCONFIG)
	return self
end

function Lightings:Apply(props: LightingProps)
	local config = table.clone(DEFAULTCONFIG) :: LightingConfig
	for key, value in pairs(props) do
		config[key] = value
	end

	Lighting.Ambient = config.Ambient
	Lighting.Brightness = config.Brightness
	Lighting.ColorShift_Bottom = config.ColorShift_Bottom
	Lighting.ColorShift_Top = config.ColorShift_Top
	Lighting.EnvironmentDiffuseScale = config.EnvironmentDiffuseScale
	Lighting.EnvironmentSpecularScale = config.EnvironmentSpecularScale
	Lighting.GlobalShadows = config.GlobalShadows
	Lighting.OutdoorAmbient = config.OutdoorAmbient
	Lighting.ShadowSoftness = config.ShadowSoftness
	Lighting.ClockTime = config.ClockTime
	Lighting.GeographicLatitude = config.GeographicLatitude
	Lighting.ExposureCompensation = config.ExposureCompensation
	Lighting.FogColor = config.FogColor
	Lighting.FogEnd = config.FogEnd
	Lighting.FogStart = config.FogStart

	self.atmosphere = self.atmosphere or Lighting:FindFirstChildWhichIsA("Atmosphere") or Instance.new("Atmosphere")
	local atmosphere: Atmosphere = self.atmosphere
	atmosphere.Parent = config.Atmosphere and Lighting or nil
	atmosphere.Density = config.AtmosphereDensity
	atmosphere.Offset = config.AtmosphereOffset
	atmosphere.Color = config.AtmosphereColor
	atmosphere.Decay = config.AtmosphereDecay
	atmosphere.Glare = config.AtmosphereGlare
	atmosphere.Haze = config.AtmosphereHaze

	self.sky = self.sky or Lighting:FindFirstChildWhichIsA("Sky") or Instance.new("Sky")
	local sky: Sky = self.sky
	sky.Parent = config.Sky and Lighting or nil
	sky.CelestialBodiesShown = config.SkyCelestialBodiesShown
	sky.SkyboxBk = config.SkySkyboxBk
	sky.SkyboxDn = config.SkySkyboxDn
	sky.SkyboxFt = config.SkySkyboxFt
	sky.SkyboxLf = config.SkySkyboxLf
	sky.SkyboxRt = config.SkySkyboxRt
	sky.SkyboxUp = config.SkySkyboxUp
	sky.SkyboxOrientation = config.SkySkyboxOrientation
	sky.StarCount = config.SkyStarCount
	sky.MoonAngularSize = config.SkyMoonAngularSize
	sky.MoonTextureId = config.SkyMoonTextureId
	sky.SunAngularSize = config.SkySunAngularSize
	sky.SunTextureId = config.SkySunTextureId

	self.bloom = self.bloom or Lighting:FindFirstChildWhichIsA("BloomEffect") or Instance.new("BloomEffect")
	local bloom: BloomEffect = self.bloom
	bloom.Parent = Lighting
	bloom.Enabled = config.Bloom
	bloom.Intensity = config.BloomIntensity
	bloom.Size = config.BloomSize
	bloom.Threshold = config.BloomThreshold

	self.colorCorrection = self.colorCorrection
		or Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")
		or Instance.new("ColorCorrectionEffect")
	local colorCorrection: ColorCorrectionEffect = self.colorCorrection
	colorCorrection.Parent = Lighting
	colorCorrection.Enabled = config.ColorCorrection
	colorCorrection.Brightness = config.ColorCorrectionBrightness
	colorCorrection.Contrast = config.ColorCorrectionContrast
	colorCorrection.Saturation = config.ColorCorrectionSaturation
	colorCorrection.TintColor = config.ColorCorrectionTintColor

	self.colorGrading = self.colorGrading
		or Lighting:FindFirstChildWhichIsA("ColorGradingEffect")
		or Instance.new("ColorGradingEffect")
	local colorGrading: ColorGradingEffect = self.colorGrading
	colorGrading.Parent = Lighting
	colorGrading.Enabled = config.ColorGrading
	colorGrading.TonemapperPreset = config.ColorGradingTonemapperPreset

	self.blur = self.blur or Lighting:FindFirstChildWhichIsA("BlurEffect") or Instance.new("BlurEffect")
	local blur: BlurEffect = self.blur
	blur.Parent = Lighting
	blur.Enabled = config.Blur
	blur.Size = config.BlurSize

	self.depthOfField = self.depthOfField
		or Lighting:FindFirstChildWhichIsA("DepthOfFieldEffect")
		or Instance.new("DepthOfFieldEffect")
	local depthOfField: DepthOfFieldEffect = self.depthOfField
	depthOfField.Parent = Lighting
	depthOfField.Enabled = config.DepthOfField
	depthOfField.FarIntensity = config.DepthOfFieldFarIntensity
	depthOfField.FocusDistance = config.DepthOfFieldFocusDistance
	depthOfField.InFocusRadius = config.DepthOfFieldInFocusRadius
	depthOfField.NearIntensity = config.DepthOfFieldNearIntensity

	self.sunRays = self.sunRays or Lighting:FindFirstChildWhichIsA("SunRaysEffect") or Instance.new("SunRaysEffect")
	local sunRays: SunRaysEffect = self.sunRays
	sunRays.Parent = Lighting
	sunRays.Enabled = config.SunRays
	sunRays.Intensity = config.SunRaysIntensity
	sunRays.Spread = config.SunRaysSpread
end

return Lightings.new()
