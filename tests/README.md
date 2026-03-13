# Tests for pacclone (Pico-8)

This folder contains a small in-cart test harness and unit tests you can run from the Pico-8 console.

Files
- `test_harness.lua` — test runner, assertions, and helpers
- `test_vec.lua`, `test_util.lua`, `test_pathfinding.lua`, `test_enemy.lua` — example tests
- `loader.lua` — convenience loader that `dofile`s the harness and all tests

Quick start (REPL/manual)
1. Tests are included into the cartridge via `#include` (they are already added to the cart). After loading the cartridge, simply run:
```lua
run_tests()
```
3. Show a compact on-screen summary (call from `_draw()` or manually each frame):
```lua
tests_draw()
```

Run a single test
```lua
run_test("vec_floor")
```

Notes and controls
- Test results are written to `log.txt` via `printh` and also collected in the global `TEST_RESULTS` table.
- To inspect failures in the REPL after `run_tests()`:
```lua
print(TEST_RESULTS.passed, TEST_RESULTS.failed)
for i=1,#TEST_RESULTS.failures do print(TEST_RESULTS.failures[i].name, TEST_RESULTS.failures[i].err) end
```
- Coroutine-based tests: the harness provides `step_coroutines_for(entity, max_frames)` to advance movement coroutines used by `create_enemy()`.
- Many game modules expect a global `g`. Use `with_g(overrides, fn)` in tests to run code with a temporary shallow `g` mock.
- Randomness: `determine_sprite` and other functions use `rnd()` — seed determinism with `srand()` or stub `rnd` if you need deterministic outputs.

Adding tests
- Create a new file `tests/test_myfeature.lua`.
- Call `register_test("mytestname", function() ... end)` to add tests.
- Prefer `with_g(...)` to isolate global `g` changes and `printh` for logging.

Auto-run at start (optional)
- To auto-run tests on cart start, add `#include` directives for the test files in `pacclone.p8` (already done), then in `_init()` call:
```lua
run_tests()
```

Troubleshooting
- If a test fails and raises an error, details will be in `log.txt` and `TEST_RESULTS.failures`.
- Some tests stub or replace globals (e.g., `find_first_open`) — ensure test code restores originals if you edit tests manually.

If you want, I can add: (A) deterministic seeds for random tests, (B) an `_init()` auto-run option, or (C) more coroutine-stepped assertions for enemy movement.
