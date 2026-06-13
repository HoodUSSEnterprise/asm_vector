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
    return 0;
}