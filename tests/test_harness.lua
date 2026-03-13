-- simple in-cart test harness
TEST_REGISTRY = TEST_REGISTRY or {}
TEST_ORDER = TEST_ORDER or {}
TEST_RESULTS = TEST_RESULTS or nil

function register_test(name, fn)
    TEST_REGISTRY[name] = fn
    add(TEST_ORDER, name)
end

local function pretty(v)
    if type(v) == "table" then
        local s = "{"
        local first = true
        for k, val in pairs(v) do
            if not first then s = s .. ", " end
            s = s .. tostring(k) .. ":" .. tostring(val)
            first = false
        end
        return s .. "}"
    else
        return tostring(v)
    end
end

local function shallow_eq(a, b)
    if type(a) ~= type(b) then return false end
    if type(a) ~= "table" then return a == b end
    -- compare simple tables with numeric or x,y or row,col
    for k, v in pairs(a) do
        if type(v) == "table" then
            -- nested not supported deeply
            if not shallow_eq(v, b[k]) then return false end
        else
            if b[k] ~= v then return false end
        end
    end
    for k, v in pairs(b) do
        if a[k] == nil then return false end
    end
    return true
end

-- test assertions set a failure flag instead of throwing
TEST_CURRENT_FAILED = false
TEST_CURRENT_ERROR = nil

function assert_eq(expected, actual, name)
    local ok = shallow_eq(expected, actual)
    if not ok then
        local msg = "assert_eq failed: " .. (name or "") .. " expected=" .. pretty(expected) .. " got=" .. pretty(actual)
        TEST_CURRENT_FAILED = true
        TEST_CURRENT_ERROR = msg
        printh(msg, "log.txt")
        return false
    end
    return true
end

function assert_true(expr, name)
    if not expr then
        local msg = "assert_true failed: " .. (name or "")
        TEST_CURRENT_FAILED = true
        TEST_CURRENT_ERROR = msg
        printh(msg, "log.txt")
        return false
    end
    return true
end

-- helper to run code with a shallow-mocked `g`
function with_g(overrides, fn)
    local old_g = g
    local new_g = {}
    if old_g then
        for k,v in pairs(old_g) do new_g[k]=v end
    end
    if overrides then
        for k,v in pairs(overrides) do new_g[k]=v end
    end
    g = new_g
    -- call test function directly; assertions set TEST_CURRENT_FAILED instead of throwing
    local res1, res2 = fn()
    g = old_g
    return res1, res2
end

-- step movement coroutines for an enemy-like entity until dead or max frames
function step_coroutines_for(entity, max_frames)
    max_frames = max_frames or 60
    if not entity or not entity.movement_coroutine then return end
    for i=1,max_frames do
        local st = costatus(entity.movement_coroutine)
        if st == "dead" then break end
        coresume(entity.movement_coroutine)
    end
end

function run_test(name)
    local fn = TEST_REGISTRY[name]
    if not fn then
        printh("test not found: "..name, "log.txt")
        return false, "not found"
    end
    -- reset current test failure flag
    TEST_CURRENT_FAILED = false
    TEST_CURRENT_ERROR = nil
    local ok, msg = fn()
    if TEST_CURRENT_FAILED then
        return false, TEST_CURRENT_ERROR
    end
    if ok == false then
        return false, msg or "failed"
    end
    return true
end

function run_tests()
    TESTS_ACTIVE = true
    TEST_RESULTS = {passed=0, failed=0, failures={}}
    for i=1,#TEST_ORDER do
        local name = TEST_ORDER[i]
        local ok, err = run_test(name)
        if ok then
            TEST_RESULTS.passed += 1
        else
            TEST_RESULTS.failed += 1
            add(TEST_RESULTS.failures, {name=name, err=tostring(err)})
            printh("[TEST FAIL] "..name.." -> "..tostring(err), "log.txt")
        end
    end
    printh("tests finished: passed="..TEST_RESULTS.passed.." failed="..TEST_RESULTS.failed, "log.txt")
    -- keep TESTS_ACTIVE true so game updates are paused; caller may clear it to resume
    return TEST_RESULTS
end

-- draw helper to show a compact test summary when present
function tests_draw()
    if not TEST_RESULTS then return end
    local total = TEST_RESULTS.passed + TEST_RESULTS.failed
    print("tests: "..TEST_RESULTS.passed.."/"..total, 4, 4)
    if TEST_RESULTS.failed > 0 then
        for i=1,#TEST_RESULTS.failures do
            local f = TEST_RESULTS.failures[i]
            print("-"..f.name..":"..f.err, 4, 8 + (i-1)*6)
        end
    end
end

-- convenience loader: call this file with dofile then dofile other tests and run_tests()
printh("test harness loaded", "log.txt")
