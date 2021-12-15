#include "\z\ace\addons\main\script_macros.hpp"

#define ACE_PREFIX ace

#define ACE_FUNCMAIN(var1) TRIPLES(ACE_PREFIX,fnc,var1)
#define ACE_FUNC(var1,var2) TRIPLES(DOUBLES(ACE_PREFIX,var1),fnc,var2)
#define ACE_QFUNC(var1) QUOTE(ACE_FUNC(var1))
#define ACE_QFUNCMAIN(var1) QUOTE(ACE_FUNCMAIN(var1))
#define ACE_QQFUNC(var1,var2) QUOTE(ACE_FUNC(var1,var2))
#define ACE_QQFUNCMAIN(var1) QUOTE(ACE_FUNCMAIN(var1))

