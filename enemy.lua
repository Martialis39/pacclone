
local tile_to_world = function(a)
    local res = vec2(a.col * g.step, a.row * g.step)
    return res
end

function create_enemy(row, col)
    local enemy = {}
    enemy.frames = {9,10}
    enemy.f_index = 1
    enemy.tick = 1
    enemy.tile_pos = {row=row, col=col}
    enemy.position = vec2((col - 1) * g.step, (row - 1) * g.step)
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
        if not enemy.target_tile then
            return
        end
        local tp = {row=flr(enemy.position.y / g.step) + 1, col = flr(enemy.position.x / g.step) + 1}
        local tt = enemy.target_tile

        if tt.row == tp.row and tt.col == tp.col then
            enemy.target_tile = nil
            deli(enemy.path, 1)
            if #enemy.path > 0 then
                enemy.target_tile = enemy.path[1]
                tt = enemy.target_tile
            else
                enemy.path = nil
                return
            end
        end

        local dir = vec2(tt.col - tp.col, tt.row - tp.row)
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
            local p = solve_for_entities(enemy, player)
            if #p < 1 then
                return
            end
            enemy.path = p
            deli(enemy.path, 1) -- the 1st is the current position
            enemy.target_tile = enemy.path[1]
        end
    end
    return enemy
end