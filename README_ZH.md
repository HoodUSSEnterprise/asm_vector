# asm_vector

一个使用 x64 NASM 汇编手写优化实现的 C 语言高性能向量库，支持 **int**、**float** 和 **double** 三种数据类型，适用于 Windows 平台。

## 特性

- **三类型支持** — 每个运算均提供 `_int`、`_float`、`_double` 三种变体
- **向量算术** — 逐元素加减法、点积、叉积、标量乘法
- **动态数组操作** — 尾部追加、弹出、按值删除、指定位置插入
- **查找与替换** — 按值查找元素、替换元素、原地翻转
- **汇编实现** — 所有运算使用手写优化的 NASM 汇编（x64，win64 ABI），float/double 使用 SIMD 指令
- **C API** — 基于 `data` 指针 + `len` 的简洁结构体接口

## API 参考

| Int 函数                            | 返回值              | 说明                   |
|-------------------------------------|---------------------|------------------------|
| `add_vector_int(v1, v2)`            | `VectorInt *`       | 逐元素相加             |
| `sub_vector_int(v1, v2)`            | `VectorInt *`       | 逐元素相减             |
| `mul_vector_int_dot(v1, v2)`        | `int`               | 点积                   |
| `mul_vector_int_cross(v1, v2)`      | `VectorInt *`       | 叉积（3D 向量）        |
| `scale_vector_int(v, s)`            | `VectorInt *`       | 所有元素乘以标量       |
| `push_back_int(v, val)`             | `void`             | 尾部追加元素           |
| `pop_int(v, &val)`                  | `void`             | 移除并返回尾部元素     |
| `insert_vector_int(v, pos, val)`    | `bool`             | 指定位置插入元素       |
| `remove_vector_int(v, val)`         | `bool`             | 移除第一个匹配值       |
| `find_vector_int(v, val, &idx)`     | `bool`             | 查找值并写入索引       |
| `replace_vector_int(v, old, new)`   | `bool`             | 替换第一个匹配值       |
| `reverse_vector_int(v)`             | `void`             | 原地翻转               |

`_float` 和 `_double` 变体具有相同的函数签名（点积返回值类型对应为 `float` / `double`，其余为 `VectorFloat *` / `VectorDouble *`）。

### 数据类型

```c
typedef struct VectorInt {    int    *data; size_t len; } VectorInt;
typedef struct VectorFloat {  float  *data; size_t len; } VectorFloat;
typedef struct VectorDouble { double *data; size_t len; } VectorDouble;
```

## 构建

### 前置依赖

- CMake >= 3.10
- NASM 汇编器（需加入 `PATH` 环境变量，命令名为 `nasm`）
- C 编译器（MSVC 或 MinGW）

### 构建步骤

```bash
mkdir build && cd build
cmake .. -G "Ninja"           # 或 "Visual Studio 17 2022"、"MinGW Makefiles" 等
cmake --build .
```

### 构建目标

| 目标                 | 说明                              |
|----------------------|-----------------------------------|
| `vector_lib`         | 包含 `_int` 汇编例程的静态库      |
| `vector_lib_double`  | 包含 `_double` 汇编例程的静态库   |
| `vector_float_lib`   | 包含 `_float` 汇编例程的静态库    |
| `MyProject`          | `_int` 操作示例程序               |
| `vector_double`      | `_double` 操作示例程序            |
| `vector_float`       | `_float` 操作示例程序             |

## 示例

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

## 平台

**仅支持 Windows x64。** NASM 汇编源文件针对 win64 ABI 编译（`-f win64`）。

> Linux 平台支持开发中，敬请期待。

## 许可证

MIT
