#include "wrapper.h"
#include "loader.hpp"

#ifdef __cplusplus
extern "C" {
#endif

void init_extensions_c(void * ptr) {
    init_extensions(ptr);  // Call the C++ function
}

#ifdef __cplusplus
}
#endif
