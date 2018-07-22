function Clamp(x, min, max)
  return math.min(math.max(x, min), max)
end

function GetDisabledControlNormalBetween(inputGroup, control1, control2)
  local normal1 = GetDisabledControlNormal(inputGroup, control1)
  local normal2 = GetDisabledControlNormal(inputGroup, control2)
  return normal1 - normal2
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
