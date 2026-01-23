

local level_1 = {
"################",
"#oooooooooooooo#",
"#o####o#o#####o#",
"#o####o#o#####o#",
"#o####o#o#####o#",
"#oooooooooooooo#",
"#o############o#",
"#o############o#",
"#oooooooooooooo#",
"#o############o#",
"#o############o#",
"#oooooooooooooo#",
"#o############o#",
"#o############o#",
"#oooooooooooooo#",
"################",
}

local wall = "#"
local open = "o"
local grass = "g"
local grass2 = "g2"
local grass_tiles = {19, 22}
local wall_s = 17
local open_s = 16

local create_tile = function(x, y, type, spr)
    return {x=x, y=y, type=type, h=g.step, w=g.step, s=spr}
end

local create_level = function(l)
    local level = l or level_1
    local m = {}
    local i = 1
    local x = 0
    local y = 0
    foreach(level, function(l)
        m[i] = {}
        local row = split(l, "")
        foreach(row, function (letter)
            local sprite = open_s
            if letter == wall then
                sprite = wall_s
            end
            if letter == open then
                if rnd() > 0.85 then
                    if rnd() <= 0.5 then
                        sprite = grass_tiles[1]
                    else 
                        sprite = grass_tiles[2]
                    end
                end
            end
            local t = create_tile(x, y, letter, sprite)
            x = x + g.step
            add(m[i], t)
        end)

        x = 0
        y = y + g.step
        i = i + 1
    end)

    return m
end

local draw_level = function(level)
    foreach(level, function(line)
        foreach(line, function(tile)
            local x, y, s = tile.x, tile.y, tile.s
            spr(s, x, y)
        end)
    end)
end