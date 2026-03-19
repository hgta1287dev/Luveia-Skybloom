local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DevStates = require(script.Parent.DevStates)
local Iris = require(ReplicatedStorage.Packages.Iris)

local ControlPanel = {}

function ControlPanel:Render()
	Iris.Window({ "Control Panel" }, { isOpened = DevStates.ShowControllerPanel })
	do
		Iris.MenuBar()
		do
			Iris.Menu({ "Tools" })
			do
				Iris.MenuToggle({ "Output Console" }, { isChecked = DevStates.ShowOutputConsole })
			end
			Iris.End()
		end
		Iris.End()
	end
	Iris.End()
end

return ControlPanel
