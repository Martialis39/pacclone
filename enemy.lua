
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
    enemy.position = vec2((col) * g.step, (row) * g.step)
    enemy.h = g.step
    enemy.w = g.step
    -- enemy.dir = vec2(-1, 0)
    enemy.flipped = true
    enemy.speed = 1
    enemy.target_tile = nil
    enemy.draw = function()
        if enemy.path then
            debug_path(enemy.path)
        end
        add_debug_gfx(function ()
            myrect(enemy.position.x, enemy.position.y, 8, 8)
        end)
        spr(enemy.frames[enemy.f_index], enemy.position.x, enemy.position.y, 1, 1, enemy.flipped)
    end
    enemy.path = nil

    enemy.move_towards_tile = function()
        if not enemy.target_tile then
            return
        end
        local tp = {row=flr(enemy.position.y / g.step), col = flr(enemy.position.x / g.step)}
        local tt = enemy.target_tile

        -- local t_world_x = ( tt.col - 1 ) * g.step
        -- local t_world_y = ( tt.row - 1 ) * g.step
        
        -- log("Tile w pos")
        -- log(t_world_x)
        -- log(t_world_y)
        -- log("Pos")
        -- logt(enemy.position)

        if enemy.position.x == (tt.col) * g.step and enemy.position.y == ( tt.row) * g.step then
        -- if tt.row == tp.row and tt.col == tp.col then
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
        local dx = 0
        local dy = 0
        if enemy.position.y < (tt.row)* g.step then
            dy = 1
        end
        if enemy.position.y > (tt.row) * g.step then
            dy = -1
        end
        if enemy.position.x < (tt.col) * g.step then
            dx = 1
        end
        if enemy.position.x > (tt.col) * g.step then
            dx = -1
        end


        local dir = vec2(dx, dy)
        -- log("Target")
        -- logt(tp)
        -- log("TP")
        -- logt(tt)
        -- log("Dir")
        -- logt(dir)
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
            enemy.move_towards_tile()
        end
    end
    return enemy
end