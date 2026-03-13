-- When running on Pico-8, tests are included into the cartridge via `#include`.
-- To run tests from the cart console call `run_tests()` once the cartridge is loaded.
TESTS_LOADER = true
printh("tests available: "..(#TEST_ORDER or 0), "log.txt")
