
function vec2(x, y)
    local x = x or 0
    local y = y or 0
    return {x=x, y=y}
end

function add_vec2(v1, v2)
    local result = vec2()
    result.x = v1.x + v2.x
    result.y = v1.y + v2.y
    return result
end

function mult_vec2(v1, mult)
    local result = vec2(v1.x, v1.y)
    result.x = result.x * mult
    result.y = result.y * mult
    return result
end