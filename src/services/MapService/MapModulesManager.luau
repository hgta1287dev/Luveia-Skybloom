local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Logger = require(ReplicatedStorage.Shared.Utils.Logger)
local MapModulesManager = {}
MapModulesManager.__index = MapModulesManager

-- * Types
export type MapModulesManager = {
	_started: boolean,
	_destroyed: boolean,
	_map: Model,
	_modules: { [string]: any },
}

-- * Utils
local function ValidateAndRequire(moduleScript: ModuleScript): (boolean, any)
	local success, res = pcall(require, moduleScript)
	if not success then
		return false, res
	elseif typeof(res) ~= "table" then
		return false, `Module "{moduleScript.Name}" must return a table`
	elseif typeof(res.Init) ~= "function" then
		return false, `Module "{moduleScript.Name}" must have Init`
	elseif typeof(res.Start) ~= "function" then
		return false, `Module "{moduleScript.Name}" must have Start`
	elseif typeof(res.Destroy) ~= "function" then
		return false, `Module "{moduleScript.Name}" must have Destroy`
	end

	return true, res
end

local function run(callback)
	local ok, result = pcall(callback)
	if not ok then
		Logger.error("MapModulesManager", result)
	end
end

-- * Constructor
function MapModulesManager.new(map: Model)
	local self = setmetatable({}, MapModulesManager)
	self._started = false
	self._destroyed = false
	self._map = map
	self._modules = {}
	return self
end

-- * Public
function MapModulesManager:Register(moduleScript: ModuleScript): (boolean, any)
	-- Already registered
	if self._modules[moduleScript.Name] then
		return false, `Module "{moduleScript.Name}" is already registered`
	end

	-- Already started or destroyed
	if self._started or self._destroyed then
		return false, "MapModulesManager is already started or destroyed"
	end

	-- Validate
	local ok, result = ValidateAndRequire(moduleScript)
	if not ok then
		return false, result
	end

	-- Register
	self._modules[moduleScript.Name] = result
	return true
end

function MapModulesManager:RegisterAll(moduleScripts: { ModuleScript })
	for _, moduleScript in moduleScripts do
		self:Register(moduleScript)
	end
end

-- * Lifecycle
function MapModulesManager:Start()
	-- Already started or destroyed
	if self._started or self._destroyed then
		return
	end
	self._started = true

	-- Freeze modules
	table.freeze(self._modules)

	-- Run modules
	for _, module in pairs(self._modules) do
		run(function()
			module.Init(self._map)
		end)
	end
	for _, module in pairs(self._modules) do
		run(function()
			module.Start(self._map)
		end)
	end
end

function MapModulesManager:Destroy()
	-- Already destroyed
	if self._destroyed then
		return
	end
	self._destroyed = true

	-- Destroy modules
	for _, module in pairs(self._modules) do
		run(function()
			module.Destroy(self._map)
		end)
	end

	--! do not clear self._modules
end

return MapModulesManager
