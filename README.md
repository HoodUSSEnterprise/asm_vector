# asm_vector

A high-performance C vector library with NASM assembly implementations for **int**, **float**, and **double** data types. Supports both **Windows (Win64 ABI)** and **Linux (System-V ABI)**.

All 11 vector operations are implemented directly in hand-written x64 assembly — no C fallback, no compiler-generated code.

## Features

- **Triple type support** — each operation has `_int`, `_float`, and `_double` variants
- **Vector arithmetic** — element-wise addition/subtraction, dot product, 3D cross product, scalar multiplication
- **Dynamic array ops** — push back, pop, remove by value, insert at position
- **Search & replace** — find element by value, replace element, reverse in-place
- **Pure assembly** — all operations implemented in hand-optimized NASM (x64) with SSE scalar instructions for float/double
- **Simple C API** — flat struct with `data` pointer + `len`
- **Dual platform** — Windows (win64, `rcx/rdx/r8`) and Linux (System-V, `rdi/rsi/rdx`)

## API Reference

### Int Functions

| Function                           | Returns               | Description                      |
|------------------------------------|-----------------------|----------------------------------|
| `add_vector_int(v1, v2)`           | `VectorInt *`         | Element-wise addition            |
| `sub_vector_int(v1, v2)`           | `VectorInt *`         | Element-wise subtraction         |
| `mul_vector_int_dot(v1, v2)`       | `int`                 | Dot product                      |
| `mul_vector_int_cross(v1, v2)`     | `VectorInt *`         | Cross product (3D vectors only)  |
| `scale_vector_int(v, s)`           | `VectorInt *`         | Multiply all elements by scalar  |
| `push_back_int(v, val)`            | `void`                | Append element (realloc)         |
| `pop_int(v, &val)`                 | `void`                | Remove and retrieve last element  |
| `insert_vector_int(v, pos, val)`   | `bool`                | Insert element at position       |
| `remove_vector_int(v, val)`        | `bool`                | Remove first occurrence          |
| `find_vector_int(v, val, &idx)`    | `bool`                | Find value, write index          |
| `replace_vector_int(v, old, new)`  | `bool`                | Replace first occurrence         |
| `reverse_vector_int(v)`            | `void`                | Reverse in-place                 |

The same function signatures apply for `_float` and `_double` variants:
- Dot product returns `float` / `double` respectively
- Cross product returns `VectorFloat *` / `VectorDouble *`
- All others mirror the int signatures with matching types

### Data Types

```c
typedef struct VectorInt {    int    *data; size_t len; } VectorInt;
typedef struct VectorFloat {  float  *data; size_t len; } VectorFloat;
typedef struct VectorDouble { double *data; size_t len; } VectorDouble;
```

## Memory Model

| Operation     | Behavior |
|---------------|----------|
| `add`, `sub`, `scale`, `cross` | Allocate and return a **new** vector. Caller must `free()` the returned `data`. |
| `push_back`, `pop`, `insert`, `remove`, `reverse`, `replace` | Operate **in-place** on the vector. May `realloc()` the `data` pointer. |
| `find` | Read-only. Index written to caller-provided pointer. |

### Error Handling

- **NULL input pointers** → returns `NULL` (or `0x7FFFFFFF` / `INT_MAX` / `FLT_MAX` / `DBL_MAX` for dot product)
- **Length mismatch** between operands → returns `NULL` (or the error sentinel for dot product)
- **Cross product on non-3D** → returns `NULL`
- **`malloc` failure** → frees any partial allocation, returns `NULL`
- **Element not found** (find/remove/replace) → returns `false`

## Project Structure

```
├── CMakeLists.txt          # Cross-platform build (Windows + Linux)
├── include/                # Public C headers (one per operation)
│   ├── vector.h            # Aggregate header (include this)
│   ├── myvector.h          # Struct definitions
│   ├── add_vector.h        # ...
│   └── ...
├── src/
│   ├── windows/            # Win64 ABI NASM source (33 files)
│   └── linux/              # System-V ABI NASM source (33 files)
├── example/
│   ├── main.c              # Int test app
│   ├── vector_float.c      # Float test app
│   └── vector_double.c     # Double test app
└── scripts/
    ├── build.bat           # Windows build script (MinGW)
    └── build.sh            # Linux build script
```

## Build

### Prerequisites

- **CMake** >= 3.10
- **NASM** assembler (in `PATH` as `nasm`)
- **C compiler**: MSVC / MinGW (Windows), GCC / Clang (Linux)

### Build (Windows)

```bash
mkdir build && cd build
cmake .. -G "Ninja"           # or "Visual Studio 17 2022", "MinGW Makefiles"
cmake --build .
```

Or use the convenience script:

```bash
scripts\build.bat
```

### Build (Linux)

```bash
mkdir build && cd build
cmake .. -G "Unix Makefiles"
make
```

Or use the convenience script:

```bash
chmod +x scripts/build.sh && ./scripts/build.sh
```

### Build Targets

| Target                 | Description                              |
|------------------------|------------------------------------------|
| `vector_lib`           | Static library — `_int` ASM routines     |
| `vector_lib_double`    | Static library — `_double` ASM routines  |
| `vector_float_lib`     | Static library — `_float` ASM routines   |
| `MyProject`            | Example app — `_int` operations          |
| `vector_double`        | Example app — `_double` operations       |
| `vector_float`         | Example app — `_float` operations        |

Each type is compiled into a separate static library. Link the one you need (or all three).

## Example

```c
#include "vector.h"

int main(void) {
    int data[] = {1, 2, 3};
    VectorInt v1 = {data, 3};
    VectorInt v2 = {data, 3};

    VectorInt *sum  = add_vector_int(&v1, &v2);      // {2, 4, 6}
    int dot         = mul_vector_int_dot(&v1, &v2);  // 14
    VectorInt *cross = mul_vector_int_cross(&v1, &v2); // {-3, 6, -3}

    push_back_int(&v1, 4);                          // {1, 2, 3, 4}
    int popped;
    pop_int(&v1, &popped);                          // popped = 4

    int idx;
    find_vector_int(&v1, 2, &idx);                  // idx = 1
    reverse_vector_int(&v1);                        // {3, 2, 1}

    free(sum->data); free(sum);
    free(cross->data); free(cross);
    return 0;
}
```

## Platform

| Platform   | ABI          | Registers          | Status |
|------------|--------------|--------------------|--------|
| Windows    | Win64 (x64)  | `rcx`, `rdx`, `r8` | Supported |
| Linux      | System-V     | `rdi`, `rsi`, `rdx` | Supported |
| macOS      | —            | —                  | Not planned |

> **Note:** Float/double operations use SSE scalar instructions (`addss`/`addsd`, `mulss`/`mulsd`, etc.). This is a pedagogical assembly library; performance matches scalar C, not hand-vectorized SIMD loops.

## License

MIT
