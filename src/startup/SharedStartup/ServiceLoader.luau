local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local Logger = LoggerManager:CreateLogger(script.Name)

--  * Config
local SERVICES = {
	"DevLogService",
	-- "CameraProxyService",
	-- "MapService",
	-- "CameraService", --! Have problems with this one
	-- "WindService",
	"TestService",
	-- "RoomService",
	-- "CharacterService",
}

local CONTROLLERS = {
	"DevLogService",
	-- "LightingService",
	"TestService",
}

-- * Loader
local ServiceLoader = {
	controllers = {},
	services = {},
}

function ServiceLoader:Init()
	Logger:Info("Initialization Started!")
	if RunService:IsServer() then
		for _, name in SERVICES do
			local serviceFolder = ServerScriptService.Services:WaitForChild(name)
			local server = serviceFolder and serviceFolder:WaitForChild(`{name}Server`)
			if serviceFolder then
				ServiceLoader.services[name] = require(server)
				Logger:Info(`Loaded service: {name}`)
			end
		end
	else
		for _, name in CONTROLLERS do
			local serviceFolder = ReplicatedStorage.Shared.Services:WaitForChild(name)
			local client = serviceFolder and serviceFolder:WaitForChild(`{name}Client`)
			if client then
				ServiceLoader.controllers[name] = require(client)
				Logger:Info(`Loaded controller: {name}`)
			end
		end
	end
	Logger:Info("Initialization Completed!")
end

return ServiceLoader
