local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)

local CloudController = HoenKnit.CreateController({
	Name = "CloudController",
})

local SIZE = Vector2.one * 1000000

local function createLayer()
	local mesh = Instance.new("MeshPart")
	mesh.MeshContent = "rbxassetid://2946773829"
	mesh.Size = Vector3.new(0.0001, SIZE.X, SIZE.Y)
	mesh.Parent = workspace

	return mesh
end

function CloudController:KnitStart()
	self.Clouds = {}
	for i = 1, 10 do
		local cloud = createLayer()
		table.insert(self.Clouds, cloud)
	end
end

return CloudController
