
local tile_to_world = function(a)
    local res = vec2(a.col * g.step, a.row * g.step)
    return res
end

function create_enemy(x, y)
    local enemy = {}
    enemy.frames = {9,10}
    enemy.f_index = 1
    enemy.tick = 1
    enemy.position = vec2(10 * g.step, 8)
    enemy.h = g.step
    enemy.w = g.step
    enemy.dir = vec2(-1, 0)
    enemy.flipped = true
    enemy.next_dir = vec2(enemy.dir.x, enemy.dir.y)
    enemy.speed = 1
    enemy.target_tile = nil
    enemy.draw = function()
        spr(enemy.frames[enemy.f_index], enemy.position.x, enemy.position.y, 1, 1, enemy.flipped)
    end
    enemy.path = nil

    enemy.move_towards_tile = function()
        local t = vec2(enemy.target_tile.col, enemy.target_tile.row)
        local enemy_tile_position = vec2(flr(enemy.position.x / g.step), flr(enemy.position.y / g.step))

        if t == enemy_tile_position then
            deli(enemy.path, 1)
            if #enemy.path > 0 then
                enemy.target_tile = enemy.path[1]
            else
                enemy.path = nil
            end
        end


        local dir = t - enemy_tile_position
        enemy.position += dir
    end

    enemy.upd = function(player)
        animate(enemy)
        enemy.move(player)
    end

    enemy.move = function(player)
        if enemy.path then
            enemy.move_towards_tile()
            return
        end
        if enemy.path == nil then
            local sx, sy = flr(enemy.position.x / g.step), flr(enemy.position.y / g.step)
            local player_tile_pos = vec2(flr(player.position.x / g.step), flr(player.position.y / g.step))
            local p = solve(sy + 1, sx + 1, player_tile_pos.y + 1, player_tile_pos.x + 1, level)
            if #p < 1 then
                return
            end
            enemy.path = p
            deli(enemy.path, 1)
            enemy.target_tile = enemy.path[1]
        end
    end
    return enemy
end