#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"rid_main"};
        author = "";
        authors[] = {""};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgAmmo.hpp"
#include "CfgVehicles.hpp"
#include "CfgCloudlets.hpp"
#include "CfgSounds.hpp"


class rid_tripWireEffect {
    class SpawnFlare {
        simulation="particles";
        type="rid_tripWire_cloudLet";
        position="explosionPos";
    };
};

class CfgMineTriggers
{
	class WireTrigger;
	class rid_tripWire_base_trigger: WireTrigger
	{
	mineDelay=0;
	mineTriggerMass=5;
	mineTriggerRange=3;
	mineWireStart[]={0, 0, -0.5};
    mineWireEnd[]={0, 0, 0.5};
	};
};