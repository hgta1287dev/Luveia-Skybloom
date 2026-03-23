local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevControllerPanel = require(script.DevControllerPanel)
local DevOutputConsole = require(script.DevOutputConsole)
local DevStates = require(script.DevStates)
local Iris = require(ReplicatedStorage.Packages.Iris)

local DevPanel = {}

function DevPanel:Init()
	Iris.Init()
	Iris:Connect(function()
		if DevStates.ShowControllerPanel:get() then
			DevControllerPanel:Render()
		else
			if Iris.Button({ "Open DevConsole" }).clicked() then
				DevStates.ShowControllerPanel:set(true)
			end
			return
		end

		if DevStates.ShowOutputConsole:get() then
			DevOutputConsole:Render()
		end
	end)

	-- DevOutputConsole:Test()
end

return DevPanel
