#ifndef SCALE_VECTOR_H
#define SCALE_VECTOR_H

#include "myvector.h"

VectorInt *scale_vector_int(VectorInt *v, int scale);

VectorDouble *scale_vector_double(VectorDouble *v, double scale);
VectorFloat *scale_vector_float(VectorFloat *v, float scale);

#endif // SCALE_VECTOR_H