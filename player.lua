
player = {}
player.frames = {1,2}
player.f_index = 1
player.tick = 1
player.position = {x=1 * g.step, y= 1 * g.step}
player.h = g.step
player.w = g.step
player.dir = {x=1, y=0}
player.next_dir = {x=0,y=0}
player.speed = 1
player.draw = function()
 spr(player.frames[player.f_index], player.position.x, player.position.y)
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

-- ty nerdy teachers!
function rect_rect_collision( r1, r2 )
  return r1.x < r2.x+r2.w and
         r1.x+r1.w > r2.x and
         r1.y < r2.y+r2.h and
         r1.y+r1.h > r2.y
end

local move = function()
  local old_position = player.position
  local ndir = {x=0, y=0}
  if(btnp(0)) then
    ndir.x = -1
  end
  if(btnp(1)) then
    ndir.x = 1
  end
  
  if(btnp(2)) then
    ndir.y = -1
  end
  if(btnp(3)) then
    ndir.y = 1
  end

  if(ndir.x != 0) then
    player.next_dir.x = ndir.x
  end

  if(ndir.y != 0) then
    player.next_dir.y = ndir.y
  end

  if player.next_dir.x !=0 or player.next_dir.y !=0 then
  -- try to move to new direction
    local maybe = {x=0, y=0}
    maybe.x = player.position.x + player.speed * player.next_dir.x
    maybe.y = player.position.y + player.speed * player.next_dir.y

    player.position = maybe
    local collision = false
    local collision_tile = nil
    for_each_grid(level, function(tile)
        if player.check_tile_collision(tile) then
            collision = true
            collision_tile = tile
        end
    -- end, collision)
    end, function() return collision end)

    if collision == false then
        player.dir.x= player.next_dir.x
        player.dir.y= player.next_dir.y
        player.next_dir = {x=0, y=0}
        return -- no need to check further
    else
        add_debug_gfx(function()
            rect(collision_tile.x, collision_tile.y, collision_tile.x + 8, collision_tile.y + 8, 9)
        end)
        player.position = old_position
    end
  end

  -- try move to old direction
  local maybe = {x=0, y=0}
  maybe.x = player.position.x + player.speed * player.dir.x
  maybe.y = player.position.y + player.speed * player.dir.y
  
  player.position = maybe
  local collision = false
  for_each_grid(level, function(tile)
      if player.check_tile_collision(tile) then
          collision = true
      end
  end, function() return collision end)
  if collision then
      player.position = old_position
  end
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
  animate()
  move()
end
