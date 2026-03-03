local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local Logger = require(ReplicatedStorage.Shared.Core.LoggerManager.Logger)
local CharacterService = Knit.CreateService({
	Name = "CharacterService",
	Client = {
		CharacterSpawned = Knit.CreateSignal(),
		CharacterDied = Knit.CreateSignal(),
	},
})

-- * Private API
function CharacterService:_setupCharacter(player, character)
	self.Client.CharacterSpawned:Fire(player, character)

	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	humanoid.Died:Connect(function()
		self.Client.CharacterDied:Fire(player)
		task.delay(3, function()
			if player and player.Parent then
				self:Spawn(player)
			end
		end)
	end)
end

-- * Public API
function CharacterService:Spawn(player: Player)
	player:LoadCharacterAsync()
end

function CharacterService:Despawn(player)
	if player.Character then
		player.Character:Destroy()
	end
end

-- * Knit
function CharacterService:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)
	Logger:Info(KnitMessageConfig.Initialized)
end

function CharacterService:KnitStart()
	Players.CharacterAutoLoads = false

	Players.PlayerAdded:Connect(function(player: Player)
		player.CharacterAdded:Connect(function(character)
			self:_setupCharacter(player, character)
		end)

		--self:Spawn(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:Despawn(player)
	end)
end

return CharacterService
