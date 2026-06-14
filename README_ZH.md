# asm_vector

一个使用 x64 NASM 汇编手写优化实现的 C 语言高性能向量库，支持 **int**、**float** 和 **double** 三种数据类型，同时支持 **Windows (Win64 ABI)** 和 **Linux (System-V ABI)** 平台。

所有 11 种向量操作均直接使用手写 x64 汇编实现，不依赖 C 代码回退或编译器生成代码。

## 特性

- **三类型支持** — 每个运算均提供 `_int`、`_float`、`_double` 三种变体
- **向量算术** — 逐元素加减法、点积、3D 叉积、标量乘法
- **动态数组操作** — 尾部追加、弹出、按值删除、指定位置插入
- **查找与替换** — 按值查找元素、替换元素、原地翻转
- **纯汇编实现** — 所有运算使用手写优化的 NASM 汇编（x64），float/double 使用 SSE 标量指令
- **简洁 C API** — 基于 `data` 指针 + `len` 的扁平结构体接口
- **双平台支持** — Windows（win64 ABI，`rcx/rdx/r8` 传参）和 Linux（System-V ABI，`rdi/rsi/rdx` 传参）

## API 参考

### Int 函数

| 函数                               | 返回值              | 说明                          |
|------------------------------------|---------------------|-------------------------------|
| `add_vector_int(v1, v2)`           | `VectorInt *`       | 逐元素相加                    |
| `sub_vector_int(v1, v2)`           | `VectorInt *`       | 逐元素相减                    |
| `mul_vector_int_dot(v1, v2)`       | `int`               | 点积                          |
| `mul_vector_int_cross(v1, v2)`     | `VectorInt *`       | 叉积（仅限 3D 向量）          |
| `scale_vector_int(v, s)`           | `VectorInt *`       | 所有元素乘以标量              |
| `push_back_int(v, val)`            | `void`              | 尾部追加元素（自动 realloc）  |
| `pop_int(v, &val)`                 | `void`              | 移除并返回尾部元素            |
| `insert_vector_int(v, pos, val)`   | `bool`              | 指定位置插入元素              |
| `remove_vector_int(v, val)`        | `bool`              | 移除第一个匹配值              |
| `find_vector_int(v, val, &idx)`    | `bool`              | 查找值并写入索引              |
| `replace_vector_int(v, old, new)`  | `bool`              | 替换第一个匹配值              |
| `reverse_vector_int(v)`            | `void`              | 原地翻转                      |

`_float` 和 `_double` 变体具有相同的函数签名：
- 点积返回值类型对应为 `float` / `double`
- 叉积返回值类型对应为 `VectorFloat *` / `VectorDouble *`
- 其余函数签名与 int 版本一致，类型相应替换

### 数据类型

```c
typedef struct VectorInt {    int    *data; size_t len; } VectorInt;
typedef struct VectorFloat {  float  *data; size_t len; } VectorFloat;
typedef struct VectorDouble { double *data; size_t len; } VectorDouble;
```

## 内存模型

| 操作                              | 行为 |
|-----------------------------------|------|
| `add`、`sub`、`scale`、`cross`    | 分配并返回**新向量**，调用者须 `free()` 返回的 `data` |
| `push_back`、`pop`、`insert`、`remove`、`reverse`、`replace` | **原地修改**向量，可能 `realloc()` `data` 指针 |
| `find`                            | 只读操作，索引写入调用者提供的指针 |

### 错误处理

- **NULL 指针输入** → 返回 `NULL`（点积返回 `0x7FFFFFFF` / `INT_MAX` / `FLT_MAX` / `DBL_MAX`）
- **操作数长度不匹配** → 返回 `NULL`（点积返回错误哨兵值）
- **非 3D 向量求叉积** → 返回 `NULL`
- **`malloc` 失败** → 释放已分配的部分内存，返回 `NULL`
- **元素未找到**（find/remove/replace）→ 返回 `false`

## 项目结构

```
├── CMakeLists.txt          # 跨平台构建系统（Windows + Linux）
├── include/                # 公共 C 头文件（每个操作独立头文件）
│   ├── vector.h            # 聚合头文件（直接 include 此文件）
│   ├── myvector.h          # 结构体定义
│   ├── add_vector.h        # ...
│   └── ...
├── src/
│   ├── windows/            # Win64 ABI NASM 源码（33 个文件）
│   └── linux/              # System-V ABI NASM 源码（33 个文件）
├── example/
│   ├── main.c              # Int 类型测试程序
│   ├── vector_float.c      # Float 类型测试程序
│   └── vector_double.c     # Double 类型测试程序
└── scripts/
    ├── build.bat           # Windows 构建脚本（MinGW）
    └── build.sh            # Linux 构建脚本
```

## 构建

### 前置依赖

- **CMake** >= 3.10
- **NASM** 汇编器（需加入 `PATH` 环境变量，命令名为 `nasm`）
- **C 编译器**：MSVC 或 MinGW（Windows）、GCC 或 Clang（Linux）

### Windows 构建

```bash
mkdir build && cd build
cmake .. -G "Ninja"           # 或 "Visual Studio 17 2022"、"MinGW Makefiles"
cmake --build .
```

或使用便捷脚本：

```bash
scripts\build.bat
```

### Linux 构建

```bash
mkdir build && cd build
cmake .. -G "Unix Makefiles"
make
```

或使用便捷脚本：

```bash
chmod +x scripts/build.sh && ./scripts/build.sh
```

### 构建目标

| 目标                 | 说明                                |
|----------------------|-------------------------------------|
| `vector_lib`         | 静态库 — `_int` 汇编例程            |
| `vector_lib_double`  | 静态库 — `_double` 汇编例程         |
| `vector_float_lib`   | 静态库 — `_float` 汇编例程          |
| `MyProject`          | 示例程序 — `_int` 操作              |
| `vector_double`      | 示例程序 — `_double` 操作           |
| `vector_float`       | 示例程序 — `_float` 操作            |

每种类型独立编译为单独的静态库，按需链接即可。

## 示例

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

## 平台支持

| 平台       | ABI          | 传参寄存器          | 状态 |
|------------|--------------|---------------------|------|
| Windows    | Win64 (x64)  | `rcx`、`rdx`、`r8` | 已支持 |
| Linux      | System-V     | `rdi`、`rsi`、`rdx` | 已支持 |
| macOS      | —            | —                   | 暂不支持 |

> **注意：** float/double 操作使用 SSE 标量指令（`addss`/`addsd`、`mulss`/`mulsd` 等）。本库侧重于汇编语言教学演示，性能对标量 C 代码级别，并非手写 SIMD 向量化循环优化。

## 许可证

MIT
