local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local GameTypes = require(ReplicatedStorage.Shared.Types.GameTypes)

local Logger = LoggerManager:CreateLogger("TestService")
local TestService = Knit.CreateService({
	Name = "TestService",
	Client = {},
})

-- * Knit
function TestService:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)
	Logger:Info(KnitMessageConfig.Initialized)
end

function TestService:KnitStart()
	Logger:Info(KnitMessageConfig.Starting)

	local Services = Knit.GetServices()
	local MapService = Services.MapService

	local mode: GameTypes.Mode = "Editor"
	local mapName: string = "Prototype01"

	task.wait(5)

	MapService:CreateMap(mode, mapName)

	MapService.MapUpdated:Connect(function(mapName: string)
		local CharacterService = Services.CharacterService
		CharacterService:Spawn()
	end)

	Logger:Info(KnitMessageConfig.Started)
end

return TestService
