local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local TestController = Knit.CreateController({ Name = "TestController" })
local Logger = LoggerManager:CreateLogger("TestController")

-- * Constants

-- * Knit
function TestController:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)
	Logger:Info(KnitMessageConfig.Initialized)
end

function TestController:KnitStart()
	Logger:Info(KnitMessageConfig.Starting)
	Logger:Info(KnitMessageConfig.Started)
end

return TestController
