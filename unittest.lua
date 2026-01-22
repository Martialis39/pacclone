
local unit_tests = {}

function unit_test_upd()
end

function unit_test_init()
    log("start", true)
    describe("1 + 1", {
        function()
            return 1 + 1 == 2
        end,
    })
    describe("solve", {
        function()
            local level_str = "OOO\nOOO\nOOO"
            local level = create_level(level_str)
            local res = solve(1, 1, 1, 3, level)
            return res[1].row == 1 and res[1].col == 1
        end,
        function()
            local level_str = "O##\nO##\nOOO"
            local level = create_level(level_str)
            local res = solve(1, 1, 3, 3, level)
            return res[1].row == 1 and res[1].col == 1 and #res == 5 and res[3].row == 3 and res[3].col == 1
        end,
        function()
            local level_str = "O##\nO##\nO##"
            local l = create_level(level_str)
            local res = solve(1, 1, 3, 3, l)
            return #res == 0
        end,
    })
    describe("enemy", {
        function()
            local e = create_enemy(2, 2)

            -- local res = solve(1, 1, 1, 3, level)
            return e.position.x == 8 and e.position.y == 8
        end,
        function()
            local e = create_enemy(2, 2)
            e.target_tile = {row = 2, col = 3}
            e.path = {{row=2, col=3},{row=2, col=4}}
            e.move_towards_tile()
            e.move_towards_tile()
            e.move_towards_tile()
            e.move_towards_tile()

            e.move_towards_tile()
            e.move_towards_tile()
            e.move_towards_tile()
            e.move_towards_tile()

            e.move_towards_tile()
            -- assert(e.position.x == 8 + 8 + 1)


            -- e.move_towards_tile()
            -- local res = solve(1, 1, 1, 3, level)
            logt(e.target_tile, "target tile")
            logt(e.position, "pos")
            return e.position.x == 17
        end,
        function()
            local e = create_enemy(1, 1)
            player.position = vec2(3*8, 1*8)
            local level_str = "OOOO\nOOOO\nOOOO\nOOOO"
            level = create_level(level_str)
            for i=0, 8 do
                e.upd(player)
            end
            local mid_result = e.position.x == 8


            for i=0, 8 * 4 do
                e.upd(player)
            end

            return e.path == nil and e.position.x == player.position.x and mid_result
        end,
        function()
            local e = create_enemy(1, 1)
            player.position = vec2(3*8, 1*8)
            local level_str = "O#OO\nO#OO\nO#OO\nO#OO"
            level = create_level(level_str)
            for i=0, 8 do
                e.upd(player)
            end

            return e.path == nil
        end,
    })
end

function unit_test_draw()
    cls()

    foreach(unit_tests, function(res)
        local header = res[1]
        print(header)
        for i=2, #res do
            print("     result: "..tostr(res[i]))
        end
    end)
end

function describe(txt, test_fns)
    local block = {txt}
    print(txt)
    foreach(test_fns, function(test_fn)
        test_fn()
    end)
    -- foreach(test_fns, function(test_fn)
    --     add(block, test_fn())
    -- end)
    -- add(unit_tests, block)
end


function expect(label, test_fn)
    local res = test_fn()
    local col = 8 
    if res then 
        col = 11
    end
    print("  "..label, col)
    print("----", 7)


end

-- function it(txt, test_fn)
--     local block = {txt, fn()}
--     foreach(test_fns, function(test_fn)
--         add(block, test_fn())
--     end)
--     add(unit_tests, block)
-- end