function create_enemy(row, col)
    local enemy = {}
    enemy.frames = { 9, 10 }
    enemy.f_index = 1
    enemy.tick = 1
    enemy.position = vec2(col * g.step, row * g.step)
    enemy.h = g.step
    enemy.w = g.step
    enemy.flipped = true
    enemy.speed = 1
    enemy.target_tile = nil
    enemy.prev_tile = nil
    enemy.target_fn = nil
    enemy.movement_coroutine = nil
    enemy.draw = function()
        local x = enemy.position.x
        if enemy.flipped then
            x -= 8 - g.step
        end
        spr(enemy.frames[enemy.f_index], x, enemy.position.y, 1, 1, enemy.flipped)
    end
    enemy.path = nil

    enemy.mode = "chase"
    enemy.scatter_target = nil

    enemy.upd = function(player)
        animate(enemy)
        if enemy.mode == "chase" then
            local target = enemy.target_fn(player, g.level)
            enemy.target_tile = target
        elseif enemy.mode == "scatter" then
            enemy.target_tile = enemy.scatter_target
        end
        enemy.move(player)
    end

    enemy.move = function(player)
        if enemy.movement_coroutine then
            if (costatus(enemy.movement_coroutine) != "dead") then
                assert(coresume(enemy.movement_coroutine))
                return
            end
        end
        local tt = enemy.target_tile
        local tile_position = (enemy.position / g.step):floor() -- lua magic passes self to floor
        local neighbors = g.neighbor_map[tile_position.y][tile_position.x]
        local new_neighbors = filter(
            neighbors, function(n)
                return filter_out_prev(enemy, n)
            end
        )
        local closest_index = 1

        if #neighbors != 1 then
            -- find closest
            local current_best = 999 -- random big number
            foreachi(
                new_neighbors, function(n, i)
                    local dist = distance_to(vec2(n.col, n.row), vec2(tt.col, tt.row))
                    if dist < current_best then
                        current_best = dist
                        closest_index = i
                    end
                end
            )
        end
        enemy.movement_coroutine = cocreate(function()
            local target = new_neighbors[closest_index]
            local frames = 4
            for i = 1, frames do
                local new_x = lerp(enemy.position.x, target.col * g.step, i / frames)
                local new_y = lerp(enemy.position.y, target.row * g.step, i / frames)
                enemy.position.x = new_x
                enemy.position.y = new_y
                yield()
            end
        end)
        enemy.prev_tile = tile_position
    end
    return enemy
end

function compute_ahead_of_player(player, grid)
    local curr = (player.position / g.step):floor()
    local target = curr + (player.facing * 3)
    local new_player = {}
    new_player.position = target * g.step
    return new_player
end

function compute_target_player(player, grid)
    return { row = flr(player.position.y / 4), col = flr(player.position.x / 4) }
end

function noop(_player)
    local t = { position = vec2(16, 16) }
    return t
end

function filter_out_prev(enemy, n)
    if not enemy.prev_tile then
        return true
    end
    if n.col == enemy.prev_tile.x and n.row == enemy.prev_tile.y then
        return false
    else
        return true
    end
end