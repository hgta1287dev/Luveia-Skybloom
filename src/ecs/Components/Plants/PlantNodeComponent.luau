local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)

export type PlantNodeData = {
	parentId: string?,
	depth: number,
	length: number,
}

local PlantNode = Matter.component(
	"Node",
	{
		parentId = nil,
		depth = 0,
		length = 0,
	} :: PlantNodeData
)

return PlantNode
