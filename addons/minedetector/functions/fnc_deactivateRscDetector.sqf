#include "script_component.hpp"
20 cutText ["", "PLAIN"]; 

["ace_minedetector_mineDetected", GVAR(RscDetector_mindeDetectedEH)] call CBA_fnc_removeEventHandler;
["ace_minedetector_detectorEnabled", GVAR(RscDetector_enabledEH)] call CBA_fnc_removeEventHandler;
["ace_minedetector_detectorDisabled", GVAR(RscDetector_disabeldEH)] call CBA_fnc_removeEventHandler;

//Setup display of RscDetector if detector is equipped:
[{[ace_player] call ACE_FUNC(minedetector,hasDetector)}, FUNC(activateRscDetector)] call CBA_fnc_waitUntilAndExecute;