
player = {}
player.frames = {1,2}
player.f_index = 1
player.tick = 1
player.position = {x=1 * g.step, y= 1 * g.step}
player.h = g.step
player.w = g.step
player.dir = {x=0, y=0}
player.next_dir = {x=0,y=0}
player.speed = 1
player.draw = function()
 spr(player.frames[player.f_index], player.position.x, player.position.y)
end

-- ty nerdy teachers!
function rect_rect_collision( player, object )
  if object.type == 'o' then
      return
  end
  local r1 = {}
  r1.x, r1.y = player.position.x, player.position.y
  r1.w, r1.h = player.w, player.h

  local r2 = object

  return r1.x < r2.x+r2.w and
         r1.x+r1.w > r2.x and
         r1.y < r2.y+r2.h and
         r1.y+r1.h > r2.y
end

local move = function()
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
    player.dir.x = ndir.x
  end

  if(ndir.y != 0) then
    player.dir.y = ndir.y
  end

  
--   if(maybe.position.x < 0) then
--   	maybe.position.x = 0
--   end
--   if(maybe.position.x > 128) then
--   	maybe.position.x = 128 - g.step
--   end
  
  local old_position = player.position

  local maybe = {position={}}
  maybe.position.x = player.position.x + player.speed * player.dir.x
  maybe.position.y = player.position.y + player.speed * player.dir.y

  player.position = maybe.position
  local collision = false
  for_each_grid()
  for_each_grid(level, function(tile)
    if rect_rect_collision(player, tile) then
        collision = true
    end
  end)

  if collision then
    player.position = old_position
    player.dir = {x=0, y=0}
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
