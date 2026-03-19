local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevControllerPanel = require(script.DevControllerPanel)
local DevOutputConsole = require(script.DevOutputConsole)
local DevStates = require(script.DevStates)
local Iris = require(ReplicatedStorage.Packages.Iris)

local DevPanel = {}

local function TEST()
	task.spawn(function()
		local i = 0
		while true do
			for _, fType in ipairs(MESSAGE_FILTERS) do
				i += 1
				OutputConsole:SendMessage(`Test {fType} {i}`, fType)
				task.wait(1)
			end
		end
	end)
end

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

	TEST()
end

return DevPanel
