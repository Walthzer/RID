#include "script_component.hpp"
//Turn screen to ON and flash all indicators
params["_unit", "_detectorType"];

private _detectorConfig = [_detectorType] call ace_minedetector_getDetectorConfig;
_unit setVariable ["rid_detectorType", _detectorType];
private _display = uiNamespace getVariable GVAR(displayRscDetector);

if (isNull _display) exitwith {diag_log "Is not display"};

//Turn screen on:
(_display displayCtrl 231001) ctrlSetText "MD_WD\Screen_ON.paa";

//Flash all indicators:
[_display] spawn {
    params["_display"];
    [_display, 1] call FUNC(toggleRscDetector);
    sleep 0.1;
    [_display, 0] call FUNC(toggleRscDetector);
    [_display] call FUNC(screenInitRscDetector);
};

//Allow the creation of a RscDetector reset after a timeout:
GVAR(canCreateTimeoutResetRscDetector) = true;

//minedetected EH:
GVAR(RscDetector_mindeDetectedEH) = ["ace_minedetector_mineDetected", FUNC(objectDetected)] call CBA_fnc_addEventHandler;
