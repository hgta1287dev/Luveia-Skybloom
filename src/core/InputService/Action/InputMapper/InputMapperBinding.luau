local InputMapperTypes = require(script.Parent.InputMapperTypes)

local BindingUtils = {}

type BindingConfig = InputMapperTypes.BindingConfig
type BindingSpec = InputMapperTypes.BindingSpec
type BindingRecord = InputMapperTypes.BindingRecord

local function keyOr(keyCode: Enum.KeyCode?): Enum.KeyCode
	return keyCode or Enum.KeyCode.Unknown
end

local function valueOr<T>(value: T?, defaultValue: T): T
	return value ~= nil and value or defaultValue
end

local function applyD1(spec: BindingSpec, config: BindingConfig)
	spec.ClampMagnitudeToOne = valueOr(config.ClampMagnitudeToOne, false)
	spec.Up = keyOr(config.Up)
	spec.Down = keyOr(config.Down)
end

local function applyD2(spec: BindingSpec, config: BindingConfig)
	applyD1(spec, config)
	spec.Left = keyOr(config.Left)
	spec.Right = keyOr(config.Right)
end

local function applyD3(spec: BindingSpec, config: BindingConfig)
	applyD2(spec, config)
	spec.Forward = keyOr(config.Forward)
	spec.Backward = keyOr(config.Backward)
end

function BindingUtils.ConvertSpec(actionType: Enum.InputActionType, config: BindingConfig): BindingSpec
	local spec: any = {
		PrimaryModifier = keyOr(config.PrimaryModifier),
		SecondaryModifier = keyOr(config.SecondaryModifier),

		KeyCode = Enum.KeyCode.Unknown,
		UIButton = nil,

		ClampMagnitudeToOne = false,
		Scale = 1,
		Vector2Scale = Vector2.new(1, 1),
		Vector3Scale = Vector3.new(1, 1, 1),

		Up = Enum.KeyCode.Unknown,
		Down = Enum.KeyCode.Unknown,
		Left = Enum.KeyCode.Unknown,
		Right = Enum.KeyCode.Unknown,
		Forward = Enum.KeyCode.Unknown,
		Backward = Enum.KeyCode.Unknown,
	}

	if actionType == Enum.InputActionType.Bool then
		spec.KeyCode = keyOr(config.KeyCode)
		spec.UIButton = config.UIButton
		return spec :: BindingSpec
	end

	if actionType == Enum.InputActionType.ViewportPosition then
		spec.KeyCode = keyOr(config.KeyCode)
		return spec :: BindingSpec
	end

	if actionType == Enum.InputActionType.Direction1D then
		spec.KeyCode = keyOr(config.KeyCode)
		spec.Scale = valueOr(config.Scale, 1)
		applyD1(spec :: BindingSpec, config)
		return spec :: BindingSpec
	end

	if actionType == Enum.InputActionType.Direction2D then
		spec.KeyCode = keyOr(config.KeyCode)
		spec.Vector2Scale = valueOr(config.Vector2Scale, Vector2.new(1, 1))
		applyD2(spec :: BindingSpec, config)
		return spec :: BindingSpec
	end

	if actionType == Enum.InputActionType.Direction3D then
		spec.Vector3Scale = valueOr(config.Vector3Scale, Vector3.new(1, 1, 1))
		applyD3(spec :: BindingSpec, config)
		return spec :: BindingSpec
	end

	error(("Unsupported InputActionType: %s"):format(actionType.Name))
end

function BindingUtils.ApplySpec(binding: InputBinding, actionType: Enum.InputActionType, spec: BindingSpec)
	binding.PrimaryModifier = spec.PrimaryModifier
	binding.SecondaryModifier = spec.SecondaryModifier

	if actionType == Enum.InputActionType.Bool then
		binding.KeyCode = spec.KeyCode
		if spec.UIButton then
			binding.UIButton = spec.UIButton
		end
		return
	end

	if actionType == Enum.InputActionType.ViewportPosition then
		binding.KeyCode = spec.KeyCode
		return
	end

	if actionType == Enum.InputActionType.Direction1D then
		binding.KeyCode = spec.KeyCode
		binding.Scale = spec.Scale
		binding.ClampMagnitudeToOne = spec.ClampMagnitudeToOne
		binding.Up = spec.Up
		binding.Down = spec.Down
		return
	end

	if actionType == Enum.InputActionType.Direction2D then
		binding.KeyCode = spec.KeyCode
		binding.Vector2Scale = spec.Vector2Scale
		binding.ClampMagnitudeToOne = spec.ClampMagnitudeToOne
		binding.Up = spec.Up
		binding.Down = spec.Down
		binding.Left = spec.Left
		binding.Right = spec.Right
		return
	end

	if actionType == Enum.InputActionType.Direction3D then
		binding.Vector3Scale = spec.Vector3Scale
		binding.ClampMagnitudeToOne = spec.ClampMagnitudeToOne
		binding.Up = spec.Up
		binding.Down = spec.Down
		binding.Left = spec.Left
		binding.Right = spec.Right
		binding.Forward = spec.Forward
		binding.Backward = spec.Backward
		return
	end

	error(`Unsupported InputActionType: {actionType.Name}`)
end

function BindingUtils.ApplyConfig(binding: InputBinding, actionType: Enum.InputActionType, config: BindingConfig)
	local spec = BindingUtils.ConvertSpec(actionType, config)
	BindingUtils.ApplySpec(binding, actionType, spec)
end

function BindingUtils.CreateBinding(actionType: Enum.InputActionType, config: BindingConfig): InputBinding
	local binding = Instance.new("InputBinding")
	BindingUtils.ApplyConfig(binding, actionType, config)
	return binding
end

function BindingUtils.UpdateRecord(record: BindingRecord, actionType: Enum.InputActionType, config: BindingConfig)
	local instance = record.Instance
	if not instance then
		instance = BindingUtils.CreateBinding(actionType, config)
	end

	local spec = BindingUtils.ConvertSpec(actionType, config)
	BindingUtils.ApplySpec(instance, actionType, spec)

	record.Spec = spec
	record.Instance = instance
end

function BindingUtils.CreateRecord(actionType: Enum.InputActionType, config: BindingConfig): BindingRecord
	local spec = BindingUtils.ConvertSpec(actionType, config)
	local binding = BindingUtils.CreateBinding(actionType, config)
	local record: BindingRecord = {
		Instance = binding,
		Spec = spec,
	}
	return record
end

return BindingUtils
