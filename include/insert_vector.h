#ifndef INSERT_VECTOR_H
#define INSERT_VECTOR_H

#include "myvector.h"

bool insert_vector_int(VectorInt *v, size_t pos, int value);

bool insert_vector_float(VectorFloat *v, size_t pos, float value);

bool insert_vector_double(VectorDouble *v, size_t pos, double value);

#endif // INSERT_VECTOR_H