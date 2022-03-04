#define COMPONENT eden
#define COMPONENT_BEAUTIFIED eden
#include "\z\rid\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_EDEN
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_EDEN
    #define DEBUG_SETTINGS DEBUG_SETTINGS_EDEN
#endif

#include "\z\rid\addons\main\script_macros.hpp"

// UI grid -> From ACE Zeus 
#define SIZEX ((safeZoneW / safeZoneH) min 1.2)
#define SIZEY (SIZEX / 1.2)
#define W_PART(num) (num * (SIZEX / 40))
#define H_PART(num) (num * (SIZEY / 25))
#define X_PART(num) (W_PART(num) + (safeZoneX + (safeZoneW - SIZEX) / 2))
#define Y_PART(num) (H_PART(num) + (safeZoneY + (safeZoneH - SIZEY) / 2))