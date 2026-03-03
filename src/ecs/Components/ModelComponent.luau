local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)
export type ModelComponent = {
	instance: Model?,
}
return Matter.component("Model")
