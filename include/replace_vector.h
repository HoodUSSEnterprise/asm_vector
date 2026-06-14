#ifndef REPLACE_VECTOR_H
#define REPLACE_VECTOR_H

#include "myvector.h"

bool replace_vector_int(VectorInt *v, int old_elem, int new_elem);

bool replace_vector_double(VectorDouble *v, double old_elem, double new_elem);
bool replace_vector_float(VectorFloat *v, float old_elem, float new_elem);

#endif // REPLACE_VECTOR_H