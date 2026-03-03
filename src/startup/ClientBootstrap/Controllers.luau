local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CONTROLLERS = {
	"LightingService",
	"CameraProxyService",
	"MapService",
	-- "CameraService", --! Have problems with this one
	"WindService",
	"TestService",
	"RoomService",
	"CharacterService",
}

local Controllers = {
	controllers = {},
}
function Controllers:Init()
	for _, name in CONTROLLERS do
		Controllers.controllers[name] = require(ReplicatedStorage.Shared.Services[name][`{name}Client`])
	end
end

return Controllers
