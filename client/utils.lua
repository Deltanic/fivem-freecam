function table.copy(x)
  local copy = {}
  for k, v in pairs(x) do
    if type(v) == 'table' then
        copy[k] = table.copy(v)
    else
        copy[k] = v
    end
  end
  return copy
end

function protect(t)
  local fn = function (_, k)
    error('Key `' .. tostring(k) .. '` is not supported.')
  end

  return setmetatable(t, {
    __index = fn,
    __newindex = fn
  })
end

function CreateGamepadMetatable(keyboard, gamepad)
  return setmetatable({}, {
    __index = function (t, k)
      local src = IsGamepadControl() and gamepad or keyboard
      return src[k]
    end
  })
end

function Clamp(x, min, max)
  return math.min(math.max(x, min), max)
end

function ClampCameraRotation(rotX, rotY, rotZ)
  local x = Clamp(rotX, -90.0, 90.0)
  local y = rotY % 360
  local z = rotZ % 360
  return x, y, z
end

function IsGamepadControl()
  return not IsInputDisabled(2)
end

function GetSmartControlNormal(control)
    if type(control) == 'table' then
      local normal1 = GetDisabledControlNormal(0, control[1])
      local normal2 = GetDisabledControlNormal(0, control[2])
      return normal1 - normal2
    end

    return GetDisabledControlNormal(0, control)
  end

function EulerToMatrix(rotX, rotY, rotZ)
  local radX = math.rad(rotX)
  local radY = math.rad(rotY)
  local radZ = math.rad(rotZ)

  local sinX = math.sin(radX)
  local sinY = math.sin(radY)
  local sinZ = math.sin(radZ)
  local cosX = math.cos(radX)
  local cosY = math.cos(radY)
  local cosZ = math.cos(radZ)

  local vecX = {}
  local vecY = {}
  local vecZ = {}

  vecX.x = cosY * cosZ
  vecX.y = cosY * sinZ
  vecX.z = -sinY

  vecY.x = cosZ * sinX * sinY - cosX * sinZ
  vecY.y = cosX * cosZ - sinX * sinY * sinZ
  vecY.z = cosY * sinX

  vecZ.x = -cosX * cosZ * sinY + sinX * sinZ
  vecZ.y = -cosZ * sinX + cosX * sinY * sinZ
  vecZ.z = cosX * cosY

  vecX = vector3(vecX.x, vecX.y, vecX.z)
  vecY = vector3(vecY.x, vecY.y, vecY.z)
  vecZ = vector3(vecZ.x, vecZ.y, vecZ.z)

  return vecX, vecY, vecZ
end
