
player = {}
player.frames = {1,2}
player.f_index = 1
player.tick = 1
player.position = vec2(8, 8)
player.h = g.step
player.w = g.step
player.dir = vec2(1, 0)
player.flipped = false
player.next_dir = vec2(1, 0)
player.speed = 1
player.draw = function()
  local x = player.position.x
  if player.flipped then
    x -= 8 - g.step
  end
  spr(player.frames[player.f_index], x, player.position.y, 1, 1, player.flipped)
end

-- player.position.x += 1


player.maybe_flip = function()
    if(player.dir.x < 0) then
        player.flipped = true
    elseif (player.dir.x > 0) then
        player.flipped = false
    end
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
    emit_recalc()
    player.dir = player.next_dir
    player.position += player.dir

    local collision = check_map_collision(player)
    if collision then
        player.position = old_position
        player.dir = old_dir
    else
        return
    end
  end
  player.position += player.dir
  local collision = check_map_collision(player)
  if collision then
    player.position = old_position
    player.dir = vec2()
  end
  player.maybe_flip()
end

player.upd = function()
  animate(player)
  move()
end
