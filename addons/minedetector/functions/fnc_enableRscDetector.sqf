#include "script_component.hpp"
//Turn screen to ON and flash all indicators
params["_unit", "_detectorType"];

private _detectorConfig = [_detectorType] call ace_minedetector_getDetectorConfig;
_unit setVariable [QGVAR(detectorType), _detectorType];

private _display = uiNamespace getVariable[QGVAR(displayRscDetector), displayNull];
if (isNull _display) exitwith {ERROR_MSG("Is not display")};

//Turn screen on:
(_display displayCtrl 231001) ctrlSetText QPATHTOF(ui\Screen_ON.paa);

//Flash all indicators:
_display spawn {
    [_this, 1] call FUNC(toggleRscDetector);
    sleep 0.1;
    [_this, 0] call FUNC(toggleRscDetector);
    [_this] call FUNC(screenInitRscDetector);
};

//Allow the creation of a RscDetector reset after a timeout:
GVAR(canCreateTimeoutResetRscDetector) = true;

//minedetected EH:
GVAR(RscDetector_mindeDetectedEH) = ["ace_minedetector_mineDetected", FUNC(objectDetected)] call CBA_fnc_addEventHandler;
