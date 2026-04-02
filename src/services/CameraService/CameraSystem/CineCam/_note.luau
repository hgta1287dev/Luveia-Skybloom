--[[

Cinemachine/
├─ Core/
│   ├─ CinemachineBrain.cs            # Brain duy nhất, apply view xuống Camera thật
│   ├─ CinemachineCore.cs             # Hệ thống trung tâm tracking cameras
│   └─ CinemachineVirtualCameraBase.cs # Base class các virtual camera
│
├─ VirtualCameras/
│   ├─ CinemachineVirtualCamera.cs     # Virtual Camera chính
│   ├─ CinemachineFreeLook.cs          # Virtual Camera free look
│   └─ CinemachineBlendListCamera.cs   # Virtual Camera list/blend
│
├─ Components/                        # Pipeline modules của Virtual Camera
│   ├─ Body/
│   │   ├─ CinemachineTransposer.cs    # Body component
│   │   ├─ CinemachineTrackedDolly.cs  # Body component chạy theo path
│   │   └─ CinemachineOrbitalTransposer.cs
│   │
│   ├─ Aim/
│   │   ├─ CinemachineComposer.cs      # Aim module giữ target trong khung
│   │   └─ CinemachinePOV.cs           # Aim module theo input
│   │
│   ├─ Noise/
│   │   └─ CinemachineBasicMultiChannelPerlin.cs # Noise/Shake
│   │
│   └─ Extensions/                     # Extensions/Modifiers
│       ├─ CinemachineConfiner.cs
│       └─ CinemachineFollowZoom.cs
│
├─ Utilities/
│   └─ Helpers.cs                     # Helper / internal utils
│
└─ Resources/                         # Default assets/icons/profiles

--]]
