
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


function create_grid(n)
    local rows = {}
    for i=1, n do
        local row = {}
        for j=1, n do
            add(row, "empty")
        end
        add(rows, row)
    end
    return rows
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

function find_path(start_row, start_col, end_row, end_col, grid)
    local visited = create_grid(#grid)
    local prev = create_grid(#grid)
    local found = false
    local q = {{col=start_col, row = start_row}}
    local i = 0
    while #q > 0 and found == false do
        local curr = q[1]
        deli(q, 1)
        log(" I ran")
        local row = curr.row
        local col = curr.col
        local neighbors = get_neighbours(row, col, grid)
        visited[row][col] = true
        foreach(neighbors, function(neighbor)
            local r, c = neighbor.row, neighbor.col
            if visited[r][c] == true then return end
            if grid[r][c].type == "#" then return end -- is wall
            prev[r][c] = {row=row, col=col}
            -- visited[r][c] = true
            if c == end_col and r == end_row then
                found = true
            end
            add(q, neighbor)
        end)
    end
    return prev
end

function solve(srow, scol, erow, ecol, grid)
  local res = find_path(srow, scol, erow, ecol, grid)
  local path = path_from_result(srow, scol, erow, ecol, res)
  if #path > 0 then
    foreach(path, function(t)
        add_debug_gfx(myrect((t.col - 1) * 8, (t.row - 1) * 8))
    end)
  end
end

function path_from_result(srow, scol, erow, ecol, prev)
    local path = {}
    -- log("here"..#prev)
    test = prev
    current = prev[erow][ecol]
    
    while current != "empty" and current != nil do
        add(path, current)
        local next = prev[current.row][current.col]
        current = next
    end
    log("P#")
    log(#path)
    if #path < 1 then return {} end
    local r = reverse(path)
    if r[1].col == scol and r[1].row == srow then
        return r
    else
        return {}
    end

end

function log(str, override)
    local o = override or false
    printh(str, "log.txt", o)
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