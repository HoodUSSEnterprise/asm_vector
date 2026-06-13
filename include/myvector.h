#ifndef MYVECTOR_H
#define MYVECTOR_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct VectorInt
{
    int *data;
    size_t len;
} VectorInt;

#endif // MYVECTOR_H