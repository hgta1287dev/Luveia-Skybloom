local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OrderedCollections = require(ReplicatedStorage.Packages.OrderedCollections)

local KeyboardInput = {}
KeyboardInput.__index = KeyboardInput

export type KeyboardState = {
	KeysDown: typeof(OrderedCollections.Set.new()),
	KeysPressed: typeof(OrderedCollections.Set.new()),
	KeysReleased: typeof(OrderedCollections.Set.new()),
}

export type KeyboardInput = typeof(setmetatable(
	{} :: {
		KeyboardState: KeyboardState,
	},
	KeyboardInput
))

function KeyboardInput.new(keyState: KeyboardState): KeyboardInput
	local self = setmetatable({
		KeyboardState = keyState,
	}, KeyboardInput)

	self:Init()
	return self
end

function KeyboardInput:Init()
	UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent)
		if gameProcessedEvent then
			return
		end

		if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local keyCode = inputObject.KeyCode
		if keyCode == Enum.KeyCode.Unknown then
			return
		end

		if not self.KeyboardState.KeysDown:Has(keyCode) then
			self.KeyboardState.KeysDown:PushBack(keyCode)
			self.KeyboardState.KeysPressed:PushBack(keyCode)
		end
	end)

	UserInputService.InputEnded:Connect(function(inputObject, _gameProcessedEvent)
		if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local keyCode = inputObject.KeyCode
		if keyCode == Enum.KeyCode.Unknown then
			return
		end

		if not self.KeyboardState.KeysReleased:Has(keyCode) then
			self.KeyboardState.KeysReleased:PushBack(keyCode)
		end

		if self.KeyboardState.KeysDown:Has(keyCode) then
			self.KeyboardState.KeysDown:Pop(keyCode)
		end
	end)
end

function KeyboardInput:Flush()
	local state: KeyboardState = self.KeyboardState
	state.KeysPressed:Clear()
	state.KeysReleased:Clear()
end

return KeyboardInput
