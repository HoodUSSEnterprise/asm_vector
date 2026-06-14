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
# add_custom_command(TARGET MyProject POST_BUILD
#     COMMAND ${CMAKE_C_COMPILER} -S ${CMAKE_CURRENT_SOURCE_DIR}/example/main.c -I${CMAKE_CURRENT_SOURCE_DIR}/include -o ${CMAKE_CURRENT_BINARY_DIR}/main.s
# )

# 库的源文件（不含main）
set(LIB_SOURCES_VECTOR_DOUBLE
    src/add_vector_double.asm
    src/find_vector_double.asm
    src/insert_vector_double.asm
    src/mul_vector_double.asm
    src/pop_vector_double.asm
    src/push_back_vector_double.asm
    src/remove_vector_double.asm
    src/replace_vector_double.asm
    src/reverse_vector_double.asm
    src/scale_vector_double.asm
    src/sub_vector_double.asm
)

# 创建库
add_library(vector_lib_double ${LIB_SOURCES_VECTOR_DOUBLE})

target_include_directories(vector_lib_double PUBLIC include)

# 创建测试可执行文件
add_executable(vector_double example/vector_double.c)
target_link_libraries(vector_double vector_lib_double)
# 库的源文件（不含main）
set(LIB_SOURCES_VECTOR_FLOAT
    src/add_vector_float.asm
    src/find_vector_float.asm
    src/insert_vector_float.asm
    src/mul_vector_float.asm
    src/pop_vector_float.asm
    src/push_back_vector_float.asm
    src/remove_vector_float.asm
    src/replace_vector_float.asm
    src/reverse_vector_float.asm
    src/scale_vector_float.asm
    src/sub_vector_float.asm
)

# 创建库
add_library(vector_float_lib ${LIB_SOURCES_VECTOR_FLOAT})

target_include_directories(vector_float_lib PUBLIC include)

# 创建测试可执行文件
add_executable(vector_float example/vector_float.c)
target_link_libraries(vector_float vector_float_lib)
