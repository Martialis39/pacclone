-- tests for vec.lua
register_test("vec_floor", function()
    local v = vec2(1.7, 2.9)
    local f = floor_vec(v)
    assert_eq({x=1, y=2}, {x=f.x, y=f.y}, "vec_floor")
    return true
end)

register_test("distance_to", function()
    local a = vec2(1,1)
    local b = vec2(3,2)
    local d = distance_to(a,b)
    assert_eq(3, d, "distance_to")
    return true
end)
