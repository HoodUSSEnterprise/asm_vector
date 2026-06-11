#ifndef MYVECTOR_H
#define MYVECTOR_H

#include <stdio.h>
#include <stdlib.h>

typedef struct MyVector
{
    int *data;
    size_t len;
} MyVector;

#endif // MYVECTOR_H