--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Components)
local PlantNodeComponent = require(ReplicatedStorage.Shared.Ecs.Components.Plants.PlantNodeComponent)

local BushFactory = {}

export type BushProps = {
	position: CFrame,
	modelTemplate: Model,
}

function BushFactory.create(world, props: CreateBushParams): number
	local bushId = world:spawn(
		Components.PlantTagComponent(),
		Components.TransformComponent({
			CFrame = params.position,
		}),
		Components.ModelComponent({
			current = params.modelTemplate:Clone(),
		}),
		Components.GrowthComponent({
			age = 0,
			stage = 1,
			maxStage = 3,
		})
	)

	-- Tạo node đầu tiên (gốc cây)
	local rootNodeId = world:spawn(PlantNodeComponent({
		parentId = bushId,
		depth = 0,
		length = 1,
	}))

	return bushId
end

return BushFactory
