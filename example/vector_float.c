#include "vector.h"

int main(void)
{
    float *data = (float *)malloc(sizeof(float) * 3);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return 0;
    }
    float *data1 = (float *)malloc(sizeof(float) * 3);
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
    VectorFloat v1 = {data, 3};
    VectorFloat v2 = {data1, 3};
    puts("-------------------add vector-------------------");
    VectorFloat *v3 = add_vector_float(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%f ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------sub vector-------------------");
    v3 = sub_vector_float(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%f ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------mul vector-------------------");
    float val = mul_vector_float_dot(&v1, &v2);
    printf("val = %f\n", val);
    putchar('\n');
    v3 = mul_vector_float_cross(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%f ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("------------------scale vector------------------");
    v3 = scale_vector_float(&v1, 2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%f ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("----------------push_back vector----------------");
    push_back_float(v3, 4);
    push_back_float(v3, 5);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%f ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------pop vector-------------------");
    float pop_value = 0;
    pop_float(v3, &pop_value);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%f ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-----------------remove vector------------------");
    float remove_val = 4;
    if (remove_vector_float(v3, remove_val))
    {
        printf("%zu\n", v3->len);
        for (size_t i = 0; i < v3->len; i++)
        {
            printf("%f ", v3->data[i]);
        }
    }
    else
    {
        puts("No element remove");
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("------------------find vector-------------------");
    float find_val1 = 6;
    float find_val2 = 10;
    int idx = 0;
    if (find_vector_float(v3, find_val1, &idx))
    {
        printf("value %f index = %d\n", find_val1, idx);
    }
    else
    {
        printf("No find value %f\n", find_val1);
    }
    if (find_vector_float(v3, find_val2, &idx))
    {
        printf("value %f index = %d\n", find_val2, idx);
    }
    else
    {
        printf("No find value %f\n", find_val2);
    }
    puts("------------------------------------------------");
    //     puts("----------------replace vector------------------");
    //     for (int i = 0; i < 10; i++)
    //     {
    //         push_back_float(v3, i + 1);
    //     }
    //     puts("Before:");
    //     printf("%zu\n", v3->len);
    //     for (size_t i = 0; i < v3->len; i++)
    //     {
    //         printf("%f ", v3->data[i]);
    //     }
    //     putchar('\n');
    //     float old_data = 6;
    //     int new_data = 9;
    //     puts("After");
    //     if (replace_vector_float(v3, old_data, new_data))
    //     {
    //         printf("%zu\n", v3->len);
    //         for (size_t i = 0; i < v3->len; i++)
    //         {
    //             printf("%f ", v3->data[i]);
    //         }
    //         putchar('\n');
    //     }
    //     else
    //     {
    //         printf("No find value %f\n", old_data);
    //     }
    //     puts("------------------------------------------------");
    //     puts("----------------reverse vector------------------");
    //     reverse_vector_float(v3);
    //     printf("%zu\n", v3->len);
    //     for (size_t i = 0; i < v3->len; i++)
    //     {
    //         printf("%f ", v3->data[i]);
    //     }
    //     putchar('\n');
    //     puts("------------------------------------------------");
    //     puts("-----------------insert vector------------------");
    //     size_t insert_pos = 2;
    //     // printf("insert_vector: v=%p, v->data=%p, v->len=%zu, pos=%zu\n",
    //     //        v3, v3->data, v3->len, insert_pos);
    //     if (insert_vector_float(v3, insert_pos, 4))
    //     {
    //         printf("%zu\n", v3->len);
    //         for (size_t i = 0; i < v3->len; i++)
    //         {
    //             printf("%f ", v3->data[i]);
    //         }
    //         putchar('\n');
    //     }
    //     else
    //     {
    //         puts("Error insert");
    //    }
    return 0;
}
