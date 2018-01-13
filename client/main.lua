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

function IsFreecamEnabled()
  return IsCamActive(camera) ~= false
end

function SetFreecamEnabled(enable)
  if enable == IsFreecamEnabled() then
    return
  end

  if enable then
    local pos = GetGameplayCamCoord()
    local rot = GetGameplayCamRot()

    camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamCoord(camera, pos.x, pos.y, pos.z)
    SetCamRot(camera, rot.x, rot.y, rot.z)
    SetCamFov(camera, settings.fov)
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
    if not IsFreecamEnabled() or IsPauseMenuActive() then
      return
    end

    local vecX, vecY, vecZ = GetCamMatrix(camera)
    local pos = GetCamCoord(camera)
    local rot = GetCamRot(camera)

    -- Get speed multiplier for movement
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

    -- Clamp camera pitch to avoid the camera going upside down.
    rotX = Clamp(rotX, -90, 90)

    -- Adjust position relative to camera rotation.
    pos = pos + (vecX *  moveAD * speedMultiplier)
    pos = pos + (vecY * -moveWS * speedMultiplier)

    -- Adjust rotation.
    rot = vector3(rotX, rotY, rotZ)

    -- Update LOD streaming
    SetFocusArea(pos.x, pos.y, pos.z)

    -- Update camera
    SetCamCoord(camera, pos.x, pos.y, pos.z)
    SetCamRot(camera, rot.x, rot.y, rot.z)

    -- Update minimap position
    LockMinimapPosition(pos.x, pos.y)
    LockMinimapAngle(math.floor(ToPositiveRotation(rot.z)))

    -- Trigger an update event. Resources depending on the freecam position can
    -- make use of this event.
    TriggerEvent('onClientFreecamUpdate', pos.x, pos.y, pos.z, rot.x, rot.y, rot.z)
  end

  while true do
    Citizen.Wait(0)
    CameraLoop()
  end
end)
