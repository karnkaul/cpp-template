# C++17 CMake Project Template (Executable)

Sets up a minimalist C++17 CMake executable project with a few basic add-ons.

### Features
- Editor config support (use `.editorconfig.template` as an example)
- CMake tools:
	- `.tools/.cmake/platform.cmake` : sets cache variables for Windows/Linux platforms/compilers/etc (stateful)
	- `.tools/.cmake/utils.cmake` : provides various utility functions (stateless)
- Shell tools:
	- `.tools/os.sh` : (import script) sets up environment for other scripts to run on (including WSL with exe binaries)
	- `.tools/clang-format.sh` : runs clang-format on all source files
- Travis CI integration:
	- `.travis/` (Builds only, no tests)

[LICENCE](LICENSE)
