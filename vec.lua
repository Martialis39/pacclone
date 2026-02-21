
-- ty nerdy teachers!
local mtbl = {
  __sub = function(a, b) 
      return vec2((a.x-b.x), (a.y-b.y))
  end,
  __add = function(a, b) 
      return vec2((a.x+b.x), (a.y+b.y))
  end,
  __mul = function(a, b) 
      return vec2((a.x * b), (a.y * b))
  end,
  __eq = function(a, b)
      return a.x == b.x and b.y == a.y
  end,
  __tostring = function(table)
    local s = ""
    for k,v in pairs(table) do
        s = s..k..": "..v.."; "
    end
    return s
  end
}


function vec2(x, y)
    local x = x or 0
    local y = y or 0
    local t = {x=x, y=y}
    setmetatable(t, mtbl)
    return t
end

function distance_to(a, b)
    return abs(a.x - b.x) + abs(a.y - b.y)
end