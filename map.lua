local level_1 = {
    "####################",
    "#oooooooooooooooooo#",
    "#o###o####o###o###o#",
    "#o###o####o###o###o#",
    "#o###o####x###o###o#",
    "#o###o####o###o###o#",
    "#oooooooooooooooooo#",
    "#o################o#",
    "#o################o#",
    "#oooooooooooooooooo#",
    "#o################o#",
    "#o################o#",
    "#oooooooooooooooooo#",
    "#o################o#",
    "#o################o#",
    "#o################o#",
    "#o################o#",
    "#o################o#",
    "#oooooooooooooooook#",
    "####################"
}


scatter_target_4 = "k"
enemy_tile = "x"
local wall = "#"
open = "o"
local grass = "g"
local grass2 = "g2"
local grass_tiles = { 19, 22 }
local wall_s = 17
local open_s = 16

local create_tile = function(x, y, type, spr, has_coin)
    local coin = has_coin or false
    return tile(x,y, type, spr, coin)
end

function determine_sprite(letter)
    local sprite = open_s
    if letter == wall then
        sprite = wall_s
        return sprite
    end
    if letter == open then
        -- sprite = 5
        if rnd() > 0.85 then
            if rnd() <= 0.5 then
                sprite = grass_tiles[1]
            else
                sprite = grass_tiles[2]
            end
        end
    end
    return sprite
end

local create_level = function(lev)
    local level = lev or level_1
    local game_map = {}
    local i = 1
    local x = g.step
    local y = g.step
    foreach(
        level, function(l)
            game_map[i] = {}
            local row = split(l, "")
            foreach(
                row, function(letter)
                    local l = letter
                    local has_coin = true
                    if letter == enemy_tile then
                        add(g.enemies, create_enemy(y / g.step, x / g.step))
                        l = open
                        has_coin = false
                    end
                    if letter == scatter_target_4 then
                        add(g.scatter_targets, {x=x, y=y})
                        l = open
                    end
                    if l != open then
                        has_coin = false
                    end
                    local sprite = determine_sprite(l)
                    local t = create_tile(x, y, l, sprite, has_coin)
                    x = x + g.step
                    add(game_map[i], t)
                end
            )
            x = g.step
            y = y + g.step
            i = i + 1
        end
    )

    return game_map
end

local draw_level = function(level)
    foreach(
        level, function(line)
            foreach(
                line, function(tile)
                    tile:draw()
                end
            )
        end
    )
end

function is_in_bounds(row, col)
    return row > 0 and col > 0 and row < g.level_size + 1 and col < g.level_size + 1
end

local function get_neighbours(y, x, grid)
    local coords = {
        { 0, 1 },
        { 0, -1 },
        { 1, 0 },
        { -1, 0 }
    }

    local result = {}
    foreach(
        coords, function(coord)
            local diff_y, diff_x = coord[1], coord[2]
            local new_y = y + diff_y
            local new_x = x + diff_x
            if is_in_bounds(new_y, new_x) and grid[new_y][new_x].type == open then
                add(result, { y = new_y, x = new_x })
            end
        end
    )

    return result
end

create_neighbor_map = function(level)
    local result = {}
    local i = 1
    for i = 1, g.level_size do
        result[i] = {}
        for j = 1, g.level_size do
            local object = level[i][j]
            if object.type == open then
                local neighbors = get_neighbours(i, j, g.level)
                result[i][j] = neighbors
            else
                result[i][j] = nil
            end
        end
    end
    return result
end