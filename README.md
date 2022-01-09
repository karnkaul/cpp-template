# C++20 CMake Project Template (Executable)

Sets up a minimalist C++20 CMake executable project with a few basic add-ons.

<!-- Replace/remove this badge -->
[![Build Status](https://github.com/karnkaul/cpp-template/actions/workflows/ci.yml/badge.svg)](https://github.com/karnkaul/cpp-template/actions/workflows/ci.yml)

## Features

- Dotfiles
  - `.clang-format`
  - `.editorconfig`
  - `.gitignore`
  - `.gitattributes`
- CMake scripts:
  - `CMakeLists.txt`: project script, also sets up git commit hash / option to update submodules, `compile_commands.json` export, etc
  - `cmake/interface.cmake`: sets up interface library with compile flags etc
  - `cmake/build.cmake` : configures, builds, and installs a ninja/clang build using a desired build configuration
  - `cmake/CMakePresets.json`: ninja/clang and inherited presets (copy/symlink to project root to use)
  - `config.cmake.in`: package config file input
- GitHub CI integration:
  - `.github/workflows/ci.yml` : runs a matrix build on Windows and Ubuntu, invoking `cmake/build.cmake`

## Usage

1. Clone repo / use as template
1. Modify the `project parameters` section in `CMakeLists.txt`
   1. `project_name`: name to use for root project and prefix for interface library
   1. `${project_name}_version_file`: version file to configure (optional)
   1. `${project_name}_version`, `${project_name}_soversion`: used for versioning
   1. `cxx_standard`: compile feature on interface library
1. Make any other changes if desired
1. Configure
   1. If using Ninja + clang and CMake 3.20+, use presets eg: `cmake -S . --preset=nc-debug` for `Debug`
1. Build and debug/run

[Original repository](https://github.com/karnkaul/cpp-template)

[LICENCE](LICENSE)
