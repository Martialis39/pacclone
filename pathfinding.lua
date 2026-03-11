
function find_first_open(x, y, grid)
    if x > g.level_size then x = g.level_size end
    if y > g.level_size then y = g.level_size end

    if x < 1 then x = 1 end
    if y < 1 then y = 1 end
    if grid[y][x].type == open then
        return vec2(x, y)
    end
    local visited = {}
    for i=1, #grid do
        visited[i] = {}
    end
    local q = {vec2(x, y)}
    while #q > 0 do
        local curr = q[1]
        local curr_y, curr_x = curr.y, curr.x
        deli(q, 1)
        visited[curr_y][curr_x] = true
        local neighbors = g.neighbor_map[curr_y][curr_x] or {}
        foreach(neighbors, function(n)
            local neighbor_y, neighbor_x = n.row, n.col
            if visited[neighbor_y][neighbor_x] then
                return
            end
            if grid[neighbor_y][neighbor_x].type == open then
                return vec2(neighbor_x, neighbor_y)
            else
                add(q, vec2(neighbor_x, neighbor_y))
            end
            
        end)
    end
    return nil
end

-- function bfs(start_row, start_col, end_row, end_col, grid)
--     local visited = {}
--     local prev = {}
--     for i=1, #grid do
--         visited[i] = {}
--         prev[i] = {}
--     end
--     local q = {{col=start_col, row = start_row}}
--     local i = 0
--     while #q > 0 do
--         local curr = q[1]
--         deli(q, 1)
--         local row,col = curr.row, curr.col
--         if col == end_col and row == end_row then
--             break
--         end
--         visited[row][col] = true

--         local neighbors = g.neighbor_map[row][col] or {}

--         foreach(neighbors, function(neighbor)
--             local r, c = neighbor.row, neighbor.col
--             if visited[r][c] == true or grid[r][c].type == "#" then
--                 return 
--             end

--             prev[r][c] = {row=row, col=col}
--             add(q, neighbor)
--         end)
--     end
--     return prev
-- end