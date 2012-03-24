//visual leak detector will register itself as the first module to load.
#ifdef USE_VLD
#include <windows.h>
#include <vld.h>
#endif