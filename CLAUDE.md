# Simalq Development Guide

## Build & Test Commands
- Install from source: `pip install .` or `pip install -e .` (development mode)
- Run the game: `python3 -m simalq`
- Start Tutorial Quest: `python3 -m simalq Tutorial_Quest`
- Run all tests: `pytest`
- Run single test: `pytest tests/test_file.hy::test_function_name`
- Use PyPy instead of CPython for better performance
- With Makefile:
  - `make run` - Run the game
  - `make test` - Run all tests
  - `make lint` - Check Hy syntax
  - `make clean` - Remove build artifacts

## Code Style Guidelines
- **Hy**: Use Lisp-style hyphenated-names, macros like `defdataclass` and `deftile`
  - Use `require` for importing macros, `import` for modules/functions
  - Test function prefix: `test_*` or `hyx_test_*`
  - Use test helpers like `assert-at`, `assert-hp` for assertions
- **Python**: PEP 8 style for Python code
  - Imports: standard lib → third-party → local modules
  - Error handling: use try/except with specific exceptions
  - Naming: snake_case for functions/variables, PascalCase for classes
- **Documentation**: Use comments with Outli headers for code organization
- **Git**: Conventional Commits style
  - Format: `<type>(<scope>): <description>`
  - Example: `feat(monsters): implement dragons behavior`
  - Use trailers instead of inline attribution for co-authorship
  - Example:
    ```
    feat(tiles): add new scenery tiles for Tutorial Quest

    This adds two new scenery tile types with proper
    movement blocking and visibility attributes.

    Co-authored-by: Claude <noreply@anthropic.com>
    Reviewed-by: jwalsh
    ```

## Project Structure
- `simalq/`: Main game code
- `simalq/tile/`: Game tile definitions
- `simalq/quest_definition/`: Quest definitions
- `tests/`: Test suite with Hy test files
- `util/`: Utility scripts
- Create new quests by duplicating `tutorial.hy` in quest_definition/