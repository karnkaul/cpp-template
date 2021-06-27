# C++17 CMake Project Template (Executable)

Sets up a minimalist C++17 CMake executable project with a few basic add-ons.

## Features

- Dotfiles
  - `.clang-format`
  - `.editorconfig`
  - `.appveyor.yml.in` (configured by CMake into `.appveyor.yml`)
  - `.gitignore`
  - `.gitattributes`
- CMake scripts:
  - `CMakeLists.txt`: project script, also sets up git commit hash / option to update submodules, `compile_commands.json` export, etc
  - `cmake/interface.cmake`: sets up interface library with compile flags etc
  - `cmake/platform.cmake` : sets cache variables for Windows/Linux platforms/compilers/etc (stateful)
  - `cmake/utils.cmake` : provides various utility functions (stateless)
  - `CMakePresets.json`: ninja/clang presets for maximum platform coverage
- Appveyor CI integration:
  - `.appveyor.yml` : runs a matrix build on Windows and Ubuntu

## Usage

1. Clone repo / use as template
1. Modify the `project parameters` section in `CMakeLists.txt`
   1. `project_name`: name to use for root project and prefix for interface library
   1. `project_version`: passed to `project()`
   1. `cxx_standard`: compile feature on interface library
1. Make any other changes if desired
1. Configure
   1. If using Ninja + clang and CMake 3.19+, use presets eg: `cmake -S . --preset=ninja-db` for `Debug`
1. Build and debug/run

[Original repository](https://github.com/karnkaul/cpp-template)

[LICENCE](LICENSE)
