local menu_g = {}
menu_g.selected = 1

function menu_init()
    local base = 60
    local start_btn = {x= 12, y=base, txt="start game", selected=true}
    local how_btn = {x= 12, y=base + 8, txt="how to play", selected=false}
    menu_g.buttons = {}
    add(menu_g.buttons, start_btn)
    add(menu_g.buttons, how_btn)
end

function menu_upd()
    local selected = menu_g.selected
    -- if btnp(1) then
    --     selected -= 1
    --     if selected < 1 then selected = #menu_g.buttons end
    -- end
    if btnp(1) then
        selected += 1
        if selected > #menu_g.buttons then selected = 1 end
    end

    menu_g.selected = selected
end

function menu_draw()
    cls()
    foreachi(menu_g.buttons, function(b, i)
        local bx, by, btxt, selected = b.x,b.y,b.txt
        cursor(bx, by)
        print(btxt)
        if i == menu_g.selected then
            rectfill(bx - 8, by, bx - 4, by + 4)
        end
    end)
end
