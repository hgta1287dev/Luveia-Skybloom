local InputMapperBinding = require(script.Parent.InputMapperBinding)
local InputMapperTypes = require(script.Parent.InputMapperTypes)

local ActionUtils = {}

type ActionConfig = InputMapperTypes.ActionConfig
type ActionSpec = InputMapperTypes.ActionSpec
type ActionRecord = InputMapperTypes.ActionRecord

type BindingSpec = InputMapperTypes.BindingSpec
type BindingRecord = InputMapperTypes.BindingRecord

function ActionUtils.ConvertSpec(config: ActionConfig): ActionSpec
	local bindingSpecs: { [string]: BindingSpec } = {}

	if config.Bindings then
		for bindingName, bindingConfig in pairs(config.Bindings) do
			bindingSpecs[bindingName] = InputMapperBinding.ConvertSpec(config.Type, bindingConfig)
		end
	end

	return {
		Enabled = if config.Enabled ~= nil then config.Enabled else true,
		Type = config.Type,
		Bindings = bindingSpecs,
	}
end

function ActionUtils.ApplySpec(action: InputAction, spec: ActionSpec)
	action.Enabled = spec.Enabled
	action.Type = spec.Type

	for _, binding in pairs(action:GetChildren()) do
		if not spec.Bindings[binding.Name] then
			binding:Destroy()
		end
	end

	for bindingName, bindingSpec in pairs(spec.Bindings) do
		local binding = action:FindFirstChild(bindingName)
		if binding then
			InputMapperBinding.ApplySpec(binding, spec.Type, bindingSpec)
		else
			binding = InputMapperBinding.CreateBinding(spec.Type, bindingSpec)
			binding.Name = bindingName
			binding.Parent = action
		end
	end
end

function ActionUtils.CreateAction(config: ActionConfig)
	local action = Instance.new("InputAction")
	ActionUtils.ApplyConfig(action, config)
	return action
end

function ActionUtils.CreateRecordFromInstance(action: InputAction, spec: ActionSpec): ActionRecord
	local bindings: { [string]: BindingRecord } = {}

	for bindingName, bindingSpec in pairs(spec.Bindings) do
		local bindingInstance = action:FindFirstChild(bindingName)
		bindings[bindingName] = {
			Instance = bindingInstance :: InputBinding?,
			Spec = bindingSpec,
		}
	end

	return {
		Instance = action,
		Spec = spec,
		Bindings = bindings,
	}
end

function ActionUtils.ApplyConfig(action: InputAction, config: ActionConfig)
	local spec = ActionUtils.ConvertSpec(config)
	ActionUtils.ApplySpec(action, spec)
end

function ActionUtils.UpdateRecord(record: ActionRecord, config: ActionConfig)
	local instance = record.Instance
	if not instance then
		instance = ActionUtils.CreateAction(config)
	end

	local spec = ActionUtils.ConvertSpec(config)
	ActionUtils.ApplySpec(instance, spec)

	for bindingName, bindingRecord in pairs(record.Bindings) do
		if not spec.Bindings[bindingName] then
			if bindingRecord.Instance then
				bindingRecord.Instance:Destroy()
			end
			record.Bindings[bindingName] = nil
		end
	end

	for bindingName, bindingSpec in pairs(spec.Bindings) do
		local bindingInstance = instance:FindFirstChild(bindingName)
		local bindingRecord = record.Bindings[bindingName]

		if bindingRecord then
			bindingRecord.Instance = bindingInstance :: InputBinding?
			bindingRecord.Spec = bindingSpec
		else
			record.Bindings[bindingName] = {
				Instance = bindingInstance :: InputBinding?,
				Spec = bindingSpec,
			}
		end
	end

	record.Instance = instance
	record.Spec = spec
end

function ActionUtils.CreateRecord(config: ActionConfig): ActionRecord
	local spec = ActionUtils.ConvertSpec(config)
	local action = ActionUtils.CreateAction(config)
	return ActionUtils.CreateRecordFromInstance(action, spec)
end

return ActionUtils
