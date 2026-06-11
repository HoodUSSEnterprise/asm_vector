# asm_vector

A C vector library with x64 NASM assembly implementations for high-performance vector operations on Windows.

## Features

- **Vector arithmetic**: addition, subtraction, dot product, cross product, scalar multiplication
- **Dynamic array ops**: push back, pop, remove by value
- **Search**: find element by value, replace element
- **Assembly-powered**: all operations implemented in hand-optimized NASM (x64, win64 ABI)
- **C API**: simple `MyVector` struct interface with `int *data` and `size_t len`

## API Overview

| Function                      | Description                             |
| ----------------------------- | --------------------------------------- |
| `add_vector(v1, v2)`          | Element-wise addition of two vectors    |
| `sub_vector(v1, v2)`          | Element-wise subtraction of two vectors |
| `mul_vector_dot(v1, v2)`      | Dot product of two vectors              |
| `mul_vector_cross(v1, v2)`    | Cross product of two vectors            |
| `scale_vector(v, s)`          | Multiply all elements by a scalar       |
| `push_back(v, val)`           | Append an element to the vector         |
| `pop(v, &val)`                | Remove and retrieve the last element    |
| `remove_vector(v, val)`       | Remove the first occurrence of a value  |
| `find_vector(v, val, &idx)`   | Find a value and store its index        |
| `replace_vector(v, old, new)` | Replace the first occurrence of a value |
| `reverse_vector(v)`           | Reverse the vector                      |

## Build

### Prerequisites

- CMake >= 3.10
- NASM assembler (in `PATH` as `nasm`)
- A C compiler (MSVC or MinGW)

### Build steps

```bash
mkdir build && cd build
cmake .. -G "Ninja"   # or "Visual Studio 17 2022", "MinGW Makefiles", etc.
cmake --build .
```

The build produces `vector_lib` (static library) and `MyProject.exe` (test example).

### Build outputs

- `vector_lib` — static library containing all assembly routines
- `MyProject` — example executable demonstrating all operations

## Platform

**Windows x64 only.** The NASM source files target the win64 ABI (`-f win64`).

> Linux support is under development.

## License

MIT
