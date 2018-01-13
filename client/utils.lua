function Clamp(x, min, max)
  return math.min(math.max(x, min), max)
end

function ToPositiveRotation(rot)
  return math.abs((rot + 360) % 360)
end
