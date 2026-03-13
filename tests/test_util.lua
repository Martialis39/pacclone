-- tests for util.lua helpers
register_test("lerp_test", function()
    local r = lerp(0, 10, 0.5)
    assert_eq(5, r, "lerp")
    return true
end)

register_test("reverse_test", function()
    local t = {1,2,3,4}
    local r = reverse(t)
    -- reverse stores values in mirrored indices
    assert_eq(4, r[1], "reverse idx1")
    assert_eq(1, r[4], "reverse idx4")
    return true
end)

register_test("filter_tests", function()
    local direct = filter({1,2,3,4}, function(x) return x%2==0 end)
    assert_eq(2, direct[1], "filter direct first")
    assert_eq(4, direct[2], "filter direct second")

    local curried = filter(function(x) return x>2 end)
    local applied = curried({1,2,3,4})
    assert_eq(3, applied[1], "filter curried first")
    assert_eq(4, applied[2], "filter curried second")
    return true
end)

register_test("rect_collision", function()
    local r1 = {x=0,y=0,w=4,h=4}
    local r2 = {x=3,y=3,w=4,h=4}
    local r3 = {x=10,y=10,w=1,h=1}
    assert_true(rect_rect_collision(r1, r2), "rect collides")
    assert_true(not rect_rect_collision(r1, r3), "rect not collides")
    return true
end)
