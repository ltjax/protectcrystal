
local Vector={}

function Vector.add(a, b)
  return {x=a.x+b.x, y=a.y+b.y}
end

function Vector.subtract(a, b)
  return {x=a.x-b.x, y=a.y-b.y}
end

function Vector.scale(a, lambda)
  return {x=a.x*lambda, y=a.y*lambda}
end

function Vector.length(a)
  return math.sqrt(a.x*a.x+a.y*a.y)
end

function Vector.squareDistance(a, b)
  local dx=b.x-a.x
  local dy=b.y-a.y
  return dx*dx+dy*dy
end

function Vector.normalize(a)
  return Vector.scale(a, 1.0/Vector.length(a))
end

function Vector.fromAngle(angle)
  return {x=math.cos(angle), y=math.sin(angle)}
end

function Vector.toAngle(p)
  return math.atan2(p.y, p.x)
end

return Vector
