local INPUT_SPRINT = 21
local INPUT_CHARACTER_WHEEL = 19
local INPUT_LOOK_LR = 1
local INPUT_LOOK_UD = 2
local INPUT_COVER = 44
local INPUT_PICKUP = 38
local INPUT_MOVE_UD = 31
local INPUT_MOVE_LR = 30

--------------------------------------------------------------------------------

local camera
local settings = {
  --Camera
  fov = 45.0,

  -- Mouse
  mouseSensitivityX = 5,
  mouseSensitivityY = 5,

  -- Movement
  normalMoveMultiplier = 1,
  fastMoveMultiplier = 10,
  slowMoveMultiplier = 0.1,

  -- On enable/disable
  enableEasing = true,
  easingDuration = 1000
}

--------------------------------------------------------------------------------

local isCameraFrozen

--------------------------------------------------------------------------------

function IsEnabled()
  return IsCamActive(camera) == 1
end

function SetEnabled(enable)
  if enable == IsEnabled() then
    return
  end

  if enable then
    local pos = GetGameplayCamCoord()
    local rot = GetGameplayCamRot()

    camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetFov(settings.fov)
    SetPosition(pos.x, pos.y, pos.z)
    SetRotation(rot.x, rot.y, rot.z)
  else
    DestroyCam(camera)
    ClearFocus()
    UnlockMinimapPosition()
    UnlockMinimapAngle()
  end

  SetPlayerControl(PlayerId(), not enable)
  RenderScriptCams(enable, settings.enableEasing, settings.easingDuration)
end

--------------------------------------------------------------------------------

function IsFrozen()
  return isCameraFrozen
end

function SetFrozen(frozen)
  isCameraFrozen = frozen
end

--------------------------------------------------------------------------------

function GetFov()
  return GetCamFov(camera)
end

function SetFov(fov)
  return SetCamFov(camera, fov)
end

--------------------------------------------------------------------------------

function GetTarget(distance)
  local _, vecY, _, pos = GetCamMatrix(camera)
  return { table.unpack(pos + (vecY * distance)) }
end

--------------------------------------------------------------------------------

function GetPosition()
  return { table.unpack(GetCamCoord(camera)) }
end

function SetPosition(posX, posY, posZ)
  local interior = GetInteriorAtCoords(posX, posY, posZ)

  LoadInterior(interior)
  SetFocusArea(posX, posY, posZ)
  LockMinimapPosition(posX, posY)

  return SetCamCoord(camera, posX, posY, posZ)
end

--------------------------------------------------------------------------------

function GetRotation()
  return { table.unpack(GetCamRot(camera)) }
end

function SetRotation(rotX, rotY, rotZ)
  local angle = rotZ % 360
  local pitch = Clamp(rotX, -90.0, 90.0)

  LockMinimapAngle(math.floor(angle))

  return SetCamRot(camera, pitch, rotY, rotZ)
end

--------------------------------------------------------------------------------

local function GetSpeedMultiplier()
  if IsDisabledControlPressed(0, INPUT_SPRINT) then
    return settings.fastMoveMultiplier
  elseif IsDisabledControlPressed(0, INPUT_CHARACTER_WHEEL) then
    return settings.slowMoveMultiplier
  end

  return settings.normalMoveMultiplier
end

--------------------------------------------------------------------------------

Citizen.CreateThread(function()
  local function CameraLoop()
    if not IsEnabled() or IsPauseMenuActive() then
      return
    end

    if not IsFrozen() then
      local vecX, vecY = GetCamMatrix(camera)
      local pos = GetCamCoord(camera)
      local rot = GetCamRot(camera)

      -- Get speed multiplier for movement
      local frameMultiplier = GetFrameTime() * 60
      local speedMultiplier = GetSpeedMultiplier()

      -- Get mouse input
      local mouseX = GetDisabledControlNormal(0, INPUT_LOOK_LR)
      local mouseY = GetDisabledControlNormal(0, INPUT_LOOK_UD)

      -- Get keyboard input
      local moveWS = GetDisabledControlNormal(0, INPUT_MOVE_UD)
      local moveAD = GetDisabledControlNormal(0, INPUT_MOVE_LR)

      -- Calculate new rotation.
      local rotX = rot.x + (-mouseY * settings.mouseSensitivityY)
      local rotZ = rot.z + (-mouseX * settings.mouseSensitivityX)
      local rotY = 0.0

      -- Adjust position relative to camera rotation.
      pos = pos + (vecX *  moveAD * frameMultiplier * speedMultiplier)
      pos = pos + (vecY * -moveWS * frameMultiplier * speedMultiplier)

      -- Adjust new rotation
      rot = vector3(rotX, rotY, rotZ)

      -- Update camera
      SetPosition(pos.x, pos.y, pos.z)
      SetRotation(rot.x, rot.y, rot.z)
    end

    -- Trigger an update event. Resources depending on the freecam position can
    -- make use of this event.
    TriggerEvent('freecam:onFreecamUpdate')
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
    SetEnabled(false)
  end
end)
