local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DevConsole = require(script.Parent.DevConsole)
local DevConsoleStates = require(script.Parent.DevConsoleStates)
local Iris = require(ReplicatedStorage.Packages._Index["sirmallard_iris@2.5.0"].iris)
local IrisTypes = require(ReplicatedStorage.Packages._Index["sirmallard_iris@2.5.0"].iris.Types)
local DevPanelState = require(ReplicatedStorage.Shared.Core.DevPanel.DevCommon.DevPanelState)
local LogSharedTypes = require(ReplicatedStorage.Shared.Core.LoggerManager.LogSharedTypes)

local OutputConsole = {}
OutputConsole.__index = OutputConsole

-- * Types
type State<T> = IrisTypes.State<T>

export type LogLevel = LogSharedTypes.LogLevel
export type LogEntry = LogSharedTypes.LogEntry

-- * Default Config
local LEVEL_COLORS = {
	Trace = Color3.fromRGB(75, 20, 255),
	Debug = Color3.fromRGB(100, 180, 255),
	Info = Color3.fromRGB(255, 255, 255),
	Warn = Color3.fromRGB(255, 160, 0),
	Error = Color3.fromRGB(255, 50, 50),
	Fatal = Color3.fromRGB(200, 0, 0),
}

local SIDE_COLORS = {
	Server = LEVEL_COLORS.Warn,
	Client = LEVEL_COLORS.Debug,
}

-- * API
-- Render
function OutputConsole:Render()
	Iris.Window({ "Console Panel" }, { isOpened = DevPanelState.ShowConsolePanel })
	do
		Iris.SeparatorText({ "Options" })
		Iris.SameLine()
		do
			-- * Clear button
			if Iris.Button({ "Clear" }).clicked() then
				DevConsole:Clear()
			end
			-- * Search
		end
		Iris.End()

		-- * Options Field
		Iris.CollapsingHeader({ "Display Settings" })
		do
			Iris.Table({ 5 })
			do
				Iris.Checkbox({ "Show Date" }, { isChecked = DevConsoleStates.ShowDate })
				Iris.NextColumn()
				Iris.Checkbox({ "Show Run Side" }, { isChecked = DevConsoleStates.ShowRunSide })
				Iris.NextColumn()
				Iris.Checkbox({ "Show Run Scope" }, { isChecked = DevConsoleStates.ShowRunScope })
				Iris.NextColumn()
				Iris.Checkbox({ "Show Category" }, { isChecked = DevConsoleStates.ShowCategory })
				Iris.NextColumn()
				Iris.Checkbox({ "Show Run Content" }, { isChecked = DevConsoleStates.ShowRunContent })
			end
			Iris.End()
		end
		Iris.End()

		-- * Categories Filter Field
		Iris.CollapsingHeader({ "Category filters" })
		do
			Iris.Table({ 4 })
			do
				-- * Filters "All"
				Iris.Checkbox({ "All" }, { isChecked = DevConsole.categoryFilterManager:GetMasterState() })

				-- * Other filters
				local cnt = 0
				DevConsole.categoryFilterManager:EachState(function(name: string, state: State<boolean>)
					cnt += 1
					if cnt % 2 == 0 then
						Iris.NextColumn()
					end
					Iris.Checkbox({ name }, { isChecked = state })
				end)
			end
			Iris.End()
		end
		Iris.End()

		-- * Level Filters Field
		Iris.CollapsingHeader({ "Level filters" })
		do
			Iris.Table({ 4 })
			do
				-- * Filters "All"
				Iris.Checkbox({ "All" }, { isChecked = DevConsole.levelFilterManager:GetMasterState() })

				-- * Other filters
				local cnt = 0
				DevConsole.levelFilterManager:EachState(function(name: string, state: State<boolean>)
					cnt += 1
					if cnt % 2 == 0 then
						Iris.NextColumn()
					end
					Iris.Checkbox({ name }, { isChecked = state })
				end)
			end
			Iris.End()
		end
		Iris.End()

		-- * Output Field
		Iris.SeparatorText({ "Output" })
		Iris.Indent()
		do
			DevConsole:EachEntry(function(entry: LogEntry)
				Iris.SameLine(5, nil, Enum.HorizontalAlignment.Left)
				do
					if DevConsoleStates.DisplayStates.ShowDate:get() then
						Iris.Separator()
						Iris.Text({ string.format("%07.3f", entry._timestamp) })
						Iris.Separator()
					end

					if DevConsoleStates.DisplayStates.ShowRunSide:get() then
						Iris.Separator()
						Iris.TextColored({ string.upper(entry._side), SIDE_COLORS[entry._side] })
						Iris.Separator()
					end

					if DevConsoleStates.DisplayStates.ShowRunScope:get() then
						Iris.Separator()
						Iris.Text({ entry.scope })
						Iris.Separator()
					end

					if DevConsoleStates.DisplayStates.ShowCategory:get() then
						Iris.Separator()
						Iris.Text({ entry.category })
						Iris.Separator()
					end

					if DevConsoleStates.DisplayStates.ShowRunContent:get() then
						Iris.Separator()
						Iris.TextColored({ entry.content, LEVEL_COLORS[entry.level] })
						Iris.Separator()
					end
				end
				Iris.End()
			end)
		end
		Iris.End()
	end
	Iris.End()
end

return OutputConsole
