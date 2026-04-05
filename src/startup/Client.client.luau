local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevPanel = require(ReplicatedStorage.Shared.Core.DevPanel)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local KnitBootstrap = require(ReplicatedStorage.SharedStartup.KnitBootstrap)
local ServiceLoader = require(ReplicatedStorage.SharedStartup.ServiceLoader)

local Logger = LoggerManager:CreateLogger("Bootstrap", "System")

Logger:Info(`Booting Up Game!`)
DevPanel:Init()

local success, err = pcall(function(...)
	ServiceLoader:Init()
	KnitBootstrap:Init()
end)

if success then
	Logger:Info(`Game Booted Successfully!`)
else
	Logger:Fatal(`GANE BOOT FAILED!: {err}`)
end
