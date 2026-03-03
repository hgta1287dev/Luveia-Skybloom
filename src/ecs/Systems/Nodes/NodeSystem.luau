local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

function System(world: ECS.World) end

return ECS.CreateSystem({
	name = "NodeSystem",
	system = System,
})
