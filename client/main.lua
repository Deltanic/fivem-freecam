local INPUT_LOOK_LR = 1
local INPUT_LOOK_UD = 2
local INPUT_CHARACTER_WHEEL = 19
local INPUT_SPRINT = 21
local INPUT_MOVE_UD = 31
local INPUT_MOVE_LR = 30
local INPUT_VEH_ACCELERATE = 71
local INPUT_VEH_BRAKE = 72
local INPUT_PARACHUTE_BRAKE_LEFT = 152
local INPUT_PARACHUTE_BRAKE_RIGHT = 153

--------------------------------------------------------------------------------

local _internal_camera = nil
local _internal_isFrozen = false

local _internal_pos = nil
local _internal_rot = nil
local _internal_fov = nil
local _internal_vecX = nil
local _internal_vecY = nil
local _internal_vecZ = nil

--------------------------------------------------------------------------------

local KEYBOARD_CONTROLS = {
  lookX = INPUT_LOOK_LR,
  lookY = INPUT_LOOK_UD,

  moveX = INPUT_MOVE_LR,
  moveY = INPUT_MOVE_UD,
  moveZ = { INPUT_PARACHUTE_BRAKE_LEFT, INPUT_PARACHUTE_BRAKE_RIGHT },

  moveFast = INPUT_SPRINT,
  moveSlow = INPUT_CHARACTER_WHEEL
}

local GAMEPAD_CONTROLS = {
  lookX = INPUT_LOOK_LR,
  lookY = INPUT_LOOK_UD,

  moveX = INPUT_MOVE_LR,
  moveY = INPUT_MOVE_UD,
  moveZ = { INPUT_PARACHUTE_BRAKE_RIGHT, INPUT_PARACHUTE_BRAKE_LEFT },

  moveFast = INPUT_VEH_ACCELERATE,
  moveSlow = INPUT_VEH_BRAKE
}

--------------------------------------------------------------------------------

local config = {
  --Camera
  fov = 45.0,

  -- Rotation
  lookSensitivityX = 5,
  lookSensitivityY = 5,

  -- Position
  baseMoveMultiplier = 1,
  fastMoveMultiplier = 10,
  slowMoveMultiplier = 10,

  -- On enable/disable
  enableEasing = true,
  easingDuration = 1000,

  -- Keep position/rotation
  keepPosition = false,
  keepRotation = false
}

--------------------------------------------------------------------------------

local function GetInitialCameraPosition()
  if config.keepPosition and _internal_pos then
    return _internal_pos
  end

  return GetGameplayCamCoord()
end

local function GetInitialCameraRotation()
  if config.keepRotation and _internal_rot then
    return _internal_rot
  end

  local rot = GetGameplayCamRot()
  return vector3(rot.x, 0.0, rot.z)
end

--------------------------------------------------------------------------------

local function GetFreecamConfig(key)
  return config[key]
end

local function SetFreecamConfig(key, value)
  config[key] = value
end

--------------------------------------------------------------------------------

local function IsFreecamFrozen()
  return _internal_isFrozen
end

local function SetFreecamFrozen(frozen)
  local frozen = frozen == true
  _internal_isFrozen = frozen
end

--------------------------------------------------------------------------------

local function GetFreecamPosition()
  return _internal_pos
end

local function SetFreecamPosition(x, y, z)
  local pos = vector3(x, y, z)
  local int = GetInteriorAtCoords(pos)

  LoadInterior(int)
  SetFocusArea(pos)
  LockMinimapPosition(x, y)
  SetCamCoord(_internal_camera, pos)

  _internal_pos = pos
end

--------------------------------------------------------------------------------

local function GetFreecamRotation()
  return _internal_rot
end

local function SetFreecamRotation(x, y, z)
  local rotX, rotY, rotZ = ClampCameraRotation(x, y, z)
  local vecX, vecY, vecZ = EulerToMatrix(rotX, rotY, rotZ)
  local rot = vector3(rotX, rotY, rotZ)

  LockMinimapAngle(math.floor(rotZ))
  SetCamRot(_internal_camera, rot)

  _internal_rot  = rot
  _internal_vecX = vecX
  _internal_vecY = vecY
  _internal_vecZ = vecZ
end

--------------------------------------------------------------------------------

local function GetFreecamFov()
  return _internal_fov
end

local function SetFreecamFov(fov)
  local fov = Clamp(fov, 0.0, 90.0)
  SetCamFov(_internal_camera, fov)
  _internal_fov = fov
end

--------------------------------------------------------------------------------

local function GetFreecamMatrix()
  return _internal_vecX,
         _internal_vecY,
         _internal_vecZ,
         _internal_pos
end

local function GetFreecamTarget(distance)
  local target = _internal_pos + (_internal_vecY * distance)
  return target
end

--------------------------------------------------------------------------------

local function IsFreecamActive()
  return IsCamActive(_internal_camera) == 1
end

local function SetFreecamActive(active)
  if active == IsFreecamActive() then
    return
  end

  if active then
    local pos = GetInitialCameraPosition()
    local rot = GetInitialCameraRotation()

    _internal_camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetFreecamFov(config.fov)
    SetFreecamPosition(pos.x, pos.y, pos.z)
    SetFreecamRotation(rot.x, rot.y, rot.z)
  else
    DestroyCam(_internal_camera)
    ClearFocus()
    UnlockMinimapPosition()
    UnlockMinimapAngle()
  end

  SetPlayerControl(PlayerId(), not active)
  RenderScriptCams(active, config.enableEasing, config.easingDuration)
end

--------------------------------------------------------------------------------

function IsActive()           return IsFreecamActive()           end
function SetActive(active)    return SetFreecamActive(active)    end
function GetConfig(key)       return GetFreecamConfig(key)       end
function SetConfig(key, val)  return SetFreecamConfig(key, val)  end
function IsFrozen()           return IsFreecamFrozen()           end
function SetFrozen(frozen)    return SetFreecamFrozen(frozen)    end
function GetFov()             return GetFreecamFov()             end
function SetFov(fov)          return SetFreecamFov(fov)          end
function GetMatrix()          return GetFreecamMatrix()          end
function GetTarget(distance)  return GetFreecamTarget(distance)  end
function GetPosition()        return GetFreecamPosition()        end
function SetPosition(x, y, z) return SetFreecamPosition(x, y, z) end
function GetRotation()        return GetFreecamRotation()        end
function SetRotation(x, y, z) return SetFreecamRotation(x, y, z) end
function GetPitch()           return GetFreecamRotation().x      end
function GetRoll()            return GetFreecamRotation().y      end
function GetYaw()             return GetFreecamRotation().z      end

--------------------------------------------------------------------------------

Citizen.CreateThread(function()
  local function GetControls()
    return IsGamepadControl() then
      return GAMEPAD_CONTROLS
    end

    return KEYBOARD_CONTROLS
  end

  local function GetSpeedMultiplier(controls)
    local fastNormal = GetSmartControlNormal(controls.moveFast)
    local slowNormal = GetSmartControlNormal(controls.moveSlow)

    local base = config.baseMoveMultiplier
    local fast = 1 + ((config.fastMoveMultiplier - 1) * fastNormal)
    local slow = 1 + ((config.slowMoveMultiplier - 1) * slowNormal)

    return (base * fast / slow) * (GetFrameTime() * 60)
  end

  local function CameraLoop()
    if not IsFreecamActive() or IsPauseMenuActive() then
      return
    end

    if not IsFreecamFrozen() then
      local controls = GetControls()

      local vecX, vecY = GetFreecamMatrix()
      local vecZ = vector3(0, 0, 1)

      local pos = GetFreecamPosition()
      local rot = GetFreecamRotation()

      -- Get speed multiplier for movement
      local speedMultiplier = GetSpeedMultiplier(controls)

      -- Get rotation input
      local lookX = GetSmartControlNormal(controls.lookX)
      local lookY = GetSmartControlNormal(controls.lookY)

      -- Get position input
      local moveX = GetSmartControlNormal(controls.moveX)
      local moveY = GetSmartControlNormal(controls.moveY)
      local moveZ = GetSmartControlNormal(controls.moveZ)

      -- Calculate new rotation.
      local rotX = rot.x + (-lookY * config.lookSensitivityY)
      local rotZ = rot.z + (-lookX * config.lookSensitivityX)
      local rotY = rot.y

      -- Adjust position relative to camera rotation.
      pos = pos + (vecX *  moveX * speedMultiplier)
      pos = pos + (vecY * -moveY * speedMultiplier)
      pos = pos + (vecZ *  moveZ * speedMultiplier)

      -- Adjust new rotation
      rot = vector3(rotX, rotY, rotZ)

      -- Update camera
      SetFreecamPosition(pos.x, pos.y, pos.z)
      SetFreecamRotation(rot.x, rot.y, rot.z)
    end

    -- Trigger a tick event. Resources depending on the freecam position can
    -- make use of this event.
    TriggerEvent('freecam:onTick')
  end

  while true do
    Citizen.Wait(0)
    CameraLoop()
  end
end)

--------------------------------------------------------------------------------

-- When the resource is stopped, make sure to return the camera to the player.
AddEventHandler('onResourceStop', function (resourceName)
  if resourceName == GetCurrentResourceName() then
    SetFreecamActive(false)
  end
end)
