local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local OrderedCollections =
	require(ReplicatedStorage.Packages._Index["hgta1287dev_ordered-collections@1.0.0"]["ordered-collections"])
local CframeBuffer = require(ReplicatedStorage.Shared.Utils.CframeBuffer)
local Logger = require(ReplicatedStorage.Shared.Utils.Logger)

-- * Types
export type Map<K, V> = OrderedCollections.Map<K, V>
export type Set<T> = OrderedCollections.Set<T>

-- * Service
local CameraProxyService = Knit.CreateService({
	Name = "CameraProxyService",
	Client = {
		CameraAdded = Knit.CreateSignal(),
		CameraRemoved = Knit.CreateSignal(),
		CamerasUpdated = Knit.CreateSignal(),
	},
	cameras = OrderedCollections.Set.new() :: Set<number>,
	cframesBuffer = OrderedCollections.Map.new() :: Map<number, CFrame>,
})

-- * Constant
local SCOPENAME = "CameraProxyService"
local UPDATE_INTERVAL = 1 / 10 -- 1 / n = n hz

-- * Client API
function CameraProxyService.Client:GetCameras()
	local snapshot = self.Server:_serializeCameras()
	return snapshot
end

function CameraProxyService.Client:UpdateCamera(player: Player, cframeBuffer: buffer)
	local cameraCframe = CframeBuffer.Deserialize(cframeBuffer)
	CameraProxyService:UpdateCamera(player, cameraCframe)
end

-- * Public API
-- Cframe Updater
function CameraProxyService:UpdateCamera(player: Player, cameraCframe: CFrame)
	if typeof(cameraCframe) ~= "CFrame" then
		return
	end
	self.cframesBuffer:Set(player.UserId, cameraCframe)
end

function CameraProxyService:Render()
	if self.cframesBuffer:Size() == 0 then
		return
	end

	local snapshot = self:_serializeCframes()
	self.Client.CamerasUpdated:FireAll(snapshot)
end

-- Proxy Spawner
function CameraProxyService:Spawn(player: Player)
	if self.cameras:Has(player.UserId) then
		Logger.warn(SCOPENAME, "Camera already exists!")
	end

	self.cameras:PushBack(player.UserId)

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer == player then
			continue
		end
		self.Client.CameraAdded:Fire(otherPlayer, player.UserId)
	end
end

function CameraProxyService:Despawn(player: Player)
	if not self.cameras:Has(player.UserId) then
		return
	end

	self.cameras:Pop(player.UserId)
	self.cframesBuffer:Remove(player.UserId)

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer == player then
			continue
		end
		self.Client.CameraRemoved:Fire(otherPlayer, player.UserId)
	end
end

-- * Private API
function CameraProxyService:_serializeCameras(): { number }
	local set = self.cameras :: Set<number>
	return set:ToArray()
end

function CameraProxyService:_serializeCframes(): { [number]: CFrame }
	local map = self.cframesBuffer :: Map<number, CFrame>
	local packet = table.create(map:Size())

	map:Each(function(userId: number, cframe: CFrame)
		packet[userId] = CframeBuffer.Serialize(cframe)
	end)

	return packet
end

-- * Knit
function CameraProxyService:KnitStart()
	Players.PlayerAdded:Connect(function(player: Player)
		self:Spawn(player)
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		self:Despawn(player)
	end)
	RunService.Heartbeat:Connect(function(dt)
		self._accumulator = self._accumulator and self._accumulator + dt or dt
		if self._accumulator >= UPDATE_INTERVAL then
			self._accumulator = 0
			self:Render()
		end
	end)
end

return CameraProxyService
