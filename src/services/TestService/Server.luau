local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local TestMap = require(ReplicatedStorage.Shared.Services.TestService.TestMap)

local TestService = HoenKnit.CreateService({
	Name = "TestService",
	Client = {},
})

-- * Knit
function TestService:KnitStart()
	TestMap:Init()
end

return TestService
