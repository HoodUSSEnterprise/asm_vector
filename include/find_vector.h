#ifndef FIND_VECTOR_H
#define FIND_VECTOR_H

#include "myvector.h"

bool find_vector_int(VectorInt *v, int elem, int *index);

bool find_vector_double(VectorDouble *v, double elem, int *index);
bool find_vector_float(VectorFloat *v, float elem, int *index);

#endif // FIND_VECTOR_H