local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

-- * Logger Setup
LoggerManager:Init()

-- * ECS Setup
-- ECS.AddSystemsDeep(ReplicatedStorage.Shared.Ecs.Systems)
-- ECS.AddSystemsDeep(ServerScriptService.Ecs.Systems)
-- ECS.Start()

-- * Knit Setup
