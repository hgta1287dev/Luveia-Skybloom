local ReplicatedStorage = game:GetService("ReplicatedStorage")

local KnitBootstrap = require(ReplicatedStorage.SharedStartup.KnitBootstrap)
local ServiceLoader = require(ReplicatedStorage.SharedStartup.ServiceLoader)

ServiceLoader:Init()
KnitBootstrap:Init()
