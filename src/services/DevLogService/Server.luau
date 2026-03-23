local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local DevLogService = HoenKnit.CreateService({
	Name = "DevLogService",
	Client = {
		MessageOut = Knit.CreateSignal(),
	},
})

-- * Knit
function DevLogService:KnitInit()
	LoggerManager:Init()
end

function DevLogService:KnitStart()
	LoggerManager:ConnectMessageOut(function(message: string, entryBuffer: buffer)
		self.Client.MessageOut:FireAll(message, entryBuffer)
	end)
end

return DevLogService
