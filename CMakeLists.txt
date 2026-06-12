cmake_minimum_required(VERSION 3.10)
project(MyProject)

enable_language(C ASM_NASM)

# 添加 NASM 配置
if(CMAKE_ASM_NASM_COMPILER)
    set(CMAKE_ASM_NASM_FLAGS "-f win64 -g")
endif()

# 设置编译选项
set(CMAKE_C_FLAGS_DEBUG "-g -O0 -Wall -Wextra")
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")

include_directories(include)

# 库的源文件（不含main）
set(LIB_SOURCES_VECTOR
    src/add_vector.asm
    src/find_vector.asm
    src/insert_vector.asm
    src/mul_vector.asm
    src/pop_vector.asm
    src/push_back_vector.asm
    src/remove_vector.asm
    src/replace_vector.asm
    src/reverse_vector.asm
    src/scale_vector.asm
    src/sub_vector.asm
)

# 创建库
add_library(vector_lib ${LIB_SOURCES_VECTOR})

target_include_directories(vector_lib PUBLIC include)

# 创建测试可执行文件
add_executable(MyProject example/main.c)
target_link_libraries(MyProject vector_lib)
# add_executable(MyProject src/main.c src/add_vector.asm)
