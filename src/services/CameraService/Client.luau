local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CameraSystem = require(script.Parent.CameraSystem)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Knit = require(ReplicatedStorage.Packages.Knit)
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)

local CameraController = HoenKnit.CreateController({
	Name = "CameraController",
	_currentTransitionPromise = nil,
})
local Logger = CameraController._logger
Logger:SetDefaultCategory("Gameplay")

-- * Private
function CameraController:_cancelCurrent()
	if self._currentTransitionPromise then
		self._currentTransitionPromise:cancel()
		self._currentTransitionPromise = nil
	end
end

function CameraController:_playTransition()
	return Promise.new(function(resolve, reject, onCancel)
		local cancelled = false

		onCancel(function()
			cancelled = true
			reject("Cancelled")
		end)

		-- TODO: fade out, blur, etc.
		task.spawn(function()
			if cancelled then
				return
			end

			self:MoveCameraToCurrentMap()

			resolve()
		end)
	end)
end

-- * Public
function CameraController:MoveCameraTo(cameraPivot: BasePart)
	print("Moving camera to", cameraPivot.Name)
	CameraSystem:GetContext().CameraState.LookAtObject = cameraPivot
end

function CameraController:MoveCameraToCurrentMap()
	local MapController = Knit.GetController("MapController")
	local map = MapController:GetCurrentMap()
	if not map then
		return
	end

	self:MoveCameraTo(map.CameraPivot)
end

-- * Knit
function CameraController:KnitStart()
	local MapController = Knit.GetController("MapController")

	CameraSystem:Init()
	self:MoveCameraToCurrentMap()
	MapController.MapUpdated:Connect(function(mapName: string, transitionId: number)
		Logger:Info(`Camera updating to map {mapName}`)

		self:_cancelCurrent()

		local promise = self:_playTransition()
		self._currentTransitionPromise = promise

		promise
			:andThen(function()
				if self._currentTransitionPromise ~= promise then
					return
				end

				MapController.TransitionReady:Fire(transitionId)
			end)
			:catch(function(err)
				if err ~= "Cancelled" then
					Logger:Error("Error while playing transition: " .. err)
					MapController.TransitionReady:Fire(transitionId)
				end
			end)
			:finally(function()
				if self._currentTransitionPromise == promise then
					self._currentTransitionPromise = nil
				end
			end)
	end)
end

return CameraController
