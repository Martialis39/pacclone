-- tests for enemy helpers
register_test("compute_target_player", function()
    with_g({step=4}, function()
        local player = { position = vec2(8, 12) }
        local t = compute_target_player(player)
        assert_eq(3, t.row, "compute_target row")
        assert_eq(2, t.col, "compute_target col")
    end)
    return true
end)

register_test("compute_ahead_of_player_stub_find", function()
    -- stub find_first_open to return vec2(3,2)
    local old_ff = find_first_open
    find_first_open = function(_y, _x, _grid) return vec2(3,2) end
    with_g({step=4, level_size=5}, function()
        local player = { position = vec2(8,8), facing = vec2(1,0) }
        local newp = compute_ahead_of_player(player, {})
        assert_eq(12, newp.position.x, "compute_ahead pos x")
        assert_eq(8, newp.position.y, "compute_ahead pos y")
    end)
    find_first_open = old_ff
    return true
end)

register_test("noop_returns_vec", function()
    local t = noop(nil)
    assert_eq(16, t.position.x, "noop x")
    assert_eq(16, t.position.y, "noop y")
    return true
end)
