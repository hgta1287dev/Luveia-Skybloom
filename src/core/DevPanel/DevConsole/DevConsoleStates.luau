local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Iris = require(ReplicatedStorage.Packages.Iris)

export type DisplaySetting = "ShowDate" | "ShowRunSide" | "ShowRunScope" | "ShowCategory" | "ShowRunContent"

local DisplaySettings = {
	"ShowDate",
	"ShowRunSide",
	"ShowRunScope",
	"ShowCategory",
	"ShowRunContent",
}

local DisplayStates = {
	ShowDate = Iris.State(true),
	ShowRunSide = Iris.State(true),
	ShowRunScope = Iris.State(true),
	ShowCategory = Iris.State(true),
	ShowRunContent = Iris.State(true),
}

return {
	DisplayStates = DisplayStates,
	DisplaySettingNames = DisplaySettings,
}
