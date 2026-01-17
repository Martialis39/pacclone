
-- ty nerdy teachers!
mtbl = {
  --__add called when + operator is used
  __add = function(a, b) 
      return { x = (a.x+b.x), y = (a.y+b.y) }
  end,
  __eq = function(a, b)
      return a.x == b.x and b.y == a.y
  end
}


function vec2(x, y)
    local x = x or 0
    local y = y or 0
    local t = {x=x, y=y}
    setmetatable(t, mtbl)
    return t
end