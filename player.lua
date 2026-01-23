
player = {}
player.frames = {1,2}
player.f_index = 1
player.tick = 1
player.position = vec2(16, 16)
player.h = g.step
player.w = g.step
player.dir = vec2(1, 0)
player.flipped = false
player.next_dir = vec2(1, 0)
player.speed = 1
player.draw = function()
 spr(player.frames[player.f_index], player.position.x, player.position.y, 1, 1, player.flipped)
end

player.position.x += 1

player.maybe_flip = function()
    if(player.dir.x < 0) then
        player.flipped = true
    elseif (player.dir.x > 0) then
        player.flipped = false
    end
end

player.check_tile_collision = function(object)
    if object.type == "o" or object.type == "g" or object.type == "g2" then
        return false
    end
    local r1 = {}
    r1.x, r1.y = player.position.x, player.position.y
    r1.w, r1.h = player.w, player.h
    return rect_rect_collision(r1, object)

end

player.check_map_collision = function()
  local collision = false
  for_each_grid(g.level, function(tile)
      if player.check_tile_collision(tile) then
          collision = true
      end
  end, function() return collision end)
  return collision
end

-- ty nerdy teachers!
function rect_rect_collision( r1, r2 )
  return r1.x < r2.x+r2.w and
         r1.x+r1.w > r2.x and
         r1.y < r2.y+r2.h and
         r1.y+r1.h > r2.y
end

local move = function()
  local old_position = player.position
  local ndir = vec2()
  if(btnp(0)) then
    ndir = vec2(-1, 0)
  end
  if(btnp(1)) then
    ndir = vec2(1, 0)
  end
  
  if(btnp(2)) then
    ndir = vec2(0, -1)
  end
  if(btnp(3)) then
    ndir = vec2(0, 1)
  end

  if ndir.x != 0 or ndir.y != 0 then
    player.next_dir = ndir
  end

  local old_dir = player.dir
  local on_tile = player.position.x % g.step == 0 and player.position.y % g.step == 0
  if on_tile then
    player.dir = player.next_dir
    player.position += player.dir

    local collision = player.check_map_collision()
    if collision then
        player.position = old_position
        player.dir = old_dir
    else
        return
    end
  end
  player.position += player.dir
  local collision = player.check_map_collision()
  if collision then
    player.position = old_position
    player.dir = vec2()
  end
  player.maybe_flip()

--   if player.next_dir.x !=0 or player.next_dir.y !=0 then
--   -- try to move to new direction

--     local delta_v = mult_vec2(player.next_dir, player.speed)
--     local maybe = add_vec2(player.position, delta_v)

--     player.position = maybe
--     local collision = player.check_map_collision()

--     if collision == false then
--         player.dir.x= player.next_dir.x
--         player.dir.y= player.next_dir.y
--         player.next_dir = vec2()
--         if(player.dir.x < 0) then
--             player.flipped = true
--         elseif (player.dir.x > 0) then
--             player.flipped = false
--         end
--         return -- no need to check further
--     else
--         player.position = old_position
--     end
--   end

  -- try move to old direction
--   local delta_v = mult_vec2(player.dir, player.speed)
--   local maybe = add_vec2(player.position, delta_v)
--   player.position = maybe

--   local collision = player.check_map_collision()
--   if collision then
--       player.position = old_position
--       player.dir = vec2()
--       player.next_dir = vec2()
--   else
--       if(player.dir.x < 0) then
--           player.flipped = true
--       elseif (player.dir.x > 0) then
--           player.flipped = false
--       end
--   end
end

local animate = function()
  player.tick += 1
  if player.tick > 4 then
    player.tick = 0
    player.f_index += 1
    if player.f_index > #player.frames then
      player.f_index = 1
    end 
  end
end

player.upd = function()
  animate(player)
  move()
end
