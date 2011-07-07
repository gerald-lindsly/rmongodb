#include "api.h"

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>


#define CDEF(name)  {"mongo." #name, (DL_FUNC) &name, sizeof(name ## _t)/sizeof(name ## _t[0]), name ##_t}

static R_NativePrimitiveArgType sock_connect_t[] = {INTSXP, STRSXP};
static R_NativePrimitiveArgType sock_close_t[] = {INTSXP};

static const R_CMethodDef CEntries[] = 
{
	CDEF(sock_connect),
	CDEF(sock_close),
    {NULL, NULL, 0}
};

void attribute_visible R_init_rmongo(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
}