# asm_vector

A high-performance C vector library with hand-optimized x64 NASM assembly implementations, supporting **int**, **float**, and **double** data types on Windows.

## Features

- **Triple type support** — each operation has `_int`, `_float`, and `_double` variants
- **Vector arithmetic** — element-wise addition, subtraction, dot product, cross product, scalar multiplication
- **Dynamic array ops** — push back, pop, remove by value, insert at position
- **Search & replace** — find element by value, replace element, reverse in-place
- **Assembly-powered** — all operations implemented in hand-optimized NASM (x64, win64 ABI) with SIMD instructions for float/double
- **C API** — simple struct interface (`data` pointer + `len`)

## API Reference

| Int Function                       | Returns               | Description                        |
|------------------------------------|-----------------------|------------------------------------|
| `add_vector_int(v1, v2)`           | `VectorInt *`         | Element-wise addition              |
| `sub_vector_int(v1, v2)`           | `VectorInt *`         | Element-wise subtraction           |
| `mul_vector_int_dot(v1, v2)`       | `int`                 | Dot product                        |
| `mul_vector_int_cross(v1, v2)`     | `VectorInt *`         | Cross product (3D vectors)         |
| `scale_vector_int(v, s)`           | `VectorInt *`         | Multiply all elements by scalar    |
| `push_back_int(v, val)`            | `void`                | Append element                     |
| `pop_int(v, &val)`                 | `void`                | Remove and retrieve last element   |
| `insert_vector_int(v, pos, val)`   | `bool`                | Insert element at position         |
| `remove_vector_int(v, val)`        | `bool`                | Remove first occurrence            |
| `find_vector_int(v, val, &idx)`    | `bool`                | Find value, write index            |
| `replace_vector_int(v, old, new)`  | `bool`                | Replace first occurrence           |
| `reverse_vector_int(v)`            | `void`                | Reverse in-place                   |

The same signatures apply for `_float` and `_double` variants (return types match: `float` / `double` for dot product, `VectorFloat *` / `VectorDouble *` for others).

### Data Types

```c
typedef struct VectorInt {    int    *data; size_t len; } VectorInt;
typedef struct VectorFloat {  float  *data; size_t len; } VectorFloat;
typedef struct VectorDouble { double *data; size_t len; } VectorDouble;
```

## Build

### Prerequisites

- CMake >= 3.10
- NASM assembler (in `PATH` as `nasm`)
- A C compiler (MSVC or MinGW)

### Build steps

```bash
mkdir build && cd build
cmake .. -G "Ninja"           # or "Visual Studio 17 2022", "MinGW Makefiles", etc.
cmake --build .
```

### Build targets

| Target                 | Description                                |
|------------------------|--------------------------------------------|
| `vector_lib`           | Static library with `_int` ASM routines    |
| `vector_lib_double`    | Static library with `_double` ASM routines |
| `vector_float_lib`     | Static library with `_float` ASM routines  |
| `MyProject`            | Example app for `_int` operations          |
| `vector_double`        | Example app for `_double` operations       |
| `vector_float`         | Example app for `_float` operations        |

## Example

```c
#include "vector.h"

int main(void) {
    int data[] = {1, 2, 3};
    VectorInt v1 = {data, 3};
    VectorInt v2 = {data, 3};

    VectorInt *sum = add_vector_int(&v1, &v2);   // {2, 4, 6}
    int dot = mul_vector_int_dot(&v1, &v2);      // 14
    VectorInt *cross = mul_vector_int_cross(&v1, &v2); // {-3, 6, -3}

    push_back_int(&v1, 4);                       // {1, 2, 3, 4}
    int popped;
    pop_int(&v1, &popped);                       // popped = 4

    int idx;
    find_vector_int(&v1, 2, &idx);               // idx = 1
    reverse_vector_int(&v1);                     // {3, 2, 1}
    return 0;
}
```

## Platform

**Windows x64 only.** The NASM source files target the win64 ABI (`-f win64`).

> Linux support is under development.

## License

MIT
