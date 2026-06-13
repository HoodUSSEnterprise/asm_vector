#include "vector.h"

int main(void)
{
    double *data = (double *)malloc(sizeof(double) * 3);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return 0;
    }
    double *data1 = (double *)malloc(sizeof(double) * 3);
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
    VectorDouble v1 = {data, 3};
    VectorDouble v2 = {data1, 3};
    puts("-------------------add vector-------------------");
    VectorDouble *v3 = add_vector_double(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%lf ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------sub vector-------------------");
    v3 = sub_vector_double(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%lf ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------mul vector-------------------");
    double val = mul_vector_double_dot(&v1, &v2);
    printf("val = %lf\n", val);
    putchar('\n');
    v3 = mul_vector_double_cross(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%lf ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("------------------scale vector------------------");
    v3 = scale_vector_double(&v1, 2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%lf ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("----------------push_back vector----------------");
    push_back_double(v3, 4);
    push_back_double(v3, 5);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%lf ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-------------------pop vector-------------------");
    double pop_value = 0;
    pop_double(v3, &pop_value);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%lf ", v3->data[i]);
    }
    putchar('\n');
    puts("------------------------------------------------");
    puts("-----------------remove vector------------------");
    double remove_val = 4;
    if (remove_vector_double(v3, remove_val))
    {
        printf("%zu\n", v3->len);
        for (size_t i = 0; i < v3->len; i++)
        {
            printf("%lf ", v3->data[i]);
        }
    }
    else
    {
        puts("No element remove");
    }
    putchar('\n');
    puts("------------------------------------------------");
    return 0;
}