
function create_enemy(row, col)
    local enemy = {}
    enemy.frames = {9,10}
    enemy.f_index = 1
    enemy.tick = 1
    enemy.position = vec2((col) * g.step, (row) * g.step)
    enemy.h = g.step
    enemy.w = g.step
    -- enemy.dir = vec2(-1, 0)
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
    add_listener(player_moved_event, function ()
        enemy.should_recalc = true
    end)



    enemy.upd = function(player)
        if not enemy.target_tile then
            enemy.target_tile = enemy.target_fn(player, g.level)
        end
        animate(enemy)
        enemy.move(player)
    end

    enemy.move = function(player)
        if enemy.should_recalc then
            enemy.should_recalc = false
            enemy.target_tile = nil
        end
        if enemy.target_tile == nil then
            local target = enemy.target_fn(player, g.level)
            enemy.target_tile = target
        end

        if enemy.movement_coroutine then
            if(costatus(enemy.movement_coroutine) != "dead") then
                assert(coresume(enemy.movement_coroutine))
                return
            else
                enemy.movement_coroutine = nil
                local tile_position = {}
                tile_position.x = flr(enemy.position.x / g.step)
                tile_position.y = flr(enemy.position.y / g.step)
                enemy.prev_tile = tile_position
                enemy.target_tile = nil

            end
        else
            local tt = enemy.target_tile
            local tile_position = {}
            tile_position.x = flr(enemy.position.x / g.step)
            tile_position.y = flr(enemy.position.y / g.step)
            -- logt(enemy.position, "EP")
            -- logt(tile_position, "TP")
            local neighbors = g.neighbor_map[tile_position.y][tile_position.x]
            local closest_index = 1
            local current_best = 999 -- random big number
            if enemy.prev_tile == nil then
                log("No prev tile")
            else
                log("Has prev tile")
                logtr(enemy.prev_tile)
            end
            log("L is "..#neighbors)
            local new_neighbors = filter(neighbors, function(n)
                if not enemy.prev_tile then
                    return true
                end
                if n.col == enemy.prev_tile.x and n.row == enemy.prev_tile.y then
                    return false
                else
                    return true
                end
            end)
            log("New L is "..#new_neighbors)
            logtr(tt, "Target tile is ")
            foreachi(new_neighbors, function(n, i)
                local dist = distance_to(vec2(n.col, n.row), vec2(tt.col, tt.row))
                if dist < current_best then
                    current_best = dist
                    closest_index = i
                end
            end)
            enemy.movement_coroutine = cocreate(function()
                local target = neighbors[closest_index]
                local frames = 4
                for i=1, frames do
                    local new_x = lerp(enemy.position.x, target.col * g.step, i / frames ) 
                    local new_y = lerp(enemy.position.y, target.row * g.step, i / frames ) 
                    enemy.position.x = new_x
                    enemy.position.y = new_y
                    yield()
                end
            end)
        end
        
    end
    return enemy
end

function compute_ahead_of_player(player, grid)
    local x, y = player.position.x, player.position.y
    local tile_x = flr(x / g.step)
    local tile_y = flr(y / g.step) 
    local tile_vec = vec2(tile_x, tile_y) + (player.facing * 3)
    local result = tile_vec
    local new_player = {}
    new_player.position = result * g.step

    return new_player
end

function compute_target_player(player, grid)
    return {row=player.position.y / 4, col = player.position.x / 4}
end

function noop(_player)
    local t = {position = vec2(16,16)}
    return t
end