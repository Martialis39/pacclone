
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


function isInBounds(row, col, gridSize)
    return row > 0 and col > 0 and row < gridSize + 1 and col < gridSize + 1
end

function get_neighbours(row, col, grid)
    local coords = {
        {0, 1},
        {0, -1},
        {1, 0},
        {-1, 0}
    }

    local result = {}
    foreach(coords, function(coord)
        local diffRow, diffCol = coord[1], coord[2]
        local newRow = row + diffRow
        local newCol = col + diffCol
        if isInBounds(newRow, newCol, #grid) then
            add(result, {row=newRow, col=newCol})
        end
    end)

    return result
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

        local neighbors = get_neighbours(row, col, grid)

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
  for_each_grid(g.level, function(tile)
      if check_tile_collision(entity, tile) then
          collision = true
      end
  end, function() return collision end)
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

recalc_path_event = "recalc"

local listeners = {
    [recalc_path_event] = {}
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
    emit(recalc_path_event)
end