local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local KnitBootstrap = {}
local Logger = LoggerManager:CreateLogger(script.Name)

function KnitBootstrap:Init()
	task.wait(5)
	Logger:Info(`Knit Starting!`)
	Knit.Start()
		:andThen(function()
			Logger:Info(`Knit Started Successfully!`)
		end)
		:catch(function(...)
			Logger:Error(...)
		end)
		:await()
end

return KnitBootstrap
