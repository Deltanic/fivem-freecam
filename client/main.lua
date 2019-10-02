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

local DEFAULT_CONTROLS = {
  -- Rotation
  lookX = INPUT_LOOK_LR,
  lookY = INPUT_LOOK_UD,

  -- Position
  moveX = INPUT_MOVE_LR,
  moveY = INPUT_MOVE_UD,
  moveZ = { INPUT_PARACHUTE_BRAKE_LEFT, INPUT_PARACHUTE_BRAKE_RIGHT },

  -- Multiplier
  moveFast = INPUT_SPRINT,
  moveSlow = INPUT_CHARACTER_WHEEL
}

-- TODO: Table protection + value assertions.
local CONTROLS_MT = {

}

--------------------------------------------------------------------------------

local DEFAULT_CONFIG = {
  -- Rotation
  lookSensitivityX = 5,
  lookSensitivityY = 5,

  -- Position
  baseMoveMultiplier = 1,
  fastMoveMultiplier = 10,
  slowMoveMultiplier = 10,
}

-- TODO: Table protection + value assertions.
local CONFIG_MT = {

}

--------------------------------------------------------------------------------

local DEFAULT_SETTINGS = {
  --Camera
  fov = 45.0,

  -- On enable/disable
  enableEasing = true,
  easingDuration = 1000,

  -- Keep position/rotation
  keepPosition = false,
  keepRotation = false
}

-- TODO: Table protection + value assertions.
local SETTINGS_MT = {

}

--------------------------------------------------------------------------------

local KEYBOARD_CONTROLS = table.copy(DEFAULT_CONTROLS)
local GAMEPAD_CONTROLS = table.copy(DEFAULT_CONTROLS)

-- Swap up/down movement (LB for down, RB for up)
GAMEPAD_CONTROLS.moveZ[1] = INPUT_PARACHUTE_BRAKE_LEFT
GAMEPAD_CONTROLS.moveZ[2] = INPUT_PARACHUTE_BRAKE_RIGHT

-- Use LT and RT for speed
GAMEPAD_CONTROLS.moveFast = INPUT_VEH_ACCELERATE
GAMEPAD_CONTROLS.moveSlow = INPUT_VEH_BRAKE

setmetatable(KEYBOARD_CONTROLS, CONTROLS_MT)
setmetatable(GAMEPAD_CONTROLS, CONTROLS_MT)

--------------------------------------------------------------------------------

local KEYBOARD_CONFIG = table.copy(DEFAULT_CONFIG)
local GAMEPAD_CONFIG = table.copy(DEFAULT_CONFIG)

-- Gamepad sensitivity can be reduced by default.
GAMEPAD_CONFIG.lookSensitivityX = 2
GAMEPAD_CONFIG.lookSensitivityY = 2

setmetatable(KEYBOARD_CONFIG, CONFIG_MT)
setmetatable(GAMEPAD_CONFIG, CONFIG_MT)

--------------------------------------------------------------------------------

local CAMERA_SETTINGS = table.copy(DEFAULT_SETTINGS)
setmetatable(CAMERA_SETTINGS, SETTINGS_MT)

--------------------------------------------------------------------------------

local function CreateGamepadMetatable(keyboard, gamepad)
  return setmetatable({}, {
    __index = function (t, k)
      local src = IsGamepadControl() and gamepad or keyboard
      return src[k]
    end
  })
end

-- For convenience.
local CONTROLS = CreateGamepadMetatable(KEYBOARD_CONTROLS, GAMEPAD_CONTROLS)
local CONFIG   = CreateGamepadMetatable(KEYBOARD_CONFIG,   GAMEPAD_CONFIG)

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

local function GetInitialCameraPosition()
  if CAMERA_SETTINGS.keepPosition and _internal_pos then
    return _internal_pos
  end

  return GetGameplayCamCoord()
end

local function GetInitialCameraRotation()
  if CAMERA_SETTINGS.keepRotation and _internal_rot then
    return _internal_rot
  end

  local rot = GetGameplayCamRot()
  return vector3(rot.x, 0.0, rot.z)
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

    SetFreecamFov(CAMERA_SETTINGS.fov)
    SetFreecamPosition(pos.x, pos.y, pos.z)
    SetFreecamRotation(rot.x, rot.y, rot.z)
  else
    DestroyCam(_internal_camera)
    ClearFocus()
    UnlockMinimapPosition()
    UnlockMinimapAngle()
  end

  SetPlayerControl(PlayerId(), not active)
  RenderScriptCams(active, CAMERA_SETTINGS.enableEasing, CAMERA_SETTINGS.easingDuration)
end

--------------------------------------------------------------------------------

function GetKeyboardControl(key) return KEYBOARD_CONTROLS[key]  end
function GetGamepadControl (key) return GAMEPAD_CONTROLS[key]   end
function GetKeyboardConfig (key) return KEYBOARD_CONFIG[key]    end
function GetGamepadConfig  (key) return GAMEPAD_CONFIG[key]     end
function GetCameraSetting  (key) return CAMERA_SETTINGS[key]    end

function SetKeyboardControl(key, value) KEYBOARD_CONTROLS[key] = value end
function SetGamepadControl (key, value) GAMEPAD_CONTROLS[key]  = value end
function SetKeyboardConfig (key, value) KEYBOARD_CONFIG[key]   = value end
function SetGamepadConfig  (key, value) GAMEPAD_CONFIG[key]    = value end
function SetCameraSetting  (key, value) CAMERA_SETTINGS[key]   = value end

--------------------------------------------------------------------------------

function IsActive()           return IsFreecamActive()           end
function SetActive(active)    return SetFreecamActive(active)    end
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
  local function GetSpeedMultiplier()
    local fastNormal = GetSmartControlNormal(CONTROLS.moveFast)
    local slowNormal = GetSmartControlNormal(CONTROLS.moveSlow)

    local baseSpeed = CONFIG.baseMoveMultiplier
    local fastSpeed = 1 + ((CONFIG.fastMoveMultiplier - 1) * fastNormal)
    local slowSpeed = 1 + ((CONFIG.slowMoveMultiplier - 1) * slowNormal)

    local frameMultiplier = GetFrameTime() * 60
    local speedMultiplier = baseSpeed * fastSpeed / slowSpeed

    return speedMultiplier * frameMultiplier
  end

  local function CameraLoop()
    if not IsFreecamActive() or IsPauseMenuActive() then
      return
    end

    if not IsFreecamFrozen() then
      local vecX, vecY = GetFreecamMatrix()
      local vecZ = vector3(0, 0, 1)

      local pos = GetFreecamPosition()
      local rot = GetFreecamRotation()

      -- Get speed multiplier for movement
      local speedMultiplier = GetSpeedMultiplier()

      -- Get rotation input
      local lookX = GetSmartControlNormal(CONTROLS.lookX)
      local lookY = GetSmartControlNormal(CONTROLS.lookY)

      -- Get position input
      local moveX = GetSmartControlNormal(CONTROLS.moveX)
      local moveY = GetSmartControlNormal(CONTROLS.moveY)
      local moveZ = GetSmartControlNormal(CONTROLS.moveZ)

      -- Calculate new rotation.
      local rotX = rot.x + (-lookY * CONFIG.lookSensitivityY)
      local rotZ = rot.z + (-lookX * CONFIG.lookSensitivityX)
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
