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

typedef struct VectorFloat
{
    float *data;
    size_t len;
} VectorFloat;

typedef struct VectorDouble
{
    double *data;
    size_t len;
} VectorDouble;

#endif // MYVECTOR_H