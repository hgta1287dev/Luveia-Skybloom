local InputMapperAction = require(script.Parent.InputMapperAction)
local InputMapperTypes = require(script.Parent.InputMapperTypes)

local ContextUtils = {}

type ContextConfig = InputMapperTypes.ContextConfig
type ContextSpec = InputMapperTypes.ContextSpec
type ContextRecord = InputMapperTypes.ContextRecord

type ActionSpec = InputMapperTypes.ActionSpec
type ActionRecord = InputMapperTypes.ActionRecord

function ContextUtils.ConvertSpec(config: ContextConfig): ContextSpec
	local actionsSpecs: { [string]: ActionSpec } = {}

	if config.Actions then
		for actionName, actionConfig in pairs(config.Actions) do
			actionsSpecs[actionName] = InputMapperAction.ConvertSpec(actionConfig)
		end
	end

	return {
		Sink = if config.Sink ~= nil then config.Sink else false,
		Enabled = if config.Enabled ~= nil then config.Enabled else true,
		Priority = if config.Priority ~= nil then config.Priority else 0,
		Actions = actionsSpecs,
	}
end

function ContextUtils.ApplySpec(context: InputContext, spec: ContextSpec)
	context.Sink = spec.Sink
	context.Enabled = spec.Enabled
	context.Priority = spec.Priority

	for _, action in pairs(context:GetChildren()) do
		if not spec.Actions[action.Name] then
			action:Destroy()
		end
	end

	for actionName, actionSpec in pairs(spec.Actions) do
		local action = context:FindFirstChild(actionName)
		if action then
			InputMapperAction.ApplySpec(action, actionSpec)
		else
			action = InputMapperAction.CreateAction(actionSpec)
			action.Name = actionName
			action.Parent = context
		end
	end
end

function ContextUtils.ApplyConfig(context: InputContext, config: ContextConfig)
	local spec = ContextUtils.ConvertSpec(config)
	ContextUtils.ApplySpec(context, spec)
end

function ContextUtils.CreateContext(config: ContextConfig)
	local context = Instance.new("InputContext")
	ContextUtils.ApplyConfig(context, config)
	return context
end

function ContextUtils.CreateRecordFromInstance(context: InputContext, spec: ContextSpec): ContextRecord
	local actions: { [string]: ActionRecord } = {}

	for actionName, actionSpec in pairs(spec.Actions) do
		local actionInstance = context:FindFirstChild(actionName)
		if actionInstance then
			actions[actionName] = InputMapperAction.CreateRecordFromInstance(actionInstance :: InputAction, actionSpec)
		else
			local newAction = InputMapperAction.CreateAction({
				Enabled = actionSpec.Enabled,
				Type = actionSpec.Type,
				Bindings = actionSpec.Bindings,
			})
			newAction.Name = actionName
			newAction.Parent = context
			actions[actionName] = InputMapperAction.CreateRecordFromInstance(newAction, actionSpec)
		end
	end

	return {
		Spec = spec,
		Instance = context,
		Actions = actions,
	}
end

function ContextUtils.CreateRecord(config: ContextConfig): ContextRecord
	local spec = ContextUtils.ConvertSpec(config)
	local context = ContextUtils.CreateContext(config)
	return ContextUtils.CreateRecordFromInstance(context, spec)
end

function ContextUtils.UpdateRecord(record: ContextRecord, config: ContextConfig)
	local instance = record.Instance
	if not instance then
		instance = ContextUtils.CreateContext(config)
	end

	local spec = ContextUtils.ConvertSpec(config)
	ContextUtils.ApplySpec(instance, spec)

	for actionName, actionRecord in pairs(record.Actions) do
		if not spec.Actions[actionName] then
			if actionRecord.Instance then
				actionRecord.Instance:Destroy()
			end
			record.Actions[actionName] = nil
		end
	end

	for actionName, actionSpec in pairs(spec.Actions) do
		local actionInstance = instance:FindFirstChild(actionName)
		local actionRecord = record.Actions[actionName]

		if actionRecord then
			InputMapperAction.UpdateRecord(actionRecord, {
				Enabled = actionSpec.Enabled,
				Type = actionSpec.Type,
				Bindings = actionSpec.Bindings,
			})
			actionRecord.Instance = actionInstance :: InputAction?
			actionRecord.Spec = actionSpec
		else
			if actionInstance then
				record.Actions[actionName] =
					InputMapperAction.CreateRecordFromInstance(actionInstance :: InputAction, actionSpec)
			else
				local newAction = InputMapperAction.CreateAction({
					Enabled = actionSpec.Enabled,
					Type = actionSpec.Type,
					Bindings = actionSpec.Bindings,
				})
				newAction.Name = actionName
				newAction.Parent = instance
				record.Actions[actionName] = InputMapperAction.CreateRecordFromInstance(newAction, actionSpec)
			end
		end
	end

	record.Instance = instance
	record.Spec = spec
end

return ContextUtils
