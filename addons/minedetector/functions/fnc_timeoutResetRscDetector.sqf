#include "script_component.hpp"
if (CBA_missionTime - GVAR(timeOfLastDetect) > 0.05) then {
    GVAR(canCreateTimeoutResetRscDetector) = true;
    private _display = uiNamespace getVariable[QGVAR(displayRscDetector), displayNull];
    if (isNull _display) exitwith {};
    {
        for "_i" from 1 to 8 do {
            private _alpha = if (_i <= _x) then {1} else {0};
            _screenIdc = parseNumber("231" + str(1+_forEachIndex) + "0" + str (_i-1));
            _sideIdc = parseNumber("231" + str(6+_forEachIndex) + "0" + str _i);
            (_display displayCtrl _screenIdc) ctrlSetTextColor [1, 1, 1, _alpha];
            (_display displayCtrl _sideIdc) ctrlSetTextColor [1, 1, 1, _alpha];
        };  
    } forEach [0,0];
} else {
    [FUNC(timeoutResetRscDetector), [], 0.06] call CBA_fnc_waitAndExecute;
};

