#ifndef MUL_VECTOR_H
#define MUL_VECTOR_H

#include "myvector.h"

int mul_vector_int_dot(VectorInt *v1, VectorInt *v2);

VectorInt *mul_vector_int_cross(VectorInt *v1, VectorInt *v2);

double mul_vector_double_dot(VectorDouble *v1, VectorDouble *v2);

VectorDouble *mul_vector_double_cross(VectorDouble *v1, VectorDouble *v2);
float mul_vector_float_dot(VectorFloat *v1, VectorFloat *v2);

VectorFloat *mul_vector_float_cross(VectorFloat *v1, VectorFloat *v2);

#endif // MUL_VECTOR_H