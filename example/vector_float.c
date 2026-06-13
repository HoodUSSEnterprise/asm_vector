#include "vector.h"

int main(void)
{
    float *data = (float *)malloc(sizeof(int) * 3);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return 0;
    }
    float *data1 = (float *)malloc(sizeof(int) * 3);
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
    return 0;
}
