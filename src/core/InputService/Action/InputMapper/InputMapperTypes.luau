-- * Config
export type Config = {
	Parent: Instance?,
	ContainerName: string?,
	Contexts: { [string]: ContextConfig }?,
}

-- * Contexts
export type ContextConfig = {
	Sink: boolean?,
	Enabled: boolean?,
	Priority: number?,
	Actions: { [string]: ActionConfig }?,
}

export type ContextSpec = {
	Sink: boolean,
	Enabled: boolean,
	Priority: number,
	Actions: { [string]: ActionSpec },
}

export type ContextRecord = {
	Spec: ContextSpec,
	Instance: InputContext,
	Actions: { [string]: ActionRecord },
}

-- * Actions
export type ActionConfig = {
	Enabled: boolean?,
	Type: Enum.InputActionType, --! required
	Bindings: { [string]: BindingConfig }?,
}

export type ActionSpec = {
	Enabled: boolean,
	Type: Enum.InputActionType,
	Bindings: { [string]: BindingSpec },
}

export type ActionRecord = {
	Spec: ActionSpec,
	Instance: InputAction,
	Bindings: { [string]: BindingRecord },
}

-- * Bindings
export type BindingConfig = {
	PrimaryModifier: Enum.KeyCode?,
	SecondaryModifier: Enum.KeyCode?,

	KeyCode: Enum.KeyCode?,
	UIButton: GuiButton?,

	ClampMagnitudeToOne: boolean?,
	Scale: number?,
	Vector2Scale: Vector2?,
	Vector3Scale: Vector3?,

	Up: Enum.KeyCode?,
	Down: Enum.KeyCode?,
	Left: Enum.KeyCode?,
	Right: Enum.KeyCode?,
	Forward: Enum.KeyCode?,
	Backward: Enum.KeyCode?,
}

export type BindingSpec = {
	PrimaryModifier: Enum.KeyCode,
	SecondaryModifier: Enum.KeyCode,

	KeyCode: Enum.KeyCode,
	UIButton: GuiButton?,

	ClampMagnitudeToOne: boolean,
	Scale: number,
	Vector2Scale: Vector2,
	Vector3Scale: Vector3,

	Up: Enum.KeyCode,
	Down: Enum.KeyCode,
	Left: Enum.KeyCode,
	Right: Enum.KeyCode,
	Forward: Enum.KeyCode,
	Backward: Enum.KeyCode,
}

export type BindingRecord = {
	Spec: BindingSpec,
	Instance: InputBinding,
}

return {}
