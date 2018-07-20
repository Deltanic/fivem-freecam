function Clamp(x, min, max)
  return math.min(math.max(x, min), max)
end

function GetDisabledControlNormalBetween(inputGroup, control1, control2)
  local normal1 = GetDisabledControlNormal(inputGroup, control1)
  local normal2 = GetDisabledControlNormal(inputGroup, control2)
  return normal1 - normal2
end
