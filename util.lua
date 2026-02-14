
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



function bfs(start_row, start_col, end_row, end_col, grid)
    local visited = {}
    local prev = {}
    for i=1, #grid do
        visited[i] = {}
        prev[i] = {}
    end
    local q = {{col=start_col, row = start_row}}
    local i = 0
    while #q > 0 do
        local curr = q[1]
        deli(q, 1)
        local row,col = curr.row, curr.col
        if col == end_col and row == end_row then
            break
        end
        visited[row][col] = true

        local neighbors = g.neighbor_map[row][col] or {}

        foreach(neighbors, function(neighbor)
            local r, c = neighbor.row, neighbor.col
            if visited[r][c] == true or grid[r][c].type == "#" then
                return 
            end

            -- visited[r][c] = true
            prev[r][c] = {row=row, col=col}
            add(q, neighbor)
        end)
    end
    return prev
end

function path_from_result(sr, sc, er, ec, prev)
    if not prev[er][ec] then return {} end

    local path = {}
    local current = {row = er, col = ec}
    
    while current do
        add(path, current)
        local next = prev[current.row][current.col]
        current = next
    end

    if #path < 1 then
        return {}
    end
    local r = reverse(path)
    if r[1].col == sc and r[1].row == sr then
        return r
    else
        return {}
    end

end

function solve_for_entities(a, b)

  local a_tile_pos = vec2(flr(a.position.x / g.step), flr(a.position.y / g.step))

  local b_tile_pos = vec2(flr(b.position.x / g.step), flr(b.position.y / g.step))

  local sr, sc = a_tile_pos.y, a_tile_pos.x
  local er, ec = b_tile_pos.y, b_tile_pos.x
  return solve(sr, sc, er, ec, g.level)
end

function solve(srow, scol, erow, ecol, grid)
  local res = bfs(srow, scol, erow, ecol, grid)
  return path_from_result(srow, scol, erow, ecol, res)
end


function debug_path(path)
  if #path > 0 then
    foreach(path, function(t)
        add_debug_gfx(myrect((t.col) * 8, (t.row) * 8))
    end)
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