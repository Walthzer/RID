#include "script_component.hpp"

//inital Detection if player equips a detector
[{[ace_player] call ace_minedetector_fnc_hasDetector}, FUNC(activateRscDetector)] call CBA_fnc_waitUntilAndExecute;