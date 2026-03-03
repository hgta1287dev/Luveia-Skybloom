local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CameraProxyFactory = require(script.Parent.CameraProxyFactory)
local Knit = require(ReplicatedStorage.Packages.Knit)
local CframeBuffer = require(ReplicatedStorage.Shared.Utils.CframeBuffer)
local Logger = require(ReplicatedStorage.Shared.Utils.Logger)

local CameraProxyController = Knit.CreateController({
	Name = "CameraProxyController",

	_targets = {}, -- [userId] = target CFrame
	_cameras = {}, -- [userId] = Model
	_smoothing = 0.15, -- interpolation strength
})

-- * Constant
local SCOPENAME = "CameraProxyController"
local UPDATE_INTERVAL = 1 / 30 -- 30 hz
local RENDER_NAME = "CameraProxyController"
local RENDER_PRIORITY = Enum.RenderPriority.Last.Value

-- * Public
function CameraProxyController:CreateCamera(userId: number)
	if self._cameras[userId] then
		return self._cameras[userId]
	end

	local cameraModel = CameraProxyFactory:Create()
	self._cameras[userId] = cameraModel

	return cameraModel
end

function CameraProxyController:UpdateCameras(dt)
	for userId, target in pairs(self._targets) do
		local camera = self._cameras[userId]
		if camera then
			local current = camera:GetPivot()
			local alpha = 1 - math.exp(-dt * 12) -- framerate independent smoothing
			local new = current:Lerp(target, alpha)
			camera:PivotTo(new)
		end
	end
	table.clear(self._targets)
end

function CameraProxyController:GetCamera(userId: number)
	return self._cameras[userId]
end

-- * Private
function CameraProxyController:_onCamerasUpdated(snapshot)
	for userId, buffer in pairs(snapshot) do
		local cf = CframeBuffer.Deserialize(buffer)
		self._targets[userId] = cf
	end
end

function CameraProxyController:_onCameraAdded(userId: number)
	self:CreateCamera(userId)
end

function CameraProxyController:_onCameraRemoved(userId: number)
	local cam = self._cameras[userId]
	if cam then
		cam:Destroy()
	end

	self._cameras[userId] = nil
	self._targets[userId] = nil
end

function CameraProxyController:_renderStep(dt)
	self:UpdateCameras(dt)
end

-- Serialization
function CameraProxyController:_serializeCurrentCframe()
	local camera = workspace.CurrentCamera
	return CframeBuffer.Serialize(camera.CFrame)
end

-- My camera setup
function CameraProxyController:_setupMyCamera()
	local userId = game.Players.LocalPlayer.UserId
	local myCamera = self._cameras[userId]

	if not myCamera then
		return
	end

	for _, descendant in ipairs(myCamera:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CanTouch = false
			descendant.CanQuery = false
			descendant.Transparency = 1
		end
	end
end

-- * Knit
function CameraProxyController:KnitStart()
	local service = Knit.GetService("CameraProxyService")

	service
		:GetCameras()
		:andThen(function(res: { number })
			for _, userId in ipairs(res) do
				self:_onCameraAdded(userId)
			end
		end)
		:catch(function(err)
			Logger.error(SCOPENAME, err)
		end)

	service.CamerasUpdated:Connect(function(snapshot)
		self:_onCamerasUpdated(snapshot)
	end)

	service.CameraAdded:Connect(function(userId)
		self:_onCameraAdded(userId)
		if userId == game.Players.LocalPlayer.UserId then
			self:_setupMyCamera()
		end
	end)

	service.CameraRemoved:Connect(function(userId)
		self:_onCameraRemoved(userId)
	end)

	RunService:BindToRenderStep(RENDER_NAME, RENDER_PRIORITY, function(dt: number)
		self:_renderStep(dt)
		self._accumulator = self._accumulator and self._accumulator + dt or dt

		if self._accumulator < UPDATE_INTERVAL then
			return
		end

		local camera = workspace.CurrentCamera
		local currentCfr = camera.CFrame

		if currentCfr == self._lastCfr then
			return
		end

		self._accumulator = 0
		self._lastCfr = currentCfr

		local buffer = self:_serializeCurrentCframe()
		service:UpdateCamera(buffer):catch(function(err)
			Logger.error(SCOPENAME, err)
		end)
	end)
end

return CameraProxyController
