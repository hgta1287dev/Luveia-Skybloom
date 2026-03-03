local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStates = require(script.Parent.GameStates)
local Knit = require(ReplicatedStorage.Packages.Knit)
local StateMachine = require(ReplicatedStorage.Packages.StateMachine)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

-- * Types
export type State = GameStates.State

-- * Constants
local DEFAULT_STATE: State = GameStates.MainMenu

-- * Controller
local Logger = LoggerManager:CreateLogger("GameStateController")
local GameStateController = Knit.CreateController({
	Name = "GameStateController",
})

-- * Private
function GameStateController:_registerStates()
	for _, state in pairs(GameStates) do
		self._machine:RegisterState(state)
	end
end

-- * Public
function GameStateController:ChangeState(state: State)
	return self._machine:ChangeState(state)
end

function GameStateController:StartGame()
	return self._machine:ChangeState(GameStates.Gameplay)
end

function GameStateController:ReturnToMenu()
	return self._machine:ChangeState(GameStates.MainMenu)
end

-- * Knit
function GameStateController:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)
	self._machine = StateMachine.new()
	self:_registerStates()

	Logger:Info(KnitMessageConfig.Initialized)
end

function GameStateController:KnitStart()
	Logger:Info(KnitMessageConfig.Starting)
	self:ChangeState(DEFAULT_STATE)
	Logger:Info(KnitMessageConfig.Started)
end

return GameStateController
