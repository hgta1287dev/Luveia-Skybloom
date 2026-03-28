local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local GameTypes = require(ReplicatedStorage.Shared.Types.GameTypes)

local mode: GameTypes.Mode = "Editor"
local MAP_NAME: string = "Prototype01"

local Test = {}

function Test:Init()
	local Services = Knit.GetServices()
	local MapService = Services.MapService

	task.wait(5)

	MapService:CreateMap(mode, MAP_NAME)

	MapService.MapUpdated:Connect(function(mapName: string)
		local CharacterService = Services.CharacterService
		CharacterService:Spawn()
	end)
end

return Test
