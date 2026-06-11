#include "vector.h"

int main(void)
{
    int *data = (int *)malloc(sizeof(int) * 3);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return 0;
    }
    int *data1 = (int *)malloc(sizeof(int) * 3);
    if (data1 == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return 0;
    }
    for (int i = 0; i < 3; i++)
    {
        data[i] = i + 1;
        data1[i] = 4 - i;
    }
    MyVector v1 = {data, 3};
    MyVector v2 = {data1, 3};
    puts("-------------------add vector-------------------");
    MyVector *v3 = add_vector(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------sub vector-------------------");
    v3 = sub_vector(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------mul vector-------------------");
    int val = mul_vector_dot(&v1, &v2);
    printf("val = %d\n", val);
    putchar('\n');
    v3 = mul_vector_cross(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("------------------scale vector------------------");
    v3 = scale_vector(&v1, 2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("----------------push_back vector----------------");
    push_back(v3, 4);
    push_back(v3, 5);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------pop vector-------------------");
    int pop_value = 0;
    pop(v3, &pop_value);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-----------------remove vector------------------");
    int remove_val = 4;
    if (remove_vector(v3, remove_val))
    {
        printf("%zu\n", v3->len);
        for (size_t i = 0; i < v3->len; i++)
        {
            printf("%d ", v3->data[i]);
        }
    }
    else
    {
        puts("No element remove");
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("------------------find vector-------------------");
    int find_val1 = 6;
    int find_val2 = 10;
    int idx = 0;
    if (find_vector(v3, find_val1, &idx))
    {
        printf("value %d index = %d\n", find_val1, idx);
    }
    else
    {
        printf("No find value %d\n", find_val1);
    }
    if (find_vector(v3, find_val2, &idx))
    {
        printf("value %d index = %d\n", find_val2, idx);
    }
    else
    {
        printf("No find value %d\n", find_val2);
    }
    puts("------------------------------------------------");
    puts("----------------replace vector------------------");
    for (int i = 0; i < 10; i++)
    {
        push_back(v3, i + 1);
    }
    puts("Before:");
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    int old_data = 6;
    int new_data = 9;
    puts("After");
    if (replace_vector(v3, old_data, new_data))
    {
        printf("%zu\n", v3->len);
        for (size_t i = 0; i < v3->len; i++)
        {
            printf("%d ", v3->data[i]);
        }
        putchar('\n');
    }
    else
    {
        printf("No find value %d\n", old_data);
    }
    return 0;
}
