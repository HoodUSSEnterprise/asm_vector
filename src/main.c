#include "add_vector.h"
#include "mul_vector.h"

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
    printf("Before add_vector\n");
    MyVector *v3 = add_vector(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    putchar('\n');
    v3 = mul_vector_cross(&v1, &v2);
    printf("%zu\n", v3->len);
    for (size_t i = 0; i < 3; i++)
    {
        printf("%d ", v3->data[i]);
    }
    return 0;
}
