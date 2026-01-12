

local level_1 = [[
################
#oooooooooooooo#
#o####o#o#####o#
#o####o#o#####o#
#o####o#o#####o#
#oooooooooooooo#
#o############o#
#o############o#
#oooooooooooooo#
#o############o#
#o############o#
#oooooooooooooo#
#o############o#
#o############o#
#oooooooooooooo#
################
]]

local wall = "#"
local open = "o"
local grass = "g"
local grass_tile = 19

local create_tile = function(x, y, type)
    return {x=x, y=y, type=type, h=g.step, w=g.step}
end

local create_level = function()
    local lines = split(level_1, "\n")
    local m = {}
    local i = 1
    local x = 0
    local y = 0
    foreach(lines, function(l)
        m[i] = {}
        local row = split(l, "")
        foreach(row, function (letter)
            if letter == open then

                if rnd() > 0.85 then
                    letter = grass
                end
            end
            local t = create_tile(x, y, letter)
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
            local x = tile.x
            local y = tile.y
            local letter = tile.type
            local s = 0
            if(letter == wall) then
                s = 17
            end

            if(letter == open) then
                s = 16
            end

            if(letter == grass) then
                s = grass_tile
            end
            spr(s, x, y)
        end)
    end)
end