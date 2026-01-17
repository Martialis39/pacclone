
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

function find_path(srow, scol, erow, ecol, grid)
    local visited = create_grid(#grid)
    local prev = create_grid(#grid)
    local found = false
    local q = {}
    add(q, {col=scol, row = srow})
    printh('here', "log.txt", true)
    -- printh(#q, "log.txt")
    while #q > 0 and found == false do
        local curr = q[1]
        deli(q, 1)
        local row = curr.row
        local col = curr.col
        local ns = get_neighbours(row, col, grid)
        visited[row][col] = true
        foreach(ns, function(neighbor)
            if found then return end
            local r, c = neighbor.row, neighbor.col
            printh(r..":"..c, "log.txt")
            if visited[r][c] == true then return end
            if grid[r][c].type == "#" then return end -- is wall
            prev[row][col] = {row = neighbor.row, col=neighbor.col}
            if c == ecol and r == erow then
                found = true
                printh("Found it!", "log.txt")
            else
                add(q, neighbor)
            end
        end)
    end
    return prev
end

function solve(srow, scol, erow, ecol, grid)
  local res = find_path(srow, scol, erow, ecol, grid)
  return path_from_result(srow, scol, erow, ecol, res)
end

function path_from_result(srow, scol, erow, ecol, prev)
    local path = {}
    local current = prev[srow][scol]
    while current != "empty" do
        printh("it!", "log.txt")
        add(path, current)
        local next = prev[current.row][current.col]
        current = next
    end
    add(path, {row=erow, col=ecol})

    printh(#path, "log.txt")
    return path
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
