local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Packages.Signal)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local Logger = Knit.CreateLogger("CharacterController")
local CharacterController = Knit.CreateController({
	Name = "CharacterController",
	CharacterSpawned = Signal.new(),
	CharacterDied = Signal.new(),
})

-- * Private
function CharacterController:_onCharacterSpawn(character)
	self.CharacterSpawned:Fire(character)
end

function CharacterController:_onCharacterDied()
	self.CharacterDied:Fire()
end

-- * Public API
function CharacterController:GetCharacter(): Model?
	return Players.LocalPlayer.Character
end

-- * Knit
function CharacterController:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)
	Logger:Info(KnitMessageConfig.Initialized)
end
function CharacterController:KnitStart()
	Logger:Info(KnitMessageConfig.Starting)

	local CharacterService = Knit.GetService("CharacterService")

	CharacterService.CharacterSpawned:Connect(function(character)
		self:_onCharacterSpawn(character)
	end)

	CharacterService.CharacterDied:Connect(function()
		self:_onCharacterDied()
	end)

	Logger:Info(KnitMessageConfig.Started)
end

return CharacterController
