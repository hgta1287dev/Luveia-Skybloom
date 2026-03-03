export type LightingConfig = {
	-- * Lighting
	Ambient: Color3,
	Brightness: number,
	ColorShift_Bottom: Color3,
	ColorShift_Top: Color3,
	EnvironmentDiffuseScale: number,
	EnvironmentSpecularScale: number,
	GlobalShadows: boolean,
	OutdoorAmbient: Color3,
	ShadowSoftness: number,
	ClockTime: number,
	GeographicLatitude: number,
	ExposureCompensation: number,
	FogColor: Color3,
	FogEnd: number,
	FogStart: number,

	-- * Atmosphere
	Atmosphere: boolean,

	AtmosphereDensity: number,
	AtmosphereOffset: number,
	AtmosphereColor: Color3,
	AtmosphereDecay: Color3,
	AtmosphereGlare: number,
	AtmosphereHaze: number,

	-- * Sky
	Sky: boolean,
	SkyCelestialBodiesShown: boolean,
	SkySkyboxBk: string,
	SkySkyboxDn: string,
	SkySkyboxFt: string,
	SkySkyboxLf: string,
	SkySkyboxRt: string,
	SkySkyboxUp: string,
	SkySkyboxOrientation: Vector3,
	SkyStarCount: number,
	SkyMoonAngularSize: number,
	SkyMoonTextureId: string,
	SkySunAngularSize: number,
	SkySunTextureId: string,

	-- * Bloom
	Bloom: boolean,
	BloomIntensity: number,
	BloomSize: number,
	BloomThreshold: number,

	-- * ColorCorrection
	ColorCorrection: boolean,
	ColorCorrectionBrightness: number,
	ColorCorrectionContrast: number,
	ColorCorrectionSaturation: number,
	ColorCorrectionTintColor: Color3,

	-- * ColorGrading
	ColorGrading: boolean,
	ColorGradingTonemapperPreset: Enum.TonemapperPreset,

	-- * Blur
	Blur: boolean,
	BlurSize: number,

	-- * DepthOfField
	DepthOfField: boolean,
	DepthOfFieldFocusDistance: number,
	DepthOfFieldInFocusRadius: number,
	DepthOfFieldFarIntensity: number,
	DepthOfFieldNearIntensity: number,

	-- * SunRays
	SunRays: boolean,
	SunRaysIntensity: number,
	SunRaysSpread: number,
}

export type LightingProps = {
	-- * Lighting
	Ambient: Color3?,
	Brightness: number?,
	ColorShift_Bottom: Color3?,
	ColorShift_Top: Color3?,
	EnvironmentDiffuseScale: number?,
	EnvironmentSpecularScale: number?,
	GlobalShadows: boolean?,
	OutdoorAmbient: Color3?,
	ShadowSoftness: number?,
	ClockTime: number?,
	GeographicLatitude: number?,
	ExposureCompensation: number?,
	FogColor: Color3?,
	FogEnd: number?,
	FogStart: number?,

	-- * Atmosphere
	Atmosphere: boolean?,
	AtmosphereDensity: number?,
	AtmosphereOffset: number?,
	AtmosphereColor: Color3?,
	AtmosphereDecay: Color3?,
	AtmosphereGlare: number?,
	AtmosphereHaze: number?,

	-- * Sky
	Sky: boolean?,
	SkyCelestialBodiesShown: boolean?,
	SkySkyboxBk: string?,
	SkySkyboxDn: string?,
	SkySkyboxFt: string?,
	SkySkyboxLf: string?,
	SkySkyboxRt: string?,
	SkySkyboxUp: string?,
	SkySkyboxOrientation: Vector3?,
	SkyStarCount: number?,
	SkyMoonAngularSize: number?,
	SkyMoonTextureId: string?,
	SkySunAngularSize: number?,
	SkySunTextureId: string?,

	-- * Bloom
	Bloom: boolean?,
	BloomIntensity: number?,
	BloomSize: number?,
	BloomThreshold: number?,

	-- * ColorCorrection
	ColorCorrection: boolean?,
	ColorCorrectionBrightness: number?,
	ColorCorrectionContrast: number?,
	ColorCorrectionSaturation: number?,
	ColorCorrectionTintColor: Color3?,

	-- * ColorGrading
	ColorGrading: boolean?,
	ColorGradingTonemapperPreset: Enum.TonemapperPreset?,

	-- * Blur
	Blur: boolean?,
	BlurSize: number?,

	-- * DepthOfField
	DepthOfField: boolean?,
	DepthOfFieldFocusDistance: number?,
	DepthOfFieldInFocusRadius: number?,
	DepthOfFieldFarIntensity: number?,
	DepthOfFieldNearIntensity: number?,

	-- * SunRays
	SunRays: boolean?,
	SunRaysIntensity: number?,
	SunRaysSpread: number?,
}

return {}
