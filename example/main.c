#include "vector.h"

int main(void)
{
    int *data = (int *)malloc(sizeof(int) * 3);
    int *data1 = (int *)malloc(sizeof(int) * 3);
    for (int i = 0; i < 3; i++)
    {
        data[i] = i + 1;
        data1[i] = 4 - i;
    }
    MyVector v1 = {data, 3};
    MyVector v2 = {data1, 3};
    printf("-------------------add vector-------------------\n");
    MyVector *v3 = add_vector(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    printf("------------------------------------------------\n");
    printf("-------------------sub vector-------------------\n");
    v3 = sub_vector(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    printf("------------------------------------------------\n");
    printf("-------------------mul vector-------------------\n");
    int val = mul_vector(&v1, &v2);
    printf("val = %d\n", val);
    putchar('\n');
    v3 = mul_vector_cross(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    printf("------------------------------------------------\n");
    printf("------------------scale vector------------------\n");
    v3 = scale_vector(&v1, 2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    printf("------------------------------------------------\n");
    printf("----------------push_back vector----------------\n");
    push_pack(&v3, 4);
    push_pack(&v3, 5);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    printf("------------------------------------------------\n");
    printf("-------------------pop vector-------------------\n");
    int pop_value = 0;
    pop(&v3, &pop_value);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < v3->len; i++)
    {
        printf("%d ", v3->data[i]);
    }
    return 0;
}
