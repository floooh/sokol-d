// Use importC to import the C header files.
// Box3D holds simulation state, so `pure` is intentionally omitted.
#pragma attribute(push, nogc, nothrow) // dmdfrontend-2.111.x feature

#if defined(__clang__)
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#endif

#include <box3d/box3d.h>

#pragma attribute(pop)