
local tile_metatable = {
    draw = function(tile)
        local x, y, s = tile.x, tile.y, tile.s
        spr(s, x, y)
    end,
    get_vec = function(tile)
        return vec2(tile.x, tile.y)
    end,
    get_grid_pos_vec = function(tile)
        return vec2(flr(tile.x / g.step), flr(tile.y / g.step))
    end
}

tile_metatable.__index = tile_metatable


function tile(x, y, type, spr, has_coin)
    local t = {x = x, y=y, type=type, h = g.step, w = g.step, s = spr, has_coin = has_coin}
    setmetatable(t, tile_metatable)
    return t
end