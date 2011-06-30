#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

void test(double* x)
{
	Rprintf("x = %g\n", *x);
}


#define CDEF(name)  {#name, (DL_FUNC) &name, sizeof(name ## _t)/sizeof(name ## _t[0]), name ##_t}

static R_NativePrimitiveArgType test_t[] = {REALSXP};

static const R_CMethodDef CEntries[] = 
{
	CDEF(test),
    {NULL, NULL, 0}
};

void attribute_visible R_init_rmongo(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
	Rprintf("phooey\n");
}