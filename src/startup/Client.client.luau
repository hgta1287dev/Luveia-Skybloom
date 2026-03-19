local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevPanel = require(script.Parent.ClientStartup.DevPanel)
local KnitBootstrap = require(ReplicatedStorage.SharedStartup.KnitBootstrap)
local LoggerBootstap = require(ReplicatedStorage.SharedStartup.LoggerBootstap)
local ServiceLoader = require(ReplicatedStorage.SharedStartup.ServiceLoader)

LoggerBootstap:Init()
DevPanel:Init()
ServiceLoader:Init()
KnitBootstrap:Init()
