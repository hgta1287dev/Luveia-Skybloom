local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local OrderedCollections = require(ReplicatedStorage.Packages.OrderedCollections)

local MouseInput = {}
MouseInput.__index = MouseInput

type Set = typeof(OrderedCollections.Set.new())
export type MouseState = {
	MoveDelta: Vector2,
	ScrollDelta: number,
	ButtonsDown: Set,
	ButtonsPressed: Set,
	ButtonsReleased: Set,
}
export type MouseInput = typeof(setmetatable(
	{} :: {
		MouseState: MouseState,
	},
	MouseInput
))

function isMouseButtonType(input: Enum.UserInputType): boolean
	return input == Enum.UserInputType.MouseButton1
		or input == Enum.UserInputType.MouseButton2
		or input == Enum.UserInputType.MouseButton3
end

function MouseInput.new(mouseState: MouseState): MouseInput
	local self = setmetatable({
		MouseState = mouseState,
		LastLocation = UserInputService:GetMouseLocation(),
	}, MouseInput)

	self:Init()
	return self
end

function MouseInput:Init()
	local state: MouseState = self.MouseState

	do -- * Scroll and Movement
		UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseWheel then
				state.ScrollDelta -= input.Position.Z
			elseif input.UserInputType == Enum.UserInputType.MouseMovement then
				state.MoveDelta -= (UserInputService:GetMouseLocation() - self.LastLocation)
				self.LastLocation = UserInputService:GetMouseLocation()
			end
		end)
	end

	do -- * Buttons
		UserInputService.InputBegan:Connect(function(input: InputObject, gpc: boolean)
			if gpc then
				return
			end

			local inputType = input.UserInputType
			if isMouseButtonType(inputType) then
				if not state.ButtonsDown:Has(inputType) then
					state.ButtonsDown:PushBack(inputType)
					state.ButtonsPressed:PushBack(inputType)
				end
			end
		end)

		UserInputService.InputEnded:Connect(function(input: InputObject, gpc: boolean)
			if gpc then
				return
			end

			local inputType = input.UserInputType
			if isMouseButtonType(inputType) then
				if not state.ButtonsReleased:Has(inputType) then
					state.ButtonsReleased:PushBack(inputType)
				end

				if state.ButtonsDown:Has(inputType) then
					state.ButtonsDown:Pop(inputType)
				end
			end
		end)
	end
end

function MouseInput:Flush()
	local state = self.MouseState
	state.MoveDelta = Vector2.zero
	state.ScrollDelta = 0
	state.ButtonsPressed:Clear()
	state.ButtonsReleased:Clear()
end

return MouseInput
