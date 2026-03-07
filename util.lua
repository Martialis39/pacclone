
function for_each_grid(grid, fn, break_fn)
    local early_break = break_fn or function()
        return false
    end

    local i = 1
    while i <= #grid and (early_break() == false) do
        local j = 1
        while j <= #grid[i] and (early_break() == false) do
            
            fn(grid[i][j])
            j = j + 1
        end

        i = i + 1
    end
end

function log(str, override)
    local o = override or false
    printh(str, "log.txt", o)
    return o
end

function logt(t, l)
    local label = l or nil
    local s = ""
    if label then
        s = s .. label .. ": "
    end
    for k, v in pairs(t) do
        local new_snip = k..":"..v.."; "
        s = s .. new_snip
    end
    log(s)
    return s
end

function logtr(t, l)
local label = l or nil
    local s = ""
    if label then
        s = s .. label .. ": "
    end
    for k, v in pairs(t) do
        if type(v) == "table" then
            local res = logtr(v, k)
            s = s..res
        else
            local new_snip = k..":"..v.."; "
        s = s .. new_snip
        end
    end
    log(s)
    return s
end


local animate = function(entity)
  entity.tick += 1
  if entity.tick > 4 then
    entity.tick = 0
    entity.f_index += 1
    if entity.f_index > #entity.frames then
      entity.f_index = 1
    end 
  end
end

 function reverse(table)
    local res = {}
    local j = 1
    for i=#table, 1, -1 do
        res[i] = table[j]
        j += 1
    end
    return res
end
-- ty nerdy teachers!
function rect_rect_collision( r1, r2 )
  return r1.x < r2.x+r2.w and
         r1.x+r1.w > r2.x and
         r1.y < r2.y+r2.h and
         r1.y+r1.h > r2.y
end

check_map_collision = function(entity)
  local collision = false
  local tile_position_row = flr(entity.position.y / g.step)
  local rows_to_check = {-1, 0, 1}
  for i=1, #rows_to_check do
    local new_row = tile_position_row + rows_to_check[i]
    if not (new_row < 1 or new_row > g.level_size) then
       local current_row = g.level[new_row]
       for j=1, #current_row do
         collision = check_tile_collision(entity, current_row[j]) 
         if collision then
            break
         end
       end
    end
    if collision then
        break
    end
  end
  return collision
end

check_tile_collision = function(entity, object)
    if object.type == "o" or object.type == "g" or object.type == "g2" then
        return false
    end
    local r1 = {}
    r1.x, r1.y = entity.position.x, entity.position.y
    r1.w, r1.h = entity.w, entity.h
    return rect_rect_collision(r1, object)
end

-- Events

player_moved_event = "pme"

local listeners = {
    [player_moved_event] = {}
}

function add_listener(type, fn)
    if (listeners[type]) then
        add(listeners[type], fn)
    end
end


function emit(t)
    local ls = listeners[t]
    if not ls then
        return
    end
    foreach(ls, function(listener)
        listener()
    end)

end

function emit_recalc()
    emit(player_moved_event)
end

function foreachi(tbl, fn)
    local i = 1
    foreach(tbl, function(e)
        fn(e, i)
        i+=1
    end)
end

function lerp(a, b, t)
    local result = a+t*(b-a)
    return result
end

function filter(...)

    local args = {...}
    local list = nil
    local fn = nil

    local _filter = function(l, func)
        local result = {}
        for i=1, #l do
            local element = l[i]
            local test = fn(element)
            if(test) then
                add(result, element)
            end
            
        end
        return result
        
    end

    if #args == 2 then
        list = args[1]
        fn = args[2]
        return _filter(list, fn)
    elseif #args == 1 then -- curry
        fn = args[1]
        return function(l)
            return _filter(l, fn)
        end
    end
end

function reduce(list, fn, start_val) -- takes accumulator and curr, accumu
    local result = start_val
    foreach(list, function(element)
        result = fn(result, element)
    end)

    return result
        
end