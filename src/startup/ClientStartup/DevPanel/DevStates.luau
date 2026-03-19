local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Iris = require(ReplicatedStorage.Packages.Iris)

local States = {
	ShowControllerPanel = Iris.State(true),
	ShowOutputConsole = Iris.State(false),
}

return States
