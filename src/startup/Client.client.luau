local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevPanel = require(script.Parent.ClientStartup.DevPanel)
local KnitBootstrap = require(ReplicatedStorage.SharedStartup.KnitBootstrap)
local ServiceLoader = require(ReplicatedStorage.SharedStartup.ServiceLoader)

DevPanel:Init()
ServiceLoader:Init()
KnitBootstrap:Init()
