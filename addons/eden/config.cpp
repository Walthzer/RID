#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {QGVAR(iedModule)};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"rid_main", "3DEN"};
        is3DENmod = 1;
        author = "";
        authors[] = {"Walthzer/Shark"};
        VERSION_CONFIG;
    };
}; 

#include "RscAttributes.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgEden.hpp"
#include "Display3DEN.hpp"
#include "CfgVehicles.hpp"
