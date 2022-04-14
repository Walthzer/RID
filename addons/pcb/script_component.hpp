#define COMPONENT pcb
#define COMPONENT_BEAUTIFIED Pcb
#include "\z\rid\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_PCB
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_PCB
    #define DEBUG_SETTINGS DEBUG_SETTINGS_PCB
#endif

#define CTRLOFFSET 100

#include "\z\rid\addons\main\script_macros.hpp"
