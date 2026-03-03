local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoomTypes = require(script.Parent.RoomTypes)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local Logger = LoggerManager:CreateLogger("RoomController")
local RoomController = Knit.CreateController({
	Name = "RoomController",
})

-- * Types
export type SerializedRoomData = RoomTypes.SerializedRoomData

-- * Knit
function RoomController:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)

	self.CurrentRoom = nil
	self.Rooms = {}
	self.RoomsChanged = Signal.new()

	Logger:Info(KnitMessageConfig.Initialized)
end

function RoomController:KnitStart()
	Logger:Info(KnitMessageConfig.Starting)

	self.RoomService = Knit.GetService("RoomService")

	self.RoomService.RoomJoined:Connect(function(room)
		print("Joined room:", room.Id)
		self.CurrentRoom = room
	end)

	self.RoomService.RoomUpdated:Connect(function(room)
		print("Room updated:", room.PlayerCount)
	end)

	self.RoomService.RoomLeft:Connect(function(room)
		print("Left room")
		self.CurrentRoom = nil
	end)

	self.RoomService.RoomStarted:Connect(function(room)
		print("Game started!")
	end)

	self.RoomService.RoomKicked:Connect(function(reason: string, snapshot)
		print(`Kicked from room {snapshot.Id} with reason: {reason}`)
	end)

	self.RoomService.RoomAdded:Connect(function(room)
		self.Rooms[room.Id] = room
		self.RoomsChanged:Fire(self.Rooms)
	end)

	self.RoomService.RoomRemoved:Connect(function(roomId)
		self.Rooms[roomId] = nil
		self.RoomsChanged:Fire(self.Rooms)
	end)

	self.RoomService.RoomUpdated:Connect(function(room)
		self.Rooms[room.Id] = room
		self.RoomsChanged:Fire(self.Rooms)
	end)

	Logger:Info(KnitMessageConfig.Started)
end

function RoomController:GetRooms()
	return self.Rooms :: { [string]: SerializedRoomData }
end

return RoomController
