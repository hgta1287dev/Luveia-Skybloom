local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Iris = require(ReplicatedStorage.Packages.Iris)
local OrderedCollections = require(ReplicatedStorage.Packages.OrderedCollections)

local OutputConsole = {}
local logs = OrderedCollections.Set.new()

-- * Types
export type MessageType = "Log" | "Info" | "Warning" | "Error" | "Success" | "Debug"
export type MessageContext = {
	message: string,
	messageType: MessageType,
}

-- * Constant
local MAX_LOGS = 100
local MAX_OUTPUT = 20
local COLORS = {
	Log = Color3.fromRGB(255, 255, 255),
	Info = Color3.fromRGB(0, 255, 255),
	Warning = Color3.fromRGB(255, 255, 0),
	Error = Color3.fromRGB(255, 0, 0),
	Success = Color3.fromRGB(0, 255, 0),
	Debug = Color3.fromRGB(255, 0, 255),
}
local MESSAGE_FILTERS = { "All", "Log", "Info", "Warning", "Error", "Success", "Debug" }
local filterStates = {
	All = Iris.State(true),
	Log = Iris.State(true),
	Info = Iris.State(true),
	Warning = Iris.State(true),
	Error = Iris.State(true),
	Success = Iris.State(true),
	Debug = Iris.State(true),
}
local fullFilter = Iris.State(false)

-- * Helpers
local function eachFilters(callback: (fType: string) -> ())
	for _, fType in ipairs(MESSAGE_FILTERS) do
		callback(fType)
	end
end

local function eachFilterStates(callback: (fType: string, state: typeof(Iris.State(false))) -> ())
	eachFilters(function(fType: string)
		callback(fType, filterStates[fType])
	end)
end

-- * API
function OutputConsole:SendMessage(message: string, messageType: MessageType?)
	if logs:Size() >= MAX_LOGS then
		logs:PopBack()
	end

	local context: MessageContext = {
		message = `[{os.date("%H:%M:%S")}]: {message}`,
		messageType = messageType or "Log",
	}

	logs:PushFront(context)
end

function OutputConsole:Render()
	Iris.Window({ "Log Window" })
	do
		Iris.SeparatorText({ "Filters" })
		Iris.SameLine()
		do
			local function toggleAll(active: boolean)
				eachFilterStates(function(fType: string, state)
					if fType ~= "All" then
						state:set(active)
					end
				end)
			end

			local function updateAllState()
				local allActive = true

				eachFilterStates(function(fType: string, state)
					if fType ~= "All" and not state:get() then
						allActive = false
					end
				end)

				if fullFilter:get() ~= allActive then
					fullFilter:set(allActive)
				end
			end

			eachFilterStates(function(fType: string, state)
				local cb = Iris.Checkbox({ fType }, { isChecked = state })
				if fType == "All" then
					if state:changed() and cb:hovered() then
						toggleAll(state:get())
					end

					if fullFilter:changed() then
						state:set(fullFilter:get())
					end
				else
					if state:changed() then
						updateAllState()
					end
				end
			end)
		end
		Iris.End()
		Iris.Separator()

		Iris.SeparatorText({ "Output" })
		Iris.Indent()
		do
			local outputs = 0
			logs:Each(function(context: MessageContext)
				if filterStates.All:get() or filterStates[context.messageType]:get() then
					Iris.TextColored({ context.message, COLORS[context.messageType] })
					outputs += 1
				end
				return outputs <= MAX_OUTPUT
			end)
		end
		Iris.End()
	end
	Iris.End()
end

return OutputConsole
