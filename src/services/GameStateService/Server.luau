local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local StateMachine = require(ReplicatedStorage.Packages.StateMachine)
local GameStateService = Knit.CreateService({
	Name = "GameStateService",
	Client = {},

	_machine = StateMachine.new(),
})

-- * Knit
function GameStateService:KnitStart() end

-- * Client

-- * Private

-- * Public API

return GameStateService
