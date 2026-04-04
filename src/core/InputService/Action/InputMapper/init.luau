local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputMapperContext = require(script.InputMapperContext)
local InputMapperTypes = require(script.InputMapperTypes)

type Config = InputMapperTypes.Config
type ContextConfig = InputMapperTypes.ContextConfig
type ActionConfig = InputMapperTypes.ActionConfig
type BindingConfig = InputMapperTypes.BindingConfig

type ContextRecord = InputMapperTypes.ContextRecord
type ActionRecord = InputMapperTypes.ActionRecord
type BindingRecord = InputMapperTypes.BindingRecord

type ContextSpec = InputMapperTypes.ContextSpec
type ActionSpec = InputMapperTypes.ActionSpec
type BindingSpec = InputMapperTypes.BindingSpec

local InputMapper = {}
InputMapper.__index = InputMapper

local function cloneContexts(contexts: { [string]: ContextConfig }?): { [string]: ContextConfig }
	local result: { [string]: ContextConfig } = {}
	for contextName, contextConfig in pairs(contexts or {}) do
		result[contextName] = contextConfig
	end
	return result
end

local function enumToName(value: EnumItem?): string?
	return value and value.Name or nil
end

local function keyCodeFromName(name: any): Enum.KeyCode?
	if type(name) ~= "string" then
		return nil
	end
	return Enum.KeyCode:FromName(name) or Enum.KeyCode.Unknown
end

local function actionTypeFromName(name: any): Enum.InputActionType?
	if type(name) ~= "string" then
		return nil
	end
	return Enum.InputActionType:FromName(name)
end

local function vector2FromTable(value: any): Vector2?
	if type(value) ~= "table" then
		return nil
	end
	return Vector2.new(tonumber(value[1]) or 1, tonumber(value[2]) or 1)
end

local function vector3FromTable(value: any): Vector3?
	if type(value) ~= "table" then
		return nil
	end
	return Vector3.new(tonumber(value[1]) or 1, tonumber(value[2]) or 1, tonumber(value[3]) or 1)
end

local function exportBindingSpec(spec: BindingSpec): any
	return {
		PrimaryModifier = enumToName(spec.PrimaryModifier),
		SecondaryModifier = enumToName(spec.SecondaryModifier),

		KeyCode = enumToName(spec.KeyCode),
		ClampMagnitudeToOne = spec.ClampMagnitudeToOne,
		Scale = spec.Scale,
		Vector2Scale = { spec.Vector2Scale.X, spec.Vector2Scale.Y },
		Vector3Scale = { spec.Vector3Scale.X, spec.Vector3Scale.Y, spec.Vector3Scale.Z },

		Up = enumToName(spec.Up),
		Down = enumToName(spec.Down),
		Left = enumToName(spec.Left),
		Right = enumToName(spec.Right),
		Forward = enumToName(spec.Forward),
		Backward = enumToName(spec.Backward),
	}
end

local function exportActionSpec(spec: ActionSpec): any
	local bindings: { [string]: any } = {}
	for bindingName, bindingRecord in pairs(spec.Bindings) do
		bindings[bindingName] = exportBindingSpec(bindingRecord)
	end

	return {
		Enabled = spec.Enabled,
		Type = enumToName(spec.Type),
		Bindings = bindings,
	}
end

local function exportContextSpec(spec: ContextSpec): any
	local actions: { [string]: any } = {}
	for actionName, actionRecord in pairs(spec.Actions) do
		actions[actionName] = exportActionSpec(actionRecord)
	end

	return {
		Sink = spec.Sink,
		Enabled = spec.Enabled,
		Priority = spec.Priority,
		Actions = actions,
	}
end

local function importBindingConfig(data: any): BindingConfig
	return {
		PrimaryModifier = keyCodeFromName(data.PrimaryModifier),
		SecondaryModifier = keyCodeFromName(data.SecondaryModifier),

		KeyCode = keyCodeFromName(data.KeyCode),
		ClampMagnitudeToOne = data.ClampMagnitudeToOne,
		Scale = data.Scale,
		Vector2Scale = vector2FromTable(data.Vector2Scale),
		Vector3Scale = vector3FromTable(data.Vector3Scale),

		Up = keyCodeFromName(data.Up),
		Down = keyCodeFromName(data.Down),
		Left = keyCodeFromName(data.Left),
		Right = keyCodeFromName(data.Right),
		Forward = keyCodeFromName(data.Forward),
		Backward = keyCodeFromName(data.Backward),
	}
end

local function importActionConfig(data: any): ActionConfig
	local actionType = actionTypeFromName(data.Type)
	assert(actionType, ("Invalid InputActionType: %s"):format(tostring(data.Type)))

	local bindings: { [string]: BindingConfig }? = nil
	if type(data.Bindings) == "table" then
		bindings = {}
		for bindingName, bindingData in pairs(data.Bindings) do
			(bindings :: any)[bindingName] = importBindingConfig(bindingData)
		end
	end

	return {
		Enabled = data.Enabled,
		Type = actionType,
		Bindings = bindings,
	}
end

local function importContextConfig(data: any): ContextConfig
	local actions: { [string]: ActionConfig }? = nil
	if type(data.Actions) == "table" then
		actions = {}
		for actionName, actionData in pairs(data.Actions) do
			(actions :: any)[actionName] = importActionConfig(actionData)
		end
	end

	return {
		Sink = data.Sink,
		Enabled = data.Enabled,
		Priority = data.Priority,
		Actions = actions,
	}
end

function InputMapper.new(config: Config)
	local self = setmetatable({}, InputMapper)

	local container = Instance.new("Folder")
	container.Name = config.ContainerName or "InputSystem"
	container.Parent = config.Parent or ReplicatedStorage

	self._config = {
		Parent = config.Parent,
		ContainerName = config.ContainerName,
		Contexts = cloneContexts(config.Contexts),
	}

	self._container = container
	self._contexts = {} :: { [string]: ContextRecord }
	self._connections = {} :: { [string]: { RBXScriptConnection } }

	self:Build()
	return self
end

function InputMapper:_ensureContextConfig(contextName: string): ContextConfig
	self._config.Contexts = self._config.Contexts or {}

	local contextConfig = self._config.Contexts[contextName]
	if not contextConfig then
		contextConfig = {
			Actions = {},
		}
		self._config.Contexts[contextName] = contextConfig
	elseif contextConfig.Actions == nil then
		contextConfig.Actions = {}
	end

	return contextConfig
end

function InputMapper:_clearConnections(contextName: string)
	local list = self._connections[contextName]
	if not list then
		return
	end

	for _, conn in ipairs(list) do
		conn:Disconnect()
	end

	self._connections[contextName] = nil
end

function InputMapper:_syncRecordParents()
	for _, contextRecord in pairs(self._contexts) do
		if contextRecord.Instance then
			contextRecord.Instance.Parent = self._container
		end
	end
end

function InputMapper:Build()
	local desiredContexts = self._config.Contexts or {}

	for contextName, contextRecord in pairs(self._contexts) do
		if desiredContexts[contextName] == nil then
			self:_clearConnections(contextName)
			if contextRecord.Instance then
				contextRecord.Instance:Destroy()
			end
			self._contexts[contextName] = nil
		end
	end

	for contextName, contextConfig in pairs(desiredContexts) do
		local record = self._contexts[contextName]

		if record then
			InputMapperContext.UpdateRecord(record, contextConfig)
		else
			record = InputMapperContext.CreateRecord(contextConfig)
			self._contexts[contextName] = record
		end

		record.Instance.Name = contextName
		record.Instance.Parent = self._container
	end

	return self
end

function InputMapper:SetContext(contextName: string, contextConfig: ContextConfig)
	self._config.Contexts = self._config.Contexts or {}
	self._config.Contexts[contextName] = contextConfig
	return self:Build()
end

function InputMapper:RemoveContext(contextName: string)
	if self._config.Contexts then
		self._config.Contexts[contextName] = nil
	end
	return self:Build()
end

function InputMapper:SetAction(contextName: string, actionName: string, actionConfig: ActionConfig)
	local contextConfig = self:_ensureContextConfig(contextName)
	contextConfig.Actions = contextConfig.Actions or {}
	contextConfig.Actions[actionName] = actionConfig
	return self:Build()
end

function InputMapper:RemoveAction(contextName: string, actionName: string)
	local contextConfig = self._config.Contexts and self._config.Contexts[contextName]
	if contextConfig and contextConfig.Actions then
		contextConfig.Actions[actionName] = nil
	end
	return self:Build()
end

function InputMapper:SetBinding(
	contextName: string,
	actionName: string,
	bindingName: string,
	bindingConfig: BindingConfig
)
	local contextConfig = self._config.Contexts and self._config.Contexts[contextName]
	assert(contextConfig, ("Context not found: %s"):format(contextName))
	assert(
		contextConfig.Actions and contextConfig.Actions[actionName],
		("Action not found: %s/%s"):format(contextName, actionName)
	)

	local actionConfig = contextConfig.Actions[actionName]
	actionConfig.Bindings = actionConfig.Bindings or {}
	actionConfig.Bindings[bindingName] = bindingConfig

	return self:Build()
end

function InputMapper:RemoveBinding(contextName: string, actionName: string, bindingName: string)
	local contextConfig = self._config.Contexts and self._config.Contexts[contextName]
	if
		contextConfig
		and contextConfig.Actions
		and contextConfig.Actions[actionName]
		and contextConfig.Actions[actionName].Bindings
	then
		contextConfig.Actions[actionName].Bindings[bindingName] = nil
	end
	return self:Build()
end

function InputMapper:GetContextRecord(contextName: string): ContextRecord?
	return self._contexts[contextName]
end

function InputMapper:GetActionRecord(contextName: string, actionName: string): ActionRecord?
	local contextRecord = self._contexts[contextName]
	return contextRecord and contextRecord.Actions[actionName] or nil
end

function InputMapper:GetBindingRecord(contextName: string, actionName: string, bindingName: string): BindingRecord?
	local actionRecord = self:GetActionRecord(contextName, actionName)
	return actionRecord and actionRecord.Bindings[bindingName] or nil
end

function InputMapper:GetContext(contextName: string): InputContext?
	local record = self._contexts[contextName]
	return record and record.Instance or nil
end

function InputMapper:GetAction(contextName: string, actionName: string): InputAction?
	local actionRecord = self:GetActionRecord(contextName, actionName)
	return actionRecord and actionRecord.Instance or nil
end

function InputMapper:GetBinding(contextName: string, actionName: string, bindingName: string): InputBinding?
	local bindingRecord = self:GetBindingRecord(contextName, actionName, bindingName)
	return bindingRecord and bindingRecord.Instance or nil
end

function InputMapper:ConnectAction(contextName: string, actionName: string, callback: (any) -> ())
	local action = self:GetAction(contextName, actionName)
	assert(action, ("Action not found: %s/%s"):format(contextName, actionName))

	local conn = action.StateChanged:Connect(function(value)
		callback(value)
	end)

	self._connections[contextName] = self._connections[contextName] or {}
	table.insert(self._connections[contextName], conn)

	return conn
end

function InputMapper:ExportKeymap()
	local contexts: { [string]: any } = {}

	for contextName, contextRecord in pairs(self._contexts) do
		contexts[contextName] = exportContextSpec(contextRecord)
	end

	return {
		Contexts = contexts,
	}
end

function InputMapper:ImportKeymap(data: any)
	local contextsData = data and (data.Contexts or data)
	assert(type(contextsData) == "table", "Invalid keymap payload")

	local contexts: { [string]: ContextConfig } = {}
	for contextName, contextData in pairs(contextsData) do
		contexts[contextName] = importContextConfig(contextData)
	end

	self._config.Contexts = contexts
	self:Build()
end

function InputMapper:SerializeKeymap(): string
	return HttpService:JSONEncode(self:ExportKeymap())
end

function InputMapper:DeserializeKeymap(json: string)
	local ok, data = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if not ok then
		return false, data
	end

	self:ImportKeymap(data)
	return true
end

function InputMapper:Destroy()
	for _, list in pairs(self._connections) do
		for _, conn in ipairs(list) do
			conn:Disconnect()
		end
	end

	table.clear(self._connections)
	table.clear(self._contexts)

	if self._container then
		self._container:Destroy()
		self._container = nil
	end
end

return InputMapper
