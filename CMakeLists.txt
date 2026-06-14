cmake_minimum_required(VERSION 3.10)
project(MyProject)

enable_language(C ASM_NASM)

# 根据平台选择不同的源文件目录
if(WIN32)
    set(PLATFORM_DIR "windows")
    set(CMAKE_ASM_NASM_FLAGS "-f win64 -g")
    set(EXTRA_LIBS "")  # Windows 特定库，如需要可添加
elseif(UNIX AND NOT APPLE)  # Linux
    set(PLATFORM_DIR "linux")
    set(CMAKE_ASM_NASM_FLAGS "-f elf64 -g")
    set(EXTRA_LIBS m pthread dl)  # Linux 特定库
else()
    message(FATAL_ERROR "Unsupported platform: Only Windows and Linux are supported")
endif()

message(STATUS "Building for platform: ${PLATFORM_DIR}")

# 设置编译选项
set(CMAKE_C_FLAGS_DEBUG "-g -O0 -Wall -Wextra")
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")

include_directories(include)

# 库的源文件（从对应平台目录读取）
set(LIB_SOURCES_VECTOR
    src/${PLATFORM_DIR}/add_vector.asm
#     src/${PLATFORM_DIR}/find_vector.asm
#     src/${PLATFORM_DIR}/insert_vector.asm
#     src/${PLATFORM_DIR}/mul_vector.asm
#     src/${PLATFORM_DIR}/pop_vector.asm
#     src/${PLATFORM_DIR}/push_back_vector.asm
#     src/${PLATFORM_DIR}/remove_vector.asm
#     src/${PLATFORM_DIR}/replace_vector.asm
#     src/${PLATFORM_DIR}/reverse_vector.asm
#     src/${PLATFORM_DIR}/scale_vector.asm
#     src/${PLATFORM_DIR}/sub_vector.asm
)

# 创建库
add_library(vector_lib ${LIB_SOURCES_VECTOR})

target_include_directories(vector_lib PUBLIC include)
target_link_libraries(vector_lib ${EXTRA_LIBS})

# 创建测试可执行文件
add_executable(MyProject example/main.c)
target_link_libraries(MyProject vector_lib)

# Float 版本
set(LIB_SOURCES_VECTOR_FLOAT
     src/${PLATFORM_DIR}/add_vector_float.asm
#     src/${PLATFORM_DIR}/find_vector_float.asm
#     src/${PLATFORM_DIR}/insert_vector_float.asm
#     src/${PLATFORM_DIR}/mul_vector_float.asm
#     src/${PLATFORM_DIR}/pop_vector_float.asm
#     src/${PLATFORM_DIR}/push_back_vector_float.asm
#     src/${PLATFORM_DIR}/remove_vector_float.asm
#     src/${PLATFORM_DIR}/replace_vector_float.asm
#     src/${PLATFORM_DIR}/reverse_vector_float.asm
#     src/${PLATFORM_DIR}/scale_vector_float.asm
#     src/${PLATFORM_DIR}/sub_vector_float.asm
)
# 
add_library(vector_float_lib ${LIB_SOURCES_VECTOR_FLOAT})
target_include_directories(vector_float_lib PUBLIC include)
target_link_libraries(vector_float_lib ${EXTRA_LIBS})
 
add_executable(vector_float example/vector_float.c)
target_link_libraries(vector_float vector_float_lib)
