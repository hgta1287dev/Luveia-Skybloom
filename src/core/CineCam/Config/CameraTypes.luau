local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CameraContext =
	require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Context.CameraContext)
local CameraOutput = require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Output.CameraOutput)
local CameraResult = require(ReplicatedStorage.Shared.Services.CameraService.CameraSystem.CineCam.Output.CameraResult)

-- * Types
export type CameraContext = CameraContext.CameraContext
export type CameraState = CameraContext.CameraState
export type CameraInputState = CameraContext.CameraInputState
-- export type CameraControllerState = CameraControllerState.CameraControllerState

-- export type CameraVCam = BaseCameraMode.BaseMode
-- export type CameraComponent = BaseCameraController.BaseController

export type CameraOutput = CameraOutput.CameraOutput
export type CameraResult = CameraResult.CameraResult

return {}
