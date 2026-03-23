local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local DevStates = require(script.Parent.DevStates)
local Iris = require(ReplicatedStorage.Packages._Index["sirmallard_iris@2.5.0"].iris)
local IrisTypes = require(ReplicatedStorage.Packages._Index["sirmallard_iris@2.5.0"].iris.Types)
local OrderedCollections =
	require(ReplicatedStorage.Packages._Index["hgta1287dev_ordered-collections@1.0.0"]["ordered-collections"])
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local LogSharedTypes = require(ReplicatedStorage.Shared.Core.LoggerManager.LogSharedTypes)

local OutputConsole = {}
OutputConsole.__index = OutputConsole

-- * Types
type Set<T> = OrderedCollections.Set<T>
type State<T> = IrisTypes.State<T>

export type LogLevel = LogSharedTypes.LogLevel
export type LogEntry = LogSharedTypes.LogEntry

export type OutputConsoleData = {
	MaxLog: number,
	MaxOutput: number,
	Colors: { [LogLevel]: Color3 },

	_entries: Set<LogEntry>,
	_filterStates: { [LogLevel]: State<boolean> },
	_filterAllState: State<boolean>,
	_fullFilterState: State<boolean>,

	_showDate: State<boolean>,

	_janitor: typeof(Janitor.new()),
}
export type OutputConsole = typeof(setmetatable({} :: OutputConsoleData, OutputConsole))

-- * Default Config
local MAX_LOGS = 100000
local MAX_OUTPUT = 200
local Colors: { [LogLevel]: Color3 } = {
	Trace = Color3.fromRGB(75, 20, 255),
	Debug = Color3.fromRGB(100, 180, 255),
	Info = Color3.fromRGB(255, 255, 255),
	Warn = Color3.fromRGB(255, 160, 0),
	Error = Color3.fromRGB(255, 50, 50),
	Fatal = Color3.fromRGB(200, 0, 0),
}

-- * Helpers
local function eachLogLevel(callback: (level: LogLevel) -> ())
	for _, level in ipairs(LogSharedTypes.LogLevelNames) do
		callback(level)
	end
end

function OutputConsole:_eachFilterStates(callback: (LogLevel: LogLevel, state: State<boolean>) -> ())
	eachLogLevel(function(LogLevel: LogLevel)
		callback(LogLevel, self._filterStates[LogLevel])
	end)
end

-- * Constructor
function OutputConsole.new(): OutputConsole
	local self = setmetatable(
		{
			MaxLog = MAX_LOGS,
			MaxOutput = MAX_OUTPUT,
			Colors = Colors,

			_entries = OrderedCollections.Set.new(),

			_filterStates = {},
			_filterAllState = Iris.State(true),
			_fullFilterState = Iris.State(true),

			_showDate = Iris.State(true),
			_showRunSide = Iris.State(true),
			_showRunScope = Iris.State(true),
			_showRunContent = Iris.State(true),

			_janitor = Janitor.new(),
		} :: OutputConsoleData,
		OutputConsole
	) :: OutputConsole

	eachLogLevel(function(LogLevel: string)
		self._filterStates[LogLevel] = Iris.State(true)
	end)

	LoggerManager:ConnectMessageOut(function(message: string, entryBuffer: buffer)
		local entry = LoggerManager:DeserializeEntry(entryBuffer)
		self:Log(entry)
	end)

	return self
end

-- * API
function OutputConsole:Test()
	task.spawn(function()
		local i = 0
		while true do
			eachLogLevel(function(LogLevel: LogLevel)
				i += 1
				self:SendMessage(`Test {LogLevel} {i}`, LogLevel)
				task.wait(1)
			end)
		end
	end)
end

-- Message Methods
function OutputConsole:Log(entry: LogEntry)
	if self._entries:Size() >= self.MaxLog then
		self._entries:PopBack()
	end

	self._entries:PushFront(entry)
end

function OutputConsole:Clear()
	self._entries:Clear()
end

-- Render
function OutputConsole:Render()
	Iris.Window({ "Output Console" }, { isOpened = DevStates.ShowOutputConsole })
	do
		Iris.SeparatorText({ "Options" })
		Iris.SameLine()
		do
			-- * Clear button
			if Iris.Button({ "Clear" }).clicked() then
				self:Clear()
			end
			-- * Search
		end
		Iris.End()

		-- * Options Field
		Iris.CollapsingHeader({ "Display Settings" })
		do
			Iris.Table({ 4 })
			do
				Iris.Checkbox({ "Show Date" }, { isChecked = self._showDate })
				Iris.NextColumn()
				Iris.Checkbox({ "Show Run Side" }, { isChecked = self._showRunSide })
				Iris.NextColumn()
				Iris.Checkbox({ "Show Run Scope" }, { isChecked = self._showRunScope })
				Iris.NextColumn()
				Iris.Checkbox({ "Show Run Content" }, { isChecked = self._showRunContent })
			end
			Iris.End()
		end
		Iris.End()

		-- * Filters Field
		Iris.CollapsingHeader({ "Filters" })
		do
			Iris.Table({ 4 })
			do
				-- * Filters toggle
				local function toggleAll(active: boolean)
					self:_eachFilterStates(function(fType: LogLevel, state: State<boolean>)
						state:set(active)
					end)
				end

				local function updateAllState()
					local allActive = true

					self:_eachFilterStates(function(fType: LogLevel, state: State<boolean>)
						if not state:get() then
							allActive = false
						end
					end)

					if self._fullFilterState:get() ~= allActive then
						self._fullFilterState:set(allActive)
					end
				end

				-- * Filters "All"
				do
					local checkbox = Iris.Checkbox({ "All" }, { isChecked = self._filterAllState })
					local fullState = self._fullFilterState
					local allState = self._filterAllState

					if allState:changed() and checkbox:hovered() then
						toggleAll(allState:get())
					end

					if self._fullFilterState:changed() then
						allState:set(fullState:get())
					end
				end

				-- * Other filters
				local cnt = 0
				self:_eachFilterStates(function(fType: LogLevel, state: State<boolean>)
					cnt += 1
					if cnt % 2 == 0 then
						Iris.NextColumn()
					end
					Iris.Checkbox({ fType }, { isChecked = state })
					if state:changed() then
						updateAllState()
					end
				end)
			end
			Iris.End()
		end
		Iris.End()

		-- * Output Field
		Iris.SeparatorText({ "Output" })
		Iris.Indent()
		do
			local outputs = 0
			self._entries:Each(function(entry: LogEntry)
				if self._filterAllState:get() or self._filterStates[entry.level]:get() then
					Iris.SameLine(5, nil, Enum.HorizontalAlignment.Left)
					do
						if self._showDate:get() then
							Iris.Text({
								entry._timestamp:FormatLocalTime("HH:mm:ss.SSS", LocalizationService.RobloxLocaleId),
							})
							Iris.Separator()
						end
						if self._showRunSide:get() then
							Iris.Text({ string.upper(entry._side) })
							Iris.Separator()
						end
						if self._showRunScope:get() then
							Iris.Text({ entry.scope })
							Iris.Separator()
						end
						if self._showRunContent:get() then
							Iris.TextColored({ entry.content, self.Colors[entry.level] })
						end
					end
					Iris.End()

					outputs += 1
				end
				return outputs <= self.MaxOutput
			end)
		end
		Iris.End()
	end
	Iris.End()
end

return OutputConsole.new()
