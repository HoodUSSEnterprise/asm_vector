# asm_vector

一个使用 x64 NASM 汇编实现的高性能向量运算 C 语言库，适用于 Windows 平台。

## 功能

- **向量算术**：加法、减法、点积、叉积、标量乘法
- **动态数组操作**：尾部追加、弹出、按值删除
- **搜索**：按值查找元素、替换元素
- **汇编实现**：所有运算使用手写优化的 NASM 汇编（x64，win64 ABI）
- **C API**：基于 `MyVector` 结构体的简洁接口，包含 `int *data` 和 `size_t len`

## API 一览

| 函数                          | 说明                 |
| ----------------------------- | -------------------- |
| `add_vector(v1, v2)`          | 两个向量逐元素相加   |
| `sub_vector(v1, v2)`          | 两个向量逐元素相减   |
| `mul_vector_dot(v1, v2)`      | 两个向量的点积       |
| `mul_vector_cross(v1, v2)`    | 两个向量的叉积       |
| `scale_vector(v, s)`          | 向量所有元素乘以标量 |
| `push_back(v, val)`           | 在向量尾部追加元素   |
| `pop(v, &val)`                | 移除并返回尾部元素   |
| `remove_vector(v, val)`       | 移除第一个匹配的值   |
| `find_vector(v, val, &idx)`   | 查找值并返回索引     |
| `replace_vector(v, old, new)` | 替换第一个匹配的值   |
| `reverse_vector(v)`           | 颠倒向量             |

## 构建

### 前置依赖

- CMake >= 3.10
- NASM 汇编器（需加入 `PATH` 环境变量，命令名为 `nasm`）
- C 编译器（MSVC 或 MinGW）

### 构建步骤

```bash
mkdir build && cd build
cmake .. -G "Ninja"   # 或 "Visual Studio 17 2022"、"MinGW Makefiles" 等
cmake --build .
```

构建产物包括 `vector_lib`（静态库）和 `MyProject.exe`（示例程序）。

### 构建输出

- `vector_lib` — 包含所有汇编函数的静态库
- `MyProject` — 演示所有操作的示例可执行文件

## 平台

**仅支持 Windows x64。** NASM 汇编源文件针对 win64 ABI 编译（`-f win64`）。

> Linux 平台支持开发中，敬请期待。

## 许可证

MIT
