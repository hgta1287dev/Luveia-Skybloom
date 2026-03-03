local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Controllers = require(script.Parent.Controllers)
local Knit = require(ReplicatedStorage.Packages.Knit)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

-- * Logger Setup
LoggerManager:Init()
local Logger = LoggerManager:CreateLogger()

-- * React Setup

-- * ECS Setup

-- * Knit Setup
Controllers:Init()
Knit.Start()
	:andThen(function()
		Logger:Info("Knit Started Successfully!")
	end)
	:catch(function(...)
		Logger:Error(...)
	end)
	:await()
