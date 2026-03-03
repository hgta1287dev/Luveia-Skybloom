local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)

export type TransformData = { cframe: CFrame }
return Matter.component("Transform", { cframe = CFrame.new() } :: TransformData)
