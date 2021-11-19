#include "script_component.hpp"

//inital Detection if player equips a detector
[{[ace_player] call ACE_FUNC(minedetector,hasDetector)}, FUNC(activateRscDetector)] call CBA_fnc_waitUntilAndExecute;