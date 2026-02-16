
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
    enemy.target_fn = nil
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

    enemy.move_towards_tile = function()
        if not enemy.target_tile then
            return
        end
        local tt = enemy.target_tile
        local moves = {}
        if enemy.position.y < (tt.row)* g.step then
            add(moves, vec2(0, 0.5))
        end
        if enemy.position.y > (tt.row) * g.step then
            add(moves, vec2(0, -0.5))
        end
        if enemy.position.x < (tt.col) * g.step then
            add(moves, vec2(0.5, 0))
        end
        if enemy.position.x > (tt.col) * g.step then
            add(moves, vec2(-0.5, 0))
        end

        local old_position = enemy.position
        for i=1, #moves do
            local move = moves[i]
            enemy.position += move
            local collision = check_map_collision(enemy)
            if collision then
                enemy.position = old_position
            else
                break
            end
        end

        -- check if reached target
        if enemy.position.x == (tt.col) * g.step and enemy.position.y == ( tt.row) * g.step then
            enemy.target_tile = nil
            deli(enemy.path, 1)
            if #enemy.path > 0 then
                enemy.target_tile = enemy.path[1]
            else
                enemy.path = nil
            end
        end
    end

    enemy.upd = function(player)
        animate(enemy)
        enemy.move(player)
    end

    enemy.move = function(player)
        if enemy.should_recalc then
            enemy.should_recalc = false
            enemy.path = nil
        end
        if enemy.path == nil then
            local target = enemy.target_fn(player, g.level)
            local p = solve_for_entities(enemy, target)
            if #p < 1 then
                return
            end
            deli(p, 1) -- same as enemy current position
            enemy.path = p
            enemy.target_tile = enemy.path[1]
        end
        enemy.move_towards_tile()
    end
    return enemy
end

function compute_ahead_of_player(player, grid)
    local x, y = player.position.x, player.position.y
    local tile_x = flr(x / g.step)
    local tile_y = flr(y / g.step) 
    local tile_vec = vec2(tile_x, tile_y) + (player.facing * 3)
    logt(tile_vec)
    logt(player.dir, "Dir : ")
    local result = tile_vec
    -- local limit = 3
    -- local i = 0
    -- while i < limit  do
    --     local t = tile_vec + player.dir * (3 - i)
    --     if isInBounds(t.y, t.x) then
    --         result = t
    --         break

    --     end
    --     limit += 1
        
    -- end
    local new_player = {}
    new_player.position = result * g.step

    return new_player
end

function compute_target_player(player, grid)
    return player
end

function noop(_player)
    local t = {position = vec2(16,16)}
    return t
end