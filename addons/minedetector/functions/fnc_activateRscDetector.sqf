#include "script_component.hpp"
20 cutRsc ["Rsc_rid_detector", "PLAIN"];

GVAR(RscDetector_enabledEH) = ["ace_minedetector_detectorEnabled", FUNC(enableRscDetector)] call CBA_fnc_addEventHandler;
GVAR(RscDetector_disabeldEH) = ["ace_minedetector_detectorDisabled", FUNC(disableRscDetector)] call CBA_fnc_addEventHandler;

//Remove display of RscDetector if detector is not primary weapon anymore:
[{!([ace_player] call ACE_FUNC(minedetector,hasDetector))}, FUNC(deactivateRscDetector)] call CBA_fnc_waitUntilAndExecute;