# Guideliness for coding agent

Project-specific requirements always take precedence.

## General suggestions

* Prefer asking the user over deciding unilaterally, for anything uncertain.
* Keep the host system and user's home (i.e. things outside the project dir)
  clean. Ask the user first if you believe it is necessary to mutate persistent
  states outside the project scope. Explicit requests are an exception.
* Focus on correstness, simplicity, clarity and current best practices.
* Only make edits when explicitly asked to.
* Separate git commits logically, instead of stuffing everything into one.
* Prefer snake_case_names for functions and variables.


## Language-specific guidelines

### C++

* Write clean, modern C++. Prefer standard, portable solutions.
* Adhere to the C++ Core Guidelines when appropriate.
* Write generic, composable code, but do not be overly generic.
* Ownership and lifetimes should be carefully considered and designed.
  Make use of RAII.
* Be explicit about contracts: preconditions, postconditions, etc.

* Use CMake for project management. Prefer vcpkg for dependency management.
* Use the pitchfork layout (PFL) for structuring new projects.
* Prefer snake_case naming. Class names, template parameters and concepts can
  be PascalCase. Macros are NAMESPACED_UPPER_CASE.
* Use `.hpp` extension for header files that cannot be used as C headers. Use
  `.h` for headers compatible with C.

### C

C++ guidelines that are applicable to C shall also apply here.

* Be explicit about lifetimes and ownership. E.g.: Is this pointer in a struct
  managing a resource owned by the struct, which will be reponsible for cleaning
  it, or a non-owning reference? Write it down.

### Python

* Use `uv` for managing new projects.
